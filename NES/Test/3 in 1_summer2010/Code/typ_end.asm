typ_end_Compare:

;lda var_new                     ;;;;;; triggering for going into compare for snake level
;cmp #1
;beq @com_jmp
;rts

;@com_jmp:

;LDA var1                       ;;;;;;; checking if keyboard input is working
;cmp #1
;beq @c
ldy pointer     ; it points to current letter that should be pressed by the user. pointer is a number. we will load the letter from library
ldx Current     ; this stores the current letter pressed by the user
lda word_end,y   ; load the expected letter into accumaltor
cmp Current  ;        compare with the currently pressed letter
beq @Found              ; correct letter is pressed
lda #0
sta Current
;inc $504
@c:RTS

@Found:
                           ;;;;;; if word typed is correct then going in found
 ;;;;;;;;
         ;lda #0
         ;sta ps2
         ;jsr arrow11
         ;jsr LoadSprites98

         lda #0
         sta Current
   lda #1
   sta under1
   sta inc_hanu
   inc wl                          ; this will increse the wl. So if "RO" are pressed then wl = 2 and if "C" is pressed then wl=3
   ldx wl                          ; is the current lenght of the letters pressed of a word
                        ; level number. - how many words r completed for "ROCK" it is wordnum = 1
   ldy wordnum
   lda NumberofLetters_end,y           ; load the no.of letters in word. here for rock,it will load 4
   sta ww
   inc pointer                     ; increment pointer so now it points to the next correct letter


    LDA #$01
    STA varX
    STA var1
    ldy wordnum
    lda NumberofLetters_end,y
    sta ww                          ; this loads that word 1 has how many letters . 4 will be loaded
    cmp wl                          ; compare with current lenght of the current word.
    BEQ @newword                     ; ie wordnum is 1. so lda will be 4. wl is 4 then new word
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@newword:

         lda #0
         sta wl              ; now wl is reset to zero. wl keeps the no. of letters pressed by user for current word
         sta lower_byte
         ;sta delay_cal_quiz       ;;;;; initializing delay value to 0
         ;sta var_new         ;;;;; disabling the first word comparision
         lda #1
         sta under2
         sta trigger
         ;inc wn
         inc wordnum
         ;sta var01           ;;;; initialising the trigger for second comparision
         ;sta trig_delay      ;;;; initialising the time limit for secon word detection
         ;sta clearing_byte

         ;jsr mon_1           ;;;; loading the initial monster again

         ;lda #0
         ;sta key
         RTS

;               ---------------------------------------------------------------------


loading_letters_end:              ;;;; loading the first letter



                lda trigger
                cmp #1
                beq @start
                rts

@start:
                jsr typ_end_clearing_words
                ldy #00
                ldx #00
                lda #%00000000             ;off the screen
                sta $2001

                LDA $2002             ; read PPU status to reset the high/low latch
                LDA #$23
                STA $2006             ; write the high byte of $2000 address
                LDA #$63
                STA $2006

                            ; write the low byte of $2000 address
@start1:
                ldy wordnum
                ldx total_letters
                lda word_end,x
                sta $2007             ;we are stoaring a character in address 0595+y
                inc ttempx
                inc total_letters
                inx
                lda NumberofLetters_end,y  ;loading length of the word in accumulator
                cmp ttempx                ;comparing the value of x with the value stored in accumulator
                bne @start1

                lda #%00011110
                sta $2001
                lda PPUCRTL
                sta $2000
                lda #0
                sta $2005
                lda #0
                sta $2005

                lda #0
                sta ttempx
                sta trigger
                ;lda #1
                ;sta trigger0
                ;jsr LoadSprites98
                ;lda #4
                ;sta level_change
                ;lda #2
                ;sta game_no
                RTS
;               --------------------------------------------------------------------
update_spritespp:

        LDA #$00
        STA $2003 ; set the low byte (00) of the RAM address
        LDA #$05
        STA $4014 ; set the high byte (05) of the RAM address, start the transfer
        RTS
;               --------------------------------------------------------------------
ClearSprites12:
      lda #0
      ldx #0
@loop:
      STA $500, x
      INX
      BNE @loop
      rts
