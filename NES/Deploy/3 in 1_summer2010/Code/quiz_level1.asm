

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


load_sprites:

                  lda trig_disp_level1
                    cmp #1
                    bne rtt

                INC smc1
                lda smc1
                CMP #15
                BNE rtt
                lda #0
                sta smc1


 jk :lda duf
     cmp #0
     bne jk1
     lda #$A2     ;;;L
     sta $5A1

     lda #1
     sta duf
rtt:     rts

 jk1: lda duf
     cmp #1
     bne jk2
      lda #$B2     ;;;E
      sta $5A5

     lda #2
     sta duf
     rts

 jk2:lda duf
     cmp #2
     bne jk3
     lda #$A3     ;;;V
     sta $5A9

     lda #3
     sta duf
     rts

  jk3:lda duf
     cmp #3
     bne jk4
     lda #$B2    ;;;E
     sta $5AD
     lda #4
     sta duf
     rts

  jk4:lda duf
     cmp #4
     bne jk5
     lda #$A2    ;;;L
     sta $5B1
     lda #5
     sta duf
     rts

  jk5:lda duf
     cmp #5
     bne jk6
     lda #$32    ;;;1
     sta $5B5
     lda #6
     sta duf
     rts
     
     
  jk6:lda duf
      cmp #6
      bne jk7

      lda #7
      sta duf
      rts

  jk7:lda duf
      cmp #7
      bne jk8

      lda #8
      sta duf
      rts

  jk8:lda duf
      cmp #8
      bne jk9

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



  jk9:lda duf
      cmp #9
      bne jk10

      lda #10
      sta duf
      rts

 jk10:
      lda #47
      sta level1_complete
      
           ;  LDA #$01
           ;  JSR setCHRPage0000
           ;  LDA #$03
           ;  JSR setCHRPage1000

  rtt1:    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;this subroutine is called when a question mark is touched  by hanuman  ..... it loads the question screen .....it disables the mainscreen controller and 
;; initialises the questionscreen variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Questionscreen:
lda #0
          sta go0
          sta go
          sta scrolldown_act
          sta scrollup_act
          sta scro
          sta scroll_step
;LDA #$13
;JSR setCHRPage1000
 ;       ldx  #0
;back    lda $500 , x
;        sta $600 , x
;        inx
;        txa
;        bne back
         inc Qcount
         lda Qcount
         cmp #23
         bne kjj
         lda #0
         sta Qcount
         lda #1
         sta trig_que

  kjj:   lda #0
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

@back1   lda sprite ,x            ;;;loading of sprites
        sta $600, x
        inx
        txa
        cmp #4
        bne @back1

        jsr ClearSprites11
        jsr update_sprites11

        lda #10
        sta scroll_change
        ;jsr pallatechange
        lda #%00000000
        sta $2001
        jsr @Q44


        jsr update_sprites11
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


;jsr ClearSprites11
 ;lda #142
;sta $600


;jsr update_sprites11

        ;lda #$1E
        ;sta $6DC
        ;jsr update_sprites11
        
        


 rts

 @Q44:
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

  ;.................................................................................................................................................
;.........................................................................................................................................................
;.........................................................................................................................................................
;;; Controller for Question screen......
;;; selecting the options is done over here
;;;and after selceting if the answer is right then execution moves to @corr otherwise @inncorrect1
newcontroller:
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
	BEQ @newCheckA


;@newCheckRight:
;	LDA #%10000000
;	AND buttons
;	BEQ @newCheckB

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

;@newCheckB:
        ;lda wrongans
        ;cmp #10
        ;beq @newCheckA
;	LDA #%00000010
;	AND buttons
;	BEQ @newCheckA



@newCheckA:
           LDA #%00000001
	AND buttons
	BEQ @newCheckOver

         ldy question_count
        ; lda #80
        lda answers,y
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
             ;LDA #$13
             ;JSR setCHRPage1000
            ;jsr LoadSprites55
            jsr load_incorrect
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
         ;jsr LoadSprites55
         ;jsr Loadwrong
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
screenchange5:
   	LDA #$20                ; set to beginning of first nametable
    	STA $2006
    	LDA #$00
    	STA $2006
        LDA #<screen6              ; load low byte of first picture
        STA $10
        LDA #>screen6              ; load high byte of first picture
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

screenchange7:
   	LDA #$20                ; set to beginning of first nametable
    	STA $2006
    	LDA #$00
    	STA $2006
        LDA #<screen7              ; load low byte of first picture
        STA $10
        LDA #>screen7              ; load high byte of first picture
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

