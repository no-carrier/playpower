
buttons EQU $20
oldbuttons EQU $22
justpressed EQU $24

freq EQU $26

counter EQU $27
power EQU $00
temp2 EQU $32

;varibales for new screen on question asking
screennumber = $44
oldscreen    = $45
palettenumber = $46

screen1 = #$00

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
        sta screennumber
        ; sta oldscreen
        sta palettenumber


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

        ldy #$00
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
      CPX #$50                  ; Compare X to # of values (divide by 4 for total # of sprites)
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
.db $C8, $62, $00, $08 ;sprite 0
.db $C8, $63, $00, $10 ;sprite 0
.db $D0, $72, $00, $08 ;sprite 0
.db $D0, $73, $00, $10 ;
    ;Y              ;X

    ;flying power controlling sprites
.db $28, $11, $00, $F0
.db $30, $11, $00, $F0
.db $38, $11, $00, $F0
.db $40, $11, $00, $F0
.db $48, $11, $00, $F0
.db $50, $11, $00, $F0
.db $58, $11, $00, $F0
.db $60, $11, $00, $F0
.db $68, $11, $00, $F0
.db $70, $11, $00, $F0
.db $78, $11, $00, $F0
.db $80, $11, $00, $F0
.db $88, $11, $00, $F0
.db $90, $11, $00, $F0
.db $00, $4F, $00, $30
.db $00, $4F, $00, $60



;-------------------------------
;###########FOR SCREEN PURPOSE
LoadScreen:

    	lda #%00000000          ; disable NMI's and screen display
 	sta $2000
        lda #%00000000
   	STA $2001

        LDA screennumber

Test0:
        LDA screennumber
        CMP #$00                  ; compare ScreenNumber to find out which picture / palette to load
        BNE Test1
        LDA #<pic0              ; load low byte of picture
        STA $10
        LDA #>pic0              ; load high byte of picture
        STA $11
        jmp LoadNewPalette
        ;LDA #$00
        ;STA palettenumber       ; set palette lookup location
       ; RTS
; ****************************
Test1:
      LDA #<game_over              ; load low byte of picture
      STA $10
      LDA #>game_over              ; load high byte of picture
      STA $11


LoadNewPalette:
       	LDX palettenumber       ; load palette lookup value
        LDY #$00
        LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
LoadNewPal:                     ; load palette
        LDA palette, x
        STA $2007
        INX
        INY
        CPY #$10
        BNE LoadNewPal
       ; RTS

;***************************
DrawScreen:

   	LDA #$20                ; set to beginning of first nametable
    	STA $2006
    	LDA #$00
    	STA $2006

        LDY #$00
        LDX #$04

NameLoop1:                       ; loop to draw entire nametable
        LDA ($10),y
        STA $2007
        INY
        BNE NameLoop1
        INC $11
        DEX
        BNE NameLoop1

        ;RTS

Vblank1:                         ; turn on the screen and start the party
	BIT $2002
	BPL Vblank1

        LDX #$00
        STX $2005
        STX $2005

	LDA #%10001000
	STA $2000
        LDA #%00001110
	STA $2001

;#######Sprite
;InitS:
;      ;CLEAR ALL OF SPRITE MEMORY TO AVOID GARBAGE SPRITES!
;      LDA #$00
;      LDX #$00
;ClearS:
;      STA $500, x
;      INX
;      BNE ClearS

;LoadS:
;      LDX #$00
;LoadSLoop:
;      LDA spt, x            ; load data from address (sprites + x)
;      STA $0500, x              ; store into RAM address ($0200 + x)
;      INX                       ; X = X + 1
;      CPX #4                   ; Compare X to # of values (divide by 4 for total # of sprites)
;      BNE LoadSLoop       ; Branch to LoadSpritesLoop if compare was Not Equal to zero
                               ; if compare was equal to 32, keep going down