;               --------------------------------------------------------------------
typ_end_loading_underlines:                       ;;;;;;;;loading underline for the second word
                   lda under1
                   cmp #1
                   beq @start_under
                   rts

@start_under:
          lda #%00000000             ;off the screen
          sta $2001
          ldy lower_byte
          LDA $2002             ; read PPU status to reset the high/low latch
          LDA #$23
          STA $2006             ; write the high byte of $2000 address
          LDA Lower_byte_pal_end,y
          STA $2006

          lda #$ED
          sta $2007
          lda #%00011110
          sta $2001
          inc lower_byte

          lda PPUCRTL
          sta $2000
          lda #0
          sta $2005
          lda #0
          sta $2005

          lda #0
          sta under1
          rts
;       ---------------------------------------------------
typ_end_clearing_underlines:                    ;;;;;;;;;;;clearing underlines
                    lda under2
                   cmp #1
                   beq @under_jmp2
                   rts
@under_jmp2:
          lda #%00000000             ;off the screen
          sta $2001
          ldy lower_byte
          lda #$A0
          LDA $2002             ; read PPU status to reset the high/low latch
          LDA #$23
          STA $2006             ; write the high byte of $2000 address
          LDA #$83
          STA $2006
          ldx #0

@loop_under:
          lda #$FD
          sta $2007
          inx
          cpx #30
          bne @loop_under

          lda #%00011110
          sta $2001
          lda PPUCRTL
      sta $2000
      lda #0
      sta $2005
      lda #0
      sta $2005

          lda #0
          sta under2
          sta lower_byte

          rts
;       -------------------------------------------------------------------------
typ_end_clearing_words:                    ;;;;;;;;;;;clearing underlines

          lda #%00000000             ;off the screen
          sta $2001
          lda #$80
          LDA $2002             ; read PPU status to reset the high/low latch
          LDA #$23
          STA $2006             ; write the high byte of $2000 address
          LDA #$63
          STA $2006
          ldx #0

@loop_under:
          lda #$FD
          sta $2007
          inx
          cpx #30
          bne @loop_under

          lda #%00011110
          sta $2001
          lda PPUCRTL
      sta $2000
      lda #0
      sta $2005
      lda #0
      sta $2005
          rts
      ;   ----------------------------------------------------------

increase_hanuman:
                 lda inc_hanu
                 cmp #1
                 bne @jmp_rts
                 ldx #0
                 @Loop:
                 dec $0500, x              ; store into RAM address ($0200 + x)
                 INX
                 INX
                 INX
                 INX                       ; X = X + 1
                 CPX #252
                        ; Compare X to # of values (divide by 4 for total # of sprites)
                 BNE @Loop
                 inc count_end

@jmp_rts:
         lda #0
         sta inc_hanu
         rts
;        ----------------------------------------------------------------------
decrease_hanuman:
                 lda dec_hanu
                 cmp #1
                 bne @jmp_rts
                 
                 lda count_end
                 cmp #0
                 beq @jmp_rts

                 ldx #0
                 @Loop:
                 inc $0500, x              ; store into RAM address ($0200 + x)
                 INX
                 INX
                 INX
                 INX                       ; X = X + 1
                 CPX #252
                        ; Compare X to # of values (divide by 4 for total # of sprites)
                 BNE @Loop
                 dec count_end

@jmp_rts:
         lda #0
         sta dec_hanu
         rts
;       --------------------------------------------------------------------------
timer_end_typing:
          inc timer_end
          lda timer_end
          cmp #60
          bne @jmp_end
          lda #0
          sta timer_end
          lda #1
          sta dec_hanu
@jmp_end:
         rts
;       ---------------------------------------------------------------------------
ResetKeyboard_end:
  lda #%00000100
  sta $4016
  lda #%00000101
  sta $4016        ;;sets keyboard row/column to 0
  lda #%00000100
  sta $4016
  rts

; ----------------------------------------------------------------------------------
  ;;
ReadKeyboard_end:
  ldx #$00                ;;byte counter
@ReadKeyboardLoop:
  lda #%00000000          ;;set to low column
  lda $4017
  lsr a                   ;;dont use d0
  and #$0F
  sta $0300, x            ;;get low column 4 bits

  lda #%00000110          ;;set to high column
  sta $4016

  lda $4017
  asl a
  asl a
  asl a
  and #$F0
  ora $0300, x            ;;get high column 4 bits
  sta $0300, x

  inx
  cpx #$0D                ;;count 13 rows
  beq @ReadKeyboardLoopDone
