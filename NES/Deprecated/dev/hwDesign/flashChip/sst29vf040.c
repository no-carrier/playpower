Software
Drivers

29VF040
4 Mbit(512K x 8) Small-Sector Flash

May 2001

ABOUT THE SOFTWARE
This application note provides software driver examples for 29VF040, 4 Mbit
(512K x 8) Small-Sector Flash, that can be used in any microprocessor based 
system.  Software driver examples used in this document utilize two 
programming languages: (a) high -level "C" for broad platform support and 
(b) optimized 8086 assembly language. In many cases, software driver routines 
can be inserted "as is" into the main body of code being developed by the 
system software developers. Extensive comments are included in each routine 
to describe the function of each routine. The driver in "C" language can be 
used with many microprocessors and microcontrollers, while the 8086 assembly 
language provides an optimized solution for 8086 microprocessors.

ABOUT THE 29VF040

Companion product datasheets for the 29VF040 should be reviewed in conjunction
with this application note for a complete understanding of the device.

Both the C and 8086 assembly code in the document contain the following
routines, in this order:

Name                    Function
------------------------------------------------------------------
Check_SST_29VF040       Check manufacturer and device ID
Erase_Entire_Chip       Erase the contents of the entire chip
Erase_One_Sector        Erase a sector of 128 bytes
Program_One_Byte        Alter data in one byte
Program_One_Sector      Alter data in 128 bytes sector
Check_Toggle_Ready      End of internal program or erase detection using
                        Toggle bit
Check_Data_Polling      End of internal program or erase detection using
                        Data# polling


"C" LANGUAGE DRIVERS

/***********************************************************************/
/* Copyright Silicon Storage Technology, Inc. (SST), 1994-2001         */
/* Example "C" Language Drivers of 29VF040 4 Mbit Small-Sector Flash   */
/* Nelson Wang, Silicon Storage Technology, Inc.                       */
/*                                                                     */
/* Revision 1.0, May 11, 2001                                          */
/*                                                                     */
/* This file requires these external "timing"  routines:               */
/*                                                                     */
/*      1.)  Delay_150_Nano_Seconds                                    */
/*      2.)  Delay_25_Milli_Seconds                                    */
/*      3.)  Delay_100_Milli_Seconds                                   */
/***********************************************************************/

#define FALSE                   0
#define TRUE                    1

#define SECTOR_SIZE             128     /* Must be 128 bytes for 29VF040 */

#define SST_ID                  0xBF    /* SST Manufacturer's ID code   */
#define SST_29VF040             0x14    /* SST 29VF040 device code      */

typedef unsigned char           BYTE;

/* -------------------------------------------------------------------- */
/*                       EXTERNAL ROUTINES                              */
/* -------------------------------------------------------------------- */

extern void     Delay_150_Nano_Seconds();
extern void     Delay_25_Milli_Seconds();
extern void     Delay_100_Milli_Seconds();


*************************************************************************/
/* PROCEDURE:   Check_SST_29VF040                                       */
/*                                                                      */
/* This procedure decides whether a physical hardware device has a      */
/* SST 29VF040  4 Mbit Small-Sector Flash installed or not.             */
/*                                                                      */
/* Input:                                                               */
/*          None                                                        */
/*                                                                      */
/* Output:                                                              */
/*          return TRUE:  indicates a SST 29VF040                       */
/*          return FALSE: indicates not a SST 29VF040                   */
/************************************************************************/

