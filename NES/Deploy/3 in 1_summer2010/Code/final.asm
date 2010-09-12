end_seq_check = $5a
buttons EQU $20
levelnum = $21
oldbuttons EQU $22
sk1 = $23
justpressed EQU $24
points = $25
freq EQU $26
counter EQU $27
;;;;;;;;;;;
varX EQU $28
var1 EQU $29
var2 EQU $30
var3 EQU $31
var4 EQU $32
var5 EQU $33
var6 EQU $34
var7 EQU $35
var8 EQU $36
varY EQU $37
random1 EQU $38
random2 EQU $39
random3 EQU $40
random4 EQU $41
random5 EQU $42
random6 EQU $43
random7 EQU $44
loc1 EQU $45
loc2 EQU $46
loc3 EQU $47
loc4 EQU $48
loc5 EQU $49
loc6 EQU $50
loc7 EQU $51
k EQU $52
k1 EQU $53
k2 EQU $54
k3 EQU $55
k4 EQU $56
k5 EQU $57
k6 EQU $58
k7 EQU $59
hpy EQU $60
varYY EQU $61
 vary = $62
varyjsr = $63
cnt = $64
cntloop = $65

obj1 = $66
 gudcount EQU $67
 ngud EQU $68
level EQU $69
tt EQU $6A
go = $6B
bo = $6C
cq = $6D
icq = $6E
counter1 = $6F
counter2 = $70
counter3 = $71
us = $72
cb = $73
cbb = $74
uss = $75
random_enable = $76
question_count  =$77
checkup_status = $78
checkdown_status = $79
control = $7A
bg = $7C
count = $7D
qq = $7E
bg1 =$7F
bg2=$80
bg3=$81
bg4=$82
bg5=$83
bg6=$84
question_no=$85
count2=$86
random11 EQU $87
random22 EQU $88
random33 EQU $89
random44 EQU $8A
vv1=$8B
vv2=$8C
vv3=$3A
vv4=$3B
vv5=$3C
vv6=$3E
vv7=$3F
v11=$4A
v22=$4B
v33=$4C
v44=$4D
v55=$4E
v66=$19
v77=$18

varY1=$8D
varY2=$8E
varY3=$8F
varY4=$90
varY5=$91
varY6=$92
varY7=$93
gameover=$94
pointcheck=$95
game_finished = $95
wrongans   = $96
delay      = $97
L = $98
countl =$99
countr =$9A
waitt =$9B
h1 =$9C
h2 =$9D
h3 =$9E
tempcnt = $19
trigger_delay = $9F
delayy = $A0
trigger_delay2 = $A1
first_screen = $A2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scroll_h equ $A3
scroll_v equ $A4
ppucntl  equ $A5
scroll_step equ $A6
scrollup_act equ $A7
scrolldown_act equ $A8
screen_no equ $A9
scroll_h_temp equ $AB
scroll_v_temp equ $AC
scroll_change equ $ad
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
screen_start equ $B0
control_start equ $b1

buttons_s EQU $b2
oldbuttons_s EQU $b3
justpressed_s EQU $b4
level1_complete equ $b5

go0 = $b5
bo0 = $b6
cq0 = $b7
icq0 = $b8

sec_count = $b9
time_ones = $ba
time_tens = $bb
time_hundreds = $bc
pp = $bd

md1 EQU $bd
md2 EQU $be
md3 EQU $bf
md4 EQU $c0
u1 EQU $c1
u2 EQU $c2
u3 EQU $c3
u4 EQU $c4
oover = $c5
moveendtrig = $c6
moveawaytrig = $c7
downbagtrig = $c8
sadface = $c9
cntr = $cA
timend = $cb
bagpos = $cc
oover123 = $cd
gamelevel = $ce
trig_controller1=$cf
temp_varyjsr=$d0
loop_var1=$d1
loop_var2=$d2
bag_vertical=$d3
new_qst=$d4
new_qst1=$d5
last_try = $d6
ch1 =$d7
ch2 =$d8
ch3 =$d9
varch1 =$da
varch2 =$db
varch3 =$dc
sp1 =$dd
sp2 =$de
up_frame =$df
upmo =$e0
trig_endmotion =$e1
trig_startmotion =$e2
mx4 =$e3
color_right =$e4
color_left =$e5
mh2 =$e6
Qcount =$e7
trig_que =$e8
Gcount =$e9
trig_gud =$ea
trig_bad =$eb
trig_disp_level1 =$ec
smc1 =$ed
duf =$ee
sp3 =$ef
sp4 =$f0
sp5 =$f1
sp6 =$f2
sp7 =$f3
varss = $f4
sson = $f5
SongNumber = $f6
bad_temp = $f7
ps =$f8
ps1 =$f9
;LoadAddy = $EC05
;InitAddy = $EC05
;PlayAddy = $EC08
bug  = $fa
bug_imp = $fb
desparate = $fc
test      = $fd
credit_enable   = $fe
duf1 =$ff
screen_start6 = $100
trig_st =$19
scro = $18
fast_speed =$17
updown1 =$16
updown2 =$15
tpp =$14
tpp1 =$13
touch_trig=$12
select_var = $11

NewButtons = $10
OldButtons = $102
JustPressed = $103
PPUCRTL = $104
bitmask = $105
temp = $106
sourceLo = $107
sourceHi = $108
nol = $109
cs EQU $10a
tempx EQU $10b
color1 = $10c
Current = $10d
scroll = $10e
hitrock EQU $10f
breakrock = $110
walk = $111
pointer= $112
wl = $113
wordlength = $114
wordnum = $115
xleft = $116
xright =  $117
ytop = $118
ybottom = $119

sp0 EQU $11a
cs1 EQU $11b
tem EQU $11c
ts EQU $11d
i EQU $11e
ww EQU $11f
j EQU $120
moveforward_status EQU $121
scroll_status EQU $122
ll EQU $123
varZ EQU $124
kk EQU $125
color EQU $126
trigger = $127
wn = $128
total_letters = $129
trigger2 = $12a
ttempx = $12b
count1 EQU $12c
count3 EQU $12d
count4 EQU $12e

upd EQU $12f
varM EQU $130
key EQu $131
varM1 EQU $132
key1 EQU $133
moh EQU $134
trigger0 = $135

total_letters0 = $136
var01 = $137

pointer0 = $138

trig_delay = $139

delay_cal_quiz = $13a


under = $13b
upper_byte=$13c
lower_byte=$13d
under1=$13e
under2=$13f


var_new = $140
var_walk EQU $141
co =$142
varP =$143
tri =$144
co1 =$145
co2 =$146
tri1 =$147
tri2 =$148
pro1 =$149
pro2 =$14a
pro3 =$14b
pro4 =$14c
varMM =$14d
key_fun2 =$14e
varMM1 =$14f
kkc =$150
varH =$151
mx =$152
sw =$153
varG =$154
mon_color = $155
mdd2=$156
col=$157
hanu_pal=$158
mdd21=$159
col1=$15a
level_change=$15b
clearing_byte=$15c
varYp=$15d
game_no = $15e


varA EQU $15f
varB EQU $160
mosX EQU $161

varC EQU $162
varD EQU $163
varE EQU $164
varF EQU $165

varZ1 EQU $166
varZ2 EQU $167
kg EQU $168
kg2 EQU $169
kg1 EQU $16a
varG1 EQU $16b
varG2 EQU $16c


mosY EQu $16d
racX EQU $16e
racY EQU $16f

key2 EQU $170
key3 EQU $171
key4 EQU $172
key5 EQU $173
pressA EQU $174
jj EQU $175
md EQU $176

md5 EQu $177
x1 EQU $178
x2 EQU $179
x3 EQU $180
x4 EQU $181
x5 EQU $182
z EQU $183
mosquito_dead EQU $184

screen_change_trigger equ $185
rm EQU $186
rm1 EQU $187

fr EQU $188
delay_selectup = $189
delay_selectdown  = $18a
initiate_con=$18b
stop_start = $18c

hanu=$18d
head=$18e
bad=$18f

blastsnake=$190
blastrock=$191
blastsoldier=$192
vv8 =$193
varY8 =$194
random8 =$195
loc8 =$196
k8 =$197
trig_m8 =$198
varY88 =$199
varch6 =$19a
ch6 =$19b
varch5 =$19c
ch5 =$19d
varch4 =$19e
ch4 =$19f

scrollup_slow = $200

trig_static = $201
bh = $202
trig_hit = $18
varB1 = $204
be1 = $17
bh1 = $d3
trig_fall = $c9
varB2 = $208
bh2 = $78
be2 = $79
varS = $6b
var_sol = $6c
trig_sol = $6d
varSS = $38
var_smoke =$39
trig_smoke=$40

ch7 = $2a
varch7 =$2b
ps2 =$2c
ps3 =$2d
varch8 =$2e
typ_variable = $2f
game_no1 = $209
end_seq = $96


;       ----------------------------------------------------

        .ORG $7ff0
Header:                         ; 16 byte .NES header (iNES format)
	.db "NES", $1a
	.db $08                 ; size of PRG ROM in 16kb units
	.db $10			; size of CHR ROM in 8kb units
	.db #%00010010		; mapper 1
	.db #%00000000		; mapper 1
        .db $00                 ; size of PRG RAM in 8kb RAM
        .db $00
        .db $00
        .db $00
        .db $00
        .db $00
        .db $00
        .db $00

;       ----------------------------------------------------
.base $8000
.include quiz_level1.asm

LoadAddy = $AB50
InitAddy = $AB50
PlayAddy = $AB53

.org LoadAddy
.incbin "quiz.nsf"

.org $c000

.base $8000
.include quiz_level2.asm

LoadAddy = $AB50
InitAddy = $AB50
PlayAddy = $AB53

.org LoadAddy
.incbin "quiz.nsf"
.org $c000

.base $8000
.include typing.asm
LoadAddyt = $ADE2
InitAddyt = $ADE2
PlayAddyt = $ADE5

.org LoadAddyt
.incbin "typing.nsf"

.org $c000

.base $8000
.include malaria.asm

LoadAddy = $AB50
InitAddy = $AB50
PlayAddy = $AB53

.org LoadAddy
.incbin "malaria.nsf"      ; NSF filename

.org $c000

.base $8000
type_screen:
.incbin "type_screen_load.nam"
start_screen11:
.incbin "start.nam"
.org $c000


.base $8000
.include typ_end.asm
.org $c000

.base $8000
.org $c000

.base  $c000
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        LDX #%00011111
        jsr initMMC1Mapper

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        lda #10
        sta select_var
        sta screen_start6

        lda #19
        sta count2
        sta stop_start

        lda #$0f
        sta freq

        lda #6
        sta counter
        lda #80
        sta delay

        lda #6
        sta time_hundreds
        sta level1_complete
        
        lda #1
        sta ps2



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
PPULoop
	STA $2007
	DEX
	BNE PPULoop

	DEY
	BNE ClearName

;       ----------------------------------------------------
        lda #10
        sta screen_start
      	LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<start_2in1
        sta $10
        lda #>start_2in1
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

NameLoop1:
        lda ($10),y
        sta $2007
        iny
        bne NameLoop1
        inc $11
        dex
        bne NameLoop1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

InitSprites:
      ;CLEAR ALL OF SPRITE MEMORY TO AVOID GARBAGE SPRITES!
      LDA #$00
      LDX #$00
      LDY #$00
      stx varX
      stx varY
      stx k
      stx k1
      stx ngud
      stx gudcount
      stx k3
      stx k4
      stx k5
      stx k6
      stx k7
      stx varYY
      stx tt
      stx L
      stx countl
      stx countr
      stx waitt
      stx h1
      stx h2
      stx h3

      stx hpy
    ;  stx random4
      lda #240
      sta k2
      LDA #1
      sta var1
      sta var2
      sta var3
      sta var4
      sta var5
      sta var6
      sta var7
      sta var8
      sta trig_m8

      sta trig_controller1

      sta ps


      ;;;;;;;;;;

      lda #$00

      sta random1
      sta random2
      sta random3
      sta random4
      sta random5
      sta random6
      sta random7
      sta random8
      sta loc1
      sta loc2
      sta loc3
      sta loc4
      sta loc5
      sta loc6
      sta loc7
      sta loc8
      sta varY1


      lda #0
      sta level


      ;;;;;;;;;;




ClearSprites:
      STA $500, x
      INX
      BNE ClearSprites

LoadSprites:
      LDX #$00
@LoadSpritesLoop:
      LDA sprites_2in1, x            ; load data from address (sprites + x)
      STA $0500, x              ; store into RAM address ($0200 + x)
      INX                       ; X = X + 1
      CPX #4
                        ; Compare X to # of values (divide by 4 for total # of sprites)
      BNE @LoadSpritesLoop       ; Branch to LoadSpritesLoop if compare was Not Equal to zero
                               ; if compare was equal to 32, keep going down
;;;;;;;;;;;;;;;;;;;;;;;


;LoadSprites1:
;      LDX #$00
;LoadSpritesLoop1:
;      LDA sprites_level, x            ; load data from address (sprites + x)
;      STA $0700, x              ; store into RAM address ($0200 + x)
;      INX                       ; X = X + 1
;      CPX #24
                        ; Compare X to # of values (divide by 4 for total # of sprites)
;      BNE LoadSpritesLoop1       ; Branch to LoadSpritesLoop if compare was Not Equal to zero
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

	LDA #%10001010
	STA $2000
	sta ppucntl
        LDA #%00011110
	STA $2001

        ldx #$00
        stx $2005
        LDX #239
        stX scroll_v
        stx $2005

jsr InitMusic

;       ----------------------------------------------------

InfLoop:                        ; loop forever
        JMP InfLoop

;       ----------------------------------------------------

InitMusic:

	lda #$00
	ldx #$00
Clear_Sound:
	sta $4000,x
	inx
	cpx #$0F
	bne Clear_Sound



	lda #%00001111
 	STA $4015
	lda #$C0
	STA $4017

       LDA SongNumber		; song number
      ldx #$0		; 00 for NTSC or $01 for PAL
	jsr InitAddy		; init address
       rts

update_spr_2in1:
        LDA #$00
        STA $2003 ; set the low byte (00) of the RAM address
        LDA #$05
        STA $4014 ; set the high byte (05) of the RAM address, start the transfer
        RTS


update_sprites:
               LDA trig_controller1
               cmp #1
               bne up_sprit_end

        LDA #$00
        STA $2003 ; set the low byte (00) of the RAM address
        LDA #$05
        STA $4014 ; set the high byte (05) of the RAM address, start the transfer
        RTS


update_sprites1:
        LDA control
        cmp #5
        bne up_sprit_end
update_sprites11:
        LDA #$00
        STA $2003 ; set the low byte (00) of the RAM address
        LDA #$06
        STA $4014 ; set the high byte (05) of the RAM address, start the transfer
up_sprit_end:
        RTS


initMMC1Mapper:
  LDA #$80
  STA $8000

  TXA
  JSR setMMC1ControlMode

  LDA #$04
  JSR setCHRPage0000

  LDA #$05
  JSR setCHRPage1000


  LDA #$00
  JSR setPRGBank

  RTS

;       ----------------------------------------------------
setMMC1ControlMode:
       ; lda var
      ;  and %01111111
     ;   sta $8000
        STA $8000
        LSR A
        STA $8000
        LSR A
        STA $8000
        LSR A
        STA $8000
        LSR A
        STA $8000
  RTS

setCHRPage0000:
        ;lda var
       ; and %01111111
       ; sta $a000
        STA $A000
        LSR A
        STA $A000
        LSR A
        STA $A000
        LSR A
        STA $A000
        LSR A
        STA $A000
  RTS

