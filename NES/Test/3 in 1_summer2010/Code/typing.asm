
      ; LDA SongNumber		; song number
     ; ldx #$0		; 00 for NTSC or $01 for PAL
;	jsr InitAddy		; init address

snow_monster_fall:

            lda trig_fall
            cmp #1
            bne @bhk2

           INC varB2
           lda varB2
           CMP #8
           BNE @bhk2
           LDA #$00
           STA varB2



            lda bh2
            cmp #0
            bne @hb3
            inc be2
            jsr load_snow1
            lda #1
            sta bh2
            rts

    @hb3:   inc be2
           jsr load_snow5
            lda #0
            sta bh2
            lda be2
            cmp #4
            beq @omg2
   @bhk2:     rts

   @omg2:
          jsr load_snow1
          lda #0
          sta trig_fall
          sta be2
          sta Current
          lda #1
          sta var01

          lda mx
          cmp #1
          bne @bhk2
          LDA #1
          sta trig_smoke
          
       lda wn          ;;;;;;no of letters for continuing snow level
       cmp #4
       bne @gg1

       lda #1
       sta end_seq
       sta trigger2               ;;;;;; triggring clear letters
       sta under2                 ;;;;;; triggering clear underlines
       jsr clearing_letters
       jsr clearing_underlines
       sta trigger                   ;;;; loading the letters
       sta var_new                   ;;;; starting word detection
       lda #4
       sta level_change            ;;;; increse the level for NMI
       lda #0
       sta trig_fall
       sta wl
       sta trig_smoke
       sta lower_byte               ;;;; starting the address of underline from starting
       sta varYp
       sta Current                  ;;;; clearing keyboard variable
       sta wn
       sta ttempx
       sta mx
       sta wordnum
       sta scroll_status
       sta pointer
       sta pointer0
       sta total_letters
       sta total_letters0
       sta kk
       ;LDA #$0b
       ;JSR setCHRPage1000           ;;;; changing sprite page
       ;jsr loading_snow             ;;; loading snow monster
       ;lda #1
       ;sta random7
       ;sta trig_static
       ;LDA #$10
       ;JSR setCHRPage0000
       ;lda #$0
       ;sta $2001
       ;jsr pal_firstchange
       ;jsr firstchange
       ;lda #%00011110
       ;sta $2001
       jsr clear_monster
       ;jsr walk_mov1
       rts

          ;STA scroll_status         ;;;; triggering scroll
          ;jsr clear_snow            ;;;;; clearing snow
@gg1:
          rts


scrollanimation:

         lda scroll_status    ;;;; triggering for scroll
         cmp #10             ; check if scrolling is enabled
         bne @continue

lda level_change                ;;;;; to change the chr page for walking of hanuman with rock
cmp #0
bne @p1
LDA #$08                       ;;;;;; chr page with hanuman walking frames and rock
JSR setCHRPage1000
jmp @p4

@p1:                           ;;;;; to change the chr page for walking of hanuman with only soldier basic states
    cmp #1
    bne @p2
    LDA #$08                   ;;;;;; chr page with hanuman walking frames and soldier
    JSR setCHRPage1000
    jmp @p4
@p2:                          ;;;;; to change the chr page for walking of hanuman with only snake basic states
   cmp #2
   bne @p3
   LDA #$07                   ;;;;;; chr page with hanuman walking frames and snake
   JSR setCHRPage1000
   jmp @p4
@p3:                          ;;;;; to change the chr page for walking of hanuman with only snow monster basic states
    cmp #3
    bne @p4
    LDA #$0b                  ;;;;;; chr page with hanuman walking frames and snow monster
    JSR setCHRPage1000
@p4:

         lda #0
         sta var_new

         lda #1
         sta trigger2          ;;;; triggering for clearing word
         sta under2            ;;;; triggering for clearing underline
         sta sw                ;;;; hanuman moving while scrolling

         lda ll
         beq @moveforward     ; check whether 90 pixel movement is enabled ,if enabled then jumps to the routine
         cmp #5              ; check if 90 pixel movement of hanuman forward is done
         beq @moveboth
@continue:
         rts

; move hanuman 90 pixelsforward
@moveforward:
	lda moveforward_status
        cmp #90
        beq @moveboth_init
        inc moveforward_status
        inc scroll_h         ; increase horizotal scroll value
        rts

@moveboth_init:
        lda #5
        sta ll
        lda #0
        sta moveforward_status
        rts
@moveboth:
         jsr decrease        ;move hanuman back by 1 pixel
         lda $503
         cmp #0              ; check if hanuman is at the right end of the screen
         bne @abc
         jsr increase
@abc      inc scroll_h        ; move screen back
         lda scroll_h
         cmp #0              ;check if the background has completely changed to new
         beq change22
         rts
; move hanuman 90 pixelsforward
change22:                            ;;;;;; triggering all variables after scrolling is over
        lda #0
        sta scroll_status            ;;;;; disabling scrolling
        sta mx
        sta sw                       ;;;; dissabling walking during scrolling
        sta lower_byte               ;;;; starting the address of underline from starting
        sta varYp
        sta Current                  ;;;; clearing keyboard variable
        inc wordnum                  ;;;; increasing the word number
        inc wn                       ;;;; increasing the word number

       lda #1
       sta trigger                   ;;;; loading the letters
                             ;;;; starting the movement
       sta var_new                   ;;;; starting word detection

        lda #$0                      ;;;; changing the name table
        sta hitrock
        sta ll
        lda PPUCRTL
        EOR #%00000001
        sta PPUCRTL
        sta $2000

lda level_change                    ;;;;initialising variables after scroling for rock level
cmp #0
bne @p1
        lda wn                      ;;;;;; for how many different letters rock will loaded again
        cmp #3
        bne @conti
        lda #1                             ;;;;; code for going from rock level to soldier level
        sta trig_sol
        inc level_change
        lda #0
        sta wn
        sta wordnum
        sta pointer
        sta total_letters
        jsr loading_soldier
        rts
@conti:
        jsr loading_rock               ;;; loading rock
        rts

jmp @p4

@p1:                                ;;;;for soldier level
    cmp #1
    bne @p2
    jsr loading_soldier
    lda #1
    sta trig_sol
    rts
    jmp @p4

@p2:
   cmp #2                            ;;;;checkinh for snake level
   bne @p3
        jsr loading_snake            ;;; loading snake
        lda #1
        sta key
        rts
   jmp @p4

@p3:
    cmp #3
    bne @p4
    jsr loading_snow                ;;;;; loading snow monster again
    lda #1
    sta trig_static
    rts
@p4:

rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;To update the sprites of hunuman during walking

update:


 @jk :lda var_walk
     cmp #0
     bne @jk1
     jsr walk_mov1
     lda #1
     sta var_walk
     rts

 @jk1: lda var_walk
     cmp #1
     bne @jk2
     jsr walk_mov2
     lda #2
     sta var_walk
     rts

 @jk2:lda var_walk
     cmp #2
     bne @jk3
     jsr walk_mov3
     lda #3
     sta var_walk
     rts

  @jk3:lda var_walk
     cmp #3
     bne @jk4
     jsr walk_mov4
     lda #4
     sta var_walk
     rts

  @jk4:lda var_walk
     cmp #4
     bne @jk5
     jsr walk_mov5
     lda #5
     sta var_walk
     rts

  @jk5:lda var_walk
     cmp #5
     bne @jk6
     jsr walk_mov6
     lda #6
     sta var_walk
     rts

   @jk6:lda var_walk
     cmp #6
     bne @jk7
     jsr walk_mov7
     lda #7
     sta var_walk
     rts

  @jk7:lda var_walk
     cmp #7
     bne @jk8
     jsr walk_mov8
     lda #0
     sta var_walk
@jk8:rts

walk_mov1:

                lda #$00
                sta $501

                lda #$01
                sta $505

                lda #$02
                sta $509

                lda #$03
                sta $50D

                lda #$10
                sta $511

                lda #$11
                sta $515

                lda #$12
                sta $519

                lda #$1f
                sta $51D

                lda #$20
                sta $521

                lda #$21
                sta $525

                lda #$22
                sta $529

                lda #$23
                sta $52D

                lda #$30
                sta $531

                lda #$31
                sta $535

                lda #$32
                sta $539

                lda #$33
                sta $53D

                rts
 ;-----------------------------------------

                RTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
walk_mov2:       lda #$04
                sta $501

                lda #$05
                sta $505

                lda #$06
                sta $509

                lda #$07
                sta $50D

                lda #$14
                sta $511

                lda #$15
                sta $515

                lda #$16
                sta $519

                lda #$17
                sta $51D

                lda #$24
                sta $521

                lda #$25
                sta $525

                lda #$26
                sta $529

                lda #$27
                sta $52D

                lda #$34
                sta $531

                lda #$35
                sta $535

                lda #$36
                sta $539

                lda #$37
                sta $53D


                RTS
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  walk_mov3:    lda #$08
                sta $501

                lda #$09
                sta $505

                lda #$0A
                sta $509

                lda #$0B
                sta $50D

                lda #$18
                sta $511

                lda #$19
                sta $515

                lda #$1A
                sta $519

                lda #$1B
                sta $51D

                lda #$28
                sta $521

                lda #$29
                sta $525

                lda #$2A
                sta $529

                lda #$2B
                sta $52D

                lda #$38
                sta $531

                lda #$39
                sta $535

                lda #$3A
                sta $539

                lda #$3B
                sta $53D


                RTS
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  walk_mov4:     lda #$0C
                sta $501

                lda #$0D
                sta $505

                lda #$0E
                sta $509

                lda #$0F
                sta $50D

                lda #$1C
                sta $511

                lda #$1D
                sta $515

                lda #$1E
                sta $519

                lda #$1F
                sta $51D

                lda #$2C
                sta $521

                lda #$2D
                sta $525

                lda #$2E
                sta $529

                lda #$2F
                sta $52D

                lda #$3C
                sta $531

                lda #$3D
                sta $535

                lda #$3E
                sta $539

                lda #$3F
                sta $53D


                RTS
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  walk_mov5:       lda #$40
                sta $501

                lda #$41
                sta $505

                lda #$42
                sta $509

                lda #$43
                sta $50D

                lda #$50
                sta $511

                lda #$51
                sta $515

                lda #$52
                sta $519

                lda #$53
                sta $51D

                lda #$60
                sta $521

                lda #$61
                sta $525

                lda #$62
                sta $529

                lda #$1f
                sta $52D

                lda #$70
                sta $531

                lda #$71
                sta $535

                lda #$72
                sta $539

                lda #$1f
                sta $53D


                RTS
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   walk_mov6:   lda #$44
                sta $501

                lda #$45
                sta $505

                lda #$46
                sta $509

                lda #$47
                sta $50D

                lda #$54
                sta $511

                lda #$55
                sta $515

                lda #$56
                sta $519

                lda #$57
                sta $51D

                lda #$64
                sta $521

                lda #$65
                sta $525

                lda #$66
                sta $529

                lda #$67
                sta $52D

                lda #$74
                sta $531

                lda #$75
                sta $535

                lda #$76
                sta $539

                lda #$77
                sta $53D


                RTS
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  walk_mov7:    lda #$48
                sta $501

                lda #$49
                sta $505

                lda #$4A
                sta $509

                lda #$4B
                sta $50D

                lda #$58
                sta $511

                lda #$59
                sta $515

                lda #$5A
                sta $519

                lda #$1F
                sta $51D

                lda #$68
                sta $521

                lda #$69
                sta $525

                lda #$6A
                sta $529

                lda #$1F
                sta $52D

                lda #$78
                sta $531

                lda #$79
                sta $535

                lda #$7A
                sta $539

                lda #$1F
                sta $53D


                RTS
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  walk_mov8:       lda #$4C
                sta $501

                lda #$4D
                sta $505

                lda #$4E
                sta $509

                lda #$2B
                sta $50D

                lda #$1F
                sta $511

                lda #$5D
                sta $515

                lda #$5E
                sta $519

                lda #$5F
                sta $51D

                lda #$6C
                sta $521

                lda #$6D
                sta $525

                lda #$6E
                sta $529

                lda #$1F
                sta $52D

                lda #$7C
                sta $531

                lda #$7D
                sta $535

                lda #$7E
                sta $539

                lda #$1F
                sta $53D


                RTS

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
update1:
        LDA count1
        cmp #1
        beq @L2a
        LDA count1

        cmp #2
        beq @L3a
        LDA count1

        cmp #3
        beq @L4a
        LDA count1

        cmp #4
        beq @L5a
        LDA count1

        cmp #5
        beq @L6a
        LDA count1

        cmp #6
        beq @L7a
        LDA count1

        cmp #7
        beq @L8a
        LDA count1

        CMP #0
        beq @L1a

@L1a:
        jsr load_a1

        LDA #1
        STA count1

        RTS