int Check_SST_29VF040()
{
        BYTE far *Temp;
        BYTE SST_id1;
        BYTE SST_id2;
        int  ReturnStatus;

        /*  Issue the Software Product ID code to 29VF040  */

        Temp  = (BYTE far *)0xA0000555; /* set up address to be A000:0555h    */
        *Temp = 0xAA;                   /* write data 0xAA to the address     */
        Temp  = (BYTE far *)0xA00002AA; /* set up address to be A000:02AAh    */
        *Temp = 0x55;                   /* write data 0x55 to the address     */
        Temp  = (BYTE far *)0xA0000555; /* set up address to be A000:0555h    */
        *Temp = 0x90;                   /* write data 0x90 to the address     */

        Delay_150_Nano_Seconds();       /* check DATABOOK for the most  */
                                        /* accurate value -- Tida       */

        /* Read the product ID from 29VF040 */

        Temp  = (BYTE far *)0xA0000000; /* set up address to be A000:0000h    */
        SST_id1  =  *Temp;              /* get first ID byte                  */
        Temp  = (BYTE far *)0xA0000001; /* set up address to be A000:0001h    */
        SST_id2  =  *Temp;              /* get second ID byte                 */

        /* Determine whether there is a SST 29VF040 installed or not */

        if ((SST_id1 == SST_ID) && (SST_id2 ==SST_29VF040))
                ReturnStatus = TRUE;
        else
                ReturnStatus = FALSE;

        /* Issue the Soffware Product ID Exit code thus returning the 29VF040 */
        /* to the read operating mode                                         */

        Temp  = (BYTE far *)0xA0000555; /* set up address to be A000:0555h    */
        *Temp = 0xAA;                   /* write data 0xAA to the address     */
        Temp  = (BYTE far *)0xA00002AA; /* set up address to be A000:02AAh    */
        *Temp = 0x55;                   /* write data 0x55 to the address     */
        Temp  = (BYTE far *)0xA0000555; /* set up address to be A000:0555h    */
        *Temp =0xF0;                    /* write data 0xF0 to the address     */

        Delay_150_Nano_Seconds();       /* check DATABOOK for the most  */
                                        /* accurate value -- Tida       */

        return (ReturnStatus);
}


*************************************************************************/
/* PROCEDURE:   Erase_Entire_Chip                                       */
/*                                                                      */
/* This procedure can be used to erase the entire chip.                 */
/*                                                                      */
/* Input:                                                               */
/*      NONE                                                            */
/*                                                                      */
/* Output:                                                              */
/*      NONE                                                            */
/************************************************************************/

int Erase_Entire_Chip()
{
        BYTE far *Temp;

        /*  Issue the Sector Erase command to 29VF040   */

        Temp  = (BYTE far *)0xA0000555; /* set up address to be A000:0555h    */
        *Temp = 0xAA;                   /* write data 0xAA to the address     */
        Temp  = (BYTE far *)0xA00002AA; /* set up address to be A000:02AAh    */
        *Temp = 0x55;                   /* write data 0x55 to the address     */
        Temp  = (BYTE far *)0xA0000555; /* set up address to be A000:0555h    */
        *Temp = 0x80;                   /* write data 0x80 to the address     */
        Temp  = (BYTE far *)0xA0000555; /* set up address to be A000:0555h    */
        *Temp = 0xAA;                   /* write data 0xAA to the address     */
        Temp  = (BYTE far *)0xA00002AA; /* set up address to be A000:02AAh    */
        *Temp = 0x55;                   /* write data 0x55 to the address     */
        Temp  = (BYTE far *)0xA0000555; /* set up address to be A000:0555h    */
        *Temp = 0x10;                   /* write data 0x10 to the address     */

        Delay_100_Milli_Seconds();      /* check DATABOOK for the most  */
                                        /* accurate value -- Tsce       */
}



*************************************************************************/
/* PROCEDURE:   Erase_One_Sector                                        */
/*                                                                      */
/* This procedure can be used to erase a total of 128 bytes.            */
/*                                                                      */
/* Input:                                                               */
/*      Dst     DESTINATION address at which the erase operation will   */
/*              start.                                                  */
/*                                                                      */
/* Output:                                                              */
/*      NONE                                                            */
/************************************************************************/