screenchange9:
   	LDA #$20                ; set to beginning of first nametable
    	STA $2006
    	LDA #$00
    	STA $2006
        LDA #<screen9              ; load low byte of first picture
        STA $10
        LDA #>screen9              ; load high byte of first picture
        STA $11
        LDY #$00
        LDX #$04
@NameLoop221    LDA ($10),y
              STA $2007
              INY
              BNE @NameLoop221
              INC $11
              DEX
              BNE @NameLoop221
              lda ppucntl
              sta $2000
rts


Q44:
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

background:
           lda new_qst
           cmp #1
           bne @srt_qs
           jsr background__
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

                    LDA question1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start

                    LDA question2, y
                    ldx question_no
                    cpx #1
                    beq @start

                    LDA question3, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start

                    LDA question4, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start

                    LDA question5, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start

                    LDA question6, y
                    ldx question_no
                    cpx #5
                    beq @start

                    LDA question7, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start

                    LDA question8, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start

                    LDA question9, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start

                    LDA question10, y
                    ldx question_no
                    cpx #9
                    beq @start
                    
                    lda #1
                    sta new_qst
                    LDA question11, y              ; load data from address (background + the value in x)
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

                    LDA question1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start1

                    LDA question2, y
                    ldx question_no
                    cpx #1
                    beq @start1

                    LDA question3, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start1

                    LDA question4, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start1

                    LDA question5, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start1

                    LDA question6, y
                    ldx question_no
                    cpx #5
                    beq @start1

                    LDA question7, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start1

                    LDA question8, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start1

                    LDA question9, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start1

                    LDA question10, y
                    ldx question_no
                    cpx #9
                    beq @start1

                    LDA question11, y              ; load data from address (background + the value in x)
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

                    LDA question1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start2

                    LDA question2, y
                    ldx question_no
                    cpx #1
                    beq @start2

                    LDA question3, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start2

                    LDA question4, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start2

                    LDA question5, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start2

                    LDA question6, y
                    ldx question_no
                    cpx #5
                    beq @start2

                    LDA question7, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start2

                    LDA question8, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start2

                    LDA question9, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start2

                    LDA question10, y
                    ldx question_no
                    cpx #9
                    beq @start2

                    LDA question11, y              ; load data from address (background + the value in x)
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
background1:
            lda new_qst1
            cmp #1
            bne @srt_qs1
            jsr background1__
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

                    LDA question1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start91

                    LDA question2, y
                    ldx question_no
                    cpx #1
                    beq @start91

                    LDA question3, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start91

                    LDA question4, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start91

                    LDA question5, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start91

                    LDA question6, y
                    ldx question_no
                    cpx #5
                    beq @start91

                    LDA question7, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start91

                    LDA question8, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start91

                    LDA question9, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start91

                    LDA question10, y
                    ldx question_no
                    cpx #9
                    beq @start91

                    LDA #1
                    STA new_qst1
                    LDA question11, y              ; load data from address (background + the value in x)
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

                    LDA question1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start9

                    LDA question2, y
                    ldx question_no
                    cpx #1
                    beq @start9

                    LDA question3, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start9

                    LDA question4, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start9

                    LDA question5, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start9

                    LDA question6, y
                    ldx question_no
                    cpx #5
                    beq @start9

                    LDA question7, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start9

                    LDA question8, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start9

                    LDA question9, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start9

                    LDA question10, y
                    ldx question_no
                    cpx #9
                    beq @start9

                    LDA question11, y              ; load data from address (background + the value in x)
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

                    LDA question1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start8

                    LDA question2, y
                    ldx question_no
                    cpx #1
                    beq @start8

                    LDA question3, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start8

                    LDA question4, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start8

                    LDA question5, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start8

                    LDA question6, y
                    ldx question_no
                    cpx #5
                    beq @start8

                    LDA question7, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start8

                    LDA question8, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start8

                    LDA question9, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start8

                    LDA question10, y
                    ldx question_no
                    cpx #9
                    beq @start8

                    LDA question11, y              ; load data from address (background + the value in x)
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

                    LDA question1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start7

                    LDA question2, y
                    ldx question_no
                    cpx #1
                    beq @start7

                    LDA question3, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start7

                    LDA question4, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start7

                    LDA question5, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start7

                    LDA question6, y
                    ldx question_no
                    cpx #5
                    beq @start7

                    LDA question7, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start7

                    LDA question8, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start7

                    LDA question9, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start7

                    LDA question10, y
                    ldx question_no
                    cpx #9
                    beq @start7

                    LDA question11, y              ; load data from address (background + the value in x)
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

                    LDA question1, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #0
                    beq @start6

                    LDA question2, y
                    ldx question_no
                    cpx #1
                    beq @start6

                    LDA question3, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #2
                    beq @start6

                    LDA question4, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #3
                    beq @start6

                    LDA question5, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #4
                    beq @start6

                    LDA question6, y
                    ldx question_no
                    cpx #5
                    beq @start6

                    LDA question7, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #6
                    beq @start6

                    LDA question8, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #7
                    beq @start6

                    LDA question9, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #8
                    beq @start6

                    LDA question10, y
                    ldx question_no
                    cpx #9
                    beq @start6

                    LDA question11, y              ; load data from address (background + the value in x)
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
background__:
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

                    LDA question12, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start

                    LDA question13, y
                    ldx question_no
                    cpx #12
                    beq @start

                    LDA question14, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start

                    LDA question15, y              ; load data from address (background + the value in x)
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

                    LDA question12, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start1

                    LDA question13, y
                    ldx question_no
                    cpx #12
                    beq @start1

                    LDA question14, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start1

                    LDA question15, y              ; load data from address (background + the value in x)
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

                    LDA question12, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start2

                    LDA question13, y
                    ldx question_no
                    cpx #12
                    beq @start2

                    LDA question14, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start2

                    LDA question15, y              ; load data from address (background + the value in x)
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
background1__:
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

                    LDA question12, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start91

                    LDA question13, y
                    ldx question_no
                    cpx #12
                    beq @start91

                    LDA question14, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start91

                    LDA question15, y              ; load data from address (background + the value in x)
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

                    LDA question12, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start9

                    LDA question13, y
                    ldx question_no
                    cpx #12
                    beq @start9

                    LDA question14, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start9

                    LDA question15, y              ; load data from address (background + the value in x)
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

                    LDA question12, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start8

                    LDA question13, y
                    ldx question_no
                    cpx #12
                    beq @start8

                    LDA question14, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start8

                    LDA question15, y              ; load data from address (background + the value in x)
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

                    LDA question12, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start7

                    LDA question13, y
                    ldx question_no
                    cpx #12
                    beq @start7

                    LDA question14, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start7

                    LDA question15, y              ; load data from address (background + the value in x)
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

                    LDA question12, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #11
                    beq @start6

                    LDA question13, y
                    ldx question_no
                    cpx #12
                    beq @start6

                    LDA question14, y              ; load data from address (background + the value in x)
                    ldx question_no
                    cpx #13
                    beq @start6

                    LDA question15, y              ; load data from address (background + the value in x)
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
;;;;         -----------------------------------------
delay_cal2:
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
          jsr ClearSprites11
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
;        loading the screen after giving incorrect answer
@incorrect1:
           ;lda #0
           ;sta wrongans
           lda #80
           sta delay
           lda #1
           STA icq0
