#pragma once

#ifndef __DISCRETE_H__
#define __DISCRETE_H__

#include "machine/rescap.h"

/***********************************************************************
 *
 *  MAME - Discrete sound system emulation library
 *
 *  Written by Keith Wilkins (mame@esplexo.co.uk)
 *
 *  (c) K.Wilkins 2000
 *
 *  Coding started in November 2000
 *
 *  Additions/bugfix February 2003 - D.Renaud, F.Palazzolo, K.Wilkins
 *
 ***********************************************************************
 *
 * For free text books on electronic theory check out:
 * http://www.ibiblio.org/obp/electricCircuits/
 * For a free circuit simulator:
 * http://qucs.sourceforge.net/index.html
 * For a free waveform editor to view DISCRETE_WAVELOG dumps:
 * http://audacity.sourceforge.net/
 * http://www.sonicvisualiser.org/
 *
 ***********************************************************************
 *
 * Currently only one instance of a discrete sound system is supported.
 * If more then one instance is required in the future, then a chip #
 * will have to be added to the read/writes and the discrete inputs
 * modified to match.  This functionality should never be needed.
 * There is no real need to run more then 1 discrete system.
 *
 * If a clock is specified in the machine driver setup, then this is
 * used for the simulation sample rate.  Otherwise it will default to
 * run at the audio sample rate.
 *
 * Unused/Unconnected input nodes should be set to NODE_NC (No Connect)
 *
 * Each node can have many inputs from either constants or other
 * nodes within the system.
 *
 * It should be remembered that the discrete sound system emulation
 * does not do individual device emulation, but instead does a function
 * emulation. So you will need to convert the schematic design into
 * a logic block representation.
 *
 * There is the possibility to support multiple outputs per module.
 * In this case, NODE_XXX is the default output. Alternative outputs may
 * be accessed by using NODE_XXX_YY where 00<=Y<08.
 *
 * You may also access nodes with a macros:
 *
 *     NODE_XXX = NODE_SUB(XXX, 0)
 *     NODE_XXX = NODE(XXX)
 *     NODE_XXX_YY = NODE_SUB(XXX, YY) with YY != 00
 *
 * One node point may feed a number of inputs, for example you could
 * connect the output of a DISCRETE_SINEWAVE to the AMPLITUDE input
 * of another DISCRETE_SINEWAVE to amplitude modulate its output and
 * also connect it to the frequency input of another to frequency
 * modulate its output, the combinations are endless....
 *
 * Consider the circuit below:
 *
 *  .--------.             .----------.                 .-------.
 *  |        |             |          |                 |       |
 *  | SQUARE |       Enable| SINEWAVE |                 |       |
 *  | WAVE   |-+---------->|  2000Hz  |---------------->|       |
 *  |        | |           |          |                 | ADDER |-->OUT
 *  | NODE11 | |           |  NODE12  |                 |       |
 *  '--------' |           '----------'              .->|       |
 *             |                                     |  |NODE20 |
 *             |  .------.              .---------.  |  '-------'
 *             |  |Logic |              |         |  |       ^
 *             |  | INV  |       Enable | SINEWVE |  |       |
 *             '->| ERT  |------------->| 4000Hz  |--'  .-------.
 *                |      |              |         |     |       |
 *                |NODE13|              | NODE14  |     | INPUT |
 *                '------'              '---------'     |       |
 *                                                      |NODE01 |
 *                                                      '-------'
 *
 * This should give you an alternating two tone sound switching
 * between the 2000Hz and 4000Hz sine waves at the frequency of the
 * square wave, with the memory mapped enable signal mapped onto NODE07
 * so discrete_sound_w(NODE_01,1) will enable the sound, and
 * discrete_sound_w(NODE_01,0) will disable the sound.
 *
 *  DISCRETE_SOUND_START(test_interface)
 *      DISCRETE_INPUT_LOGIC(NODE_01)
 *      DISCRETE_SQUAREWFIX(NODE_11, 1, 0.5, 1, 50, 1.0/2, 0)   // Output 0:1
 *      DISCRETE_SINEWAVE(NODE_12, NODE_11, 2000, 10000, 0, 0)
 *      DISCRETE_LOGIC_INVERT(NODE_13, 1, NODE_11)
 *      DISCRETE_SINEWAVE(NODE_14, NODE_13, 4000, 10000, 0, 0)
 *      DISCRETE_ADDER2(NODE_20, NODE_01, NODE_12, NODE_14)
 *      DISCRETE_OUTPUT(NODE_20, 1)
 *  DISCRETE_SOUND_END
 *
 * To aid simulation speed it is preferable to use the enable/disable
 * inputs to a block rather than setting the output amplitude to zero
 *
 * Feedback loops are allowed BUT they will always feedback one time
 * step later, the loop over the netlist is only performed once per
 * deltaT so feedback occurs in the next deltaT step. This is not
 * the perfect solution but saves repeatedly traversing the netlist
 * until all nodes have settled.
 *
 * The best way to work out your system is generally to use a pen and
 * paper to draw a logical block diagram like the one above, it helps
 * to understand the system ,map the inputs and outputs and to work
 * out your node numbering scheme.
 *
 * Node numbers NODE_01 to NODE_299 are defined at present.
 *
 * It is recommended to put all Inputs at the start of the interface.
 * That way they are updated first.
 *
 * Each sound effects final node should come after all nodes that
 * create it.  The final mixing of all sound effects should come
 * at the end of the interface.
 *
 ***********************************************************************
 *
 * x_time - ANTI-ALIASING features.
 *
 * Certain modules make use of x_time.  This is a feature that passes
 * information between modules about how long in the current sample, the
 * switch in state happened.  This is a decimal value of the % of the
 * full sample period that it has been in the new state.
 * 0 means it has been at the same state the whole sample.
 *
 * Example: Here is the output of a clock source with x_time on the
 *          output.  The square wave is the real world waveform we
 *          want.  The ^'s are the sample point.  The numbers under
 *          the ^'s are the node output with the logic state left of
 *          the decimal and the x_time to the right.  Under that is
 *          what the node's anti-aliased output energy would be.
 *          Note: the example is not 4x sampling so the energy
 *                does not provide an accurate representation of the
 *                original waveform.  This is intentional so it fits
 *                in this header file.
 *  1      ____    ____    ____    ____    ____    ____    ____    ____
 *  0   ___    ____    ____    ____    ____    ____    ____    ____    __
 *        ^....^....^....^....^....^....^....^....^....^....^....^....^
 *   x_time   0.2  1.4  0.6  1.8  1.2  0.4  1.6  0.8  0.2  1.4  0.6
 *   energy   0.8  0.4  0.4  0.8  0.2  0.6  0.6  0.2  0.8  0.4  0.4
 *
 * Some modules will just pass the x_time onto another module.
 *
 * Modules that process x_time will keep track of the node's previous
 * state so they can calculate the actual energy at the sample time.
 *
 * Example: Say we have a 555 module that outputs a clock with x_time
 *          that is connected to a counter.  The output of the counter
 *          is connected to DAC_R1.
 *          In this case the counter module continues counting dependant
 *          on the integer portion of the 555 output.  But it also
 *          passes the decimal portion as the x_time.
 *          The DAC_R1 then uses this info to anti-alias its output.
 *          Consider the following counter outputs vs DAC_R1
 *          calculations.  The count changes from 9 to 10.  It has
 *          been at the new state for 75% of the sample.
 *
 *          counter    binary   x_time    -- DAC_R1 bit energy --
 *            out       count              D3    D2    D1    D0
 *            9.0       1001     0.0      1.0   0.0   0.0   1.0
 *           10.75      1010     0.75     1.0   0.0   0.75  0.25
 *           10.0       1010     0.0      1.0   0.0   1.0   0.0
 *
 *           The DAC_R1 uses these energy calculations to scale the
 *           voltages created on each of its resistors.  This
 *           anti-aliases the waveform no mater what the resistor
 *           weighting is.
 *
 ***********************************************************************
 *
 * LIST OF CURRENTLY IMPLEMENTED DISCRETE BLOCKS
 * ---------------------------------------------
 *
 * DISCRETE_SOUND_START(STRUCTURENAME)
 * DISCRETE_SOUND_END
 *
 * DISCRETE_ADJUSTMENT(NODE,MIN,MAX,LOGLIN,PORT)
 * DISCRETE_ADJUSTMENT_TAG(NODE,MIN,MAX,LOGLIN,TAG)
 * DISCRETE_ADJUSTMENTX(NODE,MIN,MAX,LOGLIN,PORT,PMIN,PMAX)
 * DISCRETE_CONSTANT(NODE,CONST0)
 * DISCRETE_INPUT_DATA(NODE)
 * DISCRETE_INPUTX_DATA(NODE,GAIN,OFFSET,INIT)
 * DISCRETE_INPUT_LOGIC(NODE)
 * DISCRETE_INPUTX_LOGIC(NODE,GAIN,OFFSET,INIT)
 * DISCRETE_INPUT_NOT(NODE)
 * DISCRETE_INPUTX_NOT(NODE,GAIN,OFFSET,INIT)
 * DISCRETE_INPUT_PULSE(NODE,INIT)
 * DISCRETE_INPUT_STREAM(NODE, NUM)
 * DISCRETE_INPUTX_STREAM(NODE,NUM, GAIN,OFFSET)
 *
 * DISCRETE_COUNTER(NODE,ENAB,RESET,CLK,MAX,DIR,INIT0,CLKTYPE)
 * DISCRETE_COUNTER_7492(NODE,ENAB,RESET,CLK,CLKTYPE)
 * DISCRETE_LFSR_NOISE(NODE,ENAB,RESET,CLK,AMPL,FEED,BIAS,LFSRTB)
 * DISCRETE_NOISE(NODE,ENAB,FREQ,AMP,BIAS)
 * DISCRETE_NOTE(NODE,ENAB,CLK,DATA,MAX1,MAX2,CLKTYPE)
 * DISCRETE_SAWTOOTHWAVE(NODE,ENAB,FREQ,AMP,BIAS,GRADIENT,PHASE)
 * DISCRETE_SINEWAVE(NODE,ENAB,FREQ,AMP,BIAS,PHASE)
 * DISCRETE_SQUAREWAVE(NODE,ENAB,FREQ,AMP,DUTY,BIAS,PHASE)
 * DISCRETE_SQUAREWFIX(NODE,ENAB,FREQ,AMP,DUTY,BIAS,PHASE)
 * DISCRETE_SQUAREWAVE2(NODE,ENAB,AMPL,T_OFF,T_ON,BIAS,TSHIFT)
 * DISCRETE_TRIANGLEWAVE(NODE,ENAB,FREQ,AMP,BIAS,PHASE)
 *
 * DISCRETE_INVERTER_OSC(NODE,ENAB,MOD,RCHARGE,RP,C,R2,INFO)
 * DISCRETE_OP_AMP_OSCILLATOR(NODE,ENAB,INFO)
 * DISCRETE_OP_AMP_VCO1(NODE,ENAB,VMOD1,INFO)
 * DISCRETE_OP_AMP_VCO2(NODE,ENAB,VMOD1,VMOD2,INFO)
 * DISCRETE_SCHMITT_OSCILLATOR(NODE,ENAB,INP0,AMPL,TABLE)
 *
 * DISCRETE_ADDER2(NODE,ENAB,IN0,IN1)
 * DISCRETE_ADDER3(NODE,ENAB,IN0,IN1,IN2)
 * DISCRETE_ADDER4(NODE,ENAB,IN0,IN1,IN2,IN3)
 * DISCRETE_CLAMP(NODE,ENAB,IN0,MIN,MAX,CLAMP)
 * DISCRETE_DIVIDE(NODE,ENAB,IN0,IN1)
 * DISCRETE_GAIN(NODE,IN0,GAIN)
 * DISCRETE_INVERT(NODE,IN0)
 * DISCRETE_LOOKUP_TABLE(NODE,ENAB,ADDR,SIZE,TABLE)
 * DISCRETE_MULTIPLY(NODE,ENAB,IN0,IN1)
 * DISCRETE_MULTADD(NODE,ENAB,INP0,INP1,INP2)
 * DISCRETE_ONESHOT(NODE,TRIG,AMPL,WIDTH,TYPE)
 * DISCRETE_ONESHOTR(NODE,RESET,TRIG,AMPL,WIDTH,TYPE)
 * DISCRETE_ONOFF(NODE,ENAB,INP0)
 * DISCRETE_RAMP(NODE,ENAB,RAMP,GRAD,MIN,MAX,CLAMP)
 * DISCRETE_SAMPLHOLD(NODE,ENAB,INP0,CLOCK,CLKTYPE)
 * DISCRETE_SWITCH(NODE,ENAB,SWITCH,INP0,INP1)
 * DISCRETE_TRANSFORM2(NODE,INP0,INP1,FUNCT)
 * DISCRETE_TRANSFORM3(NODE,INP0,INP1,INP2,FUNCT)
 * DISCRETE_TRANSFORM4(NODE,INP0,INP1,INP2,INP3,FUNCT)
 * DISCRETE_TRANSFORM5(NODE,INP0,INP1,INP2,INP3,INP4,FUNCT)
 *
 * DISCRETE_COMP_ADDER(NODE,DATA,TABLE)
 * DISCRETE_DAC_R1(NODE,ENAB,DATA,VDATA,LADDER)
 * DISCRETE_DIODE_MIXER2(NODE,IN0,IN1,TABLE)
 * DISCRETE_DIODE_MIXER3(NODE,IN0,IN1,IN2,TABLE)
 * DISCRETE_DIODE_MIXER4(NODE,IN0,IN1,IN2,IN3,TABLE)
 * DISCRETE_INTEGRATE(NODE,TRG0,TRG1,INFO)
 * DISCRETE_MIXER2(NODE,ENAB,IN0,IN1,INFO)
 * DISCRETE_MIXER3(NODE,ENAB,IN0,IN1,IN2,INFO)
 * DISCRETE_MIXER4(NODE,ENAB,IN0,IN1,IN2,IN3,INFO)
 * DISCRETE_MIXER5(NODE,ENAB,IN0,IN1,IN2,IN3,IN4,INFO)
 * DISCRETE_MIXER6(NODE,ENAB,IN0,IN1,IN2,IN3,IN4,IN5,INFO)
 * DISCRETE_MIXER7(NODE,ENAB,IN0,IN1,IN2,IN3,IN4,IN5,IN6,INFO)
 * DISCRETE_MIXER8(NODE,ENAB,IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7,INFO)
 * DISCRETE_OP_AMP(NODE,ENAB,IN0,IN1,INFO)
 * DISCRETE_OP_AMP_ONESHOT(NODE,TRIG,INFO)
 * DISCRETE_OP_AMP_TRIG_VCA(NODE,TRG0,TRG1,TRG2,IN0,IN1,INFO)
 *
 * DISCRETE_LOGIC_INVERT(NODE,ENAB,INP0)
 * DISCRETE_LOGIC_AND(NODE,ENAB,INP0,INP1)
 * DISCRETE_LOGIC_AND3(NODE,ENAB,INP0,INP1,INP2)
 * DISCRETE_LOGIC_AND4(NODE,ENAB,INP0,INP1,INP2,INP3)
 * DISCRETE_LOGIC_NAND(NODE,ENAB,INP0,INP1)
 * DISCRETE_LOGIC_NAND3(NODE,ENAB,INP0,INP1,INP2)
 * DISCRETE_LOGIC_NAND4(NODE,ENAB,INP0,INP1,INP2,INP3)
 * DISCRETE_LOGIC_OR(NODE,ENAB,INP0,INP1)
 * DISCRETE_LOGIC_OR3(NODE,ENAB,INP0,INP1,INP2)
 * DISCRETE_LOGIC_OR4(NODE,ENAB,INP0,INP1,INP2,INP3)
 * DISCRETE_LOGIC_NOR(NODE,ENAB,INP0,INP1)
 * DISCRETE_LOGIC_NOR3(NODE,ENAB,INP0,INP1,INP2)
 * DISCRETE_LOGIC_NOR4(NODE,ENAB,INP0,INP1,INP2,INP3)
 * DISCRETE_LOGIC_XOR(NODE,ENAB,INP0,INP1)
 * DISCRETE_LOGIC_NXOR(NODE,ENAB,INP0,INP1)
 * DISCRETE_LOGIC_DFLIPFLOP(NODE,ENAB,RESET,SET,CLK,INP)
 * DISCRETE_LOGIC_JKFLIPFLOP(NODE,ENAB,RESET,SET,CLK,J,K)
 * DISCRETE_MULTIPLEX2(NODE,ENAB,ADDR,INP0,INP1)
 * DISCRETE_MULTIPLEX4(NODE,ENAB,ADDR,INP0,INP1,INP2,INP3)
 * DISCRETE_MULTIPLEX8(NODE,ENAB,ADDR,INP0,INP1,INP2,INP3,INP4,INP5,INP6,INP7)
 *
 * DISCRETE_FILTER1(NODE,ENAB,INP0,FREQ,TYPE)
 * DISCRETE_FILTER2(NODE,ENAB,INP0,FREQ,DAMP,TYPE)
 *
 * DISCRETE_CRFILTER(NODE,ENAB,IN0,RVAL,CVAL)
 * DISCRETE_CRFILTER_VREF(NODE,ENAB,IN0,RVAL,CVAL,VREF)
 * DISCRETE_OP_AMP_FILTER(NODE,ENAB,INP0,INP1,TYPE,INFO)
 * DISCRETE_RCDISC(NODE,ENAB,IN0,RVAL,CVAL)
 * DISCRETE_RCDISC2(NODE,SWITCH,INP0,RVAL0,INP1,RVAL1,CVAL)
 * DISCRETE_RCDISC3(NODE,ENAB,INP0,RVAL0,RVAL1,CVAL)
 * DISCRETE_RCDISC4(NODE,ENAB,INP0,RVAL0,RVAL1,RVAL2,CVAL,VP,TYPE)
 * DISCRETE_RCDISC5(NODE,ENAB,IN0,RVAL,CVAL)
 * DISCRETE_RCINTEGRATE(NODE,INP0,RVAL0,RVAL1,RVAL2,CVAL,vP,TYPE)
 * DISCRETE_RCDISC_MODULATED(NODE,INP0,INP1,RVAL0,RVAL1,RVAL2,RVAL3,CVAL,VP)
 * DISCRETE_RCFILTER(NODE,ENAB,IN0,RVAL,CVAL)
 * DISCRETE_RCFILTER_VREF(NODE,ENAB,IN0,RVAL,CVAL,VREF)
 *
 * DISCRETE_555_ASTABLE(NODE,RESET,R1,R2,C,OPTIONS)
 * DISCRETE_555_ASTABLE_CV(NODE,RESET,R1,R2,C,CTRLV,OPTIONS)
 * DISCRETE_555_MSTABLE(NODE,RESET,TRIG,R,C,OPTIONS)
 * DISCRETE_555_CC(NODE,RESET,VIN,R,C,RBIAS,RGND,RDIS,OPTIONS)
 * DISCRETE_555_VCO1(NODE,RESET,VIN,OPTIONS)
 * DISCRETE_555_VCO1_CV(NODE,RESET,VIN,CTRLV,OPTIONS)
 * DISCRETE_566(NODE,ENAB,VMOD,R,C,OPTIONS)
 *
 * DISCRETE_CUSTOM1(NODE,IN0,INFO)
 * DISCRETE_CUSTOM2(NODE,IN0,IN1,INFO)
 * DISCRETE_CUSTOM3(NODE,IN0,IN1,IN2,INFO)
 * DISCRETE_CUSTOM4(NODE,IN0,IN1,IN2,IN3,INFO)
 * DISCRETE_CUSTOM5(NODE,IN0,IN1,IN2,IN3,IN4,INFO)
 * DISCRETE_CUSTOM6(NODE,IN0,IN1,IN2,IN3,IN4,IN5,INFO)
 * DISCRETE_CUSTOM7(NODE,IN0,IN1,IN2,IN3,IN4,IN5,IN6,INFO)
 * DISCRETE_CUSTOM8(NODE,IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7,INFO)
 * DISCRETE_CUSTOM9(NODE,IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,INFO)
 *
 * DISCRETE_CSVLOG1(NODE1)
 * DISCRETE_CSVLOG2(NODE1,NODE2)
 * DISCRETE_CSVLOG3(NODE1,NODE2,NODE3)
 * DISCRETE_CSVLOG4(NODE1,NODE2,NODE3,NODE4)
 * DISCRETE_CSVLOG5(NODE1,NODE2,NODE3,NODE4,NODE5)
 * DISCRETE_WAVELOG1(NODE1,GAIN1)
 * DISCRETE_WAVELOG2(NODE1,GAIN1,NODE2,GAIN2)
 * DISCRETE_OUTPUT(OPNODE,GAIN)
 *
 ***********************************************************************
 =======================================================================
 * from from disc_inp.c
 =======================================================================
 ***********************************************************************
 *
 * DISCRETE_ADJUSTMENT     - Adjustable constant set by the UI [~] menu.
 * DISCRETE_ADJUSTMENT_TAG - Same as above but referenced by a tag.
 *
 * Note: DISCRETE_ADJUSTMENT_TAG is prefered over DISCRETE_ADJUSTMENT.
 *
 *                        .----------.
 *                        |          |
 *                        | ADJUST.. |-------->   Netlist node
 *                        |          |
 *                        '----------'
 *  Declaration syntax
 *
 *     DISCRETE_ADJUSTMENT(name of node,
 *                         static minimum value the node can take,
 *                         static maximum value the node can take,
 *                         log/linear scale 0=Linear !0=Logarithmic,
 *                         input port number of the adjuster)
 *
 *     DISCRETE_ADJUSTMENT_TAG(name of node,
 *                             static minimum value the node can take,
 *                             static maximum value the node can take,
 *                             log/linear scale 0=Linear !0=Logarithmic,
 *                             port tag name of the adjuster)
 *
 *  Note: When using DISC_LOGADJ, the min/max values must be > 0.
 *        If they are <=0, they will be forced to 1.
 *        Min can be a higher value then max.
 *        Min/max is just how the slider is displayed.
 *
 *  Example config line
 *
 *     DISCRETE_ADJUSTMENT(NODE_01,0.0,5.0,DISC_LINADJ,0,5)
 *
 *  Define an adjustment slider that takes a 0-100 input from input
 *  port #5, scaling between 0.0 and 5.0. Adjustment scaling is Linear.
 *
 *      DISC_LOGADJ 1.0
 *      DISC_LINADJ 0.0
 *
 * EXAMPLES: see Hit Me, Fire Truck
 *
 ***********************************************************************
 *
 * DISCRETE_CONSTANT - Single output, fixed at compile time.
 *                     This is usefull as a placeholder for
 *                     incomplete circuits.
 *
 *                        .----------.
 *                        |          |
 *                        | CONSTANT |-------->   Netlist node
 *                        |          |
 *                        '----------'
 *  Declaration syntax
 *
 *     DISCRETE_CONSTANT(name of node, constant value)
 *
 *  Example config line
 *
 *     DISCRETE_CONSTANT(NODE_01, 100)
 *
 *  Define a node that has a constant value of 100
 *
 ***********************************************************************
 *
 * DISCRETE_INPUT_DATA  - accepts 8-bit data.  Value at reset is 0.
 * DISCRETE_INPUT_LOGIC - 0 if data=0; 1 if data=1.  Value at reset is 0.
 * DISCRETE_INPUT_NOT   - 0 if data=1; 1 if data=0.  Value at reset is 1.
 *
 * DISCRETE_INPUTX_xx   - same as above, but will modify the value by the
 *                        given GAIN and OFFSET.  At reset the value will
 *                        be INIT modified by GAIN and OFFSET.
 *
 * DISCRETE_INPUT_PULSE - Same as normal input node but the netlist
 *                        node output returns to INIT after a single
 *                        cycle of sound output. To allow for scenarios
 *                        whereby the register write pulse is used as
 *                        a reset to a system.
 *
 *                            .----------.
 *                      -----\|          |
 *     discrete_sound_w  data | INPUT(A) |---->   Netlist node
 *            Write     -----/|          |
 *                            '----------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_INPUT_DATA  (name of node)
 *     DISCRETE_INPUT_LOGIC (name of node)
 *     DISCRETE_INPUT_NOT   (name of node)
 *     DISCRETE_INPUTX_DATA (name of node, gain, offset, initial value)
 *     DISCRETE_INPUTX_LOGIC(name of node, gain, offset, initial value)
 *     DISCRETE_INPUTX_NOT  (name of node, gain, offset, initial value)
 *     DISCRETE_INPUT_PULSE (name of node, default value)
 *
 *  Can be written to with:    discrete_sound_w(NODE_xx, data);
 *
 ***********************************************************************
 *
 * DISCRETE_INPUT_STREAM(NODE,NUM)              - Accepts stream input NUM
 * DISCRETE_INPUTX_STREAM(NODE,NUM,GAIN,OFFSET) - Accepts a stream input and
 *                                                applies a gain and offset.
 *
 *  Declaration syntax
 *
 *     DISCRETE_INPUT_STREAM (name of node, stream number, )
 *     DISCRETE_INPUTX_STREAM(name of node, stream nubmer, gain, offset)
 *
 * Note: The discrete system is floating point based.  So when routing a stream
 *       set it's gain to 100% and then use DISCRETE_INPUTX_STREAM to adjust
 *       it if needed.
 *
 * EXAMPLES: see
 *
 ***********************************************************************
 =======================================================================
 * from from disc_wav.c
 * Generic modules
 =======================================================================
 ***********************************************************************
 *
 * DISCRETE_COUNTER     - up/down counter.
 *
 *  This counter counts up/down from 0 to MAX.  When the enable is low, the output
 *  is held at it's last value.  When reset is high, the reset value is loaded
 *  into the output.  The counter can be clocked internally or externally.  It also
 *  supports x_time used by the clock modules to pass on anti-aliasing info.
 *
 *  Declaration syntax
 *
 *       where:  direction: DISC_COUNT_DOWN = 0 = down
 *                          DISC_COUNT_UP   = 1 = up
 *
 *               clock type: DISC_CLK_ON_F_EDGE - toggle on falling edge.
 *                           DISC_CLK_ON_R_EDGE - toggle on rising edge.
 *                           DISC_CLK_BY_COUNT  - toggle specified number of times.
 *                           DISC_CLK_IS_FREQ   - internally clock at this frequency.
 *                                                Clock node must be static if
 *                                                DISC_CLK_IS_FREQ is used.
 *               x_time options: you can also | these x_time features to the basic
 *                               types above if needed, or use seperately with 7492.
 *                           DISC_OUT_IS_ENERGY - This will uses the x_time to
 *                                                anti-alias the count.  Might be
 *                                                usefull if not connected to other
 *                                                modules.
 *                           DISC_OUT_HAS_XTIME - This will generate x_time if
 *                                                being used with DISC_CLK_IS_FREQ.
 *                                                It will pass x_time for the
 *                                                other clock types.
 *
 *     DISCRETE_COUNTER(name of node,
 *                      enable node or static value,
 *                      reset node or static value, (reset when TRUE)
 *                      clock node or static value,
 *                      max count static value,
 *                      direction node or static value,
 *                      reset value node or static value,
 *                      clock type static value)
 *
 *     DISCRETE_COUNTER_7492(name of node,
 *                           enable node or static value,
 *                           reset node or static value,
 *                           clock node or static value,
 *                           clock type static value)
 *
 *  Note: A 7492 counter outputs a special bit pattern on its /6 stage.
 *        A 7492 clocks on the falling edge,
 *        so it is not recommended to use DISC_CLK_ON_R_EDGE for a 7492.
 *        This module emulates the /6 stage only.
 *        Use another DISCRETE_COUNTER for the /2 stage.
 *
 * EXAMPLES: see Fire Truck, Monte Carlo, Super Bug, Polaris
 *
 ***********************************************************************
 *
 * DISCRETE_LFSR_NOISE - Noise waveform generator node, generates
 *                       psuedo random digital stream at the requested
 *                       clock frequency.
 *
 *  Declaration syntax
 *
 *     DISCRETE_LFSR_NOISE(name of node,
 *                         enable node or static value,
 *                         reset node or static value,
 *                         clock node or static value,
 *                         amplitude node or static value,
 *                         forced infeed bit to shift reg,
 *                         bias node or static value,
 *                         LFSR noise descriptor structure)
 *
 *     discrete_lfsr_desc = {clock type,  (see DISCRETE_COUNTER),
 *                           bitlength, reset_value,
 *                           feedback_bitsel0, feedback_bitsel1,
 *                           feedback_function0, feedback_function1, feedback_function2,
 *                           feedback_function2_mask, flags, output_bit}
 *
 *     flags: DISC_LFSR_FLAG_OUT_INVERT     - invert output
 *            DISC_LFSR_FLAG_RESET_TYPE_L   - reset when LOW (Defalut)
 *            DISC_LFSR_FLAG_RESET_TYPE_H   - reset when HIGH
 *            DISC_LFSR_FLAG_OUTPUT_F0      - output is result of F0
 *
 *  The diagram below outlines the structure of the LFSR model.
 *
 *         .-------.
 *   FEED  |       |
 *   ----->|  F1   |<--------------------------------------------.
 *         |       |                                             |
 *         '-------'               BS - Bit Select               |
 *             |                   Fx - Programmable Function    |
 *             |        .-------.  PI - Programmable Inversion   |
 *             |        |       |                                |
 *             |  .---- | SR>>1 |<--------.                      |
 *             |  |     |       |         |                      |
 *             V  V     '-------'         |  .----               |
 *           .------.                     +->| BS |--. .------.  |
 *   BITMASK |      |    .-------------.  |  '----'  '-|      |  |
 *   ------->|  F2  |-+->| Shift Reg   |--+            |  F0  |--'
 *           |      | |  '-------------'  |  .----.  .-|      |
 *           '------' |         ^         '->| BS |--' '------'
 *                    |         |            '----'
 *   CLOCK            |     RESET VAL
 *   ---->            |                      .----.  .----.
 *                    '----------------------| BS |--| PI |--->OUTPUT
 *                                           '----'  '----'
 *
 * EXAMPLES: see Fire Truck, Monte Carlo, Super Bug, Polaris
 *
 ***********************************************************************
 *
 * DISCRETE_NOISE      - Noise waveform generator node, generates
 *                       random noise of the chosen frequency.
 *
 *                        .------------.
 *                        |            |
 *    ENABLE     -0------>|            |
 *                        |            |
 *    FREQUENCY  -1------>|   NOISE    |---->   Netlist node
 *                        |            |
 *    AMPLITUDE  -2------>|            |
 *                        |            |
 *    BIAS       -3------>|            |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_NOISE(name of node,
 *                    enable node or static value,
 *                    frequency node or static value,
 *                    amplitude node or static value)
 *
 *  Example config line
 *
 *     DISCRETE_NOISE(NODE_03,1,5000,NODE_01,0)
 *
 ***********************************************************************
 *
 * DISCRETE_NOTE - Note generator.  This takes a chosen clock, and
 *                 clocks an up counter that is preloaded with the data
 *                 value at every max 1 count.  Every time max 1 count
 *                 is reached, the output counts up one and rolls over
 *                 to 0 at max 2 count.
 *                 When the data value is the same as max count 1, the
 *                 counter no longer counts.
 *
 *  Declaration syntax
 *
 *     DISCRETE_NOTE(name of node,
 *                   enable node or static value,
 *                   clock node or static value,
 *                   data node or static value,
 *                   max 1 count static value,
 *                   max 2 count static value,
 *                   clock type  (see DISCRETE_COUNTER))
 *
 * EXAMPLES: see Polaris, Blockade
 *
 ***********************************************************************
 *
 * DISCRETE_SAWTOOTHWAVE - Saw tooth shape waveform generator, rapid
 *                         rise and then graduated fall
 *
 *                        .------------.
 *                        |            |
 *    ENABLE     -0------>|            |
 *                        |            |
 *    FREQUENCY  -1------>|            |
 *                        |            |
 *    AMPLITUDE  -2------>|  SAWTOOTH  |----> Netlist Node
 *                        |    WAVE    |
 *    BIAS       -3------>|            |
 *                        |            |
 *    GRADIENT   -4------>|            |
 *                        |            |
 *    PHASE      -5------>|            |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_SAWTOOTHWAVE(name of node,
 *                         enable node or static value,
 *                         frequency node or static value,
 *                         amplitude node or static value,
 *                         dc bias value for waveform,
 *                         gradient of wave ==0 //// !=0 \\\\,
 *                         starting phase value in degrees)
 *
 *  Example config line
 *
 *     DISCRETE_SAWTOOTHWAVE(NODE_03,1,5000,NODE_01,0,0,90)
 *
 ***********************************************************************
 *
 * DISCRETE_SINEWAVE   - Sinewave waveform generator node, has four
 *                       input nodes FREQUENCY, AMPLITUDE, ENABLE and
 *                       PHASE, if a node is not connected it will
 *                       default to the initialised value in the macro
 *
 *                        .------------.
 *                        |            |
 *    ENABLE     -0------>|            |
 *                        |            |
 *    FREQUENCY  -1------>|            |
 *                        | SINEWAVE   |---->   Netlist node
 *    AMPLITUDE  -2------>|            |
 *                        |            |
 *    BIAS       -3------>|            |
 *                        |            |
 *    PHASE      -4------>|            |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_SINEWAVE  (name of node,
 *                         enable node or static value,
 *                         frequency node or static value,
 *                         amplitude node or static value,
 *                         dc bias value for waveform,
 *                         starting phase value in degrees)
 *
 *  Example config line
 *
 *     DISCRETE_SINEWAVE(NODE_03,NODE_01,NODE_02,10000,5000.0,90)
 *
 ***********************************************************************
 *
 * DISCRETE_SQUAREWAVE - Squarewave waveform generator node.
 * DISCRETE_SQUAREWFIX   Waveform is defined by frequency and duty
 *                       cycle.
 *
 *                        .------------.
 *                        |            |
 *    ENABLE     -0------>|            |
 *                        |            |
 *    FREQUENCY  -1------>|            |
 *                        |            |
 *    AMPLITUDE  -2------>| SQUAREWAVE |---->   Netlist node
 *                        |            |
 *    DUTY CYCLE -3------>|            |
 *                        |            |
 *    BIAS       -4------>|            |
 *                        |            |
 *    PHASE      -5------>|            |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_SQUAREWAVE(name of node,
 *                         enable node or static value,
 *                         frequency node or static value,
 *                         amplitude node or static value,
 *                         duty cycle node or static value,
 *                         dc bias value for waveform,
 *                         starting phase value in degrees)
 *
 *  Example config line
 *
 *     DISCRETE_SQUAREWAVE(NODE_03,NODE_01,NODE_02,100,50,0,90)
 *
 * NOTE: DISCRETE_SQUAREWFIX is used the same as DISCRETE_SQUAREWAVE.
 *       BUT... It does not stay in sync when you change the freq or
 *              duty values while enabled.  This should be used only
 *              when these values are stable while the wave is enabled.
 *              It takes up less CPU time then DISCRETE_SQUAREWAVE and
 *              should be used whenever possible.
 *
 * EXAMPLES: see Polaris
 *
 ***********************************************************************
 *
 * DISCRETE_SQUAREWAVE2 - Squarewave waveform generator node.
 *                        Waveform is defined by it's off/on time
 *                        periods.
 *
 *                        .------------.
 *                        |            |
 *    ENABLE     -0------>|            |
 *                        |            |
 *    AMPLITUDE  -1------>|            |
 *                        |            |
 *    OFF TIME   -2------>| SQUAREWAVE |---->   Netlist node
 *                        |            |
 *    ON TIME    -3------>|            |
 *                        |            |
 *    BIAS       -4------>|            |
 *                        |            |
 *    TIME SHIFT -5------>|            |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_SQUAREWAVE2(name of node,
 *                          enable node or static value,
 *                          amplitude node or static value,
 *                          off time node or static value in seconds,
 *                          on time node or static value in seconds,
 *                          dc bias value for waveform,
 *                          starting phase value in seconds)
 *
 *  Example config line
 *
 *   DISCRETE_SQUAREWAVE2(NODE_03,NODE_01,NODE_02,0.01,0.001,0.0,0.001)
 *
 ***********************************************************************
 *
 * DISCRETE_TRIANGLEW  - Triagular waveform generator, generates
 *                       equal ramp up/down at chosen frequency
 *
 *                        .------------.
 *                        |            |
 *    ENABLE     -0------>|            |
 *                        |            |
 *    FREQUENCY  -1------>|  TRIANGLE  |---->   Netlist node
 *                        |    WAVE    |
 *    AMPLITUDE  -2------>|            |
 *                        |            |
 *    BIAS       -3------>|            |
 *                        |            |
 *    PHASE      -4------>|            |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_TRIANGLEWAVE(name of node,
 *                         enable node or static value,
 *                         frequency node or static value,
 *                         amplitude node or static value,
 *                         dc bias value for waveform,
 *                         starting phase value in degrees)
 *
 *  Example config line
 *
 *     DISCRETE_TRIANGLEWAVE(NODE_03,1,5000,NODE_01,0.0,0.0)
 *
 ***********************************************************************
 =======================================================================
 * from from disc_wav.c
 * Component specific modules
 =======================================================================
 ***********************************************************************
 *
 * DISCRETE_OP_AMP_OSCILLATOR - Various single power supply op-amp oscillator circuits
 *
 *  Declaration syntax
 *
 *     DISCRETE_OP_AMP_OSCILLATOR(name of node,
 *                                enable node or static value,
 *                                address of dss_op_amp_osc_context structure)
 *
 *     discrete_op_amp_osc_info = {type, r1, r2, r3, r4, r5, r6, r7, r8, c, vP}
 *
 * Note: Set all unused components to 0.
 *
 *  Types:
 *
 *     DISC_OP_AMP_OSCILLATOR_1 | DISC_OP_AMP_IS_NORTON
 *          Basic Norton Op Amp Oscillator circuit.
 *
 *  vP >-.
 *       |         c
 *       Z     .---||----+---------------------------> DISC_OP_AMP_OSCILLATOR_OUT_CAP
 *       Z r1  |         |
 *       Z     |   |\    |
 *       |     |   | \   |            |\
 *       '-----+---|- \  |     r3     | \
 *                 |   >-+----ZZZZ----|- \
 *                 |+ /               |   >--+-------> DISC_OP_AMP_OSCILLATOR_OUT_SQW
 *             .---| /             .--|+ /   |
 *             |   |/        r5    |  | /    |
 *             |      vP >--ZZZZ---+  |/     |
 *             Z                   |         |
 *             Z r2                |   r4    |
 *             Z                   '--ZZZZ---+
 *             |                             |
 *             |                             |
 *             '-----------------------------'
 *
 * Note: R1 - R5 can be nodes.
 *
 * EXAMPLES: see Polaris, Amazing Maze
 *
 ***********************************************************************
 *
 * DISCRETE_OP_AMP_VCOn - Various single power supply op-amp VCO circuits
 *                   (n = 1 or 2)
 *
 *  Declaration syntax
 *
 *     DISCRETE_OP_AMP_VCOn(name of node,
 *                          enable node or static value,
 *                          modulation voltage 1 node or static value,
 *                          modulation voltage 2 node or static value,  [optional]
 *                          address of dss_op_amp_osc_context structure)
 *
 *     discrete_op_amp_osc_info = {type, r1, r2, r3, r4, r5, r6, r7, r8, c, vP}
 *
 * Note: Set all unused components to 0.
 *
 *  Types:
 *
 *     DISC_OP_AMP_OSCILLATOR_VCO_1
 *          Basic Op Amp Voltage Controlled Oscillator circuit.
 *          Note that this circuit has only 1 modulation voltage.
 *          So it is used only with DISCRETE_OP_AMP_VCO1.
 *
 *                               c
 *  .------------------------+---||----+---------------------------> DISC_OP_AMP_OSCILLATOR_OUT_CAP
 *  |                        |         |
 *  |                        |   |\    |
 *  |              r1        |   | \   |            |\
 *  | vMod1 >--+--ZZZZ-------+---|- \  |            | \
 *  |          |                 |   >-+------------|- \
 *  |          |   r2            |+ /               |   >--+-------> DISC_OP_AMP_OSCILLATOR_OUT_SQW
 *  Z          '--ZZZZ--+--------| /             .--|+ /   |
 *  Z r6                |        |/        r4    |  | /    |
 *  Z                   Z         vP/2 >--ZZZZ---+  |/     |
 *  |                   Z r5                     |         |
 * .----.               Z                        |   r3    |
 * | sw |<--------.     |                        '--ZZZZ---+
 * '----'         |    gnd                                 |
 *    |           |                                        |
 *   gnd          '----------------------------------------'
 *
 * Notes: The 'sw' block can be a transistor or 4066 switch.  It connects
 *        r6 to ground when 'sw' is high.
 *
 *          --------------------------------------------------
 *
 *     DISC_OP_AMP_OSCILLATOR_VCO_1 | DISC_OP_AMP_IS_NORTON
 *          Basic Norton Op Amp Voltage Controlled Oscillator circuit.
 *          When disabled, c discharges and sqw out goes high.
 *
 *                                             .---------------------------> DISC_OP_AMP_OSCILLATOR_OUT_CAP
 *                                       c     |
 *               r6                  .---||----+
 *        vP >--ZZZZ---.             |         |         r5    |\
 *                     |             |   |\    |  vP >--ZZZZ-. | \
 *               r7    |   r1        |   | \   |             '-|- \
 *     vMod1 >--ZZZZ---+--ZZZZ-------+---|- \  |     r3        |   >--+-------> DISC_OP_AMP_OSCILLATOR_OUT_SQW
 *                     |                 |   >-+----ZZZZ----+--|+ /   |
 *               r8    |   r2    .----.  |+ /               |  | /    |
 *     vMod2 >--ZZZZ---+--ZZZZ---| sw |--| /                |  |/     |
 *                               '----'  |/                 |         |
 *                                 ^ ^                      |   r4    |
 *                                 | |                      '--ZZZZ---+
 *                                 | |                                |
 *                Enable >---------' |                                |
 *                                   '--------------------------------'
 *
 * EXAMPLES: see Polaris
 *
 *          --------------------------------------------------
 *
 *     DISC_OP_AMP_OSCILLATOR_VCO_2 | DISC_OP_AMP_IS_NORTON
 *          Basic Norton Op Amp Voltage Controlled Oscillator circuit.
 *          Note that this circuit has only 1 modulation voltage.
 *          So it is used only with DISCRETE_OP_AMP_VCO1.
 *          When vMod1 goes to 0V, the oscillator is disabled.
 *          c fully charges and the sqw out goes low.
 *
 *                                             .---------------------------> DISC_OP_AMP_OSCILLATOR_OUT_CAP
 *                                             |
 *                                             |                 r4
 *                                       c     |             .--ZZZZ--.
 *                                   .---||----+             |        |
 *                                   |         |         r5  | |\     |
 *                                   |   |\    |  vP >--ZZZZ-+ | \    |
 *               r1                  |   | \   |             '-|+ \   |
 *     vMod1 >--ZZZZ-----------------+---|- \  |     r3        |   >--+-------> DISC_OP_AMP_OSCILLATOR_OUT_SQW
 *                                       |   >-+----ZZZZ-------|- /   |
 *               r2                      |+ /                  | /    |
 *        vP >--ZZZZ-----------------+---| /                   |/     |
 *                                   |   |/                           |
 *               r6      .----.      |                                |
 *        vP >--ZZZZ-----|-sw-|------'                                |
 *                       '----'                                       |
 *                          ^                                         |
 *                          |                                         |
 *                          '-----------------------------------------'
 *
 * EXAMPLES: see Double Play
 *
 *          --------------------------------------------------
 *
 *     DISC_OP_AMP_OSCILLATOR_VCO_3 | DISC_OP_AMP_IS_NORTON
 *          Basic Norton Op Amp Voltage Controlled Oscillator circuit.
 *
 *
 *                                  c
 *              r7              .---||----+---------------------------> DISC_OP_AMP_OSCILLATOR_OUT_CAP
 *       vP >--ZZZZ---.         |         |
 *                    |         |   |\    |
 *              r1    |         |   | \   |            |\
 *    vMod1 >--ZZZZ---+---------+---|- \  |     r3     | \
 *                    |             |   >-+----ZZZZ----|- \
 *              r6    |             |+ /               |   >--+-------> DISC_OP_AMP_OSCILLATOR_OUT_SQW
 *    vMod2 >--ZZZZ---'         .---| /             .--|+ /   |
 *                              |   |/        r5    |  | /    |
 *                              |      vP >--ZZZZ---+  |/     |
 *                              Z                   |         |
 *                              Z r2                |   r4    |
 *                              Z                   '--ZZZZ---+
 *                              |                             |
 *                              |                             |
 *                              '-----------------------------'
 *
 * EXAMPLES: see Space Encounter
 *
 ***********************************************************************
 *
 * DISCRETE_SCHMITT_OSCILLATOR - Schmitt Inverter gate oscillator
 *
 *                  rFeedback
 *                .---ZZZ----.                   .--< Amplitude
 *                |          |                   |
 *                |  |\      |      .------.     |
 *           rIn  |  | \     | 0/1  | AND/ |    .-.
 *  INP0 >---ZZZ--+--|S >o---+----->|NAND/ |--->|*|-----> Netlist Node
 *                |  | /            |  OR/ |    '-'
 *                |  |/          .->| NOR  |
 *               ---             |  '------'
 *               --- C           |
 *                |              ^
 *               gnd          Enable
 *
 *  Declaration syntax
 *
 *     DISCRETE_SCHMITT_OSCILLATOR(name of node,
 *                                 enable node or static value,
 *                                 Input 0 node or static value,
 *                                 Amplitude node or static value,
 *                                 address of discrete_schmitt_osc_desc structure)
 *
 *     discrete_schmitt_osc_desc = {rIn, rFeedback, c, trshRise, trshFall, vGate, options}
 *
 *  Note: trshRise, trshFall, vGate can be replaced with one of these common types:
 *        DEFAULT_7414_VALUES or DEFAULT_74LS14_VALUES  (the LS makes a difference)
 *    eg: {rIn, rFeedback, c, DEFAULT_7414_VALUES, options}
 *
 *  Where:
 *     trshRise is the voltage level that triggers the gate input to go high (vGate) on rise.
 *     trshFall is the voltage level that triggers the gate input to go low (0V) on fall.
 *     vGate    is the output high voltage of the gate that gets fedback through rFeedback.
 *
 *  Input Options:
 *     DISC_SCHMITT_OSC_IN_IS_LOGIC (DEFAULT)
 *     DISC_SCHMITT_OSC_IN_IS_VOLTAGE
 *
 *  Enable Options: (ORed with input options)
 *     DISC_SCHMITT_OSC_ENAB_IS_AND (DEFAULT)
 *     DISC_SCHMITT_OSC_ENAB_IS_NAND
 *     DISC_SCHMITT_OSC_ENAB_IS_OR
 *     DISC_SCHMITT_OSC_ENAB_IS_NOR
 *
 * EXAMPLES: see Fire Truck, Monte Carlo, Super Bug
 *
 ***********************************************************************
 *
 * DISCRETE_INVERTER_OSC - Inverter gate oscillator circuits
 *
 * TYPE 1/3
 *               .----------------------------> Netlist Node (Type 3)
 *               |
 *        |\     |  |\        |\
 *        | \    |  | \       | \
 *     +--|  >o--+--|-->o--+--|  >o--+--------> Netlist Node (Type 1)
 *     |  | /       | /    |  | /    |
 *     |  |/        |/     |  |/     |
 *     Z                   |         |
 *     Z RP               ---        |
 *     Z                  --- C      |
 *     |                   |     R1  |
 *     '-------------------+----ZZZ--'
 *
 * TYPE 2
 *
 *        |\        |\
 *        | \       | \
 *     +--|  >o--+--|-->o--+-------> Netlist Node
 *     |  | /    |  | /    |
 *     |  |/     |  |/     |
 *     Z         Z         |
 *     Z RP      Z R1     ---
 *     Z         Z        --- C
 *     |         |         |
 *     '---------+---------'
 *
 *
 * TYPE 4 / see vicdual
 *
 *                |\        |\
 *                | \       | \
 * Enable >-+-----+--|>o-+--|-->o--+-------> Netlist Node
 *          |     | /    |  | /    |
 *          |     |/     |  |/     |
 *          Z            Z         |
 *          Z RP         Z R1     ---
 *          Z            Z        --- C
 *          |       D    |         |
 *          '------|>|---+---------'
 *                       |
 * Mod    >-----ZZZ------'
 *               R2
 *
 * TYPE 5 / see vicdual
 *    Diode will cause inverted input behaviour and inverted output
 *
 *                |\        |\
 *                | \       | \
 * Enable >-+-----+--|>o-+--|-->o--+-------> Netlist Node
 *          |     | /    |  | /    |
 *          |     |/     |  |/     |
 *          Z            Z         |
 *          Z RP         Z R1     ---
 *          Z            Z        --- C
 *          |       D    |         |
 *          '------|<|---+---------'
 *                       |
 * Mod    >-----ZZZ------'
 *               R2
 *
 *  Declaration syntax
 *
 *     DISCRETE_INVERTER_OSC( name of node,
 *                            enable node or static value,
 *                            modulation node or static value (0 when not used),
 *                            R1 static value,
 *                            RP static value
 *                            C  static value,
 *                            R2 static value (0 when not used),
 *                            address of discrete_inverter_osc_desc structure)
 *
 *     discrete_inverter_osc_desc = {vB, vOutLow, vOutHigh, vInRise, vInFall, clamp, options}
 *
 *     Where
 *        vB       Supply Voltage
 *        vOutLow  Low Output voltage
 *        vOutHigh High Output voltage
 *        vInRise  voltage that triggers the gate input to go high (vGate) on rise
 *        vInFall  voltage that triggers the gate input to go low (0V) on fall
 *        clamp    internal diode clamp:  [-clamp ... vb+clamp] if clamp>= 0
 *        options  bitmaped options
 *
 *     There is a macro DEFAULT_CD40XX_VALUES(_vB) which may be used to initialize the
 *     structure with .... = { 5, DEFAULT_CD40XX_VALUES(5), DISC_OSC_INVERTER_IS_TYPE1}
 *
 *     The parameters are used to construct a input/output transfer function.
 *
 *     Option Values
 *
 *         DISC_OSC_INVERTER_IS_TYPE1
 *         DISC_OSC_INVERTER_IS_TYPE2
 *         DISC_OSC_INVERTER_IS_TYPE3
 *         DISC_OSC_INVERTER_IS_TYPE4
 *         DISC_OSC_INVERTER_OUT_IS_LOGIC
 *
 * EXAMPLES: see dkong
 *
 ***********************************************************************
 =======================================================================
 * from from disc_wav.c
 * Not yet implemented
 =======================================================================
 ***********************************************************************
 *
 * DISCRETE_ADSR_ENV  - Attack Decay Sustain Release envelope generator
 *
 * Note: Not yet implemented.
 *
 *                        .------------.
 *                        |            |
 *    ENABLE     -0------>|            |
 *                        |    /\__    |
 *    TRIGGER    -1------>|   /    \   |---->   Netlist node
 *                        |    ADSR    |
 *    GAIN       -2------>|    Env     |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_ADSR_ENV  (name of node,
 *                         enable node or static value,
 *                         envelope gain node or static value,
 *                         envelope descriptor struct)
 *
 *  Example config line
 *
 *     DISCRETE_ADSR_ENV(NODE_3,1,NODE_21,1.0,&adsrdesc)
 *
 ***********************************************************************
 =======================================================================
 * from from disc_mth.c
 * Generic modules
 =======================================================================
 ***********************************************************************
 *
 * DISCRETE_ADDER      - Node addition function, available in three
 *                       lovely flavours, ADDER2,ADDER3,ADDER4
 *                       that perform a summation of incoming nodes
 *
 *                        .------------.
 *                        |            |
 *    INPUT0     -0------>|            |
 *                        |            |
 *    INPUT1     -1------>|     |      |
 *                        |    -+-     |---->   Netlist node
 *    INPUT2     -2------>|     |      |
 *                        |            |
 *    INPUT3     -3------>|            |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_ADDERx    (name of node,
 *        (x=2/3/4)        enable node or static value,
 *                         input0 node or static value,
 *                         input1 node or static value,
 *                         input2 node or static value,  [optional]
 *                         input3 node or static value)  [optional]
 *
 *  Example config line
 *
 *     DISCRETE_ADDER2(NODE_03,1,NODE_12,-2000)
 *
 *  Always enabled, subtracts 2000 from the output of NODE_12
 *
 ***********************************************************************
 *
 * DISCRETE_CLAMP - Force a signal to stay within bounds MIN/MAX
 *
 *                        .------------.
 *                        |            |
 *    ENAB       -0------>|            |
 *                        |            |
 *    INP0       -1------>|            |
 *                        |            |
 *    MIN        -2------>|   CLAMP    |---->   Netlist node
 *                        |            |
 *    MAX        -3------>|            |
 *                        |            |
 *    CLAMP      -4------>|            |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *        DISCRETE_CLAMP(name of node,
 *                       enable,
 *                       input node,
 *                       minimum node or static value,
 *                       maximum node or static value,
 *                       clamp node or static value when disabled)
 *
 *  Example config line
 *
 *     DISCRETE_CLAMP(NODE_9,NODE_10,NODE_11,2.0,10.0,5.0)
 *
 *  Node10 when not zero will allow clamp to operate forcing the value
 *  on the node output, to be within the MIN/MAX boundard. When enable
 *  is set to zero the node will output the clamp value
 *
 ***********************************************************************
 *
 * DISCRETE_DIVIDE     - Node division function
 *
 *                        .------------.
 *                        |            |
 *    ENAB       -0------>|            |
 *                        |     o      |
 *    INPUT1     -1------>|    ---     |---->   Netlist node
 *                        |     o      |
 *    INPUT2     -2------>|            |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_DIVIDE    (name of node,
 *                         enable node or static value,
 *                         input0 node or static value,
 *                         input1 node or static value)
 *
 *  Example config line
 *
 *     DISCRETE_DIVIDE(NODE_03,1.0,NODE_12,50.0)
 *
 *  Always enabled, divides the input NODE_12 by 50.0. Note that a
 *  divide by zero condition will give a LARGE number output, it
 *  will not stall the machine or simulation. It will also attempt
 *  to write a divide by zero error to the Mame log if enabled.
 *
 ***********************************************************************
 *
 * DISCRETE_LOGIC_INVERT - Logic invertor
 * DISCRETE_LOGIC_AND  - Logic AND gate (3 & 4 input also available)
 * DISCRETE_LOGIC_NAND - Logic NAND gate (3 & 4 input also available)
 * DISCRETE_LOGIC_OR   - Logic OR gate (3 & 4 input also available)
 * DISCRETE_LOGIC_NOR  - Logic NOR gate (3 & 4 input also available)
 * DISCRETE_LOGIC_XOR  - Logic XOR gate
 * DISCRETE_LOGIC_NXOR - Logic NXOR gate
 *
 *                        .------------.
 *                        |            |
 *    ENAB       -0------>|            |
 *                        |            |
 *    INPUT0     -0------>|            |
 *                        |   LOGIC    |
 *    [INPUT1]   -1------>|  FUNCTION  |---->   Netlist node
 *                        |    !&|^    |
 *    [INPUT2]   -2------>|            |
 *                        |            |
 *    [INPUT3]   -3------>|            |
 *                        |            |
 *    [] - Optional       '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_LOGIC_XXXn(name of node,
 *      (X=INV/AND/etc)    enable node or static value,
 *      (n=Blank/2/3)      input0 node or static value,
 *                         [input1 node or static value],
 *                         [input2 node or static value],
 *                         [input3 node or static value])
 *
 *  Example config lines
 *
 *     DISCRETE_LOGIC_INVERT(NODE_03,1,NODE_12)
 *     DISCRETE_LOGIC_AND(NODE_03,1,NODE_12,NODE_13)
 *     DISCRETE_LOGIC_NOR4(NODE_03,1,NODE_12,NODE_13,NODE_14,NODE_15)
 *
 *  Node output is always either 0.0 or 1.0 any input value !=0.0 is
 *  taken as a logic 1.
 *
 ***********************************************************************
 *
 * DISCRETE_LOGIC_DFLIPFLOP - Standard D-type flip-flop.
 *                            Changes on rising edge of clock.
 *
 *    /SET       -2 ------------.
 *                              v
 *                        .-----o------.
 *                        |            |
 *    DATA       -4 ----->|            |
 *                        |  FLIPFLOP  |
 *                        |           Q|---->    Netlist node
 *                        |            |
 *    CLOCK      -3 ----->|            |
 *                        |            |
 *                        '-----o------'
 *                              ^
 *    /RESET     -1 ------------'
 *
 *  Declaration syntax
 *
 *       DISCRETE_LOGIC_DFLIPFLOP(name of node,
 *                                enable node or static value,
 *                                reset node or static value,
 *                                set node or static value,
 *                                clock node,
 *                                data node or static value)
 *
 *  Example config line
 *
 *     DISCRETE_LOGIC_DFLIPFLOP(NODE_7,1,NODE_17,0,NODE_13,1)
 *
 *  A flip-flop that clocks a logic 1 through on the rising edge of
 *  NODE_13. A logic 1 on NODE_17 resets the output to 0.
 *
 * EXAMPLES: see Hit Me, Polaris
 *
 ***********************************************************************
 *
 * DISCRETE_LOGIC_JKFLIPFLOP - Standard JK-type flip-flop.
 *                             Changes on falling edge of clock.
 *
 *    /SET       -2 ------------.
 *                              v
 *                        .-----o------.
 *                        |            |
 *    J          -4 ----->|            |
 *                        |  FLIPFLOP  |
 *    CLOCK      -3 ----->|           Q|---->    Netlist node
 *                        |            |
 *    K          -5 ----->|            |
 *                        |            |
 *                        '-----o------'
 *                              ^
 *    /RESET     -1 ------------'
 *
 *  Declaration syntax
 *
 *       DISCRETE_LOGIC_JKFLIPFLOP(name of node,
 *                                 enable node or static value,
 *                                 reset node or static value,
 *                                 set node or static value,
 *                                 clock node,
 *                                 J node or static value,
 *                                 K node or static value)
 *
 * EXAMPLES: see Amazing Maze
 *
 ***********************************************************************
 *
 * DISCRETE_LOOKUP_TABLE - returns the value in a table
 *
 *  Declaration syntax
 *
 *       DISCRETE_LOOKUP_TABLE(name of node,
 *                             enable node or static value,
 *                             address node,
 *                             size of table static value,
 *                             address of table of double values)
 *
 ***********************************************************************
 *
 * DISCRETE_MULTIPLEX - 1 of 2/4/8 multiplexer
 *
 *                 .-------------.
 *   Input 0 >-----|>-<.         |
 *                 |    \        |
 *   Input 1 >-----|>-   \       |
 *                 |      \      |
 *   Input 2 >-----|>-    |\     |
 *                 |      | \    |
 *   Input 3 >-----|>-    |  o-->|------> Netlist Node
 *                 |      |      |
 *   Input 4 >-----|>-    |      |
 *                 |      |      |
 *   Input 5 >-----|>-    '------|----< Address
 *                 |             |     (0 shown)
 *   Input 6 >-----|>-           |
 *                 |             |
 *   Input 7 >-----|>-           |
 *                 '-------------'
 *
 *  Declaration syntax
 *
 *       DISCRETE_MULTIPLEXx(name of node,
 *           (x=2/4/8)       enable node or static value,
 *                           address node,
 *                           input 0 node or static value,
 *                           input 1 node or static value, ...)
 *
 ***********************************************************************
 *
 * DISCRETE_GAIN       - Node multiplication function output is equal
 * DISCRETE_MULTIPLY     to INPUT0 * INPUT1
 * DISCRETE_MULTADD      to (INPUT0 * INPUT1) + INPUT 2
 *
 *                        .------------.
 *                        |            |
 *    ENAB       -0------>|            |
 *                        |            |
 *    INPUT0     -1------>|     \|/    |
 *                        |     -+-    |---->   Netlist node
 *    INPUT1     -2------>|     /|\    |
 *                        |            |
 *    INPUT2     -3------>|            |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_MULTIPLY  (name of node,
 *                         enable node or static value,
 *                         input0 node or static value,
 *                         input1 node or static value)
 *
 *     DISCRETE_MULTADD   (name of node,
 *                         enable node or static value,
 *                         input0 node or static value,
 *                         input1 node or static value,
 *                         input2 node or static value)
 *
 *     DISCRETE_GAIN      (name of node,
 *                         input0 node or static value,
 *                         static value for gain)
 *  Example config line
 *
 *     DISCRETE_GAIN(NODE_03,NODE_12,112.0)
 *
 *  Always enabled, multiplies the input NODE_12 by 112.0
 *
 ***********************************************************************
 *
 * DISCRETE_ONESHOT    - Monostable multivibrator, no reset
 * DISCRETE_ONESHOTR   - Monostable multivibrator, with reset
 *
 *  Declaration syntax
 *
 *     DISCRETE_ONESHOT   (name of node,
 *                         trigger node,
 *                         amplitude node or static value,
 *                         width (in seconds) node or static value,
 *                         type of oneshot static value)
 *
 *     DISCRETE_ONESHOTR  (name of node,
 *                         reset node or static value,
 *                         trigger node,
 *                         amplitude node or static value,
 *                         width (in seconds) node or static value,
 *                         type of oneshot static value)
 *
 *  Types:
 *
 *     DISC_ONESHOT_FEDGE    0x00 - trigger on falling edge (DEFAULT)
 *     DISC_ONESHOT_REDGE    0x01 - trigger on rising edge
 *
 *     DISC_ONESHOT_NORETRIG 0x00 - non-retriggerable (DEFAULT)
 *     DISC_ONESHOT_RETRIG   0x02 - retriggerable
 *
 *     DISC_OUT_ACTIVE_LOW   0x04 - output active low
 *     DISC_OUT_ACTIVE_HIGH  0x00 - output active high (DEFAULT)
 *
 *  NOTE: A width of 0 seconds will output a pulse of 1 sample.
 *        This is useful for a guaranteed minimun pulse, regardless
 *        of the sample rate.
 *
 * EXAMPLES: see Polaris
 *
 ***********************************************************************
 *
 * DISCRETE_RAMP - Ramp up/down circuit with clamps & reset
 *
 *                        .------------.
 *                        |            |
 *    ENAB       -0------>| FREE/CLAMP |
 *                        |            |
 *    RAMP       -1------>| FW/REV     |
 *                        |            |
 *    GRAD       -2------>| Grad/sec   |
 *                        |            |---->   Netlist node
 *    START      -3------>| Start clamp|
 *                        |            |
 *    END        -4------>| End clamp  |
 *                        |            |
 *    CLAMP      -5------>| off clamp  |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *         DISCRETE_RAMP(name of node,
 *                       enable,
 *                       ramp forward/reverse node (or value),
 *                       gradient node (or static value),
 *                       start node or static value,
 *                       end node or static value,
 *                       clamp node or static value when disabled)
 *
 *  Example config line
 *
 *     DISCRETE_RAMP(NODE_9,NODE_10,NODE_11,10.0,-10.0,10.0,0)
 *
 *  Node10 when not zero will allow ramp to operate, when 0 then output
 *  is clamped to clamp value specified. Node11 ramp when 0 change
 *  gradient from start to end. 1 is reverse. Output is clamped to max-
 *  min values. Gradient is specified in change/second.
 *
 ***********************************************************************
 *
 * DISCRETE_SAMPHOLD - Sample & Hold circuit
 *
 *                        .------------.
 *                        |            |
 *    ENAB       -0------>|            |
 *                        |            |
 *    INP0       -1------>|   SAMPLE   |
 *                        |     &      |----> Netlist node
 *    CLOCK      -2------>|    HOLD    |
 *                        |            |
 *    CLKTYPE    -3------>|            |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_SAMPHOLD(name of node,
 *                       enable,
 *                       input node,
 *                       clock node or static value,
 *                       input clock type)
 *
 *  Example config line
 *
 *     DISCRETE_SAMPHOLD(NODE_9,1,NODE_11,NODE_12,DISC_SAMPHOLD_REDGE)
 *
 *  Node9 will sample the input node 11 on the rising edge (REDGE) of
 *  the input clock signal of node 12.
 *
 *   DISC_SAMPHOLD_REDGE  - Rising edge clock
 *   DISC_SAMPHOLD_FEDGE  - Falling edge clock
 *   DISC_SAMPHOLD_HLATCH - Output is latched whilst clock is high
 *   DISC_SAMPHOLD_LLATCH - Output is latched whilst clock is low
 *
 ***********************************************************************
 *
 * DISCRETE_SWITCH     - Node switch function, output node is switched
 *                       by switch input to take one node/contst or
 *                       other. Can be nodes or constants.
 *
 *    SWITCH     -0--------------.
 *                               V
 *                        .------------.
 *                        |      |     |
 *    INPUT0     -1------}|----o       |
 *                        |       .--- |---->   Netlist node
 *    INPUT1     -2------>|----o /     |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_SWITCH    (name of node,
 *                         enable node or static value,
 *                         switch node or static value,
 *                         input0 node or static value,
 *                         input1 node or static value)
 *
 *  Example config line
 *
 *     DISCRETE_SWITCH(NODE_03,1,NODE_10,NODE_90,5.0)
 *
 *  Always enabled, NODE_10 switches output to be either NODE_90 or
 *  constant value 5.0. Switch==0 inp0=output else inp1=output
 *
 ***********************************************************************
 *
 * DISCRETE_ASWITCH     - Node switch function, output node is same
 *                        as input when CTRL is above threshold.
 *
 *    CTRL       -0--------------.
 *                               V
 *                        .------------.
 *                        |      |     |
 *    INPUT0     -1------ |----- . --- |---->   Netlist node
 *                        |            |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_ASWITCH   (name of node,
 *                         enable node or static value,
 *                         ctrl node or static value,
 *                         input node or static value,
 *                         threshold satic value )
 *
 *  Example config line
 *
 *     DISCRETE_ASWITCH(NODE_03,1,NODE_10,NODE_90, 2.73)
 *
 *  Always enabled, NODE_10 switches output to be either NODE_90 or
 *  constant value 0.0. Ctrl>2.73 output=NODE_90 else output=0
 *
 ***********************************************************************
 *
 * DISCRETE_TRANSFORMn - Node arithmatic logic (postfix arithmatic)
 *     (n=2,3,4,5)
 *                        .------------.
 *                        |            |
 *    INPUT0     -0------>|            |
 *                        |            |
 *    INPUT1     -1------>|  Postfix   |
 *                        |   stack    |----> Netlist node
 *    INPUT2     -2------>|   maths    |
 *                        |            |
 *    INPUT3     -3------>|            |
 *                        |            |
 *    INPUT4     -4------>|            |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_TRANSFORMn(name of node,
 *                         input0 node or static value,
 *                         input1 node or static value,
 *                         input2 node or static value,  [optional]
 *                         input3 node or static value,  [optional]
 *                         input4 node or static value,  [optional]
 *                         maths string)
 *
 *  Example config line
 *
 *  DISCRETE_TRANSFORM4(NODE_12,NODE_22,50.0,120.0,33.33,"01*2+3/")
 *
 *  Arithmetic uses stack based arithmetic similar to Forth, the maths
 *  has 5 registers 0-4 and various arithmetic operations. The math
 *  string is processed from left to right in the following manner:
 *   0 - Push input 0 to stack
 *   1 - Push input 1 to stack
 *   2 - Push input 2 to stack
 *   3 - Push input 3 to stack
 *   4 - Push input 4 to stack
 *   - - Pop two values from stack, subtract and push result to stack
 *   + - Pop two values from stack, add and push result to stack
 *   / - Pop two values from stack, divide and push result to stack
 *   * - Pop two values from stack, multiply and push result to stack
 *   i - Pop one value from stack, multiply -1 and push result to stack
 *   ! - Pop one value from stack, logical invert, push result to stack
 *   = - Pop two values from stack, logical = and push result to stack
 *   > - Pop two values from stack, logical > and push result to stack
 *   < - Pop two values from stack, logical < and push result to stack
 *   & - Pop two values from stack, binary AND and push result to stack
 *   | - Pop two values from stack, binary OR and push result to stack
 *   ^ - Pop two values from stack, binary XOR and push result to stack
 *   P - Push a duplicate of the last stack value back on the stack
 *
 * EXAMPLES: see Polaris
 *
 ***********************************************************************
 =======================================================================
 * from from disc_mth.c
 * Component specific modules
 =======================================================================
 ***********************************************************************
 *
 * DISCRETE_COMP_ADDER - Selecatable parallel component adder.
 *                       The total netlist out will be the parallel sum of all
 *                       components with their corresponding data bit = 1.
 *                       Set cDefault to 0 if not used.
 *
 *         common >---cDefault---.
 *      data&0x01 >-----c[0]-----+
 *      data&0x02 >-----c[1]-----+
 *      data&0x04 >-----c[2]-----+
 *      data&0x08 >-----c[3]-----+-----> netlist node
 *      data&0x10 >-----c[4]-----+
 *      data&0x20 >-----c[5]-----+
 *      data&0x40 >-----c[6]-----+
 *      data&0x80 >-----c[7]-----'
 *
 *  Declaration syntax
 *
 *     DISCRETE_COMP_ADDER(name of node,
 *                         data node (static value is useless),
 *                         address of discrete_comp_adder_table structure)
 *
 *     discrete_comp_adder_table = {type, cDefault, length, c{}}
 *          note: length can be a maximum of 8
 *
 *  Circuit Types:
 *     DISC_COMP_P_CAPACITOR - parallel capacitors
 *     DISC_COMP_P_RESISTOR  - parallel resistors
 *
 * EXAMPLES: see Hit Me
 *
 ***********************************************************************
 *
 * DISCRETE_DAC_R1 - R1 ladder DAC with cap smoothing and external bias
 *
 *                             rBias
 * data&0x01 >--/\R[0]/\--+-----/\/\----< vBias
 * data&0x02 >--/\R[1]/\--|
 * data&0x04 >--/\R[2]/\--|
 * data&0x08 >--/\R[3]/\--|
 * data&0x10 >--/\R[4]/\--|
 * data&0x20 >--/\R[5]/\--|
 * data&0x40 >--/\R[6]/\--|
 * data&0x80 >--/\R[7]/\--+-------------+-----> Netlist node
 *                        |             |
 *                        Z            ---
 *                        Z rGnd       --- cFilter
 *                        |             |
 *                       gnd           gnd
 *
 * NOTES: rBias and vBias are used together.  If not needed they should
 *        be set to 0.  If used, they should both have valid values.
 *        rGnd and cFilter should be 0 if not needed.
 *        A resistor value should be properly set for each resistor
 *        up to the ladder length.  Remember 0 is a short circuit.
 *        The data node is bit mapped to the ladder. valid int 0-255.
 *        TTL logic 0 is actually 0.2V but 0V is used.  The other parts
 *        have a tolerance that more then makes up for this.
 *
 *  Declaration syntax
 *
 *     DISCRETE_DAC_R1(name of node,
 *                     enable node or static value,
 *                     data node (static value is useless),
 *                     vData node or static value (voltage when a bit is on ),
 *                     address of discrete_dac_r1_ladder structure)
 *
 *     discrete_dac_r1_ladder = {ladderLength, r{}, vBias, rBias, rGnd, cFilter}
 *
 *  Note: Resistors in the ladder that are set to 0, will be handled like they
 *        are out of circuit.  So the bit selecting them will have no effect
 *        on the DAC output voltage.
 *
 * x_time - this modules automatically handles any non-integer value
 *          on the data input as x_time.
 *
 * EXAMPLES: see Fire Truck, Monte Carlo, Super Bug, Polaris
 *
 ***********************************************************************
 *
 * DISCRETE_DIODE_MIXER - mixes inputs through diodes
 *
 *
 *    input 0 >----|>|---.
 *                       |
 *    input 1 >----|>|---+----------> Netlist Node
 *                       |
 *    input 2 >----|>|---+
 *                       |
 *    input 3 >----|>|---+--/\/\/\--.
 *                                  |
 *                                 gnd
 *
 *  Declaration syntax
 *
 *     DISCRETE_DIODE_MIXERx(name of node,
 *         (x = 2/3/4)       input 0 node,
 *                           input 1 node,
 *                           ...,
 *                           address of v_junction table)
 *
 *    v_junction table can be set to NULL if you want all diodes to
 *                     default to a 0.5V drop.  Otherwise use a
 *                     table of doubles to specify juntion voltages.
 *
 * EXAMPLES: see dkong
 *
 ***********************************************************************
 *
 * DISCRETE_INTEGRATE - Various Integration circuits
 *
 *  Declaration syntax
 *
 *     DISCRETE_INTEGRATE(name of node,
 *                        trigger 0 node or static value,
 *                        trigger 1 node or static value,
 *                        address of discrete_integrate_info)
 *
 *     discrete_integrate_info = {type, r1, r2, r3, c, v1, vP, f0, f1, f2}
 *
 * Note: Set all unused components to 0.
 *       These are all single supply circuits going from gnd(0V) to vP(B+),
 *       so be sure to specify the vP power source.
 *
 *  Types:
 *
 *     DISC_INTEGRATE_OP_AMP_1
 *
 *       v1 >----+-------.
 *               |       |           c
 *               Z       Z      .---||----.
 *               Z r1    Z r2   |         |
 *               Z       Z      |  |\     |
 *               |       |      |  | \    |
 *               +--------------+--|- \   |
 *               |       |         |   >--+----> Netlist Node
 *              /        +---------|+ /
 *            |/         |         | /
 *   Trig0 >--| NPN      Z         |/
 *            |\         Z r3
 *              >        Z
 *               |       |
 *              gnd     gnd
 *
 *
 * EXAMPLES: see Tank8
 *
 *          --------------------------------------------------
 *
 *     DISC_INTEGRATE_OP_AMP_1 | DISC_OP_AMP_IS_NORTON
 *
 *                               c
 *                          .---||----.
 *                          |         |
 *                          |  |\     |
 *               r1         |  | \    |
 *      v1 >----ZZZZ--------+--|- \   |
 *                             |   >--+----> Netlist Node
 *               r2         .--|+ /
 *   Trig0 >----ZZZZ--------'  | /
 *                             |/
 *
 * Note: Trig0 is voltage level, not logic.
 *       No functions are used so set them to 0, or DISC_OP_AMP_TRIGGER_FUNCTION_NONE.
 *       You can also use DISCRETE_OP_AMP with type DISC_OP_AMP_IS_NORTON to emulate this.
 *
 * EXAMPLES: see Double Play
 *
 *          --------------------------------------------------
 *
 *     DISC_INTEGRATE_OP_AMP_2 | DISC_OP_AMP_IS_NORTON
 *
 *                                       c
 *                                  .---||----.
 *            r1a                   |         |
 *   v1 >----ZZZZ---.               |  |\     |
 *          .----.  |   r1b   Diode |  | \    |
 *          | F0 |--+--ZZZZ----|>|--+--|- \   |
 *          '----'                     |   >--+----> Netlist Node
 *            r2a       r2b         .--|+ /
 *   v1 >----ZZZZ---+--ZZZZ---------+  | /
 *          .----.  |               |  |/
 *          | F1 |--'               |
 *          '----'                  |
 *            r3a       r3b   Diode |
 *   v1 >----ZZZZ---+--ZZZZ----|>|--'
 *          .----.  |
 *          | F2 |--'
 *          '----'
 *
 * Note: For an explanation of the functions and trigger inputs,
 *       see DISCRETE_OP_AMP_TRIG_VCA below.
 *
 * EXAMPLES: see Polaris
 *
 ***********************************************************************
 *
 * DISCRETE_MIXER - Mixes multiple input signals.
 *
 *  Declaration syntax
 *
 *     DISCRETE_MIXERx(name of node,
 *      (x = 2 to 8)   enable node or static value,
 *                     input 0 node,
 *                     input 1 node,
 *                     input 2 node,  (if used)
 *                     input 3 node,  (if used)
 *                     input 4 node,  (if used)
 *                     input 5 node,  (if used)
 *                     input 6 node,  (if used)
 *                     input 7 node,  (if used)
 *                     address of discrete_mixer_info structure)
 *
 *     discrete_mixer_desc = {type, r{}, r_node{}, c{}, rI, rF, cF, cAmp, vRef, gain}
 *
 * Note: Set all unused components to 0.
 *       If an rNode is not used it should also be set to 0.
 *
 *  Types:
 *
 *     DISC_MIXER_IS_RESISTOR
 *
 *       rNode[0]   r[0]   c[0]
 *  IN0 >--zzzz-----zzzz----||---.
 *                               |
 *       rNode[1]   r[1]   c[1]  |
 *  IN1 >--zzzz-----zzzz----||---+--------.
 *   .      .        .      .    |        |      cAmp
 *   .      .        .      .    |        Z<------||---------> Netlist Node
 *   .      .        .      .    |        Z
 *   .   rNode[7]   r[7]   c[7]  |        Z rF
 *  IN7 >--zzzz-----zzzz----||---+        |
 *                               |        |
 *                              ---       |
 *                           cF ---       |
 *                               |        |
 *                              gnd      gnd
 *
 *  Note: The variable resistor is used in it's full volume position.
 *        MAME's built in volume is used for adjustment.
 *
 * EXAMPLES: see Polaris, Super Bug
 *
 *          --------------------------------------------------
 *
 *     DISC_MIXER_IS_OP_AMP
 *
 *                                               cF
 *                                          .----||---.
 *                                          |         |
 *        rNode[0]    r[0]   c[0]           |    rF   |
 *   IN0 >--zzzz------zzzz----||---.        +---ZZZZ--+
 *                                 |        |         |
 *        rNode[1]    r[1]   c[1]  |   rI   |  |\     |
 *   IN1 >--zzzz------zzzz----||---+--zzzz--+  | \    |
 *    .      .         .      .    |        '--|- \   |  cAmp
 *    .      .         .      .    |           |   >--+---||-----> Netlist Node
 *    .      .         .      .    |        .--|+ /
 *    .   rNode[7]    r[7]   c[7]  |        |  | /
 *   IN7 >--zzzz------zzzz----||---'        |  |/
 *                                          |
 *  vRef >----------------------------------'
 *
 * Note: rI is not always used and should then be 0.
 *
 * EXAMPLES: see Fire Truck, Monte Carlo
 *
 ***********************************************************************
 *
 * DISCRETE_OP_AMP - Various op-amp circuits
 *
 *  Declaration syntax
 *
 *     DISCRETE_OP_AMP(name of node,
 *                     enable node or static value,
 *                     input 0 node or static value,
 *                     input 1 node or static value,
 *                     address of discrete_op_amp_info structure)
 *
 *     discrete_op_amp_info = {type, r1, r2, r3, r4, c, vN, vP}
 *
 * Note: Set all unused components to 0.
 *
 *  Types:
 *
 *     DISC_OP_AMP_IS_NORTON
 *
 *                            c
 *                      .----||---.
 *                      |         |
 *             r3       |    r4   |       vP = B+
 *     vP >---ZZZZ------+---ZZZZ--+       vN = B-
 *                      |         |
 *             r1       |  |\     |       Note: r2 must always be used
 *    IN0 >---ZZZZ------+  | \    |
 *                      '--|- \   |
 *             r2          |   >--+-----> Netlist Node
 *    IN1 >---ZZZZ---------|+ /
 *                         | /
 *                         |/
 *
 * EXAMPLES: see Space Encounter
 *
 ***********************************************************************
 *
 * DISCRETE_OP_AMP_ONESHOT - Various op-amp one shot circuits
 *
 *  Declaration syntax
 *
 *     DISCRETE_OP_AMP_ONESHOT(name of node,
 *                             trigger node (voltage level),
 *                             address of discrete_op_amp_1sht_info structure)
 *
 *     discrete_op_amp_1sht_info = {type, r1, r2, r3, r4, r5, c1, c2, vN, vP}
 *
 *  Types:
 *
 *     DISC_OP_AMP_1SHT_1 | DISC_OP_AMP_IS_NORTON
 *
 *             c1       .---|>|---.
 *    gnd >----||---+---+         |
 *                  |   |    r4   |       vP = B+
 *                  Z   '---ZZZZ--+       vN = B-
 *                  Z r3          |
 *                  Z      |\     |       Note: all components must be used
 *             r1   |      | \    |             The oneshot is cancelled when TRIG goes low
 *     vP >---ZZZZ--+------|- \   |
 *                         |   >--+-----> Netlist Node
 *           c2    r2   .--|+ /   |
 *   TRIG >--||---ZZZZ--+  | /    |
 *                      |  |/     |
 *                      |    r5   |
 *                      '---ZZZZ--'
 *
 *
 * EXAMPLES: see Space Encounter
 *
 ***********************************************************************
 *
 * DISCRETE_OP_AMP_TRIG_VCA - Triggered Norton op amp voltage controlled amplifier.
 *                            This means the cap is rapidly charged thru r5 when F2=1.
 *                            Then it discharges thru r6+r7 when F2=0.
 *                            This voltage controls the amplitude.
 *                            While the diagram looks complex, usually only parts of it are used.
 *
 *  Declaration syntax
 *
 *     DISCRETE_OP_AMP_TRIG_VCA(name of node,
 *                              trigger 0 node or static value,
 *                              trigger 1 node or static value,
 *                              trigger 2 node or static value,
 *                              input 0 node or static value,
 *                              input 1 node or static value,
 *                              address of discrete_op_amp_tvca_info structure)
 *
 *     discrete_op_amp_tvca_info = { r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, c1, c2, c3, v1, v2, v3, vP, f0, f1, f2, f3, f4, f5}
 *
 * Note: Set all unused components to 0.
 *       Set all unused functions to DISC_OP_AMP_TRIGGER_FUNCTION_NONE
 *       Set all unused nodes to NODE_NC.
 *       If function F3 is not used then set r6=0 and use only r7.
 *       r2 = r2a + r2b.  r3 = r3a + r3b.
 *       vP is the op-amp B+.
 *
 *             r2a
 *   IN0 >----ZZZZ-----.               r1
 *           .----.    |     vP >------ZZZZ---.
 *           | F0 |----+                      |
 *           '----'    |                r2b   |    r4
 *             r3a     '---------------ZZZZ---+---ZZZZ--.
 *   IN1 >----ZZZZ---.                        |         |
 *           .----.  |                  r3b   |  |\     |
 *           | F1 |--+-----------------ZZZZ---+  | \    |
 *           '----'                           '--|- \   |
 *           .----.    diode     r6        r7    |   >--+----> Netlist Node
 *           | F2 |--+--|>|--+--ZZZZ---+--ZZZZ-+-|+ /
 *           '----'  |       |         |       | | /
 *                   |      ---      .----.    | |/
 *             r5    |      --- c1   | F3 |    |
 *    v1 >----ZZZZ---'       |       '----'    |
 *                          gnd                |
 *                                             |
 *           .----.    diode               r9  |
 *           | F4 |--+--|>|-----------+---ZZZZ-+
 *           '----'  |           c2   |        |
 *             r8    |   gnd >---||---'        |
 *    v2 >----ZZZZ---'                         |
 *           .----.    diode               r11 |
 *           | F5 |--+--|>|-----------+---ZZZZ-'
 *           '----'  |           c3   |
 *             r10   |   gnd >---||---'
 *    v3 >----ZZZZ---'
 *
 *  Function types:
 *
 *   Trigger 0, 1 and 2 are used for the functions F0 - F5.
 *   When the output of the function is 0, then the connection is held at 0V or gnd.
 *   When the output of the function is 1, then the function is an open circuit.
 *
 *   DISC_OP_AMP_TRIGGER_FUNCTION_NONE       - Not used, cicuit open.
 *   DISC_OP_AMP_TRIGGER_FUNCTION_TRG0       - Gnd when trigger 0 is 0.
 *   DISC_OP_AMP_TRIGGER_FUNCTION_TRG0_INV   - Gnd when trigger 0 is 1.
 *   DISC_OP_AMP_TRIGGER_FUNCTION_TRG1       - Gnd when trigger 1 is 0.
 *   DISC_OP_AMP_TRIGGER_FUNCTION_TRG1_INV   - Gnd when trigger 1 is 1.
 *   DISC_OP_AMP_TRIGGER_FUNCTION_TRG2       - Gnd when trigger 2 is 0.
 *   DISC_OP_AMP_TRIGGER_FUNCTION_TRG2_INV   - Gnd when trigger 2 is 1.
 *   DISC_OP_AMP_TRIGGER_FUNCTION_TRG01_AND  - Gnd when trigger 0 or 1 are 0.
 *   DISC_OP_AMP_TRIGGER_FUNCTION_TRG01_NAND - Gnd when trigger 0 and 1 are 1.
 *
 * EXAMPLES: see Polaris
 *
 ***********************************************************************
 =======================================================================
 * from from disc_flt.c
 * Generic modules
 =======================================================================
 ***********************************************************************
 *
 * DISCRETE_FILTER1
 *
 *  Declaration syntax
 *
 *     DISCRETE_FILTER1(name of node,
 *                      enable node or static value,
 *                      input node,
 *                      filter center frequency static value,
 *                      filter type static value)
 *
 *  Filter types: DISC_FILTER_LOWPASS,
 *                DISC_FILTER_HIGHPASS
 *                DISC_FILTER_BANDPASS
 *
 ***********************************************************************
 *
 * DISCRETE_FILTER2
 *
 *  Declaration syntax
 *
 *     DISCRETE_FILTER2(name of node,
 *                      enable node or static value,
 *                      input node,
 *                      filter center frequency static value,
 *                      damp static value,
 *                      filter type static value)
 *
 *  Filter types: DISC_FILTER_LOWPASS,
 *                DISC_FILTER_HIGHPASS
 *                DISC_FILTER_BANDPASS
 *
 * Note: Damp = 1/Q
 *
 ***********************************************************************
 =======================================================================
 * from from disc_flt.c
 * Component specific modules
 =======================================================================
 ***********************************************************************
 *
 * DISCRETE_CRFILTER - Simple single pole CR filter network (vRef = 0)
 * DISCRETE_CRFILTER_VREF - Same but refrenced to vRef not 0V
 *
 *                        .------------.
 *                        |            |
 *    ENAB       -0------}| CR FILTER  |
 *                        |            |
 *    INPUT1     -1------}| --| |-+--  |
 *                        |   C   |    |----}   Netlist node
 *    RVAL       -2------}|       Z    |
 *                        |       Z R  |
 *    CVAL       -3------}|       |    |
 *                        |      vRef  |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_CRFILTER(name of node,
 *                       enable
 *                       input node (or value)
 *                       resistor value in OHMS
 *                       capacitor value in FARADS)
 *
 *     DISCRETE_CRFILTER_VREF(name of node,
 *                            enable
 *                            input node (or value)
 *                            resistor value in OHMS
 *                            capacitor value in FARADS,
 *                            vRef static value)
 *
 *  Example config line
 *
 *     DISCRETE_CRFILTER(NODE_11,1,NODE_10,100,CAP_U(1))
 *
 *  Defines an always enabled CR filter with a 100R & 1uF network
 *  the input is fed from NODE_10.
 *
 *  This can be also thought of as a high pass filter with a 3dB cutoff
 *  at:
 *                                  1
 *            Fcuttoff =      --------------
 *                            2*Pi*RVAL*CVAL
 *
 *  (3dB cutoff is where the output power has dropped by 3dB ie Half)
 *
 ***********************************************************************
 *
 *  DISCRETE_OP_AMP_FILTER - Various Op Amp Filters.
 *
 *  Declaration syntax
 *
 *      DISCRETE_OP_AMP_FILTER(name of node,
 *                             enable node or static value,
 *                             input 1 node or static value,
 *                             input 2 node or static value,
 *                             type static value,
 *                             address of discrete_op_amp_filt_info)
 *
 *      discrete_op_amp_filt_info = {r1, r2, r3, r4, rF, c1, c2, c3, vRef, vP, vN}
 *
 * Note: Set all unused components to 0.
 *       vP and vN are the +/- op-amp power supplies.
 *       vRef is 0 if Gnd.
 *
 *  Types:
 *
 *     DISC_OP_AMP_FILTER_IS_LOW_PASS_1
 *          First Order Low Pass Filter
 *
 *                              c1
 *                      .-------||---------.
 *                      |                  |
 *          r1          |       rF         |
 *  IN0 >--ZZZZ--.      +------ZZZZ--------+
 *               |      |                  |
 *          r2   |      |           |\     |
 *  IN1 >--ZZZZ--+------+--------+  | \    |
 *               |               '--|- \   |
 *          r3   |                  |   >--+----------> Netlist Node
 * vRef >--ZZZZ--'               .--|+ /
 *                               |  | /
 *  vRef >-----------------------'  |/
 *
 *          --------------------------------------------------
 *
 *     DISC_OP_AMP_FILTER_IS_HIGH_PASS_1
 *          First Order High Pass Filter
 *
 *          r1                  rF
 *  IN0 >--ZZZZ--.      .------ZZZZ--------.
 *               |      |                  |
 *          r2   |  c1  |           |\     |
 *  IN1 >--ZZZZ--+--||--+--------+  | \    |
 *               |               '--|- \   |
 *          r3   |                  |   >--+----------> Netlist Node
 * vRef >--ZZZZ--'               .--|+ /
 *                               |  | /
 *  vRef >-----------------------'  |/
 *
 *          --------------------------------------------------
 *
 *     DISC_OP_AMP_FILTER_IS_BAND_PASS_1
 *          First Order Band Pass Filter
 *
 *                              c1
 *                      .-------||---------.
 *                      |                  |
 *          r1          |       rF         |
 *  IN0 >--ZZZZ--.      +------ZZZZ--------+
 *               |      |                  |
 *          r2   |  c2  |           |\     |
 *  IN1 >--ZZZZ--+--||--+--------+  | \    |
 *               |               '--|- \   |
 *          r3   |                  |   >--+----------> Netlist Node
 * vRef >--ZZZZ--'               .--|+ /
 *                               |  | /
 *  vRef >-----------------------'  |/
 *
 *          --------------------------------------------------
 *
 *     DISC_OP_AMP_FILTER_IS_BAND_PASS_1M
 *          Single Pole Multiple Feedback Band Pass Filter
 *
 *                         c1
 *                      .--||----+---------.
 *                      |        |         |
 *          r1          |        Z         |
 *  IN0 >--ZZZZ--.      |        Z rF      |
 *               |      |        Z         |
 *          r2   |      |  c2    |  |\     |
 *  IN1 >--ZZZZ--+------+--||----+  | \    |
 *               |               '--|- \   |
 *          r3   |                  |   >--+----------> Netlist Node
 * vRef >--ZZZZ--'               .--|+ /
 *                               |  | /
 *  vRef >-----------------------'  |/
 *
 * EXAMPLES: see Tank 8, Atari Baseball, Monte Carlo
 *
 *          --------------------------------------------------
 *
 *     DISC_OP_AMP_FILTER_IS_BAND_PASS_1M | DISC_OP_AMP_IS_NORTON
 *          Single Pole Multiple Feedback Band Pass Filter
 *
 *                         c1
 *                      .--||----+---------.
 *                      |        |         |
 *                      |        Z         |
 *                      |        Z rF      |
 *                      |        Z         |
 *          r1          |  c2    |  |\     |
 *  IN0 >--ZZZZ--+------+--||----+  | \    |
 *               |               '--|- \   |
 *          r2   |                  |   >--+----------> Netlist Node
 * vRef >--ZZZZ--'               .--|+ /
 *                    r3         |  | /
 *    vP >-----------ZZZZ--------'  |/
 *
 * EXAMPLES: see Space Encounter
 *
 *          --------------------------------------------------
 *
 *     DISC_OP_AMP_FILTER_IS_HIGH_PASS_0 | DISC_OP_AMP_IS_NORTON
 *          Basic Norton High Pass Filter
 *
 *                                   rF
 *          r1 = r1a + r1b       .--ZZZZ---.
 *                               |         |
 *          r1a   c1    r1b      |  |\     |
 *  IN1 >--ZZZZ---||---ZZZZ------+  | \    |
 *                               '--|- \   |
 *                                  |   >--+----------> Netlist Node
 *                               .--|+ /
 *                     r4        |  | /
 *  vRef >------------ZZZZ-------'  |/
 *
 * EXAMPLES: see Polaris
 *
 *          --------------------------------------------------
 *
 *     DISC_OP_AMP_FILTER_IS_BAND_PASS_0 | DISC_OP_AMP_IS_NORTON
 *          Basic Norton Band Pass Filter
 *
 *                                                    rF
 *                             r3 = r3a + r3b     .--ZZZZ---.
 *                                                |         |
 *           r1       r2       r3a   c3     r3b   |  |\     |
 *  IN1 >---ZZZZ--+--ZZZZ--+--ZZZZ---||----ZZZZ---+  | \    |
 *                |        |                      '--|- \   |
 *               ---      ---                        |   >--+---> Netlist Node
 *               --- c1   --- c2                  .--|+ /
 *                |        |                      |  | /
 *               gnd      gnd                     |  |/
 *                                         r4     |
 *  vRef >--------------------------------ZZZZ----'
 *
 * EXAMPLES: see Polaris
 *
 ***********************************************************************
 *
 * DISCRETE_SALLEN_KEY_FILTER - Sallen key low pass filter
 *
 *  Declaration syntax
 *
 *      DISCRETE_SALLEN_KEY_FILTER(name of node,
 *                                 enable node or static value,
 *                                 input node or static value,
 *                                 type static value,
 *                                 address of discrete_op_amp_filt_info)
 *
 *      discrete_op_amp_filt_info = {r1, r2, r3, r4, rF, c1, c2, c3, vRef, vP, vN}
 *
 * Note: Set all unused components to 0.
 *
 *  Types:
 *
 *     DISC_SALLEN_KEY_LOWPASS
 *
 *                              .---------.
 *                              |         |
 *                              |  |\     |
 *                              |  | \    |
 *                              `--|- \   |
 *            R1       R2          |   >--+----> Netlist Node
 *    IN >---ZZZZ--+--ZZZZ--+------|+ /   |
 *                 |        |      | /    |
 *                ---      ---     |/     |
 *                --- C1   --- C2         |
 *                 |        |             |
 *                 |       gnd            |
 *                 |                      |
 *                 `----------------------'
 *
 * EXAMPLES: see moon patrol, dkong
 *
 * References:
 *      http://www.t-linespeakers.org/tech/filters/Sallen-Key.html
 *      http://en.wikipedia.org/wiki/Sallen_Key_filter
 ***********************************************************************
 *
 * DISCRETE_RCDISC - Simple single pole RC discharge network
 *
 *                        .------------.
 *                        |            |
 *    ENAB       -0------>| RC         |
 *                        |            |
 *    INPUT1     -1------>| -ZZZZ-+--  |
 *                        |   R   |    |---->   Netlist node
 *    RVAL       -2------>|      ---   |
 *                        |      ---C  |
 *    CVAL       -3------>|       |    |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_RCFILTER(name of node,
 *                       enable,
 *                       input node (or value),
 *                       resistor value in OHMS,
 *                       capacitor value in FARADS)
 *
 *  Example config line
 *
 *     DISCRETE_RCDISC(NODE_11,NODE_10,10,100,CAP_U(1))
 *
 *  When enabled by NODE_10, C discharges from 10v as indicated by RC
 *  of 100R & 1uF.
 *
 ***********************************************************************
 *
 * DISCRETE_RCDISC2  - Switched input RC discharge network
 *
 *                        .------------.
 *                        |            |
 *    SWITCH     -0------>| IP0 | IP1  |
 *                        |            |
 *    INPUT0     -1------>| -ZZZZ-.    |
 *                        |   R0  |    |
 *    RVAL0      -2------>|       |    |
 *                        |       |    |
 *    INPUT1     -3------>| -ZZZZ-+--  |
 *                        |   R1  |    |---->   Netlist node
 *    RVAL1      -4------>|      ---   |
 *                        |      ---C  |
 *    CVAL       -5------>|       |    |
 *                        |            |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *      DISCRETE_RCDISC2(name of node,
 *                       switch,
 *                       input0 node (or value),
 *                       resistor0 value in OHMS,
 *                       input1 node (or value),
 *                       resistor1 value in OHMS,
 *                       capacitor value in FARADS)
 *
 *  Example config line
 *
 *     DISCRETE_RCDISC2(NODE_9,NODE_10,10.0,100,0.0,100,CAP_U(1))
 *
 *  When switched by NODE_10, C charges/discharges from 10v/0v
 *  as dictated by R0/C & R1/C combos respectively
 *  of 100R & 1uF.
 *
 ***********************************************************************
 *
 * DISCRETE_RCDISC3 - RC discharge network
 *
 *                        .-----------------.
 *                        |                 |
 *    ENAB       -0------>|                 |
 *                        |    diode  R2    |
 *    INPUT1     -1------>| -+-|<|--ZZZZ-+- |---->   Netlist node
 *                        |  |           |  |
 *    RVAL1      -2------>|  '-ZZZZ-+----'  |
 *                        |     R1  |       |
 *    RVAL2      -3------>|        ---      |
 *                        |        ---C     |
 *    CVAL       -4------>|         |       |
 *                        |        gnd      |
 *                        '-----------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_RCDISC3(name of node,
 *                      enable,
 *                      input node (or value),
 *                      R1 resistor value in OHMS,
 *                      R2 resistor value in OHMS,
 *                      capacitor value in FARADS)
 *
 *  Example config line
 *
 *     DISCRETE_RCDISC3(NODE_11,NODE_10,10,100,220,CAP_U(1))
 *
 *  When enabled by NODE_10, C charges from 10v as indicated by RC
 *  of 100R & 1uF.
 *
 * EXAMPLES: see Tank8
 *
 ***********************************************************************
 *
 * DISCRETE_RCDISC4 - RC discharge networks triggered by logic levels
 *
 *  Declaration syntax
 *
 *     DISCRETE_RCDISC4(name of node,
 *                      enable,
 *                      logic input node,
 *                      R1 resistor static value in OHMS,
 *                      R2 resistor static value in OHMS,
 *                      R3 resistor static value in OHMS,
 *                      C1 capacitor static value in FARADS,
 *                      vP static value in VOLTS,
 *                      circuit type static value)
 *
 *  Type: 1
 *
 *                             vP >---.
 *                                    |              .------.
 *                                    Z              |      |
 *                                    Z R2           | |\   |
 *             O.C.                   Z              '-|-\  |
 *             |\    Diode      R1    |                |  >-+---> node
 *   Input >---| o----|<|------ZZZZ---+--------+-------|+/
 *             |/                     |        |       |/
 *                                   ---     -----
 *                                C1 ---      \ / Diode
 *                                    |        V
 *                                   gnd      ---
 *                                             |
 *                                             Z
 *                                             Z R3
 *                                             Z
 *                                             |
 *                                            gnd
 *
 * EXAMPLES: see Phoenix
 *
 *          --------------------------------------------------
 *
 *  Type: 2
 *
 *      5V >---.                                    .------.
 *             Z                                    |      |
 *             Z 1k                                 | |\   |
 *             Z                                    '-|-\  |
 *             |   R1     C1         Diode            |  >-+---> node
 *   Input >---+--ZZZZ----||----+-----|>|----+--------|+/
 *                              |            |        |/
 *                            -----          Z
 *                              ^            Z R2
 *                             / \ Diode     Z
 *                            -----          |
 *                              |           gnd
 *                             gnd
 *
 * EXAMPLES: see
 *
 *          --------------------------------------------------
 *
 *  Type: 3
 *
 *      5V >---.                                     .------.
 *             Z                                     |      |
 *             Z 1k                                  | |\   |
 *             Z                                     '-|-\  |
 *             |   R1     Diode                        |  >-+---> node
 *   Input >---+--ZZZZ-----|>|------+---------+--------|+/
 *                                  |         |        |/
 *                                 --- C1     Z
 *                                 ---        Z R2
 *                                  |         Z
 *                                 gnd        |
 *                                           gnd
 *
 *
 * EXAMPLES: see
 *
 ***********************************************************************
 *
 * DISCRETE_RCDISC5 - Diode in series with R//C
 *
 *                        .---------------.
 *                        |               |
 *    ENAB       -0------>|               |
 *                        |               |
 *    INPUT1     -1------>| -|>|--+---+-  |
 *                        |       |   |   |---->   Netlist node
 *    RVAL       -2------>|      ---  Z   |
 *                        |     C---  Z R |
 *    CVAL       -3------>|       |   Z   |
 *                        |       --+--   |
 *                        |         |gnd  |
 *                        '---------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_RCDISC5(name of node,
 *                      enable,
 *                      input node (or value),
 *                      resistor value in OHMS,
 *                      capacitor value in FARADS)
 *
 *  Example config line
 *
 *     DISCRETE_RCDISC5(NODE_11,NODE_10,10,100,CAP_U(1))
 *
 *  When enabled by NODE_10, C discharges from 10v as indicated by RC
 *  of 100R & 1uF.
 *
 *  EXAMPLES: see Spiders
 *
 ***********************************************************************
 *
 * DISCRETE_RCDISC_MODULATED - RC triggered by logic and modulated
 *
 *           vP  >---.
 *                   |
 *                   Z
 *                   Z  R1
 *             O.C.  Z
 *             |\    |   R2   C1                R3
 *  INPUT1 >---| o---+--ZZZ---||------+----+---ZZZ------+---> node
 *             |/                     |    |           /
 *                                   / \   Z         |/
 *                            Diode -----  Z R4  .---| NPN
 *                                    |    Z     |   |\
 *                                    |    |     |     >
 *                                   gnd  gnd    |      |
 *                                               |     gnd
 *  INPUT2 >----------ZZZ------------------------.
 *
 *  Declaration syntax
 *
 *     DISCRETE_RCDISC_MODULATED(name of node,
 *                      INPUT1 node (or value),
 *                      INPUT2 node (or value),
 *                      R1 value in OHMS (static value),
 *                      R2 value in OHMS (static value),
 *                      R3 value in OHMS (static value),
 *                      R4 value in OHMS (static value),
 *                      C1 value in FARADS (static value),
 *                      vP value in VOLTS)
 *
 * EXAMPLES: dkong
 *
 ***********************************************************************
 *
 * DISCRETE_RCFILTER - Simple single pole RC filter network (vRef = 0)
 * DISCRETE_RCFILTER_VREF - Same but refrenced to vRef not 0V
 *
 *                        .------------.
 *                        |            |
 *    ENAB       -0------}| RC FILTER  |
 *                        |            |
 *    INPUT1     -1------}| -ZZZZ-+--  |
 *                        |   R   |    |----}   Netlist node
 *    RVAL       -2------}|      ---   |
 *                        |      ---C  |
 *    CVAL       -3------}|       |    |
 *                        |      vRef  |
 *                        '------------'
 *
 *  Declaration syntax
 *
 *     DISCRETE_RCFILTER(name of node,
 *                       enable
 *                       input node (or value)
 *                       resistor value in OHMS
 *                       capacitor value in FARADS)
 *
 *     DISCRETE_RCFILTER_VREF(name of node,
 *                            enable
 *                            input node (or value)
 *                            resistor value in OHMS
 *                            capacitor value in FARADS,
 *                            vRef static value)
 *
 *  Example config line
 *
 *     DISCRETE_RCFILTER(NODE_11,1,NODE_10,100,CAP_U(1))
 *
 *  Defines an always enabled RC filter with a 100R & 1uF network
 *  the input is fed from NODE_10.
 *
 *  This can be also thought of as a low pass filter with a 3dB cutoff
 *  at:
 *                                  1
 *            Fcuttoff =      --------------
 *                            2*Pi*RVAL*CVAL
 *
 *  (3dB cutoff is where the output power has dropped by 3dB ie Half)
 *
 * EXAMPLES: see Polaris
 *
 ***********************************************************************
 *
 * DISCRETE_RCFILTER_SW - Multiple switchable RC filters
 *
 *                             R
 *    INPUT      >-----------ZZZZ-+-------+----......-----> Output
 *                                |       |
 *                               +-+     +-+
 *    SWITCH     > Bit 0 ---->F1 | |  F2 | |
 *                               '-'   ^ '-'
 *                 Bit 1 ---------|----'  |
 *                                |       |
 *                 Bit ...       ---     ---
 *                               --- C1  --- C2
 *                                |       |
 *                               GND     GND
 *
 *
 *  Declaration syntax
 *
 *     DISCRETE_RCFILTER_SW(name of node,
 *                          enable,
 *                          input node (or value),
 *                          switch node (or value),
 *                          R in Ohms (static value),
 *                          C1 in Farads (static value),
 *                          C2 in Farads (static value),
 *                          C3 in Farads (static value),
 *                          C4 in Farads (static value))
 *
 *     This is a typical filter circuit in circusc or scramble.
 *     Switches are usually CD4066 with a "open" resistance of
 *     typical 470 Ohms at 5V.
 *     This circuit supports up to 4 filters.
 *
 * EXAMPLES: see circusc
 *
 ***********************************************************************
 *
 * DISCRETE_RCINTEGRATE - RC integration circuit/amplifier
 *
 *
 *  vP    >-------------------+
 *                            |
 *                            Z
 *                            Z R3
 *                            Z
 *                            |
 *                            +-----------------> node (Type 3)
 *                           /
 *                         |/
 *  INPUT  >---------------| NPN
 *                          \    .--------------> node (Type 2)
 *                           >   |  R1
 *                            +--+--ZZZ-+-------> node (Type 1)
 *                            |         |
 *                            Z        ---
 *                            Z R2    C---
 *                            Z         |
 *                            |         |
 *                           gnd       gnd
 *
 *  Declaration syntax
 *
 *     DISCRETE_RCINTEGRATE(name of node,
 *                          INPUT node (or value),
 *                          R1 value in OHMS,
 *                          R2 value in OHMS,
 *                          R3 value in OHMS,
 *                          C  value in FARADS,
 *                          vP node (or value in VOLTS)
 *                          TYPE)
 *
 * TYPE: RC_INTEGRATE_TYPE1, RC_INTEGRATE_TYPE2, RC_INTEGRATE_TYPE3
 *
 * Actually an amplifier as well. Primary reason for implementation was integration.
 * The integration configuration (TYPE3, R3=0) works quite well, the amplifying
 * configuration is missing a good, yet simple ( :-) ) transistor model. Around the
 * defined working point the amplifier delivers results.
 *
 * EXAMPLES: dkong
 *
 *
 ***********************************************************************
 =======================================================================
 * from from disc_dev.c
 * Component specific modules
 =======================================================================
 ***********************************************************************
 *
 * DISCRETE_555_ASTABLE    - NE555 Chip simulation (astable mode).
 * DISCRETE_555_ASTABLE_CV - NE555 Chip simulation (astable mode) with CV control.
 *
 *                            v_charge     v_pos
 *                                 V         V
 *                                 |         |
 *                                 |         |
 *                                 |         |
 *                                 Z         |8
 *    _FAST_CHARGE_DIODE        R1 Z     .---------.
 *       (optional)                |    7|  Vcc    |
 *                    +--------->  +-----|Discharge|
 *                    |            |     |         |
 *                   ---           Z     |   555   |3
 *                   \ /        R2 Z     |      Out|---> Netlist Node
 *                    V            |    6|         |
 *                   ---           +-----|Threshold|
 *                    |            |     |         |
 *                    +--------->  +-----|Trigger  |
 *                                 |    2|         |---< Control Voltage
 *                                 |     |  Reset  |5
 *                                 |     '---------'
 *                                ---        4|
 *                              C ---         |
 *                                 |          ^
 *                                gnd       Reset
 *
 *  Declaration syntax
 *
 *     DISCRETE_555_ASTABLE(name of node,
 *                          reset node (or value),
 *                          R1 node (or value) in ohms,
 *                          R2 node (or value) in ohms,
 *                          C node (or value) in farads,
 *                          address of discrete_555_desc structure)
 *
 *     DISCRETE_555_ASTABLE_CV(name of node,
 *                            reset node (or value),
 *                            R1 node (or value) in ohms,
 *                            R2 node (or value) in ohms,
 *                            C node (or value) in farads,
 *                            Control Voltage node (or value),
 *                            address of discrete_555_desc structure)
 *
 *    discrete_555_desc =
 *    {
 *        options,        - bit mapped options
 *        v_pos,          - B+ voltage of 555
 *        v_charge,       - voltage (or node) to charge circuit  (Defaults to v_pos)
 *        v_out_high,     - High output voltage of 555 (Defaults to v_pos - 1.2V)
 *    }
 *
 * The last 2 options of discrete_555_desc can use the following defaults:
 *     DEFAULT_555_CHARGE -  to connect v_charge to v_pos
 *     DEFAULT_555_HIGH   - to use the normal output voltage based on v_pos
 * or combine both as:
 *     DEFAULT_555_VALUES
 *
 * eg. {DISC_555_OUT_SQW | DISC_555_OUT_DC, 12, DEFAULT_555_VALUES}
 *
 *  Output Types: (only needed with DISC_555_OUT_SQW, DISC_555_OUT_CAP
 *                 and DISC_555_OUT_ENERGY)
 *     DISC_555_OUT_DC - Output is actual DC. (DEFAULT)
 *     DISC_555_OUT_AC - A cheat to make the waveform AC.
 *
 *  Waveform Types: (ORed with output types)
 *     DISC_555_OUT_SQW     - Output is Squarewave.  0 or v_out_high. (DEFAULT)
 *                            When the state changes from low to high (or high to low)
 *                            during a sample, the output will high (or low) for that
 *                            sample.  This can cause alaising effects.
 *     DISC_555_OUT_CAP     - Output is Timing Capacitor 'C' voltage.
 *     DISC_555_OUT_COUNT_F - If the 555 frequency is greater then half the sample
 *                            rate, then the output may change state more then once
 *                            during the sample.  Using this flag will cause
 *                            the output to be the number of falling edges that
 *                            happened during the sample.  This is usefull to feed
 *                            to counter circuits.  The Output Type flag is ingnored
 *                            when this flag is used.
 *     DISC_555_OUT_COUNT_R - Same as DISC_555_OUT_COUNT_F but with rising edges.
 *     DISC_555_OUT_ENERGY  - Same SQW, but will help reduce aliasing effects.
 *                            This should be used when the 555 squarewave output is used
 *                            as a final output and not as a clock source.
 *                            If the state changes from low to high 1/4 of the way
 *                            through the sample, then the output will be 75% of the
 *                            normal high value.
 *     DISC_555_OUT_LOGIC_X - This will output the 0/1 level of the flip-flop with
 *                            some eXtra info.  This x_time is in decimal remainder.
 *                            It lets you know the percent of sample time where the
 *                            flip-flop changed state.  If 0, the change did not happen
 *                            during the sample.  1.75 means the flip-flop is 1 and
 *                            switched over 1/4 of the way through the sample.
 *                            0.2 means the flip-flop is 0 and switched over 4/5 of
 *                            the way through the sample.
 *                            X modules can be used with counters to reduce alaising.
 *   DISC_555_OUT_COUNT_F_X - Same as DISC_555_OUT_COUNT_F but with x_time.
 *   DISC_555_OUT_COUNT_R_X - Same as DISC_555_OUT_COUNT_R but with x_time.
 *
 *  other options - DISCRETE_555_ASTABLE only:
 *     DISC_555_ASTABLE_HAS_FAST_CHARGE_DIODE - diode used to bypass rDischarge
 *                                              when charging for quicker charge.
 *
 * EXAMPLES: see Hit Me, Canyon Bomber, Sky Diver
 *
 ***********************************************************************
 *
 * DISCRETE_555_MSTABLE - NE555 Chip simulation (monostable mode)
 *                      - Triggered on falling edge.
 *
 *            v_charge     v_pos
 *                 V         V
 *                 |         |
 *                 |         |
 *                 |         |
 *                 Z         |
 *               R Z     .---------.
 *                 |     |  Vcc    |
 *                 +-----|Discharge|
 *                 |     |         |
 *                 |     |   555   |
 *                 |     |      Out|---> Netlist Node
 *                 |     |         |
 *                 +-----|Threshold|
 *                 |     |         |
 *                 |     |  Trigger|--------< Trigger
 *                 |     |       CV|---.
 *                 |     |  Reset  |   |
 *                 |     '---------'  --- not
 *                ---         |       --- needed
 *              C ---         |        |
 *                 |          ^       gnd
 *                gnd       Reset
 *
 *  Declaration syntax
 *
 *     DISCRETE_555_MSTABLE(name of node,
 *                          reset node (or value),
 *                          Trigger node,
 *                          R node (or value) in ohms,
 *                          C node (or value) in farads,
 *                          address of discrete_555_desc structure)
 *
 *    discrete_555_desc = See DISCRETE_555_ASTABLE for description.
 *      Note: v_charge can not be a node for this circuit.
 *
 *  Trigger Types
 *     DISC_555_TRIGGER_IS_LOGIC   - Input is (0 or !0) logic (DEFAULT)
 *     DISC_555_TRIGGER_IS_VOLTAGE - Input is actual voltage.
 *                                   Voltage must drop below
 *                                   trigger to activate.
 *     DISC_555_TRIGGER_DISCHARGES_CAP - some circuits connect an external
 *                                       device (transistor) to the cap to
 *                                       discharge it when the trigger is
 *                                       enabled.  Thereby allowing the one-shot
 *                                       to retrigger.
 *
 *  Output Types: (ORed with trigger types)
 *     DISC_555_OUT_DC - Output is actual DC. (DEFAULT)
 *     DISC_555_OUT_AC - A cheat to make the waveform AC.
 *
 *  Waveform Types: (ORed with trigger types)
 *     DISC_555_OUT_SQW     - Output is Squarewave.  0 or v_out_high. (DEFAULT)
 *     DISC_555_OUT_CAP     - Output is Timing Capacitor 'C' voltage.
 *
 * EXAMPLES: see Frogs
 *
 ***********************************************************************
 *
 * DISCRETE_555_CC - Constant Current Controlled 555 Oscillator
 *                   Which works out to a VCO when R is fixed.
 *
 *       v_cc_source                     v_pos
 *           V                            V
 *           |     .----------------------+
 *           |     |                      |
 *           |     |                  .---------.
 *           |     |       rDischarge |  Vcc    |
 *           Z     Z        .---+-----|Discharge|
 *           Z R   Z rBias  |   |     |         |
 *           |     |        |   Z     |   555   |
 *           |     |        |   Z     |      Out|---> Netlist Node
 *         .----.  |      >-'   |     |         |
 *  Vin >--| CC |--+--> option  +-----|Threshold|
 *         '----'         >-----+     |         |
 *                              +-----|Trigger  |
 *                              |     |         |
 *                 .------+-----'     |  Reset  |
 *                 |      |           '---------'
 *                ---     Z                |
 *                --- C   Z rGnd           |
 *                 |      |                ^
 *                gnd    gnd             Reset
 *
 * Notes: R sets the current and should NEVER be 0 (short).
 *        The current follows the voltage I=Vin/R and charges C.
 *        rBias, rDischarge and rGnd should be 0 if not used.
 *        Reset is active low for the module.
 *
 *        Note that the CC source can be connected two different ways.
 *        See the option flags below for more info.
 *
 *        DISC_555_OUT_SQW mode only:
 *        When there is no rDischarge there is a very short discharge
 *        cycle (almost 0s), so the module triggers the output for 1
 *        sample. This does not effect the timing, just the duty cycle.
 *        But frequencies more the half the sample frequency will be
 *        limited to a max of half the sample frequency.
 *        This mode should be used to drive a counter for any real use.
 *        Just like the real thing.
 *
 *  Declaration syntax
 *
 *     DISCRETE_555_CC(name of node,
 *                     reset node or static value,
 *                     Vin node or static value,
 *                     R node or static value,
 *                     C node or static value,
 *                     rBias node or static value,
 *                     rGnd node or static value,
 *                     rDischarge node or static value,
 *                     address of discrete_555_cc_desc structure)
 *
 *     discrete_555_cc_desc =
 * {
 *         options;         - bit mapped options
 *         v_pos;           - B+ voltage of 555
 *         v_cc_source;     - Voltage of the Constant Current source
 *         v_out_high;      - High output voltage of 555 (Defaults to v_pos - 1.2V)
 *         v_cc_junction;   - The voltage drop of the Constant Current source transitor
 *                            (0 if Op Amp)
 *  }
 *
 * The last 2 options of discrete_555_desc can use the following defaults:
 *     DEFAULT_555_CC_SOURCE - to connect v_cc_source to v_pos
 *     DEFAULT_555_HIGH      - to use the normal output voltage based on v_pos
 * or combine both as:
 *     DEFAULT_555_VALUES
 *
 *  Output Types:
 *     See DISCRETE_555_ASTABLE for description.
 *
 *  Waveform Types: (ORed with output types)
 *     See DISCRETE_555_ASTABLE for description.
 *
 *  Other Flags:
 *     DISCRETE_555_CC_TO_DISCHARGE_PIN - The CC source connects to the
 *                                        discharge pin. (Default)
 *     DISCRETE_555_CC_TO_CAP           - The CC source connects to the
 *                                        threshold pin.  This is not fully
 *                                        implemented yet.  It only works properly
 *                                        when only rDischarge is defined.
 *
 * EXAMPLES: see Fire Truck, Monte Carlo, Super Bug
 *
 ***********************************************************************
 *
 * DISCRETE_555_VCO1    - Op-Amp based 555 VCO circuit.
 * DISCRETE_555_VCO1_CV - Op-Amp based 555 VCO circuit with CV control.
 *
 *                               c
 *  .------------------------+---||----+---------------------------> DISC_555_OUT_CAP
 *  |                        |         |
 *  |                        |   |\    |
 *  |              r1        |   | \   |      .------------.
 *  |  vIn1 >--+--ZZZZ-------+---|- \  |      |            |
 *  |          |                 |   >-+---+--|Threshold   |
 *  |          |   r2            |+ /      |  |         Out|------> DISC_555_OUT_xx
 *  Z          '--ZZZZ--+--------| /       '--|Trigger     |
 *  Z r4                |        |/           |            |
 *  Z                   Z                     |       Reset|------< Reset
 *  |                   Z r3          vIn2 >--|CV          |
 * .----.               Z                     |            |
 * |  En|<--------.     |                 .---|Discharge   |
 * '----'         |    gnd                |   '------------'
 *   |            |                       |
 *  gnd           '-----------------------+---ZZZZ------> v_charge (ignored)
 *                                             rX
 *
 *  Declaration syntax
 *
 *     DISCRETE_555_VCO1(name of node,
 *                       reset node or static value,
 *                       Vin1 node or static value,
 *                       address of discrete_555_vco1_desc structure)
 *
 *     DISCRETE_555_VCO1_CV(name of node,
 *                          reset node or static value,
 *                          Vin1 node or static value,
 *                          Vin2 (CV) node or static value,
 *                          address of discrete_555_vco1_desc structure)
 *
 *  discrete_555_vco1_desc =
 *  {
 *      options,            - bit mapped options
 *      r1, r2, r3, r4, c,
 *      v_pos,              - B+ voltage of 555
 *      v_out_high,         - High output voltage of 555 (Defaults to v_pos - 1.2V)
 *  }
 *
 * The last option of discrete_555_vco1_desc can use the following default:
 *     DEFAULT_555_HIGH      - to use the normal output voltage based on v_pos
 *
 * Notes: The value of resistor rX is not needed.  It is just a pull-up
 *        for the discharge output.
 *        The 'En' block can be a transistor or 4066 switch.  It connects
 *        r4 to ground when En is high.
 *
 ***********************************************************************
 *
 * DISCRETE_566 - NE566 VCO simulation.
 *
 *       v_charge        v_pos
 *           V             V
 *           |             |
 *           |             |
 *           |    R    .-------.
 *           '---/\/\--|6  8   |
 *                     |       |
 *   vMod >------------|5   3/4|---------> Netlist Node
 *                     |       |
 *                 .---|7  1   |
 *                 |   '-------'
 *                ---      |
 *                --- C    |
 *                 |       |
 *               v_neg   v_neg
 *
 *  Declaration syntax
 *
 *     DISCRETE_566(name of node,
 *                  enable node or static value,
 *                  vMod node or static value,
 *                  R node or static value in ohms,
 *                  C node or static value in Farads,
 *                  address of discrete_566_desc structure)
 *
 *     discrete_566_desc = {options, v_pos, v_neg, v_charge}
 *       Note: v_charge can be static value, a node
 *             or use DEFAULT_566_CHARGE to connect to v_pos
 *
 *  Output Types:
 *     DISC_566_OUT_DC - Output is actual DC. (DEFAULT)
 *     DISC_566_OUT_AC - A cheat to make the waveform AC.
 *
 *  Waveform Types:
 *     DISC_566_OUT_SQUARE   - Pin 3 Square Wave Output (DEFAULT)
 *     DISC_566_OUT_TRIANGLE - Pin 4 Triangle Wave Output
 *     DISC_566_OUT_LOGIC    - Internal Flip/Flop Output
 *
 * EXAMPLES: see Starship 1
 *
 ***********************************************************************
 *
 * DISCRETE_74LS624 - VCO.
 *
 * Simplified 74LS624 - calculated frequencies should match datasheet
 * for C > 1nF. Output is Logic (1/0)
 *
 * The datasheet gives no formulae. The implementation therefore is
 * a rough model of the diagrams given.
 *
 * For a LS628, use VRng = 3.2
 *
 *                          V+
 *                           |
 *                     .---------.
 *   vRng >------------|Rng  V+  |
 *                     |         |
 *   vMod >------------|Freq   Z |---------> Netlist Node
 *                     |         |
 *                 .---|CX1      |
 *                 |   |         |
 *                ---  |         |
 *              C ---  |         |
 *                 |   |         |
 *                 '---|CX2      |
 *                     '---------'
 *                         |
 *                        GND
 *
 *  Declaration syntax
 *
 *     DISCRETE_74LS624(name of node,
 *                      enable node or static value,
 *                      vMod node or static value,
 *                      vRng node or static value,
 *                      C node or static value in Farads,
 *                      Type of output static value)
 *
 * Type of Output
 *      DISC_LS624_OUT_ENERGY   Energy - use for audio output
 *      DISC_LS624_OUT_LOGIC    Logic ( 0 or 1)
 *      DISC_LS624_OUT_COUNT_F  Number of Falling edges
 *      DISC_LS624_OUT_COUNT_R  Number of Rising  edges
 *
 ***********************************************************************
 *
 * DISCRETE_CUSTOMx - Link to custom code
 *     where x = 1 to 9
 *
 *  Declaration syntax
 *
 *     DISCRETE_CUSTOMx(name of node,
 *                      input 0 node or static value, ...)
 *
 *     discrete_custom_info = {reset, step, contextsize, custom}
 *                             reset  = address called to reset a node after creation or system reset
 *                             step   = address called to execute one time delta of output update
 *                             contextsize = size of context to create
 *                             custom = address of specific initialization data
 *
 * EXAMPLES: see Donkey Kong
 *
 ***********************************************************************
 =======================================================================
 * Debugging modules.
 =======================================================================
 ***********************************************************************
 *
 * DISCRETE_CSVLOGx - Dump n nodes into a csv (comma separated value) file
 *
 *  Declaration syntax
 *
 *     DISCRETE_CSVLOGx(node 1, ...)
 *         where x = 1 to 5
 *
 *  WARNING: This can rapidally use up a lot of hard drive space.
 *           48kHz sampling of 5 nodes used 217M after 80 seconds.
 *
 *  Use this to monitor nodes while debugging the driver.  You should
 *  remove these nodes from the final driver.  You can use up to a maximum
 *  DISCRETE_MAX_CSVLOGS.  Each file will be called discreteX_Y.csv,
 *  where X is the sound tag.  Y is 0-9, in the order the file is
 *  created in the driver.
 *
 *  This can be used to monitor how multiple nodes relate to each other.
 *  The resulting file can be imported to a spreadsheet.
 *
 ************************************************************************
 *
 * DISCRETE_WAVELOG - Dump nodes into a wav file
 *
 *  Declaration syntax
 *
 *     DISCRETE_WAVELOG1(node,
 *                       static gain for node)
 *
 *     DISCRETE_WAVELOG2(left node,
 *                       static gain for left node,
 *                       right node,
 *                       static gain for right node)
 *
 *  Use this to monitor nodes while debugging the driver.  You should
 *  remove these nodes from the final driver.  You can use up to a maximum
 *  of DISCRETE_MAX_WAVELOGS.  Each file will be called discreteX_Y.wav,
 *  where X is the sound tag.  Y is 0-9, in the order the file is
 *  created in the driver.
 *
 *  This can be used to monitor how a node's input affects it's output.
 *  Monitor the input trigger against the final effect, etc.  The resulting
 *  file can be played/viewed etc. by music player/editor software.
 *
 *  When logging nodes that are voltage levels, you may want to use a
 *  gain of 1000.  This will make the wav sample level reflect milli-volts.
 *
 ************************************************************************
 =======================================================================
 * Must be last module.
 =======================================================================
 ***********************************************************************
 *
 * DISCRETE_OUTPUT - Single output node to Mame mixer and output
 *
 *                            .----------.       .
 *                            |          |    .-/|
 *      Netlist node -------->| OUTPUT   |----|  | Sound Output
 *                            |          |    '-\|
 *                            '----------'       '
 *
 *  Declaration syntax
 *
 *     DISCRETE_OUTPUT(name of output node, gain)
 *
 *  Example config line
 *
 *     DISCRETE_OUTPUT(NODE_02, 1000)
 *
 *  Output stream will be generated from the NODE_02 output stream * 1000.
 *
 *  Multiple outputs can be used up to DISCRETE_MAX_OUTPUTS.
 *
 ************************************************************************/

