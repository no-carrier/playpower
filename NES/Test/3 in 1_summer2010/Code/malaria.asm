controller_test_malaria:

        lda mosquito_dead
        cmp #5
        bpl @oh
        jmp @dsp

    @oh: lda #10
	sta screen_change_trigger
	lda #0
	sta mosquito_dead


@dsp:	LDA buttons
	sta oldbuttons

        ldx #$00

        LDA #$01		; strobe joypad
	STA $4016
	LDA #$00
	STA $4016
@con_loop:
	LDA $4016		; check the state of each button
	LSR
	ROR buttons
        INX
        CPX #$08
        bne @con_loop

	LDA oldbuttons
	EOR #$FF
	AND buttons
	STA justpressed

@CheckUp:
	LDA #%00010000
	;AND justpressed
	AND buttons
        BEQ @CheckDown

        dec $514
        dec $518
        dec $51C
        dec $520



@CheckDown:
	LDA #%00100000
	;AND justpressed
	AND buttons
	BEQ @CheckLeft

        inc $514
        inc $518
        inc $51C
        inc $520





@CheckLeft:
	LDA #%01000000
	;AND justpressed
	AND buttons
	BEQ @CheckRight

        dec $517
        dec $51B
        dec $51F
        dec $523



@CheckRight:
	LDA #%10000000
	;AND justpressed
	AND buttons
	BEQ @CheckSel

        inc $517
        inc $51B
        inc $51F
        inc $523


@CheckSel:
	LDA #%00000100
	AND justpressed
	BEQ @CheckStart



@CheckStart
	LDA #%00001000
	AND justpressed
	BEQ @CheckB


@CheckB:
	LDA #%00000010
	AND justpressed
	BEQ @CheckA


@CheckA:
	LDA #%00000001
	AND justpressed
	BEQ @CheckOver


	lda #1
	sta tri



@CheckOver:
        RTS
        
palchange_mal:
       	LDX #0      ; load palette lookup value
        LDY #$00
        LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
LoadNewPal:                     ; load palette
        LDA Pall, x
        STA $2007
        INX
        INY
        CPY #$10
        BNE LoadNewPal
;        RTS
        lda #%00001110
        sta $2001
        lda ppucntl
        eor #%00000010
    ;    sta ppucntl
        sta $2000
        lda #0
        sta $2005
        sta $2005

        
        rts

        mainscreen1_mal:

   	LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

    ;    lda #<screen
        sta $10
    ;    lda #>screen
        sta $11

@NameLoop11:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop11
        inc $11
        dex
        bne @NameLoop11

rts
;       ----------------------------------------------------


pal_fordemo:
        lda #0
        sta $2001
        ldx #0
        ldy #0

       	LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
@load_pal12:                       ; load palette
        LDA pal_fordemo1,x
        sta $2007
        inx
        cpx #$20
        bne @load_pal12
        lda #30
        sta $2001

@brk2rts2  rts
demoscreen_load:

         lda screen_change_trigger
          cmp #10
          bne jh
          lda #21
          jsr setCHRPage0000



        jsr pal_fordemo
        lda #0
        sta $2001
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<demoscreen
        sta $10
        lda #>demoscreen
        sta $11

@NameLoop111:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop111
        inc $11
        dex
        bne @NameLoop111
        lda #%00001110
        sta $2001

        lda #0
        sta screen_change_trigger

  jh:     rts


frame1:    lda #$0C
           sta $515
           lda #$0D
           sta $519
           lda #$1C
           sta $51D
           lda #$1D
           sta $521
           rts

frame2:   lda #$20
           sta $515
           lda #$21
           sta $519
           lda #$30
           sta $51D
           lda #$31
           sta $521
           rts


frame3:  lda #$24
           sta $515
           lda #$25
           sta $519
           lda #$34
           sta $51D
           lda #$35
           sta $521
           rts


frame4: lda #$26
           sta $515
           lda #$27
           sta $519
           lda #$36
           sta $51D
           lda #$37
           sta $521
           rts

frame5:   lda #$06
           sta $515
           lda #$07
           sta $519
           lda #$16
           sta $51D
           lda #$17
           sta $521
           rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 racket_mos:

        lda tri
        cmp #1
        bne @gg2

        LDA rm1
        CMP #10
        BEQ @lv2
        inc rm1
        jsr frame1

        rts




   @lv2:lda #0
       sta rm1
       sta tri

          lda #$04
           sta $515
           lda #$01
           sta $519
           lda #$10
           sta $51D
           lda #$11
           sta $521

           lda #1
           sta pressA



  @gg2:     RTS
  
  
  random_gen_mal:
        ldx #10          ; generate 4 bytes