setCHRPage1000:
        ;lda var
        ;and %01111111
        ;sta $c000
        STA $C000
        LSR A
        STA $C000
        LSR A
        STA $C000
        LSR A
        STA $C000
        LSR A
        STA $C000
  RTS

setPRGBank:
        ;lda var
        ;and %01111111
        ;sta $e000
        STA $E000
        LSR A
        STA $E000
        LSR A
        STA $E000
        LSR A
        STA $E000
        LSR A
        STA $E000
  RTS





update_srr1:


sprites:
;   vert tile attr horiz
;neg obj
.db $ff, $15, $01, $80 ;sprite 0    1                          ;
.db $ff, $21, $02, $DD ;sprite 0    2
.db $ff, $14, $03, $C8 ;sprite 0    3
.db $ff, $02, $01, $B0 ;sprite 0    4

;ques obj
.db $ff, $02, $01, $60 ;sprite 0     5

;gud obj
.db $ff, $13, $00, $98 ;sprite 0     6
.db $ff, $3B, $03, $20 ;sprite 0     7

;hanuman sprites
.db $98, $68, $00, $30 ;sprite 0      8
.db $98, $69, $00, $38 ;1             9
.db $98, $6A, $00, $40 ;2             10
.db $98, $6B, $00, $48  ;               11
.db $A0, $78, $00, $30  ;              12
.db $A0, $79, $00, $38  ;               13
.db $A0, $7A, $00, $40  ;               14
.db $A0, $7B, $00, $48  ;               15
.db $A8, $88, $00, $30  ;               16
.db $A8, $89, $00, $38  ;               17
.db $A8, $8A, $00, $40  ;               18
.db $A8, $8B, $00, $48   ;              19
.db $B0, $98, $00, $30  ;               20
.db $B0, $99, $00, $38  ;               21
.db $B0, $9A, $00, $40  ;               22
.db $B0, $9B, $00, $48   ;14           23

; level sprites
.db $00, $00, $00, $00   ;14           24
.db $00, $00, $00, $00   ;14           25
.db $00, $00, $00, $00   ;14           26
.db $00, $00, $00, $00   ;14           27
.db $00, $00, $00, $00   ;14           28
.db $00, $00, $00, $00   ;14           29

; bag
.db $98, $00, $00, $80   ;              30
.db $A0, $00, $00, $80   ;              31

; timer
.db $14, $88, $02, $20   ;              32
.db $14, $89, $02, $28  ;               33
.db $14, $8A, $02, $30  ;               34

;sprites for press start
.db $c8, $00, $00, $70 ;sprite 0       35                    ;
.db $c8, $00, $00, $78 ;sprite 0       36
.db $c8, $00, $00, $80 ;sprite 0       37
.db $c8, $00, $00, $88 ;sprite 0       38                    ;
.db $c8, $00, $00, $90 ;sprite 0       39
.db $c8, $00, $00, $98 ;sprite 0       40

;   vert tile attr horiz

 ;sprites for level1
.db $60, $00, $02, $70 ;sprite 0       41                    ;
.db $60, $00, $02, $78 ;sprite 0       42
.db $60, $00, $02, $80 ;sprite 0       43
.db $60, $00, $02, $88 ;sprite 0       44                    ;
.db $60, $00, $02, $90 ;sprite 0       45
.db $60, $00, $02, $A0 ;sprite 0       46

;;to display time
.db $0c, $F3, $02, $20 ;sprite 0       47
.db $0c, $F7, $02, $28 ;sprite 0       48                    ;
.db $0c, $F8, $02, $30 ;sprite 0       49
.db $0c, $1A, $02, $38 ;sprite 0       50

.db $ff, $90, $02, $A0 ;                51


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LoadSprites1:         ;to load all sprites again
      LDX #$00
LoadSpritesLoop1:
      LDA sprites, x            ; load data from address (sprites + x)
      STA $0500, x              ; store into RAM address ($0200 + x)
      INX                       ; X = X + 1
      CPX #204
                        ; Compare X to # of values (divide by 4 for total # of sprites)
      BNE LoadSpritesLoop1
      rts


;;;;;;;;;;;;
;;;press1-press2 :to load "press start" continuesly
press1:
       lda #$00
       sta $589
       sta $58D
       sta $591
       sta $595
       sta $599
       sta $59D
       rts
press2:
       lda #$06
       sta $589
       lda #$07
       sta $58D
       lda #$08
       sta $591
       lda #$09
       sta $595
       lda #$0A
       sta $599
       lda #$0B
       sta $59D
       rts


;-------------------------------
;;press_start-jsr to load "press start" continuesly
 press_start:

            lda ps
            cmp #1
            bne avv

            INC varch1
             lda varch1
             CMP #10
             BNE avv
             lda #0
             sta varch1

            lda ps1
            cmp #0
            bne ffg
            jsr press2
            lda #1
            sta ps1
            rts

     ffg:  jsr press1
           lda #0
           sta ps1


       avv: rts



;-------------------------------
; change1 ;
; change2 ;to move two frames of badobjects
; change3 ;
;
change1:

         INC varch1
         lda varch1
         CMP #15
         BNE ech1
         lda #0
         sta varch1


         lda ch1
         cmp #1
         bne kp
         lda #$20
         sta $501
         lda #0
         sta ch1
   ech1: rts
   kp:  lda #$15
        sta $501
         lda #1
         sta ch1
         rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 change2:

         INC varch2
         lda varch2
         CMP #15
         BNE ech2
         lda #0
         sta varch2

         lda ch2
         cmp #1
         bne kp1
         lda #$21
         sta $505
         lda #0
         sta ch2
   ech2: rts
   kp1:  lda #$1B
        sta $505
         lda #1
         sta ch2
         rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 change3:
         INC varch3
         lda varch3
         CMP #15
         BNE ech3
         lda #0
         sta varch3

         lda ch3
         cmp #1
         bne kp2
         lda #$26
         sta $509
         lda #0
         sta ch3
   ech3: rts
   kp2:  lda #$14
        sta $509
         lda #1
         sta ch3
         rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 change4:
         INC varch4
         lda varch4
         CMP #15
         BNE ech4
         lda #0
         sta varch4

         lda ch4
         cmp #1
         bne kp33
         lda #$13
         sta $515
         lda #0
         sta ch4
   ech4: rts
   kp33:  lda #$47
        sta $515
         lda #1
         sta ch4
         rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

change5:
         INC varch5
         lda varch5
         CMP #15
         BNE ech5
         lda #0
         sta varch5

         lda ch5
         cmp #0
         bne kp5
         lda #$02
         sta $511
         lda #1
         sta ch5
   ech5: rts
   kp5:  lda ch5
         cmp #1
         bne kp6
         lda #$ca
        sta $511
         lda #2
         sta ch5
         rts

   kp6:
         lda #$da
        sta $511
         lda #0
         sta ch5
         rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
change7:
         INC varch7
         lda varch7
         CMP #15
         BNE @ech5
         lda #0
         sta varch7

         lda ch7
         cmp #0
         bne @kp5
         lda #$02
         sta $50D
         lda #1
         sta ch7
   @ech5: rts
   @kp5:  lda ch7
         cmp #1
         bne @kp6
         lda #$ca
        sta $50d
         lda #2
         sta ch7
         rts

   @kp6:
         lda #$da
        sta $50d
         lda #0
         sta ch7
         rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 change6:
         INC varch6
         lda varch6
         CMP #15
         BNE ech6
         lda #0
         sta varch6

         lda ch6
         cmp #0
         bne kp7
         lda #$90
         sta $5c9
         lda #1
         sta ch6
   ech6: rts
   kp7:  lda ch6
         cmp #1
         bne kp8
         lda #$eb
        sta $5c9
         lda #2
         sta ch6
         rts

   kp8:
         lda #$ba
         sta $5c9
         lda #0
         sta ch6
         rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;m1---  to drop bad objects from the top of the screen randomly
;;m2---
;;m3---
;;m4---

;;m5--- to drop question object from the top of the screen randomly

;;m6--- to drop good objects from the top of the screen randomly
;;m7---

   ppp0:rts

  
  m1:          lda vv1
              cmp #1
               bne one1
               lda #240
               sta $500
           ;    sta $501
               lda #0
               sta vv1
           ;    sta $502
           ;    sta $503


                INC varY1
                 lda varY1
                 CMP #120
                 BNE ppp0
                lda #0
                sta varY1
                sta vv1

            one1:
            lda var1
                cmp #$00
                beq mm1

                INC var1
                lda var1
                cmp random1
                BNE p1

                LDA #$00
                STA var1


      mm1:  inc #$500
            jsr change1
          ;  dec #$500
          ;  inc #$500

            lda #$500
            cmp #$ff
            bne mmm1
                ;;;;;
         ;       lda $42
         ;       sta $501
               ;;;;;;;
                lda #1
                sta var1
                jsr load
                lda loc1
              ;  inc random44
              ; jsr random_gen
                sta #$503
             ;
                lda #0
             ;   sta k



        mmm1:    rts


      p1:    inc var1
      ppp1:       RTS

  m2:
               lda vv2
               cmp #1
               bne one2
               lda #240
               sta $504
          ;     sta $505
               lda #0
               sta vv2
          ;     sta $506
          ;     sta $507


                INC varY2
                 lda varY2
                 CMP #120
                 BNE ppp1
                lda #0
                sta varY2
                sta vv2




        one2:
                lda var2
                cmp #$00
                beq mm2

                INC var2
                lda var2
                  cmp random2
                  BNE p2


            LDA #$00
            STA var2
      mm2:  inc #$504
            jsr change2
          ;  inc $504
           lda #$504
            cmp #$ff
            bne mmm2

          ;       lda $42
          ;     sta $505

                lda #1
                sta var2
          ;       jsr inc_k
                 jsr load
                 lda loc2
                sta #$507
               ; lda #0
               ; sta k


        mmm2 :  rts


      p2:inc var2
      ppp2:    RTS


  m3:
        lda vv3
               cmp #1
               bne one3
               lda #240
               sta $508
          ;     sta $509
               lda #0
               sta vv3
          ;     sta $50A
          ;     sta $50B


                INC varY3
                 lda varY3
                 CMP #120
                 BNE ppp2
                lda #0
                sta varY3
                sta vv3



             one3:
               lda var3
                cmp #$00
                beq mm3

                INC var3
                lda var3
               ;  CMP #180
                  cmp random3
                     BNE p3



            LDA #$00
            STA var3
      mm3:  inc #$508
            jsr change3
            ;inc #$508
            lda #$508
            cmp #$ff
            bne mmm3

          ;      lda $42
         ;       sta $509
           ;
                lda #1
                sta var3
               ;  jsr load
                 lda loc3
              ;  inc random44
              ;  jsr random_gen
                sta #$50B

        mmm3 :  rts


      p3:inc var3
      ppp3:    RTS



  m4:

             lda vv4
               cmp #1
               bne one4
               lda #240
               sta $50C
         ;      sta $50D
           ;    sta $50E
           ;    sta $50F
                lda #0
                sta vv4

                INC varY4
                 lda varY4
                 CMP #120
                 BNE ppp3
                lda #0
                sta varY4
                sta vv4


  one4:
            lda var4
                cmp #$00
                beq mm4

                INC var4
                lda var4
                cmp random4
                 BNE p4



            LDA #$00
            STA var4
      mm4:  inc #$50c
      
            ;jsr change7
            inc sp1
            lda sp1
            cmp #2
            bne ip1
            lda #0
            sta sp1
            inc #$50c
     ip1:   lda #$50c
            cmp #$ff
            bne mmm4

        ;        lda $42
         ;       sta $50D

                lda #1
                sta var4

                 lda loc4
                sta #$50F

        mmm4 :  rts



      p4:inc var4
      ppp4:    RTS

  m5:

             lda vv5
               cmp #1
               bne one5
               lda #240
               sta $510
           ;    sta $511
               lda #0
               sta vv5

               INC varY5
                 lda varY5
                 CMP #120
                 BNE ppp4
                lda #0
                sta varY5
                sta vv5

  one5:
                 lda var5
                cmp #$00
                beq mm5

                INC var5
                lda var5
                ; CMP #12
                 cmp random5
                  BNE p5

            LDA #$00
            STA var5
      mm5:
            inc #$510
            ;jsr change5
            lda #$510
            cmp #$ff
            bne mmm5

           ;      lda $42
           ;      sta $511

                lda #1
                sta var5
                 lda loc5
               ; jsr random_gen
                sta #$513


        mmm5 :  rts

      p5:inc var5
      ppp5:    RTS

  m6:
              lda vv6
              cmp #1
               bne one6
               lda #240
               sta $514

                 INC varY6
                 lda varY6
                 CMP #120
                 BNE ppp5
                lda #0
                sta varY6
                sta vv6

  one6:

             lda var6
                cmp #$00
                beq mm6

            INC var6
                lda var6
               ;  CMP #120
                 cmp random6
                 BNE p6


            LDA #$00
            STA var6
      mm6:   lda gudcount
            cmp #1
            beq j1

            inc #$514

            inc sp2
            lda sp2
            cmp #2
            bne ip2
            lda #0
            sta sp2
            inc #$514
            jsr change4
     ip2:

            lda #k6
            cmp #5
            bne j1
            inc k6
            inc $517
            inc $517
            inc $517
            inc $517
            lda #0
            sta k6

        j1:
            lda #$514
            cmp #$ff
            bne mmm6


       con66:

           ;;;;;;;;;;;;;;;;;;
             inc ngud
             ;;;;;;
               ldy level
                lda no_of_gudobjects,y
                tax
                dex
                stx tt
                lda ngud
                cmp tt
                bne con
                lda #$00
               sta #$514
               sta #$515
               sta #$516
               sta #$517
             ;;;;;

   con:     ldy level
            lda no_of_gudobjects,y

               cmp ngud
               beq ld99
           ;;;;;;;;;;;;;;;;
                lda #1
                sta var6

             lda loc6
                  ; jsr random_gen

                  sta #$517

        mmm6 :  rts

        ;;;;;;;;;;


;;;;;;;;;;;

      p6:inc var6
           RTS


;;;;;;;;;;;
  m7:
               lda vv7
               cmp #1
               bne one7
               lda #240
               sta $518

                INC varY7
                lda varY7
                 CMP #120
                 beq ppp7
                 rts

       ppp7:      lda #0
                 sta vv7
                 sta varY7


one7:
                lda var7
                cmp #$00
                beq mm7

                INC var7
                lda var7
              ;   CMP #200
                 cmp random7
                   BNE p7


            LDA #$00
            STA var7
      mm7:  lda gudcount
            cmp #1
            beq j2

            inc #$518
          j2: lda #$518
            cmp #$ff
            bne mmm7

         ;    lda v77
         ;   cmp #0
         ;   beq con77
         ;   lda $47
         ;   sta $519
         ;   lda #0
         ;   sta v77
          ;   jsr n77


      ; con77:

            ;;;;;;;;;;;;;;;;;
             inc ngud
             ;;;;;;;
              ;;;;;;;;;

              ldy level
                lda no_of_gudobjects,y
                tax
                dex
                stx tt
                lda ngud
                cmp tt
                bne con1
               lda #0
               sta #$518
               sta #$519
               sta #$51A
               sta #$51B
       con1:   ldy level
                lda no_of_gudobjects,y
               cmp ngud
               beq ld99
                lda #1
                sta var7
            ;      lda v77
            ;     cmp #1
            ;     bne eq7
            ;      lda #0
            ;      sta v77
            ;      jsr random_gen
            ;      sta $51B
            ;      jmp mmm7


               lda loc7
                sta #$51B

        mmm7 :  rts
