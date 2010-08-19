
load_sprites_1:

                  lda trig_disp_level1
                  cmp #1
                  bne @rtt

                INC smc1
                lda smc1
                CMP #15
                BNE @rtt
                lda #0
                sta smc1


 @jk :lda duf
     cmp #0
     bne @jk1
     lda #$A2     ;;;L
     sta $5A1

     lda #1
     sta duf
@rtt:     rts

 @jk1: lda duf
     cmp #1
     bne @jk2
      lda #$B2     ;;;E
      sta $5A5

     lda #2
     sta duf
     rts

 @jk2:lda duf
     cmp #2
     bne @jk3
     lda #$A3     ;;;V
     sta $5A9

     lda #3
     sta duf
     rts

  @jk3:lda duf
     cmp #3
     bne @jk4
     lda #$B2    ;;;E
     sta $5AD
     lda #4
     sta duf
     rts

  @jk4:lda duf
     cmp #4
     bne @jk5
     lda #$A2    ;;;L
     sta $5B1
     lda #5
     sta duf
     rts

  @jk5:lda duf
     cmp #5
     bne @jk6
     lda #$32    ;;;1
     sta $5B5
     lda #6
     sta duf
     rts


  @jk6:lda duf
      cmp #6
      bne @jk7

      lda #7
      sta duf
      rts

  @jk7:lda duf
      cmp #7
      bne @jk8

      lda #8
      sta duf
      rts

  @jk8:lda duf
      cmp #8
      bne @jk9

      lda #$00
      sta $5A1
      sta $5A5
      sta $5A9
      sta $5AD
      sta $5B1
      sta $5B5

     lda #9
     sta duf
    ;  lda #0
    ;  sta trig_disp_level1
     rts



  @jk9:lda duf
      cmp #9
      bne @jk10

      lda #10
      sta duf
      rts

 @jk10:
      lda #47
      sta level1_complete

  @rtt1:    rts

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;this subroutine is called when a question mark is touched  by hanuman  ..... it loads the question screen .....it disables the mainscreen controller and
;; initialises the questionscreen variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Questionscreen_1:

lda #0
          sta go0
          sta go
          sta bo
          sta scrolldown_act
          sta scrollup_act
          sta scro
          sta scroll_step

LDA #$13
JSR setCHRPage1000
 ;       ldx  #0
;back    lda $500 , x
;        sta $600 , x
;        inx
;        txa
;        bne back
         lda #0
         sta trig_controller1
        ldx #0
        lda scroll_h
        sta scroll_h_temp
        lda scroll_v
        sta scroll_v_temp
        lda #0
        sta scroll_h
        sta scroll_v
        lda #%10001000
        sta $2000
 jsr ClearSprites11

        ldx #0

@back1   lda sprite ,x
        sta $600, x
        inx
        txa
        cmp #4
        bne @back1



        lda #10
        sta scroll_change
        ;jsr pallatechange
        lda #%00000000
        sta $2001
        jsr Q44_1


        jsr update_sprites1
        lda #%00011110

        sta $2001
        lda #0
        sta $2005
        sta $2005

        lda #1
        sta bg

        lda #5
        sta control

        lda #1
        sta bg

        lda #5
        sta qq
        sta random_enable

        lda #142
        sta $600



 rts

  ;.................................................................................................................................................
;.........................................................................................................................................................
;.........................................................................................................................................................
 ;.................................................................................................................................................
;.........................................................................................................................................................
;.........................................................................................................................................................
;;; Controller for Question screen......
;;; selecting the options is done over here
;;;and after selceting if the answer is right then execution moves to @corr otherwise @inncorrect1
newcontroller_1:
        lda control
        cmp #5
        bne @newCheckOver1

        lda checkup_status
        beq @nxt1
        dec checkup_status
@nxt1
        lda checkdown_status
        beq @nxt
        dec checkdown_status
@nxt:
        LDA buttons
	sta oldbuttons


        ldx #$00

        LDA #$01		; strobe joypad
	STA $4016
	LDA #$00
	STA $4016
@con_loop1:
	LDA $4016		; check the state of each button
	LSR
	ROR buttons
        INX
        CPX #$08
        bne @con_loop1

	LDA oldbuttons
	EOR #$FF
	AND buttons

@newCheckUp:
        lda checkup_status
        bne @newCheckDown

	LDA #%00010000
	;AND justpressed
	AND buttons
        BEQ @newCheckDown
          lda #%00011110
                    sta $2001

        lda #13
        sta checkup_status
       	lda $600
	cmp #142
        beq @onedown
        cmp #158
        beq @twodown
        cmp #174
        beq @threedown
        cmp #190

        beq @fourdown
@onedown:
lda #190
sta $600
jmp @newCheckLeft
@newCheckOver1 :
jmp @newCheckOver
@twodown:
lda #142
sta $600
jmp @newCheckLeft
@threedown:
lda #158
sta $600
jmp @newCheckLeft
@fourdown:
lda #174
sta $600


@newCheckDown:
        lda checkdown_status
        bne @newCheckLeft
	LDA #%00100000
	;AND justpressed
	AND buttons
	BEQ @newCheckLeft
	lda #13
        sta checkdown_status
        lda $600
        cmp #142
        beq @one
        cmp #158
        beq @two
        cmp #174
        beq @three
        cmp #190
        beq @four
@one:
lda #158
sta $600
jmp @newCheckDown
@two:
lda #174
sta $600
jmp @newCheckDown
@three:
lda #190
sta $600
jmp @newCheckDown
@four:
lda #142
sta $600
jmp @newCheckDown


@newCheckLeft:
	LDA #%01000000
	AND buttons
	BEQ @newCheckRight


@newCheckRight:
	LDA #%10000000
	AND buttons
	BEQ @newCheckB

;	sta random_enable
;bck1:	jsr backtomain

;	BEQ newCheckSe

;newCheckSel:
;	LDA #%00000100
;	AND justpressed
;	BEQ newCheckStart

;newCheckStart
;	LDA #%00001000
;	AND justpressed
;	BEQ newCheckB

@newCheckB:
        ;lda wrongans
        ;cmp #10
        ;beq @newCheckA
	LDA #%00000010
	AND buttons
	BEQ @newCheckA



@newCheckA:
	LDA #%00000001
	AND buttons
	beq @newCheckOver
	
	ldy question_count
        ; lda #80
        lda answers_1,y
        cmp $600
     ;   cmp #option1
        beq @corrr
        jmp @inncorrect1