#include "streams.h"
#include "wavwrite.h"



/*************************************
 *
 *  macros
 *  see also: emu\machine\rescap.h
 *
 *************************************/

/* calculate charge exponent using discrete sample time */
#define RC_CHARGE_EXP(rc)				(1.0 - exp(discrete_current_context->neg_sample_time / (rc)))
/* calculate charge exponent using given sample time */
#define RC_CHARGE_EXP_DT(rc, dt)		(1.0 - exp(-(dt) / (rc)))
#define RC_CHARGE_NEG_EXP_DT(rc, dt)	(1.0 - exp((dt) / (rc)))

/* calculate discharge exponent using discrete sample time */
#define RC_DISCHARGE_EXP(rc)			(exp(discrete_current_context->neg_sample_time / (rc)))
/* calculate discharge exponent using given sample time */
#define RC_DISCHARGE_EXP_DT(rc, dt)		(exp(-(dt) / (rc)))
#define RC_DISCHARGE_NEG_EXP_DT(rc, dt)	(exp((dt) / (rc)))

/*************************************
 *
 *  Interface & Naming
 *
 *************************************/

#define DISCRETE_STEP_NAME( _func )  _func ## _step
#define DISCRETE_RESET_NAME( _func ) _func ## _reset

#define DISCRETE_STEP(_func) void DISCRETE_STEP_NAME(_func) (const device_config *device, node_description *node)
#define DISCRETE_RESET(_func) void DISCRETE_RESET_NAME(_func) (const device_config *device, node_description *node)