@ReadKeyboardLoopNextRow:
  lda #%00000100          ;;set to low column, increments row
  sta $4016
  jmp @ReadKeyboardLoop

@ReadKeyboardLoopDone:


  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ParseKeyboard_end:
  ldx #$00                  ;;which keyboard byte
@ParseKeyboardByteLoop:
  ldy #$00                  ;;which bit in byte to look at
  lda #$01
  sta bitmask               ;;start with lowest bit

@ParseKeyboardBitLoop:
  lda $0300, x              ;;get keyboard byte
  and bitmask               ;;mask off all but 1 bit
  beq @ParseKeyboardFound    ;;if bit CLEAR, button is DOWN

@ParseKeyboardNextBit:
  asl bitmask               ;;go to next bit
  iny                       ;;look at all 8 bits
  cpy #$08
  bne @ParseKeyboardBitLoop

@ParseKeyboardNextByte:
  inx                       ;;go to next byte
  cpx #$0D                  ;;13 rows
  bne @ParseKeyboardByteLoop

@ParseKeyboardNotFound:      ;;no keys down were found


  lda #'\0'
;  sta $0501                 ;;set tile to empty
  rts

@ParseKeyboardFound:


  txa
  asl a
  asl a
  asl a
  sta temp                  ;;shift byte counter up  xxxxx000

  tya
  ora temp                  ;;add in bit counter     xxxxxyyy
  tax
 ;;;;;;;;;;
 ;lda var1



 ;cmp #$01


 ;BNE over1234

  ;;;;;;
  lda keyboard_end, x           ;;load that character
  ;;;;;;;;;;;;;;

  ;;;;;;;;;
  sta Current                 ;;store into sprite tile
  ;sta $505
  ;inc $504


  over1234:
  rts
  
  


; ------------------------------------------------------------------------------------
keyboard_end:
  ; SUBOR compatible layout
  .db '4', 'G', 'F', 'C', '2', 'E', '5', 'V'
  .db '2', 'D', 'S', 'E', '1', 'W', '3', 'X'
  .db 'I', 'B', 'N', 'R', '8', 'P', 'D', 'H'
  .db '9', 'I', 'L', ',', '5', 'O', '0', '.'
  .db '[', 'R', 'U', 'L', '7', '0', '0', 'D'
  .db 'Q', 'C', 'Z', 'T', 'E', 'A', '1', 'C'
  .db '7', 'Y', 'K', 'M', '4', 'U', '8', 'J'
  .db '0', '0', '0', '0', '6', 'P', '0', 'S'
  .db 'T', 'H', 'N', ' ', '3', 'R', '6', 'B'
  .dB  0 ,  0 ,  0 ,  0 ,  0 ,  0 ,  0 ,  0
  .dB 'M', '4', '7', '1', '2', '1', '2', '8'
  .dB '-', '+', '*', '9', '0', '5', '/', 'N'
  .dB '`', '6', 'P', ' ', '9', '3', '.', '0'
  ;   ---------------------------------------------------------------------
  NumberofLetters_end:
.db #23,#22,#21,#16,#15,#26,#22,#13

word_end:
.db 'T','R','U','T','H',' ','W','I','N','S',' ','A','G','A','I','N','S','T',' ','E','V','I','L'
.db 'R','A','V','A','N',' ','I','S',' ','K','I','N','G',' ','O','F',' ','L','A','N','K','A'
.db 'L','O','R','D',' ','L','A','X','M','A','N',' ','I','S',' ','D','Y','I','E','N','G'
.db 'S','A','V','E',' ','L','O','R','D',' ','L','A','X','M','A','N'
.db 'P','L','E','A','S','E',' ','H','U','R','R','Y',' ','U','P'
.db 'B','R','I','N','G',' ','S','A','N','J','I','V','A','N','I',' ','B','O','O','T','I',' ','F','A','S','T'
.db 'H','A','N','U','M','A','N',' ','F','I','G','H','T','S',' ','B','R','A','V','E','L','Y'
.db 'J','A','I',' ','S','H','R','E','E',' ','R','A','M'