@loop:
        lda random44     ; random bit generator
        rol             ; written by kevtis
        rol             ; uses user input from joystick for initial values
        rol
        rol
        eor random44     ; this will XOR two bits together and put the answer in bit 7 of the acc
        rol             ; this puts the answer into the carry
        ror random11
        ror random22
        ror random33
        ;ror random44
        dex
        bne @loop
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
garbage_motion:
               INC varB
               lda varB
               CMP #5
               BNE @TP
               LDA #0
               STA varB

               lda varA
               cmp #0
               bne @ahd
               lda #$22
               sta $525
               sta $529
               lda #1
               sta varA
         @TP:   rts
          @ahd: lda #$12
               sta $525
               sta $529
               lda #0
               sta varA
               rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mos_motion:


               INC varM
               lda varM
               CMP #4
               BNE @TPM
               LDA #0
               STA varM

               lda varM1
               cmp #0
               bne @ahd1
               lda #$02
               ldx x1
               cpx #1
               beq @mov1
               sta $501
               ldx x2
               cpx #1
               beq @mov2
         @mov1: sta $505
                ldx x3
               cpx #1
               beq @mov3
         @mov2: sta $509
               ldx x4
               cpx #1
               beq @mov4
         @mov3: sta $50D
                ldx x5
               cpx #1
               beq @mov5
         @mov4: sta $511

         @mov5: lda #1
               sta varM1
         @TPM:   rts
          @ahd1: lda #$03
               ldx x1
               cpx #1
               beq @mov11
               sta $501
               ldx x2
               cpx #1
               beq @mov22
         @mov11: sta $505
                ldx x3
               cpx #1
               beq @mov33
         @mov22: sta $509
               ldx x4
               cpx #1
               beq @mov44
         @mov33: sta $50D
                ldx x5
               cpx #1
               beq @mov55
         @mov44: sta $511

         @mov55: lda #0
               sta varM1
               rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mos_1 : lda x1
        cmp #1
        beq @TP1

        inc $500
        dec $503

        lda $500
        cmp #$ff
        beq @as

    @TP1:   rts
     @as:   inc random44
           jsr random_gen_mal
           sta #$503
           rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mos_2 : lda x2
        cmp #1
        beq @TP2

        inc $507
        lda $507
        cmp #$ff
        beq @as1

   @TP2: rts
     @as1:   inc random44
           jsr random_gen_mal
           sta #$504
           rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mos_3 :
        lda x3
        cmp #1
        beq @TP3


        inc $508
        inc $50B
        lda $50B
        cmp #$ff
        beq @as2
        lda $508
        cmp #$ff
        beq @as2


    @TP3:   rts
     @as2:   inc random44
           jsr random_gen_mal
           sta #$508

           rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mos_4 : lda x4
        cmp #1
        beq @TP4

        dec $50C
        dec $50F
        lda $50F
        cmp #$ff
        beq @as3

    @TP4:   rts
     @as3:   inc random44
           jsr random_gen_mal
           sta #$50F

           rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mos_5 : lda x5
        cmp #1
        beq @TP5

        dec $510
        inc $513
        lda $513
        cmp #$ff
        beq @as4

    @TP5:    rts
     @as4:   inc random44
           jsr random_gen_mal
           sta #$510

           rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
increment_b:
               inc $52C
               inc $530
               inc $534
               inc $538
               inc $53C
               inc $540
               inc $544
               inc $548

               rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
decrement_b:
               dec $52C
               dec $530
               dec $534
               dec $538
               dec $53C
               dec $540
               dec $544
               dec $548
               rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 increment_g:
               inc $54C
               inc $550
               inc $554
               inc $558
               inc $55C
               inc $560
               inc $564
               inc $568

               rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
decrement_g:
               dec $54C
               dec $550
               dec $554
               dec $558
               dec $55C
               dec $560
               dec $564
               dec $568
               rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