@L2a:    jsr load_a2
        LDA #2
        STA count1

        RTS


@L3a:    jsr load_a3
        LDA #3
        STA count1
        RTS

@L4a:    jsr load_a4
        LDA #4
        STA count1
        RTS

@L5a:    jsr load_a5
        LDA #5
        STA count1
        RTS

@L6a:    jsr load_a6
        LDA #6
        STA count1
        RTS

@L7a:    jsr load_a7
        LDA #7
        STA count1
        RTS

@L8a:    jsr load_a8
        LDA #0
        STA count1


        RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  load_a1:      lda #$00
                sta $501

                lda #$01
                sta $505

                lda #$02
                sta $509

                lda #$03
                sta $50D

                lda #$10
                sta $511

                lda #$11
                sta $515

                lda #$12
                sta $519

                lda #$1f
                sta $51D

                lda #$20
                sta $521

                lda #$21
                sta $525

                lda #$22
                sta $529

                lda #$23
                sta $52D

                lda #$30
                sta $531

                lda #$31
                sta $535

                lda #$32
                sta $539

                lda #$33
                sta $53D

                rts
 ;;;;;;;;;;;;;;;;;;;;;;;
 load_a2:       lda #$1F
                sta $501

                lda #$05
                sta $505

                lda #$06
                sta $509

                lda #$1f
                sta $50D

                lda #$14
                sta $511

                lda #$15
                sta $515

                lda #$16
                sta $519

                lda #$1f
                sta $51D

                lda #$24
                sta $521

                lda #$25
                sta $525

                lda #$26
                sta $529

                lda #$27
                sta $52D

                lda #$34
                sta $531

                lda #$35
                sta $535

                lda #$36
                sta $539

                lda #$37
                sta $53D


                RTS
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  load_a3:    lda #$08
                sta $501

                lda #$09
                sta $505

                lda #$0A
                sta $509

                lda #$0B
                sta $50D

                lda #$18
                sta $511

                lda #$19
                sta $515

                lda #$1A
                sta $519

                lda #$1B
                sta $51D

                lda #$28
                sta $521

                lda #$29
                sta $525

                lda #$2A
                sta $529

                lda #$2B
                sta $52D

                lda #$1f
                sta $531

                lda #$39
                sta $535

                lda #$3A
                sta $539

                lda #$3B
                sta $53D


                RTS
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  load_a4:     lda #$1f
                sta $501

                lda #$0D
                sta $505

                lda #$0E
                sta $509

                lda #$0F
                sta $50D

                lda #$1C
                sta $511

                lda #$1D
                sta $515

                lda #$1E
                sta $519

                lda #$1F
                sta $51D

                lda #$2C
                sta $521

                lda #$2D
                sta $525

                lda #$2E
                sta $529

                lda #$2F
                sta $52D

                lda #$3C
                sta $531

                lda #$3D
                sta $535

                lda #$3E
                sta $539

                lda #$3F
                sta $53D


                RTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
load_a5:       lda #$40
                sta $501

                lda #$41
                sta $505

                lda #$42
                sta $509

                lda #$43
                sta $50D

                lda #$50
                sta $511

                lda #$51
                sta $515

                lda #$52
                sta $519

                lda #$53
                sta $51D

                lda #$60
                sta $521

                lda #$61
                sta $525

                lda #$1F
                sta $529

                lda #$1F
                sta $52D

                lda #$70
                sta $531

                lda #$71
                sta $535

                lda #$72
                sta $539

                lda #$1F
                sta $53D


                RTS
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   load_a6:   lda #$44
                sta $501

                lda #$45
                sta $505

                lda #$46
                sta $509

                lda #$47
                sta $50D

                lda #$54
                sta $511

                lda #$55
                sta $515

                lda #$56
                sta $519

                lda #$57
                sta $51D

                lda #$64
                sta $521

                lda #$65
                sta $525

                lda #$66
                sta $529

                lda #$67
                sta $52D

                lda #$74
                sta $531

                lda #$75
                sta $535

                lda #$76
                sta $539

                lda #$77
                sta $53D


                RTS
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  load_a7:    lda #$48
                sta $501

                lda #$49
                sta $505

                lda #$4A
                sta $509

                lda #$4B
                sta $50D

                lda #$58
                sta $511

                lda #$59
                sta $515

                lda #$5A
                sta $519

                lda #$1F
                sta $51D

                lda #$68
                sta $521

                lda #$69
                sta $525

                lda #$6A
                sta $529

                lda #$6B
                sta $52D

                lda #$78
                sta $531

                lda #$79
                sta $535

                lda #$7A
                sta $539

                lda #$7B
                sta $53D


                RTS
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  load_a8:       lda #$4C
                sta $501

                lda #$4D
                sta $505

                lda #$4E
                sta $509

                lda #$1F
                sta $50D

                lda #$5C
                sta $511

                lda #$5D
                sta $515

                lda #$5E
                sta $519

                lda #$5F
                sta $51D

                lda #$6C
                sta $521

                lda #$6D
                sta $525

                lda #$6E
                sta $529

                lda #$6F
                sta $52D

                lda #$7C
                sta $531

                lda #$7D
                sta $535

                lda #$7E
                sta $539

                lda #$1F
                sta $53D


                RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ch3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 mon_1:

       lda #$1F
       sta $541

       lda #$1F
       sta $545

       lda #$1F
       sta $549

       lda #$1F
       sta $54D

       lda #$D0
       sta $551

       lda #$D1
       sta $555

       lda #$1F
       sta $559

       lda #$1F
       sta $55D

       lda #$E0
       sta $561

       lda #$E1
       sta $565

       lda #$E2
       sta $569

       lda #$E3
       sta $56D

       lda #$F0
       sta $571

       lda #$F1
       sta $575

       lda #$F2
       sta $579

       lda #$F3
       sta $57D

       rts

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ch4
   mon_2:

       lda #$1F
       sta $541

       lda #$C5
       sta $545

       lda #$C6
       sta $549

       lda #$1F
       sta $54D

       lda #$D4
       sta $551

       lda #$D5
       sta $555

       lda #$D6
       sta $559

       lda #$1F
       sta $55D

       lda #$E4
       sta $561

       lda #$E5
       sta $565

       lda #$E6
       sta $569

       lda #$E7
       sta $56D

       lda #$F4
       sta $571

       lda #$F5
       sta $575

       lda #$F6
       sta $579

       lda #$F7
       sta $57D

       rts


 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ch2
  mon_3:

       lda #$1F
       sta $541

       lda #$C9
       sta $545

       lda #$CA
       sta $549

       lda #$CB
       sta $54D

       lda #$1F
       sta $551

       lda #$D9
       sta $555

       lda #$DA
       sta $559

       lda #$DB
       sta $55D

       lda #$E8
       sta $561

       lda #$E9
       sta $565

       lda #$EA
       sta $569

       lda #$EB
       sta $56D

       lda #$F8
       sta $571

       lda #$F9
       sta $575

       lda #$FA
       sta $579

       lda #$FB
       sta $57D

       rts

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ch1
 mon_4:

       lda #$1F
       sta $541

       lda #$C1
       sta $545

       lda #$C2
       sta $549

       lda #$C3
       sta $54D

       lda #$1F
       sta $551

       lda #$C0
       sta $555

       lda #$D2
       sta $559

       lda #$D3
       sta $55D

       lda #$1F
       sta $561

       lda #$C8
       sta $565

       lda #$C7
       sta $569

       lda #$1F
       sta $56D

       lda #$DF
       sta $571

       lda #$CF
       sta $575

       lda #$D7
       sta $579

       lda #$C4
       sta $57D

       rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mon_5:

       lda #$CC
       sta $541

       lda #$CD
       sta $545

       lda #$CE
       sta $549

       lda #$1F
       sta $54D

       lda #$DC
       sta $551

       lda #$DD
       sta $555

       lda #$DE
       sta $559

       lda #$1F
       sta $55D

       lda #$EC
       sta $561

       lda #$ED
       sta $565

       lda #$EE
       sta $569

       lda #$1F
       sta $56D

       lda #$FC
       sta $571

       lda #$FD
       sta $575

       lda #$FE
       sta $579

       lda #$FF
       sta $57D

       rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mon_6:

       lda #$1F
       sta $541

       lda #$1F
       sta $545

       lda #$1F
       sta $549

       lda #$1F
       sta $54D

       lda #$1F
       sta $551

       lda #$1F
       sta $555

       lda #$1F
       sta $559

       lda #$1F
       sta $55D

       lda #$1F
       sta $561

       lda #$48
       sta $565

       lda #$5B
       sta $569

       lda #$4F
       sta $56D

       lda #$8C
       sta $571

       lda #$8D
       sta $575

       lda #$13
       sta $579

       lda #$04
       sta $57D

       rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mon_7:

       lda #$1F
       sta $541

       lda #$1F
       sta $545

       lda #$1F
       sta $549

       lda #$1F
       sta $54D

       lda #$1F
       sta $551

       lda #$1F
       sta $555

       lda #$1F
       sta $559

       lda #$1F
       sta $55D

       lda #$1F
       sta $561

       lda #$17
       sta $565

       lda #$07
       sta $569

       lda #$38
       sta $56D

       lda #$62
       sta $571

       lda #$63
       sta $575

       lda #$73
       sta $579

       lda #$0C
       sta $57D

       rts



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
startup :

decrease:
        DEC $503
	DEC $507
	DEC $50B
	DEC $50F
	DEC $513
	DEC $517
	DEC $51B
	DEC $51F
	DEC $523
	DEC $527
	DEC $52B
	DEC $52F
	DEC $533
	DEC $537
	DEC $53B
	DEC $53F
	rts
increase:
        INC $503
	INC $507
	INC $50B
	INC $50F
	INC $513
	INC $517
	INC $51B
	INC $51F
	INC $523
	INC $527
	INC $52B
	INC $52F
	INC $533
	INC $537
	INC $53B
	INC $53F
         rts

;controller_test:

; Now we are moving 4 sprites together. so now the horizontal position of sprite 0,1,2,3 are stored in 503,507,50B and 50F respectively
; The vertical position is stored in 500,504,508 and 50C respectively. So now we simltaneously increase or decrease the position of all 4 sprites.
; This in done in code. For Check up - we have decresed the vertical position of all 4 sprites in order. For check down, we have increased the
; the vertical position in order.now each tile has 8 pixel. So for check left and check right, we have put boundary and accordingly adjusted its
; value with the position. Remember the the position difference should be 8.

         ;;;;;;;;;;;;;;;;;;;;;;;;;;
Compare:                        ;;;;; comparing the letter typed by the user and the one required

lda var_new                     ;;;;;; triggering for going into compare for snake level
cmp #1
beq @com_jmp
rts
@com_jmp:
LDA var1                       ;;;;;;; checking if keyboard input is working
cmp #1
beq @c
ldy pointer     ; it points to current letter that should be pressed by the user. pointer is a number. we will load the letter from library
ldx Current     ; this stores the current letter pressed by the user
lda word1,y   ; load the expected letter into accumaltor
cmp Current  ;        compare with the currently pressed letter
beq @Found              ; correct letter is pressed
lda #0
sta Current

@c:RTS

@Found:                           ;;;;;; if word typed is correct then going in found
 ;;;;;;;;
         lda #0
         sta ps2
         ;jsr arrow11
         lda #0
         sta Current
   lda #1
   sta under
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
    lda NumberofLetters,y
    sta ww                          ; this loads that word 1 has how many letters . 4 will be loaded
    cmp wl                          ; compare with current lenght of the current word.
    BEQ @newword                     ; ie wordnum is 1. so lda will be 4. wl is 4 then new word
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@newword:

         lda #0
         sta wl              ; now wl is reset to zero. wl keeps the no. of letters pressed by user for current word
         sta delay_cal_quiz       ;;;;; initializing delay value to 0
         sta var_new         ;;;;; disabling the first word comparision
         lda #1
         sta var01           ;;;; initialising the trigger for second comparision
         sta trig_delay      ;;;; initialising the time limit for secon word detection
         sta clearing_byte

         jsr mon_1           ;;;; loading the initial monster again

         lda #0
         sta key
         RTS

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Compare2:                  ;;;;; checking for the comparision of second word's letter typed and the one required
         LDA var01
         cmp #$01
         beq @c0
         rts
@c0:
         ldy pointer0     ; it points to current letter that should be pressed by the user. pointer is a number. we will load the letter from library
         ldx Current     ; this stores the current letter pressed by the user
         lda word2,y   ; load the expected letter into accumaltor
         cmp Current  ;        compare with the currently pressed letter
         beq @Found0              ; correct letter is pressed
         lda #0
         sta Current
@c00:
         RTS
