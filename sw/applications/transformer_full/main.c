//
// Created by alireza on 10/6/23.
//

#include <stdio.h>
#include <math.h>
#include "transformer.h"
#include "data_cpp/signal.cpp"
#include "data_cpp/signal_fft.cpp"
#include "SYLT-FFT/fft.h"
#include "weightsAndBiasesC.h"
#include "transformerBlockC.h"

// For the cgra
#include "csr.h"
#include "handler.h"
#include "rv_plic.h"
#include "rv_plic_regs.h"
#include "hart.h"
#include "cgra_bitstream.h"
#include "cgra_x_heep.h"
#include "cgra.h"

// For the timers   
#include "rv_timer.h"
#include "soc_ctrl.h"
#include "core_v_mini_mcu.h"

// FFT
#include "stftVec.h"

#define HART_ID 0

// CGRA variables
static cgra_t cgra;
static uint8_t cgra_slot;

// Timer
static rv_timer_t timer;
static uint32_t freq_hz;

float error_check(const quant_bit_width* groundTruth, const quant_bit_width* output, size_t length){
    long error = 0;
    for (int i=0; i<length; i++){
        error += MUL_HQ(groundTruth[i] - output[i], groundTruth[i] - output[i]);
    }
    error = (error >> NUM_FRACTION_BITS);
    return (float) error/ (float) length;
}

void prototype_distances(quant_bit_width* prototypeVec, const quant_bit_width* modelOutput, int32_t* distVec, size_t prototypeLength, int prototypeNums){
    for (int p=0; p< prototypeNums; p++){
        long dist = 0;
        quant_bit_width * prototypePtr = prototypeVec + (p * prototypeLength);
        for (int i=0; i<prototypeLength; i++){
            dist += MUL_HQ(prototypePtr[i] - modelOutput[i], prototypePtr[i] - modelOutput[i]);
        }
        dist = (dist >> NUM_FRACTION_BITS);
        distVec[p] = (int32_t) dist;
    }
}

void transformerInference(quant_bit_width * transformerInput, quant_bit_width * transformerOutput, quant_bit_width* input_normalized, quant_bit_width* qkv, quant_bit_width* intermediate){
    quant_bit_width * weightVec[NUM_LAYERS*(3*NUM_HEAD+5)+5];
    quant_bit_width * biasVec[NUM_LAYERS*(3*NUM_HEAD+5)+5];
    getWeights(weightVec);
    getBiases(biasVec);
    quant_bit_width * clsTokenVector = getClassToken();
    quant_bit_width * posMatrix = getPosEmbedding();
    TransformerBlock* selfatten = createTransformerBlock(D_SEQ, D_MODEL, D_Q, NUM_HEAD, D_FF, weightVec, biasVec, clsTokenVector, posMatrix);
    computeFixedPoint(selfatten, D_SEQ, transformerInput, input_normalized, transformerOutput, intermediate, qkv, &cgra, cgra_slot);
}

quant_bit_width compute_log_amp(int32_t real, int32_t imag){
    real = MUL_HQ(real, 25) >> (NUM_FRACTION_BITS - 9);
    imag = MUL_HQ(imag, 25) >> (NUM_FRACTION_BITS - 9);
    int32_t real2 = MUL_LONG(real, real) >> NUM_FRACTION_BITS;
    int32_t imag2 = MUL_LONG(imag, imag) >> NUM_FRACTION_BITS;
    float pow2 = (float)(real2 + imag2) / (float) (1<< NUM_FRACTION_BITS);
    float amp = sqrtf(pow2);
    float stft = logf(amp+ 1e-10f);
    quant_bit_width stft_int = (quant_bit_width) (stft * (1<<NUM_FRACTION_BITS));
    return stft_int;
}

void initialize_stft(fft_complex_t* data, const quant_bit_width * raw_input_signal){
    // Initialize each element of the data array
    for (int i = 0; i < 256; i++) {
        data[i].r = (MUL_HQ(raw_input_signal[i], hanning[i])) ;
        data[i].i = 0;
    }
    for (int i = 256; i < 512; i++) {
        data[i].r = 0;
        data[i].i = 0;
    }
}