@newCheckOver:

        RTS
@corrr:
      jmp @correct
  ;       ----------------------------------------------------
            ; Loading Sad Face
            ; triggering->jmp from new controller
    ;       ----------------------------------------------------
@inncorrect1 :

 jsr load_incorrect
                    ldx #0

@back1   lda correct_sprite ,x
        sta $600, x
        inx
        txa
        cmp #4
        bne @back1
            jsr update_sprites11
            lda #10
            sta wrongans
            sta control
            lda #%00000000
            sta $2001
            lda #1
            sta trigger_delay2


        lda #%00000000
        sta $2001
 LDA $2002             ; read PPU status to reset the high/low latch
            LDA #$23
            STA $2006             ; write the high byte of $2000 address
            LDA #$04
            STA $2006             ; write the low byte of $2000 address
            LDX #$00

            LDA #$F1               ;loading correponding tiles from chr
            STA $2007
            LDA #$F2
            STA $2007

            LDA $2002             ; read PPU status to reset the high/low latch
            LDA #$22
            STA $2006             ; write the high byte of $2000 address
            LDA #$84
            STA $2006             ; write the low byte of $2000 address
            LDX #$00

            LDA #$B1               ;loading correponding tiles from chr
            STA $2007
            LDA #$b2
            STA $2007
            LDA #$B3
            STA #2007

            LDA $2002             ; read PPU status to reset the high/low latch
            LDA #$22
            STA $2006             ; write the high byte of $2000 address
            LDA #$e4
            STA $2006             ; write the low byte of $2000 address
            LDX #$00

            LDA #$E0              ;loading correponding tiles from chr
            STA #2007
            LDA #$E1
            STA $2007
            LDA #$E2
            STA $2007
            LDA #$E3
            STA $2007

            LDA $2002             ; read PPU status to reset the high/low latch
            LDA #$22
            STA $2006             ; write the high byte of $2000 address
            LDA #$C4
            STA $2006             ; write the low byte of $2000 address
            LDX #$00

            LDA #$D1              ;loading correponding tiles from chr
            STA $2007
            LDA #$D2
            STA $2007
            LDA #$D3
            STA $2007

            LDA $2002             ; read PPU status to reset the high/low latch
            LDA #$22
            STA $2006             ; write the high byte of $2000 address
            LDA #$A4
            STA $2006             ; write the low byte of $2000 address
            LDX #$00

            LDA #$C1              ;loading correponding tiles from chr
            STA $2007
            LDA #$C2
            STA $2007
            LDA #$C3
            STA $2007

            LDA $2002             ; read PPU status to reset the high/low latch
            LDA #$23
            STA $2006             ; write the high byte of $2000 address
            LDA #$41
            STA $2006             ; write the low byte of $2000 address
            LDX #$00

            lda #$57
            sta $2007
            lda #$52
            sta $2007
            lda #$4F
            sta $2007
            lda #$4E
            sta $2007
            lda #$47
            sta $2007

            lda #%00011110        ; on the screen
            sta $2001
            lda #0                ; clearin $2005 to avoid scroling
            sta $2005
            sta $2005
        rts
;       -----------------------------------------------------
        ; Loading happy face
        ; triggering->jmp from new controller
@correct :
          jsr load_correct
         jsr update_sprites11
        lda #1
        sta trigger_delay
        sta control

        lda #%00000000
        sta $2001

        LDA $2002             ; read PPU status to reset the high/low latch
        LDA #$22
        STA $2006             ; write the high byte of $2000 address
        LDA #$64
        STA $2006             ; write the low byte of $2000 address
        LDX #$00


        lda #$A5
        sta $2007
        lda #$B4
        sta $2007
        lda #$A5
        sta $2007

        LDA #$22
        STA $2006             ; write the high byte of $2000 address
        LDA #$84
        STA $2006             ; write the low byte of $2000 address
        LDX #$00

        lda #$b5
        sta $2007
        lda #$B6
        sta $2007
        lda #$B7
        sta $2007

        LDA #$22
        STA $2006             ; write the high byte of $2000 address
        LDA #$A4
        STA $2006             ; write the low byte of $2000 address
        LDX #$00

        lda #$C5
        sta $2007
        lda #$C4
        sta $2007

        LDA $2002             ; read PPU status to reset the high/low latch
        LDA #$22
        STA $2006             ; write the high byte of $2000 address
        LDA #$C3
        STA $2006             ; write the low byte of $2000 address
        LDX #$00

        lda #$D4
        sta $2007
        lda #$D5
        sta $2007
        lda #$D6
        sta $2007
        lda #$D7
        sta $2007

        LDA $2002             ; read PPU status to reset the high/low latch
        LDA #$22
        STA $2006             ; write the high byte of $2000 address
        LDA #$e3
        STA $2006             ; write the low byte of $2000 address
        LDX #$00

        lda #$E4
        sta $2007
        lda #$E5
        sta $2007
        lda #$E6
        sta $2007
        lda #$E7
        sta $2007

        LDA $2002             ; read PPU status to reset the high/low latch
        LDA #$23
        STA $2006             ; write the high byte of $2000 address
        LDA #$04
        STA $2006             ; write the low byte of $2000 address
        LDX #$00

        lda #$F5
        sta $2007
        lda #$F6
        sta $2007

        LDA $2002             ; read PPU status to reset the high/low latch
        LDA #$23
        STA $2006             ; write the high byte of $2000 address
        LDA #$41
        STA $2006             ; write the low byte of $2000 address
        LDX #$00

        LDA #$52
        sta $2007
        lda #$49
        sta $2007
        lda #$47
        sta $2007
        lda #$48
        sta $2007
        lda #$54
        sta $2007

        lda #%00011110
        sta $2001
        lda #0
        sta $2005
        sta $2005
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
screenchange5_1:
   	LDA #$20                ; set to beginning of first nametable
    	STA $2006
    	LDA #$00
    	STA $2006
        LDA #<screen5_1              ; load low byte of first picture
        STA $10
        LDA #>screen5_1              ; load high byte of first picture
        STA $11
        LDY #$00
        LDX #$04
@NameLoop22:    LDA ($10),y
              STA $2007
              INY
              BNE @NameLoop22
              INC $11
              DEX
              BNE @NameLoop22
              lda ppucntl
              sta $2000
rts