;;;;;;;;
    ;     n77:    lda v77
    ;        cmp #0
    ;        beq con77
    ;        lda $47
    ;        sta $519
    ;        lda #0
    ;        sta v77
    ;        rts
     ;;;;;


      p7:inc var7
          RTS

      ld99:  lda #1
       sta gudcount

       lda #$00
       sta #$514
       sta #$515
       sta #$516
       sta #$517
       sta #$518
       sta #$519
       sta #$51A
       sta #$51B

       rts

m8:          lda trig_m8
             cmp #1
             bne mmm8

               lda vv8
               cmp #1
               bne one8
               lda #240
               sta $5c8
          ;     sta $509
               lda #0
               sta vv8
          ;     sta $50A
          ;     sta $50B


                INC varY8
                 lda varY8
                 CMP #6000
                 BNE mmm7
                lda #0
                sta varY8
                sta vv8



             one8:
               lda var8
                cmp #$00
                beq mm8

                INC var8
                lda var8

                  cmp random8
                     BNE p8



            LDA #$00
            STA var8
      mm8:  inc #$5c8
            jsr change6
            lda #$5c8
            cmp #$ff
            bne mmm8
            
                lda #1
                sta var8
               ;  jsr load
                 lda loc8
              ;  inc random44
              ;  jsr random_gen
                 sta #$5cB
                 
                ; lda #0
                ; sta trig_m8
                ; jsr triger_m8

        mmm8 :  rts


      p8:inc var8
      ppp8:    RTS

triger_m8:
       
     ;  lda enable_m8
     ;  cmp #1
     ;  bne mg1

        LDA varY88
        CMP #7
        BEQ lg1
        inc varY88
       
        lda #240
        sta $5c8
        rts

   lg1:lda #0
       sta varY88
       lda loc8
       sta $5cB
   ;    sta enable_m8

  mg1:     RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;

random_gen:             ;to generate random numbers
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 load:
       lda var1
       cmp #1
       bne ld2
       jsr delay1

 ld2:
      lda var2
       cmp #1
       bne ld3
       jsr delay2

 ld3:
      lda var3
       cmp #1
       bne ld4
       jsr delay3

 ld4:
        lda var4
       cmp #1
       bne ld5
       jsr delay4

 ld5:
      lda var5
       cmp #1
       bne ld6
       jsr delay5

 ld6:
      lda var6
       cmp #1
       bne ld7


       jsr delay6
            lda k6
            cmp #1
            bne ld7
           jsr random_gen
            sta loc6
            lda #0
            sta k6

 ld7:

      lda var7
       cmp #1
       bne ld8


       jsr delay7

           lda k7
            cmp #1
            bne ld8
           jsr random_gen
            sta loc7
            lda #0
            sta k7


 ld8: lda var8
       cmp #1
       bne ld9


       jsr delay8

           lda k8
            cmp #1
            bne ld9
           jsr random_gen
            sta loc8
            lda #0
            sta k8




 ld9:rts



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; delay1-7--- for random delay of diffrent 7 objects while falling from the top
;;
;;
;;


 delay1:

        lda k
        cmp #1
        bne d1_2
        ldx #90
        stx random1

        ldx #72
        stx loc1
        rts
   d1_2:  lda k

          cmp #2
        bne d1_3
        ldx #300
        stx random1

         ldx #12
        stx loc1
        rts
   d1_3:  lda k

          cmp #3
        bne d1_4
        ldx #5
        stx random1
         ldx #234
        stx loc1
        rts
   d1_4:  lda k

          cmp #4
        bne d1_5
        ldx #115
        stx random1
         ldx #90
        stx loc1
        rts
   d1_5:  lda k

          cmp #5
        bne d1_6
        ldx #150
        stx random1
         ldx #56
        stx loc1
        rts
   d1_6:  lda k

          cmp #6
        bne d1_7
        ldx #225
        stx random1
         ldx #20
        stx loc1
        rts
   d1_7:  lda k

          cmp #7
        bne d1_8
        ldx #95
        stx random1
         ldx #160
        stx loc1
        rts

   d1_8:  lda k

          cmp #8
        bne d1_9
        ldx #840
        stx random1
         ldx #110
        stx loc1
        rts
   d1_9:   lda k

           cmp #9
        bne d1_10
        ldx #120
        stx random1
         ldx #200
        stx loc1
        rts
   d1_10: lda k

          cmp #10
        bne d1_11
        ldx #340
        stx random1
         ldx #15
        stx loc1
        rts
   d1_11: lda k

          cmp #11
        bne d1_12
        ldx #190
        stx random1
         ldx #49
        stx loc1
        rts
   d1_12: lda k

          cmp #12
        bne d1_13
        ldx #25
        stx random1
         ldx #138
        stx loc1
        rts
   d1_13: lda k

          cmp #13
        bne d1_14
        ldx #720
        stx random1
         ldx #220
        stx loc1
        rts
   d1_14: lda k

          cmp #14
        bne d1_15
        ldx #70
        stx random1
         ldx #80
        stx loc1
        rts
   d1_15: lda k

          cmp #15
        bne d1_16
        ldx #510
        stx random1
         ldx #210
        stx loc1
  d1_16:
        rts
;;;;;;;;;;;;;;;;;

 delay2:
        lda k

        cmp #1
        bne d2_2
        ldx #10
        stx random2

        ldx #23
        stx loc2
        rts
   d2_2:lda k

        cmp #2
        bne d2_3
        ldx #600
        stx random2
         ldx #190
        stx loc2
        rts
   d2_3:  lda k

          cmp #3
        bne d2_4
        ldx #51
        stx random2
         ldx #40
        stx loc2
        rts
   d2_4:  lda k

          cmp #4
        bne d2_5
        ldx #415
        stx random2
         ldx #12
        stx loc2
        rts
   d2_5:  lda k

          cmp #5
        bne d2_6
        ldx #299
        stx random2
         ldx #240
        stx loc2
        rts
   d2_6:  lda k

          cmp #6
        bne d2_7
        ldx #25
        stx random2
         ldx #61
        stx loc2
        rts
   d2_7:  lda k

          cmp #7
        bne d2_8
        ldx #615
        stx random2
         ldx #174
        stx loc2
        rts

   d2_8:  lda k

          cmp #8
        bne d2_9
        ldx #84
        stx random2
         ldx #9
        stx loc2
        rts
   d2_9:   lda k

           cmp #9
        bne d2_10
        ldx #220
        stx random2
         ldx #90
        stx loc2
        rts
   d2_10: lda k

          cmp #10
        bne d2_11
        ldx #40
        stx random2
         ldx #123
        stx loc2
        rts
   d2_11: lda k

          cmp #11
        bne d2_12
        ldx #140
        stx random2
         ldx #81
        stx loc2
        rts
   d2_12: lda k

          cmp #12
        bne d2_13
        ldx #252
        stx random2
         ldx #175
        stx loc2
        rts
   d2_13: lda k

          cmp #13
        bne d2_14
        ldx #72
        stx random2
         ldx #76
        stx loc2
        rts
   d2_14: lda k

          cmp #14
        bne d2_15
        ldx #702
        stx random2
         ldx #24
        stx loc2
        rts
   d2_15: lda k

          cmp #15
        bne d2_16
        ldx #51
        stx random2
         ldx #231
        stx loc2
  d2_16:
        rts

  ;;;;;;;;;;;;

 delay3:
        lda k

        cmp #1
        bne d3_2
        ldx #9
        stx random3

        ldx #90
        stx loc3
        rts
   d3_2:  cmp #2
        bne d3_3
        ldx #30
        stx random3
         ldx #230
        stx loc3
        rts
   d3_3:  cmp #3
        bne d3_4
        ldx #511
        stx random3
         ldx #40
        stx loc3
        rts
   d3_4:  cmp #4
        bne d3_5
        ldx #145
        stx random3
         ldx #10
        stx loc3
        rts
   d3_5:  cmp #5
        bne d3_6
        ldx #15
        stx random3
         ldx #99
        stx loc3
        rts
   d3_6:  cmp #6
        bne d3_7
        ldx #25
        stx random3
         ldx #148
        stx loc3
        rts
   d3_7:  cmp #7
        bne d3_8
        ldx #925
        stx random3
         ldx #211
        stx loc3
        rts

   d3_8:  cmp #8
        bne d3_9
        ldx #84
        stx random3
         ldx #24
        stx loc3
        rts
   d3_9:   cmp #9
        bne d3_10
        ldx #12
        stx random3
         ldx #67
        stx loc3
        rts
   d3_10: cmp #10
        bne d3_11
        ldx #140
        stx random3
         ldx #120
        stx loc3
        rts
   d3_11: cmp #11
        bne d3_12
        ldx #19
        stx random3
         ldx #29
        stx loc3
        rts
   d3_12: cmp #12
        bne d3_13
        ldx #255
        stx random3
         ldx #168
        stx loc3
        rts
   d3_13: cmp #13
        bne d3_14
        ldx #620
        stx random3
         ldx #33
        stx loc3
        rts
   d3_14: cmp #14
        bne d3_15
        ldx #570
        stx random3
         ldx #133
        stx loc3
        rts
   d3_15: cmp #15
        bne d3_16
        ldx #10
        stx random3
         ldx #5
        stx loc3
  d3_16:
        rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;3

 delay4:
        lda k

        cmp #1
        bne d4_2
        ldx #190
        stx random4
         ldx #2
        stx loc4
        rts
   d4_2:  cmp #2
        bne d4_3
        ldx #45
        stx random4
         ldx #180
        stx loc4
        rts
   d4_3:  cmp #3
        bne d4_4
        ldx #152
        stx random4
        ldx #18
        stx loc4

        rts
   d4_4:  cmp #4
        bne d4_5
        ldx #15
        stx random4
          ldx #150
        stx loc4

        rts
   d4_5:  cmp #5
        bne d4_6
        ldx #90
        stx random4
          ldx #220
        stx loc4

        rts
   d4_6:  cmp #6
        bne d4_7
        ldx #625
        stx random4
        ldx #49
        stx loc4

        rts
   d4_7:  cmp #7
        bne d4_8
        ldx #995
        stx random4
          ldx #130
        stx loc4

        rts

   d4_8:  cmp #8
        bne d4_9
        ldx #540
        stx random4
          ldx #84
        stx loc4

        rts
   d4_9:   cmp #9
        bne d4_10
        ldx #320
        stx random4
          ldx #3
        stx loc4

        rts
   d4_10: cmp #10
        bne d4_11
        ldx #57
        stx random4
          ldx #234
        stx loc4

        rts
   d4_11: cmp #11
        bne d4_12
        ldx #10
        stx random4
          ldx #213
        stx loc4

        rts
   d4_12: cmp #12
        bne d4_13
        ldx #415
        stx random4
          ldx #80
        stx loc4

        rts
   d4_13: cmp #13
        bne d4_14
        ldx #70
        stx random4
          ldx #60
        stx loc4

        rts
   d4_14: cmp #14
        bne d4_15
        ldx #730
        stx random4
          ldx #10
        stx loc4

        rts
   d4_15: cmp #15
        bne d4_16
        ldx #310
        stx random4
          ldx #78
        stx loc4

  d4_16:
        rts

  ;;;;;;;;;;;;;4

 delay5:
        lda k

        cmp #1
        bne d5_2
        ldx #490
        stx random5
        ldx #50
        stx loc5

        rts
   d5_2: lda k
          cmp #2
        bne d5_3
        ldx #3
        stx random5
        ldx #250
        stx loc5

        rts
   d5_3:  lda k
          cmp #3
        bne d5_4
        ldx #512
        stx random5
        ldx #20
        stx loc5

        rts
   d5_4:  lda k
          cmp #4
        bne d5_5
        ldx #15
        stx random5
        ldx #228
        stx loc5

        rts
   d5_5:  lda k
          cmp #5
        bne d5_6
        ldx #250
        stx random5
        ldx #90
        stx loc5

        rts
   d5_6:  lda k
          cmp #6
        bne d5_7
        ldx #125
        stx random5
        ldx #190
        stx loc5

        rts
   d5_7:  lda k
          cmp #7
        bne d5_8
        ldx #45
        stx random5
        ldx #10
        stx loc5

        rts

   d5_8:  lda k
          cmp #8
        bne d5_9
        ldx #84
        stx random5
        ldx #170
        stx loc5

        rts
   d5_9:lda k
        cmp #9
        bne d5_10
        ldx #720
        stx random5
        ldx #100
        stx loc5

        rts
   d5_10:
          lda k
          cmp #10
        bne d5_11
        ldx #440
        stx random5
        ldx #198
        stx loc5

        rts
   d5_11: lda k
          cmp #11
        bne d5_12
        ldx #590
        stx random5
        ldx #12
        stx loc5

        rts
   d5_12: lda k
          cmp #12
        bne d5_13
        ldx #15
        stx random5
        ldx #50
        stx loc5

        rts
   d5_13: lda k
          cmp #13
        bne d5_14
        ldx #72
        stx random5
        ldx #240
        stx loc5

        rts
   d5_14: lda k
          cmp #14
        bne d5_15
        ldx #170
        stx random5
        ldx #180
        stx loc5

        rts
   d5_15: lda k
          cmp #15
        bne d5_16
        ldx #210
        stx random5
        ldx #215
        stx loc5

  d5_16:
        rts

  ;;;;;;;;;;;;;;;;;5

 delay6:
        lda k

        cmp #1
        bne d6_2
        ldx #2
        stx random6
        ldx #7
        stx loc6

        rts
   d6_2:  cmp #2
        bne d6_3
        ldx #100
        stx random6
        ldx #72
        stx loc6

        rts
   d6_3:  cmp #3
        bne d6_4
        ldx #715
        stx random6
        ldx #97
        stx loc6

        rts
   d6_4:  cmp #4
        bne d6_5
        ldx #355
        stx random6
        ldx #157
        stx loc6

        rts
   d6_5:  cmp #5
        bne d6_6
        ldx #890
        stx random6
        ldx #72
        stx loc6

        rts
   d6_6:  cmp #6
        bne d6_7
        ldx #125
        stx random6
        ldx #193
        stx loc6

        rts
   d6_7:  cmp #7
        bne d6_8
        ldx #395
        stx random6
        ldx #32
        stx loc6

        rts

   d6_8:  cmp #8
        bne d6_9
        ldx #1210
        stx random6
        ldx #217
        stx loc6

        rts
   d6_9:   cmp #9
        bne d6_10
        ldx #310
        stx random6
        ldx #17
        stx loc6

        rts
   d6_10: cmp #10
        bne d6_11
        ldx #430
        stx random6
        ldx #72
        stx loc6

        rts
   d6_11: cmp #11
        bne d6_12
        ldx #12
        stx random6
        ldx #234
        stx loc6

        rts
   d6_12: cmp #12
        bne d6_13
        ldx #134
        stx random6
        ldx #163
        stx loc6

        rts
   d6_13: cmp #13
        bne d6_14
        ldx #290
        stx random6
        ldx #212
        stx loc6

        rts
   d6_14: cmp #14
        bne d6_15
        ldx #7
        stx random6
        ldx #134
        stx loc6

        rts
   d6_15: cmp #15
        bne d6_16
        ldx #615
        stx random6
        ldx #120
        stx loc6

  d6_16:
        rts
  ;;;;;;;;;;;;;;;;;6

 delay7:
        lda k

        cmp #1
        bne d7_2
        ldx #590
        stx random7
        ldx #27
        stx loc7

        rts
   d7_2:  cmp #2
        bne d7_3
        ldx #300
        stx random7
        ldx #126
        stx loc7

        rts
   d7_3:  cmp #3
        bne d7_4
        ldx #60
        stx random7
        ldx #63
        stx loc7

        rts
   d7_4:  cmp #4
        bne d7_5
        ldx #15
        stx random7
        ldx #186
        stx loc7

        rts
   d7_5:  cmp #5
        bne d7_6
        ldx #160
        stx random7
        ldx #92
        stx loc7

        rts
   d7_6:  cmp #6
        bne d7_7
        ldx #725
        stx random7
        ldx #212
        stx loc7

        rts
   d7_7:  cmp #7
        bne d7_8
        ldx #945
        stx random7
        ldx #123
        stx loc7

        rts

   d7_8:  cmp #8
        bne d7_9
        ldx #84
        stx random7
        ldx #73
        stx loc7

        rts
   d7_9:   cmp #9
        bne d7_10
        ldx #125
        stx random7
        ldx #42
        stx loc7

        rts
   d7_10: cmp #10
        bne d7_11
        ldx #240
        stx random7
        ldx #192
        stx loc7

        rts
   d7_11: cmp #11
        bne d7_12
        ldx #19
        stx random7
        ldx #49
        stx loc7

        rts
   d7_12: cmp #12
        bne d7_13
        ldx #425
        stx random7
        ldx #229
        stx loc7

        rts
   d7_13: cmp #13
        bne d7_14
        ldx #20
        stx random7
        ldx #39
        stx loc7

        rts
   d7_14: cmp #14
        bne d7_15
        ldx #720
        stx random7
        ldx #55
        stx loc7

        rts
   d7_15: cmp #15
        bne d7_16
        ldx #50
        stx random7
        ldx #166
        stx loc7

  d7_16:
       rts