int Erase_One_Sector(BYTE far *Dst)
{
        BYTE far *Temp;

        /*  Issue the Sector Erase command to 29VF040   */

        Temp  = (BYTE far *)0xA0000555; /* set up address to be A000:0555h    */
        *Temp = 0xAA;                   /* write data 0xAA to the address     */
        Temp  = (BYTE far *)0xA00002AA; /* set up address to be A000:02AAh    */
        *Temp = 0x55;                   /* write data 0x55 to the address     */
        Temp  = (BYTE far *)0xA0000555; /* set up address to be A000:0555h    */
        *Temp = 0x80;                   /* write data 0x80 to the address     */
        Temp  = (BYTE far *)0xA0000555; /* set up address to be A000:0555h    */
        *Temp = 0xAA;                   /* write data 0xAA to the address     */
        Temp  = (BYTE far *)0xA00002AA; /* set up address to be A000:02AAh    */
        *Temp = 0x55;                   /* write data 0x55 to the address     */
        Temp  = Dst                   /* set up starting address to be erased */
        *Temp = 0x20;                   /* write data 0x20 to the address     */

        Delay_25_Milli_Seconds();       /* check DATABOOK for the most  */
                                        /* accurate value -- Tse        */
}


/************************************************************************/
/* PROCEDURE:   Program_One_Byte                                        */
/*                                                                      */
/* This procedure can be used to program ONE byte of date to the        */
/* 29VF040.                                                             */
/*                                                                      */
/* NOTE:  It is mandatory that the sector containing the byte to be     */
/*        programmed was ERASED first.                                  */
/*                                                                      */
/* Input:                                                               */
/*           SrcByte The BYTE which will be written to the 29VF040.     */
/*           Dst     DESTINATION address which will be written with the */
/*                   data passed in from SrcByte                        */
/*                                                                      */
/* Output:                                                              */
/*           None                                                       */
/************************************************************************/

void Program_One_Byte (BYTE SrcByte,    BYTE far *Dst)
{
        BYTE far *Temp;
        BYTE far *DestBuf;
        int Index;

        DestBuf = Dst;

         /* issue the 3-byte "enable protection" sequence to the chip */
        Temp =  (BYTE far *)0xA0000555; /* set up address to be A000:0555h    */
        *Temp = 0xAA;                   /* write data 0xAA to the address     */
        Temp =  (BYTE far *)0xA00002AA; /* set up address to be A000:02AAh    */
        *Temp = 0x55;                   /* write data 0x55 to the address     */
        Temp =  (BYTE far *)0xA0000555; /* set up address to be A000:0555h    */
        *Temp = 0xA0;                   /* write data 0xA0 to the address     */

        *DestBuf = SrcByte;             /* transfer the byte to destination   */
        Check_Toggle_Ready(DestBuf);    /* wait for TOGGLE bit to get ready   */
}


/************************************************************************/
/* PROCEDURE:   Program_One_Sector                                      */
/*                                                                      */
/* This procedure can be used to program a total of 128 bytes of data   */
/* to the SST's 29VF040.                                                */
/*                                                                      */
/* Input:                                                               */
/*           Src     SOURCE address containing the data which will be   */
/*                   written to the 29VF040.                            */
/*           Dst     DESTINATION address which will be written with the */
/*                   data passed in from Src                            */
/*                                                                      */
/* Output:                                                              */
/*           None                                                       */
/************************************************************************/

void Program_One_Sector (BYTE far *Src,    BYTE far *Dst)
{
        BYTE far *SourceBuf;
        BYTE far *DestBuf;
        int Index;

        SourceBuf = Src;
        DestBuf = Dst;

        Erase_One_Sector(Src);          /* erase the sector first */

        for (Index = 0; Index < SECTOR_SIZE; Index++)
        {
        		Program_One_Byte (*SourceByte, DestBuf++);
            ++SourceByte;
        }
}


/************************************************************************/
/* PROCEDURE:    Check_Toggle_Ready                                     */
/*                                                                      */
/* During the internal program cycle, any consecutive read operation    */
/* on DQ6 will produce alternating 0's and 1's i.e. toggling between    */
/* 0 and 1. When the program cycle is completed, DQ6 of the data will   */
/* stop toggling. After the DQ6 data bit stops toggling, the device is  */
/* ready for next operation.                                            */
/*                                                                      */
/* Input:                                                               */
/*           Dst        must already set-up by the caller               */
/*                                                                      */
/* Output:                                                              */
/*           None                                                       */
/************************************************************************/