@Found0:
       lda #0
       sta Current
       
       LDA #$01
       STA k
       inc wl                          ; this will increse the wl. So if "RO" are pressed then wl = 2 and if "C" is pressed then wl=3
       ldx wl                          ; is the current lenght of the letters pressed of a word

       inc pointer0                     ; increment pointer so now it points to the next correct letter
       lda #0
       sta delay_cal_quiz

    LDA #$01
    sta under1

    lda #0
    STA var1

    ldy wordnum
    lda NumberofLetters1,y

    cmp wl                          ; compare with current lenght of the current word.
    BEQ @newword0                     ; ie wordnum is 1. so lda will be 4. wl is 4 then new word



    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@newword0:
          LDA #$01
          STA k
          sta mx
          LDA #$05
          sta hitrock             ; new word has been encountered. hence now the rock will break and scrolling will start



         lda #0
         sta wl              ; now wl is reset to zero. wl keeps the no. of letters pressed by user for current word
         sta var01
         sta trig_delay
         RTS
;      ---------------------------------------------------------------------
clear_monster:
       lda #$1F
       sta $541

       sta $545

       sta $549

       sta $54D

       sta $551

       sta $555

       sta $559

       sta $55D

       sta $561

       sta $565

       sta $569

       sta $56D

       sta $571

       sta $575

       sta $579

       sta $57D

       rts
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  mon_exp:                   ;;;;; movement of monster when hanuman hits

       lda go
       cmp #1
       bne @gg2

        LDA md2
        CMP #25
        BEQ @lv7
        inc md2

        jsr mon_3
@gg2:
        rts

   @lv7:
        lda #0
       sta md2
       sta go
       sta Current
       lda #1
        sta var01
       jsr mon_1

       lda mx
       cmp #1
       bne @gg1
       ;LDA #10
       ;STA scroll_status
       lda #1
       sta trig_smoke
       ;jsr clear_monster
       lda wn
       cmp #3
       bne @gg1

       lda #1
       sta trigger                   ;;;; loading the letters
       sta var_new                   ;;;; starting word detection

       inc level_change
       lda #0
       sta trig_smoke
       sta lower_byte               ;;;; starting the address of underline from starting
       sta varYp
       sta Current                  ;;;; clearing keyboard variable
       sta wn
       sta mx
       sta wordnum
       sta scroll_status
       sta pointer
       sta pointer0
       sta total_letters
       sta total_letters0
       sta kk
       sta k
       LDA #$0b
       JSR setCHRPage1000           ;;;; changing sprite page
       jsr loading_snow             ;;; loading snow monster
       lda #1
       sta random7
       sta trig_static
       LDA #$10
       JSR setCHRPage0000
       lda #$0
       sta $2001
       jsr pal_firstchange
       jsr firstchange
       lda #%00011110
       sta $2001
       jsr clear_monster
       jsr walk_mov1
       rts

  @gg1:     RTS

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

hit_fun:                          ;;;;; hitting of hanuman
         LDA k
         CMP #$00
         beq @TP11

lda level_change               ;;;; for first level rock which chr page has triggered
cmp #0
bne @p1
INC varYp
lda varYp
CMP #25  ;  increase/decrease to make it hit faster
BNE @TP11
dec varYp
LDA #$0a
JSR setCHRPage1000           ;;;;; setting chr of hitting frame
jmp @p4

@p1:                    ;;;;; for level one hitting which chr page has to be triggered
    cmp #1
    bne @p2
    INC varYp
    lda varYp
    CMP #25  ; 20 is the delay, increase/decrease to make it hit faster
    BNE @TP11
    dec varYp
    LDA #$0a
    JSR setCHRPage1000
    jmp @p4
@p2:                ;;;;; for level two hitting which chr page has to be set
   cmp #2
   bne @p3
   LDA #$09
   JSR setCHRPage1000
   jmp @p4
@p3:                ;;;;; for level three hitting which chr page has to be set
    cmp #3
    bne @p4
    LDA #$0c
    JSR setCHRPage1000
@p4:

         INC varYY
         lda varYY
         CMP #5  ; 20 is the delay, increase/decrease to make it hit faster
         BNE @TP11
         LDA #$00
         STA varYY


        LDA #00
        sta var1
        sta varX



        inc kk
        jsr update1
        lda level_change
        cmp #0
        beq @conti
        cmp #1
        beq @conti
        LDA kk
        CMP #8
        BEQ lv1
        rts
@conti:
       LDA kk
       CMP #16
       BEQ lv1

@TP11:    RTS
lv1:

        LDA #$00
        STA k
        STA kk

        jsr load_a1

        lda level_change            ;;;; when hitting completes
        cmp #0
        bne @p1
        jsr clear_rock              ;;;; clearing rocks
        lda #10
        sta scroll_status           ;;;; starting scroll
        jmp @p4
@p1:                              ;;;;; for level 2
    cmp #1
    bne @p2
    jsr clear_snow            ;;;; cleearing soldiers
    lda #10
    sta scroll_status            ;;;; starting scroll
    lda #0
    sta trig_sol

    lda wn                      ;;;; how many different letters will be loaded for soldiers
    cmp #3
    bne @p4

    lda #1
    sta trigger                   ;;;; loading the letters
    sta var_new
    sta scroll_status
                                    ;;;; code started going from soldier to snake level

    lda #0
    ;sta mx
    sta wn
    sta wordnum
    sta pointer
    sta pointer0
    sta total_letters
    sta lower_byte               ;;;; starting the address of underline from starting
    sta varYp
    sta Current                  ;;;; clearing keyboard variable
    LDA #$07
    JSR setCHRPage1000          ;;;; changing sprite page
    jsr loading_snake           ;;; loading snake
    lda #1
    sta key
    LDA #$0d
    JSR setCHRPage0000
    lda #%0
    sta $2001
    jsr pal_firstchange1
    jsr firstchange1
    lda #%00011110
    sta $2001
    inc level_change
    jmp @p4
@p2:                            ;;;; for level 3
   cmp #2
   bne @p3
   lda #1
   sta go                      ;;;;; triggering snake expression
   sta mon_color               ;;;;; triggering snake colour
   jmp @p4
@p3:                         ;;;;; for level 4
    cmp #3
    bne @p4
    lda #1
    sta trig_fall
    sta mon_color

@p4:
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
monster_colour:                            ;;;;;; change the colour of snke when hitting takes place
               lda mon_color
               cmp #1
               bne @end_mco

        LDA mdd2
        CMP #25
        BEQ @lv9
        inc mdd2

        lda col
        cmp #1
        bne @hjj
        jsr @old_pal
        lda #0
        sta col
        rts
   @hjj: jsr @new_pal
        lda #1
        sta col
        rts
   @lv9:
       lda #0
       sta mdd2
       sta mon_color
       jsr @old_pal

@end_mco:
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@old_pal:
        lda #$02
        sta #$542
        sta #$546
        sta #$54a
        sta #$54e
        sta #$552
        sta #$556
        sta #$55a
        sta #$55e
        sta #$562
        sta #$566
        sta #$56a
        sta #$56e
        sta #$572
        sta #$576
        sta #$57a
        sta #$57e
        rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@new_pal:
         lda #$03
        sta #$542
        sta #$546
        sta #$54a
        sta #$54e
        sta #$552
        sta #$556
        sta #$55a
        sta #$55e
        sta #$562
        sta #$566
        sta #$56a
        sta #$56e
        sta #$572
        sta #$576
        sta #$57a
        sta #$57e
        rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;To map fix distance at each step of hanuman for a given wordlength
map:
      LDA ww                  ;;;;;; contains the length for the word triggered from compare
      CMP #3
      BNE @m1
      LDA #28
      STA j
      RTS

  @m1:
      CMP #4
      BNE @m2
      LDA #21
      STA j
      RTS

  @m2:
      CMP #5
      BNE @m3
      LDA #17
      STA j
      RTS

  @m3:
      CMP #6
      BNE @m4
      LDA #14
      STA j
      RTS

  @m4:
      CMP #7
      BNE @m5
      LDA #12
      STA j
      RTS


   @m5:
       RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;To make hanuman walk when we found correct letter

 walk_fun:


           INC varY
           lda varY
           CMP #1
           BNE @TP1
           LDA #$00
           STA varY

           LDA var1
           CMP #$00
           BNE @ss
           LDA k
           CMP #$01
           BEQ @here
         ; jsr walk_mov1
@here:
           RTS


@ss:
        jsr update
        LDA j
        CMP #$00
        BEQ @lv
        DEC j
        jsr B2
        RTS
@lv:
        LDA #$00
        STA varX
        STA var1

@TP1:
        RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scroll_walk:              ;;;; walking while scrolling is taking place

           INC varG
           lda varG
           CMP #10
           BNE @kkg
           LDA #$00
           STA varG

           lda sw
           cmp #1
           bne @kkg
           jsr update

  @kkg:rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
monster_fun1:

            lda key
            cmp #1
            bne @jsk

           INC varM
           lda varM
           CMP #10
           BNE @jsk
           LDA #$00
           STA varM

            lda moh
            cmp #0
            bne @hm1


            jsr mon_1
            lda #1
            sta moh
      @jsk:  rts

       @hm1: lda moh
            cmp #1
            bne @hm2

           lda mx
           cmp #1
           beq @llp
           INC varMM
           lda varMM
           CMP #7
           BNE @jsk
           LDA #$00
           STA varMM

     @llp:   jsr mon_2
            lda #2
            sta moh
            rts

       @hm2: lda moh
            cmp #2
            bne @hm3

            jsr mon_3
            lda #3
            sta moh
            rts

       @hm3: lda moh
            cmp #3
            bne @hm4

            jsr mon_2
            lda #4
            sta moh
            rts

       @hm4:
            jsr mon_1
            lda #1
            sta moh

            rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hanuman_colour:                     ;;;;; colour of hanuman changes when monster hits him
               lda hanu_pal
               cmp #1
               bne @end_mco1

        LDA mdd21
        CMP #25
        BEQ @lv91
        inc mdd21

        lda col1
        cmp #1
        bne @hjj1
        jsr old_pal2
        lda #0
        sta col1
        rts
   @hjj1: jsr new_pal2
        lda #1
        sta col1
        rts
   @lv91:
       lda #0
       sta mdd21
       sta hanu_pal
       jsr old_pal2

@end_mco1:
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
old_pal2:
        lda #$01
        sta #$502
        sta #$506
        sta #$50a
        sta #$50e
        sta #$512
        sta #$516
        sta #$51a
        sta #$51e
        sta #$522
        sta #$526
        sta #$52a
        sta #$52e
        sta #$532
        sta #$536
        sta #$53a
        sta #$53e
        rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
new_pal2:
        lda #$00
        sta #$502
        sta #$506
        sta #$50a
        sta #$50e
        sta #$512
        sta #$516
        sta #$51a
        sta #$51e
        sta #$522
        sta #$526
        sta #$52a
        sta #$52e
        sta #$532
        sta #$536
        sta #$53a
        sta #$53e
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
monster_fun2:

            lda key_fun2
            cmp #1
            bne @jsk1
           INC varM1
           lda varM1
           CMP #8
           BNE @jsk1
           LDA #$00
           STA varM1

        inc kkc
        jsr @load_mon2
        LDA kkc
        CMP #7  ; 6 will make it hit 3 times, 4 will make it 2 times and so on....
        BEQ @lv5

@jsk1:        RTS

@lv5:

        LDA #$00
        STA kkc


@load_mon2:

            lda key1
            cmp #0
            bne @sh1
            jsr mon_1
            lda #1
            sta key1
            rts

       @sh1: lda key1
            cmp #1
            bne @sh2

           INC varMM1
           lda varMM1
           CMP #7
           BNE @jsk1
           LDA #$00
           STA varMM1

            jsr mon_2
            lda #2
            sta key1
            rts

      @sh2: lda key1
            cmp #2
            bne @sh3
            jsr mon_3
            lda #3
            sta key1
            rts

      @sh3: lda key1
            cmp #3
            bne @sh4
            jsr mon_4
            lda #4
            sta key1
            rts

      @sh4: lda key1
            cmp #4
            bne @sh5
            jsr mon_5
            lda #5
            sta key1
            rts

     @sh5:   lda key1
            cmp #5
            bne @sh6
            jsr mon_6
            lda #6
            sta key1
            rts

     @sh6:   lda key1
            cmp #6
            bne @sh7
            jsr mon_7
            lda #7
            sta key1
            rts

      @sh7: ;lda key1
           ; cmp #7
           ; bne sh8
            jsr mon_1
            lda #0
            sta key1
            sta key_fun2
            lda #1
            sta pro1
            sta hanu_pal
            rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  B1:   inc $0603
        inc $0607
        inc $060B
        inc $060F
        inc $0613
        inc $0617
        inc $061B
        inc $061F
        inc $0623
        inc $0627
        inc $062B
        inc $062F
        inc $0633
        inc $0637
        inc $063B
        inc $063F


        RTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  B2:   inc $0503
        inc $0507
        inc $050B
        inc $050F
        inc $0513
        inc $0517
        inc $051B
        inc $051F
        inc $0523
        inc $0527
        inc $052B
        inc $052F
        inc $0533
        inc $0537
        inc $053B
        inc $053F

        inc $0503
        inc $0507
        inc $050B
        inc $050F
        inc $0513
        inc $0517
        inc $051B
        inc $051F
        inc $0523
        inc $0527
        inc $052B
        inc $052F
        inc $0533
        inc $0537
        inc $053B
        inc $053F


        RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




 controller_test_typing:

        jsr Compare
 ;;;;;;;;;;;;;;
       jmp @over2
 ;;;;;;;;;;;;;;;;;;;;;


 @over2:      RTS