back_to_gamet:
           inc question_count
           jsr palchange
           LDA #$01
           JSR setCHRPage0000
           LDA #$03
           JSR setCHRPage1000
           lda #0
           sta $2001
           sta scroll_change

             lda screen_no
             cmp #0
@abv1         bne @nex15       
             jsr mainscreen1
             jmp @nex13
@nex15        cmp #1
             bne @nex14
@nex16        jsr screenchange11
             jmp @nex17
@nex14        cmp #2
             bne @nex17
             jmp @nex16
@nex17       cmp #3
             bne @nex18
@nex19       jsr screenchange5
             jmp @nex20
@nex18       cmp #4
             bne @nex20
             jmp @nex19
@nex20       cmp #5
             bne @nex21
@nex22       jsr screenchange7
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
@nex13 :
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
          ; sta icq0
           sta cbb
           sta trig_controller1
           rts
   mainscreen1:
   	LDA #$20                ; set to beginning of first nametable
    	STA $2006
    	LDA #$00
    	STA $2006
        LDA #<screen1              ; load low byte of first picture
        STA $10
        LDA #>screen1              ; load high byte of first picture
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

;       -----------------------------------------------------------------------
delay_cal:
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
          lda #1
          STA cq0
          jsr ClearSprites11
          lda #10
          sta scrolldown_act
          ;sta scrollup_act
          ;sta scro
          lda #180
          sta scroll_step
          jmp back_to_gamet
