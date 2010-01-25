
buttons EQU $20
oldbuttons EQU $22
justpressed EQU $24

freq EQU $26

counter EQU $27
temp1 EQU $30
temp2 EQU $32

;       ----------------------------------------------------

        .ORG $7ff0
Header:                         ; 16 byte .NES header (iNES format)
	.db "NES", $1a
	.db $02                 ; size of PRG ROM in 16kb units
	.db $01			; size of CHR ROM in 8kb units
	.db #%00000000		; mapper 0
	.db #%00000000		; mapper 0
        .db $00                 ; size of PRG RAM in 8kb RAM
        .db $00
        .db $00
        .db $00
        .db $00
        .db $00
        .db $00
        .db $00

        .org $8000

;       ----------------------------------------------------

Reset:                          ; reset routine
        SEI
        CLD
	LDX #$00
	STX $2000
	STX $2001
	DEX
	TXS
  	LDX #0
  	TXA
ClearMemory:
	STA 0, X
	STA $100, X
	STA $200, X
	STA $300, X
	STA $400, X
	STA $500, X
	STA $600, X
	STA $700, X
        STA $800, X
        STA $900, X
        INX
	BNE ClearMemory

;       ----------------------------------------------------

        lda #$00                ; setting up variables
        sta buttons
        sta oldbuttons
        sta justpressed

        lda #$0f
        sta freq

        lda #6
        sta counter

        lda #$00
        sta temp1

        lda #$00
        sta temp2

;       ----------------------------------------------------

	LDX #$02                ; warm up
WarmUp:
	bit $2002
	bpl WarmUp
	dex
	BNE WarmUp

       	LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
load_pal:                       ; load palette
        LDA palette,x
        sta $2007
        inx
        cpx #$20
        bne load_pal

	LDA #$20
	STA $2006
	LDA #$00
	STA $2006

	ldy #$04                ; clear nametables
ClearName:
	LDX #$00
	LDA #$00
PPULoop:
	STA $2007
	DEX
	BNE PPULoop

	DEY
	BNE ClearName

;       ----------------------------------------------------

   	LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006


        ldx #$04

        lda #<screen
        sta $10
        lda #>screen
        sta $11

NameLoop:
        lda ($10),y
        sta $2007
        iny
        bne NameLoop
        inc $11
        dex
        bne NameLoop

;----------------------------------

InitSprites:
      ;CLEAR ALL OF SPRITE MEMORY TO AVOID GARBAGE SPRITES!
      LDA #$00
      LDX #$00
ClearSprites:
      STA $500, x
      INX

      BNE ClearSprites

LoadSprites:
      LDX #$00
LoadSpritesLoop:
      LDA sprites, x            ; load data from address (sprites + x)
      STA $500, x               ; store into RAM address ($0200 + x)
      INX                       ; X = X + 1
      CPX #$20                  ; Compare X to # of values (divide by 4 for total # of sprites)
      BNE LoadSpritesLoop       ; Branch to LoadSpritesLoop if compare was Not Equal to zero
                                ; if compare was equal to 32, keep going down

;-------------------------------------


;       ----------------------------------------------------

        lda #%00000001          ; (0: disable; 1: enable)
;                |||||
;                ||||+- Square 1
;                |||+-- Square 2
;                ||+--- Triangle
;                |+---- Noise
;                +----- DMC
        sta $4015               ; enable / disable sound channels

;       ----------------------------------------------------

Vblank:                         ; turn on the screen and start the party
	bit $2002
	bpl Vblank

	LDA #%10001000
	STA $2000
        LDA #%00011110
	STA $2001

        ldx #$00
        stx $2005
        stx $2005

;       ----------------------------------------------------

InfLoop:                        ; loop forever
        JMP InfLoop

;       ----------------------------------------------------

update_sprites:

        LDA #$00
        STA $2003 ; set the low byte (00) of the RAM address
        LDA #$05
        STA $4014 ; set the high byte (05) of the RAM address, start the transfer
        RTS

sprites:
   ;vert tile attr horiz
.db $20, $43, $00, $20 ;sprite 0
.db $20, $44, $00, $28 ;sprite 0
.db $28, $53, $00, $20 ;sprite 0
.db $28, $54, $00, $28 ;
    ;Y              ;X
;-------------------------------






controller_test:



        LDA buttons
	sta oldbuttons

        ldx #$00
        LDA #$01		; strobe joypad
	STA $4016
	LDA #$00
	STA $4016
con_loop:
	LDA $4016		; check the state of each button
	LSR
	ROR buttons
        INX
        CPX #$08
        bne con_loop

	LDA oldbuttons
	EOR #$FF
	AND buttons
	STA justpressed

 CheckUp:
	LDA #%00010000
	;AND justpressed
	AND buttons
        BEQ CheckDown

        dec $0500


        dec $0504


        dec $0508
         dec $50c