;        lda #%00000001          ; (0: disable; 1: enable)
;                |||||
;                ||||+- Square 1
;                |||+-- Square 2
;                ||+--- Triangle
;                |+---- Noise
;                +----- DMC
;        sta $4015               ; enable / disable sound channels
;        RTS
;spt:
   ;vert tile attr horiz
;.db $C8, $62, $00, $08 ;sprite 0
;.db $C8, $63, $00, $10 ;sprite 0
;.db $D0, $72, $00, $08 ;sprite 0
;.db $D0, $73, $00, $10 ;


RTS
;####################

;--------------------------------

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

        ldx #$B8

loop1:
        clc
        ;1st barrier (lower most )
        cpx $0500     ;Y part
        beq V2
        txa
        sbc #$95
        tax
        cpx #$5
        bpl loop1

        ldx #$82
loop2:
        clc
        cpx $0500
        beq V1
        txa
        sbc #$3A
        tax
        cpx #$17
        bpl loop2


nohit:
        dec $0500
        dec $0504
        dec $0508
        dec $50c

        dec $0500
        dec $0504
        dec $0508
        dec $50c

        jmp CheckDown

V1:
   clc
   lda $0503
   cmp #$64
   bmi V3
   jmp nohit

V2:
   clc
   lda $0503
   cmp #$58
   bpl V3
   jmp nohit

V3:
    jsr declevel


CheckDown:
;	LDA #%00100000
	;AND justpressed
;	AND buttons
;	BEQ CheckLeft



	ldx #$d6
        clc
        cpx $50c
        beq downhit ; hit the end of  screen

        ldx #$B0

dloop1:
        clc
        cpx $50c     ;Y part
        beq DV2
        txa
        sbc #$95
        tax
        cpx #$05
        bpl dloop1

        ldx #$78
dloop2:
        clc
        cpx $50c
        beq DV1
        txa
        sbc #$38
        tax
        cpx #$20
        bpl dloop2

        inc $500
        inc $504
        inc $508
        inc $50c
        jmp CheckLeft

DV1:
   clc
   lda $0503
   cmp #$64
   bmi downhit
   inc $0500
   inc $504
   inc $508
   inc $50c
   jmp CheckLeft

DV2:
   clc
   lda $0503
   cmp #$58
   bpl downhit
   inc $0500
   inc $504
   inc $508
   inc $50c
   jmp CheckLeft

downhit:

  ;  lda #$86
  ;  sta $4000
  ;  lda #$C9
  ;  sta $4002
  ;  lda #$09
  ;  sta $4003

CheckLeft:
	LDA #%01000000
	;AND justpressed
	AND buttons
	BEQ CheckRight

	;flipping hanuman on left press......
        lda #$66
        sta $501
        lda #$67
        sta $505
        lda #$76
        sta $509
        lda #$77
        sta $50D

        dec $0503
        dec $507
        dec $50b
        dec $50f


        clc
        lda $503
        cmp #$07
        bcs CheckRight ;no hit
        lda #$07
        sta $503
        inc $507
        inc $50b
        inc $50f

;gensound:
    lda #$86
    sta $4000
    lda #$e9
    sta $4002
    lda #$09
    sta $4003

;###############   RIGHT ARROW KEY PART (START's)###################

CheckRight:
	LDA #%10000000
	;AND justpressed
	AND buttons
	BEQ CheckSel

        ;flipping hanuman on left press..
        lda #$62
        sta $501
        lda #$63
        sta $505
        lda #$72
        sta $509
        lda #$73
        sta $50D


        inc $0503
        inc $507
        inc $50b
        inc $50f


        clc
        lda $0507
        cmp #$D0
        bcc nohitright ;no hit
        lda #$D0
        sta $0507
        dec $503
        dec $50b
        dec $50f


    lda #$86
    sta $4000
    lda #$d9
    sta $4002
    lda #$09
    sta $4003
    jmp CheckSel