@end123: rts;-------------------------------------------------------------------
@back_to_game:
             inc question_count
             jsr palchange
             LDA #$01
             JSR setCHRPage0000
             LDA #$03
             JSR setCHRPage1000
             lda #0
             sta $2001
             sta scroll_change
             lda screen_no
             cmp #0
@abv1         bne @nex15       
             jsr mainscreen1
             jmp @nex13
@nex15        cmp #1
             bne @nex14
@nex16        jsr screenchange11
             jmp @nex17
@nex14        cmp #2
             bne @nex17
             jmp @nex16
@nex17       cmp #3
             bne @nex18
@nex19       jsr screenchange5
             jmp @nex20
@nex18       cmp #4
             bne @nex20
             jmp @nex19
@nex20       cmp #5
             bne @nex21
@nex22       jsr screenchange7
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


screen3to1:
        lda #0
        sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen1
        sta $10
        lda #>screen1
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
screen4to2:
        lda #0
        sta $2001
        LDA #$28                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen2
        sta $10
        lda #>screen2
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

screen5to3:
         lda #0
        sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen2
        sta $10
        lda #>screen2
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

screen6to4:
        lda #0
        sta $2001
        LDA #$28                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen4
        sta $10
        lda #>screen4
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

screen7to5:
         lda #0
        sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen6
        sta $10
        lda #>screen6
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

screen8to6:
        lda #0
        sta $2001
        LDA #$28                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen7
        sta $10
        lda #>screen7
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

screen9to7:
         lda #0
        sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen7
        sta $10
        lda #>screen7
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

screen10to8:
        lda #0
        sta $2001
        LDA #$28                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen7
        sta $10
        lda #>screen7
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
        lda #7
        sta screen_no                         ;;;;;;;;;;;;;-------_________-------------
rts

more240:
         lda screen_no
         cmp #1
         bne @not12
         jsr screen3to1
@not11    lda #0
         sta scroll_v
         lda #2
         eor ppucntl
         sta ppucntl
         sta $2000
         jmp @not1
@not12    cmp #2
         bne @not1r
         jsr screen4to2
         jmp @not11
@not1r    cmp #3
         bne @not1e
         jsr screen5to3
         jmp @not11
@not1e    cmp #4
         bne @not1p
         jsr screen6to4
         jmp @not11          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@not1p    cmp #5
         bne @not1d
         jsr screen7to5
         jmp @not11
@not1d    cmp #6
         bne @not1f
         jsr screen8to6
         jmp @not11
@not1f    cmp #7
         bne @not1g
         jsr screen9to7
         jmp @not11
@not1g    cmp #8
         bne @not1
         jsr screen10to8
         jmp @not11
@not1     rts


;;;;when scroll_step is set with x-pixels and then triggering it with the variable scrollup_act cause the background to move up by x-bixels ...this is basically called
;;when a negative or a bad object gets detected
scrollup:
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
@dwn2     jsr more240
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
screen1to3:
        lda #0
        sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen2
        sta $10
        lda #>screen2
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
screen2to4:
                lda #0
        sta $2001
        LDA #$28                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen4
        sta $10
        lda #>screen4
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
screen3to5:
        lda #0
        sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen6
        sta $10
        lda #>screen6
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

screen4to6:
        lda #0
        sta $2001
        LDA #$28                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen7
        sta $10
        lda #>screen7
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

screen5to7:
        lda #0
        sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen7
        sta $10
        lda #>screen7
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

screen6to8:
        lda #0
        sta $2001
        LDA #$28                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen7
        sta $10
        lda #>screen7
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


screen7to9:
        lda #0
        sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen9
        sta $10
        lda #>screen9
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
        lda #7
        sta screen_no                         ;;;;;;;;;;;;;-------_________-------------
rts

screen8to10:
        lda #0
        sta $2001
        LDA #$28                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen10
        sta $10
        lda #>screen10
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
        lda #8
        sta screen_no                         ;;;;;;;;;;;;;-------_________-------------
rts



less0:
        lda screen_no
        cmp #0
        bne @dwn6
        jsr screen1to3
@dwn18   lda #239
        sta scroll_v
        lda #2
        eor ppucntl
        sta ppucntl
        sta $2000
        jmp @dwn17
@dwn6    cmp #1
        bne @dwn19
        jsr screen2to4
        jmp @dwn18