#define DISCRETE_STEP_CALL(_func) DISCRETE_STEP_NAME(_func) (device, node)
#define DISCRETE_RESET_CALL(_func) DISCRETE_RESET_NAME(_func) (device, node)

/*************************************
 *
 *  Profiling Nodes
 *
 *************************************/

#define DISCRETE_PROFILING			(0)

/*************************************
 *
 *  Core constants
 *
 *************************************/

#define DISCRETE_MAX_NODES				300
#define DISCRETE_MAX_INPUTS				10
#define DISCRETE_MAX_OUTPUTS			16
#define DISCRETE_MAX_WAVELOGS			10
#define DISCRETE_MAX_CSVLOGS			10
#define DISCRETE_MAX_NODE_OUTPUTS		 8


/*************************************
 *
 *  Node-specific constants
 *
 *************************************/

#define DEFAULT_TTL_V_LOGIC_1	3.4

#define DISC_LOGADJ				1.0
#define DISC_LINADJ				0.0

/* DISCRETE_COMP_ADDER types */
#define DISC_COMP_P_CAPACITOR			0x00
#define DISC_COMP_P_RESISTOR			0x01

/* clk types */
#define DISC_CLK_MASK			0x03
#define DISC_CLK_ON_F_EDGE		0x00
#define DISC_CLK_ON_R_EDGE		0x01
#define DISC_CLK_BY_COUNT		0x02
#define DISC_CLK_IS_FREQ		0x03