void Check_Toggle_Ready (BYTE far  *Dst)
{
        BYTE Loop = TRUE;
        BYTE PreData;
        BYTE CurrData;
        unsigned long TimeOut = 0;

        PreData = *Dst;
        PreData = PreData & 0x40;
        while ((TimeOut< 0x07FFFFFF) && (Loop))
        {
            CurrData = *Dst;
            CurrData = CurrData & 0x40;
            if (PreData == CurrData)
                    Loop = FALSE;   /* ready to exit the while loop */
            PreData = CurrData;
            TimeOut++;
        }
}


/************************************************************************/
/* PROCEDURE:   Check_Data_Polling                                      */
/*                                                                      */
/* During the internal program cycle, any attempt to read DQ7 of the    */
/* last byte loaded during the page/byte-load cycle will receive the    */
/* complement of the true data.  Once the program cycle is completed,   */
/* DQ7 will show true data.                                             */
/*                                                                      */
/* Input:                                                               */
/*           Dst        must already be set-up by the caller            */
/*           TrueData 	this is the original (true) data            	*/
/*                                                                      */
/* Output:                                                              */
/*           None                                                       */
/************************************************************************/

void Check_Data_Polling (BYTE far  *Dst,       BYTE TrueData)
{
        BYTE Loop = TRUE;
        BYTE CurrData;
        unsigned long TimeOut = 0;

        TrueData = TrueData &  0x80;
        while ((TimeOut< 0x07FFFFFF) && (Loop))
        {
                CurrData = *Dst;
                CurrData = CurrData & 0x80;
                if (TrueData == CurrData)
                        Loop = FALSE;   /* ready to exit the while loop  */
                TimeOut++;
        }
}



8086 ASSEMBLY LANGUAGE DRIVERS

; ======================================================================
; Copyright Silicon Storage Technology, Inc. (SST), 1994-2001
; EXAMPLE 8086 Assembly Language Drivers for 29VF040 4 Mbit(512K x 8) 
; Small-Sector Flash 
; Frank Cirimele,  Silicon Storage Technology, Inc.
;
; Revision 1.0, May 11, 2001
;
; This file requires these external "timing" routines:
;
;       1.)  Delay_150_Nano_Seconds
;       2.)  Delay_25_Milli_Seconds
;       3.)  Delay_100_Milli_Seconds
; ======================================================================

SECTOR_SIZE             EQU     128    ; Must be 128 bytes for 29VF040

SST_ID                  EQU     0BFh    ; SST Manufacturer's ID code
SST_29VF040             EQU     014h    ; SST 29VF040 device code
CHIP_ERASE_COMMAND      EQU     010h
SECTOR_ERASE_COMMAND    EQU     020h

ABS_SEGMENT     EQU     0A000h

extrn   Delay_150_Nano_Seconds:near
extrn   Delay_25_Milli_Seconds:near
extrn   Delay_100_Milli_Seconds:near


;=======================================================================
; PROCEDURE:    Check_SST_29VF040
;
; This procedure decides whether a physical hardware device has a SST's
; 29VF040 4 Mbit(512K x 8) Small-Sector Flash installed or not.
;
; Input:
;       None
;
; Output:
;       carry bit:   CLEARED means a SST 29VF040 is installed
;       carry bit:   SET means NOT a SST 29VF040 is NOT installed
;
;=======================================================================

Check_SST_29VF040      proc    near

        push    ax                              ; preserve registers value
        push    ds
	pushf					; save interrupt state

	; It is mandatory to maintain pushf as the last push instruction.

        cli
        mov     ax, ABS_SEGMENT
        mov     ds, ax

        mov     ds:byte ptr [0555h], 0AAh       ; issue the 3-byte product ID
        mov     ds:byte ptr [02AAh], 055h       ;  command to the 29VF040
        mov     ds:byte ptr [0555h], 090h

        call    Delay_150_Nano_Seconds          ; insert delay = Tida

        mov     al, ds:[0]
        cmp     al, SST_ID                      ; is this a SST part?
        jne     CSC5                            ; NO, then return Carry set
        mov     al,ds:[1]
        cmp     al, SST_29VF040                 ; Is it a 29VF040?
        jne     CSC5                            ; NO, then Non-SST part and
						; set carry flag