update_boy:

           lda k
           cmp #0
           beq gpo1
           cmp #1
           beq gpo2
           cmp #2
           beq gpo3
           cmp #3
           beq gpo4


  gpo1:    lda k2
           cmp #80
           bne cng1
           lda #0
           sta k2
           lda #1
           sta k
           rts

       cng1:inc k2
            jsr load_b1
            rts



  gpo2:    lda k2
           cmp #250
           bne cng2

           lda #0
           sta k2
           lda #2
           sta k
           rts

    cng2:  inc k2
           jsr updateb_frnt
           rts


 gpo3:     lda k2
           cmp #80
           bne cng3
           lda #0
           sta k2
           lda #3
           sta k
           rts

       cng3:inc k2
            jsr load_b1
            rts



  gpo4:    lda k2
           cmp #250
           bne cng4

           lda #0
           sta k2
           lda #0
           sta k
           rts

    cng4:  inc k2
           jsr updateb_bk
           rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
update_girl:

           lda kg
           cmp #0
           beq g1
           cmp #1
           beq g2
           cmp #2
           beq g3
           cmp #3
           beq g4


  g1:    lda kg2
           cmp #80
           bne cg1
           lda #0
           sta kg2
           lda #1
           sta kg
           rts

       cg1:inc kg2
            jsr load_g1
            rts



  g2:      lda kg2
           cmp #250
           bne cg2

           lda #0
           sta kg2
           lda #2
           sta kg
           rts

    cg2:  inc kg2
           jsr updateg_bk
           rts


 g3:     lda kg2
           cmp #80
           bne cg3
           lda #0
           sta kg2
           lda #3
           sta kg
           rts

       cg3:inc kg2
            jsr load_g1
            rts



  g4:    lda kg2
           cmp #250
           bne cg4

           lda #0
           sta kg2
           lda #0
           sta kg
           rts

    cg4:  inc kg2
           jsr updateg_frnt
           rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updateb_frnt:

         INC k1
         lda k1
         CMP #10  ; 20 is the delay, increase/decrease to make it hit faster
         BNE fp
         LDA #$00
         STA k1

 
 LDA varZ1
        CMP #$00
        BNE L22
        jsr load_b2
       jsr increment_b
        LDA #$01
        STA varZ1
 fp:  RTS

L22:
        jsr load_b3
        jsr increment_b
        LDA varZ1
        LDA #$00
        STA varZ1

        RTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updateb_bk:

         INC k1
         lda k1
         CMP #10  ; 20 is the delay, increase/decrease to make it hit faster
         BNE bk
         LDA #$00
         STA k1


 LDA varZ2
        CMP #$00
        BNE L222
        jsr load_b4
        jsr decrement_b
        LDA #$01
        STA varZ2
bk:        RTS

L222:
        jsr load_b5
        jsr decrement_b
        LDA varZ2
        LDA #$00
        STA varZ2

        RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updateg_frnt:

         INC kg1
         lda kg1
         CMP #10  ; 20 is the delay, increase/decrease to make it hit faster
         BNE fpg
         LDA #$00
         STA kg1


 LDA varG1
        CMP #$00
        BNE L22g
        jsr load_g2
       jsr increment_g
        LDA #$01
        STA varG1
 fpg:  RTS

L22g:
        jsr load_g3
        jsr increment_g
        LDA varG1
        LDA #$00
        STA varG1

        RTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updateg_bk:

         INC kg1
         lda kg1
         CMP #10  ; 20 is the delay, increaseincreme/decrease to make it hit faster
         BNE bkg
         LDA #$00
         STA kg1


 LDA varG2
        CMP #$00
        BNE L2g
        jsr load_g4
        jsr decrement_g
        LDA #$01
        STA varG2
bkg:        RTS

L2g:
        jsr load_g5
        jsr decrement_g
        LDA varG2
        LDA #$00
        STA varG2

        RTS



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
load_b1:
        lda #$40
        sta $52D
        lda #$41
        sta $531
        lda #$50
        sta $535
        lda #$51
        sta $539
        lda #$60
        sta $53D
        lda #$61
        sta $541
        lda #$70
        sta $545
        lda #$71
        sta $549

        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
load_b2:
        lda #$40
        sta $52D
        lda #$41
        sta $531
        lda #$50
        sta $535
        lda #$51
        sta $539
        lda #$28
        sta $53D
        lda #$29
        sta $541
        lda #$38
        sta $545
        lda #$39
        sta $549

        rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