#define DISC_COUNT_DOWN			0
#define DISC_COUNT_UP			1

#define DISC_COUNTER_IS_7492	0x08

#define DISC_OUT_MASK			0x30
#define DISC_OUT_DEFAULT		0x00
#define DISC_OUT_IS_ENERGY		0x10
#define DISC_OUT_HAS_XTIME		0x20

/* Function possibilities for the LFSR feedback nodes */
/* 2 inputs, one output                               */
#define DISC_LFSR_XOR					0
#define DISC_LFSR_OR					1
#define DISC_LFSR_AND					2
#define DISC_LFSR_XNOR					3
#define DISC_LFSR_NOR					4
#define DISC_LFSR_NAND					5
#define DISC_LFSR_IN0					6
#define DISC_LFSR_IN1					7
#define DISC_LFSR_NOT_IN0				8
#define DISC_LFSR_NOT_IN1				9
#define DISC_LFSR_REPLACE				10
#define DISC_LFSR_XOR_INV_IN0           11
#define DISC_LFSR_XOR_INV_IN1           12

/* LFSR Flag Bits */
#define DISC_LFSR_FLAG_OUT_INVERT		0x01
#define DISC_LFSR_FLAG_RESET_TYPE_L		0x00
#define DISC_LFSR_FLAG_RESET_TYPE_H		0x02
#define DISC_LFSR_FLAG_OUTPUT_F0		0x04