;=---------------------------------------------------


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
StartHitRockAnim:


                 ;lda k
                ; cmp #$01
                ; BEQ ove1
                ; jmp rh



; here the logic is that the big rock is divided into 7 different parts. the no. of tiles in blocks are 4,2,4,2,3,3,3 respectively
; so total 21 tiles we are using. Now were changing the x and y positions of each 7 objects in each jsr and hence they are
;seemed to be fly at random


;rh:

  lda hitrock
  cmp #$05
  beq onn
  rts
         ;INC varH
         ;lda varH
         ;CMP #1  ; 20 is the delay, increase/decrease to make it hit faster
         ;BNE ove1
         ;LDA #$00
         ;STA varH
         ;

onn:

lda blastrock
cmp #1
beq brock
lda blastsoldier
cmp #1
beq bsoldier1
lda blastsnake
cmp #1
beq bsnake1
rts

bsnake1:
jmp bsnake

bsoldier1:
jmp bsoldier

brock:
;lda #0
;sta blastrock


test0:
     lda sp0        ; for sprite 0,1,3,4
     inc sp0
     cmp #30
     BEQ new0
     BNE old0

     old0:
     dec $540
     dec $544
     dec $54C
     dec $550
     dec $543
     dec $54F
     dec $553
     dec $547
     JMP test1

     new0:
     dec sp0
     inc $54C
     inc $550
     inc $540
     inc $544
     dec $543
     dec $54F
     dec $547
     dec $553
     JMP test1

        test1:
     lda sp1         ; for sprite 2,5
     inc sp1
     cmp #30
     BEQ new1
     BNE old1

      old1:
     dec $548
     dec $554
     inc $54B
     inc $557
     JMP test2

     new1:
     dec sp1
     inc $554
     inc $548
     inc $54B
     inc $557
     JMP test2

  over11: JMP over1


     test2:           ; for sprite 6,9
     inc $564
     inc $558
     dec $55B
     dec $567
     JMP test3


     test3:
     inc $560
     inc $56C
     inc $55C
     inc $568
     inc $563
     inc $56F
     inc $55F
     inc $56B
     JMP test4

     test4:        ; for sprites 12,15,18
     inc $588
     inc $57C
     inc $570
     inc $588
     inc $57C
     inc $570
     dec $573
     dec $57F
     dec $58B
     JMP test5

     test5:      ; for sprites 13,16,19
     inc $574
     inc $580
     inc $58C
     JMP test6


     test6:       ; for sprites 14,17,20
     inc $590
     inc $584
     inc $578
     inc $590
     inc $584
     inc $578
     inc $57B
     inc $587
     inc $593
     JMP clear0


 ;; Now the below code is for clearing the sprites once the touch the boundary of the screen. Here we are testing
 ; the x and y position of the rock tiles with the boundary of the screen. if they match, clear that much sprites from memory


     clear0:    ; for testing the boundary for sprite 0,1,3,4

     LDY ybottom
     LDX xright
     CPY $54C
     BEQ ClearSprites0
     CPX $54F
     BEQ ClearSprites0
     JMP clear1

ClearSprites0:
      lda #$1F
      sta $541
      sta $545
      sta $54D
      sta $551

lda #0
sta blastrock
sta blastsoldier

      ;--------------

     clear1:   ; for testing the boundary for sprite 2,5
     LDY ybottom
     LDX xright
     CPY $554
     BEQ ClearSprites1
     CPX $557
     BEQ ClearSprites1
     JMP clear2

ClearSprites1:
 lda #$1f
 sta $549
 sta $555
      clear2:   ; for testing the boundary for sprite 6,9
     LDY ybottom
     LDX xright
     CPY $564
     BEQ ClearSprites2
     CPX $567
     BEQ ClearSprites2
     JMP clear3

ClearSprites2:
lda #$1f
sta $559
sta $565

      ;--------------

     clear3:   ; for testing the boundary for sprite 7,8,10,11
     LDY ybottom
     LDX xright
     CPY $56C
     BEQ ClearSprites3
     CPX $56F
     BEQ ClearSprites3
     JMP clear4


ClearSprites3:
lda #$1F
sta $55D
sta $561
sta $569
sta $56D
      ;--------------

     clear4:   ; for testing the boundary for sprite 12,15,18
     LDY ybottom
     LDX xright
     CPY $588
     BEQ ClearSprites4
     CPX $58B
     BEQ ClearSprites4
     JMP clear5


ClearSprites4:
lda #$1f
sta $571
sta $57D
sta $589

      ;--------------


     clear5:   ; for testing the boundary for sprite 13,16,19
     LDY ybottom
     LDX xright
     CPY $58C
     BEQ ClearSprites5
     CPX $58F
     BEQ ClearSprites5
     JMP clear6

ClearSprites5:
lda #$1f
sta $575
sta $581
sta $58D

     clear6:   ; for testing the boundary for sprite 14,17,20
     LDY ybottom
     LDX xright
     CPY $590
     BEQ ClearSprites6
     CPX $593
     BEQ ClearSprites6
     JMP over1


ClearSprites6:
lda #$1f
sta $579
sta $585
sta $591



over1:
        RTS

;;;;;;;;;;;;;;;;;;;;;;;;

bsoldier:
jmp brock

bsnake:
;;; put here the animation of snake...

rts
;       -------------------------------------------------
clearing_letters:                                  ;;;; clearing the letters
                 lda trigger2                ;;;; checking trigger
                 cmp #1
                 beq @stop
                 rts
@stop:
     ;lda #%00000000             ;off the screen
     ;sta $2001

     LDA $2002             ; read PPU status to reset the high/low latch
     LDA #$23
     STA $2006             ; write the high byte of $2000 address
     LDA #$6b
     STA $2006

@stop1:
      lda #$FD
      sta $2007            ;we are stoaring a character in address 0595+y
      inc ttempx
      lda #16  ;loading length of the word in accumulator
      cmp ttempx                ;comparing the value of x with the value stored in accumulator
      bne @stop1

      ;lda #%00011110
      ;sta $2001
      lda PPUCRTL
      sta $2000
      lda scroll_h
      sta $2005
      lda scroll_v
      sta $2005
      sta trigger2
      sta ttempx
      ;lda #1
      ;sta trigger
      RTS

;                -----------------------------------------------------
loading_letters:              ;;;; loading the first letter

                lda trigger
                cmp #1
                beq @start
                rts

@start:
                ldy wn
                ;lda #%00000000             ;off the screen
                ;sta $2001

                LDA $2002             ; read PPU status to reset the high/low latch
                LDA #$23
                STA $2006             ; write the high byte of $2000 address
                LDA #$6c
                STA $2006

                            ; write the low byte of $2000 address
@start1:
                ldx total_letters
                lda word1,x
                sta $2007             ;we are stoaring a character in address 0595+y
                inc ttempx
                inc total_letters
                lda NumberofLetters,y  ;loading length of the word in accumulator
                cmp ttempx                ;comparing the value of x with the value stored in accumulator
                bne @start1

                ;lda #%00011110
                ;sta $2001
                lda PPUCRTL
      sta $2000
      lda scroll_h
      sta $2005
      lda scroll_v
      sta $2005
                sta ttempx
                sta trigger
                lda #1
                sta trigger0

                RTS

;       ----------------------------------------------------
loading_letters2:                          ;;;;; loading second word
                 lda trigger0
                 cmp #1
                 beq @start0
                 rts

@start0:
                ldy wn
                ;lda #%00000000             ;off the screen
                ;sta $2001

                LDA $2002             ; read PPU status to reset the high/low latch
                LDA #$23
                STA $2006             ; write the high byte of $2000 address
                LDA #$74
                STA $2006

                            ; write the low byte of $2000 address
@start01:
                ldx total_letters0
                lda word2,x
                sta $2007             ;we are stoaring a character in address 0595+y
                inc ttempx
                inc total_letters0
                lda NumberofLetters1,y  ;loading length of the word in accumulator
                cmp ttempx                ;comparing the value of x with the value stored in accumulator
                bne @start01

                ;lda #%00011110
                ;sta $2001
                lda PPUCRTL
      sta $2000
      lda scroll_h
      sta $2005
      lda scroll_v
      sta $2005
                sta ttempx
                sta trigger0

                RTS
;       ---------------------------------------------------
delay_typing_lol:                                  ;;;;;;for checking the second word delay
      lda trig_delay
      cmp #1
      beq @start_delay
      rts
@start_delay:
            inc delay_cal_quiz
            lda delay_cal_quiz
            cmp #180
            beq @lol
            rts
@lol:
    lda #0
    sta delay_cal_quiz
    ldy wordnum
    lda level_change
    cmp #2
    bne @p11
    ldx NumberofLetters,y
    jmp @p41
@p11:
    cmp #3
    bne @p41
    ldx NumberofLetters_snow,y
@p41:
    lda wl
    cmp #0
    beq @loop_w1
@loop_w2:
        dec pointer0
        dec wl
        lda wl
        cmp #0
        bne @loop_w2
        lda #0
        sta lower_byte

@loop_w1:
        dec pointer
        dex
        cpx #0
        bne @loop_w1
        lda #0
        sta lower_byte
        sta var01
        sta wl
        sta trig_delay
        sta var1
        sta Current
        lda #1
        sta under2
        sta var_new

        lda level_change
        cmp #2
        bne @p1
        lda #1
        sta key_fun2
        jsr load_a1
        LDA #$09
        JSR setCHRPage1000
        jmp @p4
@p1:
        lda level_change
        cmp #3
        bne @p4
        lda #1
        sta trig_hit
        lda #$0c
        jsr setCHRPage1000
        jsr load_snow1
@p4:
        rts
;       ---------------------------------------------------



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
loading_underlines:                       ;;;;;;loading underline for the first word
                   lda under
                   cmp #1
                   beq @under_jmp
                   rts
@under_jmp:
          ;lda #%00000000             ;off the screen
          ;sta $2001
          ldy lower_byte
          lda #$A0
          LDA $2002             ; read PPU status to reset the high/low latch
          LDA #$23
          STA $2006             ; write the high byte of $2000 address
          LDA Lower_byte_pal1,y
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
          sta under
          rts
;       ---------------------------------------------------
loading_underlines1:                       ;;;;;;;;loading underline for the second word
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
clearing_underlines:                    ;;;;;;;;;;;clearing underlines
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
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;         ;
 projectile1:                        ;;;;;;;;;;projectile motion for hanuman
           lda tri
           cmp #1
           bne @T




           INC varP
           lda varP
           CMP #1
           BNE @T
           LDA #$00
           STA varP


           lda co
           cmp #12
           bne @kaka
           lda #1
           sta pro2

@kaka:
           lda co
           cmp #26
           bne @ggh
           lda #1
           sta tri1

           lda #0
           sta tri

           sta co
           jsr projectile2

    @T:     rts

      @ggh: inc co
           dec $500
           dec $503
           dec $503
           dec $503

           dec $504
           dec $507
           dec $507
           dec $507

           dec $508
           dec $50B
           dec $50B
           dec $50B

           dec $50C
           dec $50f
           dec $50f
           dec $50f

           dec $510
           dec $513
           dec $513
           dec $513

           dec $514
           dec $517
           dec $517
           dec $517

           dec $518
           dec $51B
           dec $51B
           dec $51B

           dec $51C
           dec $51f
           dec $51f
           dec $51f

           dec $520
           dec $523
           dec $523
           dec $523

           dec $524
           dec $527
           dec $527
           dec $527

           dec $528
           dec $52B
           dec $52B
           dec $52B

           dec $52C
           dec $52f
           dec $52f
           dec $52f

           dec $530
           dec $533
           dec $533
           dec $533

           dec $534
           dec $537
           dec $537
           dec $537

           dec $538
           dec $53B
           dec $53B
           dec $53B

           dec $53C
           dec $53f
           dec $53f
           dec $53f


           rts

  projectile2:

           lda tri1
           cmp #1
           bne @T1

           INC varP
           lda varP
           CMP #2
           BNE @T1
           LDA #$00
           STA varP

           lda co1
           cmp #4
           bne @ggh1

           lda #1
           sta tri2

           lda #0
           sta tri1
           sta co1
           jsr projectile3

    @T1:     rts

      @ggh1: inc co1

           dec $503
           dec $503
           dec $503


           dec $507
           dec $507
           dec $507


           dec $50B
           dec $50B
           dec $50B


           dec $50f
           dec $50f
           dec $50f


           dec $513
           dec $513
           dec $513


           dec $517
           dec $517
           dec $517


           dec $51B
           dec $51B
           dec $51B


           dec $51f
           dec $51f
           dec $51f


           dec $523
           dec $523
           dec $523


           dec $527
           dec $527
           dec $527


           dec $52B
           dec $52B
           dec $52B


           dec $52f
           dec $52f
           dec $52f


           dec $533
           dec $533
           dec $533


           dec $537
           dec $537
           dec $537


           dec $53B
           dec $53B
           dec $53B


           dec $53f
           dec $53f
           dec $53f


           rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 projectile3:
           lda tri2
           cmp #1
           bne @T2

           INC varP
           lda varP
           CMP #1
           BNE @T2
           LDA #$00
           STA varP

           lda co2
           cmp #12
           bne @ka1

           lda #0
           sta pro2
           lda #1
           sta pro3

      @ka1: lda co2
           cmp #26
           bne @ggh2
           lda #0
           sta tri2

           sta co2
           sta pro2
           ;lda #1
           ;sta var01
           lda level_change
           cmp #2
           bne @p1
           lda #1
           sta key
           LDA #$07
           JSR setCHRPage1000
           jmp @T2