@dwn19   cmp #2
        bne @dwn171
        jsr screen3to5
        jmp @dwn18
@dwn171  cmp #3
        bne @dwn172
        jsr screen4to6
        jmp @dwn18
@dwn172  cmp #4
        bne @dwn17r
        jsr screen5to7
        jmp @dwn18
@dwn17r  cmp #5
        bne @dwn17b
        jsr screen6to8
        jmp @dwn18
@dwn17b  cmp #16
        bne @dwn17c
        jsr screen7to9
        jmp @dwn18
@dwn17c  cmp #7
        bne @dwn17
        jsr screen8to10
        jmp @dwn18
@dwn17   rts
;;;;when scroll_step is set with x-pixels and then triggering it with the variable scrolldown_act cause the background to move down by x-bixels ...this is basically called
;;when a postive or a good object gets detected
scrolldown:
           lda scrolldown_act
           cmp #10
           bne @end_s2
           jsr upmotion
   ;      dec scroll_v
          lda #0
         sta touch_trig
         lda scroll_v
         cmp #0
         bne @dwn4
         lda screen_no
         cmp #6
         bne @dwn5
     ;   lda #1
     ;   sta trig_endmotion
         lda #10
         sta level1_complete
         lda #0
         sta scrolldown_act

@end_s2:

         rts
@dwn5     jsr less0
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



;        --------------------------------------------------------------

;;;;;;; Load screen3 out of three
screenchange11:
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen2
        sta $10
        lda #>screen2
        sta $11

NameLoop211:
        lda ($10),y
        sta $2007
        iny
        bne NameLoop211
        inc $11
        dex
        bne NameLoop211
rts
;  ------------------------------------------------------------
triggering_scroll:
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
                  lda scro
                  sta scroll_step
                  lda #0
                  sta bo0
@tri_scr2:
                  lda cq0                       ;  correct answer detection
                  cmp #1
                  bne @newlll
                  lda #10
                  sta scrolldown_act
                  lda #150
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

;;---------------------------------------------------------------------------

;;       ---------------------------------------------------------------------------
question1:
          .db '2',$06,$6B,$06,'2',$06,$69,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db '4',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db '5',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db '2',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db '1',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
question2:
          .db '2',$06,$6A,$06,'2',$06,$69,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db '5',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db '4',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db '2',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db '1',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06

question3:
          .db 'W','H','A','T',$06,'I','S',$06,'T','H','E',$06,'C','O','L','O','R',$06,$06
          .db 'O','F',$06,'S','K','Y',$06,$5B,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'R','E','D',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'B','L','U','E',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'G','R','E','E','N',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'B','L','A','C','K',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06

question4:
          .db 'W','H','I','C','H',$06,'M','O','N','T','H',$06,'C','O','M','E','S',$06,$06
          .db 'A','F','T','E','R',$06,'M','A','Y',$06,$5B,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'A','U','G','U','S','T',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'F','E','B','R','U','A','R','Y',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'J','U','N','E',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'N','O','V','E','M','B','E','R',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06

question5:
          .db 'A','F','T','E','R',$06,'H','O','W',$06,'M','A','N','Y',$06,'Y','E','A','R'
          .db 'A',$06,'L','E','A','P',$06,'Y','E','A','R',$06,'C','O','M','E',$06,$5B,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'O','N','E',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'T','W','O',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'T','H','R','E','E',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'F','O','U','R',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
question6:
          .db 'W','H','I','C','H',$06,'A','N','I','M','A','L',$06,'I','S',$06,$06,$06,$06
          .db 'C','A','L','L','E','D',$06,'T','H','E',$06,'S','H','I','P',$06,'O','F',$06
          .db 'D','E','S','E','R','T',$06,$5B,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'C','A','M','E','L',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'L','I','O','N',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'T','I','G','E','R',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'D','O','G',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06

question7:
          .db 'S','U','N',$06,'R','I','S','E','S',$06,'F','R','O','M',$06,$06,$06,$06,$06
          .db 'W','H','I','C','H',$06,'D','I','R','E','C','T','I','O','N',$06,$5B,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'E','A','S','T',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'W','E','S','T',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'N','O','R','T','H',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'S','O','U','T','H',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06

question8:
          .db 'W','H','I','C','H',$06,'I','S',$06,'T','H','E',$06,$06,$06,$06,$06,$06,$06
          .db 'C','A','P','I','T','A','L',$06,'C','I','T','Y',$06,'O','F',$06,$06,$06,$06
          .db 'I','N','D','I','A',$06,$5B,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'M','U','M','B','A','Y',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'K','O','L','K','A','T','A',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'N','E','W',$06,'D','E','L','H','I',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'B','A','N','G','L','O','R','E',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06