screenchange7_1:
   	LDA #$20                ; set to beginning of first nametable
    	STA $2006
    	LDA #$00
    	STA $2006
        LDA #<screen7_1              ; load low byte of first picture
        STA $10
        LDA #>screen7_1              ; load high byte of first picture
        STA $11
        LDY #$00
        LDX #$04
@NameLoop22:    LDA ($10),y
              STA $2007
              INY
              BNE @NameLoop22
              INC $11
              DEX
              BNE @NameLoop22
              lda ppucntl
              sta $2000
rts


  mainscreen1_1:
   	LDA #$20                ; set to beginning of first nametable
    	STA $2006
    	LDA #$00
    	STA $2006
        LDA #<screen1_1              ; load low byte of first picture
        STA $10
        LDA #>screen1_1              ; load high byte of first picture
        STA $11
        LDY #$00
        LDX #$04
@NameLoop22:    LDA ($10),y
              STA $2007
              INY
              BNE @NameLoop22
              INC $11
              DEX
              BNE @NameLoop22
              lda ppucntl
              sta $2000
              lda #239
              sta scroll_v
rts

Q44_1:
   	LDA #$20                ; set to beginning of first nametable
    	STA $2006
    	LDA #$00
    	STA $2006
        LDA #<pic1              ; load low byte of first picture
        STA $10
        LDA #>pic1              ; load high byte of first picture
        STA $11
        LDY #$00
        LDX #$04
@NameLoop6:    LDA ($10),y
              STA $2007
              INY
              BNE @NameLoop6
              INC $11
              DEX
              BNE @NameLoop6
RTS
;  ---------------------------------------------------------
;  -------------------------------------------------------------------
   ;loading the QUESTION on the QUESTION SCREEN
   ;triggered in question screen
;  --------------------------------------------------------------------

; Loading questions

background_1:
           lda new_qst
           cmp #1
           bne @srt_qs
           jsr background__1
           rts
@srt_qs:
                 lda bg
                 cmp #1
                 beq @new1
                 rts
@new1:
                     LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$20
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$86
                     STA $2006             ; write the low byte of $2000 address
                     LDX #$00
                     LDY count
                                  ; start out at 0
@LoadBackgroundLoop11:
                    lda #%00000000
                    sta $2001

                    LDA question1_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start

                    LDA question2_1, y
                    ldx question_no
                    cpx #1
                    beq @start

                    LDA question3_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start

                    LDA question4_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start

                    LDA question5_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start

                    LDA question6_1, y
                    ldx question_no
                    cpx #5
                    beq @start

                    LDA question7_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start

                    LDA question8_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start

                    LDA question9_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start

                    LDA question10_1, y
                    ldx question_no
                    cpx #9
                    beq @start
                    
                    lda #1
                    sta new_qst
                    LDA question11_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #10
                    beq @start




@start:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop11
                    lda #19
                    sta count2


                     LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$20
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$C6
                     STA $2006             ; write the low byte of $2000 address
                     LDX #$00
                                  ; start out at 0
@LoadBackgroundLoop12:

                    LDA question1_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start1

                    LDA question2_1, y
                    ldx question_no
                    cpx #1
                    beq @start1

                    LDA question3_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start1

                    LDA question4_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start1

                    LDA question5_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start1

                    LDA question6_1, y
                    ldx question_no
                    cpx #5
                    beq @start1

                    LDA question7_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start1

                    LDA question8_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start1

                    LDA question9_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start1

                    LDA question10_1, y
                    ldx question_no
                    cpx #9
                    beq @start1

                    LDA question11_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #10
                    beq @start1

@start1:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop12
                    lda #19
                    sta count2


                    LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$21
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$06
                     STA $2006             ; write the low byte of $2000 address
                     LDX #$00
                                  ; start out at 0
@LoadBackgroundLoop13:

                    LDA question1_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start2

                    LDA question2_1, y
                    ldx question_no
                    cpx #1
                    beq @start2

                    LDA question3_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start2

                    LDA question4_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start2

                    LDA question5_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start2

                    LDA question6_1, y
                    ldx question_no
                    cpx #5
                    beq @start2

                    LDA question7_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start2

                    LDA question8_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start2

                    LDA question9_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start2

                    LDA question10_1, y
                    ldx question_no
                    cpx #9
                    beq @start2

                    LDA question11_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #10
                    beq @start2

@start2:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop13

                    lda #%00011110
                    sta $2001
                    LDA #$00
                    STA $2005
                    STA $2005
                    lda #0
                    sta bg
                    lda #19
                    sta count2
                    lda #1
                    sta bg1
                    sty count
                    rts
;      -------------------------------------------------------------------
; loading options on the question screen
background1_1:
            lda new_qst1
            cmp #1
            bne @srt_qs1
            jsr background1__1
            rts
@srt_qs1:
                 lda bg1
                 cmp #1
                 beq @new9
                 rts
@new9:
                 LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$21
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$EB
                     STA $2006
                     sty count             ; write the low byte of $2000 address
                                  ; start out at 0
@LoadBackgroundLoop29:
                    lda #%00000000
                    sta $2001

                    LDA question1_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start91

                    LDA question2_1, y
                    ldx question_no
                    cpx #1
                    beq @start91

                    LDA question3_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start91

                    LDA question4_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start91

                    LDA question5_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start91

                    LDA question6_1, y
                    ldx question_no
                    cpx #5
                    beq @start91

                    LDA question7_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start91

                    LDA question8_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start91

                    LDA question9_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start91

                    LDA question10_1, y
                    ldx question_no
                    cpx #9
                    beq @start91

                    LDA #1
                    STA new_qst1
                    LDA question11_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #10
                    beq @start91

@start91:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop29
                    lda #19
                    sta count2


                     LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$22
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$8B
                     STA $2006             ; write the low byte of $2000 address
                     LDX #$00
                                  ; start out at 0
                     LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$22
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$4B
                     STA $2006
                     sty count             ; write the low byte of $2000 address
                                  ; start out at 0
@LoadBackgroundLoop19:
                    lda #%00000000
                    sta $2001

                    LDA question1_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start9

                    LDA question2_1, y
                    ldx question_no
                    cpx #1
                    beq @start9

                    LDA question3_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start9

                    LDA question4_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start9

                    LDA question5_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start9

                    LDA question6_1, y
                    ldx question_no
                    cpx #5
                    beq @start9

                    LDA question7_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start9

                    LDA question8_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start9

                    LDA question9_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start9

                    LDA question10_1, y
                    ldx question_no
                    cpx #9
                    beq @start9

                    LDA question11_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #10
                    beq @start9