CheckDown:
	LDA #%00100000
	;AND justpressed
	AND buttons
	BEQ CheckLeft

        inc $0500
        inc $504
        inc $508
        inc $50c



CheckLeft
	LDA #%10000000
	;AND justpressed
	AND buttons
	BEQ CheckRight

        inc $503
        inc $507
        inc $50b
        inc $50f



CheckRight:
	LDA #%01000000
	;AND justpressed
	AND buttons
	BEQ CheckSel

        dec $0503
        dec $507
        dec $50b
        dec $50f





CheckSel:
	LDA #%00000100
	AND justpressed
	BEQ CheckStart

CheckStart
	LDA #%00001000
	AND justpressed
	BEQ CheckB

CheckB:
	LDA #%00000010
	AND justpressed
	BEQ CheckA


CheckA:
	LDA #%00000001
	AND justpressed
	BEQ CheckOver

CheckOver:


          ;

        RTS




;       ----------------------------------------------------
        ldx #0
NMI:


        iny



back1:
      cpy #$28
      beq disG


back2:
      cpy #$50
      beq disR

back3:
      cpy #$A0
      beq disE

back4:cpy #$C8
      beq disA

back5:cpy #$FA
      beq disT

back6:  jsr update_sprites
        jsr controller_test


        RTI








disG:
 ldx #$0
LoadSpritesLoop0:
      LDA sprites0, x            ; load data from address (sprites + x)
      STA $510, x               ; store into RAM address ($0200 + x)
      INX                       ; X = X + 1
      CPX #$04                  ; Compare X to # of values (divide by 4 for total # of sprites)
      BNE LoadSpritesLoop0       ; Branch to LoadSpritesLoop if compare was Not Equal to zero
       ; lda #%00000001
       ; sta $4015

     jmp back2
disR:
 ldx #$0
LoadSpritesLoop1:
      LDA sprites1, x            ; load data from address (sprites + x)
      STA $514, x               ; store into RAM address ($0200 + x)
      INX                       ; X = X + 1
      CPX #$04                  ; Compare X to # of values (divide by 4 for total # of sprites)
      BNE LoadSpritesLoop1       ; Branch to LoadSpritesLoop if compare was Not Equal to zero
       ;lda #%00000001
      ; sta $4015
      jmp back3


disE:
ldx #$0
LoadSpritesLoop2:
      LDA sprites2, x            ; load data from address (sprites + x)
      STA $518, x               ; store into RAM address ($0200 + x)
      INX                       ; X = X + 1
      CPX #$04                  ; Compare X to # of values (divide by 4 for total # of sprites)
      BNE LoadSpritesLoop2       ; Branch to LoadSpritesLoop if compare was Not Equal to zero
           lda #%00000001
           sta $4015
      jmp back4




disA:
    ldx #$0
LoadSpritesLoop3:
      LDA sprites3, x            ; load data from address (sprites + x)
      STA $51C, x               ; store into RAM address ($0200 + x)
      INX                       ; X = X + 1
      CPX #$04                  ; Compare X to # of values (divide by 4 for total # of sprites)
      BNE LoadSpritesLoop3       ; Branch to LoadSpritesLoop if compare was Not Equal to zero
             lda #%00000001
             sta $4015
      jmp back5





disT:
       ldx #$0
LoadSpritesLoop4:
      LDA sprites4, x            ; load data from address (sprites + x)
      STA $520, x               ; store into RAM address ($0200 + x)
      INX                       ; X = X + 1
      CPX #$04                  ; Compare X to # of values (divide by 4 for total # of sprites)
      BNE LoadSpritesLoop4       ; Branch to LoadSpritesLoop if compare was Not Equal to zero
             lda #%00000001
             sta $4015
      jmp back6



sprites0:
.db  $80,$85,$00,$48

sprites1:
.db  $80,$86,$00,$50

sprites2:
.db  $80,$87,$00,$58

sprites3:
.db  $80,$88,$00,$60

sprites4:
.db  $80,$89,$00,$68





IRQ:
        RTI




;       ----------------------------------------------------

palette:
	;BG
	.byte $31,$16,$28,$10, $31,$07,$17,$27,  $31,$09,$0A,$1A,  $31,$11,$12,$22
        	;SPR
	.byte $31,$28,$17,$15, $31,$06,$07,$16, $31,$06,$07,$16, $31,$06,$07,$16

;       ----------------------------------------------------

screen:
        .incbin "test.nam"

;       ----------------------------------------------------

	.ORG $fffa
	.dw NMI
	.dw Reset
	.dw IRQ

;       ----------------------------------------------------