question9:
          .db 'W','H','I','C','H',$06,'I','S',$06,'T','H','E',$06,$06,$06,$06,$06,$06,$06
          .db 'L','A','R','G','E','S','T',$06,'M','A','M','M','A','L',$06,$5B,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'E','L','E','P','H','A','N','T',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'B','L','U','E',$06,'W','H','A','L','E',$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'L','I','O','N',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'O','S','T','R','I','C','H',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
question10:
          .db 'P','O','P','E','Y',$06,'E','A','T',$06,'W','H','I','C','H',$06,$06,$06,$06
          .db 'V','E','G','E','T','A','B','L','E',$06,'T','O',$06,'G','E','T',$06,$06,$06
          .db 'S','T','R','E','N','G','T','H',$06,$5B,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'S','P','I','N','A','C','H',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'T','O','M','A','T','O',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'C','A','R','R','O','T',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'O','N','I','O','N',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06

question11:
          .db 'P','I','C','K',$06,'T','H','E',$06,'O','D','D',$06,'O','N','E',$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06 ;32
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'C','A','R',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'S','C','O','O','T','E','R',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'M','O','T','E','R',$06,'C','Y','C','L','E',$06,$06,$06,$06,$06,$06,$06,$06
          .db 'B','I','C','Y','C','L','E',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
question12:
          .db 'W','H','I','C','H',$06,'G','A','S',$06,'I','S',$06,'G','I','V','E','N',$06
          .db 'O','U','T',$06,'D','U','R','I','N','G',$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'P','H','O','T','O','S','Y','N','T','H','S','I','S',$06,$5B,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'C','A','R','B','O','N',$06,'D','I',$06,'O','X','I','D','E',$06,$06,$06,$06
          .db 'O','X','Y','G','E','N',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'N','I','T','R','O','G','E','N',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'H','Y','D','R','O','G','E','N',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06

question13:
          .db 'H','O','W',$06,'M','A','N','Y',$06,'P','L','A','Y','E','R','S',$06,$06,$06
          .db 'A','R','E',$06,'T','H','E','R','E',$06,'I','N',$06,'A',$06,$06,$06,$06,$06 ;32
          .db 'C','R','I','C','K','E','T',$06,'T','E','A','M',$06,$5b,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'E','L','E','V','E','N',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'T','E','N',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'N','I','N','E',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'N','O','N','E',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
question14:
          .db 'O','U','R',$06,'N','A','T','I','O','N','A','L',$06,'F','L','A','G',$06,$06
          .db 'H','A','S',$06,'H','O','W',$06,'M','A','N','Y',$06,$06,$06,$06,$06,$06,$06
          .db 'C','O','L','O','U','R','S',$06,$5B,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'O','N','E',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'T','H','R','E','E',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'F','O','U','R',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'T','W','O',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06

question15:
          .db 'W','H','I','C','H',$06,'L','I','G','H','T',$06,'S','I','G','N','A','L',$06
          .db 'P','R','O','H','I','B','I','T','S',$06,'M','O','V','E','M','E','N','T',$06
          .db 'O','F',$06,'T','R','A','F','F','I','C',$06,$5B,$06,$06,$06,$06,$06,$06,$06
          .db $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'G','R','E','E','N',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'R','E','D',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'Y','E','L','L','O','W',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06
          .db 'B','L','A','C','K',$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06


;         ---------------------------------------------------------------------------------------------
answers:
.db  #142 , #158  , #158 , #174, #190 , #142  , #142 , #174, #158 , #142, #142 , #158, #142 , #158  , #158 , #174, #190 , #142  , #142 , #174, #158 , #142, #142
;    ---------------------------------------------------------------------------------------------------

screen1:
        ;.incbin "screen1.nam"

screen2:
        .incbin "screen2.nam"


screen3:
     ;   .incbin "screen3.nam"

screen4:
        .incbin "screen4.nam"

;screen5:
        ;.incbin "screen5.nam"

screen6:
        .incbin "screen6.nam"

screen7:
        .incbin "screen7.nam"

screen8:
        ;.incbin "screen8.nam"

screen9:
        ;.incbin "screen9.nam"

screen10:
       ; .incbin "screen10.nam"