/* Sample & Hold supported clock types */
#define DISC_SAMPHOLD_REDGE				0
#define DISC_SAMPHOLD_FEDGE				1
#define DISC_SAMPHOLD_HLATCH			2
#define DISC_SAMPHOLD_LLATCH			3

/* Maximum number of resistors in ladder chain */
#define DISC_LADDER_MAXRES				8

/* Filter types */
#define DISC_FILTER_LOWPASS				0
#define DISC_FILTER_HIGHPASS			1
#define DISC_FILTER_BANDPASS			2

/* Mixer types */
#define DISC_MIXER_IS_RESISTOR			0
#define DISC_MIXER_IS_OP_AMP			1
#define DISC_MIXER_IS_OP_AMP_WITH_RI 	2	// Used only internally.  Use DISC_MIXER_IS_OP_AMP

/* Triggered Op Amp Functions */
enum
{
	DISC_OP_AMP_TRIGGER_FUNCTION_NONE,
	DISC_OP_AMP_TRIGGER_FUNCTION_TRG0,
	DISC_OP_AMP_TRIGGER_FUNCTION_TRG0_INV,
	DISC_OP_AMP_TRIGGER_FUNCTION_TRG1,
	DISC_OP_AMP_TRIGGER_FUNCTION_TRG1_INV,
	DISC_OP_AMP_TRIGGER_FUNCTION_TRG2,
	DISC_OP_AMP_TRIGGER_FUNCTION_TRG2_INV,
	DISC_OP_AMP_TRIGGER_FUNCTION_TRG01_AND,
	DISC_OP_AMP_TRIGGER_FUNCTION_TRG01_NAND
};