load_b3:
        lda #$40
        sta $52D
        lda #$41
        sta $531
        lda #$50
        sta $535
        lda #$51
        sta $539
        lda #$2A
        sta $53D
        lda #$2B
        sta $541
        lda #$3A
        sta $545
        lda #$3B
        sta $549

        rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_b4:
        lda #$08
        sta $52D
        lda #$09
        sta $531
        lda #$18
        sta $535
        lda #$19
        sta $539
        lda #$28
        sta $53D
        lda #$29
        sta $541
        lda #$38
        sta $545
        lda #$39
        sta $549

        rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
load_b5:
        lda #$0A
        sta $52D
        lda #$0B
        sta $531
        lda #$1A
        sta $535
        lda #$1B
        sta $539
        lda #$2A
        sta $53D
        lda #$2B
        sta $541
        lda #$3A
        sta $545
        lda #$3B
        sta $549

        rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  load_g1:
        lda #$42
        sta $54D
        lda #$43
        sta $551
        lda #$52
        sta $555
        lda #$53
        sta $559
        lda #$62
        sta $55D
        lda #$63
        sta $561
        lda #$72
        sta $565
        lda #$73
        sta $569

        rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 load_g2:
        lda #$42
        sta $54D
        lda #$43
        sta $551
        lda #$52
        sta $555
        lda #$53
        sta $559
        lda #$68
        sta $55D
        lda #$69
        sta $561
        lda #$78
        sta $565
        lda #$79
        sta $569

        rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
load_g3:
        lda #$42
        sta $54D
        lda #$43
        sta $551
        lda #$52
        sta $555
        lda #$53
        sta $559
        lda #$6A
        sta $55D
        lda #$6B
        sta $561
        lda #$7A
        sta $565
        lda #$7B
        sta $569

        rts
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 load_g4:
        lda #$48
        sta $54D
        lda #$49
        sta $551
        lda #$58
        sta $555
        lda #$59
        sta $559
        lda #$68
        sta $55D
        lda #$69
        sta $561
        lda #$78
        sta $565
        lda #$79
        sta $569

        rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
load_g5:
        lda #$4A
        sta $54D
        lda #$4B
        sta $551
        lda #$5A
        sta $555
        lda #$5B
        sta $559
        lda #$6A
        sta $55D
        lda #$6B
        sta $561
        lda #$7A
        sta $565
        lda #$7B
        sta $569

        rts


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 detection1:
             lda $500
             sta mosY
             lda $503
             sta mosX
             inc mosX
             inc mosX
             inc mosY
             inc mosY
             inc mosY
             inc mosY
             inc mosY
             inc mosY
             inc mosY

             lda #1
             sta jj
             jsr compare_mal

             lda $504
             sta mosY
             lda $507
             sta mosX
             inc mosX
             inc mosX
             inc mosY
             inc mosY
             inc mosY
             inc mosY
             inc mosY
             inc mosY
             inc mosY

             lda #2
             sta jj
             jsr compare_mal

             lda $508
             sta mosY
             lda $50B
             sta mosX
             inc mosX
             inc mosX
             inc mosY
             inc mosY
             inc mosY
             inc mosY
             inc mosY
             inc mosY
             inc mosY

             lda #3
             sta jj
             jsr compare_mal

             lda $50C
             sta mosY
             lda $50F
             sta mosX
             inc mosX
             inc mosX
             inc mosY
             inc mosY
             inc mosY
             inc mosY
             inc mosY
             inc mosY
             inc mosY

             lda #4
             sta jj
             jsr compare_mal

            lda $510
             sta mosY
             lda $513
             sta mosX
             inc mosX
             inc mosX
             inc mosY
             inc mosY
             inc mosY
             inc mosY
             inc mosY
             inc mosY
             inc mosY

             lda #5
             sta jj
             jsr compare_mal
             rts

 detection2:
             lda $500
             sta mosY
             lda $503
             sta mosX
             lda #1
             sta jj
             jsr compare_mal

             lda $504
             sta mosY
             lda $507
             sta mosX

             lda #2
             sta jj
             jsr compare_mal

             lda $508
             sta mosY
             lda $50B
             sta mosX


             lda #3
             sta jj
             jsr compare_mal

             lda $50C
             sta mosY
             lda $50F
             sta mosX


             lda #4
             sta jj
             jsr compare_mal

            lda $510
             sta mosY
             lda $513
             sta mosX


             lda #5
             sta jj
             jsr compare_mal
             rts

  detection3:
             lda $500
             sta mosY
             lda $503

             sta mosX
             inc mosX
             inc mosX
             inc mosX
             inc mosX

             lda #1
             sta jj
             jsr compare_mal

             lda $504
             sta mosY
             lda $507
             sta mosX

             lda #2
             sta jj
             jsr compare_mal

             lda $508
             sta mosY
             lda $50B
             sta mosX


             lda #3
             sta jj
             jsr compare_mal
       
             lda $50C
             sta mosY
             lda $50F
             sta mosX


             lda #4
             sta jj
             jsr compare_mal
         
            lda $510
             sta mosY
             lda $513
             sta mosX


             lda #5
             sta jj
             jsr compare_mal
             rts



 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 map_quiz:
      lda jj
      cmp #1
      bne ff1
      lda #1

      sta key1
   ;   lda #0
   ;   sta key2
   ;   sta key3
   ;   sta key4
   ;   sta key5


      rts
