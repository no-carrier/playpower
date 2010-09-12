/***************************************************************************

    ppc.h

    Interface file for the universal machine language-based
    PowerPC emulator.

    Copyright Aaron Giles
    Released for general non-commercial use under the MAME license
    Visit http://mamedev.org for licensing and usage restrictions.

***************************************************************************/

#pragma once

#ifndef __PPC_H__
#define __PPC_H__

#include "cpuintrf.h"


/***************************************************************************
    CONSTANTS
***************************************************************************/

/* general constants */
#define PPC_MAX_FASTRAM			4
#define PPC_MAX_HOTSPOTS		16


/* interrupt types */
#define PPC_IRQ					0		/* external IRQ */
#define PPC_IRQ_LINE_0			0		/* (4XX) external IRQ0 */
#define PPC_IRQ_LINE_1			1		/* (4XX) external IRQ1 */
#define PPC_IRQ_LINE_2			2		/* (4XX) external IRQ2 */
#define PPC_IRQ_LINE_3			3		/* (4XX) external IRQ3 */
#define PPC_IRQ_LINE_4			4		/* (4XX) external IRQ4 */


/* register enumeration */
enum
{
	PPC_PC = 1,
	PPC_R0,
	PPC_R1,
	PPC_R2,
	PPC_R3,
	PPC_R4,
	PPC_R5,
	PPC_R6,
	PPC_R7,
	PPC_R8,
	PPC_R9,
	PPC_R10,
	PPC_R11,
	PPC_R12,
	PPC_R13,
	PPC_R14,
	PPC_R15,
	PPC_R16,
	PPC_R17,
	PPC_R18,
	PPC_R19,
	PPC_R20,
	PPC_R21,
	PPC_R22,
	PPC_R23,
	PPC_R24,
	PPC_R25,
	PPC_R26,
	PPC_R27,
	PPC_R28,
	PPC_R29,
	PPC_R30,
	PPC_R31,
	PPC_CR,
	PPC_LR,
	PPC_CTR,
	PPC_XER,
	PPC_MSR,
	PPC_SRR0,
	PPC_SRR1,
	PPC_SPRG0,
	PPC_SPRG1,
	PPC_SPRG2,
	PPC_SPRG3,
	PPC_SDR1,
	PPC_EXIER,
	PPC_EXISR,
	PPC_EVPR,
	PPC_IOCR,
	PPC_TBL,
	PPC_TBH,
	PPC_DEC
};


/* compiler-specific options */
#define PPCDRC_STRICT_VERIFY		0x0001			/* verify all instructions */
#define PPCDRC_FLUSH_PC				0x0002			/* flush the PC value before each memory access */
#define PPCDRC_ACCURATE_SINGLES		0x0004			/* do excessive rounding to make single-precision results "accurate" */


/* common sets of options */
#define PPCDRC_COMPATIBLE_OPTIONS	(PPCDRC_STRICT_VERIFY | PPCDRC_FLUSH_PC | PPCDRC_ACCURATE_SINGLES)
#define PPCDRC_FASTEST_OPTIONS		(0)



/***************************************************************************
    STRUCTURES AND TYPEDEFS
***************************************************************************/

typedef void (*ppc4xx_spu_tx_handler)(const device_config *device, UINT8 data);

typedef struct _powerpc_config powerpc_config;
struct _powerpc_config
{
	UINT32		bus_frequency;
};



/***************************************************************************
    PUBLIC FUNCTIONS
***************************************************************************/

void ppcdrc_set_options(const device_config *device, UINT32 options);
void ppcdrc_add_fastram(const device_config *device, offs_t start, offs_t end, UINT8 readonly, void *base);
void ppcdrc_add_hotspot(const device_config *device, offs_t pc, UINT32 opcode, UINT32 cycles);

void ppc4xx_spu_set_tx_handler(const device_config *device, ppc4xx_spu_tx_handler handler);
void ppc4xx_spu_receive_byte(const device_config *device, UINT8 byteval);


CPU_GET_INFO( ppc403ga );
#define CPU_PPC403GA CPU_GET_INFO_NAME( ppc403ga )

CPU_GET_INFO( ppc403gcx );
#define CPU_PPC403GCX CPU_GET_INFO_NAME( ppc403gcx )

CPU_GET_INFO( ppc601 );
#define CPU_PPC601 CPU_GET_INFO_NAME( ppc601 )

CPU_GET_INFO( ppc602 );
#define CPU_PPC602 CPU_GET_INFO_NAME( ppc602 )

CPU_GET_INFO( ppc603 );
#define CPU_PPC603 CPU_GET_INFO_NAME( ppc603 )

CPU_GET_INFO( ppc603e );
#define CPU_PPC603E CPU_GET_INFO_NAME( ppc603e )

CPU_GET_INFO( ppc603r );
#define CPU_PPC603R CPU_GET_INFO_NAME( ppc603r )

CPU_GET_INFO( ppc604 );
#define CPU_PPC604 CPU_GET_INFO_NAME( ppc604 )

CPU_GET_INFO( mpc8240 );
#define CPU_MPC8240 CPU_GET_INFO_NAME( mpc8240 )


#endif	/* __PPC_H__ */