;This check's for the X status if the sprite
nohitright:
      ldy #$b0
      clc
      lda #$b0
      cmp $50f
      beq checkyloop                           ;If the required X part is obtained then go for checking y coordinates
      jmp CheckSel

  checkyloop:

       lda #$00
       sta screennumber
       clc
       cpy  $050c                               ;Loading the Y part to check whether or not sprite is in our desired level of Y
       beq  RightScreen                              ;if in desired level go for changing the screen

       tya                                      ;Load Y into accumulator
       sbc #$95                                 ;substracting to check for next level of Y
       tay                                      ;Putting back in Y
       clc                                      ;loading in X from accumulator after substracting
       cpy #$5                                  ;Checking the level is not topmost one if so then quit loop
       bpl checkyloop

           ;If passes above Loop increase the X part of sprite to allow it to go in front as Right key is pressed
           ;inc $0503
           jmp CheckSel


RightScreen:
      lda #$01
      sta screen1
      jsr LoadScreen          ; turn off and load new screen data
      ;jsr LoadNewPalette      ; load new palette
      ;jsr DrawScreen          ; draw new screen
      ;jsr InitS
      ;JSR Vblank1             ; turn the screen back on


CheckOver2:
        RTS

                                                        c

;###############   RIGHT ARROW KEY PART (End's)###################

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
	BEQ Checkcol

Checkcol:
        ldy #$00
        ldx #$00

Checkcol2:
         clc
         lda $548,y
         cmp $500
         bmi CheckOver
         clc
         lda $548,y
         cmp $508
         bpl CheckOver
         clc
         lda $54b,x
         cmp $503
         bmi CheckOver
         clc
         lda $54b,x
         cmp $507
         bpl CheckOver
         jsr decpower
         tya
         adc #$4
         tay
         tax
         cpy #$8
         bne Checkcol2

CheckOver:
          jsr Checkpower
          RTS


Checkpower:
        lda #$01
        sta screennumber
        lda power
        cmp #$38
        beq RightScreen
        RTS

declevel:

        ldx #$00
    loopdo:
         inc $0500
         inc $504
         inc $508
         inc $50c
         inx
         cpx #$10
         bmi loopdo
decpower:
        lda #$86
        sta $4000
        lda #$b9
        sta $4002
        lda #$09
        sta $4003

         clc
         ldx #$00
         ldx power
         LDA #$00
         STA $511,x
         txa
         adc #$4
         sta power
         RTS

qscreen_controller:
    ;CheckSel:
	LDA #%00000100
	AND justpressed
        beq done

        LDA #<screen
        STA $10
        LDA #>screen
        STA $11
       ; LDA #$30
        ;STA PaletteNumber

     done:
     rts
;       ----------------------------------------------------

NMI:
    ;lda screen1
    ;cmp#$00
    ;bne qscreen
        jsr update_sprites
        jsr controller_test
        inc  $548
        dec $54b
        inc $54c
        dec $54f
        ;jsr fallauto

        RTI
  ;  qscreen:
  ;      jsr qscreen_controller
  ;      RTI
IRQ:
        RTI

;       ----------------------------------------------------

palette:
	;BG
	.byte $0F,$16,$28,$10,$0F,$0F,$0F,$30,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F
	;SPR
	.byte $0F,$38,$27,$26,$0F,$06,$07,$16,$0F,$06,$07,$16,$0F,$06,$07,$16
	;game_over
;	.byte $0F,$38,$27,$26,$0F,$06,$07,$16,$0F,$06,$07,$16,$0F,$06,$07,$16

;       ----------------------------------------------------

screen:
        .incbin "test.nam"
 pic0:
        .incbin "pic0.nam"
game_over:
        .incbin "game_over.nam"

;       ----------------------------------------------------

	.ORG $fffa
	.dw NMI
	.dw Reset
	.dw IRQ

;       ----------------------------------------------------