;;;;;;;;;;;;;;;
delay8:
        lda k

        cmp #1
        bne d8_2
        ldx #1000
        stx random8
        ldx #80
        stx loc8

        rts
   d8_2:  cmp #2
        bne d8_3
        ldx #1000
        stx random8
        ldx #200
        stx loc8

        rts
   d8_3:  cmp #3
        bne d8_4
        ldx #1000
        stx random8
        ldx #20
        stx loc8

        rts
   d8_4:  cmp #4
        bne d8_5
        ldx #1000
        stx random8
        ldx #126
        stx loc8

        rts
   d8_5:  cmp #5
        bne d8_6
        ldx #1000
        stx random8
        ldx #220
        stx loc8

        rts
   d8_6:  cmp #6
        bne d8_7
        ldx #1000
        stx random8
        ldx #112
        stx loc8

        rts
   d8_7:  cmp #7
        bne d8_8
        ldx #1000
        stx random8
        ldx #12
        stx loc8

        rts

   d8_8:  cmp #8
        bne d8_9
        ldx #1000
        stx random8
        ldx #60
        stx loc8

        rts
   d8_9:   cmp #9
        bne d8_10
        ldx #1000
        stx random8
        ldx #190
        stx loc8

        rts
   d8_10: cmp #10
        bne d8_11
        ldx #1000
        stx random8
        ldx #120
        stx loc8

        rts
   d8_11: cmp #11
        bne d8_12
        ldx #1000
        stx random8
        ldx #99
        stx loc8

        rts
   d8_12: cmp #12
        bne d8_13
        ldx #1000
        stx random8
        ldx #29
        stx loc8

        rts
   d8_13: cmp #13
        bne d8_14
        ldx #1000
        stx random8
        ldx #39
        stx loc8

        rts
   d8_14: cmp #14
        bne d8_15
        ldx #1000
        stx random8
        ldx #155
        stx loc8

        rts
   d8_15: cmp #15
        bne d8_16
        ldx #1000
        stx random8
        ldx #16
        stx loc8

  d8_16:
       rts
;;;;;;;;;;;;;;;;
;;upmotion--jsr to load 2 diffrent frames continuesly while moving up
;;
;;
 upmotion:
         lda up_frame
         cmp #0
         bne zoo1
         
         lda L
         cmp #1
         bne wq
         jsr up_left2
         jmp fbc

     wq : jsr up_right2

    fbc: lda #1
         sta up_frame
    tata:rts

   zoo1: lda up_frame
         cmp #1
         bne zoo2
         
         lda L
         cmp #1
         bne wq1
         jsr up_left3
         jmp fbc1
  wq1:   jsr up_right3
  fbc1:  lda #0
         sta up_frame
  zoo2:        rts



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;to load first frame of upmotion

load_firstmotion:
                ;    lda go
                ;    cmp #1
                ;   bne gk1

        LDA mh2
        CMP #20
        BEQ lh1
        inc mh2

        lda L
        cmp #0
        bne gjj1
        jsr up_right1
        rts
    gjj1:jsr up_left1
        rts

   lh1:lda #0
       sta mh2

     ;  sta go

  gk1:     RTS
;;;;;;;;;;;;;;;;;;;;;;;
;;drift1-2--- to move hanuman up & down continuesly
;;
;;
;;
drift1:
              dec $051C
              dec $0520
              dec $0524
              dec $0528
              dec $052C
              dec $0530
              dec $0534
              dec $0538
              dec $053C
              dec $0540
              dec $0544
              dec $0548
              dec $054C
              dec $0550
              dec $0554
              dec $0558
              dec $051C
              dec $0520
              dec $0524
              dec $0528
              dec $052C
              dec $0530
              dec $0534
              dec $0538
              dec $053C
              dec $0540
              dec $0544
              dec $0548
              dec $054C
              dec $0550
              dec $0554
              dec $0558
              
            
              rts

drift2:

       inc $0528
        inc $0524
        inc $0520
        inc $051C
        inc $052C
        inc $0530
        inc $0534
        inc $0538
        inc $053C
        inc $0540
        inc $0544
        inc $0548
        inc $054C
        inc $0550
        inc $0554
        inc $0558
        inc $0528
        inc $0524
        inc $0520
        inc $051C
        inc $052C
        inc $0530
        inc $0534
        inc $0538
        inc $053C
        inc $0540
        inc $0544
        inc $0548
        inc $054C
        inc $0550
        inc $0554
        inc $0558
chu1:    rts



;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;
controller_test:
                lda scroll_h
                sta $2005
                lda scroll_v
                sta $2005

                lda trig_controller1
                cmp #1
                bne chu1
       lda oover123
       cmp #1
      beq chu1

      lda trig_endmotion
      cmp #1
      beq chu1

      lda trig_startmotion
      cmp #1
      beq chu1

       lda go
       cmp #1
       beq ahh
       lda bo
       cmp #1
       beq ahh

       lda L
         cmp #0
         bne jf

        jsr trig_updown1
        jsr load_NR1
        jmp ahh
  jf:


   ggt1: jsr trig_updown2
         jsr load_NL1
       ;;;;;;;;;;;
 ahh:   lda control
        bne chu1

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
	  jmp CheckUp
        back50 :
        rts



; Now we are moving 4 sprites together. so now the horizontal position of sprite 0,1,2,3 are stored in 503,507,50B and 50F respectively
; The vertical position is stored in 500,504,508 and 50C respectively. So now we simltaneously increase or decrease the position of all 4 sprites.
; This in done in code. For Check up - we have decresed the vertical position of all 4 sprites in order. For check down, we have increased the
; the vertical position in order.now each tile has 8 pixel. So for check left and check right, we have put boundary and accordingly adjusted its
; value with the position. Remember the the position difference should be 8.
CheckUp:
	LDA #%00010000
	;AND justpressed
	AND buttons
        BEQ CheckDown1
        ;lda #100
        ;sta scroll_step
        ;lda #10
        ;sta scrollup_act
        lda L
        cmp #0
        bne up1
       ; jsr loadR_up

       jsr load_firstmotion
       jsr upmotion           ;to change the frames when hanuman moves up with left side face
        jmp upp
        CheckDown1:
                   jmp CheckDown
    up1:;jsr loadL_up
         jsr upmotion          ;to change the frames when hanuman moves up with left side face
    upp:

         lda #$01
        sta varX
        lda $051c
        cmp #70
        beq CheckDown
        cmp #77
        beq CheckDown
        cmp #75
        beq CheckDown
        cmp #73
        beq CheckDown
        jsr dec_hanuman

        LDA #%00000010
	;AND justpressed
	AND buttons
        BEQ CheckDown
        jsr dec_hanuman
      ;lda #10
        ;sta scrollup_act



CheckDown:
	LDA #%00100000
	;AND justpressed
	AND buttons
	BEQ CheckLeft1
        ;lda #100
        ;sta scroll_step
        ;lda #10
        ;sta scrolldown_act
         lda L
        cmp #0
        bne cp1
        jsr loadR_down            ;to change the frames when hanuman moves down with right side face
        jmp cpp
        CheckLeft1:
                   jmp CheckLeft
    cp1:jsr loadL_down            ;to change the frames when hanuman moves down with left side face
    cpp:

        lda #$01
        sta varX
        lda $558
        cmp #225
        beq CheckLeft
        cmp #227
        beq CheckLeft
        cmp #229
        beq CheckLeft
        cmp #231
        beq CheckLeft
        jsr inc_hanuman

        LDA #%00000010
	;AND justpressed
	AND buttons
	BEQ CheckLeft
	jsr inc_hanuman
     	;lda #10
        ;sta scrolldown_act


CheckLeft:
	LDA #%01000000
	;AND justpressed
	AND buttons
	BEQ CheckRight

        lda #1
        sta L
        jsr loadL               ;to change the frames when hanuman moves left
      ;  lda scroll_h
       ; sta scroll_h_temp
       ; lda scroll_v
       ; sta scroll_v_temp
       ; lda #0
       ; sta scroll_h
       ; sta scroll_v
;        jsr update_sprites1
  ; 	LDA #%10001000
;	STA $2000


;        lda ppucntl
 ;       sta $2000
        ;;;;;;;
        lda #$01
        sta varX
        jsr dec_hanuman_left

        LDA #%00000010
	;AND justpressed
	AND buttons
	BEQ CheckRight
        jsr dec_hanuman_left

CheckRight:
	LDA #%10000000
	;AND justpressed
	AND buttons
	BEQ CheckSel

	lda #0
	sta L

       jsr loadR      ;to change the frames when hanuman moves right

        lda #$01
        sta varX
        jsr inc_hanuman_right

        LDA #%00000010
	;AND justpressed
	AND buttons
	BEQ CheckSel
	jsr inc_hanuman_right


CheckSel:
	LDA #%00000100
	AND justpressed
	BEQ CheckStart
     ;   lda #47
     ;   sta level1_complete
CheckStart
	LDA #%00001000
	AND justpressed
	BEQ CheckB


CheckB:
	LDA #%00000010
	AND justpressed
	BEQ CheckA

;          lda fast_speed
;        cmp #1
;        bne change
;        lda #0
;        sta fast_speed
;        jmp CheckA
;change:
;       lda #1
;       sta fast_speed


CheckA:
	LDA #%00000001
	AND justpressed
	BEQ CheckOver


CheckOver:
  back5:        RTS
;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;trig updown1-2--- to move hanuman up & down continuesly
;;
;;
;;

trig_updown1:

             INC tpp
              lda tpp
             CMP #18
             BNE taa
             lda #0
             sta tpp

            lda updown1
            cmp #0
            bne cct
            jsr drift1
            lda #1
            sta updown1
            rts
        cct:jsr drift2
             lda #0
             sta updown1
    taa:      rts

;;;;;;;;;;;;;;;;;;;
trig_updown2:

             INC tpp
              lda tpp
             CMP #18
             BNE taa
             lda #0
             sta tpp

        lda updown2
        cmp #0
        bne cct1
        jsr drift1
        lda #1
        sta updown2
        rts
    cct1:jsr drift2
         lda #0
         sta updown2
         rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;endmotion---to enable endmotion of hanuman when level completes
;;
;;
;;
endmotion:

          lda trig_endmotion
          cmp #1
          bne hoo
      

        lda $051c
        cmp #$00
        bne jjm

        lda #$00
        sta $51D
        sta $521
        sta $525
        sta $529
        sta $52D
        sta $531
        sta $535
        sta $539
        sta $53D
        sta $541
        sta $545
        sta $549
        sta $54D
        sta $551
        sta $555
        sta $559

        lda #0
        sta trig_endmotion
     ;   lda #10
     ;   sta level1_complete
      jsr blank_load
      jsr clear_hanuman


      lda #1
      sta trig_disp_level1

  hoo:      rts

  jjm :
        jsr upmotion           ;to change the frames when hanuman moves up with left side face
        jsr dec_hanuman
   koo: rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;startmotion---to enable start motion of hanuman when level begins
;;
;;
;;
startmotion:

         lda trig_startmotion
          cmp #1
          bne hoo1



        lda $051c
        cmp #160
        bpl jjb
          lda #0
          sta trig_startmotion
              jsr LoadSprites1
              lda #0
              sta trig_gud
              sta trig_bad
              sta trig_que
              
             


  hoo1:      rts
        
  jjb :
        jsr upmotion           ;to change the frames when hanuman moves up with left side face
        jsr dec_hanuman
        rts


;;;;;;;;;;;;;;;;;;;;;;;;
up_right1:
                ldx #0
                ldy #0

upr1:
                lda up_r1,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne upr1
                RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;
up_right2:

                ldx #0
                ldy #0

upr2:
                lda up_r2,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne upr2
                RTS
                

up_right3:

                ldx #0
                ldy #0

upr3:
                lda up_r3,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne upr3
                RTS




;;;;;;;;;;;;;;;;;;;;;;;;
;;;jsr to change the frames while moving up(leftside face)
loadL_up:

        LDA u1
        cmp #0
        bne sd
        jsr up_left1
        lda #1
        sta u1
        rts

sd :   jsr up_left2
       lda #0
       sta u1
       rts
;;;;;;;;;;;;;;;;;;;;;;;;;
;;;jsr to change the frames while moving up(rightside face)
 loadR_up:

        LDA u2
        cmp #0
        bne sd1
        jsr up_right1
        lda #1
        sta u2
        rts

sd1 :   jsr up_right2
       lda #0
       sta u2
       rts
 ;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;jsr to change the frames while moving down(leftside face)
 loadL_down:

        LDA u3
        cmp #0
        bne sd3
        jsr down_left1
        lda #1
        sta u3
        rts

sd3 :   jsr down_left2
       lda #0
       sta u3
       rts
;;;;;;;;;;;;;;;;;;;;;;;;;
;;;jsr to change the frames while moving down(rightside face)
 loadR_down:

        LDA u4
        cmp #0
        bne sd4
        jsr down_right1
        lda #1
        sta u4
        rts

sd4 :   jsr down_right2
       lda #0
       sta u4
       rts
;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;

down_right1:
                ldx #0
                ldy #0

dnr1:
                lda dn_r1,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne dnr1
                RTS
;;;;;;;;;;;;;;;;;;;;;;;;
down_right2:
                ldx #0
                ldy #0

dnr2:
                lda dn_r2,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne dnr2
                RTS
;;;;;;;;;;;;;;;;;;;;;;;


up_left1:
                ldx #0
                ldy #0

upl1:
                lda up_l1,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne upl1
                RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;
up_left2:
                ldx #0
                ldy #0

upl2:
                lda up_l2,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne upl2
                RTS
