/*
                              *******************
******************************* C SOURCE FILE *******************************
**                            *******************                          **
**                                                                         **
** project  : CGRA-X-HEEP                                                  **
** filename : gsm.c                                                 **
** version  : 1                                                            **
** date     : 2023-04-28                                                       **
**                                                                         **
*****************************************************************************
**                                                                         **
** Copyright (c) EPFL                                                      **
** All rights reserved.                                                    **
**                                                                         **
*****************************************************************************
*/

/***************************************************************************/
/***************************************************************************/

/**
* @file   gsm.c
* @date   2023-04-28
* @brief  A description of the kernel...
*
*/

#define _GSM_C

/****************************************************************************/
/**                                                                        **/
/*                             MODULES USED                                 */
/**                                                                        **/
/****************************************************************************/
#include <stdint.h>

#include "gsm.h"
#include "data/function.h"

/****************************************************************************/
/**                                                                        **/
/*                        DEFINITIONS AND MACROS                            */
/**                                                                        **/
/****************************************************************************/

#define CGRA_COLS       4
#define IN_VAR_DEPTH    2
#define OUT_VAR_DEPTH   1

/****************************************************************************/
/**                                                                        **/
/*                      PROTOTYPES OF LOCAL FUNCTIONS                       */
/**                                                                        **/
/****************************************************************************/

static void        config  (void);
static void        software(void);
static uint32_t    check   (void);

/****************************************************************************/
/**                                                                        **/
/*                            GLOBAL VARIABLES                              */
/**                                                                        **/
/****************************************************************************/

const uint32_t  cgra_imem_gsm[CGRA_IMEM_SIZE] = {  0x1a080000,  0x0,  0x4a080001,  0x0,  0x0,  0x0,  0x4a080001,  0x0,  0x0,  0x0,  0x4a080001,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0xc80000,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x4100000,  0x0,  0x0,  0x0,  0x4100000,  0x0,  0x0,  0x0,  0x4100000,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0xad0000,  0x0,  0x0,  0x0,  0x0,  0x0,  0x82786000,  0x0,  0x0,  0x0,  0x82786000,  0x0,  0x0,  0x0,  0x82786000,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0xa0f0028,  0x0,  0x0,  0x0,  0x4980000d,  0x0,  0x0,  0x0,  0x4980000d,  0x0,  0x0,  0x0,  0x49880009,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x2080000,  0x0,  0x0,  0x0,  0x2080000,  0x0,  0x0,  0x0,  0x2080000,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x1a080000,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x35100000,  0x53700000,  0x0,  0x0,  0x35100000,  0x53700000,  0x0,  0x0,  0x35100000,  0x53700000,  0x10b00000,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x5080000,  0x0,  0x0,  0x0,  0x5080000,  0x0,  0x0,  0x0,  0x5080000,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0xa90000,  0x0,  0x2a180004,  0x61080000,  0x0,  0x0,  0x2a180004,  0x61080000,  0x0,  0x0,  0x2a180004,  0x61080000,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x1a080000,  0x0,  0x0,  0x0,  0x2b80000,  0x0,  0x0,  0x0,  0x2b80000,  0x0,  0x0,  0x0,  0x2b80000,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0xa90000,  0x0,  0x0,  0x0,  0x0,  0x62100000,  0x2080000,  0x52700000,  0x0,  0x62100000,  0x2080000,  0x52700000,  0x0,  0x62100000,  0x2080000,  0x52700000,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0 };
static uint32_t cgra_kmem_gsm[CGRA_KMEM_SIZE] = {  0x0,  0xf013,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0,  0x0 };

static int32_t cgra_input[CGRA_COLS][IN_VAR_DEPTH]     __attribute__ ((aligned (4)));
static int32_t cgra_output[CGRA_COLS][OUT_VAR_DEPTH]   __attribute__ ((aligned (4)));

static int32_t	i_x_soft[40];
static int32_t	i_x_cgra[40];

static int32_t	o_ret_soft;
static int32_t	o_ret_cgra;


/****************************************************************************/
/**                                                                        **/
/*                           EXPORTED VARIABLES                             */
/**                                                                        **/
/****************************************************************************/

extern kcom_kernel_t gsm_kernel = {
    .kmem   = cgra_kmem_gsm,
    .imem   = cgra_imem_gsm,
    .col_n  = CGRA_COLS,
    .in_n   = 2,
    .out_n  = 1,
    .input  = cgra_input,
    .output = cgra_output,
    .config = config,
    .func   = software,
    .check  = check,
    .name   = "Gsm",
};

/****************************************************************************/
/**                                                                        **/
/*                            LOCAL FUNCTIONS                               */
/**                                                                        **/
/****************************************************************************/

void config()
{
	for(int i = 0; i < 40; i++ )
	{
		i_x_soft[i] = kcom_getRand() % (32767 - -32768 + 1) + -32768;
		i_x_cgra[i] = i_x_soft[i];
	}
	cgra_input[1][0] = i_x_cgra;
	cgra_input[3][0] = 32767;
	cgra_input[3][1] = -32768;

}

void software(void) 
{
    o_ret_soft = gsm( i_x_soft );
}

uint32_t check(void) 
{
    uint32_t errors = 0;
    
	o_ret_cgra = cgra_output[3][0];


#if PRINT_CGRA_RESULTS
    PRINTF("------------------------------\n");
    for( uint8_t c = 0; c < CGRA_COLS; c ++)
    {
        for( uint8_t r = 0; r < OUT_VAR_DEPTH; r++ )
        {
            PRINTF("[%d][%d]:%08x\t\t",c,r,cgra_output[c][r]);
        }
        PRINTF("\n");
    }
#endif //PRINT_CGRA_RESULTS


#if PRINT_RESULTS
        PRINTF("\nCGRA\t\tSoft\n");
#endif

    for( int i = 0; i < 1; i++ )
    {
#if PRINT_RESULTS
        PRINTF("%08x\t%08x\t%s\n",
        o_ret_cgra,
        o_ret_soft,
        (o_ret_cgra != o_ret_soft) ? "Wrong!" : ""
        );
#endif

        if (o_ret_cgra != o_ret_soft) {
            errors++;
        }
    }
    return errors;
}

/****************************************************************************/
/**                                                                        **/
/**                                EOF                                     **/
/**                                                                        **/
/****************************************************************************/