/* Common Op Amp Flags and values */
#define DISC_OP_AMP_IS_NORTON	0x01
#define OP_AMP_NORTON_VBE		0.5		// This is the norton junction voltage. Used only internally.
#define OP_AMP_VP_RAIL_OFFSET	1.5		// This is how close an op-amp can get to the vP rail. Used only internally.

/* Integrate options */
#define DISC_INTEGRATE_OP_AMP_1	0x00
#define DISC_INTEGRATE_OP_AMP_2	0x10

/* op amp 1 shot types */
#define DISC_OP_AMP_1SHT_1	0x00

/* Op Amp Filter Options */
#define DISC_OP_AMP_FILTER_IS_LOW_PASS_1	0x00
#define DISC_OP_AMP_FILTER_IS_HIGH_PASS_1	0x10
#define DISC_OP_AMP_FILTER_IS_BAND_PASS_1	0x20
#define DISC_OP_AMP_FILTER_IS_BAND_PASS_1M	0x30
#define DISC_OP_AMP_FILTER_IS_HIGH_PASS_0	0x40
#define DISC_OP_AMP_FILTER_IS_BAND_PASS_0	0x50

#define DISC_OP_AMP_FILTER_TYPE_MASK		(0xf0 | DISC_OP_AMP_IS_NORTON)	// Used only internally.

/* Sallen-Key filter Opions */
#define DISC_SALLEN_KEY_LOW_PASS			0x01
#define DISC_SALLEN_KEY_HIGH_PASS			0x02


/* Op Amp Oscillator Flags */
#define DISC_OP_AMP_OSCILLATOR_1			0x00
#define DISC_OP_AMP_OSCILLATOR_VCO_1		0x80
#define DISC_OP_AMP_OSCILLATOR_VCO_2		0x90
#define DISC_OP_AMP_OSCILLATOR_VCO_3		0xa0
#define DISC_OP_AMP_OSCILLATOR_OUT_CAP		0x00
#define DISC_OP_AMP_OSCILLATOR_OUT_SQW		0x02

#define DISC_OP_AMP_OSCILLATOR_TYPE_MASK	(0xf0 | DISC_OP_AMP_IS_NORTON)	// Used only internally.

/* Schmitt Oscillator Options */
#define DISC_SCHMITT_OSC_IN_IS_LOGIC	0x00
#define DISC_SCHMITT_OSC_IN_IS_VOLTAGE	0x01

#define DISC_SCHMITT_OSC_ENAB_IS_AND	0x00
#define DISC_SCHMITT_OSC_ENAB_IS_NAND	0x02
#define DISC_SCHMITT_OSC_ENAB_IS_OR		0x04
#define DISC_SCHMITT_OSC_ENAB_IS_NOR	0x06

#define DISC_SCHMITT_OSC_ENAB_MASK		0x06	/* Bits that define output enable type.
                                                 * Used only internally in module. */

/* 555 Common output flags */
#define DISC_555_OUT_DC					0x00
#define DISC_555_OUT_AC					0x10

#define DISC_555_TRIGGER_IS_LOGIC		0x00
#define DISC_555_TRIGGER_IS_VOLTAGE		0x40
#define DISC_555_TRIGGER_DISCHARGES_CAP	0x80

#define DISC_555_OUT_SQW				0x00	/* Squarewave */
#define DISC_555_OUT_CAP				0x01	/* Cap charge waveform */
#define DISC_555_OUT_COUNT_F			0x02	/* Falling count */
#define DISC_555_OUT_COUNT_R			0x03	/* Rising count */
#define DISC_555_OUT_ENERGY				0x04
#define DISC_555_OUT_LOGIC_X			0x05
#define DISC_555_OUT_COUNT_F_X			0x06
#define DISC_555_OUT_COUNT_R_X			0x07

#define DISC_555_OUT_MASK				0x07	/* Bits that define output type.
                                                 * Used only internally in module. */

#define DISC_555_ASTABLE_HAS_FAST_CHARGE_DIODE		0x80
#define DISCRETE_555_CC_TO_DISCHARGE_PIN			0x00
#define DISCRETE_555_CC_TO_CAP						0x80

/* 566 output flags */
#define DISC_566_OUT_DC					0x00
#define DISC_566_OUT_AC					0x01

#define DISC_566_OUT_SQUARE				0x00	/* Squarewave */
#define DISC_566_OUT_TRIANGLE			0x10	/* Triangle waveform */
#define DISC_566_OUT_LOGIC				0x20	/* 0/1 logic output */

#define DISC_566_OUT_MASK				0x30	/* Bits that define output type.
                                                 * Used only internally in module. */
#define DEFAULT_566_CHARGE	-1

/* LS624 output flags */
#define DISC_LS624_OUT_ENERGY			0x01
#define DISC_LS624_OUT_LOGIC			0x02
#define DISC_LS624_OUT_COUNT_F			0x03
#define DISC_LS624_OUT_COUNT_R			0x04

/* Oneshot types */
#define DISC_ONESHOT_FEDGE				0x00
#define DISC_ONESHOT_REDGE				0x01

#define DISC_ONESHOT_NORETRIG			0x00
#define DISC_ONESHOT_RETRIG				0x02

#define DISC_OUT_ACTIVE_LOW				0x04
#define DISC_OUT_ACTIVE_HIGH			0x00

#define DISC_CD4066_THRESHOLD           2.75

/* Integrate */

#define DISC_RC_INTEGRATE_TYPE1						0x00
#define DISC_RC_INTEGRATE_TYPE2						0x01
#define DISC_RC_INTEGRATE_TYPE3						0x02

/*************************************
 *
 *  The discrete sound blocks as
 *  defined in the drivers
 *
 *************************************/

struct _discrete_sound_block
{
	int				node;							/* Output node number */
	int				type;							/* see defines below */
	int				active_inputs;					/* Number of active inputs on this node type */
	int				input_node[DISCRETE_MAX_INPUTS];/* input/control nodes */
	double			initial[DISCRETE_MAX_INPUTS];	/* Initial values */
	const void *	custom;							/* Custom function specific initialisation data */
	const char *	name;							/* Node Name */
};
typedef struct _discrete_sound_block discrete_sound_block;

/*************************************
 *
 *  Discrete module definition
 *
 *************************************/

typedef struct _node_description node_description;

typedef struct _discrete_module discrete_module;
struct _discrete_module
{
	int				type;
	const char *	name;
	int				num_output;				/* Total number of output nodes, i.e. Master node + 1 */
	size_t			contextsize;
	void (*reset)(const device_config *device, node_description *node);	/* Called to reset a node after creation or system reset */
	void (*step)(const device_config *device, node_description *node);	/* Called to execute one time delta of output update */
};


/*************************************
 *
 *  Internal structure of a node
 *
 *************************************/

struct _node_description
{
	int				node;								/* The node's index number in the node list */
	double			output[DISCRETE_MAX_NODE_OUTPUTS];	/* The node's last output value */

	int				active_inputs;						/* Number of active inputs on this node type */
	int				input_is_node;						/* Bit Flags.  1 in bit location means input_is_node */
	const double *	input[DISCRETE_MAX_INPUTS];			/* Addresses of Input values */

	discrete_module module;								/* Copy of the node's module info */
	const discrete_sound_block *block;					/* Points to the node's setup block. */
	void *			context;							/* Contextual information specific to this node type */
	const char *	name;								/* Text name string for identification/debug */
	const void *	custom;								/* Custom function specific initialisation data */
#if (DISCRETE_PROFILING)
	osd_ticks_t		run_time;
#endif
};


/*************************************
 *
 *  Core runtime info
 *
 *  this structure is exposed mainly
 *  to read the sample rate info
 *  and possibly context info
 *
 *************************************/

typedef struct _discrete_info discrete_info;
struct _discrete_info
{
	const device_config *device;

	/* emulation info */
	int		sample_rate;
	double	sample_time;
	double	neg_sample_time;

	/* internal node tracking */
	int node_count;
	node_description **running_order;
	node_description **indexed_node;
	node_description *node_list;

	/* the input streams */
	int discrete_input_streams;
	stream_sample_t *input_stream_data[DISCRETE_MAX_OUTPUTS];

	/* output node tracking */
	int discrete_outputs;
	node_description *output_node[DISCRETE_MAX_OUTPUTS];

	/* the output stream */
	sound_stream *discrete_stream;

	/* debugging statics */
	FILE *disclogfile;

	/* csvlog tracking */
	int num_csvlogs;
	FILE *disc_csv_file[DISCRETE_MAX_CSVLOGS];
	node_description *csvlog_node[DISCRETE_MAX_CSVLOGS];
	INT64 sample_num;

	/* wavelog tracking */
	int num_wavelogs;
	wav_file *disc_wav_file[DISCRETE_MAX_WAVELOGS];
	node_description *wavelog_node[DISCRETE_MAX_WAVELOGS];
};


/*************************************
 *
 *  Node-specific struct types
 *
 *************************************/

typedef struct _discrete_lfsr_desc discrete_lfsr_desc;
struct _discrete_lfsr_desc
{
	int clock_type;
	int bitlength;
	int reset_value;

	int feedback_bitsel0;
	int feedback_bitsel1;
	int feedback_function0;         /* Combines bitsel0 & bitsel1 */

	int feedback_function1;         /* Combines funct0 & infeed bit */

	int feedback_function2;         /* Combines funct1 & shifted register */
	int feedback_function2_mask;    /* Which bits are affected by function 2 */

	int flags;

	int output_bit;
};


typedef struct _discrete_op_amp_osc_info discrete_op_amp_osc_info;
struct _discrete_op_amp_osc_info
{
	int		type;
	double	r1;
	double	r2;
	double	r3;
	double	r4;
	double	r5;
	double	r6;
	double	r7;
	double	r8;
	double	c;
	double	vP;		// Op amp B+
};


#define DEFAULT_7414_VALUES 	1.7, 0.9, 3.4

#define DEFAULT_74LS14_VALUES 	1.6, 0.8, 3.4

typedef struct _discrete_schmitt_osc_desc discrete_schmitt_osc_desc;
struct _discrete_schmitt_osc_desc
{
	double	rIn;
	double	rFeedback;
	double	c;
	double	trshRise;	// voltage that triggers the gate input to go high (vGate) on rise
	double	trshFall;	// voltage that triggers the gate input to go low (0V) on fall
	double	vGate;		// the output high voltage of the gate that gets fedback through rFeedback
	int		options;	// bitmaped options
};


typedef struct _discrete_comp_adder_table discrete_comp_adder_table;
struct _discrete_comp_adder_table
{
	int		type;
	double	cDefault;				// Default componet.  0 if not used.
	int		length;
	double	c[DISC_LADDER_MAXRES];	// Componet table
};


typedef struct _discrete_dac_r1_ladder discrete_dac_r1_ladder;
struct _discrete_dac_r1_ladder
{
	int		ladderLength;		// 2 to DISC_LADDER_MAXRES.  1 would be useless.
	double	r[DISC_LADDER_MAXRES];	// Don't use 0 for valid resistors.  That is a short.
	double	vBias;			// Voltage Bias resistor is tied to (0 = not used)
	double	rBias;			// Additional resistor tied to vBias (0 = not used)
	double	rGnd;			// Resistor tied to ground (0 = not used)
	double	cFilter;		// Filtering cap (0 = not used)
};


typedef struct _discrete_integrate_info discrete_integrate_info;
struct _discrete_integrate_info
{
	int		type;
	double	r1;		// r1a + r1b
	double	r2;		// r2a + r2b
	double	r3;		// r3a + r3b
	double	c;
	double	v1;
	double	vP;
	double	f0;
	double	f1;
	double	f2;
};


#define DISC_MAX_MIXER_INPUTS	8
typedef struct _discrete_mixer_desc discrete_mixer_desc;
struct _discrete_mixer_desc
{
	int		type;
	double	r[DISC_MAX_MIXER_INPUTS];		/* static input resistance values.  These are in series with rNode, if used. */
	int		r_node[DISC_MAX_MIXER_INPUTS];	/* variable resistance nodes, if needed.  0 if not used. */
	double	c[DISC_MAX_MIXER_INPUTS];
	double	rI;
	double	rF;
	double	cF;
	double	cAmp;
	double	vRef;
	double	gain;				/* Scale value to get output close to +/- 32767 */
};


typedef struct _discrete_op_amp_info discrete_op_amp_info;
struct _discrete_op_amp_info
{
	int		type;
	double	r1;
	double	r2;
	double	r3;
	double	r4;
	double	c;
	double	vN;		// Op amp B-
	double	vP;		// Op amp B+
};


typedef struct _discrete_op_amp_1sht_info discrete_op_amp_1sht_info;
struct _discrete_op_amp_1sht_info
{
	int		type;
	double	r1;
	double	r2;
	double	r3;
	double	r4;
	double	r5;
	double	c1;
	double	c2;
	double	vN;		// Op amp B-
	double	vP;		// Op amp B+
};


typedef struct _discrete_op_amp_tvca_info discrete_op_amp_tvca_info;
struct _discrete_op_amp_tvca_info
{
	double	r1;
	double	r2;		// r2a + r2b
	double	r3;		// r3a + r3b
	double	r4;
	double	r5;
	double	r6;
	double	r7;
	double	r8;
	double	r9;
	double	r10;
	double	r11;
	double	c1;
	double	c2;
	double	c3;
	double	v1;
	double	v2;
	double	v3;
	double	vP;
	int		f0;
	int		f1;
	int		f2;
	int		f3;
	int		f4;
	int		f5;
};


typedef struct _discrete_op_amp_filt_info discrete_op_amp_filt_info;
struct _discrete_op_amp_filt_info
{
	double	r1;
	double	r2;
	double	r3;
	double	r4;
	double	rF;
	double	c1;
	double	c2;
	double	c3;
	double	vRef;
	double	vP;
	double	vN;
};


#define DEFAULT_555_CHARGE		-1
#define DEFAULT_555_HIGH		-1
#define DEFAULT_555_VALUES		DEFAULT_555_CHARGE, DEFAULT_555_HIGH

typedef struct _discrete_555_desc discrete_555_desc;
struct _discrete_555_desc
{
	int		options;	/* bit mapped options */
	double	v_pos;		/* B+ voltage of 555 */
	double  v_charge;	/* voltage to charge circuit  (Defaults to v_pos) */
	double	v_out_high;	/* High output voltage of 555 (Defaults to v_pos - 1.2V) */
};

#define DEFAULT_555_CC_SOURCE	DEFAULT_555_CHARGE

typedef struct _discrete_555_cc_desc discrete_555_cc_desc;
struct _discrete_555_cc_desc
{
	int		options;		/* bit mapped options */
	double	v_pos;			/* B+ voltage of 555 */
	double	v_cc_source;	/* Voltage of the Constant Current source */
	double	v_out_high;		/* High output voltage of 555 (Defaults to v_pos - 1.2V) */
	double	v_cc_junction;	/* The voltage drop of the Constant Current source transitor (0 if Op Amp) */
};


typedef struct _discrete_555_vco1_desc discrete_555_vco1_desc;
struct _discrete_555_vco1_desc
{
	int    options;				/* bit mapped options */
	double r1, r2, r3, r4, c;
	double v_pos;				/* B+ voltage of 555 */
	double v_charge;			/* (ignored) */
	double v_out_high;			/* High output voltage of 555 (Defaults to v_pos - 1.2V) */
};


typedef struct _discrete_566_desc discrete_566_desc;
struct _discrete_566_desc
{
	int		options;	// bit mapped options
	double	v_pos;		// B+ voltage of 566
	double	v_neg;		// B- voltage of 566
	double	v_charge;
};


typedef struct _discrete_adsr discrete_adsr;
struct _discrete_adsr
{
	double attack_time;  /* All times are in seconds */
	double attack_value;
	double decay_time;
	double decay_value;
	double sustain_time;
	double sustain_value;
	double release_time;
	double release_value;
};


typedef struct _discrete_custom_info discrete_custom_info;
struct _discrete_custom_info
{
	void (*reset)(const device_config *device, node_description *node);	/* Called to reset a node after creation or system reset */
	void (*step)(const device_config *device, node_description *node);	/* Called to execute one time delta of output update */
	size_t contextsize;
	const void *custom;						/* Custom function specific initialisation data */
};


// Taken from the transfer characteristerics diagram in CD4049UB datasheet (TI)
// There is no default trigger point and vI-vO is a continuous function

#define DEFAULT_CD40XX_VALUES(_vB) 	(_vB),(_vB)*0.02,(_vB)*0.98,(_vB)/5.0*1.5,(_vB)/5.0*3.5, 0.1

#define DISC_OSC_INVERTER_IS_TYPE1			0x00
#define DISC_OSC_INVERTER_IS_TYPE2			0x01
#define DISC_OSC_INVERTER_IS_TYPE3			0x02
#define DISC_OSC_INVERTER_IS_TYPE4			0x03
#define DISC_OSC_INVERTER_IS_TYPE5			0x04
#define DISC_OSC_INVERTER_TYPE_MASK			0x0F

#define DISC_OSC_INVERTER_OUT_IS_LOGIC		0x10

typedef struct _discrete_inverter_osc_desc discrete_inverter_osc_desc;
struct _discrete_inverter_osc_desc
{
	double	vB;
	double	vOutLow;
	double	vOutHigh;
	double	vInFall;	// voltage that triggers the gate input to go low (0V) on fall
	double	vInRise;	// voltage that triggers the gate input to go high (vGate) on rise
	double	clamp; 		// voltage is clamped to -clamp ... vb+clamp if clamp>= 0;
	int		options;	// bitmaped options
};


/*************************************
 *
 *  The node numbers themselves
 *
 *************************************/

#define NODE0_DEF(_x) NODE_ ## 0 ## _x = (0x40000000 + (_x) * DISCRETE_MAX_NODE_OUTPUTS), \
	NODE_ ## 0 ## _x ## _01, NODE_ ## 0 ## _x ## _02, NODE_ ## 0 ## _x ## _03, NODE_ ## 0 ## _x ## _04, \
	NODE_ ## 0 ## _x ## _05, NODE_ ## 0 ## _x ## _06, NODE_ ## 0 ## _x ## _07
#define NODE_DEF(_x) NODE_ ## _x = (0x40000000 + (_x) * DISCRETE_MAX_NODE_OUTPUTS), \
	NODE_ ## _x ## _01, NODE_ ## _x ## _02, NODE_ ## _x ## _03, NODE_ ## _x ## _04, \
	NODE_ ## _x ## _05, NODE_ ## _x ## _06, NODE_ ## _x ## _07

enum {
	NODE0_DEF(0), NODE0_DEF(1), NODE0_DEF(2), NODE0_DEF(3), NODE0_DEF(4), NODE0_DEF(5), NODE0_DEF(6), NODE0_DEF(7), NODE0_DEF(8), NODE0_DEF(9),
	NODE_DEF(10), NODE_DEF(11), NODE_DEF(12), NODE_DEF(13), NODE_DEF(14), NODE_DEF(15), NODE_DEF(16), NODE_DEF(17), NODE_DEF(18), NODE_DEF(19),
	NODE_DEF(20), NODE_DEF(21), NODE_DEF(22), NODE_DEF(23), NODE_DEF(24), NODE_DEF(25), NODE_DEF(26), NODE_DEF(27), NODE_DEF(28), NODE_DEF(29),
	NODE_DEF(30), NODE_DEF(31), NODE_DEF(32), NODE_DEF(33), NODE_DEF(34), NODE_DEF(35), NODE_DEF(36), NODE_DEF(37), NODE_DEF(38), NODE_DEF(39),
	NODE_DEF(40), NODE_DEF(41), NODE_DEF(42), NODE_DEF(43), NODE_DEF(44), NODE_DEF(45), NODE_DEF(46), NODE_DEF(47), NODE_DEF(48), NODE_DEF(49),
	NODE_DEF(50), NODE_DEF(51), NODE_DEF(52), NODE_DEF(53), NODE_DEF(54), NODE_DEF(55), NODE_DEF(56), NODE_DEF(57), NODE_DEF(58), NODE_DEF(59),
	NODE_DEF(60), NODE_DEF(61), NODE_DEF(62), NODE_DEF(63), NODE_DEF(64), NODE_DEF(65), NODE_DEF(66), NODE_DEF(67), NODE_DEF(68), NODE_DEF(69),
	NODE_DEF(70), NODE_DEF(71), NODE_DEF(72), NODE_DEF(73), NODE_DEF(74), NODE_DEF(75), NODE_DEF(76), NODE_DEF(77), NODE_DEF(78), NODE_DEF(79),
	NODE_DEF(80), NODE_DEF(81), NODE_DEF(82), NODE_DEF(83), NODE_DEF(84), NODE_DEF(85), NODE_DEF(86), NODE_DEF(87), NODE_DEF(88), NODE_DEF(89),
	NODE_DEF(90), NODE_DEF(91), NODE_DEF(92), NODE_DEF(93), NODE_DEF(94), NODE_DEF(95), NODE_DEF(96), NODE_DEF(97), NODE_DEF(98), NODE_DEF(99),
	NODE_DEF(100),NODE_DEF(101),NODE_DEF(102),NODE_DEF(103),NODE_DEF(104),NODE_DEF(105),NODE_DEF(106),NODE_DEF(107),NODE_DEF(108),NODE_DEF(109),
	NODE_DEF(110),NODE_DEF(111),NODE_DEF(112),NODE_DEF(113),NODE_DEF(114),NODE_DEF(115),NODE_DEF(116),NODE_DEF(117),NODE_DEF(118),NODE_DEF(119),
	NODE_DEF(120),NODE_DEF(121),NODE_DEF(122),NODE_DEF(123),NODE_DEF(124),NODE_DEF(125),NODE_DEF(126),NODE_DEF(127),NODE_DEF(128),NODE_DEF(129),
	NODE_DEF(130),NODE_DEF(131),NODE_DEF(132),NODE_DEF(133),NODE_DEF(134),NODE_DEF(135),NODE_DEF(136),NODE_DEF(137),NODE_DEF(138),NODE_DEF(139),
	NODE_DEF(140),NODE_DEF(141),NODE_DEF(142),NODE_DEF(143),NODE_DEF(144),NODE_DEF(145),NODE_DEF(146),NODE_DEF(147),NODE_DEF(148),NODE_DEF(149),
	NODE_DEF(150),NODE_DEF(151),NODE_DEF(152),NODE_DEF(153),NODE_DEF(154),NODE_DEF(155),NODE_DEF(156),NODE_DEF(157),NODE_DEF(158),NODE_DEF(159),
	NODE_DEF(160),NODE_DEF(161),NODE_DEF(162),NODE_DEF(163),NODE_DEF(164),NODE_DEF(165),NODE_DEF(166),NODE_DEF(167),NODE_DEF(168),NODE_DEF(169),
	NODE_DEF(170),NODE_DEF(171),NODE_DEF(172),NODE_DEF(173),NODE_DEF(174),NODE_DEF(175),NODE_DEF(176),NODE_DEF(177),NODE_DEF(178),NODE_DEF(179),
	NODE_DEF(180),NODE_DEF(181),NODE_DEF(182),NODE_DEF(183),NODE_DEF(184),NODE_DEF(185),NODE_DEF(186),NODE_DEF(187),NODE_DEF(188),NODE_DEF(189),
	NODE_DEF(190),NODE_DEF(191),NODE_DEF(192),NODE_DEF(193),NODE_DEF(194),NODE_DEF(195),NODE_DEF(196),NODE_DEF(197),NODE_DEF(198),NODE_DEF(199),
	NODE_DEF(200),NODE_DEF(201),NODE_DEF(202),NODE_DEF(203),NODE_DEF(204),NODE_DEF(205),NODE_DEF(206),NODE_DEF(207),NODE_DEF(208),NODE_DEF(209),
	NODE_DEF(210),NODE_DEF(211),NODE_DEF(212),NODE_DEF(213),NODE_DEF(214),NODE_DEF(215),NODE_DEF(216),NODE_DEF(217),NODE_DEF(218),NODE_DEF(219),
	NODE_DEF(220),NODE_DEF(221),NODE_DEF(222),NODE_DEF(223),NODE_DEF(224),NODE_DEF(225),NODE_DEF(226),NODE_DEF(227),NODE_DEF(228),NODE_DEF(229),
	NODE_DEF(230),NODE_DEF(231),NODE_DEF(232),NODE_DEF(233),NODE_DEF(234),NODE_DEF(235),NODE_DEF(236),NODE_DEF(237),NODE_DEF(238),NODE_DEF(239),
	NODE_DEF(240),NODE_DEF(241),NODE_DEF(242),NODE_DEF(243),NODE_DEF(244),NODE_DEF(245),NODE_DEF(246),NODE_DEF(247),NODE_DEF(248),NODE_DEF(249),
	NODE_DEF(250),NODE_DEF(251),NODE_DEF(252),NODE_DEF(253),NODE_DEF(254),NODE_DEF(255),NODE_DEF(256),NODE_DEF(257),NODE_DEF(258),NODE_DEF(259),
	NODE_DEF(260),NODE_DEF(261),NODE_DEF(262),NODE_DEF(263),NODE_DEF(264),NODE_DEF(265),NODE_DEF(266),NODE_DEF(267),NODE_DEF(268),NODE_DEF(269),
	NODE_DEF(270),NODE_DEF(271),NODE_DEF(272),NODE_DEF(273),NODE_DEF(274),NODE_DEF(275),NODE_DEF(276),NODE_DEF(277),NODE_DEF(278),NODE_DEF(279),
	NODE_DEF(280),NODE_DEF(281),NODE_DEF(282),NODE_DEF(283),NODE_DEF(284),NODE_DEF(285),NODE_DEF(286),NODE_DEF(287),NODE_DEF(288),NODE_DEF(289),
	NODE_DEF(290),NODE_DEF(291),NODE_DEF(292),NODE_DEF(293),NODE_DEF(294),NODE_DEF(295),NODE_DEF(296),NODE_DEF(297),NODE_DEF(298),NODE_DEF(299)
};