;;;;;;;;;;;;;;;;;;;;;;;;;
up_left3:
                ldx #0
                ldy #0

upl3:
                lda up_l3,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne upl3
                RTS
;;;;;;;;;;;;;;;;;;;;;;;;;


down_left1:
                ldx #0
                ldy #0

dnl1:
                lda dn_l1,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne dnl1
                RTS
;;;;;;;;;;;;;;;;;;;;;;;;
down_left2:
                ldx #0
                ldy #0

dnl2:
                lda dn_l2,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne dnl2
                RTS
;;;;;;;;;;;;;;;;;;;;;;;;
;;to load frames while moving left
;;
;;
loadL:
        LDA countl
        cmp #$01
        beq L2
        LDA countl

        cmp #$02
        beq L3
        LDA countl

        cmp #$03
        beq L4
        LDA countl

        CMP #$00
        beq L1

L1:
        jsr load_L1

        LDA #$01
        STA countl
        RTS

L2:    jsr load_L3
        LDA #$02
        STA countl
        RTS


L3:jsr load_L2
        LDA #$03
        STA countl
        RTS

L4:jsr load_L4
        LDA #$00
        STA countl
        RTS

;;;;;;;;;;;;;;;;;;;;;;;;
;;to load frames while moving right
;;
;;
loadR:
        LDA countr
        cmp #$01
        beq L2r
        LDA countr

        cmp #$02
        beq L3r
        LDA countr

        cmp #$03
        beq L4r
        LDA countr

        CMP #$00
        beq L1r

L1r:
        jsr load_R1

        LDA #$01
        STA countr
        RTS

L2r:    jsr load_R3
        LDA #$02
        STA countr
        RTS


L3r:jsr load_R2
        LDA #$03
        STA countr
        RTS

L4r:jsr load_R4
        LDA #$00
        STA countr
        RTS





;;;;;;;;;;;;;;;;;;;;;;;;
load_R1:
                ldx #0
                ldy #0

ldr1:
                lda ld_r1,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne ldr1
                RTS

load_R2:
                ldx #0
                ldy #0

ldr2:
                lda ld_r2,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne ldr2
                RTS

load_R3:
                ldx #0
                ldy #0

ldr3:
                lda ld_r3,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne ldr3
                RTS
load_R4:
                ldx #0
                ldy #0

ldr4:
                lda ld_r4,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne ldr4
                RTS

 ;;;;;;;;;;;;;;;;;;;

load_L1:
                ldx #0
                ldy #0

ldl1:
                lda ld_l1,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne ldl1
                RTS

load_L2:
                ldx #0
                ldy #0

ldl2:
                lda ld_l2,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne ldl2
                RTS

load_L3:
                ldx #0
                ldy #0

ldl3:
                lda ld_l3,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne ldl3
                RTS

load_L4:
                ldx #0
                ldy #0

ldl4:
                lda ld_l4,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne ldl4
                RTS




 ;;;;;;;;;;;;;;;
 load_NL1:
                lda L
                cmp #0
                beq l1
                ldx #0
                ldy #0

lnl1:
                lda ln_l1,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne lnl1
l1:             RTS

load_NL2:
                lda L
                cmp #0
                beq l2
                ldx #0
                ldy #0

lnl2:
                lda ln_l2,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne lnl2
l2:             RTS

load_NL3:             ;;for bad obj only
                lda L
                cmp #0
                beq l3
                ldx #0
                ldy #0

lnl3:
                lda ln_l3,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne lnl3
l3:             RTS

 ;;;;;;;;;;

load_NR1:
                lda L
                cmp #1
                beq r1
                ldx #0
                ldy #0

lnr1:
                lda ln_r1,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne lnr1
r1:             RTS

load_NR2:
                lda L
                cmp #1
                beq r2
                ldx #0
                ldy #0

lnr2:
                lda ln_r2,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne lnr2
r2:             RTS

load_NR3:              ;;for bad object only
                lda L
                cmp #1
                beq r3
                ldx #0
                ldy #0

lnr3:
                lda ln_r3,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne lnr3
r3:             RTS




 ;;;;;;;;;;

inc_k:  inc k
        lda k
        cmp #15
        bne rr1
         lda #1
         sta k
    rr1: rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
timepass: INC varYY
                lda varYY
                 CMP #1
            BNE TP1

            jsr inc_k
            LDA #$00
            STA varY

         TP1:rts
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 newgd_touch:
       lda trig_controller1
       cmp #1
       bne @TP2
       lda $52C
       sta head
       dec head
       dec head
        ldy #0
        ldx #0
@touch_loop:
           lda $5c8
           cmp head                ; comparing the y position of the bag
           beq @obj
           inc head
           cmp head                ; comparing the y position of the bag
           beq @obj
           inc head
           cmp head                ; comparing the y position of the bag
           beq @obj

@TP2:
           rts

;------------------------------------------------
@obj:
lda $5cb                 ;loading the x position of corresponding tiles
sta bad                ; loading x position of corresponding object in varyjsr

lda L
cmp #0
beq @right6
lda $52f
sta hanu                  ; loading x position of bag when hanuman is moving left
jmp @loopin6

@right6:
lda $537                  ; loading x position of bag when hanuman is moving right
sta hanu

@loopin6:
lda bad
sta temp_varyjsr
lda #8
sta loop_var1
;lda #7
sta loop_var2
@touch_loop1:
            lda hanu
            cmp bad
            beq @detected
            inc bad
            dec loop_var1
            lda loop_var1
            cmp #0
            bne @touch_loop1
            lda temp_varyjsr
            sta bad
            dec loop_var2
            inc hanu
            lda #7
            sta loop_var1
            lda loop_var2
            cmp #0
            bne @touch_loop1
            rts

@detected:
          lda #$ff
          sta $5cb
          lda #1
          sta go
          sta go0
          lda #80
          sta scro
@TP1:
          rts
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  touch:
       lda touch_trig
       cmp #1
       bne TP11
       lda $52C
       sta bag_vertical
       dec bag_vertical
       dec bag_vertical
        ldy #0
        ldx #0
touch_loop:
           lda $500,y
           cmp bag_vertical                ; comparing the y position of the bag
           beq obj
           inc bag_vertical
           cmp bag_vertical                ; comparing the y position of the bag
           beq obj
           inc bag_vertical
           cmp bag_vertical                ; comparing the y position of the bag
           beq obj
           iny
           iny
           iny
           iny
           inx
           dec bag_vertical
           dec bag_vertical
           cpx #7
           bne touch_loop
TP11:
           rts

;------------------------------------------------
obj:
iny
iny
iny
lda $500,y                 ;loading the x position of corresponding tiles
sta varyjsr                ; loading x position of corresponding object in varyjsr



lda L
cmp #0
beq right6
lda $52F
sta vary                  ; loading x position of bag when hanuman is moving left
jmp loopin6

right6:
lda $537                  ; loading x position of bag when hanuman is moving right
sta vary

loopin6:
lda varyjsr
sta temp_varyjsr
lda #7
sta loop_var1
sta loop_var2
touch_loop1:
            lda vary
            cmp varyjsr
            beq detected
            inc varyjsr
            dec loop_var1
            lda loop_var1
            cmp #0
            bne touch_loop1
            lda temp_varyjsr
            sta varyjsr
            dec loop_var2
            inc vary
            lda #7
            sta loop_var1
            lda loop_var2
            cmp #0
            bne touch_loop1
            rts

amj:jmp circle


detected:
         dey
         dey
         lda $500,y
         cmp #$02

         beq amj
         cmp #$ca
         beq amj
         cmp #$da
         beq amj

detected_loop:
              cmp #$13
              beq arrow1
              cmp #$47
              beq arrow1
              cmp #$3B
              beq arrow1
              jmp square

;-----------------------------------------------
arrow1:
jmp arrow

square:
      ; iny
      ; iny

   sty bad_temp
   ldx bad_temp

   iny
   iny
   lda #$ff
   sta $500,y

   lda #1
   sta bo
   sta bo0


  lda $500,x
   cmp #$15
   beq skull

   lda $500,x
  cmp #$20
  beq skull

   lda $500,x
  cmp #$21
  beq cross

   lda $500,x
   cmp #$14
   beq fire

  lda $500,x
  cmp #$26
  beq fire


  lda $500,x
  cmp #$05
  beq poison


      jmp conti

skull:
lda #240
sta scro
rts

cross:
lda #30
sta scro
rts

fire:
lda #20
sta scro
rts

poison:
lda #0
sta bo
sta bo0
lda #1
sta go
sta go0
lda #10
sta scro
rts

 ;;;;THis is the place where the program executes when a question is taken....
circle:
       iny
       iny
       lda #$ff
       sta $500,y
       lda gamelevel
       cmp #0
       bne skip_qs
        bne skip_qs1
        LDA #$02
        JSR setCHRPage0000
        LDA #$03
        jsr pal_changeforquestion
       jsr Questionscreen
skip_qs:
        cmp #1
        bne skip_qs1
         bne skip_qs1
        LDA #$02
        JSR setCHRPage0000
        LDA #$03
        jsr pal_changeforquestion
        jsr Questionscreen_1
skip_qs1:

       jmp conti

arrow:

sty bad_temp
   ldx bad_temp

iny
iny
lda #$ff
sta $500,y
lda #1
sta go
sta go0       ;inc points


 lda $500,x
   cmp #$13
   beq banana
   cmp #$47
   beq banana

lda $500,x
   cmp #$3B
   beq mango


conti:
      RTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
banana:
lda #20
sta scro
rts

mango:
lda #40
sta scro
rts

conti23:
rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


endscreen:

lda oover
cmp #1
beq endscccr
rts

endscccr:
lda #1
sta oover123

lda #$00
sta $51D
sta $521
sta $525
sta $529
sta $52D
sta $531
sta $535
sta $539
sta $53D
sta $541
sta $545
sta $549
sta $54D
sta $551
sta $555
sta $559

endscrr:

inc timend
lda timend
cmp #100            ; time for entry after screen is clear
beq conti3
rts

conti3:
lda #0
sta oover
sta levelnum
ldx #0

;clearing the falling objects
; ask ankit to disable his code of falling objs.
 ldx #$0
   @cls3:
      STA $500, x
      INX
      CPX #28
      BNE @cls3

lda #1
sta random_enable
; hanuman position y

  ldx #0
       ldy #0

ypos:
                lda ypost,x
                sta $51C,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne ypos

; x pos


       ldx #0
       ldy #0

xpos:
                lda xpost,x
                sta $51F,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne xpos
;; tiles

       ldx #0
       ldy #0

til:
                lda hanutile,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne til


 lda #1
 sta moveendtrig
 jsr moveend


rts


moveend:

        lda moveendtrig
        cmp #1
        bne conti4

        lda#0
	sta L

       jsr loadR

        lda #$01
        sta varX
        jsr inc_hanuman_right

        lda $523
        cmp #$80
        beq throwbag


;;; now moving
conti4:

rts

throwbag:

lda #0
sta moveendtrig

lda #$01
sta sadface
lda #0
sta cntr

rts

face:
lda sadface
cmp #01
bne conti4

face1:
             ldx #0
       ldy #0

sadf:
                lda sadfac,x
                sta $51D,y
                iny
                iny
                iny
                iny
                inx
                cpx #16
                bne sadf

jsr update_sprites

inc cntr
lda cntr
cmp #120   ;; waiting time for sad face
bne conti4


;jsr update_sprites

lda #0
sta sadface

lda #1
sta downbagtrig


lda #$48
sta $575
lda #$58
sta $579

lda $579
sta bagpos

jsr update_sprites

lda #1
sta moveawaytrig

rts

baggoingdown:

lda downbagtrig
cmp #1
bne conti43

inc $578
inc $574

lda $578
cmp #$FF   ; compare position end point
beq erasebag

conti43:
rts

erasebag:
lda #00
sta $575
sta $579
rts

moveaway:

lda moveawaytrig
cmp #1
bne conti43


lda #1
        sta L
        jsr loadL


        ;;;;;;;
        lda #$01
        sta varX
        jsr dec_hanuman_left

        lda $51F
        cmp #$00
        beq theend

rts

theend:
lda #0
sta moveawaytrig

lda #$00
sta $51D
sta $521
sta $525
sta $529
sta $52D
sta $531
sta $535
sta $539
sta $53D
sta $541
sta $545
sta $549
sta $54D
sta $551
sta $555
sta $559


;ldx #$0
;   cls:
;      STA $51C, x
;      INX
;      CPX #64
;      BNE cls
;; credit screen
rts






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 gud_exp:              ;to change the expression when one takes gud object
       lda go
       cmp #1
       bne gg1

        LDA md2
        CMP #30
        BEQ lv1_1
        inc md2
        lda L
        cmp #0
        bne ge1
        jsr load_NR2
        rts
    ge1:jsr load_NL2
        rts

   lv1_1:lda #0
       sta md2
       sta go

  gg1:     RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  right
old_pal:
        sta $51E
        sta $522
        sta $526
        sta $52A

        sta $52E
        sta $532
        sta $536
        sta $53A

        sta $53E
        sta $542
        sta $546
        sta $54A

        sta $54E
        sta $552
        sta $556
        sta $55A
        rts






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;to change the pallete of hanuman when one takes bad objects
;;;
pal_change:

       lda bo
       cmp #1
       bne gj2

        LDA mx4
        CMP #30
        BEQ lj2
        inc mx4

        lda L
        cmp #0
        bne gm2

        lda color_right
        cmp #0
        bne fhh
        lda #0
        jsr old_pal
        lda #1
        sta color_right
        rts

 fhh:
        lda #2
        jsr old_pal
        lda #0
        sta color_right
        rts


gm2:
       lda color_left
        cmp #0
        bne fhh1
        lda #0
        jsr old_pal
        lda #1
        sta color_left
        rts

 fhh1:
        lda #2
        jsr old_pal
        lda #0
        sta color_left
        rts


   lj2:lda #0
       sta mx4
       lda L
       cmp #0
       bne hjk
       lda #0
       jsr old_pal

       rts
     hjk:
          lda #0
          jsr old_pal




  gj2:     RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bad_exp:             ;to change the expression when one takes bad object
        lda bo
       cmp #1
       bne gg2


        LDA md4
        CMP #30
        BEQ lv2
        inc md4
        lda L
        cmp #0
        bne ge2
        jsr load_NR3
        rts
    ge2:jsr load_NL3
        rts

   lv2:lda #0
       sta md4
       sta bo
       lda #0
       jsr old_pal
       jsr old_pal

  gg2:     RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;to clear all sprites including hanuman
;;;
;;;
clear_hanuman:

              lda #$00

              sta $501
              sta $505
              sta $509
              sta $50D
              sta $511
              sta $515
              sta $519
              sta $5c9

              sta $51D
              sta $521
              sta $525
              sta $529
              sta $52D
              sta $531
              sta $535
              sta $539
              sta $53D
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
              sta $57D
              sta $581
              sta $585
              sta $5b9
              sta $5bd
              sta $5c1
              sta $5c5

              rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;start screen controller and is specific to LEVEL1 ; this code will be triggerred by variable screen_start when set to 10
;;;; when start button is pressed screen will load the screen one in $2000 memory and set the value of screen_start to zero.....
;;;;only used in Level1
controller_test_start:




        lda screen_start
        cmp #10
        bne gg2_1

        lda #30
        sta $2001
        lda #1
        sta random_enable
        jsr clear_hanuman
        lda stop_start
        cmp #0
        beq gameenter
        dec stop_start