@p1:
           lda level_change
           cmp #3
           bne @T2
           lda #1
           sta trig_static
           lda #$0b
           jsr setCHRPage1000

    @T2:     rts

      @ggh2: inc co2
           inc $500
           dec $503
           dec $503
           dec $503

           inc $504
           dec $507
           dec $507
           dec $507

           inc $508
           dec $50B
           dec $50B
           dec $50B

           inc $50C
           dec $50f
           dec $50f
           dec $50f

           inc $510
           dec $513
           dec $513
           dec $513

           inc $514
           dec $517
           dec $517
           dec $517

           inc $518
           dec $51B
           dec $51B
           dec $51B

           inc $51C
           dec $51f
           dec $51f
           dec $51f

           inc $520
           dec $523
           dec $523
           dec $523

           inc $524
           dec $527
           dec $527
           dec $527

           inc $528
           dec $52B
           dec $52B
           dec $52B

           inc $52C
           dec $52f
           dec $52f
           dec $52f

           inc $530
           dec $533
           dec $533
           dec $533

           inc $534
           dec $537
           dec $537
           dec $537

           inc $538
           dec $53B
           dec $53B
           dec $53B

           inc $53C
           dec $53f
           dec $53f
           dec $53f


           rts

 ;;;;;;;;;;;;;;;;;;;;;;;;;;
 load_proj1:    lda #$80
                sta $501

                lda #$81
                sta $505

                lda #$82
                sta $509

                lda #$1F
                sta $50D

                lda #$90
                sta $511

                lda #$91
                sta $515

                lda #$92
                sta $519

                lda #$1F
                sta $51D

                lda #$A0
                sta $521

                lda #$A1
                sta $525

                lda #$A2
                sta $529

                lda #$A3
                sta $52D

                lda #$B0
                sta $531

                lda #$B1
                sta $535

                lda #$B2
                sta $539

                lda #$B3
                sta $53D

                rts



 load_proj2:
                lda #$84
                sta $501

                lda #$85
                sta $505

                lda #$86
                sta $509

                lda #$1F
                sta $50D

                lda #$94
                sta $511

                lda #$95
                sta $515

                lda #$96
                sta $519

                lda #$97
                sta $51D

                lda #$A4
                sta $521

                lda #$A5
                sta $525

                lda #$A6
                sta $529

                lda #$1F
                sta $52D

                lda #$B4
                sta $531

                lda #$B5
                sta $535

                lda #$B6
                sta $539

                lda #$B7
                sta $53D


            rts

 load_proj3:
                lda #$88
                sta $501

                lda #$89
                sta $505

                lda #$8A
                sta $509

                lda #$8B
                sta $50D

                lda #$98
                sta $511

                lda #$99
                sta $515

                lda #$9A
                sta $519

                lda #$9B
                sta $51D

                lda #$A8
                sta $521

                lda #$A9
                sta $525

                lda #$AA
                sta $529

                lda #$AB
                sta $52D

                lda #$B8
                sta $531

                lda #$B9
                sta $535

                lda #$1F
                sta $539

                lda #$1F
                sta $53D


                rts


 load_proj4:
                lda #$1F
                sta $501

                lda #$1F
                sta $505

                lda #$8E
                sta $509

                lda #$8F
                sta $50D

                lda #$9C
                sta $511

                lda #$9D
                sta $515

                lda #$9E
                sta $519

                lda #$9F
                sta $51D

                lda #$AC
                sta $521

                lda #$AD
                sta $525

                lda #$AE
                sta $529

                lda #$AF
                sta $52D

                lda #$BC
                sta $531

                lda #$BD
                sta $535

                lda #$BE
                sta $539

                lda #$BF
                sta $53D


                rts

 trigger_proj1:

       lda pro1
       cmp #1
       bne @gg66

lda level_change                ;;;;; to change the chr page for walking of hanuman with rock
cmp #2
bne @p1
LDA #$07                       ;;;;;; chr page with hanuman walking frames and rock
JSR setCHRPage1000
jmp @p4
@p1:
cmp #3
bne @p4
LDA #$0b
JSR setCHRPage1000
@p4:
        LDA md1
        CMP #10
        BEQ @lvv1
        inc md1

        jsr load_proj1
        rts

   @lvv1:lda #0
       sta md1
       sta pro1
      ; jsr load_proj1
       lda #1
       sta tri

      ; sta pro2

@gg66:     RTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 trigger_proj2:

       lda pro2
       cmp #1
       bne @gg2

        jsr load_proj2
  @gg2:     RTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
trigger_proj3:

       lda pro3
       cmp #1
       bne @gg3

        LDA md2
        CMP #45
        BEQ @lv3
        inc md2

        jsr load_proj3
        rts

   @lv3:lda #0
       sta md2
       sta pro3
       lda #1
       sta pro4

  @gg3:     RTS
 ;;;;;;;;;;;;;;;;;;;;;;;;;;
 trigger_proj4:

       lda pro4
       cmp #1
       bne @gg4

        LDA md3
        CMP #50
        BEQ @lv4
        inc md3

        jsr load_proj4
        rts

   @lv4:lda #0
       sta md3
       sta pro4

       jsr walk_mov1
  @gg4:     RTS


 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;     first rock level code
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Compare_0:
lda var_new
cmp #1
beq @com_jmp
rts
@com_jmp:
LDA var1
cmp #1
beq @c
ldy pointer     ; it points to current letter that should be pressed by the user. pointer is a number. we will load the letter from library
ldx Current     ; this stores the current letter pressed by the user
lda word_rock,y   ; load the expected letter into accumaltor
cmp Current  ;        compare with the currently pressed letter
beq @Found              ; correct letter is pressed
lda #0
sta Current

@c:
   RTS

@Found:
         lda #0
         sta ps2
         ;jsr arrow11
         lda #0
         sta Current
         lda #1
         sta under
         inc wl                          ; this will increse the wl. So if "RO" are pressed then wl = 2 and if "C" is pressed then wl=3
         ldx wl                          ; is the current lenght of the letters pressed of a word
                        ; level number. - how many words r completed for "ROCK" it is wordnum = 1
                        ldy wordnum
                        lda NumberofLetters_rock,y           ; load the no.of letters in word. here for rock,it will load 4
                        sta ww
                        inc pointer                     ; increment pointer so now it points to the next correct letter




    LDA #$01
    STA varX
    STA var1
    jsr map
    ldy wordnum
    lda NumberofLetters_rock,y
    sta ww                          ; this loads that word 1 has how many letters . 4 will be loaded
    cmp wl                          ; compare with current lenght of the current word.
    BEQ @newword                     ; ie wordnum is 1. so lda will be 4. wl is 4 then new word
    RTS

@newword:

         lda #0
         sta wl              ; now wl is reset to zero.
         sta var_new
         lda #1
         sta clearing_byte
         sta k
         RTS
;       -----------------------------------------------------
        ;     hanuman hitting rock
;       -----------------------------------------------------

;       --------------------------------------------------------

;       -----------------------------------------------------------

loading_letters_0:

                lda trigger
                cmp #1
                beq @start
                rts

@start:
                ldy wn
                ;lda #%00000000             ;off the screen
                ;sta $2001

                LDA $2002             ; read PPU status to reset the high/low latch
                LDA #$23
                STA $2006             ; write the high byte of $2000 address
                LDA #$6c
                STA $2006

                            ; write the low byte of $2000 address
@start1:
                ldx total_letters
                lda word_rock,x
                sta $2007             ;we are stoaring a character in address 0595+y
                inc ttempx
                inc total_letters
                lda NumberofLetters_rock,y  ;loading length of the word in accumulator
                cmp ttempx                ;comparing the value of x with the value stored in accumulator
                bne @start1

                lda PPUCRTL
      sta $2000
      lda scroll_h
      sta $2005
      lda scroll_v
      sta $2005
                sta ttempx
                sta trigger

                RTS

;       -----------------------------------------------------
        ;     hanuman hitting soldier
;       -----------------------------------------------------
Compare_1:
lda var_new
cmp #1
beq @com_jmp
rts
@com_jmp:
LDA var1
cmp #1
beq @c
ldy pointer     ; it points to current letter that should be pressed by the user. pointer is a number. we will load the letter from library
ldx Current     ; this stores the current letter pressed by the user
lda word_soldier,y   ; load the expected letter into accumaltor
cmp Current  ;        compare with the currently pressed letter
beq @Found              ; correct letter is pressed
lda #0
sta Current

@c:
   RTS

@Found:
         lda #0
         sta ps2
         ;jsr arrow11
         lda #0
         sta Current
         lda #1
         sta under
         inc wl                          ; this will increse the wl. So if "RO" are pressed then wl = 2 and if "C" is pressed then wl=3
         ldx wl                          ; is the current lenght of the letters pressed of a word
                        ; level number. - how many words r completed for "ROCK" it is wordnum = 1
                        ldy wordnum
                        lda NumberofLetters_soldier,y           ; load the no.of letters in word. here for rock,it will load 4
                        sta ww
                        inc pointer                     ; increment pointer so now it points to the next correct letter




    LDA #$01
    STA varX
    STA var1
    jsr map
    ldy wordnum
    lda NumberofLetters_soldier,y
    sta ww                          ; this loads that word 1 has how many letters . 4 will be loaded
    cmp wl                          ; compare with current lenght of the current word.
    BEQ @newword                     ; ie wordnum is 1. so lda will be 4. wl is 4 then new word
    RTS

@newword:

         lda #0
         sta wl              ; now wl is reset to zero.
         sta var_new
         lda #1
         sta clearing_byte
         sta k
         RTS
;       -----------------------------------------------------
        ;     hanuman hitting soldier
;       -----------------------------------------------------

;       --------------------------------------------------------

;       -----------------------------------------------------------

loading_letters_1:

                lda trigger
                cmp #1
                beq @start
                rts

@start:
                ldy wn
                ;lda #%00000000             ;off the screen
                ;sta $2001

                LDA $2002             ; read PPU status to reset the high/low latch
                LDA #$23
                STA $2006             ; write the high byte of $2000 address
                LDA #$6c
                STA $2006

                            ; write the low byte of $2000 address
@start1:
                ldx total_letters
                lda word_soldier,x
                sta $2007             ;we are stoaring a character in address 0595+y
                inc ttempx
                inc total_letters
                lda NumberofLetters_soldier,y  ;loading length of the word in accumulator
                cmp ttempx                ;comparing the value of x with the value stored in accumulator
                bne @start1

                lda PPUCRTL
      sta $2000
      lda scroll_h
      sta $2005
      lda scroll_v
      sta $2005
                sta ttempx
                sta trigger

                RTS


;       ---------------------------------------------------------
;;;;;   -------------------------------------------------------------
;;;     Code for snow monster
;;;;;   -------------------------------------------------------------

Compare1_3:
lda var_new
cmp #1
beq @com_jmp
rts
@com_jmp:
LDA var1
cmp #1
beq @c
ldy pointer     ; it points to current letter that should be pressed by the user. pointer is a number. we will load the letter from library
ldx Current     ; this stores the current letter pressed by the user
lda word_snow,y   ; load the expected letter into accumaltor
cmp Current  ;        compare with the currently pressed letter
beq @Found              ; correct letter is pressed
lda #0
sta Current
;bne c                ; incorrect is pressed
@c:RTS