ff1:lda jj
    cmp #2
    bne ff2
    lda #1
    sta key2
  ;   lda #0
  ;    sta key1
  ;    sta key3
  ;    sta key4
  ;    sta key5
    rts
ff2:lda jj
    cmp #3
    bne ff3
    lda #1

    sta key3
 ;    lda #0
 ;     sta key1
 ;     sta key2
 ;     sta key4
 ;     sta key5
    rts
ff3:lda jj
    cmp #4
    bne ff4
    lda #1

    sta key4
 ;    lda #0
 ;     sta key1
 ;     sta key2
 ;     sta key3
 ;     sta key5
    rts
ff4:lda jj
    cmp #5
    bne ff5
    lda #1

    sta key5
  ;   lda #0
  ;    sta key1
  ;    sta key2
  ;    sta key3
  ;    sta key4

ff5:rts
compare_mal:
         lda $514
         sta racY
         lda $517
         sta racX
         inc racX
         inc racX
         inc racX
         inc racX
         inc racX
         inc racX

         lda racY
         cmp mosY
         bne khm
         lda racX
         cmp mosX
         bne khm

        jsr map_quiz

         rts

   khm:
        inc racY
        dec racX
        lda racY
         cmp mosY
         bne khm1
         lda racX
         cmp mosX
         bne khm1
         jsr map_quiz
         rts

khm1:
        inc racY
        dec racX
        lda racY
         cmp mosY
         bne khm2
         lda racX
         cmp mosX
         bne khm2
         jsr map_quiz
        rts

 khm2:
        inc racY
        dec racX
        lda racY
         cmp mosY
         bne khm3
         lda racX
         cmp mosX
         bne khm3
         jsr map_quiz
        rts

khm3:
        inc racY
        dec racX
        lda racY
         cmp mosY
         bne khm4
         lda racX
         cmp mosX
         bne khm4
         jsr map_quiz
        rts

khm4:
        inc racY
        dec racX
        lda racY
         cmp mosY
         bne khm5
         lda racX
         cmp mosX
         bne khm5
        jsr map_quiz
        rts

khm5:
        inc racY
        dec racX
        lda racY
         cmp mosY
         bne khm6
         lda racX
         cmp mosX
         bne khm6
         jsr map_quiz
         rts
;;;;;
khm6:   inc racY
        inc racX
        lda racY
         cmp mosY
         bne khm7
         lda racX
         cmp mosX
         bne khm7
         jsr map_quiz
         rts

khm7:   inc racY
        inc racX
        lda racY
         cmp mosY
         bne khm8
         lda racX
         cmp mosX
         bne khm8
         jsr map_quiz
          rts
khm8:   inc racY
        inc racX
        lda racY
         cmp mosY
         bne khm9
         lda racX
         cmp mosX
         bne khm9
         jsr map_quiz
          rts

khm9:   inc racY
        inc racX
        lda racY
         cmp mosY
         bne khm10
         lda racX
         cmp mosX
         bne khm10
         jsr map_quiz
          rts

khm10:   inc racY
        inc racX
        lda racY
         cmp mosY
         bne khm11
         lda racX
         cmp mosX
         bne khm11
         jsr map_quiz
         rts
 ;;;;
 khm11:  dec racY
        inc racX
        lda racY
         cmp mosY
         bne khm12
         lda racX
         cmp mosX
         bne khm12
        jsr map_quiz
         rts

khm12:  dec racY
        inc racX
        lda racY
         cmp mosY
         bne khm13
         lda racX
         cmp mosX
         bne khm13
         jsr map_quiz
          rts