gg2_1   rts
	LDA buttons_s
gameenter sta oldbuttons_s

        ldx #$00

        LDA #$01		; strobe joypad
	STA $4016
	LDA #$00
	STA $4016
con_loop_s:
	LDA $4016		; check the state of each button
	LSR
	ROR buttons_s
        INX
        CPX #$08
        bne con_loop_s

	LDA oldbuttons_s
	EOR #$FF
	AND buttons_s
	STA justpressed_s

CheckUp_s:
	LDA #%00010000
	;AND justpressed
	AND buttons_s
        BEQ CheckDown_s

CheckDown_s:
	LDA #%00100000
	;AND justpressed
	AND buttons
        Beq CheckLeft_s

CheckLeft_s:
	LDA #%01000000
	;AND justpressed
	AND buttons_s
	BEQ CheckRight_s


CheckRight_s:
	LDA #%10000000
	;AND justpressed
	AND buttons_s
	BEQ CheckSel_s

CheckSel_s:
	LDA #%00000100
;	AND justpressed
        and buttons_s
	BEQ CheckStart_s


CheckStart_s:
        LDA #%00001000
;	AND justpressed
        and buttons_s
	BEQ CheckB_s

        lda #0
        sta random_enable
        lda #0
	sta ps
	jsr press1
       ; jsr LoadSprites1

	lda #1
	sta pp
;	lda #0
;	sta screen_start
        lda #100
        sta desparate
        jsr pal_level
         LDA #$01
  JSR setCHRPage0000
  LDA #$03
  JSR setCHRPage1000

	lda #0
	sta $2001
	jsr mainscreen1
	lda #30
	sta $2001
        lda #1
        sta trig_controller1

CheckB_s:
	LDA #%00000010
;	AND justpressed
        and buttons_s
	BEQ CheckA_s
CheckA_s:
	LDA #%00000001
	AND justpressed
	and buttons_s
	BEQ CheckOver_s

nex14:
 rts
CheckOver_s:
        RTS
load_timer:
           ;lda time_display
           ;cmp #1
           ;bne dis_time_jmp
           ldx time_hundreds
           lda time_palette, x
           sta $57D
           ldx time_tens
           lda time_palette, x
           sta $581
           ldx time_ones
           lda time_palette, x
           sta $585
dis_time_jmp:
           rts
;       ----------------------------------------------------

;       ----------------------------------------------------
delay_1_sec:
            lda time_hundreds
            cmp #0
            bne timecontinue
            lda time_tens
            cmp #0
            bne timecontinue
            lda time_ones
            cmp #0
            beq timeover

            timecontinue:

            lda pp
            cmp #1
            bne delay_1_jmp
            inc sec_count
            lda sec_count
            cmp #60
            bne delay_1_jmp
            lda #1
            sta sec_count
            ;sta dec_time
            dec time_ones
            lda time_ones
            cmp #255
            bne delay_1_jmp
            lda #9
            sta time_ones
            dec time_tens
            lda time_tens
            cmp #255
            bne delay_1_jmp
            lda #9
            sta time_tens
            dec time_hundreds
delay_1_jmp:
            rts

timeover:
lda oover123
cmp #1
beq abc
lda #1
sta oover
lda #0
sta pp

abc:
rts
;--------------------------------------------------------
;         .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
time_palette:
             .db '0','1','2','3','4','5','6','7','8','9'
;      -----------------------------------------------------------------------




  ;;;pallete change for the quiz game main screen....
palchange:
        lda #0
        sta $2001
        ldx #0
        ldy #0

       	LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
load_pal12:                       ; load palette
        LDA palette_new,x
        sta $2007
        inx
        cpx #$20
        bne load_pal12
        lda #30
        sta $2001

brk2rts2  rts



 ;;pallete change for question screen
 pal_changeforquestion:
         lda #0
        sta $2001
        ldx #0
        ldy #0

       	LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
load_pal123:                       ; load palette
        LDA palette_question,x
        sta $2007
        inx
        cpx #$20
        bne load_pal123
        lda #30
        sta $2001
        rts



;; this is the place where the program executes when the whole scrolling of 8 screens in level1 are completed and it gives the animation of "LEVEL2"...and then 
;; triggers the subroutine prgchange
 level1to2:
           lda level1_complete
           cmp #10
           bne dfx
           jsr init_endmotion

         ;  lda #40
         ;  sta level1_complete

dfx           rts
blank_load:
           lda #0
           sta $2001
           LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04


@NameLoop:
        lda #$60
        sta $2007
        iny
        bne @NameLoop
        inc $11
        dex
        bne @NameLoop
         jsr pal_level
        lda #30
        sta $2001

  ;      jsr palchangeforlevel
        rts

lev1_screen1load:
        lda level1_complete
        cmp #47
        bne dn2rts
LDA #$01
JSR setPRGBank
lda #1
sta gamelevel

  LDA #$05
  JSR setCHRPage0000

jsr palchange_galaxy
        lda #0
        sta $2001
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
     ;         jsr palchange
              lda #30
              sta $2001
              lda #99                            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
              sta level1_complete                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
              lda #%10001010
              sta ppucntl
              sta $2000
              lda #239
              sta scroll_v
              lda #0
              sta question_no
              sta question_count
              sta scrolldown_act
              sta scrollup_act
              sta scroll_step
              sta time_ones
              sta time_tens
              lda #6
              sta time_hundreds

              jsr init_startmotion




              ;jsr LoadSprites1
              ;lda #0
              ;sta trig_gud
              ;sta trig_bad
              ;sta trig_que

dn2rts rts

;;this is the place where the program runs when level is completed.., and it makes the prg bank switch after the "LEVEL2" animation is gone.......,it also initialises
;;the values for second level......;
prgchang:

lda level1_complete
cmp #99
bne dn2rtsk

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

@NameLoop1:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop1
        inc $11
        dex
        bne @NameLoop1
  lda #%10001010
              sta ppucntl
              sta $2000
              lda #239
              sta scroll_v
              lda #0
              sta question_no
              sta question_count

              lda #30
              sta $2001


              lda #103                                  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sta level1_complete


lda #0
sta random_enable
sta screen_no
                      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dn2rtsk  rts
;;;;;;;;;;;;;;
;;;to initialize and trigger end motion
;;;
;;;
init_endmotion :

          lda #$00
          sta $501
          sta $505
          sta $509
          sta $50D
          sta $510
          sta $515
          sta $519
          sta $5c9

          lda #1
          sta trig_gud
          sta trig_bad
          sta trig_que


        lda #1
	sta trig_endmotion

    rts
;;;;;;;;;;;;;;
;;;to initialize and trigger start motion
;;;
;;;
init_startmotion:

          lda #$e0
          sta $051C
          sta $0520
          sta $0524
          sta $0528
          lda #$e8
          sta $052C
          sta $0530
          sta $0534
          sta $0538
          lda #$f0
          sta $053C
          sta $0540
          sta $0544
          sta $0548
          lda #$f8
          sta $054C
          sta $0550
          sta $0554
          sta $0558

          lda #$30
          sta $51F
          sta $52F
          sta $53F
          sta $54F

          lda #$38
          sta $523
          sta $533
          sta $543
          sta $553

          lda #$40
          sta $527
          sta $537
          sta $547
          sta $557

          lda #$48
          sta $52B
          sta $53B
          sta $54B
          sta $55B

          lda #1
	  sta trig_startmotion




          rts

pal_level:
         lda #0
        sta $2001
        ldx #0
        ldy #0

       	LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
load_pal1234:                       ; load palette
        LDA palette_level,x
        sta $2007
        inx
        cpx #$20
        bne load_pal1234
        lda #30
        sta $2001
        rts

new_desparate:
        lda desparate
        cmp #100
        bne jo

        lda #1
        sta trig_st
  jo:   rts


back_to_start:
  ;    inc test
  ;    lda test
  ;    cmp #0
  ;    bne @rtt1
      lda #0
      sta desparate
      sta bug_imp
      sta screen_start
      jsr palchange
        lda #0
        sta random_enable
        lda #0
	sta ps
	sta time_ones
	sta time_tens
	lda #6
	sta time_hundreds
	jsr press1

        jsr LoadSprites1
        jsr init_startmotion

	lda #1
	sta pp



 @rtt1:    rts

 ;;Loads the credit screen  and credit screen pallete
 creditscreen_ld:
    jsr palchange_galaxy
        lda #0
       sta $2001
       LDA #$05
       JSR setCHRPage0000
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

@NameLoop211:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop211
        inc $11
        dex
        bne @NameLoop211
        LDA #%00001110
	STA $2001

        sta credit_enable
rts
;;; trigger to load credit screen
 creditscr_load:
 lda credit_enable
 cmp #10
 bne fff2
 inc test
 lda test
 cmp #0
 bne fff2
 jsr creditscreen_ld
 fff2 rts
;;;;;;;;;;;;;;;;;;;
;;;to display "level 1" when first level starts
;;;
;;;
load_sprites_start:

                  lda trig_st
                    cmp #1
                    bne rt

                INC smc1
                lda smc1
                CMP #15
                BNE rt
                lda #0
                sta smc1


 jjk :lda duf1
     cmp #0
     bne jjk1
     lda #$A2     ;;;L
     sta $5A1

     lda #1
     sta duf1
rt:     rts

 jjk1: lda duf1
     cmp #1
     bne jjk2
      lda #$B2     ;;;E
      sta $5A5

     lda #2
     sta duf1
     rts

 jjk2:lda duf1
     cmp #2
     bne jjk3
     lda #$A3     ;;;V
     sta $5A9

     lda #3
     sta duf1
     rts

  jjk3:lda duf1
     cmp #3
     bne jjk4
     lda #$B2    ;;;E
     sta $5AD
     lda #4
     sta duf1
     rts

  jjk4:lda duf1
     cmp #4
     bne jjk5
     lda #$A2    ;;;L
     sta $5B1
     lda #5
     sta duf1
     rts

  jjk5:lda duf1
     cmp #5
     bne jjk6
     lda #$31    ;;;1
     sta $5B5
     lda #6
     sta duf1
     rts


  jjk6:lda duf1
      cmp #6
      bne jjk7

      lda #7
      sta duf1
      rts

  jjk7:lda duf1
      cmp #7
      bne jjk8

      lda #8
      sta duf1
      rts

  jjk8:lda duf1
      cmp #8
      bne jjk9

      lda #$00
      sta $5A1
      sta $5A5
      sta $5A9
      sta $5AD
      sta $5B1
      sta $5B5

     lda #9
     sta duf1

     rts



  jjk9:lda duf1
      cmp #9
      bne jjk10

      lda #10
      sta duf1
      rts

 jjk10: lda #0
        sta trig_st
        jsr back_to_start
        rts
 ;;;;;;;; this is the controller for selecting any of the three games
start_controller:
 dec initiate_con
 lda initiate_con
 cmp #0
 bne @conti
 lda #0
 sta delay_selectup
 sta delay_selectdown
 @conti:
	LDA buttons
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

        lda delay_selectup
        cmp #0
        bne @CheckDown
	LDA #%00010000
	;AND justpressed
	AND buttons
        BEQ @CheckDown
        lda #13
        sta initiate_con
        lda #3
        sta delay_selectup
        lda $500
        cmp #$5F
        beq @three
        cmp #$70
        beq @one
        cmp #$81
        beq @two
 @one:   lda #$5F
        sta $500
        jmp @CheckStart
 @two:  lda #$70
       sta $500
       jmp @CheckStart
@three :
       lda #$81
       sta $500
@CheckDown:

        lda delay_selectdown
        cmp #0
        bne @CheckStart
	LDA #%00100000
	;AND justpressed
	AND buttons
	BEQ @CheckStart
	lda #13
	sta initiate_con
	lda #3
	sta delay_selectdown
        lda $500
        cmp #$5F
        beq @two
        cmp #$70
        beq @three
        cmp #$81
        beq @one

;@CheckSel:
;	LDA #%00000100
;	AND justpressed
;	BEQ @CheckStart

@CheckStart
	LDA #%00001000
	AND justpressed
	BEQ @CheckOver

lda $500
	cmp #$5F
	bne @check2
	jsr make_quiz
	lda #0
	sta screen_start6
	lda #1
	sta game_no
	rts
@check2 cmp #$70
        bne @check3
jsr complete
    rts
@check3:
        cmp #$81
        bne @CheckOver

    ;    LDX #%00011110
     ;   jsr initMMC1Mapper
        lda #3
        JSR setPRGBank
        jsr make_malaria

        lda #00
        tax
        jsr InitAddy

        lda #0
        sta screen_start6




;@CheckB:
;	LDA #%00000010
; 	AND justpressed
;	BEQ @CheckA

;@CheckA:
;	LDA #%00000001
;	AND justpressed
;	BEQ @CheckOver

@CheckOver:
        RTS
;;;;;;;;;;;;;;;;Malaria Game Initialization;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
make_malaria:
lda #0
sta $2001

;jsr initialise_var_malaria
LDA #$0e
JSR setCHRPage0000
LDA #$0f
JSR setCHRPage1000
ldx #0
ldy #0
jsr load_pal_malaria
jsr screen_load_malaria
;	LDA #%10001000
;	sta PPUCRTL
;	STA $2000
;ldx #0
;stx scroll_h
;stx scroll_v
jsr LoadSprites_malaria
lda #30
sta $2001
rts
complete:
        LDA #18
        JSR setCHRPage0000
        jsr pal_typestart
        lda #4
        jsr setPRGBank
        lda #4
        sta game_no1
        lda #0
        sta $2001
       	LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<type_screen
        sta $10
        lda #>type_screen
        sta $11

@NameLoop:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop
        inc $11
        dex
        bne @NameLoop
        lda #%00001110
        sta $2001
        lda #20
        sta screen_start6
        lda #0
        sta game_no1
        lda #0
        JSR setPRGBank
        rts
LoadSprites_malaria:
      LDX #$00
@LoadSpritesLoop:
      LDA sprites_malaria, x            ; load data from address (sprites + x)
      STA $0500, x              ; store into RAM address ($0200 + x)
      INX                       ; X = X + 1
      CPX #108                   ; Compare X to # of values (divide by 4 for total # of sprites)
      BNE @LoadSpritesLoop
      rts
;  -----------------------------------------------
initialise_var_malaria:
                       lda #80
                       sta random44

                       lda #$0f
                       sta freq

                       lda #6
                       sta counter
                       rts
;       ----------------------------------------------
load_pal_malaria:
        LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
@load_pal:                       ; load palette
        LDA palette_mal,x
        sta $2007
        inx
        cpx #$20
        bne @load_pal
        rts
;       ----------------------------------------------
screen_load_malaria:
        LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<screen_malaria
        sta $10
        lda #>screen_malaria
        sta $11

@NameLoop:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop
        inc $11
        dex
        bne @NameLoop

rts
;;;;;;;;;;;;;;;;TYPING GAME INITIALISATION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
screen_load_typing:


   	LDA #$20                ; set to beginning of first nametable
    	STA $2006
    	LDA #$00
    	STA $2006

        LDA #<screen1_typing              ; load low byte of first picture
        STA $10
        LDA #>screen1_typing            ; load high byte of first picture
        STA $11

        LDY #$00
        LDX #$04

@NameLoop:                       ; loop to draw entire nametable
        LDA ($10),y
        STA $2007
        INY
        BNE @NameLoop
        INC $11
        DEX
        BNE @NameLoop
     rts