@start9:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop19
                    lda #19
                    sta count2


                     LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$22
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$8B
                     STA $2006             ; write the low byte of $2000 address
                     LDX #$00
                                  ; start out at 0
@LoadBackgroundLoop18:

                    LDA question1_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start8

                    LDA question2_1, y
                    ldx question_no
                    cpx #1
                    beq @start8

                    LDA question3_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start8

                    LDA question4_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start8

                    LDA question5_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start8

                    LDA question6_1, y
                    ldx question_no
                    cpx #5
                    beq @start8

                    LDA question7_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start8

                    LDA question8_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start8

                    LDA question9_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start8

                    LDA question10_1, y
                    ldx question_no
                    cpx #9
                    beq @start8

                    LDA question11_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #10
                    beq @start8

@start8:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop18
                    lda #19
                    sta count2


                    LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$22
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$CB
                     STA $2006             ; write the low byte of $2000 address
                     LDX #$00
                                  ; start out at 0
@LoadBackgroundLoop17:

                    LDA question1_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start7

                    LDA question2_1, y
                    ldx question_no
                    cpx #1
                    beq @start7

                    LDA question3_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start7

                    LDA question4_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start7

                    LDA question5_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start7

                    LDA question6_1, y
                    ldx question_no
                    cpx #5
                    beq @start7

                    LDA question7_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start7

                    LDA question8_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start7

                    LDA question9_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start7

                    LDA question10_1, y
                    ldx question_no
                    cpx #9
                    beq @start7

                    LDA question11_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #10
                    beq @start7

@start7:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop17

                    lda #19
                    sta count2

                    LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$23
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$0B
                     STA $2006             ; write the low byte of $2000 address
                     LDX #$00
                                  ; start out at 0
@LoadBackgroundLoop16:

                    LDA question1_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start6

                    LDA question2_1, y
                    ldx question_no
                    cpx #1
                    beq @start6

                    LDA question3_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start6

                    LDA question4_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start6

                    LDA question5_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start6

                    LDA question6_1, y
                    ldx question_no
                    cpx #5
                    beq @start6

                    LDA question7_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start6

                    LDA question8_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start6

                    LDA question9_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start6

                    LDA question10_1, y
                    ldx question_no
                    cpx #9
                    beq @start6

                    LDA question11_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #10
                    beq @start6

@start6:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop16


                    lda #%00011110
                    sta $2001
                    LDA #$00
                    STA $2005
                    STA $2005
                    lda #0
                    sta bg1
                    lda #00
                    sta count
                    lda #19
                    sta count2
                    inc question_no
                    rts
;;;;;               ----------------------------------------------------------------------------------------------
background__1:
                 lda bg
                 cmp #1
                 beq @new1
                 rts
@new1:
                     LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$20
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$86
                     STA $2006             ; write the low byte of $2000 address
                     LDX #$00
                     LDY count
                                  ; start out at 0
@LoadBackgroundLoop11:
                    lda #%00000000
                    sta $2001

                    LDA question12_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start

                    LDA question13_1, y
                    ldx question_no
                    cpx #12
                    beq @start

                    LDA question14_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start

                    LDA question15_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #14
                    beq @start

@start:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop11
                    lda #19
                    sta count2


                     LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$20
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$C6
                     STA $2006             ; write the low byte of $2000 address
                     LDX #$00
                                  ; start out at 0
@LoadBackgroundLoop12:

                    LDA question12_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start1

                    LDA question13_1, y
                    ldx question_no
                    cpx #12
                    beq @start1

                    LDA question14_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start1

                    LDA question15_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #14
                    beq @start1

@start1:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop12
                    lda #19
                    sta count2


                    LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$21
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$06
                     STA $2006             ; write the low byte of $2000 address
                     LDX #$00
                                  ; start out at 0
@LoadBackgroundLoop13:

                    LDA question12_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start2

                    LDA question13_1, y
                    ldx question_no
                    cpx #12
                    beq @start2

                    LDA question14_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start2

                    LDA question15_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #14
                    beq @start2

@start2:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop13

                    lda #%00011110
                    sta $2001
                    LDA #$00
                    STA $2005
                    STA $2005
                    lda #0
                    sta bg
                    lda #19
                    sta count2
                    lda #1
                    sta bg1
                    sty count
                    rts
;      -------------------------------------------------------------------
; loading options on the question screen
background1__1:
                 lda bg1
                 cmp #1
                 beq @new9
                 rts
@new9:
                 LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$21
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$EB
                     STA $2006
                     sty count             ; write the low byte of $2000 address
                                  ; start out at 0
@LoadBackgroundLoop29:
                    lda #%00000000
                    sta $2001

                    LDA question12_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start91

                    LDA question13_1, y
                    ldx question_no
                    cpx #12
                    beq @start91

                    LDA question14_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start91

                    LDA question15_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #14
                    beq @start91

@start91:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop29
                    lda #19
                    sta count2


                     LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$22
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$8B
                     STA $2006             ; write the low byte of $2000 address
                     LDX #$00
                                  ; start out at 0
                     LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$22
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$4B
                     STA $2006
                     sty count             ; write the low byte of $2000 address
                                  ; start out at 0
@LoadBackgroundLoop19:
                    lda #%00000000
                    sta $2001

                    LDA question12_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start9

                    LDA question13_1, y
                    ldx question_no
                    cpx #12
                    beq @start9

                    LDA question14_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start9

                    LDA question15_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #14
                    beq @start9

@start9:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop19
                    lda #19
                    sta count2


                     LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$22
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$8B
                     STA $2006             ; write the low byte of $2000 address
                     LDX #$00
                                  ; start out at 0
@LoadBackgroundLoop18:

                    LDA question12_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start8

                    LDA question13_1, y
                    ldx question_no
                    cpx #12
                    beq @start8

                    LDA question14_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start8

                    LDA question15_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #14
                    beq @start8

@start8:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop18
                    lda #19
                    sta count2


                    LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$22
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$CB
                     STA $2006             ; write the low byte of $2000 address
                     LDX #$00
                                  ; start out at 0
@LoadBackgroundLoop17:

                    LDA question12_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start7

                    LDA question13_1, y
                    ldx question_no
                    cpx #12
                    beq @start7

                    LDA question14_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start7

                    LDA question15_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #14
                    beq @start7