Lower_byte_pal_end:
.db $83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f

;   -----------------------------------------------------------------------------
LoadSprites98:
      LDX #$00
@LoadSpritesLoop:
      LDA sprites_hanuman_rock, x            ; load data from address (sprites + x)
      STA $0500, x              ; store into RAM address ($0200 + x)
      INX                       ; X = X + 1
      CPX #255
                        ; Compare X to # of values (divide by 4 for total # of sprites)
      BNE @LoadSpritesLoop
      rts
;     --------------------------------------------------------------------------------------
      
 sprites_hanuman_rock:
.db $90, $00, $00, $80 ;sprite 6
.db $90, $01, $00, $88 ;sprite 7
.db $90, $02, $00, $90 ;sprite 8
.db $90, $03, $00, $98 ;sprite 8

.db $98, $10, $00, $80 ;sprite 9
.db $98, $11, $00, $88 ;sprite 10
.db $98, $12, $00, $90 ;sprite 11
.db $98, $13, $00, $98 ;sprite 11

.db $a0, $20, $00, $80 ;sprite 6
.db $a0, $21, $00, $88 ;sprite 7
.db $a0, $22, $00, $90 ;sprite 8
.db $a0, $23, $00, $98 ;sprite 8

.db $a8, $30, $00, $80 ;sprite 9
.db $a8, $31, $00, $88 ;sprite 10
.db $a8, $32, $00, $90 ;sprite 11
.db $a8, $33, $00, $98 ;sprite 11

.db $b0, $40, $00, $80 ;sprite 6
.db $b0, $41, $00, $88 ;sprite 7
.db $b0, $42, $00, $90 ;sprite 8
.db $b0, $43, $00, $98 ;sprite 8

.db $b8, $50, $00, $80 ;sprite 9
.db $b8, $51, $00, $88 ;sprite 10
.db $b8, $52, $00, $90 ;sprite 11
.db $b8, $53, $00, $98 ;sprite 11

.db $88, $46, $03, $70 ;sprite 6
.db $88, $47, $03, $78 ;sprite 7
.db $88, $48, $03, $80 ;sprite 8
.db $88, $49, $03, $88 ;sprite 8
.db $88, $4a, $03, $90 ;sprite 9
.db $88, $4b, $03, $98 ;sprite 10
.db $88, $4c, $03, $a0 ;sprite 11
.db $88, $4d, $03, $a8 ;sprite 11

.db $80, $36, $03, $70 ;sprite 6
.db $80, $37, $03, $78 ;sprite 7
.db $80, $38, $03, $80 ;sprite 8
.db $80, $39, $03, $88 ;sprite 8
.db $80, $3a, $03, $90 ;sprite 9
.db $80, $3b, $03, $98 ;sprite 10
.db $80, $3c, $03, $a0 ;sprite 11
.db $80, $3d, $03, $a8 ;sprite 11

.db $78, $26, $03, $70 ;sprite 6
.db $78, $27, $03, $78 ;sprite 7
.db $78, $28, $03, $80 ;sprite 8
.db $78, $29, $03, $88 ;sprite 8
.db $78, $2a, $03, $90 ;sprite 9
.db $78, $2b, $03, $98 ;sprite 10
.db $78, $2c, $03, $a0 ;sprite 11
.db $78, $2d, $03, $a8 ;sprite 11

.db $70, $16, $03, $70 ;sprite 6
.db $70, $17, $03, $78 ;sprite 7
.db $70, $18, $03, $80 ;sprite 8
.db $70, $19, $03, $88 ;sprite 8
.db $70, $1a, $03, $90 ;sprite 9
.db $70, $1b, $03, $98 ;sprite 10
.db $70, $1c, $03, $a0 ;sprite 11
.db $70, $1d, $03, $a8 ;sprite 11

.db $68, $06, $03, $70 ;sprite 6
.db $68, $07, $03, $78 ;sprite 7
.db $68, $08, $03, $80 ;sprite 8
.db $68, $09, $03, $88 ;sprite 8
.db $68, $0a, $03, $90 ;sprite 9
.db $68, $0b, $03, $98 ;sprite 10
.db $68, $0c, $03, $a0 ;sprite 11
.db $68, $0d, $03, $a8 ;sprite 11