;-------------------------------
 LoadSpritesLoop_1:
     LDA sprites_rock, x            ; load data from address (sprites + x)
      STA $0540, x              ; store into RAM address ($0200 + x)
      INX                       ; X = X + 1
      CPX #84
                        ; Compare X to # of values (divide by 4 for total # of sprites)
      BNE LoadSpritesLoop_1
      jsr load_hanuman
      rts
load_pal_typing:

       	LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
@load_pal:                       ; load palette
        LDA palette_typing,x
        sta $2007
        inx
        cpx #$20
        bne @load_pal
        lda #0
        sta $2005
        sta $2005
        rts

initialise_var_typing:
        lda #$f8
        sta xright
      ;
       lda #$01
        sta xleft
        sta trigger
        sta var_new
       sta key

        lda #$06
        sta ytop

        lda #$F4
    sta ybottom

         lda #4
         sta tempx

         lda #0
         sta Current
         sta scroll_h
         sta scroll_v
        rts

make_typing:
lda #0
sta $2001
jsr initialise_var_typing
LDA #$06
JSR setCHRPage0000
LDA #$08
JSR setCHRPage1000
ldx #0
ldy #0
jsr load_pal_typing
jsr screen_load_typing
	LDA #%10001000
	sta PPUCRTL
	STA $2000
ldx #0
jsr LoadSpritesLoop_1
lda #30
sta $2001
rts

;;;;;;;;;;;;;;QUIZ Game initialisation  ;;;;;;;;;;
screenload_quiz:
        lda #4
        jsr setPRGBank
        lda #4
        sta game_no1

    	LDA #$20                ; draw screen
    	STA $2006
    	LDA #$00
    	STA $2006

        ldy #$00
        ldx #$04

        lda #<start_screen11
        sta $10
        lda #>start_screen11
        sta $11

@NameLoop:
        lda ($10),y
        sta $2007
        iny
        bne @NameLoop
        inc $11
        dex
        bne @NameLoop
        lda #0
        jsr setPRGBank
        lda #0
        sta game_no1
        ;jsr initMusic
        rts

loadsprites_quiz:
        LDX #$00
@LoadSpritesLoop:
      LDA sprites, x            ; load data from address (sprites + x)
      STA $0500, x              ; store into RAM address ($0200 + x)
      INX                       ; X = X + 1
      CPX #204                   ; Compare X to # of values (divide by 4 for total # of sprites)
      BNE @LoadSpritesLoop
      jsr InitMusic
       rts

palchange_quiz:
      	LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
@load_pal:                       ; load palette
        LDA palette_quiz,x
        sta $2007
        inx
        cpx #$20
        bne @load_pal
        rts
;;; this is the palce where the program executes when he selects hanuman quiz game
make_quiz:
       lda #0
       sta $2001
       ldx #0
       ldy #0
       LDA #$0
       JSR setCHRPage0000
       LDA #$3
       JSR setCHRPage1000
       jsr palchange_quiz
       jsr screenload_quiz
       jsr loadsprites_quiz
       	LDA #%10001010
	STA $2000
	sta ppucntl
       lda #30
       sta $2001
       rts
 ;;;;;;;;;;;;;;;;;;;;;;;
  body_touch:
       lda trig_controller1
       cmp #1
       bne @TP2
       lda $51C
       sta head
       dec head
       dec head
        ldy #0
        ldx #0
@touch_loop:
           lda $500,y
           cmp head                ; comparing the y position of the bag
           beq @obj
           inc head
           cmp head                ; comparing the y position of the bag
           beq @obj
           inc head
           cmp head                ; comparing the y position of the bag
           beq @obj
           iny
           iny
           iny
           iny
           inx
           cpx #3
           bne @touch_loop
@TP2:
           rts

;------------------------------------------------
@obj:
iny
iny
iny
lda $500,y                 ;loading the x position of corresponding tiles
sta bad                ; loading x position of corresponding object in varyjsr



lda L
cmp #0
beq @right6
lda $527
sta hanu                  ; loading x position of bag when hanuman is moving left
jmp @loopin6

@right6:
lda $51f                  ; loading x position of bag when hanuman is moving right
sta hanu

@loopin6:
lda bad
sta temp_varyjsr
lda #8
sta loop_var1
;lda #7
sta loop_var2
@touch_loop1:
            lda hanu
            cmp bad
            beq @detected
            inc bad
            dec loop_var1
            lda loop_var1
            cmp #0
            bne @touch_loop1
            lda temp_varyjsr
            sta bad
            dec loop_var2
            inc hanu
            lda #7
            sta loop_var1
            lda loop_var2
            cmp #0
            bne @touch_loop1
            rts

@detected:
          lda #$ff
          sta $500,y
          lda #1
          sta bo
          sta bo0
@TP1:
          rts
;  ----------------------------------------------------------------------------------------------
body_touch1:
       lda trig_controller1
       cmp #1
       bne @TP2
       lda $530
       sta head
       dec head
       dec head
        ldy #0
        ldx #0
@touch_loop:
           lda $500,y
           cmp head                ; comparing the y position of the bag
           beq @obj
           inc head
           cmp head                ; comparing the y position of the bag
           beq @obj
           inc head
           cmp head                ; comparing the y position of the bag
           beq @obj
           iny
           iny
           iny
           iny
           inx
           cpx #3
           bne @touch_loop
@TP2:
           rts

;------------------------------------------------
@obj:
iny
iny
iny
lda $500,y                 ;loading the x position of corresponding tiles
sta bad                ; loading x position of corresponding object in varyjsr



lda L
cmp #0
beq @right6
lda $533
sta hanu                  ; loading x position of bag when hanuman is moving left
jmp @loopin6

@right6:
lda $533                  ; loading x position of bag when hanuman is moving right
sta hanu

@loopin6:
lda bad
sta temp_varyjsr
lda #8
sta loop_var1
;lda #7
sta loop_var2
@touch_loop1:
            lda hanu
            cmp bad
            beq @detected
            inc bad
            dec loop_var1
            lda loop_var1
            cmp #0
            bne @touch_loop1
            lda temp_varyjsr
            sta bad
            dec loop_var2
            inc hanu
            lda #7
            sta loop_var1
            lda loop_var2
            cmp #0
            bne @touch_loop1
            rts

@detected:
          lda #$ff
          sta $500,y
          lda #1
          sta bo
          sta bo0
@TP1:
          rts
;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;
dec_hanuman:
        dec $051C
        dec $0520
        dec $0524
        dec $0528
        dec $052C
        dec $0530
        dec $0534
        dec $0538
        dec $053C
        dec $0540
        dec $0544
        dec $0548
        dec $054C
        dec $0550
        dec $0554
        dec $0558
rts

inc_hanuman:
        inc $0528
        inc $0524
        inc $0520
        inc $051C
        inc $052C
        inc $0530
        inc $0534
        inc $0538
        inc $053C
        inc $0540
        inc $0544
        inc $0548
        inc $054C
        inc $0550
        inc $0554
        inc $0558
rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;
dec_hanuman_left:
                 dec $051F
        dec $0527
        dec $0523
        dec $052B
        dec $052F
        dec $0537
        dec $0533
        dec $053B
        dec $053F
        dec $0547
        dec $0543
        dec $054B
        dec $054F
        dec $0557
        dec $0553
        dec $055B
        rts
;;;;;;;;;;;;;;;;;;
inc_hanuman_right:
        inc $0523
        inc $052B
        inc $051F
        inc $0527
        inc $052F
        inc $0537
        inc $0533
        inc $053B
        inc $053F
        inc $0547
        inc $0543
        inc $054B
        inc $054F
        inc $0557
        inc $0553
        inc $055B
        rts
;;;;;;;;;;;;;;

pal_typestart:
        lda #0
        sta $2001
        ldx #0
        ldy #0

       	LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
@load_pal12:                       ; load palette
        LDA palette_typestart,x
        sta $2007
        inx
        cpx #$20
        bne @load_pal12
        lda #%00001110
        sta $2001

@brk2rts2  rts

palchange_galaxy:
        lda #0
        sta $2001
        ldx #0
        ldy #0

       	LDA #$3F
	STA $2006
	LDA #$00
	STA $2006
@load_pal12:                       ; load palette
        LDA palette_galaxy,x
        sta $2007
        inx
        cpx #$20
        bne @load_pal12
        lda #30
        sta $2001

@brk2rts2  rts
; --------------------------------------------
;;;;;;;;;;;;;;;;;
arrow11: lda #$1f
        sta $595
        sta $599

        lda #$d8
         sta $594
         sta $598

        rts



arrow22: lda #$d8
         sta $594
         sta $598
         lda #$63
        sta $595
        lda #$73
        sta $599
        lda #$50
         sta $597
         lda #$58
         sta $59b
        rts




press_arrow:
           lda ps2
            cmp #1
            bne avv1

            INC varch8
             lda varch8
             CMP #10
             BNE avv1
             lda #0
             sta varch8

            lda ps3
            cmp #0
            bne ffg1
            jsr arrow11
            lda #1
            sta ps3
            rts

     ffg1:  jsr arrow22
           lda #0
           sta ps3


       avv1: rts


; ---------------------------------------------
start_controller_typing:

	LDA buttons
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


@CheckB:
        LDA #%00000010
	AND justpressed
	BEQ @CheckA
        lda #2
        sta game_no
        lda #2
        JSR setPRGBank
        jsr make_typing

        lda #00
        tax
        jsr InitAddyt

        lda #0
        sta screen_start6


@CheckA:
        RTS
;       --------------------------------------------------

;     -----------------------------------------------

ClearSprites11:
      lda #0
      ldx #0
@loop:
      STA $600, x
      INX
      BNE @loop
      rts
;     -----------------------------------------

;     ----------------------------------------------------
load_correct:
             lda #0
             ldx #0
             ldy #0
             lda #%00000000
             sta $2001
@loop1:
             LDA #$21                ; draw screen
    	     STA $2006
    	     LDA typ_byte,y
    	     STA $2006
    	     sty typ_variable
    	     ldy #0
@loop:
             lda correct_sprite,x
    	     sta $2007
    	     iny
    	     inx
    	     cpy #8
    	     bne @loop
    	     ldy typ_variable
    	     iny
    	     cpy #8
    	     bne @loop1

             lda #%00011110
             sta $2001
             lda #0
             sta $2005
             sta $2005
             rts
;            ----------------------------------------------
load_incorrect:
             lda #0
             ldx #0
             ldy #0
             lda #%00000000
             sta $2001
@loop1:
             LDA #$21                ; draw screen
    	     STA $2006
    	     LDA typ_byte,y
    	     STA $2006
    	     sty typ_variable
    	     ldy #0
@loop:
             lda incorr,x
    	     sta $2007
    	     iny
    	     inx
    	     cpy #8
    	     bne @loop
    	     ldy typ_variable
    	     iny
    	     cpy #8
    	     bne @loop1

             lda #%00011110
             sta $2001
             lda #0
             sta $2005
             sta $2005
             rts
;            -----------------------------------------------
typ_end_seq:
            lda end_seq
            cmp #1
            bne @ppp

              LDA #$10
              JSR setCHRPage0000

              LDA #$0b
              JSR setCHRPage1000




              jsr end_initialization_typ
              lda #0
              sta end_seq

              LDA #$05
              JSR setPRGBank
              
              lda #4
              sta level_change
              
              lda #2
              sta game_no
              
              jsr ClearSprites12

@ppp:       rts

;       -------------------------------------------------
end_initialization_typ:
                       lda #1
                       sta trigger
                       sta var_new
                       sta var1
                       sta trig_controller1
                       sta end_seq_check
                       ;inc level_change
                       ;jsr loading_letters_end
                       rts

;       -------------------------------------------------
NMI:
        lda end_seq_check
        cmp #1
        bne @lol
        jmp ending_seq
@lol:
        lda game_no1
        cmp #4
        bne dwnrr
        rti
dwnrr :  lda screen_start6
        cmp #10
        bne dwntogame
        jsr start_controller
        jsr update_spr_2in1
checkfor2        rti


      ;  jsr load_objects
dwntogame :
        cmp #20
        bne enterthegame
        jsr start_controller_typing
       ; inc delay_start_typing
        ;cmp #0
       ; beq enterthegame
        rti
enterthegame:
        lda game_no
        cmp #1
        bne checkfor2_1
        jsr load_sprites_start
        jsr new_desparate
        jsr endmotion                 ;to enable the motion of hanuman when level completes
        jsr startmotion               ;to enable the motion of hanuman when level begins
        jsr prgchang
        jsr press_start               ;to display "press start" in starting screen
        jsr level1to2
        jsr lev1_screen1load
        jsr gud_exp                   ;to change the frame when one takes gud object
        jsr bad_exp                   ;to change the expression when one takes bad object
        jsr pal_change                ;to change the pallete when one takes bad objects
        jsr load_timer
        jsr delay_1_sec
        jsr controller_test_start
        jsr endscreen
        jsr moveend
        jsr moveaway
        jsr face
        jsr baggoingdown
        jsr update_sprites
        jsr controller_test
        jsr update_sprites1
        
        ;lda fast_speed               ;trigger for turbo speed
        ;cmp #1
        ;bne gt
        ;jsr controller_test
        jmp gt

        checkfor2_1:
        jmp checkfor2_2
        ;lda #0
        ;sta fast_speed
;;;     -------------------------------------------------------
;;;     BANK SWITCHING
  gt:   lda gamelevel
        cmp #0
        bne change_level1
        jsr load_sprites
        jsr scrollup
        jsr scrolldown
        jsr delay_cal
        jsr delay_cal2
        jsr triggering_scroll
        jsr background
        jsr background1
        JSR newcontroller
        jsr PlayAddy


lda random_enable
cmp #0
bne hhhh



        lda varX
        cmp #1
        BNE here
        jsr touch
        jsr newgd_touch
        jsr body_touch
        jsr body_touch1
        jsr load         ; to set diffrent delays for diffrent object


         jsr m1          ; m1-m7 -to drop the seven objects randomly  from the top of the screen
         jsr m2          ; m1-m4 bad objects
         jsr m3          ; m5-quetion object
         jsr m4          ; m6-m7 good objects
         jsr m5          ;
         jsr m6          ;
         jsr m7          ;
         jsr m8

         jsr timepass     ;jst for delay
       RTI
hhhh
      RTI
 here:     jsr inc_k

           jsr load
           lda loc5
           sta #$513
           lda loc8
           sta $5CB

           RTI

change_level1:
              lda gamelevel
              ;cmp #1
              ;bne change_level22

           ;   jsr load_sprites_1
              jsr creditscr_load
              jsr scrollup_1
              jsr scrolldown_1
              jsr delay_cal_1
              jsr delay_cal2_1
              jsr triggering_scroll_1
              jsr background_1
              jsr background1_1
              JSR newcontroller_1
              jsr PlayAddy


lda random_enable
cmp #0
bne hhhh1



        lda varX
        cmp #1
        BNE here1

        jsr touch
        jsr newgd_touch
        jsr body_touch
        jsr body_touch1
        jsr load          ; to set diffrent delays for diffrent object

         jsr m1          ; m1-m7 -to drop the seven objects randomly  from the top of the screen
         jsr m2          ; m1-m4 bad objects
         jsr m3          ; m5-quetion object
         jsr m4          ; m6-m7 good objects
         jsr m5          ;
         jsr m6          ;
         jsr m7          ;
         jsr m3          ;
        ; jsr m4          ;
         jsr m5          ;
         jsr m6          ;
       ;s  jsr m7          ;
         jsr m8


         jsr timepass     ;jst for delay
       RTI
hhhh1
      RTI
 here1:     jsr inc_k

           jsr load
           lda loc5
           sta #$513
           lda loc8
           sta $5CB