@start7:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop17

                    lda #19
                    sta count2

                    LDA $2002             ; read PPU status to reset the high/low latch
                     LDA #$23
                     STA $2006             ; write the high byte of $2000 address
                     LDA #$0B
                     STA $2006             ; write the low byte of $2000 address
                     LDX #$00
                                  ; start out at 0
@LoadBackgroundLoop16:

                    LDA question12_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start6

                    LDA question13_1, y
                    ldx question_no
                    cpx #12
                    beq @start6

                    LDA question14_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start6

                    LDA question15_1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #14
                    beq @start6

@start6:
                    STA $2007
                    DEC count2
                    INY                   ; X = X + 1
                    lda #0
                    CMP count2               ; Compare X to hex $80, decimal 128 - copying 128 bytes
                    BNE @LoadBackgroundLoop16


                    lda #%00011110
                    sta $2001
                    LDA #$00
                    STA $2005
                    STA $2005
                    lda #0
                    sta bg1
                    lda #00
                    sta count
                    lda #19
                    sta count2
                    inc question_no
                    rts
;;;;         ------------------------------------------------------------------------
delay_cal2_1:
          lda trigger_delay2
          cmp #1
          bne @end124
          inc delayy
          lda delayy
          cmp #100
          bne @end124
          lda #0
          sta trigger_delay2
          sta delayy
          lda #0
          sta go0
          sta go
          sta bo
          sta scrolldown_act
          sta scrollup_act
          sta scro
          sta scroll_step
          jmp @incorrect1
@end124
        rts
;       -----------------------------------------------------------
;        loading back the screen after correct ans is given


;       -----------------------------------------
;        loading the screen after giving incorrect answer----------------
;        loading the screen
@incorrect1:
           ;lda #0
           ;sta wrongans
           lda #80
           sta delay
           inc question_count
                     jsr palchange_galaxy
           LDA #$05
           JSR setCHRPage0000
           LDA #$03
           JSR setCHRPage1000
           lda #0
           sta $2001
           sta scroll_change
           lda screen_no
             cmp #0
@abv1         bne @nex15
             jsr mainscreen1_1
             jmp @nex13
@nex15        cmp #1
             bne @nex14
@nex16        jsr screenchange11_1
             jmp @nex17
@nex14        cmp #2
             bne @nex17
             jmp @nex16
@nex17       cmp #3
             bne @nex18
@nex19       jsr screenchange5_1
             jmp @nex20
@nex18       cmp #4
             bne @nex20
             jmp @nex19
@nex20       cmp #5
             bne @nex21
@nex22       jsr screenchange7_1
             jmp @nex13
@nex21       cmp #6
             bne @nex23
             jmp @nex22
@nex23       cmp #7
             bne @nex24
@nex25       jsr screenchange9
             jmp @nex13
@nex24       cmp #8
             bne @nex13
             jmp @nex25
@nex13:
           lda scroll_h_temp
           sta scroll_h
           lda scroll_v_temp
           sta scroll_v
           lda ppucntl
           sta $2000
           lda #%00011110
           sta $2001
           jsr update_sprites
           lda #0
           sta qq
           lda #0
           sta control
  ;;;;;;;;;;;;;
           lda #$fe
           sta $500
           sta $504
           sta $508
           sta $50C
           sta $510
           sta $514
           sta $518
           lda #0
           sta random_enable
           lda #1
           sta icq0
           sta cbb
           sta trig_controller1
           rts

;       -----------------------------------------------------------------------
delay_cal_1:
          lda trigger_delay
          cmp #1
          bne @end123
          inc delayy
          lda delayy
          cmp #100
          bne @end123
          lda #0
          sta trigger_delay
          sta delayy
          jsr ClearSprites11
          jmp @back_to_game
@end123: rts;-------------------------------------------------------------------
@back_to_game:
             inc question_count
           jsr palchange_galaxy
           LDA #$05
           JSR setCHRPage0000
           LDA #$03
           JSR setCHRPage1000
           lda #0
           sta $2001
           sta scroll_change
           lda screen_no
             cmp #0
@abv1         bne @nex15
             jsr mainscreen1_1
             jmp @nex13
@nex15        cmp #1
             bne @nex14
@nex16        jsr screenchange11_1
             jmp @nex17
@nex14        cmp #2
             bne @nex17
             jmp @nex16
@nex17       cmp #3
             bne @nex18
@nex19       jsr screenchange5_1
             jmp @nex20
@nex18       cmp #4
             bne @nex20
             jmp @nex19
@nex20       cmp #5
             bne @nex21
@nex22       jsr screenchange7_1
             jmp @nex13
@nex21       cmp #6
             bne @nex23
             jmp @nex22
@nex23       cmp #7
             bne @nex24
@nex25       jsr screenchange9
             jmp @nex13
@nex24       cmp #8
             bne @nex13
             jmp @nex25
@nex13       lda scroll_h_temp
             sta scroll_h
             lda scroll_v_temp
             sta scroll_v
             lda #%00011110
             sta $2001
             lda #0
             sta qq
             lda #0
             sta control
             lda #$fe
             sta $500
             sta $504
             sta $508
             sta $50C
             sta $510
             sta $514
             sta $518
             lda #0
              sta random_enable
              lda #1
              sta cq0
              sta uss
              sta trig_controller1
              lda ppucntl
              sta $2000
@jj:
   jmp @jj


screen3to1_1:
        lda #0
        sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen1_1
        sta $10
        lda #>screen1_1
        sta $11

@NameLoop3:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop3
        inc $11
        dex
        bne @NameLoop3
        lda #30
        sta $2001
        lda #0
        sta screen_no                         ;;;;;;;;;;;;;-------_________-------------
rts
screen4to2_1:
        lda #0
        sta $2001
        LDA #$28                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen2_1
        sta $10
        lda #>screen2_1
        sta $11

@NameLoop3:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop3
        inc $11
        dex
        bne @NameLoop3
        lda #30
        sta $2001
        lda #1
        sta screen_no                         ;;;;;;;;;;;;;-------_________-------------
rts

screen5to3_1:
         lda #0
        sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen3_1
        sta $10
        lda #>screen3_1
        sta $11

@NameLoop3:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop3
        inc $11
        dex
        bne @NameLoop3
        lda #30
        sta $2001
        lda #2
        sta screen_no                         ;;;;;;;;;;;;;-------_________-------------
rts

screen6to4_1:
        lda #0
        sta $2001
        LDA #$28                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen4_1
        sta $10
        lda #>screen4_1
        sta $11