khm13:  dec racY
        inc racX
        lda racY
         cmp mosY
         bne khm14
         lda racX
         cmp mosX
         bne khm14
        jsr map_quiz
          rts

khm14:  dec racY
        inc racX
        lda racY
         cmp mosY
         bne khm15
         lda racX
         cmp mosX
         bne khm15
        jsr map_quiz
          rts

khm15:  dec racY
        inc racX
        lda racY
         cmp mosY
         bne khm16
         lda racX
         cmp mosX
         bne khm16
        jsr map_quiz
         rts

khm16:  dec racY
        inc racX
        lda racY
         cmp mosY
         bne khm17
         lda racX
         cmp mosX
         bne khm17
        jsr map_quiz
           rts

khm17:  dec racY
        inc racX
        lda racY
         cmp mosY
         bne khm18
         lda racX
         cmp mosX
         bne khm18
        jsr map_quiz
         rts
;;

khm18:  dec racY
        dec racX
        lda racY
         cmp mosY
         bne khm19
         lda racX
         cmp mosX
         bne khm19
        jsr map_quiz
         rts

khm19:  dec racY
        dec racX
        lda racY
         cmp mosY
         bne khm20
         lda racX
         cmp mosX
         bne khm20
        jsr map_quiz
         rts

khm20:  dec racY
        dec racX
        lda racY
         cmp mosY
         bne khm21
         lda racX
         cmp mosX
         bne khm21
        jsr map_quiz
          rts

khm21:  dec racY
        dec racX
        lda racY
         cmp mosY
         bne khm22
         lda racX
         cmp mosX
         bne khm22
        jsr map_quiz
         rts

khm22:  dec racY
        dec racX
        lda racY
         cmp mosY
         bne khm23
         lda racX
         cmp mosX
         bne khm23
        jsr map_quiz

khm23:rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ultimate:
      lda key1
      cmp #1
      bne u1_quiz
      lda pressA
      cmp #1
      bne u1_quiz
      lda #1
      sta x1




 u1_quiz: lda key2
      cmp #1
      bne u2_quiz
      lda pressA
      cmp #1
      bne u2_quiz
      lda #1
      sta x2



 u2_quiz: lda key3
      cmp #1
      bne u3_quiz
      lda pressA
      cmp #1
      bne u3_quiz
      lda #1
      sta x3


u3_quiz:  lda key4
      cmp #1
      bne u4_quiz
      lda pressA
      cmp #1
      bne u4_quiz
      lda #1
      sta x4

 u4_quiz: lda key5
      cmp #1
      bne u5_quiz
      lda pressA
      cmp #1
      bne u5_quiz
      lda #1
      sta x5



 u5_quiz: rts


;;;;;;;;;;;;;;;;;;;;;
found1:

       lda x1
       cmp #1
       bne go1


       lda var1
       cmp #80
       bne con1_quiz

       jsr disable1

       lda #0
       sta key1
      sta pressA
       sta var1
       sta x1
    lda #$00
       sta $502
       rts


 con1_quiz:


       inc var1

       lda #$01
       sta $502
       lda #$13
       sta $501


   go1: rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 found2:

       lda x2
       cmp #1
       bne go2
       

       lda var2
       cmp #80
       bne con2

       jsr disable2

       lda #0
       sta key2
       sta pressA
       sta var2
       sta x2
       lda #$00
       sta $506
       rts


 con2:


       inc var2
       lda #$01
       sta $506
       lda #$13
       sta $505

   go2: rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;
found3:

       lda x3
       cmp #1
       bne go3
;

       lda var3
       cmp #80
       bne con3

       jsr disable3
       lda #0
       sta key3
       sta pressA
       sta var3
       sta x3
    lda #$00
       sta $50A
       rts


 con3:


       inc var3
        lda #$01
       sta $50A
       lda #$13
       sta $509

   go3: rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;
found4:

     lda x4
       cmp #1
       bne go4
 ;     

       lda var4
       cmp #80
       bne con4
       jsr disable4
       lda #0
       sta key4
       sta pressA
       sta var4
       sta x4
     lda #$00
       sta $50E
       rts


 con4:


       inc var4
       lda #$01
       sta $50E
       lda #$13
       sta $50D

   go4: rts