CSC4:
        pop	ax				; get flags from stack
	and	ax, 0FFFEh			; and clear carry flag
        jmp     short CSC6

CSC5:
        pop	ax				; get flags from stack
	or	ax, 0001h			; and set carry flag
   ; save the result on the STACK
       
CSC6:
	push	ax				; return flags to stack

;
; Issue the Software Product ID Exit code thus returning the 29VF040
; to the read operation mode.
;

        mov     ds:byte ptr [0555h], 0AAh       ; issue the 3-byte product ID
        mov     ds:byte ptr [02AAh], 055h       ;  exit command sequence to
        mov     ds:byte ptr [0555h], 0F0h	;  the 29VF040

        call    Delay_150_Nano_Seconds          ; insert delay = Tida


        popf                                    ; restore flags
        pop     ds                              ; restore registers
        pop     ax

        ret

Check_SST_29VF040 endp


; =====================================================================
; PROCEDURE:    Erase_Entire_Chip
;
; This procedure can be used to erase the entire contents of
; SST's 29VF040.
;
; Input:
;       es:di   points to the beginning address of the 29VF040 chip
;               which will be erased.
;
; Output:
;       None
; =====================================================================

Erase_Entire_Chip       proc    near

        mov     es:byte ptr [0555h], 0AAh	; issue 6-byte chip
        mov     es:byte ptr [02AAh], 055h	;  erase command sequence
        mov     es:byte ptr [0555h], 080h
        mov     es:byte ptr [0555h], 0AAh
        mov     es:byte ptr [02AAh], 055h
        mov     es:byte ptr [0555h], CHIP_ERASE_COMMAND

        call    Delay_100_Milli_Seconds         ; insert delay = Tsce

        ret

Erase_Entire_Chip       endp


; =====================================================================
; PROCEDURE:    Erase_One_Sector
;
; This procedure can be used to erase a sector, or total of 128 bytes,
; in the SST29VF040.
;
; Input:
;       es:di   points to the beginning address of the "Destination" address
;               which will be erased.
;               ==> Note: The address MUST be on a sector boundary, 
;			  that is, a multiple of 128.
;
; Output:
;       None
; =====================================================================

Erase_One_Sector        proc    near

        push    ax				; save register

        mov     es:byte ptr [0555h], 0AAh	; send 6-byte code for
        mov     es:byte ptr [02AAh], 055h	;  sector erase
        mov     es:byte ptr [0555h], 080h
        mov     es:byte ptr [0555h], 0AAh
        mov     es:byte ptr [02AAh], 055h
        mov     al, SECTOR_ERASE_COMMAND
        mov     byte ptr es:[di], al

        call    Delay_25_Milli_Seconds          ; insert delay = Tse

        pop     ax				; restore register

        ret

Erase_One_Sector        endp

; =====================================================================
; PROCEDURE:    Program_One_Byte
;
; This procedure can be used to program ONE byte of data to the 29VF040.
;
; NOTE:  It is necessary to first erase the sector containing the byte 
;	 to be programmed..
;
;
; Input:
;       al      BYTE which will be written into the 29VF040.
;       es:di   DESTINATION address which will be written with the
;               data input in al.
;
; Output:
;       None
;       ES, DI:  Contain their original values
; =====================================================================

Program_One_Byte          proc    near

        push    ax				; save registers
        push    ds
        mov     ax, ABS_SEGMENT			; set up ds register
        mov     ds, ax
        mov     ds:byte ptr [0555h], 0AAh       ; send 3 byte data protection
        mov     ds:byte ptr [02AAh], 055h       ;  sequence to the chip
        mov     ds:byte ptr [0555h], 0A0h
        pop     ds
        pop     ax                      	; restore the byte to be 
						;  programmed from stack
        mov     byte ptr es:[di], al    	; program the byte
        call    check_Toggle_Ready      	; wait for valid TOGGLE bit 

        ret