/* Some Pre-defined nodes for convenience */

#define NODE(_x)	(NODE_00 + (_x) * DISCRETE_MAX_NODE_OUTPUTS)
#define NODE_SUB(_x, _y) (NODE(_x) + (_y))

#if DISCRETE_MAX_NODE_OUTPUTS == 8
#define NODE_CHILD_NODE_NUM(_x)		((int)(_x) & 7)
#define NODE_DEFAULT_NODE(_x)		((int)(_x) & ~7)
#define NODE_INDEX(_x)				(((int)(_x) - NODE_START)>>3)
#else
#error "DISCRETE_MAX_NODE_OUTPUTS != 8"
#endif

#define NODE_RELATIVE(_x, _y) (NODE(NODE_INDEX(_x) + (_y)))

#define NODE_NC  NODE_00
#define NODE_SPECIAL  NODE(DISCRETE_MAX_NODES)

#define NODE_START	NODE_00
#define NODE_END	NODE_SPECIAL



/*************************************
 *
 *  Enumerated values for Node types
 *  in the simulation
 *
 *      DSS - Discrete Sound Source
 *      DST - Discrete Sound Transform
 *      DSD - Discrete Sound Device
 *      DSO - Discrete Sound Output
 *
 *************************************/

enum
{
	DSS_NULL,			/* Nothing, nill, zippo, only to be used as terminating node */

	/* from disc_inp.c */
	DSS_ADJUSTMENT,		/* Adjustment node */
	DSS_CONSTANT,		/* Constant node */
	/* Do not change or add to the next 4 without also modifying disc_inp.c */
	DSS_INPUT_DATA,		/* Input node */
	DSS_INPUT_LOGIC,	/* Input node */
	DSS_INPUT_NOT,		/* Input node */
	DSS_INPUT_PULSE,	/* Input node, single pulsed version */
	DSS_INPUT_STREAM,	/* Stream Input */

	/* from disc_wav.c */
	/* generic modules */
	DSS_COUNTER,		/* External clock Binary Counter */
	DSS_COUNTER_FIX,	/* Fixed frequency Binary Counter */
	DSS_LFSR_NOISE,		/* Cyclic/Resetable LFSR based Noise generator */
	DSS_NOTE,			/* Note Generator */
	DSS_NOISE,			/* Random Noise generator */
	DSS_SAWTOOTHWAVE,	/* Sawtooth wave generator */
	DSS_SINEWAVE,		/* Sine Wave generator */
	DSS_SQUAREWAVE,		/* Square Wave generator, adjustable frequency based */
	DSS_SQUAREWFIX,		/* Square Wave generator, fixed frequency based (faster) */
	DSS_SQUAREWAVE2,	/* Square Wave generator, time based */
	DSS_INVERTER_OSC,	/* Oscillator based on inverter circuits */
	DSS_TRIANGLEWAVE,	/* Triangle wave generator, frequency based */
	/* Component specific */
	DSS_OP_AMP_OSC,		/* Op Amp Oscillator */
	DSS_SCHMITT_OSC,	/* Schmitt Feedback Oscillator */
	/* Not yet implemented */
	DSS_ADSR,			/* ADSR Envelope generator */

	/* from disc_mth.c */
	/* generic modules */
	DST_ADDER,			/* C = A+B */
	DST_CLAMP,			/* Signal Clamp */
	DST_DIVIDE,			/* Gain Block, C = A/B */
	DST_GAIN,			/* Gain Block, D = (A*B) + C*/
	DST_LOGIC_INV,
	DST_LOGIC_AND,
	DST_LOGIC_NAND,
	DST_LOGIC_OR,
	DST_LOGIC_NOR,
	DST_LOGIC_XOR,
	DST_LOGIC_NXOR,
	DST_LOGIC_DFF,
	DST_LOGIC_JKFF,
	DST_LOOKUP_TABLE,	/* return value from lookup table */
	DST_MULTIPLEX,		/* 1 of x multiplexer */
	DST_ONESHOT,		/* One-shot pulse generator */
	DST_RAMP,			/* Ramp up/down simulation */
	DST_SAMPHOLD,		/* Sample & hold transform */
	DST_SWITCH,			/* C = A or B */
	DST_ASWITCH,        /* Analog switch */
	DST_TRANSFORM,		/* Muliply math functions based on string */
	/* Component specific */
	DST_COMP_ADDER,		/* Selectable Parallel Component Adder */
	DST_DAC_R1,			/* R1 Ladder DAC with cap smoothing */
	DST_DIODE_MIX,		/* Diode mixer */
	DST_INTEGRATE,		/* Various Integration circuits */
	DST_MIXER,			/* Final Mixing Stage */
	DST_OP_AMP,			/* Op Amp circuits */
	DST_OP_AMP_1SHT,	/* Op Amp One Shot */
	DST_TVCA_OP_AMP,	/* Triggered Op Amp Voltage controlled  amplifier circuits */
	DST_VCA,			/* IC Voltage controlled  amplifiers */
//  DST_DELAY,          /* Phase shift/Delay line */

	/* from disc_flt.c */
	/* generic modules */
	DST_FILTER1,		/* 1st Order Filter, Low or High Pass */
	DST_FILTER2,		/* 2nd Order Filter, Low, High, or Band Pass */
	/* Component specific */
	DST_SALLEN_KEY,		/* Sallen key filters */
	DST_CRFILTER,		/* RC Bypass Filter (High Pass) */
	DST_OP_AMP_FILT,	/* Op Amp filters */
	DST_RCDISC,			/* Simple RC discharge */
	DST_RCDISC2,		/* Switched 2 Input RC discharge */
	DST_RCDISC3,		/* Charge/discharge with diode */
	DST_RCDISC4,		/* various Charge/discharge circuits */
	DST_RCDISC5,        /* Diode in series with R//C */
	DST_RCINTEGRATE,	/* NPN RC charge/discharge network */
	DST_RCDISC_MOD,		/* Two diode mixer with Transistor and charge/discharge network */
	DST_RCFILTER,		/* Simple RC Filter network */
	DST_RCFILTER_SW,	/* Switcheable RC Filter network */
	/* For testing - seem to be buggered.  Use versions not ending in N. */
	DST_RCFILTERN,		/* Simple RC Filter network */
	DST_RCDISCN,		/* Simple RC discharge */
	DST_RCDISC2N,		/* Switched 2 Input RC discharge */

	/* from disc_dev.c */
	/* Component specific */
	DSD_555_ASTBL,		/* NE555 Astable Emulation */
	DSD_555_MSTBL,		/* NE555 Monostable Emulation */
	DSD_555_CC,			/* Constant Current 555 circuit (VCO)*/
	DSD_555_VCO1,		/* Op-Amp linear ramp based 555 VCO */
	DSD_566,			/* NE566 Emulation */
	DSD_LS624,			/* 74LS624 Emulation */

	/* Custom */
	DST_CUSTOM,			/* whatever you want */

	/* Debugging */
	DSO_CSVLOG,			/* Dump nodes as csv file */
	DSO_WAVELOG,		/* Dump nodes as wav file */

	/* Output Node -- this must be the last entry in this enum! */
	DSO_OUTPUT			/* The final output node */
};



/*************************************
 *
 *  Encapsulation macros for defining
 *  your simulation
 *
 *************************************/

#define MDRV_SOUND_CONFIG_DISCRETE(name) MDRV_SOUND_CONFIG(name##_discrete_interface)

#define DISCRETE_SOUND_EXTERN(name) extern const discrete_sound_block name##_discrete_interface[]
#define DISCRETE_SOUND_START(name) const discrete_sound_block name##_discrete_interface[] = {
#define DISCRETE_SOUND_END                                              { NODE_00, DSS_NULL     , 0, { NODE_NC }, { 0 } ,NULL  ,"DISCRETE_SOUND_END" }  };

/* from disc_inp.c */
#define DISCRETE_ADJUSTMENT(NODE,MIN,MAX,LOGLIN,PORT)                   { NODE, DSS_ADJUSTMENT  , 7, { NODE_NC,NODE_NC,NODE_NC,NODE_NC,NODE_NC,NODE_NC }, { MIN,MAX,LOGLIN,PORT,0   ,100  }, NULL  , "DISCRETE_ADJUSTMENT"  },
#define DISCRETE_ADJUSTMENT_TAG(NODE,MIN,MAX,LOGLIN,TAG)                { NODE, DSS_ADJUSTMENT  , 7, { NODE_NC,NODE_NC,NODE_NC,NODE_NC,NODE_NC,NODE_NC }, { MIN,MAX,LOGLIN,0   ,0   ,100  }, TAG   , "DISCRETE_ADJUSTMENT_TAG" },
#define DISCRETE_ADJUSTMENTX(NODE,MIN,MAX,LOGLIN,PORT,PMIN,PMAX)        { NODE, DSS_ADJUSTMENT  , 7, { NODE_NC,NODE_NC,NODE_NC,NODE_NC,NODE_NC,NODE_NC }, { MIN,MAX,LOGLIN,PORT,PMIN,PMAX }, NULL  , "DISCRETE_ADJUSTMENTX"  },
#define DISCRETE_CONSTANT(NODE,CONST)                                   { NODE, DSS_CONSTANT    , 1, { NODE_NC }, { CONST } ,NULL  ,"DISCRETE_CONSTANT" },
#define DISCRETE_INPUT_DATA(NODE)                                       { NODE, DSS_INPUT_DATA  , 3, { NODE_NC,NODE_NC,NODE_NC }, { 1,0,0 }, NULL, "DISCRETE_INPUT_DATA" },
#define DISCRETE_INPUTX_DATA(NODE,GAIN,OFFSET,INIT)                     { NODE, DSS_INPUT_DATA  , 3, { NODE_NC,NODE_NC,NODE_NC }, { GAIN,OFFSET,INIT }, NULL, "DISCRETE_INPUTX_DATA" },
#define DISCRETE_INPUT_LOGIC(NODE)                                      { NODE, DSS_INPUT_LOGIC , 3, { NODE_NC,NODE_NC,NODE_NC }, { 1,0,0 }, NULL, "DISCRETE_INPUT_LOGIC" },
#define DISCRETE_INPUTX_LOGIC(NODE,GAIN,OFFSET,INIT)                    { NODE, DSS_INPUT_LOGIC , 3, { NODE_NC,NODE_NC,NODE_NC }, { GAIN,OFFSET,INIT }, NULL, "DISCRETE_INPUTX_LOGIC" },
#define DISCRETE_INPUT_NOT(NODE)                                        { NODE, DSS_INPUT_NOT   , 3, { NODE_NC,NODE_NC,NODE_NC }, { 1,0,0 }, NULL, "DISCRETE_INPUT_NOT" },
#define DISCRETE_INPUTX_NOT(NODE,GAIN,OFFSET,INIT)                      { NODE, DSS_INPUT_NOT   , 3, { NODE_NC,NODE_NC,NODE_NC }, { GAIN,OFFSET,INIT }, NULL, "DISCRETE_INPUTX_NOT" },
#define DISCRETE_INPUT_PULSE(NODE,INIT)                                 { NODE, DSS_INPUT_PULSE , 3, { NODE_NC,NODE_NC,NODE_NC }, { 1,0,INIT }, NULL, "DISCRETE_INPUT_PULSE" },
#define DISCRETE_INPUT_STREAM(NODE, NUM)                                { NODE, DSS_INPUT_STREAM, 3, { NUM,NODE_NC,NODE_NC }, { NUM,1,0 }, NULL, "DISCRETE_INPUT_STREAM" },
#define DISCRETE_INPUTX_STREAM(NODE, NUM, GAIN,OFFSET)                  { NODE, DSS_INPUT_STREAM, 3, { NUM,NODE_NC,NODE_NC }, { NUM,GAIN,OFFSET }, NULL, "DISCRETE_INPUTX_STREAM" },

/* from disc_wav.c */
/* generic modules */
#define DISCRETE_COUNTER(NODE,ENAB,RESET,CLK,MAX,DIR,INIT0,CLKTYPE)     { NODE, DSS_COUNTER     , 7, { ENAB,RESET,CLK,NODE_NC,DIR,INIT0,NODE_NC }, { ENAB,RESET,CLK,MAX,DIR,INIT0,CLKTYPE }, NULL, "DISCRETE_COUNTER" },
#define DISCRETE_COUNTER_7492(NODE,ENAB,RESET,CLK,CLKTYPE)              { NODE, DSS_COUNTER     , 7, { ENAB,RESET,CLK,NODE_NC,NODE_NC,NODE_NC,NODE_NC }, { ENAB,RESET,CLK,CLKTYPE,1,0,DISC_COUNTER_IS_7492 }, NULL, "DISCRETE_COUNTER_7492" },
#define DISCRETE_LFSR_NOISE(NODE,ENAB,RESET,CLK,AMPL,FEED,BIAS,LFSRTB)  { NODE, DSS_LFSR_NOISE  , 6, { ENAB,RESET,CLK,AMPL,FEED,BIAS }, { ENAB,RESET,CLK,AMPL,FEED,BIAS }, LFSRTB, "DISCRETE_LFSR_NOISE" },
#define DISCRETE_NOISE(NODE,ENAB,FREQ,AMPL,BIAS)                        { NODE, DSS_NOISE       , 4, { ENAB,FREQ,AMPL,BIAS }, { ENAB,FREQ,AMPL,BIAS }, NULL, "DISCRETE_NOISE" },
#define DISCRETE_NOTE(NODE,ENAB,CLK,DATA,MAX1,MAX2,CLKTYPE)             { NODE, DSS_NOTE        , 6, { ENAB,CLK,DATA,NODE_NC,NODE_NC,NODE_NC }, { ENAB,CLK,DATA,MAX1,MAX2,CLKTYPE }, NULL, "DISCRETE_NOTE" },
#define DISCRETE_SAWTOOTHWAVE(NODE,ENAB,FREQ,AMPL,BIAS,GRAD,PHASE)      { NODE, DSS_SAWTOOTHWAVE, 6, { ENAB,FREQ,AMPL,BIAS,NODE_NC,NODE_NC }, { ENAB,FREQ,AMPL,BIAS,GRAD,PHASE }, NULL, "DISCRETE_SAWTOOTHWAVE" },
#define DISCRETE_SINEWAVE(NODE,ENAB,FREQ,AMPL,BIAS,PHASE)               { NODE, DSS_SINEWAVE    , 5, { ENAB,FREQ,AMPL,BIAS,NODE_NC }, { ENAB,FREQ,AMPL,BIAS,PHASE }, NULL, "DISCRETE_SINEWAVE" },
#define DISCRETE_SQUAREWAVE(NODE,ENAB,FREQ,AMPL,DUTY,BIAS,PHASE)        { NODE, DSS_SQUAREWAVE  , 6, { ENAB,FREQ,AMPL,DUTY,BIAS,NODE_NC }, { ENAB,FREQ,AMPL,DUTY,BIAS,PHASE }, NULL, "DISCRETE_SQUAREWAVE" },
#define DISCRETE_SQUAREWFIX(NODE,ENAB,FREQ,AMPL,DUTY,BIAS,PHASE)        { NODE, DSS_SQUAREWFIX  , 6, { ENAB,FREQ,AMPL,DUTY,BIAS,NODE_NC }, { ENAB,FREQ,AMPL,DUTY,BIAS,PHASE }, NULL, "DISCRETE_SQUAREWFIX" },
#define DISCRETE_SQUAREWAVE2(NODE,ENAB,AMPL,T_OFF,T_ON,BIAS,TSHIFT)     { NODE, DSS_SQUAREWAVE2 , 6, { ENAB,AMPL,T_OFF,T_ON,BIAS,NODE_NC }, { ENAB,AMPL,T_OFF,T_ON,BIAS,TSHIFT }, NULL, "DISCRETE_SQUAREWAVE2" },
#define DISCRETE_TRIANGLEWAVE(NODE,ENAB,FREQ,AMPL,BIAS,PHASE)           { NODE, DSS_TRIANGLEWAVE, 5, { ENAB,FREQ,AMPL,BIAS,NODE_NC }, { ENAB,FREQ,AMPL,BIAS,PHASE }, NULL, "DISCRETE_TRIANGLEWAVE" },
/* Component specific */
#define DISCRETE_INVERTER_OSC(NODE,ENAB,MOD,RCHARGE,RP,C,R2,INFO)       { NODE, DSS_INVERTER_OSC, 6, { ENAB,MOD,NODE_NC,NODE_NC,NODE_NC }, { ENAB,MOD,RCHARGE,RP,C,R2 }, INFO, "DISCRETE_INVERTER_OSC" },
#define DISCRETE_OP_AMP_OSCILLATOR(NODE,ENAB,INFO)                      { NODE, DSS_OP_AMP_OSC  , 1, { ENAB }, { ENAB }, INFO, "DISCRETE_OP_AMP_OSCILLATOR" },
#define DISCRETE_OP_AMP_VCO1(NODE,ENAB,VMOD1,INFO)                      { NODE, DSS_OP_AMP_OSC  , 2, { ENAB,VMOD1 }, { ENAB,VMOD1 }, INFO, "DISCRETE_OP_AMP_VCO1" },
#define DISCRETE_OP_AMP_VCO2(NODE,ENAB,VMOD1,VMOD2,INFO)                { NODE, DSS_OP_AMP_OSC  , 3, { ENAB,VMOD1,VMOD2 }, { ENAB,VMOD1,VMOD2 }, INFO, "DISCRETE_OP_AMP_VCO2" },
#define DISCRETE_SCHMITT_OSCILLATOR(NODE,ENAB,INP0,AMPL,TABLE)          { NODE, DSS_SCHMITT_OSC , 3, { ENAB,INP0,AMPL }, { ENAB,INP0,AMPL }, TABLE, "DISCRETE_SCHMITT_OSCILLATOR" },
/* Not yet implemented */
#define DISCRETE_ADSR_ENV(NODE,ENAB,TRIGGER,GAIN,ADSRTB)                { NODE, DSS_ADSR        , 3, { ENAB,TRIGGER,GAIN }, { ENAB,TRIGGER,GAIN }, ADSRTB, "DISCRETE_ADSR_ENV" },