;;;;;;;;;;;;;;;;;;;;;;;;;
found5:

       lda x5
       cmp #1
       bne go5
  ;    

       lda var5
       cmp #80
       bne con5
       jsr disable5
       lda #0
       sta key5
       sta pressA
       sta var5
       sta x5
      lda #$00
       sta $512
       rts


 con5:


       inc var5
       lda #$01
       sta $512

       lda #$13
       sta $511

   go5: rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
disable1:  inc mosquito_dead
       lda md1
       cmp #1000
       bne con11
       lda #0
       sta md1

       jsr random_gen
       sta $500
       jsr random_gen
       sta $503

       rts
 con11:
       inc md1
       
       lda #$00
       sta $502
       lda #$04
       sta $501
       rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
disable2:inc mosquito_dead
       lda md2
       cmp #1000
       bne con22
       lda #0
       sta md2

      ; inc random44
       jsr random_gen
       sta $504
     ;  inc random44
       jsr random_gen
       sta $507

       rts
 con22:
       inc md2
       lda #$00
       sta $506
       lda #$04
       sta $505
       rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
disable3: inc mosquito_dead
       lda md3
       cmp #1000
       bne con33
       lda #0
       sta md3

     ;  inc random44
       jsr random_gen
       sta $508
      ; inc random44
       jsr random_gen
       sta $50B

       rts
 con33:
       inc md3
       lda #$00
       sta $50A
       lda #$04
       sta $509
       rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
disable4: inc mosquito_dead
       lda md4
       cmp #1000
       bne con44
       lda #0
       sta md4

     ;  inc random44
       jsr random_gen
       sta $50C
     ;  inc random44
       jsr random_gen
       sta $50F

       rts
 con44:
       inc md4
       lda #$00
       sta $50E
       lda #$04
       sta $50D
       rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
disable5: inc mosquito_dead
       lda md5
       cmp #1000
       bne con55
       lda #0
       sta md5

     ;  inc random44
       jsr random_gen
       sta $510
    ;   inc random44
       jsr random_gen
       sta $513

       rts
 con55:
       inc md5
       lda #$00
       sta $512
       lda #$04
       sta $511
       rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
palette_mal:

      .byte $19,$00,$0f,$30,  $19,$18,$27,$08,   $19,$21,$01,$3C, $19,$0E,$0A,$0B

      .byte $19,$07,$00,$0f,    $19,$07,$15,$0f, $19,$07,$1c,$0f, $19,$07,$30,$0f

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
screen_malaria:
        .incbin "pic0.nam"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sprites_malaria:
   ;vert tile attr horiz
.db $10, $02, $00, $10 ;sprite 0
.db $30, $02, $00, $80 ;sprite 0
.db $78, $02, $00, $40 ;sprite 0
.db $58, $02, $00, $88 ;sprite 0
.db $90, $02, $00, $30 ;sprite 0
;.db $A8, $02, $00, $58 ;sprite 0
;.db $C0, $02, $00, $90 ;sprite 0


.db $78, $04, $00, $80 ;sprite 0
.db $78, $01, $00, $88 ;sprite 0
.db $80, $10, $00, $80 ;sprite 0
.db $80, $11, $00, $88 ;sprite 0

.db $81, $22, $03, $14 ;sprite 0
.db $C9, $22, $03, $B5 ;sprite 0

.db $20, $40, $02, $60 ;sprite 0
.db $20, $41, $02, $68 ;sprite 0
.db $28, $50, $03, $60 ;sprite 0
.db $28, $51, $03, $68 ;sprite 0
.db $30, $60, $02, $60 ;sprite 0
.db $30, $61, $02, $68 ;sprite 0
.db $38, $70, $02, $60 ;sprite 0
.db $38, $71, $02, $68 ;sprite 0

.db $60, $42, $01, $90 ;sprite 0
.db $60, $43, $01, $98 ;sprite 0
.db $68, $52, $03, $90 ;sprite 0
.db $68, $53, $03, $98 ;sprite 0
.db $70, $62, $01, $90 ;sprite 0
.db $70, $63, $01, $98 ;sprite 0
.db $78, $72, $01, $90 ;sprite 0
.db $78, $73, $01, $98 ;sprite 0

demoscreen:
        .incbin "demoscreen.nam"
        
        
pal_fordemo1:
.byte $31,$11,$30,$0f,$31,$38,$30,$0f,$31,$38,$00,$0f,$31,$30,$00,$0f
.byte $31,$11,$30,$0f,$31,$38,$30,$0f,$31,$38,$00,$0f,$31,$30,$00,$0f