@NameLoop3:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop3
        inc $11
        dex
        bne @NameLoop3
        lda #30
        sta $2001
        lda #3
        sta screen_no                         ;;;;;;;;;;;;;-------_________-------------
rts

screen7to5_1:
         lda #0
        sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen5_1
        sta $10
        lda #>screen5_1
        sta $11

@NameLoop3:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop3
        inc $11
        dex
        bne @NameLoop3
        lda #30
        sta $2001
        lda #4
        sta screen_no                         ;;;;;;;;;;;;;-------_________-------------
rts

screen8to6_1:
        lda #0
        sta $2001
        LDA #$28                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen6_1
        sta $10
        lda #>screen6_1
        sta $11

@NameLoop3:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop3
        inc $11
        dex
        bne @NameLoop3
        lda #30
        sta $2001
        lda #5
        sta screen_no                         ;;;;;;;;;;;;;-------_________-------------
rts



more240_1:
         lda screen_no
         cmp #1
         bne @not12
         jsr screen3to1_1
@not11    lda #0
         sta scroll_v
         lda #2
         eor ppucntl
         sta ppucntl
         sta $2000
         jmp @not1
@not12    cmp #2
         bne @not1r
         jsr screen4to2_1
         jmp @not11
@not1r    cmp #3
         bne @not1e
         jsr screen5to3_1
         jmp @not11
@not1e    cmp #4
         bne @not1p
         jsr screen6to4_1
         jmp @not11          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@not1p    cmp #5
         bne @not1d
         jsr screen7to5_1
         jmp @not11
@not1d    cmp #6
         bne @not1f
         jsr screen8to6_1
         jmp @not11
@not1f    cmp #7
         bne @not1g
;         jsr screen9to7_1
         jmp @not11
@not1g    cmp #8
         bne @not1
 ;        jsr screen10to8_1
         jmp @not11
@not1     rts


;;;;when scroll_step is set with x-pixels and then triggering it with the variable scrollup_act cause the background to move up by x-bixels ...this is basically called
;;when a negative or a bad object gets detected

scrollup_1:
         lda scrollup_act
         cmp #10
         bne @end_s1
         lda #0
         sta touch_trig
         lda scroll_v
         cmp #239
         bne @dwn1
         lda screen_no
         cmp #0
         bne @dwn2
         lda #0
         sta scrollup_act
         rts
@dwn2     jsr more240_1
@end_s1:
        lda #1
         sta touch_trig
         rts

@dwn1     dec scroll_step
         lda scroll_step
         cmp #0
         bne @next2
         lda #0
         sta scrollup_act
         lda #22
         sta scroll_step
@next2    inc scroll_v
         rts
         ;       ----------------------------------------------------
screen1to3_1:
        lda #0
        sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen3_1
        sta $10
        lda #>screen3_1
        sta $11

@NameLoop3:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop3
        inc $11
        dex
        bne @NameLoop3
        lda #30
        sta $2001
        lda #1
        sta screen_no                         ;;;;;;;;;;;;;-------_________-------------
rts
screen2to4_1:
                lda #0
        sta $2001
        LDA #$28                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen4_1
        sta $10
        lda #>screen4_1
        sta $11

@NameLoop3:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop3
        inc $11
        dex
        bne @NameLoop3
        lda #30
        sta $2001
        lda #2
        sta screen_no                         ;;;;;;;;;;;;;-------_________-------------
rts
screen3to5_1:
        lda #0
        sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen5_1
        sta $10
        lda #>screen5_1
        sta $11

@NameLoop3:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop3
        inc $11
        dex
        bne @NameLoop3
        lda #30
        sta $2001
        lda #3
        sta screen_no                         ;;;;;;;;;;;;;-------_________-------------
rts

screen4to6_1:
        lda #0
        sta $2001
        LDA #$28                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen6_1
        sta $10
        lda #>screen6_1
        sta $11

@NameLoop3:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop3
        inc $11
        dex
        bne @NameLoop3
        lda #30
        sta $2001
        lda #4
        sta screen_no                         ;;;;;;;;;;;;;-------_________-------------
rts

screen5to7_1:
        lda #0
        sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen7_1
        sta $10
        lda #>screen7_1
        sta $11

@NameLoop3:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop3
        inc $11
        dex
        bne @NameLoop3
        lda #30
        sta $2001
        lda #5
        sta screen_no                         ;;;;;;;;;;;;;-------_________-------------
rts

screen6to8_1:
        lda #0
        sta $2001
        LDA #$28                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen7_1
        sta $10
        lda #>screen7_1
        sta $11

@NameLoop3:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop3
        inc $11
        dex
        bne @NameLoop3
        lda #30
        sta $2001
        lda #6
        sta screen_no                         ;;;;;;;;;;;;;-------_________-------------
rts




less0_1:
        lda screen_no
        cmp #0
        bne @dwn6
        jsr screen1to3_1
@dwn18   lda #239
        sta scroll_v
        lda #2
        eor ppucntl
        sta ppucntl
        sta $2000
        jmp @dwn17
@dwn6    cmp #1
        bne @dwn19
        jsr screen2to4_1
        jmp @dwn18
@dwn19   cmp #2
        bne @dwn171
        jsr screen3to5_1
        jmp @dwn18
@dwn171  cmp #3
        bne @dwn172
        jsr screen4to6_1
        jmp @dwn18
@dwn172  cmp #4
        bne @dwn17r
        jsr screen5to7_1
        jmp @dwn18
@dwn17r  cmp #5
        bne @dwn17b
        jsr screen6to8_1
        jmp @dwn18
@dwn17b  cmp #16
        bne @dwn17c
;        jsr screen7to9_1
        jmp @dwn18
@dwn17c  cmp #7
        bne @dwn17
 ;       jsr screen8to10_1
        jmp @dwn18
@dwn17
         rts

 ;;;;when scroll_step is set with x-pixels and then triggering it with the variable scrolldown_act cause the background to move down by x-bixels ...this is basically called
;;when a postive or a good object gets detected
scrolldown_1:
           lda scrolldown_act
           cmp #10
           bne @end_s2
   ;      dec scroll_v
          lda #0
         sta touch_trig
         lda scroll_v
         cmp #0
         bne @dwn4
         lda screen_no
         cmp #6
         bne @dwn5
         lda #0
         sta scrolldown_act
         jsr clear_hanuman

         jsr @endscreenload
         LDA #%00001110
	 STA $2001
	 lda #0
         sta trig_controller1