/* from disc_mth.c */
/* generic modules */
#define DISCRETE_ADDER2(NODE,ENAB,INP0,INP1)                            { NODE, DST_ADDER       , 3, { ENAB,INP0,INP1 }, { ENAB,INP0,INP1 }, NULL, "DISCRETE_ADDER2" },
#define DISCRETE_ADDER3(NODE,ENAB,INP0,INP1,INP2)                       { NODE, DST_ADDER       , 4, { ENAB,INP0,INP1,INP2 }, { ENAB,INP0,INP1,INP2 }, NULL, "DISCRETE_ADDER3" },
#define DISCRETE_ADDER4(NODE,ENAB,INP0,INP1,INP2,INP3)                  { NODE, DST_ADDER       , 5, { ENAB,INP0,INP1,INP2,INP3 }, { ENAB,INP0,INP1,INP2,INP3 }, NULL, "DISCRETE_ADDER4" },
#define DISCRETE_CLAMP(NODE,ENAB,INP0,MIN,MAX,CLAMP)                    { NODE, DST_CLAMP       , 5, { ENAB,INP0,MIN,MAX,CLAMP }, { ENAB,INP0,MIN,MAX,CLAMP }, NULL, "DISCRETE_CLAMP" },
#define DISCRETE_DIVIDE(NODE,ENAB,INP0,INP1)                            { NODE, DST_DIVIDE      , 3, { ENAB,INP0,INP1 }, { ENAB,INP0,INP1 }, NULL, "DISCRETE_DIVIDE" },
#define DISCRETE_GAIN(NODE,INP0,GAIN)                                   { NODE, DST_GAIN        , 4, { NODE_NC,INP0,NODE_NC,NODE_NC }, { 1,INP0,GAIN,0 }, NULL, "DISCRETE_GAIN" },
#define DISCRETE_INVERT(NODE,INP0)                                      { NODE, DST_GAIN        , 4, { NODE_NC,INP0,NODE_NC,NODE_NC }, { 1,INP0,-1,0 }, NULL, "DISCRETE_INVERT" },
#define DISCRETE_LOGIC_INVERT(NODE,ENAB,INP0)                           { NODE, DST_LOGIC_INV   , 2, { ENAB,INP0 }, { ENAB,INP0 }, NULL, "DISCRETE_LOGIC_INVERT" },
#define DISCRETE_LOGIC_AND(NODE,ENAB,INP0,INP1)                         { NODE, DST_LOGIC_AND   , 5, { ENAB,INP0,INP1,NODE_NC,NODE_NC }, { ENAB,INP0,INP1,1.0,1.0 }, NULL, "DISCRETE_LOGIC_AND" },
#define DISCRETE_LOGIC_AND3(NODE,ENAB,INP0,INP1,INP2)                   { NODE, DST_LOGIC_AND   , 5, { ENAB,INP0,INP1,INP2,NODE_NC }, { ENAB,INP0,INP1,INP2,1.0 }, NULL, "DISCRETE_LOGIC_AND3" },
#define DISCRETE_LOGIC_AND4(NODE,ENAB,INP0,INP1,INP2,INP3)              { NODE, DST_LOGIC_AND   , 5, { ENAB,INP0,INP1,INP2,INP3 }, { ENAB,INP0,INP1,INP2,INP3 } ,NULL, "DISCRETE_LOGIC_AND4" },
#define DISCRETE_LOGIC_NAND(NODE,ENAB,INP0,INP1)                        { NODE, DST_LOGIC_NAND  , 5, { ENAB,INP0,INP1,NODE_NC,NODE_NC }, { ENAB,INP0,INP1,1.0,1.0 }, NULL, "DISCRETE_LOGIC_NAND" },
#define DISCRETE_LOGIC_NAND3(NODE,ENAB,INP0,INP1,INP2)                  { NODE, DST_LOGIC_NAND  , 5, { ENAB,INP0,INP1,INP2,NODE_NC }, { ENAB,INP0,INP1,INP2,1.0 }, NULL, "DISCRETE_LOGIC_NAND3" },
#define DISCRETE_LOGIC_NAND4(NODE,ENAB,INP0,INP1,INP2,INP3)             { NODE, DST_LOGIC_NAND  , 5, { ENAB,INP0,INP1,INP2,INP3 }, { ENAB,INP0,INP1,INP2,INP3 }, NULL, ")DISCRETE_LOGIC_NAND4" },
#define DISCRETE_LOGIC_OR(NODE,ENAB,INP0,INP1)                          { NODE, DST_LOGIC_OR    , 5, { ENAB,INP0,INP1,NODE_NC,NODE_NC }, { ENAB,INP0,INP1,0.0,0.0 }, NULL, "DISCRETE_LOGIC_OR" },
#define DISCRETE_LOGIC_OR3(NODE,ENAB,INP0,INP1,INP2)                    { NODE, DST_LOGIC_OR    , 5, { ENAB,INP0,INP1,INP2,NODE_NC }, { ENAB,INP0,INP1,INP2,0.0 }, NULL, "DISCRETE_LOGIC_OR3" },
#define DISCRETE_LOGIC_OR4(NODE,ENAB,INP0,INP1,INP2,INP3)               { NODE, DST_LOGIC_OR    , 5, { ENAB,INP0,INP1,INP2,INP3 }, { ENAB,INP0,INP1,INP2,INP3 }, NULL, "DISCRETE_LOGIC_OR4" },
#define DISCRETE_LOGIC_NOR(NODE,ENAB,INP0,INP1)                         { NODE, DST_LOGIC_NOR   , 5, { ENAB,INP0,INP1,NODE_NC,NODE_NC }, { ENAB,INP0,INP1,0.0,0.0 }, NULL, "DISCRETE_LOGIC_NOR" },
#define DISCRETE_LOGIC_NOR3(NODE,ENAB,INP0,INP1,INP2)                   { NODE, DST_LOGIC_NOR   , 5, { ENAB,INP0,INP1,INP2,NODE_NC }, { ENAB,INP0,INP1,INP2,0.0 }, NULL, "DISCRETE_LOGIC_NOR3" },
#define DISCRETE_LOGIC_NOR4(NODE,ENAB,INP0,INP1,INP2,INP3)              { NODE, DST_LOGIC_NOR   , 5, { ENAB,INP0,INP1,INP2,INP3 }, { ENAB,INP0,INP1,INP2,INP3 }, NULL, "DISCRETE_LOGIC_NOR4" },
#define DISCRETE_LOGIC_XOR(NODE,ENAB,INP0,INP1)                         { NODE, DST_LOGIC_XOR   , 3, { ENAB,INP0,INP1 }, { ENAB,INP0,INP1 }, NULL, "DISCRETE_LOGIC_XOR" },
#define DISCRETE_LOGIC_NXOR(NODE,ENAB,INP0,INP1)                        { NODE, DST_LOGIC_NXOR  , 3, { ENAB,INP0,INP1 }, { ENAB,INP0,INP1 }, NULL, "DISCRETE_LOGIC_NXOR" },
#define DISCRETE_LOGIC_DFLIPFLOP(NODE,ENAB,RESET,SET,CLK,INP)           { NODE, DST_LOGIC_DFF   , 5, { ENAB,RESET,SET,CLK,INP }, { ENAB,RESET,SET,CLK,INP }, NULL, "DISCRETE_LOGIC_DFLIPFLOP" },
#define DISCRETE_LOGIC_JKFLIPFLOP(NODE,ENAB,RESET,SET,CLK,J,K)          { NODE, DST_LOGIC_JKFF  , 6, { ENAB,RESET,SET,CLK,J,K }, { ENAB,RESET,SET,CLK,J,K }, NULL, "DISCRETE_LOGIC_JKFLIPFLOP" },
#define DISCRETE_LOOKUP_TABLE(NODE,ENAB,ADDR,SIZE,TABLE)                { NODE, DST_LOOKUP_TABLE, 3, { ENAB,ADDR,NODE_NC }, { ENAB,ADDR,SIZE }, TABLE, "DISCRETE_LOOKUP_TABLE" },
#define DISCRETE_MULTIPLEX2(NODE,ENAB,ADDR,INP0,INP1)                   { NODE, DST_MULTIPLEX   , 4, { ENAB,ADDR,INP0,INP1 }, { ENAB,ADDR,INP0,INP1 }, NULL, "DISCRETE_MULTIPLEX2" },
#define DISCRETE_MULTIPLEX4(NODE,ENAB,ADDR,INP0,INP1,INP2,INP3)         { NODE, DST_MULTIPLEX   , 6, { ENAB,ADDR,INP0,INP1,INP2,INP3 }, { ENAB,ADDR,INP0,INP1,INP2,INP3 }, NULL, "DISCRETE_MULTIPLEX4" },
#define DISCRETE_MULTIPLEX8(NODE,ENAB,ADDR,INP0,INP1,INP2,INP3,INP4,INP5,INP6,INP7) { NODE, DST_MULTIPLEX, 10, { ENAB,ADDR,INP0,INP1,INP2,INP3,INP4,INP5,INP6,INP7 }, { ENAB,ADDR,INP0,INP1,INP2,INP3,INP4,INP5,INP6,INP7 }, NULL, "DISCRETE_MULTIPLEX8" },
#define DISCRETE_MULTIPLY(NODE,ENAB,INP0,INP1)                          { NODE, DST_GAIN        , 4, { ENAB,INP0,INP1,NODE_NC }, { ENAB,INP0,INP1,0 }, NULL, "DISCRETE_MULTIPLY" },
#define DISCRETE_MULTADD(NODE,ENAB,INP0,INP1,INP2)                      { NODE, DST_GAIN        , 4, { ENAB,INP0,INP1,INP2 }, { ENAB,INP0,INP1,INP2 }, NULL, "DISCRETE_MULTADD" },
#define DISCRETE_ONESHOT(NODE,TRIG,AMPL,WIDTH,TYPE)                     { NODE, DST_ONESHOT     , 5, { NODE_NC,TRIG,AMPL,WIDTH,NODE_NC }, { 0,TRIG,AMPL,WIDTH,TYPE }, NULL, "DISCRETE_ONESHOT" },
#define DISCRETE_ONESHOTR(NODE,RESET,TRIG,AMPL,WIDTH,TYPE)              { NODE, DST_ONESHOT     , 5, { RESET,TRIG,AMPL,WIDTH,NODE_NC }, { RESET,TRIG,AMPL,WIDTH,TYPE }, NULL, "One Shot Resetable" },
#define DISCRETE_ONOFF(NODE,ENAB,INP0)                                  { NODE, DST_GAIN        , 4, { ENAB,INP0,NODE_NC,NODE_NC }, { ENAB,0,1,0 }, NULL, "DISCRETE_ONOFF" },
#define DISCRETE_RAMP(NODE,ENAB,RAMP,GRAD,START,END,CLAMP)              { NODE, DST_RAMP        , 6, { ENAB,RAMP,GRAD,START,END,CLAMP }, { ENAB,RAMP,GRAD,START,END,CLAMP }, NULL, "DISCRETE_RAMP" },
#define DISCRETE_SAMPLHOLD(NODE,ENAB,INP0,CLOCK,CLKTYPE)                { NODE, DST_SAMPHOLD    , 4, { ENAB,INP0,CLOCK,NODE_NC }, { ENAB,INP0,CLOCK,CLKTYPE }, NULL, "DISCRETE_SAMPLHOLD" },
#define DISCRETE_SWITCH(NODE,ENAB,SWITCH,INP0,INP1)                     { NODE, DST_SWITCH      , 4, { ENAB,SWITCH,INP0,INP1 }, { ENAB,SWITCH,INP0,INP1 }, NULL, "DISCRETE_SWITCH" },
#define DISCRETE_ASWITCH(NODE,ENAB,CTRL,INP,THRESHOLD)                  { NODE, DST_ASWITCH     , 3, { ENAB,CTRL,INP,THRESHOLD }, { ENAB,CTRL,INP, THRESHOLD}, NULL, "Analog Switch" },
#define DISCRETE_TRANSFORM2(NODE,INP0,INP1,FUNCT)                       { NODE, DST_TRANSFORM   , 2, { INP0,INP1 }, { INP0,INP1 }, FUNCT, "DISCRETE_TRANSFORM2" },
#define DISCRETE_TRANSFORM3(NODE,INP0,INP1,INP2,FUNCT)                  { NODE, DST_TRANSFORM   , 3, { INP0,INP1,INP2 }, { INP0,INP1,INP2 }, FUNCT, "DISCRETE_TRANSFORM3" },
#define DISCRETE_TRANSFORM4(NODE,INP0,INP1,INP2,INP3,FUNCT)             { NODE, DST_TRANSFORM   , 4, { INP0,INP1,INP2,INP3 }, { INP0,INP1,INP2,INP3 }, FUNCT, "DISCRETE_TRANSFORM4" },
#define DISCRETE_TRANSFORM5(NODE,INP0,INP1,INP2,INP3,INP4,FUNCT)        { NODE, DST_TRANSFORM   , 5, { INP0,INP1,INP2,INP3,INP4 }, { INP0,INP1,INP2,INP3,INP4 }, FUNCT, "DISCRETE_TRANSFORM5" },
/* Component specific */
#define DISCRETE_COMP_ADDER(NODE,DATA,TABLE)                            { NODE, DST_COMP_ADDER  , 1, { DATA }, { DATA }, TABLE, "DISCRETE_COMP_ADDER" },
#define DISCRETE_DAC_R1(NODE,ENAB,DATA,VDATA,LADDER)                    { NODE, DST_DAC_R1      , 3, { ENAB,DATA,VDATA }, { ENAB,DATA,VDATA }, LADDER, "DISCRETE_DAC_R1" },
#define DISCRETE_DIODE_MIXER2(NODE,IN0,IN1,TABLE)                       { NODE, DST_DIODE_MIX   , 3, { IN0,IN1 }, { IN0,IN1 }, TABLE, "DISCRETE_DIODE_MIXER2" },
#define DISCRETE_DIODE_MIXER3(NODE,IN0,IN1,IN2,TABLE)                   { NODE, DST_DIODE_MIX   , 4, { IN0,IN1,IN2 }, { IN0,IN1,IN2 }, TABLE, "DISCRETE_DIODE_MIXER3" },
#define DISCRETE_DIODE_MIXER4(NODE,IN0,IN1,IN2,IN3,TABLE)               { NODE, DST_DIODE_MIX   , 5, { IN0,IN1,IN2,IN3 }, { IN0,IN1,IN2,IN3 }, TABLE, "DISCRETE_DIODE_MIXER4" },
#define DISCRETE_INTEGRATE(NODE,TRG0,TRG1,INFO)                         { NODE, DST_INTEGRATE   , 2, { TRG0,TRG1 }, { TRG0,TRG1 }, INFO, "DISCRETE_INTEGRATE" },
#define DISCRETE_MIXER2(NODE,ENAB,IN0,IN1,INFO)                         { NODE, DST_MIXER       , 3, { ENAB,IN0,IN1 }, { ENAB,IN0,IN1 }, INFO, "DISCRETE_MIXER2" },
#define DISCRETE_MIXER3(NODE,ENAB,IN0,IN1,IN2,INFO)                     { NODE, DST_MIXER       , 4, { ENAB,IN0,IN1,IN2 }, { ENAB,IN0,IN1,IN2 }, INFO, "DISCRETE_MIXER3" },
#define DISCRETE_MIXER4(NODE,ENAB,IN0,IN1,IN2,IN3,INFO)                 { NODE, DST_MIXER       , 5, { ENAB,IN0,IN1,IN2,IN3 }, { ENAB,IN0,IN1,IN2,IN3 }, INFO, "DISCRETE_MIXER4" },
#define DISCRETE_MIXER5(NODE,ENAB,IN0,IN1,IN2,IN3,IN4,INFO)             { NODE, DST_MIXER       , 6, { ENAB,IN0,IN1,IN2,IN3,IN4 }, { ENAB,IN0,IN1,IN2,IN3,IN4 }, INFO, "DISCRETE_MIXER5" },
#define DISCRETE_MIXER6(NODE,ENAB,IN0,IN1,IN2,IN3,IN4,IN5,INFO)         { NODE, DST_MIXER       , 7, { ENAB,IN0,IN1,IN2,IN3,IN4,IN5 }, { ENAB,IN0,IN1,IN2,IN3,IN4,IN5 }, INFO, "DISCRETE_MIXER6" },
#define DISCRETE_MIXER7(NODE,ENAB,IN0,IN1,IN2,IN3,IN4,IN5,IN6,INFO)     { NODE, DST_MIXER       , 8, { ENAB,IN0,IN1,IN2,IN3,IN4,IN5,IN6 }, { ENAB,IN0,IN1,IN2,IN3,IN4,IN5,IN6 }, INFO, "DISCRETE_MIXER7" },
#define DISCRETE_MIXER8(NODE,ENAB,IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7,INFO) { NODE, DST_MIXER       , 9, { ENAB,IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7 }, { ENAB,IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7 }, INFO, "DISCRETE_MIXER8" },
#define DISCRETE_OP_AMP(NODE,ENAB,IN0,IN1,INFO)                         { NODE, DST_OP_AMP      , 3, { ENAB,IN0,IN1 }, { ENAB,IN0,IN1 }, INFO, "DISCRETE_OP_AMP" },
#define DISCRETE_OP_AMP_ONESHOT(NODE,TRIG,INFO)                         { NODE, DST_OP_AMP_1SHT , 1, { TRIG }, { TRIG }, INFO, "DISCRETE_OP_AMP_ONESHOT" },
#define DISCRETE_OP_AMP_TRIG_VCA(NODE,TRG0,TRG1,TRG2,IN0,IN1,INFO)      { NODE, DST_TVCA_OP_AMP , 5, { TRG0,TRG1,TRG2,IN0,IN1 }, { TRG0,TRG1,TRG2,IN0,IN1 }, INFO, "DISCRETE_OP_AMP_TRIG_VCA" },
#define DISCRETE_VCA(NODE,ENAB,IN0,CTRL,TYPE)                           { NODE, DST_VCA         , 4, { ENAB,IN0,CTRL,NODE_NC }, { ENAB,IN0,CTRL,TYPE }, NULL, "DISCRETE_VCA" },

/* from disc_flt.c */
/* generic modules */
#define DISCRETE_FILTER1(NODE,ENAB,INP0,FREQ,TYPE)                      { NODE, DST_FILTER1     , 4, { ENAB,INP0,NODE_NC,NODE_NC }, { ENAB,INP0,FREQ,TYPE }, NULL, "DISCRETE_FILTER1" },
#define DISCRETE_FILTER2(NODE,ENAB,INP0,FREQ,DAMP,TYPE)                 { NODE, DST_FILTER2     , 5, { ENAB,INP0,NODE_NC,NODE_NC,NODE_NC }, { ENAB,INP0,FREQ,DAMP,TYPE }, NULL, "DISCRETE_FILTER2" },
/* Component specific */
#define DISCRETE_SALLEN_KEY_FILTER(NODE,ENAB,INP0,TYPE,INFO)            { NODE, DST_SALLEN_KEY  , 3, { ENAB,INP0,NODE_NC }, { ENAB,INP0,TYPE }, INFO, "DISCRETE_SALLEN_KEY_FILTER" },
#define DISCRETE_CRFILTER(NODE,ENAB,INP0,RVAL,CVAL)                     { NODE, DST_CRFILTER    , 4, { ENAB,INP0,NODE_NC,NODE_NC }, { ENAB,INP0,RVAL,CVAL }, NULL, "DISCRETE_CRFILTER" },
#define DISCRETE_CRFILTER_VREF(NODE,ENAB,INP0,RVAL,CVAL,VREF)           { NODE, DST_CRFILTER    , 5, { ENAB,INP0,NODE_NC,NODE_NC,NODE_NC }, { ENAB,INP0,RVAL,CVAL,VREF }, NULL, "DISCRETE_CRFILTER_VREF" },
#define DISCRETE_OP_AMP_FILTER(NODE,ENAB,INP0,INP1,TYPE,INFO)           { NODE, DST_OP_AMP_FILT , 4, { ENAB,INP0,INP1,NODE_NC }, { ENAB,INP0,INP1,TYPE }, INFO, "DISCRETE_OP_AMP_FILTER" },
#define DISCRETE_RCDISC(NODE,ENAB,INP0,RVAL,CVAL)                       { NODE, DST_RCDISC      , 4, { ENAB,INP0,NODE_NC,NODE_NC }, { ENAB,INP0,RVAL,CVAL }, NULL, "DISCRETE_RCDISC" },
#define DISCRETE_RCDISC2(NODE,SWITCH,INP0,RVAL0,INP1,RVAL1,CVAL)        { NODE, DST_RCDISC2     , 6, { SWITCH,INP0,NODE_NC,INP1,NODE_NC,NODE_NC }, { SWITCH,INP0,RVAL0,INP1,RVAL1,CVAL }, NULL, "DISCRETE_RCDISC2" },
#define DISCRETE_RCDISC3(NODE,ENAB,INP0,RVAL0,RVAL1,CVAL)               { NODE, DST_RCDISC3     , 5, { ENAB,INP0,NODE_NC,NODE_NC,NODE_NC }, { ENAB,INP0,RVAL0,RVAL1,CVAL }, NULL, "DISCRETE_RCDISC3" },
#define DISCRETE_RCDISC4(NODE,ENAB,INP0,RVAL0,RVAL1,RVAL2,CVAL,VP,TYPE) { NODE, DST_RCDISC4     , 8, { ENAB,INP0,NODE_NC,NODE_NC,NODE_NC,NODE_NC,NODE_NC,NODE_NC }, { ENAB,INP0,RVAL0,RVAL1,RVAL2,CVAL,VP,TYPE }, NULL, "DISCRETE_RCDISC4" },
#define DISCRETE_RCDISC5(NODE,ENAB,INP0,RVAL,CVAL)                      { NODE, DST_RCDISC5     , 4, { ENAB,INP0,NODE_NC,NODE_NC }, { ENAB,INP0,RVAL,CVAL }, NULL, "DISCRETE_RCDISC5" },
#define DISCRETE_RCDISC_MODULATED(NODE,INP0,INP1,RVAL0,RVAL1,RVAL2,RVAL3,CVAL,VP)	{ NODE, DST_RCDISC_MOD, 8, { INP0,INP1,NODE_NC,NODE_NC,NODE_NC,NODE_NC,NODE_NC,NODE_NC }, { INP0,INP1,RVAL0,RVAL1,RVAL2,RVAL3,CVAL,VP }, NULL, "DISCRETE_RCDISC_MODULATED" },
#define DISCRETE_RCFILTER(NODE,ENAB,INP0,RVAL,CVAL)                     { NODE, DST_RCFILTER    , 4, { ENAB,INP0,NODE_NC,NODE_NC }, { ENAB,INP0,RVAL,CVAL }, NULL, "DISCRETE_RCFILTER" },
#define DISCRETE_RCFILTER_SW(NODE,ENAB,INP0,SW,RVAL,CVAL1,CVAL2,CVAL3,CVAL4) { NODE, DST_RCFILTER_SW, 8, { ENAB,INP0,SW,NODE_NC,NODE_NC,NODE_NC,NODE_NC,NODE_NC }, { ENAB,INP0,SW,RVAL,CVAL1,CVAL2,CVAL3,CVAL4 }, NULL, "DISCRETE_RCFILTER_SW" },
#define DISCRETE_RCFILTER_VREF(NODE,ENAB,INP0,RVAL,CVAL,VREF)           { NODE, DST_RCFILTER    , 5, { ENAB,INP0,NODE_NC,NODE_NC,NODE_NC }, { ENAB,INP0,RVAL,CVAL,VREF }, NULL, "DISCRETE_RCFILTER_VREF" },
#define DISCRETE_RCINTEGRATE(NODE,INP0,RVAL0,RVAL1,RVAL2,CVAL,vP,TYPE)  { NODE, DST_RCINTEGRATE , 7, { INP0,NODE_NC,NODE_NC,NODE_NC,NODE_NC,NODE_NC,NODE_NC }, { INP0,RVAL0,RVAL1,RVAL2,CVAL,vP,TYPE }, NULL, "DISCRETE_RCINTEGRATE" },
/* For testing - seem to be buggered.  Use versions not ending in N. */
#define DISCRETE_RCDISCN(NODE,ENAB,INP0,RVAL,CVAL)                      { NODE, DST_RCDISCN     , 4, { ENAB,INP0,NODE_NC,NODE_NC }, { ENAB,INP0,RVAL,CVAL }, NULL, "DISCRETE_RCDISCN" },
#define DISCRETE_RCDISC2N(NODE,SWITCH,INP0,RVAL0,INP1,RVAL1,CVAL)       { NODE, DST_RCDISC2N    , 6, { SWITCH,INP0,NODE_NC,INP1,NODE_NC,NODE_NC }, { SWITCH,INP0,RVAL0,INP1,RVAL1,CVAL }, NULL, "DISCRETE_RCDISC2N" },
#define DISCRETE_RCFILTERN(NODE,ENAB,INP0,RVAL,CVAL)                    { NODE, DST_RCFILTERN   , 4, { ENAB,INP0,NODE_NC,NODE_NC }, { ENAB,INP0,RVAL,CVAL }, NULL, "DISCRETE_RCFILTERN" },

/* from disc_dev.c */
/* generic modules */
#define DISCRETE_CUSTOM1(NODE,IN0,INFO)                                 { NODE, DST_CUSTOM      , 1, { IN0 }, { IN0 }, INFO, "DISCRETE_CUSTOM1" },
#define DISCRETE_CUSTOM2(NODE,IN0,IN1,INFO)                             { NODE, DST_CUSTOM      , 2, { IN0,IN1 }, { IN0,IN1 }, INFO, "DISCRETE_CUSTOM2" },
#define DISCRETE_CUSTOM3(NODE,IN0,IN1,IN2,INFO)                         { NODE, DST_CUSTOM      , 3, { IN0,IN1,IN2 }, { IN0,IN1,IN2 }, INFO, "DISCRETE_CUSTOM3" },
#define DISCRETE_CUSTOM4(NODE,IN0,IN1,IN2,IN3,INFO)                     { NODE, DST_CUSTOM      , 4, { IN0,IN1,IN2,IN3 }, { IN0,IN1,IN2,IN3 }, INFO, "DISCRETE_CUSTOM4" },
#define DISCRETE_CUSTOM5(NODE,IN0,IN1,IN2,IN3,IN4,INFO)                 { NODE, DST_CUSTOM      , 5, { IN0,IN1,IN2,IN3,IN4 }, { IN0,IN1,IN2,IN3,IN4 }, INFO, "DISCRETE_CUSTOM5" },
#define DISCRETE_CUSTOM6(NODE,IN0,IN1,IN2,IN3,IN4,IN5,INFO)             { NODE, DST_CUSTOM      , 6, { IN0,IN1,IN2,IN3,IN4,IN5 }, { IN0,IN1,IN2,IN3,IN4,IN5 }, INFO, "DISCRETE_CUSTOM6" },
#define DISCRETE_CUSTOM7(NODE,IN0,IN1,IN2,IN3,IN4,IN5,IN6,INFO)         { NODE, DST_CUSTOM      , 7, { IN0,IN1,IN2,IN3,IN4,IN5,IN6 }, { IN0,IN1,IN2,IN3,IN4,IN5,IN6 }, INFO, "DISCRETE_CUSTOM7" },
#define DISCRETE_CUSTOM8(NODE,IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7,INFO)     { NODE, DST_CUSTOM      , 8, { IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7 }, { IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7 }, INFO, "DISCRETE_CUSTOM8" },
#define DISCRETE_CUSTOM9(NODE,IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8,INFO) { NODE, DST_CUSTOM      , 9, { IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8 }, { IN0,IN1,IN2,IN3,IN4,IN5,IN6,IN7,IN8 }, INFO, "DISCRETE_CUSTOM9" },
/* Component specific */
#define DISCRETE_555_ASTABLE(NODE,RESET,R1,R2,C,OPTIONS)                { NODE, DSD_555_ASTBL   , 5, { RESET,R1,R2,C,NODE_NC }, { RESET,R1,R2,C,-1 }, OPTIONS, "DISCRETE_555_ASTABLE" },
#define DISCRETE_555_ASTABLE_CV(NODE,RESET,R1,R2,C,CTRLV,OPTIONS)       { NODE, DSD_555_ASTBL   , 5, { RESET,R1,R2,C,CTRLV }, { RESET,R1,R2,C,CTRLV }, OPTIONS, "DISCRETE_555_ASTABLE_CV" },
#define DISCRETE_555_MSTABLE(NODE,RESET,TRIG,R,C,OPTIONS)               { NODE, DSD_555_MSTBL   , 4, { RESET,TRIG,R,C }, { RESET,TRIG,R,C }, OPTIONS, "DISCRETE_555_MSTABLE" },
#define DISCRETE_555_CC(NODE,RESET,VIN,R,C,RBIAS,RGND,RDIS,OPTIONS)     { NODE, DSD_555_CC      , 7, { RESET,VIN,R,C,RBIAS,RGND,RDIS }, { RESET,VIN,R,C,RBIAS,RGND,RDIS }, OPTIONS, "DISCRETE_555_CC" },
#define DISCRETE_555_VCO1(NODE,RESET,VIN,OPTIONS)                       { NODE, DSD_555_VCO1    , 3, { RESET,VIN,NODE_NC }, { RESET,VIN,-1 }, OPTIONS, "DISCRETE_555_VCO1" },
#define DISCRETE_555_VCO1_CV(NODE,RESET,VIN,CTRLV,OPTIONS)              { NODE, DSD_555_VCO1    , 3, { RESET,VIN,CTRLV }, { RESET,VIN,CTRLV }, OPTIONS, "DISCRETE_555_VCO1_CV" },
#define DISCRETE_566(NODE,ENAB,VMOD,R,C,OPTIONS)                        { NODE, DSD_566         , 4, { ENAB,VMOD,R,C }, { ENAB,VMOD,R,C }, OPTIONS, "DISCRETE_566" },
#define DISCRETE_74LS624(NODE,ENAB,VMOD,VRNG,C,OUTTYPE)                 { NODE, DSD_LS624       , 5, { ENAB,VMOD,VRNG,C,NODE_NC }, { ENAB,VMOD,VRNG,C, OUTTYPE }, NULL, "DISCRETE_74LS624" },

/* logging */
#define DISCRETE_CSVLOG1(NODE1)                                    { NODE_SPECIAL, DSO_CSVLOG   , 1, { NODE1 }, { NODE1 }, NULL, "DISCRETE_CSVLOG1" },
#define DISCRETE_CSVLOG2(NODE1,NODE2)                              { NODE_SPECIAL, DSO_CSVLOG   , 2, { NODE1,NODE2 }, { NODE1,NODE2 }, NULL, "DISCRETE_CSVLOG2" },
#define DISCRETE_CSVLOG3(NODE1,NODE2,NODE3)                        { NODE_SPECIAL, DSO_CSVLOG   , 3, { NODE1,NODE2,NODE3 }, { NODE1,NODE2,NODE3 }, NULL, "DISCRETE_CSVLOG3" },
#define DISCRETE_CSVLOG4(NODE1,NODE2,NODE3,NODE4)                  { NODE_SPECIAL, DSO_CSVLOG   , 4, { NODE1,NODE2,NODE3,NODE4 }, { NODE1,NODE2,NODE3,NODE4 }, NULL, "DISCRETE_CSVLOG4" },
#define DISCRETE_CSVLOG5(NODE1,NODE2,NODE3,NODE4,NODE5)            { NODE_SPECIAL, DSO_CSVLOG   , 5, { NODE1,NODE2,NODE3,NODE4,NODE5 }, { NODE1,NODE2,NODE3,NODE4,NODE5 }, NULL, "DISCRETE_CSVLOG5" },
#define DISCRETE_WAVELOG1(NODE1,GAIN1)                             { NODE_SPECIAL, DSO_WAVELOG  , 2, { NODE1,NODE_NC }, { NODE1,GAIN1 }, NULL, "DISCRETE_WAVELOG1" },
#define DISCRETE_WAVELOG2(NODE1,GAIN1,NODE2,GAIN2)                 { NODE_SPECIAL, DSO_WAVELOG  , 4, { NODE1,NODE_NC,NODE2,NODE_NC }, { NODE1,GAIN1,NODE2,GAIN2 }, NULL, "DISCRETE_WAVELOG2" },
/* output */
#define DISCRETE_OUTPUT(OPNODE,GAIN)                               { NODE_SPECIAL, DSO_OUTPUT   , 2, { OPNODE,NODE_NC }, { 0,GAIN }, NULL, "DISCRETE_OUTPUT" },



#define IS_VALUE_A_NODE(val)	(((val) > NODE_START) && ((val) <= NODE_END))

/*************************************
 *
 *  Interface to the external world
 *
 *************************************/

extern discrete_info *discrete_current_context;

node_description *discrete_find_node(void *chip, int node);

void discrete_sound_n_w(void *chip, offs_t offset, UINT8 data);
UINT8 discrete_sound_n_r(void *chip, offs_t offset);

WRITE8_DEVICE_HANDLER( discrete_sound_w );
READ8_DEVICE_HANDLER( discrete_sound_r );

DEVICE_GET_INFO( discrete );
#define SOUND_DISCRETE DEVICE_GET_INFO_NAME( discrete )

#endif /* __DISCRETE_H__ */
