typ_end_Compare:

lda var_new                     ;;;;;; triggering for going into compare for snake level
cmp #1
beq @com_jmp
rts

@com_jmp:

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
inc $504
@c:RTS

@Found:                           ;;;;;; if word typed is correct then going in found
 ;;;;;;;;
         ;lda #0
         ;sta ps2
         ;jsr arrow11
         ;jsr LoadSprites98

         lda #0
         sta Current
   lda #1
   sta under1
   inc wl                          ; this will increse the wl. So if "RO" are pressed then wl = 2 and if "C" is pressed then wl=3
   ldx wl                          ; is the current lenght of the letters pressed of a word
                        ; level number. - how many words r completed for "ROCK" it is wordnum = 1
   ldy wordnum
   lda NumberofLetters,y           ; load the no.of letters in word. here for rock,it will load 4
   sta ww
   inc pointer                     ; increment pointer so now it points to the next correct letter


    LDA #$01
    STA varX
    STA var1
    jsr map                       ;;;;;;; mapping for how many steps word has to be completed
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
         ;sta delay_cal_quiz       ;;;;; initializing delay value to 0
         ;sta var_new         ;;;;; disabling the first word comparision
         lda #1
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
                lda scroll_h
                sta $2005
                lda scroll_v
                sta $2005

                lda #0
                sta ttempx
                sta trigger
                ;lda #1
                ;sta trigger0
                jsr LoadSprites98
                lda #4
                sta level_change
                lda #2
                sta game_no
     ;  jsr kishan_chal

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
                   beq @under_jmp1
                   rts
@under_jmp1:
          lda clearing_byte
          cmp #1
          bne @start_under
          lda #0
          sta lower_byte
@start_under:
             inc clearing_byte
          ldy lower_byte
          lda #$A0
          LDA $2002             ; read PPU status to reset the high/low latch
          LDA #$23
          STA $2006             ; write the high byte of $2000 address
          LDA Lower_byte_pal2,y
          STA $2006

          lda #$ED
          sta $2007

          inc lower_byte
          ;lda #%00011110
          ;sta $2001
          lda PPUCRTL
      sta $2000
      lda scroll_h
      sta $2005
      lda scroll_v
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
          ;lda #%00000000             ;off the screen
          ;sta $2001
          ldy lower_byte
          lda #$A0
          LDA $2002             ; read PPU status to reset the high/low latch
          LDA #$23
          STA $2006             ; write the high byte of $2000 address
          LDA #$8c
          STA $2006
          ldx #0

@loop_under:
          lda #$FD
          sta $2007
          inx
          cpx #20
          bne @loop_under

          ;lda #%00011110
          ;sta $2001
          lda PPUCRTL
      sta $2000
      lda scroll_h
      sta $2005
      lda scroll_v
      sta $2005

          lda #0
          sta under2
          sta lower_byte
          rts
;       -------------------------------------------------------------------------
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
 lda var1



 cmp #$01


 BEQ over1234

  ;;;;;;
  lda keyboard_end, x           ;;load that character
  ;;;;;;;;;;;;;;

  ;;;;;;;;;
  sta Current                 ;;store into sprite tile




  over1234:
  rts
  
  

  kishan_chal:
  lda #$43
  sta $501

  sta $505

  sta $509
  sta $50D
  sta $511
  sta $515

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
.db #23

word_end:
.db 'T','R','U','T','H',' ','W','I','N','S',' ','A','G','A','I','N','S','T',' ','E','V','I','L'



;   -----------------------------------------------------------------------------
LoadSprites98:
      LDX #$00
@LoadSpritesLoop:
      LDA sprites_snow_end, x            ; load data from address (sprites + x)
      STA $0500, x              ; store into RAM address ($0200 + x)
      INX                       ; X = X + 1
      CPX #32
                        ; Compare X to # of values (divide by 4 for total # of sprites)
      BNE @LoadSpritesLoop
      rts
;     --------------------------------------------------------------------------------------
      
 sprites_snow_end:     
.db $A0, $1f, $02, $D0 ;sprite 6
.db $A0, $c3, $02, $D8 ;sprite 7
.db $A0, $c4, $02, $E0 ;sprite 8
.db $A0, $c5, $02, $E8 ;sprite 8

.db $A8, $1f, $02, $D0 ;sprite 9
.db $A8, $d3, $02, $D8 ;sprite 10
.db $A8, $d4, $02, $E0 ;sprite 11
.db $A8, $d5, $02, $E8 ;sprite 11