@end_s2:
         rts
@dwn5     jsr less0_1
          lda #1
          sta touch_trig
         rts
@dwn4     dec scroll_step
         lda scroll_step
         cmp #0
         bne @nex1
         lda #0
         sta scrolldown_act
         lda #22
         sta scroll_step
@nex1     dec scroll_v
         rts


@endscreenload:
         lda #10
         sta credit_enable
         sta random_enable
         jsr clear_hanuman
       jsr pal_changeforquestion
         LDA #$02
        JSR setCHRPage0000
       lda #0
       sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<pic1
        sta $10
        lda #>pic1
        sta $11

@NameLoop211:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop211
        inc $11
        dex
        bne @NameLoop211
        lda #30
        sta $2001
rts
;        --------------------------------------------------------------

;;;;;;; Load screen3 out of three
screenchange11_1:
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen2_1
        sta $10
        lda #>screen2_1
        sta $11

@NameLoop211:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop211
        inc $11
        dex
        bne @NameLoop211
rts
;  ------------------------------------------------------------
triggering_scroll_1:
                  lda go0                        ; checking good object detection
                  cmp #1
                  bne @tri_scr1
                  lda #10
                  sta scrolldown_act
                  lda #30
                  sta scroll_step
                  lda #0
                  sta go0
@tri_scr1:
                  lda bo0                        ; checking bad object detection
                  cmp #1
                  bne @tri_scr2
                  lda #10
                  sta scrollup_act
                  lda #scro
                  sta scroll_step
                  lda #0
                  sta bo0
@tri_scr2:
                  lda cq0                       ;  correct answer detection
                  cmp #1
                  bne @tri_scr3
                  lda #10
                  sta scrolldown_act
                  lda #140
                  sta scroll_step
                  lda #0
                  sta cq0

                 lda #0
                 sta sk1
@incpoint:
                 lda points
                 cmp #5
                 beq @newlll
                 inc points
                 inc sk1       ; sk1 is counter for skull
                 cmp #3
                 bne @incpoint
                 rts

@newlll:
                ; jmp @newl
                 rts




@tri_scr3:
                  lda icq0                       ;  incorrect answer detection
                  cmp #1
                  bne @tri_scr4
                  lda #0
                  sta scrollup_act
                  lda #0
                  sta scroll_step
                  lda #0
                  sta icq0

                   lda #0
                   sta sk1

@decpoint:
                   lda points
                   cmp #0
                   beq @newllle
                   dec points
                   inc sk1       ; sk1 is counter for skull
                   cmp #3
                   bne @decpoint
                   rts

@newllle:
                ;   jmp @newle
                   rts

@tri_scr4:
         rts
;        ------------------------------------------------------------------------------------------
question1_1:
          .db 'W','H','A','T',$06,'I','S',$06,'T','H','E',$06,'C','A','P','I','T','A','L'
          .db 'C','I','T','Y',$06,'O','F',$06,'A','U','S','T','R','A','L','I','A',$06,$5B
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'C','A','N','B','E','R','R','A',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'P','E','R','T','H',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'S','Y','D','N','E','Y',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'A','U','C','K','L','A','N','D',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
question2_1:
          .db 'W','H','A','T',$06,'D','O',$06,'W','E',$06,'C','A','L','L',$06,'T','H','E'
          .db 'R','A','I','N',$06,'T','H','A','T',$06,'C','O','N','T','A','I','N',$06,$06
          .db 'C','H','E','M','I','C','A','L',$06,'W','A','S','T','E',$06,$5B,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'S','M','O','G',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'A','C','I','D',$06,'R','A','I','N',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'M','O','N','S','O','O','N',$06,'R','A','I','N',$06,$06,$06,$06,$06,$06,$06
          .db 'S','E','A','S','O','N','A','L',$06,'R','A','I','N',$06,$06,$06,$06,$06,$06

question3_1:
          .db 'W','H','I','C','H',$06,'I','S',$06,'T','H','E',$06,$06,$06,$06,$06,$06,$06
          .db 'C','O','L','D','E','S','T',$06,'P','L','A','C','E',$06,'O','N',$06,$06,$06
          .db 'E','A','R','T','H',$06,$5B,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'A','N','T','A','R','T','I','C','A',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'A','R','C','T','I','C',$06,'C','I','R','C','L','E',$06,$06,$06,$06,$06,$06
          .db 'G','R','E','E','N','L','A','N','D',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'M','T',$6E,'E','V','E','R','E','S','T',$06,$06,$06,$06,$06,$06,$06,$06,$06

question4_1:
          .db 'W','H','I','C','H',$06,'F','E','S','T','I','V','A','L',$06,'I','S',$06,$06
          .db 'A','L','S','O',$06,'C','A','L','L','E','D',$06,'T','H','E',$06,$06,$06,$06
          .db 'F','E','S','T','V','A','L',$06,'O','F',$06,'L','I','G','H','T','S',$06,$5B
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'O','N','A','M',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'D','U','S','S','E','H','R','A',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'D','E','E','P','A','W','A','L','I',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'H','O','L','I',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06

question5_1:
          .db 'K','O','L','K','U','T','T','A',$06,'S','T','A','N','D','S',$06,'O','N',$06
          .db 'W','H','I','C','H',$06,'C','H','A','N','N','E','L',$06,'O','F',$06,$06,$06
          .db 'R','I','V','E','R',$06,'G','A','N','G','A',$06,$5B,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'T','E','E','S','T','A',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'B','R','A','H','M','A','P','U','T','R','A',$06,$06,$06,$06,$06,$06,$06,$06
          .db 'Y','A','M','U','N','A',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'H','O','O','G','H','L','Y',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
question6_1:
          .db 'T','H','E',$06,'L','A','Y','E','R',$06,'T','H','A','T',$06,$06,$06,$06,$06
          .db 'P','R','O','T','E','C','T','S',$06,'T','H','E',$06,'E','A','R','T','H',$06
          .db 'F','R','O','M',$06,'U','V',$06,'R','A','D','I','A','T','O','N',$06,'I','S'
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'O','Z','O','N','E',$06,'L','A','Y','E','R',$06,$06,$06,$06,$06,$06,$06,$06
          .db 'N','I','T','R','O','G','E','N',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'M','E','T','H','A','N','E',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'M','A','G','N','E','S','I','U','M',$06,'O','X','I','D','E',$06,$06,$06,$06