IRQ           RTI
checkfor2_2:
         cmp #2
         bne @checkfor3
         jsr update_spr_2in1
         jsr clearing_letters
        ;     ----------------------------------------------------------
        ;     first rock level code
        ;     -----------------------------------------------------------
              lda level_change
              cmp #0
              bne @mon_level

              jsr loading_letters_0
              LDA scroll_h
              STA $2005
              LDA scroll_v
              STA $2005
              jsr Compare_0

              ;jsr scrollanimation_0

              jmp universal
        ;     ----------------------------------------------------------
        ;     first monster level code
        ;     -----------------------------------------------------------
@mon_level:
              lda level_change
              cmp #1
              bne @snake_level

              jsr loading_letters_1
              LDA scroll_h
              STA $2005
              LDA scroll_v
              STA $2005
              jsr Compare_1
              jsr update2
              ;jsr scrollanimation_1

              jmp universal
              @checkfor3: jmp @checkfor3_1
        ;     ----------------------------------------------------------
        ;     second snake code
        ;     -----------------------------------------------------------
@snake_level:
               lda level_change
               cmp #2
               bne @snow_level
               jsr loading_letters
               jsr loading_letters2
               LDA scroll_h
               STA $2005
               LDA scroll_v
               STA $2005
               jsr monster_colour
               jsr mon_exp
               jsr projectile1
               jsr projectile2
               jsr projectile3
               jsr trigger_proj1
               jsr trigger_proj2
               jsr trigger_proj3
               jsr trigger_proj4
               JSR controller_test_typing      ; check for user input
               jsr Compare2          ;to make hanuman walk when we found correct letter
               jsr monster_fun1
               jsr monster_fun2
               jsr delay_typing_lol
               jsr update3

               jmp universal
               @checkfor3_1: jmp checkfor3_2
        ;     ----------------------------------------------------------
        ;     third snow code
        ;     -----------------------------------------------------------
@snow_level:
               lda level_change
               cmp #3
               bne ending_seq
               jsr loading_letters_3
               jsr loading_letters2_3
               LDA scroll_h
               STA $2005
               LDA scroll_v
               STA $2005
               jsr snow_monster_static
               jsr snow_monster_hit
               jsr snow_monster_fall
               jsr monster_colour
               jsr delay_typing_lol
               jsr projectile1
               jsr projectile2
               jsr projectile3
               jsr trigger_proj1
               jsr trigger_proj2
               jsr trigger_proj3
               jsr trigger_proj4
               JSR Compare1_3      ; check for user input
               jsr Compare2_3
               jsr update3
               ;jsr scrollanimation_3
               jmp universal
;              --------------------------------------------------------
ending_seq:
              ;lda level_change
              ;cmp #4
              ;bne universal
               
              jsr typ_end_seq
              jsr loading_letters_end

              jsr ResetKeyboard_end
              jsr ReadKeyboard_end
              jsr ParseKeyboard_end


              jsr typ_end_loading_underlines
              jsr typ_end_clearing_underlines
              jsr typ_end_Compare
              JSR update_spritespp

              jmp ennd
        ;     ----------------------------------------------------------
        ;     universal code
        ;     -----------------------------------------------------------

              universal:
              ;jsr press_arrow

              jsr hanuman_colour                              ;;;;;;universal jsr
              jsr scroll_walk
              jsr loading_underlines
              jsr loading_underlines1

              jsr clearing_underlines
              JSR update_sprites
              jsr ResetKeyboard
              jsr ReadKeyboard
              jsr ParseKeyboard
              jsr walk_fun             ;to make hanuman walk when we found correct letter
              jsr hit_fun
              jsr StartHitRockAnim
              jsr scrollanimation
              LDA scroll_h
               STA $2005
               LDA scroll_v
               STA $2005
              ;jsr PlayAddyt

              rti
checkfor3_2:

        lda screen_change_trigger
        cmp #10
        bne nex
       ;  jsr palchange_mal
nex :   jsr update_sprites

        jsr controller_test_malaria
        jsr garbage_motion
        jsr mos_motion
        jsr ultimate
        jsr PlayAddy
        jsr mos_1
        jsr mos_2
        jsr mos_3
        jsr mos_4
        jsr mos_5

        jsr update_boy
        jsr update_girl
        jsr detection1
       jsr detection2
        jsr detection3
       jsr found1
        jsr found2

      jsr found3
        jsr found4
        jsr found5
        jsr racket_mos
        jsr demoscreen_load
        ;
  ;      jsr PlayAddy            ; play the music
       ;

ennd        RTI


;       ----------------------------------------------------
typ_byte:
.db $0d,$2d,$4d,$6d,$8d,$ad,$cd,$ed
;   ----------------------------------------------------

 sprites_2in1:

;   vert tile attr horiz
;neg o
   ;vert tile attr horiz
.db $5f, $C4, $00, $21 ;sprite 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  typing game palletes;;;;;;;;;;;;;;;;;;;;;;

;       ----------------------------------------------------------

palette_typestart:
;.byte $3F,$20 ,$27, $28, $3F, $14   , $27,$21,$3F,$20 ,$27, $28 ,$3F, $14   , $27,$21
.byte $3F ,$3F ,$3F, $28,$3F ,$14 ,$28 ,$21 , $3F ,$3F ,$28 ,$02 ,$3F ,$3F, $3F ,$28
.byte $3F,$20 ,$27, $28 ,$3F, $14   , $27,$21,$3F,$20 ,$27, $28 ,$3F, $14   , $27,$21
palette_new:

.byte $28, $07, $27, $28 ,$28, $29, $1a ,$0a, $28 ,$11, $30, $21 ,$28,$29, $21, $0a

.byte $28,$16,$0f,$38,  $28, $0D, $20, $16,   $28,$30,$2e,$06,    $28, $16, $07, $27
palette_quiz:
	.byte $21,$16,$0f,$07,   $21,$16,$0f,$07,   $21,$16,$0f,$07,   $21,$16,$0f,$07
	;SPR
	.byte $28,$16,$0f,$38, $28,$16,$28,$18,   $28,$30,$2e,$06,    $28,$28,$3d,$08
palette_galaxy:
   .byte $3F, $30 ,$01, $21 ,$3F, $08 , $17, $27, $3F, $31 , $01 ,$12 , $3F, $31 , $01 ,$12
   .byte $3f,$16,$0f,$38,  $3f, $0D, $20, $16,   $3f,$30,$2e,$06,    $3f,$28,$3d,$08
palette_question:
         .byte $30,$03,$12,$0f,   $30,$0a,$1a,$0f,   $30,$26,$0f,$16,   $30,$27,$09,$1A
	;SPR
	.byte $30,$16,$0f,$05, $30,$16,$38,$18,   $30,$30,$2e,$06,    $30,$17,$27,$28

 palette_level:
  .byte $0f,$0f,$0f,$0f,   $0f,$0f,$0f,$0f,   $0f,$0f,$0f,$0f,   $0f,$0f,$0f,$0f
	;SPR
	.byte $0f,$16,$0f,$38, $0f,$16,$38,$18,   $0f,$30,$2e,$06,    $0f,$17,$27,$28

no_of_gudobjects:
.db #200,#10, #6, $04

Library:
.db $15,$15,$14,$05,$02,$13

sprite:
.db #142, $1e, $00, $50 ;sprite 0

palette:
	;BG
	.byte $12, $0f ,$15, $30,$12, $0f ,$15, $30,$12, $0f ,$15, $30,$12, $0f ,$15, $30
	;SPR
	.byte $12,$30,$20,$10,$12,$0F,$0F,$0F,$12,$0F,$0F,$0F,$12,$0F,$0F,$0F


Pall:
    .byte  $11,$0E,$05,$30,  $11,$18,$27,$30,   $11,$21,$01,$30,    $11,$0E,$15,$30
;     -------------------------------------------------------------------
incorr:
.db $1a, $1b, $1c, $E7, $23, $20, $21, $22
.db $24, $25, $26, $E7, $27, $28, $29, $E7
.db $E7, $2A, $28, $2c, $3a, $3b, $3c, $e7
.db $e7, $0f, $1f, $28, $28, $6e, $e7, $e7
.db $e7, $2b, $0d, $28, $28, $1d, $e7, $e7
.db $e7, $27, $28, $2d, $3d, $0e, $1e, $e7
.db $2e, $28, $3e, $e7, $3f, $28, $6f, $e7
.db $60, $70, $80, $e7, $90, $a0, $68, $22
;   --------------------------------------------------------
correct_sprite:
.db $E7, $E7, $E7, $E7, $E7, $E7, $00, $01
.db $E7, $E7, $E7, $E7, $E7, $02, $03, $04
.db $E7, $E7, $E7, $E7, $02, $05, $04, $E7
.db $E7, $E7, $E7, $02, $05, $04, $E7, $E7
.db $0b, $07, $08, $09, $0a, $E7, $E7, $E7
.db $13, $0c, $10, $11, $12, $E7, $E7, $E7
.db $E7, $14, $15, $16, $E7, $E7, $E7, $E7
.db $E7, $17, $18, $19, $E7, $E7, $E7, $E7
;   ------------------------------------------------------------


sf:
.db $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40

sf2:
.db $41, $41, $41, $41, $41, $41, $41, $41, $41, $41, $41, $41, $41, $41, $41, $41, $41, $41, $41, $41

up_r1:
.db  #$7B, #$7C, #$74, #$74, #$8B, #$8C, #$74, #$74, #$9B, #$9C, #$74, #$74, #$AD, #$BD, #$74,#$74

up_r2:
.db  #$67, #$77, #$74, #$74, #$87, #$97, #$74, #$74, #$A7, #$B6, #$74, #$74, #$C6, #$D6, #$74,#$74

up_r3:
.db #$CF, #$77, #$74,#$74 , #$DF, #$97, #$74, #$74, #$A7, #$B6, #$74, #$74, #$DE, #$D6, #$74 , #$74

dn_r1:
.db #$17, #$18, #$74, #$74, #$27, #$28, #$29, #$74, #$22, #$23, #$19, #$74, #$74, #$24, #$25, #$74

dn_r2:
.db #$16, #$18, #$74, #$74, #$27, #$28, #$29, #$74, #$12, #$23, #$19, #$74, #$74, #$24, #$25, #$74

up_l1:
.db  #$41, #$42, #$74, #$74, #$51, #$52, #$74, #$74, #$43, #$44, #$74, #$74, #$53, #$54, #$74,#$74

up_l2:
.db #$48, #$49, #$74, #$74, #$58, #$59, #$74, #$74, #$45, #$46, #$74, #$74, #$55, #$56, #$74, #$74

up_l3:
.db  #$0C, #$0D, #$74, #$74, #$1C, #$1D, #$74, #$74, #$2C, #$2D, #$74, #$74, #$3C, #$3D, #$74 ,#$74

dn_l1:
.db #$74, #$4E, #$4F, #$74, #$5D, #$5E, #$5F, #$74, #$4D, #$5A, #$5B, #$74, #$6B, #$6A, #$74, #$74

dn_l2:
.db #$74, #$4E, #$6F, #$74, #$5D, #$5E, #$5F, #$74, #$4D, #$5A, #$4B, #$74, #$6B, #$6A, #$74, #$74

ld_r1:
.db #$74, #$62, #$63, #$74, #$74, #$72, #$73, #$74, #$81, #$82, #$83, #$74, #$91, #$92, #$93, #$74

ld_r2:
.db #$74, #$60, #$61, #$74, #$74, #$70, #$71, #$74, #$81, #$82, #$83, #$74, #$91, #$92, #$93, #$74

ld_r3:
.db #$74, #$62, #$63, #$74, #$74, #$72, #$73, #$74, #$74, #$82, #$83, #$74, #$80, #$92, #$93, #$74

ld_r4:
.db #$74, #$60, #$61, #$74, #$74, #$70, #$71, #$74, #$74, #$82, #$83, #$74, #$80, #$92, #$93, #$74

ld_l1:
.db #$74, #$AB, #$AC, #$74, #$74, #$BB, #$BC, #$74, #$74, #$CB, #$CC, #$CD, #$74, #$DB, #$DC, #$DD

ld_l2:
.db #$74, #$AE, #$AF, #$74, #$74, #$BE, #$BF, #$74, #$74, #$CB, #$CC, #$CD, #$74, #$DB, #$DC, #$DD

ld_l3:
.db #$74, #$AB, #$AC, #$74, #$74, #$BB, #$BC, #$74, #$74, #$CB, #$CC, #$74, #$74, #$DB, #$DC, #$CE

ld_l4:
.db #$74, #$AE, #$AF, #$74, #$74, #$BE, #$BF, #$74, #$74, #$CB, #$CC, #$74, #$74, #$DB, #$DC, #$CE

ln_l1:
.db #$74, #$A4, #$A5, #$A6, #$B3, #$B4, #$B5, #$74, #$C3, #$C4, #$C5, #$74, #$D3, #$D4, #$D5, #$74

ln_l2:
.db #$74, #$A8, #$A9, #$AA, #$B7, #$B8, #$B9, #$74, #$C7, #$C8, #$C9, #$74, #$D7, #$D8, #$D9, #$74

ln_l3:
.db #$E0, #$E1, #$E2, #$E3, #$F0, #$F1, #$F2, #$74, #$C7, #$C8, #$C9, #$74, #$D7, #$D8, #$D9, #$74

ln_r1:
.db #$68, #$69, #$74, #$74, #$78, #$79, #$7A, #$74, #$88, #$89, #$8A, #$74, #$98, #$99, #$9A, #$74

ln_r2:
.db #$6D, #$6E, #$74, #$74, #$7D, #$7E, #$7F, #$74, #$8D, #$8E, #$8F, #$74, #$9D, #$9E, #$9F, #$74

ln_r3:
.db #$E9, #$EA, #$74, #$EC, #$F9, #$FA, #$FB, #$74, #$8D, #$8E, #$8F, #$74, #$9D, #$9E, #$9F, #$74

sadfac:
.db #$64, #$65, #$66, #$74, #$74, #$75, #$76, #$74, #$84, #$85, #$86, #$74, #$94, #$95, #$96, #$74

hanutile:
.db #$68, #$69, #$6A, #$6B, #$78, #$79, #$7A, #$7B, #$88, #$89, #$8A, #$8B, #$98, #$99, #$9A, #$9B

xpost:
.db #$00, #$08, #$10, #$18, #$00, #$08, #$10, #$18, #$00, #$08, #$10, #$18, #$00, #$08, #$10, #$18

ypost:
.db #$78, #$78, #$78, #$78, #$80, #$80, #$80, #$80, #$88, #$88, #$88, #$88, #$90, #$90, #$90, #$90


screen1_3:                                    ;;;;;;;;;;;;;;;;;;;;;;; level2 screen1
        ;.incbin "screen5.nam"

screen2_3:                                    ;;;;;;;;;;;;;;;;;;;;;;  level2 screen2
        ;.incbin "screen6.nam"

start_screen1:
   ;  .incbin "start.nam"

pic1:
        .INCBIN "pic1.nam"     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Question screen [second screen]

start_2in1:
        .incbin "screen_2in1 .nam"



snake_typing:
             .incbin "screen1_typing.nam"
snow_typing:
        .incbin "snow.nam"

;       ---------------------------;       ----------------------------------------------------
        ;     .org LoadAddy
;     .incbin "music.nsf"

	.ORG $fffa
	.dw NMI
	.dw Reset
	.dw IRQ
 .org $10000
;       ----------------------------------------------------