Program_One_Byte          endp


; =====================================================================
; PROCEDURE:    Program_One_Sector
;
; This procedure can be used to program a memory sector, or total of 
; 128 bytes, of the SST29VF040.
;
; Input:
;       ds:si   SOURCE address containing the data which will be
;               written into the 29VF040.
;       es:di   DESTINATION address which will be written with the
;               data passed in for ds:si
;
; Output:
;       None
;       SI, DI:  Contains their original values
; =====================================================================

Program_One_Sector        proc    near

        push    ax			; save registers
	push	cx
        push    di
        push    si
        pushf                   	; preserve the "Direction" flag 
        cld                     	; clear "Direction" flag to
                                	;  auto-increment SI and DI
;
; Erase the sector before programming.  Each erase command will erase a total
; of 4096 bytes for the 29VF040
;
        call    Erase_One_Sector
;
; The following loop will program a total of 128 bytes to the SST29VF040
;
	mov	cx, SECTOR_SIZE		; load sector loop counter
DRP1:
        push    ds
        mov     ax, ABS_SEGMENT
        mov     ds, ax
        mov     ds:byte ptr [0555h], 0AAh       ; 3 bytes of "enable protection"
        mov     ds:byte ptr [02AAh], 055h       ;  sequence to the chip
        mov     ds:byte ptr [0555h], 0A0h
        pop     ds
	
        lodsb                           ; get the byte to be programmed
        mov     ax, di                  ; preserve original DI temporarily
        stosb                           ; program the byte
        push    di                      ; preserve incremented DI temporarily
        mov     di, ax			; restore original DI
        call    check_Toggle_Ready      ; wait for TOGGLE bit to get ready
        pop     di                      ; retrieve the updated DI
        loop    DRP1                    ; continue program more bytes until done

        popf				; restore original direction flag
        pop     si			; restore registers
        pop     di
	pop	cx
        pop     ax

        ret

Program_One_Sector        endp


;======================================================================
; PROCEDURE:                    Check_Toggle_Ready
;
; During the internal program cycle, any consecutive read operation
; on DQ6 will produce alternating 0s and 1s, i.e. toggling between
; 0 and 1. When the program cycle is completed, the DQ6 data will
; stop toggling. After the DQ6 data stops toggling, the device is ready
; for the next operation.
;
; Input:
;       es:di   must already be set-up by the caller
;
; Output:
;       None
;======================================================================

Check_Toggle_Ready      proc    near

        push    ax		; save register

        mov     al, es:[di]     ; read a byte from the chip
        and     al, 40h         ; mask for the TOGGLE bit (DQ6)

CTR_Tog2:
        mov     ah, es:[di]     ; read the same byte from the chip again
        and     ah, 40h         ; mask for the TOGGLE bit (DQ6)
        cmp     al, ah          ; is DQ6 still toggling?
        je      CTR_Tog3        ; No, then the write operation is done
        xchg    ah, al          ; YES, then continue checking...
        jmp     short CTR_Tog2

CTR_Tog3:
        pop     ax		; restore register

        ret

Check_Toggle_Ready      endp


;=======================================================================
; PROCEDURE:                    Check_Data_Polling
;
; During the internal program cycle, any attempt to read DQ7 of the last
; byte loaded during the page/byte-load cycle will receive the complement 
; of the true data.  Once the program cycle is completed, DQ7 will show 
; true data.
;
; Input:
;       es:di   must already be set-up by the caller
;       bl      contains the original (true) data
;
; Output:
;       None
;
;=======================================================================

Check_Data_Polling      proc    near

        push    ax		; save registers
        push    bx

        and     bl, 80h         ; mask for the DQ7 bit

CDP_Tog2:
        mov     al, es:[di]     ; read a byte from the chip
        and     al,80h          ; mask for the DQ7 bit
        cmp     al,bl           ; is DQ7 still complementing?
        jne     CDP_Tog2

        pop     bx		; restore registers
        pop     ax

        ret

Check_Data_Polling      endp