question7_1:
          .db 'W','H','I','C','H',$06,'I','S',$06,'T','H','E',$06,$06,$06,$06,$06,$06,$06
          .db 'M','I','S','S','I','N','G',$06,'N','U','M','B','E','R',$06,$06,$06,$06,$06
          .db '1','3','5',$06,'9',$6E,$6E,$6E,$6E,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db '7',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db '6',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db '8',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db '1','1',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06

question8_1:
          .db 'W','H','E','N',$06,'D','I','D',$06,'I','N','D','I','A',$06,$06,$06,$06,$06
          .db 'A','D','O','P','T','E','D',$06,'I','T','S',$06,$06,$06,$06,$06,$06,$06,$06
          .db 'C','O','N','S','T','I','T','U','T','I','O','N',$06,$5B,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'A','U','G','U','S','T',$06,'1','5',$6F,'1','9','4','7',$06,$06,$06,$06,$06
          .db 'F','E','B','U','R','A','R','Y',$06,'2','0',$6F,'1','9','4','7',$06,$06,$06
          .db 'J','A','N','U','A','R','Y',$06,'2','6',$6F,'1','9','5','0',$06,$06,$06,$06
          .db 'D','E','C','E','M','B','E','R',$06,'9',$6F,'1','9','4','6',$06,$06,$06,$06

question9_1:
          .db 'L','U','N','E','R',$06,'E','C','L','I','P','S','E',$06,'I','S',$06,$06,$06
          .db 'C','A','U','S','E','D',$06,'B','Y',$06,'T','H','E',$06,$5B,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'S','U','N',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'M','O','O','N',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'M','A','R','S',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'V','E','N','U','S',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
question10_1:
          .db 'W','H','O',$06,'I','N','V','E','N','T','E','D',$06,$06,$06,$06,$06,$06,$06
          .db 'G','R','A','M','A','P','H','O','N','E',$06,$5B,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'T','H','O','M','A','S',$06,'A','L','V','A',$06,'E','D','I','S','I','O','N'
          .db 'M','I','C','H','E','A','L',$06,'F','A','R','A','D','A','Y',$06,$06,$06,$06
          .db 'F','A','H','R','E','N','H','E','I','T',$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'A','L','E','X','A','N','D','E','R',$06,'G','R','A','H','A','M','B','E','L'

question11_1:
          .db 'W','H','O',$06,'S','C','O','R','E','D',$06,'2','0','0',$06,'R','U','N','S'
          .db 'I','N',$06,'O','N','E',$06,'D','A','Y',$06,'C','R','I','C','K','E','T',$5B ;32
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'S','A','C','H','I','N',$06,'T','E','N','D','U','L','K','A','R',$06,$06,$06
          .db 'R','I','C','K','Y',$06,'P','O','N','T','I','N','G',$06,$06,$06,$06,$06,$06
          .db 'V','I','R','E','N','D','R','A',$06,'S','E','H','W','A','G',$06,$06,$06,$06
          .db 'Y','U','V','R','A','J',$06,'S','I','N','G','H',$06,$06,$06,$06,$06,$06,$06
question12_1:
          .db 'T','H','E',$06,'E','L','E','P','H','A','N','T',$06,'S','O','U','N','D',$06
          .db 'I','S',$06,'C','A','L','L','E','D',$06,$5B,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'Y','E','L','P',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'T','R','U','M','P','E','T',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'G','R','U','N','T',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'C','L','I','C','K',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06

question13_1:
          .db 'I','F',$06,'F','A','C','I','N','G',$06,'N','O','R','T','H',$06,'I',$06,$06
          .db 'T','U','R','N',$06,'1','8','0',$06,'T','H','E','N',$06,'W','H','I','C','H'
          .db 'D','I','R','E','C','T','I','O',$06,'I',$06,'A','M',$06,'O','N',$06,$5B,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'S','O','U','T','H',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'N','O','R','T','H',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'E','A','S','T',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'W','E','S','T',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
question14_1:
          .db 'W','H','O',$06,'D','E','S','I','G','N','E','D',$06,'T','H','E',$06,$06,$06
          .db 'F','I','R','S','T',$06,'E','F','F','I','C','I','E','N','T',$06,$06,$06,$06
          .db 'S','T','E','A','M',$06,'E','N','G','I','N','E',$06,$5B,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'T','H','O','M','A','S',$06,'N','E','W','W','M','E','N',$06,$06,$06,$06,$06
          .db 'J','A','M','E','S',$06,'W','A','T','T',$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'J','O','S','E','P','H',$06,'C','U','G','N','O','T',$06,$06,$06,$06,$06,$06
          .db 'S','A','M','U','E','L',$06,'C','R','O','M','P','T','O','N',$06,$06,$06,$06

question15_1:
          .db 'A','N',$06,'I','N','S','T','R','U','M','E','N','T',$06,'T','O',$06,$06,$06
          .db 'M','E','A','S','U','R','E',$06,'T','E','M','P','E','R','A','T','U','R','E'
          .db 'I','S',$06,'C','A','L','L','E','D',$06,$5B,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'H','Y','D','R','O','M','E','T','E','R',$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'T','H','E','R','M','O','M','E','T','E','R',$06,$06,$06,$06,$06,$06,$06,$06
          .db 'G','Y','R','O','M','E','T','E','R',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'T','E','M','P','O','M','E','T','E','R',$06,$06,$06,$06,$06,$06,$06,$06,$06

;         ---------------------------------------------------------------------------------------------
answers_1:
.db  #142 , #158  , #142 , #174, #190 , #142  , #142 , #174, #158 , #142, #142 , #158, #142 , #158  , #158 , #174, #190 , #142  , #142 , #174, #158 , #142, #142
;    ---------------------------------------------------------------------------------------------------




screen1_1:
        .incbin "pic33.nam"
screen8_1:
screen5_1:
screen2_1:
        .incbin "pic11.nam"
    screen7_1 :
screen4_1:
        .incbin "pic00.nam"

screen6_1
screen3_1:
       .incbin "pic22.nam"
;screen7_1
;screen4_1:
 ;       .incbin "pic00.nam"

;screen5_1:
;      ;  .incbin "screen5.nam"

;screen6_1:
       ; .incbin "screen6.nam"

;screen7_1:
        ;.incbin "screen7.nam"

;screen8_1:
        ;.incbin "screen8.nam"

screen9_1:
        ;.incbin "screen9.nam"

screen10_1:
       ; .incbin "screen10.nam"