void stft_rearrange(quant_bit_width* rawInputSignal, quant_bit_width* stftVec, size_t patchHeight, size_t patchWidth){
    fft_complex_t data[512];
    int overlap = 64;
    for (int ch=0; ch<20; ch++){
        for (int time_step=0; time_step<15; time_step++){
            quant_bit_width* rawSignalPtr = rawInputSignal + ch * 3072 + (256 - overlap) * time_step;
            initialize_stft(data, rawSignalPtr);
            fft_fft(data, 9);
            quant_bit_width * stftVecPtr = stftVec + ch * 15 * 160 + (time_step / patchWidth) * patchWidth * patchHeight + (time_step % patchWidth);
            for (int index =0 ; index < patchHeight; index++){
                int16_t stft_int = compute_log_amp(data[index].r, data[index].i);
                *stftVecPtr = (int32_t) stft_int;
                stftVecPtr += patchWidth;
            }
            stftVecPtr += patchHeight * patchWidth * 2;
            for (int index = patchHeight ; index < 2*patchHeight; index++){
                int16_t stft_int = compute_log_amp(data[index].r, data[index].i);
                *stftVecPtr = (int32_t) stft_int;
                stftVecPtr += patchWidth;
            }
        }
    }
}

// Interrupt controller variables
void handler_irq_cgra(uint32_t id) {
  cgra_intr_flag = 1;
  
}

// Initialize the CGRA
void initCGRA(){
  // Init the PLIC
  plic_Init();
  plic_irq_set_priority(CGRA_INTR, 1);
  plic_irq_set_enabled(CGRA_INTR, kPlicToggleEnabled);
  plic_assign_external_irq_handler( CGRA_INTR, (void *) &handler_irq_cgra);

  // Enable interrupt on processor side
  // Enable global interrupt for machine-level interrupts
  CSR_SET_BITS(CSR_REG_MSTATUS, 0x8);
  // Set mie.MEIE bit to one to enable machine-level external interrupts
  const uint32_t mask = 1 << 11;//IRQ_EXT_ENABLE_OFFSET;
  CSR_SET_BITS(CSR_REG_MIE, mask);
  
  // Load kernel
  cgra_cmem_init(cgra_imem_bitstream, cgra_kmem_bitstream);

  cgra.base_addr = mmio_region_from_addr((uintptr_t)CGRA_PERIPH_START_ADDRESS);
  // Select request slot of CGRA
  cgra_slot = cgra_get_slot(&cgra);
}

void timerInit()
{
    soc_ctrl_t soc_ctrl;
    soc_ctrl.base_addr  = mmio_region_from_addr((uintptr_t)SOC_CTRL_START_ADDRESS);
    freq_hz             = soc_ctrl_get_frequency(&soc_ctrl);

    mmio_region_t timer_0_reg = mmio_region_from_addr(RV_TIMER_AO_START_ADDRESS);

    rv_timer_init( timer_0_reg, (rv_timer_config_t) { .hart_count = 2, .comparator_count = 1 }, &timer );

    rv_timer_tick_params_t tick_params;

    // The same frequency is provaided to get one tick per cycle.
    rv_timer_approximate_tick_params( freq_hz, freq_hz, &tick_params );
    rv_timer_set_tick_params(&timer, HART_ID, tick_params);

    // Juan: see if i cannot remove this!
    rv_timer_irq_enable(&timer, HART_ID, 0, kRvTimerEnabled);
    rv_timer_arm(&timer, HART_ID, 0, 1);

    rv_timer_counter_set_enabled(&timer, HART_ID, kRvTimerEnabled);

}

int main() {
    printf("\rIni timer\n");
    // CGRA
    // Init timer
    timerInit();
    printf("\rIni cgra\n");
    // Enable and reset the CGRA performance counters
    cgra_perf_cnt_enable(&cgra, 1);
    cgra_perf_cnt_reset( &cgra );
    // Initialize the CGRA
    initCGRA();

    // Transformer
    //quant_bit_width* stftVec = raw_signal;
    quant_bit_width* rawInputSignal = raw_signal + 160*15;
    quant_bit_width* out = raw_signal + 160*15*20;
    quant_bit_width* intermediate = raw_signal + 16*1024;
    quant_bit_width* qkv = out + 2048;
    quant_bit_width* input_normalized = out + 4096;
    int32_t distances[2];
    //printf("\rfft\n");
    //stft_rearrange(rawInputSignal, stftVec, 80, 5);
    printf("\rInfer\n");
    transformerInference(stftVec, out, input_normalized, qkv, intermediate);
    printf("\rProto\n");
    prototype_distances(prototypes, out, distances, D_MODEL, 2);
    printf("Distances:\n");
    for (int i = 0; i< 2; i++)
        printf("Class %d = %d\n", i, distances[i]);
    return 0;
}