@Found:
 ;;;;;;;;
         lda #0
         sta ps2
         ;jsr arrow11
         lda #0
         sta Current
   lda #1
   sta under
   inc wl                          ; this will increse the wl. So if "RO" are pressed then wl = 2 and if "C" is pressed then wl=3
   ldx wl                          ; is the current lenght of the letters pressed of a word
                        ; level number. - how many words r completed for "ROCK" it is wordnum = 1
   ldy wordnum
   lda NumberofLetters_snow,y           ; load the no.of letters in word. here for rock,it will load 4
   sta ww
   inc pointer                     ; increment pointer so now it points to the next correct letter


    LDA #$01
    STA varX

    STA var1
    jsr map
    ldy wordnum
    lda NumberofLetters_snow,y
    sta ww                          ; this loads that word 1 has how many letters . 4 will be loaded
    cmp wl                          ; compare with current lenght of the current word.
    BEQ @newword                     ; ie wordnum is 1. so lda will be 4. wl is 4 then new word



    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@newword:
        ;  LDA #$01
        ;  STA k
        ;  sta key
        ;  LDA #$05
        ;  sta hitrock             ; new word has been encountered. hence now the rock will break and scrolling will start
         ; LDA #10
         ; STA scroll_status


         lda #0
         ;sta lower_byte
         sta wl              ; now wl is reset to zero. wl keeps the no. of letters pressed by user for current word
         sta delay_cal_quiz
         sta trig_static
         ;sta var1
         sta var_new
         ;inc wordnum         ; so we have gone to next level. hence next word
         lda #1
         sta var01

         sta trig_delay
         sta clearing_byte
         ;jsr mon_1
         RTS

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Compare2_3:
         LDA var01
         cmp #$01
         beq @c0
         rts
@c0:
         ldy pointer0     ; it points to current letter that should be pressed by the user. pointer is a number. we will load the letter from library
         ldx Current     ; this stores the current letter pressed by the user
         lda word_snow2,y   ; load the expected letter into accumaltor
         cmp Current  ;        compare with the currently pressed letter
         beq @Found0              ; correct letter is pressed
         lda #0
         sta Current

         RTS
@Found0:
       lda #0
       sta Current
       
       LDA #$01
       STA k
       ;LDA #$03
       ;JSR setCHRPage1000
       inc wl                          ; this will increse the wl. So if "RO" are pressed then wl = 2 and if "C" is pressed then wl=3
       ldx wl                          ; is the current lenght of the letters pressed of a word
                           ; level number. - how many words r completed for "ROCK" it is wordnum = 1
       ;lda NumberofLetters1,y           ; load the no.of letters in word. here for rock,it will load 4
       ;sta ww
       inc pointer0                     ; increment pointer so now it points to the next correct letter
       lda #0
       sta delay_cal_quiz



   ;jump walking code
    ;lda $05
    ;sta walk
   ;JMP cont

    LDA #$01
    sta under1
    ;STA varX
    lda #0
    STA var1
    ;jsr map
    ldy wordnum
    lda NumberofLetters1_snow2,y
    ;sta ww                          ; this loads that word 1 has how many letters . 4 will be loaded
    cmp wl                          ; compare with current lenght of the current word.
    BEQ @newword0                     ; ie wordnum is 1. so lda will be 4. wl is 4 then new word



    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@newword0:
          LDA #$01
          STA k
          sta mx
         ; sta key
          LDA #$05
          sta hitrock             ; new word has been encountered. hence now the rock will break and scrolling will start



         lda #0
         sta wl              ; now wl is reset to zero. wl keeps the no. of letters pressed by user for current word
         sta var01
         sta trig_delay
         ;sta lower_byte
         ;inc wordnum         ; so we have gone to next level. hence next word
         ;lda #1
         ;sta trigger2
         RTS

;       -------------------------------------------------------------

;        ----------------------------------------------------------

;        -------------------------------------------------------------

loading_letters_3:

                lda trigger
                cmp #1
                beq @start
                rts

@start:
                ldy wn
                ;lda #%00000000             ;off the screen
                ;sta $2001

                LDA $2002             ; read PPU status to reset the high/low latch
                LDA #$23
                STA $2006             ; write the high byte of $2000 address
                LDA #$6c
                STA $2006

                            ; write the low byte of $2000 address
@start1:
                ldx total_letters
                lda word_snow,x
                sta $2007             ;we are stoaring a character in address 0595+y
                inc ttempx
                inc total_letters
                lda NumberofLetters_snow,y  ;loading length of the word in accumulator
                cmp ttempx                ;comparing the value of x with the value stored in accumulator
                bne @start1

                ;lda #%00011110
                ;sta $2001
                lda PPUCRTL
      sta $2000
      lda scroll_h
      sta $2005
      lda scroll_v
      sta $2005
                sta ttempx
                sta trigger
                lda #1
                sta trigger0

                RTS

;       ----------------------------------------------------
loading_letters2_3:
                 lda trigger0
                 cmp #1
                 beq @start0
                 rts

@start0:
                ldy wn
                ;lda #%00000000             ;off the screen
                ;sta $2001

                LDA $2002             ; read PPU status to reset the high/low latch
                LDA #$23
                STA $2006             ; write the high byte of $2000 address
                LDA #$74
                STA $2006

                            ; write the low byte of $2000 address
@start01:
                ldx total_letters0
                lda word_snow2,x
                sta $2007             ;we are stoaring a character in address 0595+y
                inc ttempx
                inc total_letters0
                lda NumberofLetters1_snow2,y  ;loading length of the word in accumulator
                cmp ttempx                ;comparing the value of x with the value stored in accumulator
                bne @start01

                ;lda #%00011110
                ;sta $2001
                lda PPUCRTL
      sta $2000
      lda scroll_h
      sta $2005
      lda scroll_v
      sta $2005
                sta ttempx
                sta trigger0

                RTS
;
clear_rock:

      lda #$05
      sta hitrock
      lda #1
      sta blastrock
      rts
;      -------------------------------------------------------------------
clear_snow:
           lda #$1F
           ldx #0
@loop:
       sta $541,x
       inx
       inx
       inx
       inx
       cpx #200
       bne @loop
       rts
;      -----------------------------------------------------
ClearSprites111:
                lda #0
                sta color1
                ;lda #9
                ;sta cs
      STA $500, x
      INX
      BNE ClearSprites111
      rts


loading_snake:
        lda #$00
       ; sta color
        sta sp0
        sta sp1

jsr ClearSprites111

LoadSprites111:
      LDX #$00
      LDY #$00

   LoadSpritesLoop111:
     LDA sprites_snake,x            ; load data from address (sprites + x)
     STA $0540,x              ; store into RAM address ($0200 + x)
     INX                       ; X = X + 1
     CPX #64
                        ; Compare X to # of values (divide by 4 for total # of sprites)
     BNE LoadSpritesLoop111       ; Branch to LoadSpritesLoop if compare was Not Equal to zero
     jsr load_hanuman
                               ; if compare was equal to 32, keep going down
     RTS
     ;       ----------------------------------------------------
load_hanuman:

      LDX #$00
      LDY #$00

   @LoadSpritesLoop111:
     LDA hanuman_sprites,x            ; load data from address (sprites + x)
     STA $0500,x              ; store into RAM address ($0200 + x)
     INX                       ; X = X + 1
     CPX #64
                        ; Compare X to # of values (divide by 4 for total # of sprites)
     BNE @LoadSpritesLoop111       ; Branch to LoadSpritesLoop if compare was Not Equal to zero
     rts
     ;       -----------------------------------------------------
loading_rock:
        lda #$00
       ; sta color
        sta sp0
        sta sp1

jsr ClearSprites111

@LoadSprites111:
      LDX #$00
      LDY #$00

   @LoadSpritesLoop111:
     LDA sprites_rock,x            ; load data from address (sprites + x)
     STA $0540,x              ; store into RAM address ($0200 + x)
     INX                       ; X = X + 1
     CPX #84
                        ; Compare X to # of values (divide by 4 for total # of sprites)
     BNE @LoadSpritesLoop111       ; Branch to LoadSpritesLoop if compare was Not Equal to zero

     jsr load_hanuman

                               ; if compare was equal to 32, keep going down
     RTS
     ;       ------------------------------------------------------
loading_soldier:
        lda #$00
       ; sta color
        sta sp0
        sta sp1

jsr ClearSprites111

@LoadSprites111:
      LDX #$00
      LDY #$00

   @LoadSpritesLoop111:
     LDA sprites_soldier,x            ; load data from address (sprites + x)
     STA $0540,x              ; store into RAM address ($0200 + x)
     INX                       ; X = X + 1
     CPX #116
                        ; Compare X to # of values (divide by 4 for total # of sprites)
     BNE @LoadSpritesLoop111       ; Branch to LoadSpritesLoop if compare was Not Equal to zero
     jsr load_hanuman
                               ; if compare was equal to 32, keep going down
     RTS
     ;       -----------------------------------------------------
loading_snow:
        lda #$00
       ; sta color
        sta sp0
        sta sp1

jsr ClearSprites111

@LoadSprites111:
      LDX #$00
      LDY #$00

   @LoadSpritesLoop111:
     LDA sprites_snow,x            ; load data from address (sprites + x)
     STA $0540,x              ; store into RAM address ($0200 + x)
     INX                       ; X = X + 1
     CPX #64
                        ; Compare X to # of values (divide by 4 for total # of sprites)
     BNE @LoadSpritesLoop111       ; Branch to LoadSpritesLoop if compare was Not Equal to zero
     jsr load_hanuman
                               ; if compare was equal to 32, keep going down
     RTS
;    ----------------------------------------------------------------------------------------
snow_monster_static:

            lda trig_static
            cmp #1
            bne @bhk

           INC varB
           lda varB
           CMP #12
           BNE @bhk
           LDA #$00
           STA varB

            lda bh
            cmp #0
            bne @hb1
            jsr load_snow1
            lda #1
            sta bh
            rts

    @hb1:   jsr load_snow4
            lda #0
            sta bh
   @bhk:     rts
;    -----------------------------------------------------------------------------------------
load_snow1:

       lda #$1f
       sta $541

       lda #$c3
       sta $545

       lda #$c4
       sta $549

       lda #$c5
       sta $54D

       lda #$1f
       sta $551

       lda #$D3
       sta $555

       lda #$d4
       sta $559

       lda #$d5
       sta $55D

       lda #$1f
       sta $561

       lda #$E3
       sta $565

       lda #$E4
       sta $569

       lda #$e5
       sta $56D

       lda #$1f
       sta $571

       lda #$F3
       sta $575

       lda #$F4
       sta $579

       lda #$f5
       sta $57D

       rts

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ch4
 load_snow2:

       lda #$1f
       sta $541

       lda #$C6
       sta $545

       lda #$C7
       sta $549

       lda #$c8
       sta $54D

       lda #$1f
       sta $551

       lda #$D6
       sta $555

       lda #$D7
       sta $559

       lda #$d8
       sta $55D

       lda #$1f
       sta $561

       lda #$E6
       sta $565

       lda #$E7
       sta $569

       lda #$e8
       sta $56D

       lda #$1f
       sta $571

       lda #$F6
       sta $575

       lda #$F7
       sta $579

       lda #$f8
       sta $57D

       rts


 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ch2
  load_snow3:

       lda #$c9
       sta $541

       lda #$Ca
       sta $545

       lda #$Cb
       sta $549

       lda #$Cc
       sta $54D

       lda #$d9
       sta $551

       lda #$Da
       sta $555

       lda #$Db
       sta $559

       lda #$Dc
       sta $55D

       lda #$E9
       sta $561

       lda #$Ea
       sta $565

       lda #$Eb
       sta $569

       lda #$Ec
       sta $56D

       lda #$F9
       sta $571

       lda #$Fa
       sta $575

       lda #$Fb
       sta $579

       lda #$Fc
       sta $57D

       rts

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ch1
 load_snow4:

       lda #$1f
       sta $541

       lda #$Cd
       sta $545

       lda #$Ce
       sta $549

       lda #$cf
       sta $54D

       lda #$1f
       sta $551

       lda #$dd
       sta $555

       lda #$De
       sta $559

       lda #$df
       sta $55D

       lda #$1f
       sta $561

       lda #$ed
       sta $565

       lda #$ee
       sta $569

       lda #$eF
       sta $56D

       lda #$1f
       sta $571

       lda #$fd
       sta $575

       lda #$fe
       sta $579

       lda #$ff
       sta $57D

       rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
load_snow5:

       lda #$8c
       sta $541

       lda #$8d
       sta $545

       lda #$8e
       sta $549

       lda #$8f
       sta $54D

       lda #$9c
       sta $551

       lda #$9D
       sta $555

       lda #$9E
       sta $559

       lda #$9F
       sta $55D

       lda #$AC
       sta $561

       lda #$AD
       sta $565

       lda #$AE
       sta $569

       lda #$AF
       sta $56D

       lda #$BC
       sta $571

       lda #$BD
       sta $575

       lda #$BE
       sta $579

       lda #$BF
       sta $57D

       rts
