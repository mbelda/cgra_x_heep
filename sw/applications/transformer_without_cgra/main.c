//
// Created by alireza on 10/6/23.
//

#include <stdio.h>
#include <math.h>
#include "main.h"
#include "data_cpp/signal.cpp"
//#include "data_cpp/signal_fft.cpp"
#include "SYLT-FFT/fft.h"
#include "weightsAndBiasesC.h"
#include "transformerBlockC.h"


// FFT
#include "stftVec.h"
#include "performance.h"


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
    //getWeights(weightVec);
    //getBiases(biasVec);
    quant_bit_width * clsTokenVector = getClassToken();
    quant_bit_width * posMatrix = getPosEmbedding();
    TransformerBlock* selfatten = createTransformerBlock(D_SEQ, D_MODEL, D_Q, NUM_HEAD, D_FF, weightVec, biasVec, clsTokenVector, posMatrix);
    computeFixedPoint(selfatten, D_SEQ, transformerInput, input_normalized, transformerOutput, intermediate, qkv);
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

/*
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
*/

/*
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
}*/


int main() {
    // Init timer
    timerInit();
    //kcom_perf_t perf;
    quant_bit_width* rawInputSignal = stftVec + 160*15;
    quant_bit_width* out = stftVec + 160*15*20;
    quant_bit_width* intermediate = stftVec + 16*1024;
    quant_bit_width* qkv = out + 2048;
    quant_bit_width* input_normalized = out + 4096;
    int32_t distances[2];
    //stft_rearrange(rawInputSignal, stftVec, 80, 5);
    //kcom_perfRecordStart(&(perf.time.infer));
    transformerInference(stftVec, out, input_normalized, qkv, intermediate);
    //kcom_perfRecordStop(&(perf.time.infer));
    //prototype_distances(prototypes, out, distances, D_MODEL, 2);
    /*printf("Distances : \n");
    for (int i = 0; i< 2; i++)
        printf("From the prototype of class %d = %d\n", i, distances[i]);
    */
    //printf("Inference cycles: %d\n", perf.time.infer.spent_cy);
    
    return 0;
}