;;;    -------------------------------------------------------------------
snow_monster_hit:

            lda trig_hit
            cmp #1
            bne bhk1

           jsr load_a1
           INC varB1
           lda varB1
           CMP #5
           BNE bhk1
           LDA #$00
           STA varB1

           inc be1


            lda bh1
            cmp #0
            bne hb2
            jsr load_snow2
            lda #1
            sta bh1

            rts

    hb2:   jsr load_snow3
            lda #0
            sta bh1
            lda be1
            cmp #12
            beq omg1
   bhk1:     rts

   omg1:  jsr load_snow1
          lda #0
          sta trig_hit
          sta be1
          lda #1
          sta pro1
          sta hanu_pal
          rts
;         ------------------------------------------------
update2:

	lda trig_sol
	cmp #1
	bne @sk3

	  INC varS
          lda varS
           CMP #12
           BNE @sk3
           LDA #0
           STA varS


 @sk :lda var_sol
     cmp #0
     bne @sk1
     jsr sol_mov1
     lda #200
     sta varS
     lda #1
     sta var_sol
     rts

 @sk1: lda var_sol
     cmp #1
     bne @sk2
     jsr sol_mov2
     lda #2
     sta var_sol
     rts

 @sk2:lda var_sol
     cmp #2
     bne @sk3
     jsr sol_mov3
  ;   lda #200
  ;   sta varS
     lda #0
     sta var_walk
     sta var_sol

 @sk3:rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sol_mov1:
	lda #$9a
	sta $541
	lda #$9b
	sta $545
	lda #$9c
	sta $549
	lda #$aa
	sta $54d
	lda #$ab
	sta $551
	lda #$ac
	sta $555
	lda #$ba
	sta $559
	lda #$bb
	sta $55d
	lda #$bc
	sta $561
	lda #$ca
	sta $565
	lda #$cb
	sta $569
	lda #$cc
	sta $56d
	lda #$da
	sta $571
	lda #$db
	sta $575
	lda #$dc
	sta $579
	lda #$ea
	sta $57d
	lda #$eb
	sta $581
	lda #$ec
	sta $585
	lda #$fa
	sta $589
	lda #$fb
	sta $58d
	lda #$fc
	sta $591
	
	lda #$1f
	sta $5a9
	lda #$1f
	sta $5ad
	lda #$1f
	sta $5b1


	lda #$1f
	sta $595
	lda #$1f
	sta $599
	lda #$1f
	sta $59d
	lda #$1f
	sta $5a1
	lda #$1f
	sta $5a5

	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;

sol_mov2:
	lda #$96
	sta $541
	lda #$97
	sta $545
	lda #$98
	sta $549
	lda #$a6
	sta $54d
	lda #$a7
	sta $551
	lda #$a8
	sta $555
	lda #$b6
	sta $559
	lda #$b7
	sta $55d
	lda #$b8
	sta $561
	lda #$c6
	sta $565
	lda #$c7
	sta $569
	lda #$c8
	sta $56d
	lda #$d6
	sta $571
	lda #$d7
	sta $575
	lda #$d8
	sta $579
	lda #$e6
	sta $57d
	lda #$e7
	sta $581
	lda #$e8
	sta $585
	lda #$f6
	sta $589
	lda #$f7
	sta $58d
	lda #$f8
	sta $591
	
	lda #$1f
	sta $5a9
	lda #$1f
	sta $5ad
	lda #$1f
	sta $5b1

	lda #$86
	sta $595
	lda #$87
	sta $599
	lda #$88
	sta $59d
	lda #$89
	sta $5a1
	lda #$8a
	sta $5a5

	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;
sol_mov3:

	lda #$93
	sta $541
	lda #$94
	sta $545
	lda #$95
	sta $549
	lda #$a3
	sta $54d
	lda #$a4
	sta $551
	lda #$a5
	sta $555
	lda #$b3
	sta $559
	lda #$b4
	sta $55d
	lda #$b5
	sta $561
	lda #$c3
	sta $565
	lda #$c4
	sta $569
	lda #$c5
	sta $56d
	lda #$d3
	sta $571
	lda #$d4
	sta $575
	lda #$d5
	sta $579
	lda #$e3
	sta $57d
	lda #$e4
	sta $581
	lda #$e5
	sta $585
	lda #$f3
	sta $589
	lda #$f4
	sta $58d
	lda #$f5
	sta $591


	lda #$b0
	sta $5a9
	lda #$b1
	sta $5ad
	lda #$b2
	sta $5b1

       	lda #$1f
	sta $595
	lda #$1f
	sta $599
	lda #$1f
	sta $59d
	lda #$1f
	sta $5a1
	lda #$1f
	sta $5a5
	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
update3:

	lda trig_smoke
	cmp #1
	bne sm5
	
	lda #0
	sta go
	sta trig_fall
	
	lda #0
	jsr smoke_pallete_change

	  INC varSS
          lda varSS
           CMP #10
           BNE sm5
           LDA #0
           STA varSS


 sm :lda var_smoke
     cmp #0
     bne sm1
     jsr smoke_mov1
     lda #1
     sta var_smoke
     rts

 sm1: lda var_smoke
     cmp #1
     bne sm2
     jsr smoke_mov2
     lda #2
     sta var_smoke
     rts

 sm2:lda var_smoke
     cmp #2
     bne sm3
     jsr smoke_mov3
     lda #3
     sta var_smoke
     rts

 sm3:lda var_smoke
     cmp #3
     bne sm4
     jsr smoke_mov4
     lda #4
     sta var_smoke
     rts

sm4:lda var_smoke
     cmp #4
     bne sm5
     jsr smoke_mov5
     lda #0
     sta var_smoke
     sta trig_smoke
     ;lda random7
     ;cmp #1
     ;beq pop
     lda #10
     sta scroll_status
     lda #2
     jsr smoke_pallete_change
sm5:rts
;pop:
;    lda #0
;    sta random7
;    rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

smoke_mov1:

	lda #$1f
	sta $541
	lda #$1f
	sta $545
	lda #$1f
	sta $549
	lda #$1f
	sta $54d
	lda #$1f
	sta $551
	lda #$91
	sta $555
	lda #$92
	sta $559
	lda #$1f
	sta $55d
	lda #$1f
	sta $561
	lda #$a1
	sta $565
	lda #$a2
	sta $569
	lda #$1f
	sta $56d
	lda #$1f
	sta $571
	lda #$1f
	sta $575
	lda #$1f
	sta $579
	lda #$1f
	sta $57d


	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;

smoke_mov2:

	lda #$88
	sta $541
	lda #$89
	sta $545
	lda #$8a
	sta $549
	lda #$8b
	sta $54d
	lda #$98
	sta $551
	lda #$99
	sta $555
	lda #$9a
	sta $559
	lda #$9b
	sta $55d
	lda #$a8
	sta $561
	lda #$a9
	sta $565
	lda #$aa
	sta $569
	lda #$ab
	sta $56d
	lda #$b8
	sta $571
	lda #$b9
	sta $575
	lda #$ba
	sta $579
	lda #$bb
	sta $57d


	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;
smoke_mov3:

	lda #$84
	sta $541
	lda #$85
	sta $545
	lda #$86
	sta $549
	lda #$87
	sta $54d
	lda #$94
	sta $551
	lda #$95
	sta $555
	lda #$96
	sta $559
	lda #$97
	sta $55d
	lda #$a4
	sta $561
	lda #$a5
	sta $565
	lda #$a6
	sta $569
	lda #$a7
	sta $56d
	lda #$b4
	sta $571
	lda #$b5
	sta $575
	lda #$b6
	sta $579
	lda #$b7
	sta $57d


	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
smoke_mov4:

	lda #$80
	sta $541
	lda #$81
	sta $545
	lda #$82
	sta $549
	lda #$83
	sta $54d
	lda #$90
	sta $551
	lda #$1f
	sta $555
	lda #$1f
	sta $559
	lda #$93
	sta $55d
	lda #$a0
	sta $561
	lda #$1f
	sta $565
	lda #$1f
	sta $569
	lda #$a3
	sta $56d
	lda #$b0
	sta $571
	lda #$b1
	sta $575
	lda #$b2
	sta $579
	lda #$b3
	sta $57d


	rts
;;;;;;;;;;;;;;;;;;;;;;;
smoke_mov5:

	lda #$1f
	sta $541
	lda #$1f
	sta $545
	lda #$1f
	sta $549
	lda #$1f
	sta $54d
	lda #$1f
	sta $551
	lda #$1f
	sta $555
	lda #$1f
	sta $559
	lda #$1f
	sta $55d
	lda #$1f
	sta $561
	lda #$1f
	sta $565
	lda #$1f
	sta $569
	lda #$1f
	sta $56d
	lda #$1f
	sta $571
	lda #$1f
	sta $575
	lda #$1f
	sta $579
	lda #$1f
	sta $57d


	rts
;         ---------------------------------------------------------------------
firstchange:
        ;lda changescreen_var1
        ;cmp #10
        ;bne dwnfornxt
        lda #0
        sta $2001
        LDA #$20                ; draw screen
        STA $2006
        LDA #$00
        STA $2006

        ldy #$00
        ldx #$04

        lda #<snow_typing
        sta $10
        lda #>snow_typing
        sta $11
@NameLoop:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop
        inc $11
        dex
        bne @NameLoop
    ;    lda PPUCRTL
     ;   sta $2000
        lda #30
        sta $2001
         ;sta changescreen_var1
        rts
;       -------------------------------------------------------------
pal_firstchange:
LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
@load_pal:                       ; load palette
        LDA palette_snow_typing,x
        sta $2007
        inx
        cpx #$20
        bne @load_pal
        rts
;       -------------------------------------------------------------
firstchange1:
        ;lda changescreen_var1
        ;cmp #10
        ;bne dwnfornxt
        lda #0
        sta $2001
        LDA #$20                ; draw screen
        STA $2006
        LDA #$00
        STA $2006

        ldy #$00
        ldx #$04

        lda #<snake_typing
        sta $10
        lda #>snake_typing
        sta $11
@NameLoop:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop
        inc $11
        dex
        bne @NameLoop
    ;    lda PPUCRTL
     ;   sta $2000
        lda #30
        sta $2001
         ;sta changescreen_var1
        rts
;       -------------------------------------------------------------
pal_firstchange1:
LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
@load_pal:                       ; load palette
        LDA palette_snake_typing,x
        sta $2007
        inx
        cpx #$20
        bne @load_pal
        rts


     ;       --------------------------------------------------------
smoke_pallete_change:
                     ldx #0
                     ldy #0
                     
                     @loop:
                           sta $542,x
                           inx
                           inx
                           inx
                           inx
                           cpx #16
                           bne @loop
                           rts
;This subroutine is for loading the new word after every scrolling

 ;This fragment of code is added for eliminating unknown sprites that was appearing in the first word
 ;so we are just storing zeroes in the addresses 5A5 to 5AD  for only once when the first word will be loaded.
clearingword1:
                RTS


ResetKeyboard:
  lda #%00000100
  sta $4016
  lda #%00000101
  sta $4016        ;;sets keyboard row/column to 0
  lda #%00000100
  sta $4016
  rts


  ;;
ReadKeyboard:
  ldx #$00                ;;byte counter
ReadKeyboardLoop:
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
  beq ReadKeyboardLoopDone
ReadKeyboardLoopNextRow:
  lda #%00000100          ;;set to low column, increments row
  sta $4016
  jmp ReadKeyboardLoop

ReadKeyboardLoopDone:
  rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ParseKeyboard:
  ldx #$00                  ;;which keyboard byte
ParseKeyboardByteLoop:
  ldy #$00                  ;;which bit in byte to look at
  lda #$01
  sta bitmask               ;;start with lowest bit

ParseKeyboardBitLoop:
  lda $0300, x              ;;get keyboard byte
  and bitmask               ;;mask off all but 1 bit
  beq ParseKeyboardFound    ;;if bit CLEAR, button is DOWN

ParseKeyboardNextBit:
  asl bitmask               ;;go to next bit
  iny                       ;;look at all 8 bits
  cpy #$08
  bne ParseKeyboardBitLoop

ParseKeyboardNextByte:
  inx                       ;;go to next byte
  cpx #$0D                  ;;13 rows
  bne ParseKeyboardByteLoop

ParseKeyboardNotFound:      ;;no keys down were found
  lda #'\0'
;  sta $0501                 ;;set tile to empty
  rts

ParseKeyboardFound:
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
 BEQ over123

  ;;;;;;
  lda keyboard, x           ;;load that character
  ;;;;;;;;;;;;;;

  ;;;;;;;;;
  sta Current                 ;;store into sprite tile
  ;sta $501

  over123:
  rts
 ;         -----------------------------------------------------------------------------------
 Lower_byte_pal1:
.db $8c,$8d,$8e,$8f,$90,$91,$92,$93
Lower_byte_pal2:
.db $94,$95,$96,$97,$98,$99,$9a,$9b
 ;         ------------------------------------------------------------------------------------
keyboard:
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

 ; Family Basic keyboard layout

 ; .db $08, $A7, $41, $41, $41, $BB, $41, $AE
 ; .db $07, $41, $41, $41, $41, $41, $41, $41
 ; .db $06, $4F, 'L', 'K', '>', '<', 'P', ')'
 ; .db $05, 'I', 'U', 'J', 'M', 'N', '(', '*'
 ; .db $04, 'Y', 'G', 'H', 'B', 'V', '&', '^'
 ; .db $03, 'T', 'R', 'D', 'F', 'C', '%', '$'
 ; .db $02, 'W', 'S', 'A', 'X', 'Z', 'E', '#'
 ; .db $01, $0C, 'Q', $A9, $AB, $0B, '!', '@'
 ; .db $09, $15, $18, $17, $16, $41, $D0, $86
 ; .db  0 , $15, $17, $18, $16 ,  0 ,  0 ,  0
 ; .db  0 , 0,   0,   0,   0,   0 ,  0 ,    0


;Library:
word1:
.db 'D','E','F','E','A','T'
.db 'F','R','I','E','N','D'
.db 'W','A','R'
.db 'L','A','R','G','E'
.db 'T','Y','P','E'
.db 'N','I','G','H','T'
.db 'M','O','R','N','I','N','G'
.db 'T','R','U','T','H'
.db 'P','R','I','N','C','E'
.db 'M','O','N','S','O','O','N'


NumberofLetters:
.db $06, $06, $03, $05, $04, $05 ,$07, $05, $06, $07

word2:
.db 'R','A','M'
.db 'H','A','N','U','M','A','N'
.db 'M','O','N','S','T','E','R'
.db 'A','R','M','Y'
.db 'W','A','L','K'
.db 'D','A','R','K'
.db 'B','R','I','G','H','T'
.db 'W','I','N','S'
.db 'P','E','A','C','E'
.db 'R','A','I','N'

NumberofLetters1:
.db  $03, $07, $07, $04, $04, $04,$06, $04, $05, $04

;;;; Rock libraries
;    --------------------------------------------------------------------------------------------
word_rock:
.db 'L','I','F','E'
.db 'S','W','O','R','D'
.db 'F','R','I','E','N','D'
.db 'A','R','R','O','W'
.db 'S','I','T','A'
.db 'T','R','U','T','H'
.db 'R','I','N','G'
.db 'G','O','D'


NumberofLetters_rock:
.db $04, $05, $06, $05, $04, $05 ,$04, $03
;   ---------------------------------------------------------------------------------------
word_soldier:
.db 'M','O','N','S','T','E','R'
.db 'D','E','A','T','H'
.db 'E','A','R','T','H'
.db 'L','O','R','D'
.db 'R','O','C','K'
.db 'B','O','W'
.db 'R','A','V','V','A','N'
.db 'P','R','I','D','E'


NumberofLetters_soldier:
.db  $07, $05, $05, $04, $04, $03,$06, $05
;    ------------------------------------------------------------------------------------------
word_snow:
.db 'F','I','G','H','T'
.db 'R','E','A','D'
.db 'F','L','Y'
.db 'A','V','O','I','D'
.db 'G','O','O','D'
.db 'W','I','N','D'
.db 'F','I','N','A','L'
.db 'F','I','R','E'
.db 'P','A','L','A','C','E'
.db 'R','A','M'
.db 'B','O','Y'
.db 'S','H','A','R','P'
.db 'H','O','R','S','E'
.db 'M','O','R','N','I','N','G'
.db 'G','A','M','E'


NumberofLetters_snow:
.db  $05, $04, $03, $05, $04, $04,$05, $04, $06, $03, $03, $05 ,$05, $07, $04

;   -------------------------------------------------------------------------------------
word_snow2:
.db 'R','U','N'
.db 'B','O','O','K','S'
.db 'G','A','L','A','X','Y'
.db 'F','L','I','E','S'
.db 'D','R','E','A','M'
.db 'M','I','L','L'
.db 'M','O','V','E'
.db 'I','C','E'
.db 'L','A','N','K','A'
.db 'S','I','T','A'
.db 'G','I','R','L'
.db 'S','W','O','R','D'
.db 'R','I','D','I','N','G'
.db 'W','A','L','K'
.db 'O','V','E','R'

NumberofLetters1_snow2:
.db  $03, $05, $06, $05, $05, $03,$04, $03, $05, $04, $04, $05 ,$06, $04, $04
;    ---------------------------------------------------------------------------------
hanuman_sprites:
.db $A0, $00, $01, $10 ;0
.db $A0, $01, $01, $18 ;1
.db $A0, $02, $01, $20 ;2
.db $A0, $03, $01, $28 ;3
.db $A8, $10, $01, $10 ;4
.db $A8, $11, $01, $18 ;5
.db $A8, $12, $01, $20 ;6
.db $A8, $13, $01, $28 ;7
.db $B0, $20, $01, $10 ;8
.db $B0, $21, $01, $18 ;9
.db $B0, $22, $01, $20 ;10
.db $B0, $23, $01, $28 ;11
.db $B8, $30, $01, $10 ;12
.db $B8, $31, $01, $18 ;13
.db $B8, $32, $01, $20 ;14
.db $B8, $33, $01, $28 ;15
;    -------------------------------------------------------------------------------
sprites_rock:

.db $90, $9d, $03, $D0 ;sprite 0
.db $90, $9e, $03, $D8 ;sprite 1
.db $90, $9f, $03, $E0 ;sprite 2

.db $98, $ad, $03, $D0 ;sprite 3
.db $98, $ae, $03, $D8 ;sprite 4
.db $98, $af, $03, $E0 ;sprite 5

.db $A0, $bd, $03, $D0 ;sprite 6
.db $A0, $be, $03, $D8 ;sprite 7
.db $A0, $bf, $03, $E0 ;sprite 8

.db $A8, $cd, $03, $D0 ;sprite 9
.db $A8, $ce, $03, $D8 ;sprite 10
.db $A8, $cf, $03, $E0 ;sprite 11

.db $B0, $dd, $03, $D0 ;sprite 12
.db $B0, $de, $03, $D8 ;sprite 13
.db $B0, $df, $03, $E0 ;sprite 14

.db $B8, $ed, $03, $D0 ;sprite 15
.db $B8, $ee, $03, $D8 ;sprite 16
.db $B8, $ef, $03, $E0 ;sprite 17

.db $C0, $fd, $03, $D0 ;sprite 18
.db $C0, $fe, $03, $D8 ;sprite 19
.db $C0, $ff, $03, $E0 ;sprite 20

.db $e0, $63, $00, $50
.db $e0, $73, $00, $58

sprites_soldier:
;monster sprites
------------------------------

.db $88, $9a, $02, $D0 ;sprite 0
.db $88, $9b, $02, $D8 ;sprite 1
.db $88, $9c, $02, $E0 ;sprite 2

.db $90, $aa, $02, $D0 ;sprite 3
.db $90, $ab, $02, $D8 ;sprite 4
.db $90, $ac, $02, $E0 ;sprite 5

.db $98, $ba, $02, $D0 ;sprite 6
.db $98, $bb, $02, $D8 ;sprite 7
.db $98, $bc, $02, $E0 ;sprite 8

.db $A0, $ca, $02, $D0 ;sprite 9
.db $A0, $cb, $02, $D8 ;sprite 10
.db $A0, $cc, $02, $E0 ;sprite 11

.db $A8, $da, $02, $D0 ;sprite 12
.db $A8, $db, $02, $D8 ;sprite 13
.db $A8, $dc, $02, $E0 ;sprite 14

.db $B0, $ea, $02, $D0 ;sprite 15
.db $B0, $eb, $02, $D8 ;sprite 16
.db $B0, $ec, $02, $E0 ;sprite 17

.db $B8, $fa, $02, $D0 ;sprite 18
.db $B8, $fb, $02, $D8 ;sprite 19
.db $B8, $fc, $02, $E0 ;sprite 20

.db $80, $1f, $02, $D0 ;sprite 15
.db $80, $1f, $02, $D8 ;sprite 16
.db $80, $1f, $02, $E0 ;sprite 17
.db $80, $1f, $02, $e8 ;sprite 18
.db $80, $1f, $02, $f0 ;sprite 19

.db $98, $1f, $02, $b8 ;sprite 19
.db $98, $1f, $02, $c0 ;sprite 19
.db $98, $1f, $02, $c8 ;sprite 19
;   ---------------------------------------------------

   ;vert tile attr horiz
sprites_snake:
;rock sprites
------------------------------

.db $A0, $1F, $02, $D0 ;sprite 6
.db $A0, $1F, $02, $D8 ;sprite 7
.db $A0, $1F, $02, $E0 ;sprite 8
.db $A0, $1F, $02, $E8 ;sprite 8

.db $A8, $D0, $02, $D0 ;sprite 9
.db $A8, $D1, $02, $D8 ;sprite 10
.db $A8, $1F, $02, $E0 ;sprite 11
.db $A8, $1F, $02, $E8 ;sprite 11

.db $B0, $E0, $02, $D0 ;sprite 12
.db $B0, $E1, $02, $D8 ;sprite 13
.db $B0, $E2, $02, $E0 ;sprite 14
.db $B0, $E3, $02, $E8 ;sprite 14

.db $B8, $F0, $02, $D0 ;sprite 15
.db $B8, $F1, $02, $D8 ;sprite 16
.db $B8, $F2, $02, $E0 ;sprite 17
.db $B8, $F3, $02, $E8 ;sprite 17

.db $B0, $1f, $03, $E8 ;sprite 14
.db $B8, $1f, $03, $D0 ;sprite 15
.db $B8, $1f, $03, $D8 ;sprite 16
.db $B8, $1f, $03, $E0 ;sprite 17
;.db $B8, $1f, $02, $E8 ;sprite 17
;   ----------------------------------------------------------------------------------
   ;vert tile attr horiz
sprites_snow:
;snow monster sprites
------------------------------

.db $A0, $1f, $02, $D0 ;sprite 6
.db $A0, $c3, $02, $D8 ;sprite 7
.db $A0, $c4, $02, $E0 ;sprite 8
.db $A0, $c5, $02, $E8 ;sprite 8

.db $A8, $1f, $02, $D0 ;sprite 9
.db $A8, $d3, $02, $D8 ;sprite 10
.db $A8, $d4, $02, $E0 ;sprite 11
.db $A8, $d5, $02, $E8 ;sprite 11

.db $B0, $1f, $02, $D0 ;sprite 12
.db $B0, $E3, $02, $D8 ;sprite 13
.db $B0, $E4, $02, $E0 ;sprite 14
.db $B0, $e5, $02, $E8 ;sprite 14

.db $B8, $1f, $02, $D0 ;sprite 15
.db $B8, $F3, $02, $D8 ;sprite 16
.db $B8, $F4, $02, $E0 ;sprite 17
.db $B8, $f5, $02, $E8 ;sprite 17

.db $B8, $1f, $03, $d0 ;sprite 14
.db $B8, $1f, $03, $D8 ;sprite 15
.db $B8, $1f, $03, $e0 ;sprite 16
.db $B8, $1f, $03, $E8 ;sprite 17

;   ----------------------------------------
screen1_typing:
        .incbin "light_for.nam"




;       ---------------------------------------
palette_typing:

.byte $0F,$21,$01,$30,   $0F,$21,$09,$29,   $0F,$21,$01,$30,  $0F,$00,$20,$3D
; .byte $3F ,$3F ,$3F, $28,$3F ,$14 ,$28 ,$21 , $3F ,$3F ,$28 ,$02 ,$3F ,$3F, $3F ,$28
.byte $0f,$02,$27,$30,   $0f,$06,$27,$30,   $0f,$28,$0f,$3d,  $0f,$38,$17,$0f

palette_snow_typing:

.byte $0F,$11,$01,$30,   $0F,$11,$01,$30,   $0F,$11,$01,$30,  $0F,$11,$01,$30

.byte $0f,$28,$30,$05,   $0f,$06,$27,$30,   $0f,$28,$0f,$3d,  $0f,$07,$0a,$0f

palette_snake_typing:

.byte $08,$21,$0f,$30,   $08,$19,$3A,$0A,   $08,$3d,$0f,$28,  $08,$1C,$2C,$3C

.byte $08,$20,$10,$00,   $08,$06,$27,$30,   $08,$28,$0f,$3d,  $08,$20,$10,$00

palette_snow_typing_end:

.byte $0F,$11,$01,$30,   $0F,$11,$01,$30,   $0F,$28,$30,$05,  $0F,$07,$0A,$0F

.byte $0f,$20,$10,$00,   $0f,$06,$27,$30,   $0f,$28,$0f,$3d,  $0f,$20,$10,$00

