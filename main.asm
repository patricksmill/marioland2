include "hardware.inc"
include "macros.asm"
include "ram.asm"
include "home.asm"

SECTION "bank01", ROMX, BANK[$01]


UnknownData_0x4000:
INCBIN "baserom.gb", $4000, $41E4 - $4000 ;These are pointers to the sprite mappings

INCLUDE "gfx/spritemappings.asm"

UnknownCall_0x5267:
	ldh a, [$FFC6]
	swap a
	and $0F
	add 128
	call UnknownCall_0x527C

UnknownCall_0x5272:
	ldh a, [$FFC6]
	and $0F
	add 128
	call UnknownCall_0x527C
	ret

UnknownCall_0x527C:
	ldh [$FF98], a
	ld h, 161
	ldh a, [$FF8D]
	ld l, a
	ldh a, [$FFC4]
	ld [hli], a
	ldh a, [$FFC5]
	ld [hli], a
	add 8
	ldh [$FFC5], a
	ldh a, [$FF98]
	ld [hli], a
	ldh a, [$FFC7]
	ld [hli], a
	ld a, l
	ldh [$FF8D], a
	ret

UnknownJump_0x5297:
UnknownCall_0x5297:
	ld a, 1 ;prepare bank switch
	ld [$A24E], a
	ld [$2100], a
	ldh a, [$FFC6]
	ld d, 0
	ld e, a
	sla e
	rl d
	ld hl, $4000
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld h, 161
	ldh a, [$FF8D]
	ld l, a
	ldh a, [$FFC4]
	ld b, a
	ldh a, [$FFC5]
	ld c, a

UnknownRJump_0x52BB:
	ld a, [de]
	cp $80
	jr z, UnknownRJump_0x52E6
	add b
	ld [hli], a
	inc de
	ld a, [de]
	add c
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ldh a, [$FFC7]
	and a
	jr z, UnknownRJump_0x52D4
	ld a, [de]
	set 4, a
	jr UnknownRJump_0x52D5

UnknownRJump_0x52D4:
	ld a, [de]

UnknownRJump_0x52D5:
	ld [hl], a
	ldh a, [$FFBB]
	and a
	jr nz, UnknownRJump_0x52DF
	ld a, [hl]
	set 7, a
	ld [hl], a

UnknownRJump_0x52DF:
	inc hl
	ld a, l
	ldh [$FF8D], a
	inc de
	jr UnknownRJump_0x52BB

UnknownRJump_0x52E6:
	ret

UnknownJump_0x52E7:
UnknownCall_0x52E7:
	ldh a, [$FF8D]
	ld b, a
	ld a, [$A26E]
	ld c, a
	cp b
	jr c, UnknownRJump_0x52FC
	ld h, 161
	ldh a, [$FF8D]
	ld l, a

UnknownRJump_0x52F6:
	xor a
	ld [hli], a
	ld a, l
	cp c
	jr c, UnknownRJump_0x52F6

UnknownRJump_0x52FC:
	ldh a, [$FF8D]
	ld [$A26E], a
	ret

UnknownJump_0x5302:
UnknownCall_0x5302:
	ld hl, $A100

UnknownRJump_0x5305:
	xor a
	ld [hli], a
	ld a, l
	cp $A0
	jr c, UnknownRJump_0x5305
	ret

UnknownJump_0x530D:
	ld a, 1
	ldh [$FFBB], a
	ld a, [sPipeTravelDirection]
	cp $10
	jr c, UnknownRJump_0x532D
	xor a
	ldh [$FFBB], a
	ld a, 16
	ldh [$FFC6], a
	ld a, [sPipeTravelDirection]
	cp $30
	jp c, UnknownJump_0x5447
	jp z, UnknownJump_0x53AD
	jp UnknownJump_0x5426

UnknownRJump_0x532D:
	ld a, [sSpinJump]
	and a
	jr z, UnknownRJump_0x534C
	ld hl, $5348
	ldh a, [$FF97]
	and $0C
	srl a
	srl a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ldh [$FFC6], a
	jp UnknownJump_0x5447

UnknownData_0x5348:
INCBIN "baserom.gb", $5348, $534C - $5348


UnknownRJump_0x534C:
	ld a, [sMarioDirection]
	cp $01
	jp nz, UnknownJump_0x53CF
	ld a, [sMoonPhysics]
	bit 1, a
	jr z, UnknownRJump_0x5377
	ld a, [sMarioOnGround]
	and a
	jr nz, UnknownRJump_0x5377
	ld a, 18
	ldh [$FFC6], a
	ld a, [$A285]
	and a
	jp z, UnknownJump_0x5447
	dec a
	ld [$A285], a
	ld a, 19
	ldh [$FFC6], a
	jp UnknownJump_0x5447

UnknownRJump_0x5377:
	ld a, [$A291]
	and a
	jr z, UnknownRJump_0x5384
	ld a, 14
	ldh [$FFC6], a
	jp UnknownJump_0x5447

UnknownRJump_0x5384:
	ld a, [sMarioOnGround]
	ld b, a
	ld a, [$A26B]
	or b
	jr z, UnknownRJump_0x53BD
	ld a, [sHVelocityIndex]
	cp $80
	jr nc, UnknownRJump_0x53A1
	ld a, 13
	ldh [$FFC6], a
	ld a, 4
	ld [$A460], a
	jp UnknownJump_0x5447

UnknownRJump_0x53A1:
	ld a, 0
	ldh [$FFC6], a
	ld a, [sHVelocityIndex]
	cp $80
	jp z, UnknownJump_0x5447

UnknownJump_0x53AD:
	ld a, [$A222]
	and $0C
	srl a
	srl a
	add 1
	ldh [$FFC6], a
	jp UnknownJump_0x5447

UnknownRJump_0x53BD:
	ld a, 8
	ldh [$FFC6], a
	ld a, [sMarioInAir]
	and a
	jp nz, UnknownJump_0x5447
	ld a, 10
	ldh [$FFC6], a
	jp UnknownJump_0x5447

UnknownJump_0x53CF:
	ld a, [sMoonPhysics]
	bit 1, a
	jr z, UnknownRJump_0x53F2
	ld a, [sMarioOnGround]
	and a
	jr nz, UnknownRJump_0x53F2
	ld a, 20
	ldh [$FFC6], a
	ld a, [$A285]
	and a
	jp z, UnknownJump_0x5447
	dec a
	ld [$A285], a
	ld a, 21
	ldh [$FFC6], a
	jp UnknownJump_0x5447

UnknownRJump_0x53F2:
	ld a, [$A291]
	and a
	jr z, UnknownRJump_0x53FE
	ld a, 15
	ldh [$FFC6], a
	jr UnknownRJump_0x5447

UnknownRJump_0x53FE:
	ld a, [sMarioOnGround]
	ld b, a
	ld a, [$A26B]
	or b
	jr z, UnknownRJump_0x5436
	ld a, [sHVelocityIndex]
	cp $81
	jr c, UnknownRJump_0x541A
	ld a, 12
	ldh [$FFC6], a
	ld a, 4
	ld [$A460], a
	jr UnknownRJump_0x5447

UnknownRJump_0x541A:
	ld a, 4
	ldh [$FFC6], a
	ld a, [sHVelocityIndex]
	cp $80
	jp z, UnknownJump_0x5447

UnknownJump_0x5426:
	ld a, [$A222]
	and $0C
	srl a
	srl a
	add 5
	ldh [$FFC6], a
	jp UnknownJump_0x5447

UnknownRJump_0x5436:
	ld a, 9
	ldh [$FFC6], a
	ld a, [sMarioInAir]
	and a
	jr nz, UnknownRJump_0x5447
	ld a, 11
	ldh [$FFC6], a
	jp UnknownJump_0x5447

UnknownJump_0x5447:
UnknownRJump_0x5447:
	ld a, [$A217]
	and a
	jr z, UnknownRJump_0x545D
	dec a
	ld [$A217], a
	bit 2, a
	jr z, UnknownRJump_0x546B
	ldh a, [$FFC6]
	add 32
	ldh [$FFC6], a
	jr UnknownRJump_0x54A7

UnknownRJump_0x545D:
	ld a, [sCurPowerup]
	and a
	jr nz, UnknownRJump_0x546B
	ldh a, [$FFC6]
	add 32
	ldh [$FFC6], a
	jr UnknownRJump_0x54A7

UnknownRJump_0x546B:
	ld a, [sCurPowerup]
	cp $02
	jr nz, UnknownRJump_0x548A
	ldh a, [$FFC6]
	add 69
	ldh [$FFC6], a
	ld a, [$A24D]
	and a
	jr z, UnknownRJump_0x54A7
	bit 2, a
	jr z, UnknownRJump_0x54A7
	ldh a, [$FFC6]
	add 26
	ldh [$FFC6], a
	jr UnknownRJump_0x54A7

UnknownRJump_0x548A:
	ld a, [sCurPowerup]
	cp $03
	jr nz, UnknownRJump_0x54A7
	ldh a, [$FFC6]
	add 112
	ldh [$FFC6], a
	ld a, [$A25A]
	and a
	jr z, UnknownRJump_0x54A7
	dec a
	ld [$A25A], a
	ldh a, [$FFC6]
	add 32
	ldh [$FFC6], a

UnknownRJump_0x54A7:
	ldh a, [$FFCA]
	ld b, a
	ldh a, [$FFC2]
	sub b
	add 96
	ldh [$FFC5], a
	ld [sMarioScreenX], a
	cp $60
	jr c, UnknownRJump_0x54BF
	ld a, 255
	ld [$A232], a
	jr UnknownRJump_0x54C8

UnknownRJump_0x54BF:
	cp $60
	jr nc, UnknownRJump_0x54C8
	ld a, 255
	ld [$A233], a

UnknownJump_0x54C8:
UnknownRJump_0x54C8:
	ldh a, [$FFC8]
	ld b, a
	ldh a, [$FFC0]
	sub b
	add 98
	ldh [$FFC4], a
	ld [sMarioScreenY], a
	xor a
	ldh [$FFC7], a
	ld a, [$A271]
	and a
	jr z, UnknownRJump_0x54E9
	ld a, [$A272]
	bit 2, a
	jr z, UnknownRJump_0x54E9
	ld a, 1
	ldh [$FFC7], a

UnknownRJump_0x54E9:
	ld a, [$A2B3]
	and a
	jr z, UnknownRJump_0x54FB
	dec a
	ld [$A2B3], a
	and $03
	ld b, a
	ldh a, [$FFC4]
	sub b
	ldh [$FFC4], a

UnknownRJump_0x54FB:
	call UnknownCall_0x5297
	xor a
	ldh [$FFC7], a
	ldh [$FFBB], a
	ld a, [sMoonPhysics]
	bit 2, a
	jr z, UnknownRJump_0x551E
	ld a, 1
	ldh [$FFBB], a
	ldh a, [$FF97]
	and $10
	swap a
	add 220
	ldh [$FFC6], a
	call UnknownCall_0x5297
	xor a
	ldh [$FFBB], a

UnknownRJump_0x551E:
	ld a, [$A27A]
	and a
	ret z
	dec a
	ld [$A27A], a
	srl a
	ld b, a
	ldh a, [$FFC4]
	sub 32
	add b
	ldh [$FFC4], a
	ldh a, [$FFC5]
	sub 4
	ldh [$FFC5], a
	ld a, 1
	ldh [$FFBB], a
	ld a, [$A279]
	cp $05
	jr nc, UnknownRJump_0x5548
	ldh [$FFC6], a
	call UnknownCall_0x5272
	ret

UnknownRJump_0x5548:
	ld a, 190
	ldh [$FFC6], a
	call UnknownCall_0x5297
	ret

UnknownJump_0x5550:
	ldh a, [$FFC8]
	ld b, a
	ldh a, [$FFC0]
	sub b
	add 98
	ldh [$FFC4], a
	ld [sMarioScreenY], a
	and $E0
	cp $E0
	ret z
	ldh a, [$FFCA]
	ld b, a
	ldh a, [$FFC2]
	sub b
	add 96
	ldh [$FFC5], a
	ld [sMarioScreenX], a
	ld a, 107
	ldh [$FFC6], a
	xor a
	ldh [$FFC7], a
	jp UnknownJump_0x54C8

UnknownJump_0x5579:
	xor a
	ld [$A2A0], a
	ld a, [$A27D]
	bit 3, a
	jr z, UnknownRJump_0x5589
	ld a, 255
	ld [$A2A0], a

UnknownRJump_0x5589:
	ld hl, Level_Header_Pointers
	ld a, [sCurLevel]
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld a, e
	ld l, a
	ld de, $A800
	ld b, 20

UnknownRJump_0x559F:
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, UnknownRJump_0x559F
	ld a, [$A2A0]
	and a
	jr z, UnknownRJump_0x55C6
	ld hl, UnknownData_0x377B
	ld a, [sCurLevel]
	sla a
	sla a
	sla a
	ld e, a
	ld d, 0
	add hl, de
	ld de, $A800
	ld b, 8

UnknownRJump_0x55C0:
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, UnknownRJump_0x55C0

UnknownRJump_0x55C6:
	ld a, 2
	ldh [$FF9B], a
	ret

UnknownData_0x55CB:
INCLUDE "levels/levelheaders.asm"
INCBIN "baserom.gb", $588B, $591F - $588B

UnknownJump_0x591F:
	ld a, [sCoinLow]
	inc a
	daa
	ld [sCoinLow], a
	ld a, [sCoinHigh]
	adc 0
	ld [sCoinHigh], a
	cp $0A
	jr c, UnknownRJump_0x593D

UnknownData_0x5933:
INCBIN "baserom.gb", $5933, $593D - $5933


UnknownRJump_0x593D:
	ldh a, [$FFC2]
	add 16
	ldh [$FFB9], a
	ldh a, [$FFC3]
	adc 0
	ldh [$FFBA], a
	ld c, 8
	ld a, [sCurPowerup]
	and a
	jr nz, UnknownRJump_0x5955
	ld a, 10
	add c
	ld c, a

UnknownRJump_0x5955:
	ldh a, [$FFC0]
	add c
	ldh [$FFB7], a
	ldh a, [$FFC1]
	adc 0
	ldh [$FFB8], a

UnknownJump_0x5960:
	ld hl, $AA80

UnknownRJump_0x5963:
	ld a, [hl]
	and a
	jr z, UnknownRJump_0x5970
	ld a, l
	add 16
	ld l, a
	cp $00
	ret z
	jr UnknownRJump_0x5963

UnknownRJump_0x5970:
	ld a, b
	ld [hl], a
	ld [$A23E], a
	inc hl
	ld a, 1
	ld [hli], a
	ldh a, [$FFB7]
	and $F0
	add 8
	ld [hli], a
	ldh a, [$FFB8]
	ld [hli], a
	inc hl
	ldh a, [$FFB9]
	add 8
	ld b, a
	ldh a, [$FFBA]
	adc 0
	ld [hld], a
	ld a, b
	and $F0
	ld [hli], a
	inc hl
	call UnknownCall_0x2F72
	ret

UnknownJump_0x5997:
	ld hl, $AA80

UnknownJump_0x599A:
	push hl
	ld a, [hli]
	ld [$A23E], a
	and a
	jr z, UnknownRJump_0x59DF
	ld a, [hl]
	inc a
	ld [$A23F], a
	ld [hli], a
	ld a, [hli]
	ld [$A240], a
	ldh [$FFB7], a
	ld a, [hli]
	ld [$A241], a
	ldh [$FFB8], a
	ld a, [hli]
	ld [$A242], a
	ldh [$FFB9], a
	ld a, [hl]
	ld [$A243], a
	ldh [$FFBA], a
	ld a, [$A23E]
	cp $01
	jr z, UnknownRJump_0x59EB
	cp $02
	jp z, UnknownJump_0x5B70
	cp $03
	jp z, UnknownJump_0x5B06
	cp $04
	jp z, UnknownJump_0x5A9E
	cp $05
	jr z, UnknownRJump_0x59FA

UnknownData_0x59DA:
INCBIN "baserom.gb", $59DA, $59DF - $59DA


UnknownJump_0x59DF:
UnknownRJump_0x59DF:
	pop hl
	ld a, l
	and $F0
	add 16
	ld l, a
	and a
	jp nz, UnknownJump_0x599A
	ret

UnknownRJump_0x59EB:
	ld a, [$A23F]
	cp $02
	jp z, UnknownJump_0x5A72
	cp $28
	jp z, UnknownJump_0x5A82
	jr UnknownRJump_0x5A07

UnknownRJump_0x59FA:
	ld a, [$A23F]
	cp $02
	jp z, UnknownJump_0x5A7A
	cp $28
	jp z, UnknownJump_0x5A90

UnknownRJump_0x5A07:
	ld hl, $5A4A
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld c, a
	ld a, [sScrollY]
	ld b, a
	ldh a, [$FFB7]
	sub b
	add c
	ldh [$FFC4], a
	ld a, [$A23F]
	ld c, a
	ld a, [sScrollX]
	ld b, a
	ldh a, [$FFB9]
	sub b
	sub c
	ldh [$FFC5], a
	ld a, 101
	ldh [$FFC6], a
	ld a, 1
	ldh [$FFBB], a
	call UnknownCall_0x5297
	ld a, [$A23F]
	ld c, a
	ld a, [sScrollX]
	ld b, a
	ldh a, [$FFB9]
	sub b
	add c
	ldh [$FFC5], a
	ld a, 102
	ldh [$FFC6], a
	call UnknownCall_0x5297
	jr UnknownRJump_0x59DF

UnknownData_0x5A4A:
INCBIN "baserom.gb", $5A4A, $5A72 - $5A4A


UnknownJump_0x5A72:
	ld a, 96
	call UnknownCall_0x5CF1
	jp UnknownJump_0x5C01

UnknownJump_0x5A7A:
	ld a, 127
	call UnknownCall_0x5CF1
	jp UnknownJump_0x5C2C

UnknownJump_0x5A82:
	ld a, l
	and $F0
	ld l, a
	xor a
	ld [hl], a
	ld a, 96
	call UnknownCall_0x5CF1
	jp UnknownJump_0x59DF

UnknownJump_0x5A90:
	ld a, l
	and $F0
	ld l, a
	xor a
	ld [hl], a
	ld a, 127
	call UnknownCall_0x5CF1
	jp UnknownJump_0x59DF

UnknownJump_0x5A9E:
	ld a, [$A23F]
	cp $32
	jr z, UnknownRJump_0x5AFD
	ld hl, $5AE0
	srl a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld c, a
	ld a, [sScrollY]
	ld b, a
	ldh a, [$FFB7]
	sub b
	add c
	ldh [$FFC4], a
	ld a, [sScrollX]
	ld b, a
	ldh a, [$FFB9]
	sub b
	ldh [$FFC5], a
	ld hl, $5AF9
	ld a, [$A23F]
	and $0C
	srl a
	srl a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ldh [$FFC6], a
	ld a, 1
	ldh [$FFBB], a
	call UnknownCall_0x5297
	jp UnknownJump_0x59DF

UnknownData_0x5AE0:
INCBIN "baserom.gb", $5AE0, $5AFD - $5AE0


UnknownRJump_0x5AFD:
	ld a, l
	and $F0
	ld l, a
	xor a
	ld [hl], a
	jp UnknownJump_0x59DF

UnknownJump_0x5B06:
	ld a, [$A23F]
	cp $02
	jp z, UnknownJump_0x5BFC
	cp $08
	jr z, UnknownRJump_0x5B3C
	ld hl, $5BB4
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld c, a
	ld a, [sScrollY]
	ld b, a
	ldh a, [$FFB7]
	sub b
	add c
	ldh [$FFC4], a
	ld a, [sScrollX]
	ld b, a
	ldh a, [$FFB9]
	sub b
	ldh [$FFC5], a
	ld a, 66
	ldh [$FFC6], a
	ld a, 1
	ldh [$FFBB], a
	call UnknownCall_0x5297
	jp UnknownJump_0x59DF

UnknownRJump_0x5B3C:
	ld a, l
	and $F0
	ld l, a
	xor a
	ld [hl], a
	ld a, 7
	call UnknownCall_0x5CF1
	call UnknownCall_0x200C
	ld a, [$A205]
	and $DE
	ld l, a
	ld a, [$A206]
	ld h, a
	ld de, $001F

UnknownRJump_0x5B57:
	ldh a, [rSTAT]
	and $03
	jr nz, UnknownRJump_0x5B57

UnknownRJump_0x5B5D:
	ldh a, [rSTAT]
	and $03
	jr nz, UnknownRJump_0x5B5D
	ld a, 248
	ld [hli], a
	inc a
	ld [hl], a
	add hl, de
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	jp UnknownJump_0x59DF

UnknownJump_0x5B70:
	ld a, [$A23F]
	cp $02
	jp z, UnknownJump_0x5BFC
	cp $08
	jr z, UnknownRJump_0x5BBC
	jr UnknownRJump_0x5B8A

UnknownData_0x5B7E:
INCBIN "baserom.gb", $5B7E, $5B8A - $5B7E


UnknownRJump_0x5B8A:
	ld hl, $5BB4
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld c, a
	ld a, [sScrollY]
	ld b, a
	ldh a, [$FFB7]
	sub b
	add c
	ldh [$FFC4], a
	ld a, [sScrollX]
	ld b, a
	ldh a, [$FFB9]
	sub b
	ldh [$FFC5], a
	ld a, 66
	ldh [$FFC6], a
	ld a, 1
	ldh [$FFBB], a
	call UnknownCall_0x5297
	jp UnknownJump_0x59DF

UnknownData_0x5BB4:
INCBIN "baserom.gb", $5BB4, $5BBC - $5BB4


UnknownRJump_0x5BBC:
	ld a, l
	and $F0
	ld l, a
	xor a
	ld [hl], a
	xor a
	call UnknownCall_0x5CF1
	jr UnknownRJump_0x5BD3

UnknownData_0x5BC8:
INCBIN "baserom.gb", $5BC8, $5BD3 - $5BC8


UnknownRJump_0x5BD3:
	call UnknownCall_0x200C
	ld a, [$A205]
	and $DE
	ld l, a
	ld a, [$A206]
	ld h, a
	ld de, $001F

UnknownRJump_0x5BE3:
	ldh a, [rSTAT]
	and $03
	jr nz, UnknownRJump_0x5BE3

UnknownRJump_0x5BE9:
	ldh a, [rSTAT]
	and $03
	jr nz, UnknownRJump_0x5BE9
	ld a, 244
	ld [hli], a
	inc a
	ld [hl], a
	add hl, de
	inc a
	ld [hli], a
	inc a
	ld [hl], a
	jp UnknownJump_0x59DF

UnknownJump_0x5BFC:
	ld a, 24
	call UnknownCall_0x5CF1

UnknownJump_0x5C01:
	call UnknownCall_0x200C
	ld a, [$A205]
	and $DE
	ld l, a
	ld a, [$A206]
	ld h, a
	ld de, $001F

UnknownRJump_0x5C11:
	ldh a, [rSTAT]
	and $03
	jr nz, UnknownRJump_0x5C11

UnknownRJump_0x5C17:
	ldh a, [rSTAT]
	and $03
	jr nz, UnknownRJump_0x5C17
	ld a, 255
	ld [hli], a
	ld [hl], a
	add hl, de
	ld [hli], a
	ld [hl], a
	jp UnknownJump_0x59DF

UnknownData_0x5C27:
INCBIN "baserom.gb", $5C27, $5C2C - $5C27


UnknownJump_0x5C2C:
	call UnknownCall_0x200C
	ld a, [$A205]
	and $DE
	ld l, a
	ld a, [$A206]
	ld h, a
	ld de, $001F

UnknownRJump_0x5C3C:
	ldh a, [rSTAT]
	and $03
	jr nz, UnknownRJump_0x5C3C

UnknownRJump_0x5C42:
	ldh a, [rSTAT]
	and $03
	jr nz, UnknownRJump_0x5C42
	ld a, 127
	ld [hli], a
	ld [hl], a
	add hl, de
	ld [hli], a
	ld [hl], a
	jp UnknownJump_0x59DF

UnknownData_0x5C52:
INCBIN "baserom.gb", $5C52, $5CF1 - $5C52


UnknownCall_0x5CF1:
	ld d, a

UnknownJump_0x5CF2:
	ldh a, [$FFB7]
	sub 16
	ld c, a
	ldh a, [$FFB8]
	sbc 0
	ld b, a
	ld a, b
	and $0F
	swap a
	ld h, a
	ld a, c
	and $F0
	swap a
	or h
	add 176
	ld h, a
	ldh a, [$FFB9]
	sub 8
	ld c, a
	ldh a, [$FFBA]
	sbc 0
	ld b, a
	ld a, b
	and $0F
	swap a
	ld l, a
	ld a, c
	and $F0
	swap a
	or l
	ld l, a
	ld a, d
	ld [hl], a
	ret

UnknownJump_0x5D25:
	xor a
	ld [$A238], a
	ld [$A237], a
	ld [$A28A], a
	ldh a, [rLCDC]
	bit 5, a
	jr nz, UnknownRJump_0x5D39
	set 5, a
	ldh [rLCDC], a

UnknownRJump_0x5D39:
	ld a, 136
	ldh [rWY], a
	ld a, [$A29B]
	and a
	call nz, UnknownCall_0x6442
	ld a, [$A271]
	and a
	jr z, UnknownRJump_0x5D6A
	ld a, [$A272]
	sub 1
	ld [$A272], a
	ld a, [$A271]
	sbc 0
	ld [$A271], a
	and a
	jr nz, UnknownRJump_0x5D6A
	ld a, [sCurSong]
	cp $09
	jr z, UnknownRJump_0x5D6A
	ld a, [$A292]
	ld [$A468], a

UnknownRJump_0x5D6A:
	ld a, [$A224]
	ld b, a
	ld a, [$A2E3]
	ld c, a
	ld a, [$A24F]
	or b
	or c
	jp nz, UnknownJump_0x5E12
	ld a, [$A24B]
	dec a
	ld [$A24B], a
	jp nz, UnknownJump_0x5E12
	ld a, 48
	ld [$A24B], a
	ld a, [sTimerLow]
	sub 1
	daa
	ld [sTimerLow], a
	ld a, [sTimerHigh]
	sbc 0
	daa
	ld [sTimerHigh], a
	jr nc, UnknownRJump_0x5DB4
	ld a, 128
	ld [$A224], a
	xor a
	ld [sTimerLow], a
	ld [sTimerHigh], a
	ld a, 15
	ld [$A460], a
	xor a
	ld [$A53F], a
	jr UnknownRJump_0x5E12

UnknownRJump_0x5DB4:
	ld a, [sTimerHigh]
	and a
	jr nz, UnknownRJump_0x5DCB
	ld a, [sTimerLow]
	cp $11
	jr nc, UnknownRJump_0x5DCB
	ld a, 14
	ld [$A470], a
	ld a, 1
	ld [$A53F], a

UnknownRJump_0x5DCB:
	ld a, [$A24F]
	and a
	jr nz, UnknownRJump_0x5E12
	ld a, [sTimerHigh]
	and a
	jr nz, UnknownRJump_0x5E03
	ld a, [sCurSong]
	and a
	jr nz, UnknownRJump_0x5E12
	ld a, [$A292]
	and $FC
	cp $20
	jr z, UnknownRJump_0x5DF9
	ld a, [$A292]
	ld [$A468], a
	ld a, [$A271]
	and a
	jr z, UnknownRJump_0x5E12

UnknownData_0x5DF2:
INCBIN "baserom.gb", $5DF2, $5DF9 - $5DF2


UnknownRJump_0x5DF9:
UnknownData_0x5DF9:
INCBIN "baserom.gb", $5DF9, $5E03 - $5DF9


UnknownRJump_0x5E03:
	cp $01
	jr nz, UnknownRJump_0x5E12
	ld a, [sTimerLow]
	and a
	jr nz, UnknownRJump_0x5E12
	ld a, 9
	ld [$A468], a

UnknownJump_0x5E12:
UnknownRJump_0x5E12:
	ld a, [$A2DC]
	cp $03
	ret nz
	xor a
	ldh [hKeysPressed], a
	ld a, 18
	ldh [hKeysHeld], a
	ldh a, [$FFC2]
	and $FE
	cp $A0
	ret c
	jr nz, UnknownRJump_0x5E31
	ld a, 1
	ldh [hKeysPressed], a
	ld a, 17
	ldh [hKeysHeld], a
	ret

UnknownRJump_0x5E31:
	xor a
	ldh [hKeysPressed], a
	ld a, 17
	ldh [hKeysHeld], a
	ldh a, [$FFC0]
	cp $E0
	ret c
	ld a, 35
	ldh [$FF9B], a
	ret

UnknownData_0x5E42:
INCBIN "baserom.gb", $5E42, $6442 - $5E42


UnknownCall_0x6442:
UnknownData_0x6442:
INCBIN "baserom.gb", $6442, $6485 - $6442


UnknownJump_0x6485:
	ld a, [$A2B6]
	and a
	ret z
	cp $01
	jr z, UnknownRJump_0x64F9
	ldh a, [$FF97]
	and $01
	jr nz, UnknownRJump_0x64CB
	ld a, [$A2B9]
	sub 2
	ld [$A2B9], a
	ld a, [$A2B8]
	sbc 0
	ld [$A2B8], a
	ld a, [$A2BB]
	add 16
	ldh [$FFB9], a
	ld a, [$A2BA]
	adc 0
	ldh [$FFBA], a
	ld a, [$A2B9]
	add 24
	ldh [$FFB7], a
	ld a, [$A2B8]
	adc 0
	ldh [$FFB8], a
	call UnknownCall_0x1EFA
	cp $52
	jr c, UnknownRJump_0x64F4
	cp $58
	jr nc, UnknownRJump_0x64F4

UnknownRJump_0x64CB:
	ldh a, [$FFCA]
	ld b, a
	ld a, [$A2BB]
	sub b
	add 96
	ldh [$FFC5], a
	ldh a, [$FFC8]
	ld b, a
	ld a, [$A2B9]
	sub b
	add 98
	ldh [$FFC4], a
	cp $10
	jr c, UnknownRJump_0x64F4
	xor a
	ldh [$FFC7], a
	ld a, 1
	ldh [$FFBB], a
	ld a, 200
	ldh [$FFC6], a
	call UnknownCall_0x5297
	ret

UnknownRJump_0x64F4:
	xor a
	ld [$A2B6], a
	ret

UnknownRJump_0x64F9:
	ld a, [$A2B7]
	inc a
	ld [$A2B7], a
	cp $10
	jr nc, UnknownRJump_0x64F4
	ldh a, [$FFCA]
	ld b, a
	ld a, [$A2BB]
	sub b
	add 96
	ldh [$FFC5], a
	ldh a, [$FFC8]
	ld b, a
	ld a, [$A2B9]
	sub b
	add 98
	ldh [$FFC4], a
	xor a
	ldh [$FFC7], a
	ld a, 1
	ldh [$FFBB], a
	ld a, 199
	ldh [$FFC6], a
	call UnknownCall_0x5297
	ret

UnknownData_0x6529:
INCBIN "baserom.gb", $6529, $8000 - $6529



SECTION "bank02", ROMX, BANK[$02]


UnknownCall_0x8000:
	ld de, $0060
	ldh_a_n $CA
	ld l, a
	sub e
	ld [$AF0D], a
	ldh_a_n $CB
	ld h, a
	sbc d
	ld [$AF0C], a
	jr nc, UnknownRJump_0x801C
	xor a
	ld [$AF0D], a
	ld [$AF0C], a

UnknownRJump_0x801C:
	add hl, de
	ld a, h
	ld [$AF0A], a
	ld a, l
	ld [$AF0B], a
	ld e, 112
	ldh_a_n $CA
	ld l, a
	sub e
	ld [$AF15], a
	ldh_a_n $CB
	ld h, a
	sbc d
	ld [$AF14], a
	jr nc, UnknownRJump_0x8040
	xor a
	ld [$AF15], a
	ld [$AF14], a

UnknownRJump_0x8040:
	add hl, de
	ld a, h
	ld [$AF12], a
	ld a, l
	ld [$AF13], a
	ld e, 160
	ldh_a_n $CA
	ld l, a
	sub e
	ld [$AF1D], a
	ldh_a_n $CB
	ld h, a
	sbc d
	ld [$AF1C], a
	jr nc, UnknownRJump_0x8064
	xor a
	ld [$AF1D], a
	ld [$AF1C], a

UnknownRJump_0x8064:
	add hl, de
	ld a, h
	ld [$AF1A], a
	ld a, l
	ld [$AF1B], a
	ld a, [$AF24]
	ld b, a
	ldh_a_n $CB
	cp b
	jr c, UnknownRJump_0x80A4
	jr nz, UnknownRJump_0x8085
	ld a, [$AF25]
	ld b, a
	ldh_a_n $CA
	cp b
	jr c, UnknownRJump_0x80A4
	jr z, UnknownRJump_0x809A

UnknownRJump_0x8085:
	ld a, 1
	ld [$AF22], a
	ld a, [$AF12]
	ld [$AF00], a
	ld a, [$AF13]
	and $F8
	ld [$AF01], a
	jr UnknownRJump_0x80B7

UnknownRJump_0x809A:
	ld [$AF22], a
	ld a, 255
	ld [$AF00], a
	jr UnknownRJump_0x80B7

UnknownRJump_0x80A4:
	ld a, 255
	ld [$AF22], a
	ld a, [$AF14]
	ld [$AF00], a
	ld a, [$AF15]
	and $F8
	ld [$AF01], a

UnknownRJump_0x80B7:
	ld de, $0060
	ldh_a_n $C8
	ld l, a
	sub e
	ld [$AF11], a
	ldh_a_n $C9
	ld h, a
	sbc d
	ld [$AF10], a
	jr nc, UnknownRJump_0x80D3
	xor a
	ld [$AF11], a
	ld [$AF10], a

UnknownRJump_0x80D3:
	add hl, de
	ld a, h
	ld [$AF0E], a
	ld a, l
	ld [$AF0F], a
	ld e, 160
	ldh_a_n $C8
	ld l, a
	sub e
	ld [$AF19], a
	ldh_a_n $C9
	ld h, a
	sbc d
	ld [$AF18], a
	jr nc, UnknownRJump_0x80F7
	xor a
	ld [$AF19], a
	ld [$AF18], a

UnknownRJump_0x80F7:
	add hl, de
	ld a, h
	ld [$AF16], a
	ld a, l
	ld [$AF17], a
	ldh_a_n $C2
	add 8
	ld [$AF30], a
	ldh_a_n $C3
	adc 0
	ld [$AF31], a
	ldh_a_n $C0
	add 32
	ld [$AF32], a
	ldh_a_n $C1
	adc 0
	ld [$AF33], a
	ld a, [$AF08]
	xor $01
	ld [$AF08], a
	jr z, UnknownRJump_0x812E
	ld hl, $FFF0
	inc [hl]

UnknownRJump_0x812E:
	ld hl, $AD08

UnknownRJump_0x8131:
	xor a
	ld [$AF3E], a
	ld [$AF2E], a
	ld a, h
	ld [$AF28], a
	ld a, l
	ld [$AF29], a
	ld a, [hl]
	and a
	jr z, UnknownRJump_0x816A
	dec a
	jr z, UnknownRJump_0x815E
	call UnknownCall_0x826D
	ld a, [$AF3E]
	and a
	jr nz, UnknownRJump_0x816A
	call UnknownCall_0x828F
	ld a, [$AF3E]
	and a
	jr nz, UnknownRJump_0x816A
	call UnknownCall_0x818D
	jr UnknownRJump_0x816A

UnknownRJump_0x815E:
	call UnknownCall_0x826D
	ld a, [$AF3E]
	and a
	jr nz, UnknownRJump_0x816A
	call UnknownCall_0x81F7

UnknownRJump_0x816A:
	ld a, [$AF28]
	ld h, a
	ld a, [$AF29]
	ld l, a
	ld de, $0020
	add hl, de
	ld a, h
	cp $AF
	jr z, UnknownRJump_0x817D
	jr UnknownRJump_0x8131

UnknownRJump_0x817D:
	call UnknownCall_0x8C31
	ldh_a_n $CB
	ld [$AF24], a
	ldh_a_n $CA
	ld [$AF25], a
	ret

UnknownCall_0x818D:
	call UnknownCall_0x81A7
	call UnknownCall_0x3A50
	call UnknownCall_0x3C80
	ld a, [$AF09]
	and a
	jr z, UnknownRJump_0x819F
	xor a
	ldh [$FFE7], a

UnknownRJump_0x819F:
	xor a
	ld [$AF09], a
	call UnknownCall_0x81BA
	ret

UnknownCall_0x81A7:
	ld hl, $AF28
	ld a, [hli]
	ld b, a
	ld a, [hl]
	and $F0
	ld l, a
	ld h, b
	ld de, $FFD0
	ld b, 32
	call UnknownCall_0x3CAA
	ret

UnknownCall_0x81BA:
	call UnknownCall_0x81CF

UnknownCall_0x81BD:
	ld hl, $AF28
	ld a, [hli]
	ld d, a
	ld a, [hl]
	and $F0
	ld e, a
	ld hl, $FFD0
	ld b, 32
	call UnknownCall_0x3CAA
	ret

UnknownCall_0x81CF:
	ld hl, $4935
	ld a, [$AF06]
	and a
	jr nz, UnknownRJump_0x81DB
	ld hl, $4737

UnknownJump_0x81DB:
UnknownRJump_0x81DB:
	ld de, $FFE3
	ld b, 0
	ldh a, [$FFDB]
	add a
	ld c, a
	rl b
	add hl, bc
	ld a, [hli]
	ld c, a
	ld h, [hl]
	ld l, c
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	ret

UnknownCall_0x81F7:
	ldh a, [$FFF0]
	and $01
	ret nz
	ld hl, $AF0A
	ld de, $AF02
	ld b, 4
	call UnknownCall_0x3CAA
	call UnknownCall_0x82D5
	ld a, [$AF2A]
	and a
	ret z
	ld hl, $AF0E
	ld de, $AF02
	ld b, 4
	call UnknownCall_0x3CAA
	call UnknownCall_0x8306
	ld a, [$AF2A]
	and a
	ret z
	ld a, [$AF28]
	ld h, a
	ld a, [$AF29]
	ld l, a
	ld [hl], 2
	ld a, l
	add 9
	ld l, a
	ld a, [hli]
	ld [hl], a
	ld hl, $AF40
	dec [hl]
	ld hl, $AF41
	inc [hl]
	ld a, 1
	ld [$AF3E], a
	ret

UnknownCall_0x8240:
	ldh a, [$FFD6]
	cp $AD
	ret nc
	ldh a, [$FFD5]
	ld e, a
	ld d, 0
	ld hl, $4BC1
	ld a, [$AF06]
	and a
	jr nz, UnknownRJump_0x8256
	ld hl, $4B61

UnknownRJump_0x8256:
	add hl, de
	ld a, [hl]
	ld hl, $FFDB
	ld [hli], a
	inc l
	ld a, [$AF38]
	ld [hli], a
	ld b, 17
	xor a

UnknownRJump_0x8264:
	ld [hli], a
	dec b
	jr nz, UnknownRJump_0x8264
	xor a
	ld [$AF38], a
	ret

UnknownCall_0x826D:
	ldh a, [$FFF0]
	and $01
	ret z
	ld hl, $AF1A
	ld de, $AF02
	ld b, 4
	call UnknownCall_0x3CAA
	call UnknownCall_0x82D5
	ld a, [$AF2A]
	and a
	ret nz

UnknownRJump_0x8285:
	call UnknownCall_0x81A7
	call UnknownCall_0x3C6C
	call UnknownCall_0x81BA
	ret

UnknownCall_0x828F:
	ldh a, [$FFF0]
	and $01
	ret nz
	ld hl, $AF16
	ld de, $AF02
	ld b, 4
	call UnknownCall_0x3CAA
	call UnknownCall_0x8306
	ld a, [$AF2A]
	and a
	ret nz
	ldh a, [$FFD5]
	cp $10
	jr z, UnknownRJump_0x8285
	ld a, [$AF28]
	ld h, a
	ld a, [$AF29]
	sub 2
	ld l, a
	ld a, [hli]
	cp $AD
	jr nc, UnknownRJump_0x8285
	inc l
	ld [hl], 1
	ld a, l
	add 10
	ld l, a
	ld a, [hld]
	ld [hli], a
	ld [hl], 0
	ld a, 3
	ld [$AF3E], a
	ld hl, $AF41
	dec [hl]
	ld hl, $AF40
	inc [hl]
	ret

UnknownCall_0x82D5:
	xor a
	ld [$AF2A], a
	ld a, [$AF28]
	ld h, a
	ld a, [$AF29]
	and $F0
	ld l, a

UnknownRJump_0x82E3:
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, [$AF02]
	cp b
	ret c
	jr nz, UnknownRJump_0x82F2
	ld a, [$AF03]
	cp c
	ret c

UnknownRJump_0x82F2:
	ld a, [$AF04]
	cp b
	jr c, UnknownRJump_0x8300
	ret nz
	ld a, [$AF05]
	cp c
	jr z, UnknownRJump_0x8300
	ret nc

UnknownRJump_0x8300:
	ld a, 1
	ld [$AF2A], a
	ret

UnknownCall_0x8306:
	xor a
	ld [$AF2A], a
	ld a, [$AF28]
	ld h, a
	ld a, [$AF29]
	and $F0
	add 3
	ld l, a
	jr UnknownRJump_0x82E3

UnknownCall_0x8318:
	ld a, 136
	ld [$AF2F], a
	ldh a, [$FFD4]
	ldh_n_a $B7
	and $0C
	jr nz, UnknownRJump_0x837B
	ldh a, [$FFD3]
	ldh_n_a $B8
	ld b, 16
	call UnknownCall_0x859D
	call UnknownCall_0x1F2F
	cp $48
	ret c
	jr UnknownRJump_0x837B

UnknownCall_0x8338:
	ld a, 136
	ld [$AF2F], a
	ldh a, [$FFD4]
	ldh_n_a $B7
	and $0C
	jr nz, UnknownRJump_0x837B
	ldh a, [$FFD3]
	ldh_n_a $B8
	ld b, 16
	call UnknownCall_0x8590
	call UnknownCall_0x1F2F
	cp $48
	ret c
	jr UnknownRJump_0x837B

UnknownCall_0x8358:
	ld a, 136
	ld [$AF2F], a
	ldh a, [$FFD4]
	ldh_n_a $B7
	and $0C
	jr nz, UnknownRJump_0x837B
	ldh a, [$FFD3]
	ldh_n_a $B8

UnknownRJump_0x836B:
	ldh a, [$FFD1]
	ldh_n_a $B9
	ldh a, [$FFD0]
	ldh_n_a $BA
	call UnknownCall_0x1F2F
	cp $48
	ret c

UnknownRJump_0x837B:
	ld hl, $AF2F
	res 3, [hl]
	ret

UnknownCall_0x8381:
	ld a, 136
	ld [$AF2F], a
	ld b, 16
	call UnknownCall_0x8576
	ldh_a_n $B7
	and $0C
	jr nz, UnknownRJump_0x837B
	jr UnknownRJump_0x836B

UnknownCall_0x8394:
	ld a, 68
	ld [$AF2F], a
	ld b, 8
	call UnknownCall_0x8583
	ldh a, [$FFD1]
	ldh_n_a $B9
	ldh a, [$FFD0]
	ldh_n_a $BA
	call UnknownCall_0x1F2F
	cp $38
	ret c
	jr UnknownRJump_0x83CA

UnknownCall_0x83B0:
	ld a, 68
	ld [$AF2F], a
	ld b, 18
	call UnknownCall_0x8583
	ldh a, [$FFD1]
	ldh_n_a $B9
	ldh a, [$FFD0]
	ldh_n_a $BA
	call UnknownCall_0x1F2F
	cp $38
	ret c

UnknownRJump_0x83CA:
	ld hl, $AF2F
	res 2, [hl]
	ret

UnknownCall_0x83D0:
	ld a, 68
	ld [$AF2F], a
	ld b, 32
	call UnknownCall_0x8583
	ldh a, [$FFD1]
	ldh_n_a $B9
	ldh a, [$FFD0]
	ldh_n_a $BA
	call UnknownCall_0x1F2F
	cp $38
	ret c
	jr UnknownRJump_0x83CA

UnknownCall_0x83EC:
	ld a, 68
	ld [$AF2F], a
	ld b, 18
	call UnknownCall_0x8583
	ld b, 16
	call UnknownCall_0x859D
	call UnknownCall_0x1F2F
	cp $38
	ret c
	jr UnknownRJump_0x83CA

UnknownCall_0x8403:
	ld a, 68
	ld [$AF2F], a
	ld b, 18
	call UnknownCall_0x8583
	ld b, 16
	call UnknownCall_0x8590
	call UnknownCall_0x1F2F
	cp $38
	ret c
	jr UnknownRJump_0x83CA

UnknownCall_0x841A:
	ld a, 17
	ld [$AF2F], a
	ld b, 8
	call UnknownCall_0x8583
	ld b, 7
	call UnknownCall_0x8590
	call UnknownCall_0x1F2F
	cp $38
	ret c
	ld b, 5
	call UnknownCall_0x8583
	call UnknownCall_0x1F2F
	cp $38
	ret c
	jr UnknownRJump_0x845C

UnknownCall_0x843C:
	ld a, 17
	ld [$AF2F], a
	ld b, 11
	call UnknownCall_0x8583
	ld b, 7
	call UnknownCall_0x8590
	call UnknownCall_0x1F2F
	cp $38
	ret c
	ld b, 5
	call UnknownCall_0x8583
	call UnknownCall_0x1F2F
	cp $38
	ret c

UnknownRJump_0x845C:
	ld hl, $AF2F
	res 0, [hl]
	ret

UnknownCall_0x8462:
	ld a, 17
	ld [$AF2F], a
	ld b, 11
	call UnknownCall_0x8583
	ld b, 11
	call UnknownCall_0x8590
	call UnknownCall_0x1F2F
	cp $38
	ret c
	ld b, 5
	call UnknownCall_0x8583
	call UnknownCall_0x1F2F
	cp $38
	ret c
	jr UnknownRJump_0x845C

UnknownCall_0x8484:
	ld a, 17
	ld [$AF2F], a
	ld b, 11
	call UnknownCall_0x8583
	ld b, 19
	call UnknownCall_0x8590
	call UnknownCall_0x1F2F
	cp $38
	ret c
	ld b, 5
	call UnknownCall_0x8583
	call UnknownCall_0x1F2F
	cp $38
	ret c
	jr UnknownRJump_0x845C

UnknownCall_0x84A6:
	ld a, 17
	ld [$AF2F], a
	ld b, 19
	call UnknownCall_0x8583
	ld b, 11
	call UnknownCall_0x8590
	call UnknownCall_0x1F2F
	cp $38
	ret c
	ld b, 4
	call UnknownCall_0x8583
	call UnknownCall_0x1F2F
	cp $38
	ret c
	jr UnknownRJump_0x845C

UnknownCall_0x84C8:
	ld a, 34
	ld [$AF2F], a
	ld b, 8
	call UnknownCall_0x8583
	ld b, 7
	call UnknownCall_0x859D
	call UnknownCall_0x1F2F
	cp $38
	ret c
	ld b, 5
	call UnknownCall_0x8583
	call UnknownCall_0x1F2F
	cp $38
	ret c
	jr UnknownRJump_0x850A

UnknownCall_0x84EA:
	ld a, 34
	ld [$AF2F], a
	ld b, 11
	call UnknownCall_0x8583
	ld b, 7
	call UnknownCall_0x859D
	call UnknownCall_0x1F2F
	cp $38
	ret c
	ld b, 5
	call UnknownCall_0x8583
	call UnknownCall_0x1F2F
	cp $38
	ret c

UnknownRJump_0x850A:
	ld hl, $AF2F
	res 1, [hl]
	ret

UnknownCall_0x8510:
	ld a, 34
	ld [$AF2F], a
	ld b, 11
	call UnknownCall_0x8583
	ld b, 11
	call UnknownCall_0x859D
	call UnknownCall_0x1F2F
	cp $38
	ret c
	ld b, 5
	call UnknownCall_0x8583
	call UnknownCall_0x1F2F
	cp $38
	ret c
	jr UnknownRJump_0x850A

UnknownCall_0x8532:
	ld a, 34
	ld [$AF2F], a
	ld b, 11
	call UnknownCall_0x8583
	ld b, 19
	call UnknownCall_0x859D
	call UnknownCall_0x1F2F
	cp $38
	ret c
	ld b, 5
	call UnknownCall_0x8583
	call UnknownCall_0x1F2F
	cp $38
	ret c
	jr UnknownRJump_0x850A

UnknownCall_0x8554:
	ld a, 34
	ld [$AF2F], a
	ld b, 19
	call UnknownCall_0x8583
	ld b, 11
	call UnknownCall_0x859D
	call UnknownCall_0x1F2F
	cp $38
	ret c
	ld b, 4
	call UnknownCall_0x8583
	call UnknownCall_0x1F2F
	cp $38
	ret c
	jr UnknownRJump_0x850A

UnknownCall_0x8576:
	ld hl, $FFB7
	ldh a, [$FFD4]
	add b
	ld [hli], a
	ldh a, [$FFD3]
	adc 0
	ld [hl], a
	ret

UnknownCall_0x8583:
	ld hl, $FFB7
	ldh a, [$FFD4]
	sub b
	ld [hli], a
	ldh a, [$FFD3]
	sbc 0
	ld [hl], a
	ret

UnknownCall_0x8590:
	ld hl, $FFB9
	ldh a, [$FFD1]
	add b
	ld [hli], a
	ldh a, [$FFD0]
	adc 0
	ld [hl], a
	ret

UnknownCall_0x859D:
	ld hl, $FFB9
	ldh a, [$FFD1]
	sub b
	ld [hli], a
	ldh a, [$FFD0]
	sbc 0
	ld [hl], a
	ret

UnknownCall_0x85AA:
	ldh a, [$FFE7]
	and a
	ret z
	bit 0, a
	jr nz, UnknownRJump_0x85C4
	bit 1, a
	jr nz, UnknownRJump_0x85F0
	bit 2, a
	jr nz, UnknownRJump_0x85E2
	bit 4, a
	jr nz, UnknownRJump_0x8611
	bit 5, a
	jp nz, UnknownJump_0x86A0
	ret

UnknownRJump_0x85C4:
	xor a
	ldh [$FFDF], a
	ld a, [sSpinJump]
	and a
	jr nz, UnknownRJump_0x85F0
	ldh a, [$FFE2]
	bit 1, a
	jr z, UnknownRJump_0x85F0
	bit 0, a
	jr z, UnknownRJump_0x8633
	ld a, 3
	ld [$A460], a

UnknownCall_0x85DC:
	ld hl, $FFD5
	dec [hl]
	jr UnknownRJump_0x863C

UnknownRJump_0x85E2:
	ld a, [$A460]
	cp $09
	jr z, UnknownRJump_0x85FC
	ld a, 16
	ld [$A460], a
	jr UnknownRJump_0x85FC

UnknownJump_0x85F0:
UnknownRJump_0x85F0:
	ld a, [$A460]
	cp $09
	jr z, UnknownRJump_0x85FC
	ld a, 6
	ld [$A460], a

UnknownRJump_0x85FC:
UnknownCall_0x85FC:
	call UnknownCall_0x3A78
	xor a
	ldh [$FFD5], a
	ldh [$FFDF], a
	ldh [$FFDC], a
	ldh [$FFE2], a
	ld a, 1
	ld [$AF3E], a
	ld [$AF09], a
	ret

UnknownRJump_0x8611:
	ldh a, [$FFE2]
	bit 7, a
	jr nz, UnknownRJump_0x868A
	cp $06
	ret nz
	ldh_a_n $80
	bit 1, a
	jr z, UnknownRJump_0x864A
	ld a, [$AF3A]
	and a
	ret nz
	ld a, 1
	ld [$AF3A], a
	ldh a, [$FFD5]
	add 2
	ldh [$FFD5], a
	jr UnknownRJump_0x863C

UnknownRJump_0x8633:
UnknownCall_0x8633:
	ld a, 3
	ld [$A460], a
	ld hl, $FFD5
	inc [hl]

UnknownJump_0x863C:
UnknownRJump_0x863C:
UnknownCall_0x863C:
	ldh a, [$FFDD]
	ld [$AF38], a
	call UnknownCall_0x8240
	ld a, 1
	ld [$AF3E], a
	ret

UnknownRJump_0x864A:
	call UnknownCall_0x8633
	ld b, 16
	ld a, [sMarioDirection]
	cp $01
	jr z, UnknownRJump_0x8670
	call UnknownCall_0x3D22
	call UnknownCall_0x84C8
	ld a, [$AF2F]
	bit 1, a
	ret z
	ld b, 16
	call UnknownCall_0x3D32
	ld a, 95
	ldh [$FFE2], a
	ld a, 2
	ldh [$FFDF], a
	ret

UnknownRJump_0x8670:
	call UnknownCall_0x3D32
	call UnknownCall_0x841A
	ld a, [$AF2F]
	bit 0, a
	ret z

UnknownData_0x867C:
INCBIN "baserom.gb", $867C, $868A - $867C


UnknownRJump_0x868A:
	cp $85
	jr z, UnknownRJump_0x86DA
	cp $89
	jr z, UnknownRJump_0x8695
	cp $86
	ret nc

UnknownRJump_0x8695:
	xor a
	ldh [$FFDD], a
	call UnknownCall_0x863C
	ld a, 16
	ldh [$FFD5], a
	ret

UnknownJump_0x86A0:
	ld a, 1
	ld [$AF09], a
	ldh a, [$FFE2]
	bit 7, a
	jr nz, UnknownRJump_0x86E4
	xor a
	ldh [$FFDF], a
	ldh a, [$FFE2]
	bit 4, a
	jr nz, UnknownRJump_0x86C6
	bit 3, a
	jp nz, UnknownJump_0x85F0

UnknownData_0x86B9:
INCBIN "baserom.gb", $86B9, $86C6 - $86B9


UnknownRJump_0x86C6:
	bit 3, a
	jr nz, UnknownRJump_0x86D2
	call UnknownCall_0x8633
	ld a, 1
	ldh [$FFEB], a
	ret

UnknownRJump_0x86D2:
UnknownData_0x86D2:
INCBIN "baserom.gb", $86D2, $86DA - $86D2


UnknownRJump_0x86DA:
	ld a, 16
	ldh [$FFD5], a
	xor a
	ldh [$FFDD], a
	jp UnknownJump_0x863C

UnknownRJump_0x86E4:
	ldh a, [$FFE2]
	and $7F
	jr nz, UnknownRJump_0x8721
	ldh a, [$FFD5]
	cp $11
	jr nz, UnknownRJump_0x8708
	ld a, [sCurPowerup]
	and a
	jr z, UnknownRJump_0x8708
	ldh a, [$FFD6]
	ld h, a
	ldh a, [$FFD7]
	ld l, a
	inc hl
	inc hl
	inc hl
	ld a, 18
	ld [hl], a
	ldh [$FFD5], a
	ld a, 26
	ldh [$FFDB], a

UnknownRJump_0x8708:
	ldh a, [$FFD5]
	add 112
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ld b, 16
	call UnknownCall_0x3A64
	ld a, 8
	ld [$A460], a
	ld a, 16
	ldh [$FFD2], a
	ret

UnknownRJump_0x8721:
	ldh a, [$FFE2]
	ld [$AFCC], a
	call UnknownCall_0x863C
	ld a, [$AFCC]
	ldh [$FFE2], a
	xor a
	ld [$AFCC], a
	ld a, 2
	ldh [$FFEB], a
	ret

UnknownData_0x8737:
INCBIN "baserom.gb", $8737, $8C31 - $8737


UnknownCall_0x8C31:
	ld a, [$AF22]
	and a
	ret z
	dec a
	jr z, UnknownRJump_0x8C3C
	jp UnknownJump_0x8CEB

UnknownRJump_0x8C3C:
	ld a, [$AF00]
	cp $FF
	ret z
	ld c, a
	ld a, [$AF1E]
	ld h, a
	ld a, [$AF1F]
	ld l, a
	ld a, [hl]
	cp $FF
	ret z
	ld de, $0006

UnknownRJump_0x8C52:
	cp c
	jr z, UnknownRJump_0x8C6E
	ret nc

UnknownJump_0x8C56:
UnknownRJump_0x8C56:
	ld a, [$AF1E]
	ld h, a
	ld a, [$AF1F]
	ld l, a
	add hl, de
	ld a, [hl]
	cp $FF
	ret z
	ld a, h
	ld [$AF1E], a
	ld a, l
	ld [$AF1F], a
	ld a, [hl]
	jr UnknownRJump_0x8C52

UnknownRJump_0x8C6E:
	inc hl
	ld a, [$AF01]
	ld b, a
	ld a, [hl]
	cp b
	jr c, UnknownRJump_0x8C56
	ret nz
	ld a, [sEasyMode]
	and $01
	jr nz, UnknownRJump_0x8C87
	inc hl
	ld a, [hl]
	and $0E
	jr nz, UnknownRJump_0x8C56
	jr UnknownRJump_0x8C8D

UnknownRJump_0x8C87:
	inc hl
	ld a, [hl]
	and $0F
	jr nz, UnknownRJump_0x8C56

UnknownRJump_0x8C8D:
	ld b, e
	ld hl, $ACE8
	ld e, 32

UnknownRJump_0x8C93:
	add hl, de
	ld a, [hl]
	and a
	jr nz, UnknownRJump_0x8C93
	ld a, h
	cp $AF
	ret z
	ld a, l
	and $F0
	ld l, a
	ld a, [$AF1E]
	ld d, a
	ld a, [$AF1F]
	ld e, a

UnknownRJump_0x8CA8:
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, UnknownRJump_0x8CA8
	ld a, [$AF1E]
	ld [hli], a
	ld a, [$AF1F]
	add 2
	ld [hli], a
	ld a, h
	ld [$AF28], a
	ld a, l
	ld [$AF29], a
	ld a, 1
	ld [hli], a
	ld b, 23
	xor a

UnknownRJump_0x8CC6:
	ld [hli], a
	dec b
	jr nz, UnknownRJump_0x8CC6
	ld a, [$AF1E]
	ld h, a
	ld a, [$AF1F]
	add 2
	ld l, a
	ld [hl], 2
	push bc
	call UnknownCall_0x81A7
	call UnknownCall_0x8240
	call UnknownCall_0x81BA
	pop bc
	ld hl, $AF40
	inc [hl]
	ld de, $0006
	jp UnknownJump_0x8C56

UnknownJump_0x8CEB:
	ld a, [$AF00]
	cp $FF
	ret z
	ld c, a
	ld a, [$AF1E]
	ld h, a
	ld a, [$AF1F]
	ld l, a
	ld a, [hl]
	cp $FF
	ret z
	ld de, $FFFA

UnknownRJump_0x8D01:
	cp c
	jr z, UnknownRJump_0x8D1D
	ret c

UnknownJump_0x8D05:
UnknownRJump_0x8D05:
	ld a, [$AF1E]
	ld h, a
	ld a, [$AF1F]
	ld l, a
	add hl, de
	ld a, [hl]
	cp $FF
	ret z
	ld a, h
	ld [$AF1E], a
	ld a, l
	ld [$AF1F], a
	ld a, [hl]
	jr UnknownRJump_0x8D01

UnknownRJump_0x8D1D:
	inc hl
	ld a, [$AF01]
	ld b, a
	ld a, [hl]
	cp b
	ret c
	jr nz, UnknownRJump_0x8D05
	ld a, [sEasyMode]
	and $01
	jr nz, UnknownRJump_0x8D36
	inc hl
	ld a, [hl]
	and $0E
	jr nz, UnknownRJump_0x8D05
	jr UnknownRJump_0x8D3C

UnknownRJump_0x8D36:
	inc hl
	ld a, [hl]
	and $0F
	jr nz, UnknownRJump_0x8D05

UnknownRJump_0x8D3C:
	ld b, 6
	ld hl, $ACE8
	ld de, $0020

UnknownRJump_0x8D44:
	add hl, de
	ld a, [hl]
	and a
	jr nz, UnknownRJump_0x8D44
	ld a, h
	cp $AF
	ret z
	ld a, l
	and $F0
	ld l, a
	ld a, [$AF1E]
	ld d, a
	ld a, [$AF1F]
	ld e, a

UnknownRJump_0x8D59:
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, UnknownRJump_0x8D59
	ld a, [$AF1E]
	ld [hli], a
	ld a, [$AF1F]
	add 2
	ld [hli], a
	ld a, h
	ld [$AF28], a
	ld a, l
	ld [$AF29], a
	ld a, 1
	ld [hli], a
	ld b, 23
	xor a

UnknownRJump_0x8D77:
	ld [hli], a
	dec b
	jr nz, UnknownRJump_0x8D77
	ld a, [$AF1E]
	ld h, a
	ld a, [$AF1F]
	add 2
	ld l, a
	ld [hl], 2
	push bc
	call UnknownCall_0x81A7
	call UnknownCall_0x8240
	call UnknownCall_0x81BA
	pop bc
	ld hl, $AF40
	inc [hl]
	ld de, $FFFA
	jp UnknownJump_0x8D05

UnknownJump_0x8D9C:
	call UnknownCall_0x3A28
	call UnknownCall_0x3A00
	call UnknownCall_0x8DFD
	call UnknownCall_0x8E6C
	ret

UnknownJump_0x8DA9:
	ld a, [$AFC1]
	inc a
	ld [$AFC2], a
	ld a, 173
	ld [$AF28], a
	ld a, 0
	ld [$AF29], a
	ld hl, $FFF0
	inc [hl]

UnknownRJump_0x8DBE:
	xor a
	ld [$AF3E], a
	ld [$AFC3], a
	ld [$5290], a
	call UnknownCall_0x81A7
	ldh a, [$FFD5]
	and a
	jr z, UnknownRJump_0x8DDF
	call UnknownCall_0x92DF
	call UnknownCall_0x3A14
	xor a
	ldh [$FFE7], a
	call UnknownCall_0x9048
	call UnknownCall_0x81BD

UnknownRJump_0x8DDF:
	ld a, [$AFC2]
	dec a
	ret z
	ld [$AFC2], a
	ld a, [$AF28]
	ld h, a
	ld a, [$AF29]
	ld l, a
	ld de, $0020
	add hl, de
	ld a, h
	ld [$AF28], a
	ld a, l
	ld [$AF29], a
	jr UnknownRJump_0x8DBE

UnknownCall_0x8DFD:
	ld b, 0
	ld a, [sCurLevel]
	cp $05
	jr z, UnknownRJump_0x8E20
	inc b
	cp $09
	jr z, UnknownRJump_0x8E20
	inc b
	cp $0D
	jr z, UnknownRJump_0x8E20
	inc b
	cp $10
	jr z, UnknownRJump_0x8E20
	inc b
	cp $13
	jr z, UnknownRJump_0x8E20
	inc b
	cp $17
	jr z, UnknownRJump_0x8E20
	inc b

UnknownRJump_0x8E20:
	ld a, [$A2DC]
	add b
	ld [$AFC0], a
	ld a, 80
	ld [$AFCD], a
	ld hl, $4E3F
	call UnknownCall_0x904E
	ld a, [hli]
	ld [$AFC1], a
	ld a, [hli]
	ld [$AFC5], a
	ld a, [hl]
	ld [$AFCA], a
	ret

UnknownData_0x8E3F:
INCBIN "baserom.gb", $8E3F, $8E6C - $8E3F


UnknownCall_0x8E6C:
	ld hl, $4E9A
	call UnknownCall_0x904E
	ld de, $AD05
	ld b, 18
	call UnknownCall_0x3CAA
	ld hl, $4EAC
	call UnknownCall_0x904E
	ld a, [$AFC1]
	and a
	ret z
	ld c, a
	ld de, $AD25

UnknownRJump_0x8E89:
	ld b, 18
	call UnknownCall_0x3CAA
	ld a, e
	add 16
	and $F0
	add 5
	ld e, a
	dec c
	jr nz, UnknownRJump_0x8E89
	ret

UnknownData_0x8E9A:
INCBIN "baserom.gb", $8E9A, $9048 - $8E9A


UnknownCall_0x9048:
	ld hl, $505B
	jp UnknownJump_0x81DB

UnknownCall_0x904E:
	ld a, [$AFC0]
	add a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld e, a
	ld h, [hl]
	ld l, e
	ret

UnknownData_0x905B:
INCBIN "baserom.gb", $905B, $9285 - $905B


UnknownCall_0x9285:
	ldh a, [$FFE7]
	bit 0, a
	jr nz, UnknownRJump_0x92A5
	bit 1, a
	jr nz, UnknownRJump_0x9290
	ret

UnknownRJump_0x9290:
	ld a, 1
	ld [$AF3E], a
	ld a, [$AF29]
	and a
	ret nz

UnknownData_0x929A:
INCBIN "baserom.gb", $929A, $92A5 - $929A


UnknownRJump_0x92A5:
	ld a, 1
	ld [$AF3E], a
	ld [$AFC3], a
	ld a, [$AF29]
	and a
	ret nz
	ld a, 19
	ld [$A460], a
	ld a, [$AFC5]
	sub 2
	ld [$AFC5], a
	jr z, UnknownRJump_0x92C4
	jr c, UnknownRJump_0x92C4
	ret

UnknownRJump_0x92C4:
	ld a, 1
	ld [$AF26], a
	ld a, [$AFC0]
	cp $06
	ret nc
	ld a, 2
	ld [$A267], a
	ld a, 128
	ld [$A266], a
	ld a, 1
	ld [$A2E3], a
	ret

UnknownCall_0x92DF:
	ld a, [$A224]
	cp $FF
	ret z
	ldh a, [$FFD5]
	rst $28

UnknownData_0x92E8:
INCBIN "baserom.gb", $92E8, $9323 - $92E8

	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x934C
	ld b, 32
	call UnknownCall_0xB270
	ldh a, [$FFDD]
	xor $40
	ldh [$FFDD], a
	xor a
	ldh [$FFE0], a
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ld a, 13
	ld [$A460], a
	ld a, [$AF29]
	and a
	ret z
	ld a, 23
	ld [$A460], a
	ret

UnknownRJump_0x934C:
	dec a
	rst $28

UnknownData_0x934E:
INCBIN "baserom.gb", $934E, $9354 - $934E

	call UnknownCall_0xB1EB
	call UnknownCall_0xB270
	ldh a, [$FFE0]
	cp c
	ret nz
	ld a, 2
	ldh [$FFDF], a
	xor a
	ldh [$FFE0], a
	ret
	call UnknownCall_0xB18F
	call UnknownCall_0xB276
	ldh a, [$FFD9]
	cp $D0
	ret c
	ld a, [$AF29]
	and a
	jr nz, UnknownRJump_0x9399
	ld a, 3
	ldh [$FFDF], a
	ld a, 208
	ldh [$FFEC], a
	ld a, 12
	ld [$A468], a
	ret
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	call UnknownCall_0xB15B
	ld a, 1
	ld [$AF3E], a
	ld a, 2
	ld [$AF26], a
	ret

UnknownRJump_0x9399:
	call UnknownCall_0xB157
	ld a, 1
	ld [$AF3E], a
	ld a, 2
	ld [$AF26], a
	ret
	call UnknownCall_0x9285
	ld a, [$AF3E]
	and a
	jr z, UnknownRJump_0x93D5
	ldh a, [$FFDB]
	ld [$AF37], a
	ldh a, [$FFDF]
	ld [$AFC4], a
	ldh a, [$FFE2]
	ld [$AFCC], a
	ld a, [$AFC3]
	and a
	jr z, UnknownRJump_0x93CD
	xor a
	ldh [$FFDB], a
	ld a, [$AFCD]
	ldh [$FFEC], a

UnknownRJump_0x93CD:
	xor a
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ret

UnknownRJump_0x93D5:
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x93EE
	call UnknownCall_0xB309
	call UnknownCall_0xB14E
	ret nz
	ld a, 69
	ldh [$FFE2], a
	ld a, 3
	ldh [$FFDB], a
	ld a, 3
	ldh [$FFDF], a
	ret

UnknownRJump_0x93EE:
	dec a
	rst $28

UnknownData_0x93F0:
INCBIN "baserom.gb", $93F0, $93FE - $93F0

	call UnknownCall_0xB40E
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x940F
	call UnknownCall_0xB2F6
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz

UnknownRJump_0x940F:
	ld a, [$AF26]
	and a
	jr nz, UnknownRJump_0x9435
	ld a, 4
	ldh [$FFDB], a
	ldh a, [$FFEA]
	inc a
	ldh [$FFEA], a
	cp $10
	ret nz
	xor a
	ldh [$FFEA], a
	ldh [$FFDE], a
	ld a, [$AF37]
	ldh [$FFDB], a
	ld a, [$AFC4]
	ldh [$FFDF], a
	ld a, 69
	ldh [$FFE2], a
	ret

UnknownJump_0x9435:
UnknownRJump_0x9435:
	ld a, 2
	ldh [$FFDF], a
	ld a, 32
	ldh [$FFEC], a
	ld a, [$AFCA]
	ldh [$FFDB], a
	ret

UnknownJump_0x9443:
UnknownCall_0x9443:
	call UnknownCall_0xB40E
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	xor a
	ldh [$FFDF], a
	ld a, 3
	ldh [$FFD5], a
	xor a
	ldh [$FFEA], a
	ldh [$FFDE], a
	ld a, [$AF29]
	and a
	ret nz
	ld a, 255
	ld [$A468], a
	ret
	call UnknownCall_0xB183
	call UnknownCall_0xB276
	ldh a, [$FFE0]
	cp c
	ret nz
	ld a, 1
	ldh [$FFE0], a
	ld a, 4
	ldh [$FFDF], a
	ld a, 2
	ld [$A478], a
	ret
	call UnknownCall_0xB2FD
	ldh a, [$FFE0]
	cp $0C
	jr c, UnknownRJump_0x9489
	ld b, 1
	call UnknownCall_0xB270

UnknownRJump_0x9489:
	ld hl, $5595
	call UnknownCall_0xB16B
	call UnknownCall_0xB26A
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp $69
	ret nz
	ld a, 104
	ldh [$FFE0], a
	ld a, 5
	ldh [$FFDF], a
	ld a, 80
	ldh [$FFEC], a
	ld a, [$AFC5]
	cp $03
	ret nc

UnknownData_0x94AC:
INCBIN "baserom.gb", $94AC, $94B6 - $94AC

	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x94CD
	call UnknownCall_0xB2FD
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 5
	ldh [$FFDB], a
	ld a, 8
	ld [$A470], a

UnknownRJump_0x94CD:
	call UnknownCall_0xB309
	ld a, [$AFC6]
	and a
	jr nz, UnknownRJump_0x94DC
	ldh a, [$FFE0]
	cp $0C
	jr c, UnknownRJump_0x94E1

UnknownRJump_0x94DC:
	ld b, 1
	call UnknownCall_0xB276

UnknownRJump_0x94E1:
	ld hl, $5595
	call UnknownCall_0xB16B
	call UnknownCall_0xB264
	ldh a, [$FFE0]
	dec a
	ldh [$FFE0], a
	ret nz
	ld a, 1
	ldh [$FFE0], a
	ld a, 6
	ldh [$FFDF], a
	ld a, 2
	ldh [$FFDB], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ld a, 2
	ld [$A478], a
	ret
	call UnknownCall_0xB2FD
	ldh a, [$FFE0]
	cp $0C
	jr c, UnknownRJump_0x9516
	ld b, 1
	call UnknownCall_0xB270

UnknownRJump_0x9516:
	ld hl, $5595
	call UnknownCall_0xB16B
	call UnknownCall_0xB264
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp $69
	ret nz
	ld a, 104
	ldh [$FFE0], a
	ld a, 7
	ldh [$FFDF], a
	ld a, 80
	ldh [$FFEC], a
	ld a, [$AFC5]
	cp $03
	ret nc
	ld a, 1
	ld [$AFC6], a
	ld a, 92
	ldh [$FFE0], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x955A
	call UnknownCall_0xB2FD
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 5
	ldh [$FFDB], a
	ld a, 8
	ld [$A470], a

UnknownRJump_0x955A:
	call UnknownCall_0xB309
	ld a, [$AFC6]
	and a
	jr nz, UnknownRJump_0x9569

UnknownData_0x9563:
INCBIN "baserom.gb", $9563, $9569 - $9563


UnknownRJump_0x9569:
	ld b, 1
	call UnknownCall_0xB276
	ld hl, $5595
	call UnknownCall_0xB16B
	call UnknownCall_0xB26A
	ldh a, [$FFE0]
	dec a
	ldh [$FFE0], a
	ret nz
	ld a, 1
	ldh [$FFE0], a
	ld a, 4
	ldh [$FFDF], a
	ld a, 2
	ldh [$FFDB], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ld a, 2
	ld [$A478], a
	ret

UnknownData_0x9595:
INCBIN "baserom.gb", $9595, $9606 - $9595

	ldh a, [$FFDF]
	and a
	ret nz
	ld a, [$AF26]
	cp $02
	ret nz
	xor a
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ld a, 4
	ld [$AF36], a
	ld a, 9
	ld [$AF37], a
	call UnknownCall_0xB224
	ld a, 7
	ldh [$FFDB], a
	ret
	call UnknownCall_0xB1D6
	call UnknownCall_0xB270
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 2
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $40
	ldh [$FFDD], a
	ret

UnknownData_0x9641:
INCBIN "baserom.gb", $9641, $9642 - $9641

	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x965E
	ld a, 1
	ldh [$FFDF], a
	ld a, 5
	ld [$AF36], a
	ld a, 12
	ld [$AF37], a
	ldh a, [$FFDD]
	ld [$AF38], a
	call UnknownCall_0xB224
	ret

UnknownRJump_0x965E:
	call UnknownCall_0xB38C
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x966A:
INCBIN "baserom.gb", $966A, $9670 - $966A

	call UnknownCall_0xB18F
	call UnknownCall_0xB276
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 3
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $40
	ldh [$FFDD], a
	ret
	ld b, 4
	call UnknownCall_0xB270
	ldh a, [$FFD9]
	cp $08
	ret nc
	ld a, 29
	ldh_n_a $9B
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x96B2
	ldh a, [$FFEC]
	inc a
	ldh [$FFEC], a
	cp $08
	ret nz
	xor a
	ldh [$FFEC], a
	ld a, 1
	ldh [$FFDF], a
	ld a, 24
	call UnknownCall_0xB276
	ret

UnknownRJump_0x96B2:
	call UnknownCall_0xB2EF
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x96BE:
INCBIN "baserom.gb", $96BE, $96C4 - $96BE

	call UnknownCall_0xB1D6
	call UnknownCall_0xB270
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 2
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $40
	ldh [$FFDD], a
	ld b, 16
	call UnknownCall_0xB270
	ret
	call UnknownCall_0xB18F
	call UnknownCall_0xB276
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 3
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $40
	ldh [$FFDD], a
	ld b, 16
	call UnknownCall_0xB276
	ret
	call UnknownCall_0x9285
	ld a, [$AF3E]
	and a
	jr z, UnknownRJump_0x972D
	ldh a, [$FFDB]
	ld [$AF37], a
	ldh a, [$FFDF]
	ld [$AFC4], a
	ldh a, [$FFE2]
	ld [$AFCC], a
	ld a, [$AFC3]
	and a
	jr z, UnknownRJump_0x9725
	ld a, 17
	ldh [$FFDB], a
	ld a, [$AFCD]
	ldh [$FFEC], a

UnknownJump_0x9725:
UnknownRJump_0x9725:
	xor a
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ret

UnknownRJump_0x972D:
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x9752
	call UnknownCall_0xB14E
	ret nz
	ldh a, [$FFEC]
	inc a
	ldh [$FFEC], a
	cp $70
	ret nz
	xor a
	ldh [$FFEC], a
	ld a, 3
	ldh [$FFDF], a
	ld a, 8
	ldh [$FFEA], a
	call UnknownCall_0x97FA
	ld a, 2
	ld [$A470], a
	ret

UnknownRJump_0x9752:
	dec a
	rst $28

UnknownData_0x9754:
INCBIN "baserom.gb", $9754, $9762 - $9754

	call UnknownCall_0xB40E
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x9770
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz

UnknownRJump_0x9770:
	ld a, [$AF26]
	and a
	jp nz, UnknownJump_0x9435
	xor a
	ldh [$FFDE], a
	ld a, 20
	ldh [$FFDB], a
	ld a, 5
	ldh [$FFDF], a
	xor a
	ldh [$FFE2], a
	ret
	call UnknownCall_0x9C19
	ldh a, [$FFEA]
	and a
	ret nz
	ld a, 4
	ldh [$FFDF], a
	ld a, 16
	ldh [$FFDB], a
	ld a, 69
	ldh [$FFE2], a
	ld a, 112
	ldh [$FFEC], a
	ldh_a_n $04
	and $03
	ld [$AFC7], a
	ld a, 9
	ld [$AF36], a
	ld a, 26
	ld [$AF37], a
	ldh a, [$FFDD]
	ld [$AF38], a
	call UnknownCall_0xB224
	ld a, 6
	ld [$A478], a
	ret
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 20
	ldh [$FFDB], a
	ld a, 5
	ldh [$FFDF], a
	xor a
	ldh [$FFE2], a
	ret
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	cp $19
	ret nz
	ld a, 14
	ldh [$FFDB], a
	ld a, 6
	ldh [$FFDF], a
	ld a, 48
	ldh [$FFE8], a
	ret
	ld b, 2
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ld a, 7
	ldh [$FFDF], a
	ret
	xor a
	ldh [$FFDF], a
	ret

UnknownCall_0x97FA:
	ld a, 112
	ldh [$FFD9], a
	ldh_a_n $04
	and $03
	jr z, UnknownRJump_0x980D
	ld a, [$AFC9]
	xor $01
	ld [$AFC9], a

UnknownRJump_0x980D:
	ld a, [$AFC9]
	and a
	jr nz, UnknownRJump_0x981B
	ld a, 152
	ldh [$FFDA], a
	xor a
	ldh [$FFDD], a
	ret

UnknownRJump_0x981B:
	ld a, 24
	ldh [$FFDA], a
	ld a, 32
	ldh [$FFDD], a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x9862
	ld a, [$AFC8]
	and a
	ret z
	ld a, [$AFC7]
	bit 0, a
	ret z
	dec a
	jr z, UnknownRJump_0x9845
	ld a, [$AFC9]
	and a
	jr nz, UnknownRJump_0x984B

UnknownRJump_0x983D:
	ld a, [$AF29]
	cp $60
	ret nz
	jr UnknownRJump_0x9851

UnknownRJump_0x9845:
	ld a, [$AFC9]
	and a
	jr nz, UnknownRJump_0x983D

UnknownRJump_0x984B:
	ld a, [$AF29]
	cp $20
	ret nz

UnknownRJump_0x9851:
	ld a, 1
	ldh [$FFDF], a
	ld a, 80
	ldh [$FFE8], a
	ld a, 64
	ldh [$FFEC], a
	ld a, 25
	ldh [$FFDB], a
	ret

UnknownRJump_0x9862:
	dec a
	rst $28

UnknownData_0x9864:
INCBIN "baserom.gb", $9864, $986C - $9864

	call UnknownCall_0xB3F4
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 2
	ldh [$FFDF], a
	ld a, 19
	ldh [$FFDB], a
	ld a, 5
	ld [$A478], a
	ret
	ld a, [$AF26]
	and a
	jr nz, UnknownRJump_0x98A0
	ld b, 2
	call UnknownCall_0xB270
	call UnknownCall_0x3D10
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ld a, 3
	ldh [$FFDF], a
	ld a, 32
	ldh [$FFEC], a
	ret

UnknownRJump_0x98A0:
	xor a
	ldh [$FFE2], a
	ret
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	xor a
	ld [$AFC8], a
	ld a, 4
	ldh [$FFDF], a
	ret
	ldh a, [$FFD9]
	cp $84
	jr nc, UnknownRJump_0x98C0
	call UnknownCall_0xB18F
	call UnknownCall_0xB276
	ret

UnknownRJump_0x98C0:
	ld a, 132
	ldh [$FFD9], a
	xor a
	ldh [$FFDF], a
	ret
	ld a, [$AF26]
	cp $02
	jr z, UnknownRJump_0x98F0
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x9908
	ld a, [$AFC8]
	and a
	ret z
	ld a, [$AFC7]
	cp $02
	ret nz
	ld a, 1
	ldh [$FFDF], a
	ld a, 64
	ldh [$FFE8], a
	ld a, 64
	ldh [$FFEC], a
	ld a, 25
	ldh [$FFDB], a
	ret

UnknownRJump_0x98F0:
	ld a, 116
	ldh [$FFD9], a
	ld a, 88
	ldh [$FFDA], a

UnknownJump_0x98F8:
	ld a, 4
	ldh [$FFD5], a
	ld a, 9
	ldh [$FFDB], a
	xor a
	ldh [$FFDF], a
	ldh [$FFE0], a
	ldh [$FFE2], a
	ret

UnknownRJump_0x9908:
	dec a
	rst $28

UnknownData_0x990A:
INCBIN "baserom.gb", $990A, $9912 - $990A

	ldh a, [$FFD9]
	cp $74
	jr nc, UnknownRJump_0x991F
	call UnknownCall_0xB18F
	call UnknownCall_0xB276
	ret

UnknownRJump_0x991F:
	ld a, 116
	ldh [$FFD9], a
	xor a
	ldh [$FFDF], a
	ret
	call UnknownCall_0xB2FD
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x994A
	ld a, 64
	ldh [$FFE2], a
	call UnknownCall_0x3CB1
	ld b, 28
	call UnknownCall_0xB270
	ld b, 16
	ldh a, [$FFDD]
	and a
	jr nz, UnknownRJump_0x9946
	call UnknownCall_0xB264
	ret

UnknownRJump_0x9946:
	call UnknownCall_0xB26A
	ret

UnknownRJump_0x994A:
	dec a
	rst $28

UnknownData_0x994C:
INCBIN "baserom.gb", $994C, $9954 - $994C

	call UnknownCall_0x997D
	jr z, UnknownRJump_0x996E
	call UnknownCall_0xB264
	jr UnknownRJump_0x9966
	call UnknownCall_0x997D
	jr z, UnknownRJump_0x996E
	call UnknownCall_0xB26A

UnknownRJump_0x9966:
	call UnknownCall_0x99A2
	ld hl, $FFE0
	inc [hl]
	ret

UnknownRJump_0x996E:
	ldh a, [$FFDB]
	add 2
	ldh [$FFDB], a
	ld a, 3
	ldh [$FFDF], a
	ld a, 32
	ldh [$FFEC], a
	ret

UnknownCall_0x997D:
	ld a, [$AFC7]
	dec a
	jr z, UnknownRJump_0x998E
	dec a
	jr z, UnknownRJump_0x9993
	dec a
	jr z, UnknownRJump_0x9998
	ld hl, $59E2
	jr UnknownRJump_0x999B

UnknownRJump_0x998E:
	ld hl, $5A63
	jr UnknownRJump_0x999B

UnknownRJump_0x9993:
	ld hl, $5AB4
	jr UnknownRJump_0x999B

UnknownRJump_0x9998:
	ld hl, $5AF1

UnknownRJump_0x999B:
	call UnknownCall_0xB16B
	ld a, b
	cp $80
	ret

UnknownCall_0x99A2:
	ld a, [$AFC7]
	dec a
	jr z, UnknownRJump_0x99AF
	dec a
	jr z, UnknownRJump_0x99B4
	dec a
	jr z, UnknownRJump_0x99B9
	ret

UnknownRJump_0x99AF:
	ld hl, $5B3E
	jr UnknownRJump_0x99BC

UnknownRJump_0x99B4:
	ld hl, $5B8F
	jr UnknownRJump_0x99BC

UnknownRJump_0x99B9:
	ld hl, $5BCC

UnknownRJump_0x99BC:
	call UnknownCall_0xB16B
	call UnknownCall_0xB276
	ret
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, [$AFC7]
	and a
	jr z, UnknownRJump_0x99DE
	ld a, 1
	ld [$AFC8], a
	ld a, 4
	ldh [$FFDF], a
	ret
	ld a, [$AFC8]
	and a
	ret nz

UnknownRJump_0x99DE:
	call UnknownCall_0xB157
	ret

UnknownData_0x99E2:
INCBIN "baserom.gb", $99E2, $9C19 - $99E2


UnknownCall_0x9C19:
	ldh a, [$FFEA]
	ld b, a
	ldh a, [$FFF0]
	and $07
	jr z, UnknownRJump_0x9C2B
	cp b
	ret nz
	ldh a, [$FFDB]
	xor $01
	ldh [$FFDB], a
	ret

UnknownRJump_0x9C2B:
	dec b
	ld a, b
	ldh [$FFEA], a
	ldh a, [$FFDB]
	res 0, a
	ldh [$FFDB], a
	ret
	call UnknownCall_0x9285
	ld a, [$AF3E]
	and a
	jr z, UnknownRJump_0x9C7F

UnknownJump_0x9C3F:
	ldh a, [$FFDB]
	ld [$AF37], a
	ldh a, [$FFDF]
	ld [$AFC4], a
	ldh a, [$FFE2]
	ld [$AFCC], a
	ld b, 1
	ld a, [$AFC3]
	and a
	jr z, UnknownRJump_0x9C67
	ld a, 19
	ld [$A460], a
	inc b
	ld a, 31
	ldh [$FFDB], a
	ld a, [$AFCD]
	ldh [$FFEC], a
	jr UnknownRJump_0x9C6C

UnknownRJump_0x9C67:
UnknownData_0x9C67:
INCBIN "baserom.gb", $9C67, $9C6C - $9C67


UnknownRJump_0x9C6C:
	xor a
	ldh [$FFE2], a
	ldh a, [$FFD8]
	sub b
	ldh [$FFD8], a
	jp z, UnknownJump_0x9435
	jp c, UnknownJump_0x9435
	ld a, 1
	ldh [$FFDF], a
	ret

UnknownRJump_0x9C7F:
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x9CA0
	call UnknownCall_0xB402
	call UnknownCall_0xB14E
	ret nz

UnknownJump_0x9C8B:
	ld a, 32
	ldh [$FFDB], a
	xor a
	ldh [$FFEC], a
	ld a, 3
	ldh [$FFDF], a
	ld a, 69
	ldh [$FFE2], a
	ld a, 4
	ld [$A470], a
	ret

UnknownRJump_0x9CA0:
	dec a
	rst $28

UnknownData_0x9CA2:
INCBIN "baserom.gb", $9CA2, $9CAC - $9CA2

	call UnknownCall_0xB40E
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x9CBA
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz

UnknownRJump_0x9CBA:
	ld a, [$AF26]
	and a
	jp nz, UnknownJump_0x9435
	xor a
	ldh [$FFDE], a
	ld a, [$AF37]
	ldh [$FFDB], a
	ld a, [$AFC4]
	ldh [$FFDF], a
	ld a, [$AFCC]
	ldh [$FFE2], a
	ret
	call UnknownCall_0xB2F6
	jp UnknownJump_0x9443
	ld b, 1
	call UnknownCall_0xB26A

UnknownJump_0x9CDF:
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x9CF6
	call UnknownCall_0xB1EB
	call UnknownCall_0xB270
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 1
	ldh [$FFE8], a
	ret

UnknownRJump_0x9CF6:
	call UnknownCall_0xB18F
	call UnknownCall_0xB276
	ldh a, [$FFD9]
	cp $90
	ret c
	ld a, 144
	ldh [$FFD9], a
	xor a
	ldh [$FFE0], a
	ldh [$FFE8], a
	ld a, 4
	ldh [$FFDF], a
	ld a, 32
	ldh [$FFDD], a
	ret
	call UnknownCall_0xB3D7
	ldh a, [$FFD8]
	srl a
	ld b, a
	ld a, 4
	sub b
	ld b, a
	call UnknownCall_0xB26A
	ldh a, [$FFDA]
	cp $A0
	ret c
	jr UnknownRJump_0x9D3D
	call UnknownCall_0xB3D7
	ldh a, [$FFD8]
	srl a
	ld b, a
	ld a, 4
	sub b
	ld b, a
	call UnknownCall_0xB264
	ldh a, [$FFDA]
	cp $10
	ret nc

UnknownJump_0x9D3D:
UnknownRJump_0x9D3D:
	ldh a, [$FFDF]
	xor $01
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ldh a, [$FFD5]
	ld [$A470], a
	ret
	call UnknownCall_0x9285
	ld a, [$AF3E]
	and a
	jr z, UnknownRJump_0x9D5B
	jp UnknownJump_0x9C3F

UnknownRJump_0x9D5B:
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x9D77
	call UnknownCall_0xB402
	ld a, [$AFC1]
	dec a
	ret nz
	xor a
	ld [$AF26], a
	ldh a, [$FFEC]
	inc a
	ldh [$FFEC], a
	cp $30
	ret nz
	jp UnknownJump_0x9C8B

UnknownRJump_0x9D77:
	dec a
	rst $28

UnknownData_0x9D79:
INCBIN "baserom.gb", $9D79, $9D83 - $9D79

	ld b, 1
	call UnknownCall_0xB264
	ld a, 8
	ldh [$FFEC], a
	jp UnknownJump_0x9CDF
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x9DA2
	ld a, 40
	ldh [$FFDB], a
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 32
	ldh [$FFDB], a

UnknownRJump_0x9DA2:
	ldh a, [$FFD8]
	srl a
	ld b, a
	ld a, 4
	sub b
	ld b, a
	call UnknownCall_0xB264
	ldh a, [$FFDA]
	cp $10
	jr c, UnknownRJump_0x9D3D

UnknownRJump_0x9DB4:
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x9DC1
	call UnknownCall_0xB1EB
	call UnknownCall_0xB270
	jr UnknownRJump_0x9DC7

UnknownRJump_0x9DC1:
	call UnknownCall_0xB187
	call UnknownCall_0xB276

UnknownJump_0x9DC7:
UnknownRJump_0x9DC7:
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFE8]
	xor $01
	ldh [$FFE8], a
	ret nz
	ld a, 8
	ldh [$FFEC], a
	ldh a, [$FFD5]
	ld [$A470], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x9DF2
	ld a, 40
	ldh [$FFDB], a
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 32
	ldh [$FFDB], a

UnknownRJump_0x9DF2:
	ldh a, [$FFD8]
	srl a
	ld b, a
	ld a, 4
	sub b
	ld b, a
	call UnknownCall_0xB26A
	ldh a, [$FFDA]
	cp $A0
	jp nc, UnknownJump_0x9D3D
	jr UnknownRJump_0x9DB4
	call UnknownCall_0x9285
	ld a, [$AF3E]
	and a
	jr z, UnknownRJump_0x9E32
	ldh a, [$FFDB]
	ld [$AF37], a
	ldh a, [$FFDF]
	ld [$AFC4], a
	ldh a, [$FFE2]
	ld [$AFCC], a
	ld a, [$AFC3]
	and a
	jp z, UnknownJump_0x9725
	ld a, 31
	ldh [$FFDB], a
	ld a, [$AFCD]
	ldh [$FFEC], a
	jp UnknownJump_0x9725

UnknownRJump_0x9E32:
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x9E5B
	call UnknownCall_0xB402
	ld a, [$AFC1]
	and a
	ret nz
	xor a
	ld [$AF26], a
	ldh a, [$FFEC]
	inc a
	ldh [$FFEC], a
	cp $30
	ret nz
	ld a, 13
	ld [$AF36], a
	ld a, 14
	ld [$AF37], a
	call UnknownCall_0xB224
	jp UnknownJump_0x9C8B

UnknownRJump_0x9E5B:
	dec a
	rst $28

UnknownData_0x9E5D:
INCBIN "baserom.gb", $9E5D, $9E67 - $9E5D

	ld a, 8
	ldh [$FFEC], a
	jp UnknownJump_0x9CDF
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x9E81
	ld a, 40
	ldh [$FFDB], a
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 41
	ldh [$FFDB], a

UnknownRJump_0x9E81:
	ldh a, [$FFF0]
	and $01
	ret nz
	ld a, [$AFC5]
	srl a
	ld b, a
	ld a, 4
	sub b
	ld b, a
	call UnknownCall_0xB264
	ldh a, [$FFDA]
	cp $10
	jp c, UnknownJump_0x9D3D

UnknownRJump_0x9E9A:
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x9EAA
	call UnknownCall_0xB1EB
	inc b
	inc b
	call UnknownCall_0xB270
	jp UnknownJump_0x9DC7

UnknownRJump_0x9EAA:
	call UnknownCall_0xB187
	inc b
	inc b
	call UnknownCall_0xB276
	jp UnknownJump_0x9DC7
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x9EC8
	ld a, 40
	ldh [$FFDB], a
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 41
	ldh [$FFDB], a

UnknownRJump_0x9EC8:
	ldh a, [$FFF0]
	and $01
	ret nz
	ld a, [$AFC5]
	srl a
	ld b, a
	ld a, 4
	sub b
	ld b, a
	call UnknownCall_0xB26A
	ldh a, [$FFDA]
	cp $A0
	jp nc, UnknownJump_0x9D3D
	jr UnknownRJump_0x9E9A
	ld a, [$AF26]
	cp $02
	ret nz
	ld a, 144
	ldh [$FFD9], a
	ld a, 88
	ldh [$FFDA], a
	jp UnknownJump_0x98F8
	call UnknownCall_0x9285
	ld a, [$AF3E]
	and a
	jr z, UnknownRJump_0x9F1E
	ldh a, [$FFDB]
	ld [$AF37], a
	ldh a, [$FFDF]
	ld [$AFC4], a
	ldh a, [$FFE2]
	ld [$AFCC], a
	ld a, [$AFC3]
	and a
	jp z, UnknownJump_0x9725
	ld a, 48
	ldh [$FFDB], a
	ld a, 104
	ldh [$FFEC], a
	jp UnknownJump_0x9725

UnknownRJump_0x9F1E:
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x9F36
	call UnknownCall_0xB14E
	ret nz
	ld a, 3
	ldh [$FFDF], a
	ld a, 69
	ldh [$FFE2], a
	ld a, 32
	ldh [$FFE8], a
	ldh [$FFE9], a
	ret

UnknownRJump_0x9F36:
	dec a
	rst $28

UnknownData_0x9F38:
INCBIN "baserom.gb", $9F38, $9F46 - $9F38

	ld b, 2
	call UnknownCall_0xB270
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ldh [$FFDC], a
	ld a, 4
	ldh [$FFDF], a
	ldh a, [$FFE9]
	ldh [$FFE8], a
	ld a, 46
	ldh [$FFDB], a
	ld a, 7
	ld [$A470], a
	ret
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 1
	call UnknownCall_0xB270
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ldh_a_n $04
	and $03
	jr nz, UnknownRJump_0x9FF2

UnknownJump_0x9F7C:
	ld a, 44
	ldh [$FFDB], a
	jr UnknownRJump_0x9FDF
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x9F8F
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 44
	ldh [$FFDB], a

UnknownRJump_0x9F8F:
	call UnknownCall_0xB2FD
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDA]
	cp $A0
	jr nc, UnknownRJump_0x9FA4
	ld b, 1
	call UnknownCall_0xB26A
	jr UnknownRJump_0x9FD1

UnknownRJump_0x9FA4:
UnknownData_0x9FA4:
INCBIN "baserom.gb", $9FA4, $9FD1 - $9FA4


UnknownRJump_0x9FD1:
	inc b
	call UnknownCall_0xB276
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ld a, 46
	ldh [$FFDB], a

UnknownRJump_0x9FDF:
	ldh a, [$FFE9]
	ldh [$FFE8], a
	ldh a, [$FFDF]
	xor $01
	ldh [$FFDF], a
	bit 0, a
	ret nz
	ld a, 7
	ld [$A470], a
	ret

UnknownRJump_0x9FF2:
	ld a, [$AFCB]
	and a
	jr z, UnknownRJump_0xA004
	ld a, [$AD4F]
	and a
	jp nz, UnknownJump_0x9F7C
	ld hl, $AD49
	jr UnknownRJump_0xA00E

UnknownRJump_0xA004:
	ld a, [$AD2F]
	and a
	jp nz, UnknownJump_0x9F7C
	ld hl, $AD29

UnknownRJump_0xA00E:
	ldh a, [$FFD9]
	ld [hli], a
	ldh a, [$FFDA]
	ld [hli], a
	ld a, 49
	ld [hl], a
	ld a, [$AFCB]
	xor $01
	ld [$AFCB], a
	ld a, 47
	ldh [$FFDB], a
	ld a, 48
	ldh [$FFEC], a
	jr UnknownRJump_0x9FDF
	ld a, [$AF26]
	cp $02
	jr nz, UnknownRJump_0xA041
	ld a, [$AF29]
	cp $40
	ret nz
	ld a, 112
	ldh [$FFD9], a
	ld a, 88
	ldh [$FFDA], a
	jp UnknownJump_0x98F8

UnknownRJump_0xA041:
	call UnknownCall_0x9285
	ld a, [$AF3E]
	and a
	ret nz
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0xA05C
	ldh a, [$FFDB]
	cp $0E
	ret z
	ld a, 3
	ldh [$FFDF], a
	ld a, 69
	ldh [$FFE2], a
	ret

UnknownRJump_0xA05C:
	dec a
	rst $28

UnknownData_0xA05E:
INCBIN "baserom.gb", $A05E, $A064 - $A05E

	call UnknownCall_0xB1EB
	call UnknownCall_0xB276
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 50
	ldh [$FFDB], a
	call UnknownCall_0xB27C
	ld a, 32
	ldh [$FFE9], a
	ret
	call UnknownCall_0xB2FD
	ldh a, [$FFF0]
	and $03
	ret nz
	ld b, 1
	call UnknownCall_0xB264
	jr UnknownRJump_0xA099

UnknownData_0xA08C:
INCBIN "baserom.gb", $A08C, $A099 - $A08C


UnknownRJump_0xA099:
	ldh a, [$FFDA]
	cp $B8
	jr nc, UnknownRJump_0xA0B1
	call UnknownCall_0xB2C2
	dec a
	jr z, UnknownRJump_0xA0AB
	ld b, 1
	call UnknownCall_0xB270
	ret

UnknownRJump_0xA0AB:
	ld b, 1
	call UnknownCall_0xB276
	ret

UnknownRJump_0xA0B1:
	ld a, 14
	ldh [$FFDB], a
	xor a
	ldh [$FFDF], a
	ret
	call UnknownCall_0x9285
	ld a, [$AF3E]
	and a
	jr z, UnknownRJump_0xA0E8
	ldh a, [$FFDB]
	ld [$AF37], a
	ldh a, [$FFDF]
	ld [$AFC4], a
	ldh a, [$FFE2]
	ld [$AFCC], a
	ld a, [$AFC3]
	and a
	jp z, UnknownJump_0x9725
	ld a, 53
	ldh [$FFDB], a
	xor a
	ldh [$FFE2], a
	ld a, 9
	ldh [$FFDF], a
	ld a, 1
	ldh [$FFEC], a
	ret

UnknownRJump_0xA0E8:
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0xA103
	call UnknownCall_0xB14E
	ret nz
	ld a, 3
	ldh [$FFDF], a
	ld a, 69
	ldh [$FFE2], a
	ld a, 4
	ld [$AFC7], a
	ld a, 1
	ldh [$FFEC], a
	ret

UnknownRJump_0xA103:
	dec a
	rst $28

UnknownData_0xA105:
INCBIN "baserom.gb", $A105, $A117 - $A105

	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 5
	ld [$A470], a
	ld a, 1
	ldh [$FFDF], a
	ld a, [$AFCD]
	ldh [$FFEC], a
	ret
	call UnknownCall_0xB3C0
	jp UnknownJump_0x9443
	ld a, [$AFC7]
	and a
	jr z, UnknownRJump_0xA17D
	call UnknownCall_0xA1B3
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, [$AD2F]
	and a
	jr nz, UnknownRJump_0xA159
	ld hl, $AD29
	ldh a, [$FFD9]
	ld [hli], a
	ldh a, [$FFDA]
	sub 8
	ld [hli], a
	ld a, 59
	ld [hli], a
	inc l
	ldh a, [$FFDD]
	ld [hl], a

UnknownRJump_0xA159:
	ld a, [$AD4F]
	and a
	jr nz, UnknownRJump_0xA171
	ld hl, $AD49
	ldh a, [$FFD9]
	add 16
	ld [hli], a
	ldh a, [$FFDA]
	ld [hli], a
	ld a, 60
	ld [hli], a
	inc l
	ldh a, [$FFDD]
	ld [hl], a

UnknownRJump_0xA171:
	ld a, [$AFC7]
	dec a
	ld [$AFC7], a
	ld a, 96
	ldh [$FFEC], a
	ret

UnknownRJump_0xA17D:
	xor a
	ldh [$FFE8], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 92
	ldh [$FFE0], a
	ret
	ld a, [$AFC7]
	and a
	jr z, UnknownRJump_0xA17D
	call UnknownCall_0xA1B3
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, [$AD2F]
	and a
	jr nz, UnknownRJump_0xA159
	ld hl, $AD29
	ldh a, [$FFD9]
	ld [hli], a
	ldh a, [$FFDA]
	add 8
	ld [hli], a
	ld a, 59
	ld [hli], a
	inc l
	ldh a, [$FFDD]
	ld [hl], a
	jr UnknownRJump_0xA159

UnknownCall_0xA1B3:
	ldh a, [$FFE8]
	and a
	jr z, UnknownRJump_0xA1C0
	call UnknownCall_0xB183
	call UnknownCall_0xB270
	jr UnknownRJump_0xA1C6

UnknownRJump_0xA1C0:
	call UnknownCall_0xB1E4
	call UnknownCall_0xB276

UnknownRJump_0xA1C6:
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFE8]
	xor $01
	ldh [$FFE8], a
	ret
	ld b, 1
	call UnknownCall_0xB276
	ld hl, $5595
	call UnknownCall_0xB16B
	call UnknownCall_0xB264
	ldh a, [$FFE0]
	dec a
	ldh [$FFE0], a
	ret nz
	ld a, 1
	ldh [$FFE0], a
	ld a, 5
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret
	ld b, 1
	call UnknownCall_0xB270
	ld hl, $5595
	call UnknownCall_0xB16B
	call UnknownCall_0xB264
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp $5D
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 6
	ldh [$FFDF], a
	ld a, 48
	ldh [$FFD9], a
	ld a, 32
	ldh [$FFDA], a
	ld a, 80
	ldh [$FFEC], a
	ldh_a_n $04
	and $03
	ld [$AFC7], a
	ret
	ld b, 1
	call UnknownCall_0xB276
	ld hl, $5595
	call UnknownCall_0xB16B
	call UnknownCall_0xB26A
	ldh a, [$FFE0]
	dec a
	ldh [$FFE0], a
	ret nz
	ld a, 1
	ldh [$FFE0], a
	ld a, 8
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret
	ld b, 1
	call UnknownCall_0xB270
	ld hl, $5595
	call UnknownCall_0xB16B
	call UnknownCall_0xB26A
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp $5D
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 3
	ldh [$FFDF], a
	ld a, 80
	ldh [$FFEC], a
	ld a, 48
	ldh [$FFD9], a
	ld a, 144
	ldh [$FFDA], a
	ldh_a_n $04
	and $03
	ld [$AFC7], a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0xA295
	ldh a, [$FFDB]
	cp $0E
	ret z
	ld a, 64
	ldh [$FFE2], a
	call UnknownCall_0x3CB1
	ld a, 9
	ld [$A478], a
	ret

UnknownRJump_0xA295:
	dec a
	rst $28

UnknownData_0xA297:
INCBIN "baserom.gb", $A297, $A29B - $A297

	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 3
	call UnknownCall_0xB264
	jr UnknownRJump_0xA2B1
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 3
	call UnknownCall_0xB26A

UnknownRJump_0xA2B1:
	ldh a, [$FFDA]
	cp $B8
	ret c
	ld a, 14
	ldh [$FFDB], a
	xor a
	ldh [$FFDF], a
	ret
	ld a, [$AF26]
	cp $02
	jr nz, UnknownRJump_0xA2D0
	ld a, 128
	ldh [$FFD9], a
	ld a, 88
	ldh [$FFDA], a
	jp UnknownJump_0x98F8

UnknownRJump_0xA2D0:
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0xA2E3
	ldh a, [$FFDB]
	cp $0E
	ret z
	ld a, 3
	ldh [$FFDF], a
	ld a, 64
	ldh [$FFE2], a
	ret

UnknownRJump_0xA2E3:
	dec a
	rst $28

UnknownData_0xA2E5:
INCBIN "baserom.gb", $A2E5, $A2F1 - $A2E5

	call UnknownCall_0xB18F
	call UnknownCall_0xB276
	ldh a, [$FFD9]
	cp $80
	ret c
	call UnknownCall_0x3CB1
	ret
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 3
	call UnknownCall_0xB264
	jr UnknownRJump_0xA316
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 3
	call UnknownCall_0xB26A

UnknownRJump_0xA316:
	call UnknownCall_0xB2DB
	cp $10
	ret nc
	ld a, 4
	ldh [$FFDF], a
	ret
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	cp $3E
	ret nz
	ld a, 5
	ldh [$FFDF], a
	ld a, 48
	ldh [$FFE8], a
	ret
	call UnknownCall_0xB2FD
	ld b, 2
	call UnknownCall_0xB270
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ld a, 6
	ldh [$FFDF], a
	ld a, 6
	ldh [$FFEC], a
	ld a, 13
	ld [$A470], a
	ret
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDB]
	cp $41
	jr z, UnknownRJump_0xA362
	inc a
	ldh [$FFDB], a
	ret

UnknownRJump_0xA362:
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	xor a
	ldh [$FFDF], a
	ldh [$FFE2], a
	ld a, 14
	ldh [$FFDB], a
	ret
	call UnknownCall_0x9285
	ld a, [$AF3E]
	and a
	jr z, UnknownRJump_0xA39C
	ldh a, [$FFDB]
	ld [$AF37], a
	ldh a, [$FFDF]
	ld [$AFC4], a
	ldh a, [$FFE2]
	ld [$AFCC], a
	ld a, [$AFC3]
	and a
	jp z, UnknownJump_0x9725
	ld a, 74
	ldh [$FFDB], a
	ld a, 48
	ldh [$FFEC], a
	jp UnknownJump_0x9725

UnknownRJump_0xA39C:
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0xA3B6
	call UnknownCall_0xB14E
	ret nz
	ld a, 3
	ldh [$FFDF], a
	ld a, 69
	ldh [$FFE2], a
	ld a, 36
	ldh [$FFE9], a
	ld a, 16
	ldh [$FFDE], a
	ret

UnknownRJump_0xA3B6:
	ldh a, [$FFDF]
	cp $03
	call nc, UnknownCall_0xA3FF
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0xA3C1:
INCBIN "baserom.gb", $A3C1, $A3FF - $A3C1


UnknownCall_0xA3FF:
	ld a, 16
	ldh [$FFDE], a
	call UnknownCall_0xB339
	ldh a, [$FFDC]
	and a
	ret nz
	ldh a, [$FFF0]
	and $01
	ret nz
	ld a, 7
	ld [$A478], a
	ldh_a_n $04
	and $3F
	ret nz
	ld a, 3
	ld [$A470], a
	ret
	call UnknownCall_0xB2FD
	call UnknownCall_0x9443
	ld a, 16
	ldh [$FFDE], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0xA434
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0xA434:
	ld b, 2
	call UnknownCall_0xB264
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	xor a
	ldh [$FFDC], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ret
	ld hl, $6472
	call UnknownCall_0xB16B
	ld a, b
	cp $80
	jr z, UnknownRJump_0xA465
	call UnknownCall_0xB276
	ld hl, $648C
	call UnknownCall_0xB16B
	call UnknownCall_0xB264
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	ret

UnknownRJump_0xA465:
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 76
	ldh [$FFE9], a
	ret

UnknownData_0xA472:
INCBIN "baserom.gb", $A472, $A4A5 - $A472

	ld b, 2
	call UnknownCall_0xB264
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ld a, 6
	ldh [$FFDF], a
	ld a, 69
	ldh [$FFDB], a
	xor a
	ldh [$FFEA], a
	ld a, 68
	ldh [$FFE2], a
	ret
	ld hl, $64EA
	call UnknownCall_0xB16B
	ld a, b
	cp $80
	jr z, UnknownRJump_0xA4DD
	call UnknownCall_0xB270
	ld hl, $64F7
	call UnknownCall_0xB16B
	call UnknownCall_0xB264
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	ret

UnknownRJump_0xA4DD:
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 28
	ldh [$FFE8], a
	ret

UnknownData_0xA4EA:
INCBIN "baserom.gb", $A4EA, $A504 - $A4EA

	ld b, 1
	call UnknownCall_0xB270
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ld a, 8
	ldh [$FFDF], a
	ld a, 66
	ldh [$FFDB], a
	xor a
	ldh [$FFEA], a
	ld a, 36
	ldh [$FFE9], a
	ld b, 4
	call UnknownCall_0xB26A
	ld a, 128
	ldh [$FFDC], a
	ld b, 2
	call UnknownCall_0xB264
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 64
	ldh [$FFEC], a
	ld a, 69
	ldh [$FFE2], a
	ld a, 32
	ldh [$FFDD], a
	ld a, 36
	ldh [$FFE9], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0xA551
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0xA551:
	ld b, 2
	call UnknownCall_0xB26A
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	xor a
	ldh [$FFDC], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ret
	ld hl, $658F
	call UnknownCall_0xB16B
	ld a, b
	cp $80
	jr z, UnknownRJump_0xA582
	call UnknownCall_0xB276
	ld hl, $65A0
	call UnknownCall_0xB16B
	call UnknownCall_0xB26A
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	ret

UnknownRJump_0xA582:
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 80
	ldh [$FFE9], a
	ret

UnknownData_0xA58F:
INCBIN "baserom.gb", $A58F, $A5B0 - $A58F

	ld b, 2
	call UnknownCall_0xB26A
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 69
	ldh [$FFDB], a
	xor a
	ldh [$FFEA], a
	ld a, 68
	ldh [$FFE2], a
	ret
	ld hl, $64EA
	call UnknownCall_0xB16B
	ld a, b
	cp $80
	jr z, UnknownRJump_0xA5E9
	call UnknownCall_0xB270
	ld hl, $64F7
	call UnknownCall_0xB16B
	call UnknownCall_0xB26A
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	ret

UnknownRJump_0xA5E9:
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 68
	ldh [$FFE8], a
	ret
	ld b, 1
	call UnknownCall_0xB270
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ld a, 14
	ldh [$FFDF], a
	ld a, 66
	ldh [$FFDB], a
	xor a
	ldh [$FFEA], a
	ld a, 64
	ldh [$FFDD], a
	ret
	ld hl, $64F7
	call UnknownCall_0xB16B
	ld a, b
	cp $80
	jr z, UnknownRJump_0xA62E
	call UnknownCall_0xB270
	ld hl, $64EA
	call UnknownCall_0xB16B
	call UnknownCall_0xB264
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	ret

UnknownRJump_0xA62E:
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 28
	ldh [$FFE9], a
	ret
	ld b, 2
	call UnknownCall_0xB264
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ld a, 16
	ldh [$FFDF], a
	ld a, 96
	ldh [$FFE8], a
	ld a, 69
	ldh [$FFDB], a
	xor a
	ldh [$FFEA], a
	ld a, 69
	ldh [$FFE2], a
	ret
	ld b, 3
	call UnknownCall_0xB276
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ld a, 17
	ldh [$FFDF], a
	ld a, 28
	ldh [$FFE9], a
	ld a, 32
	ldh [$FFDD], a
	ld a, 66
	ldh [$FFDB], a
	xor a
	ldh [$FFEA], a
	ret
	ld b, 2
	call UnknownCall_0xB26A
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ld a, 18
	ldh [$FFDF], a
	ret
	ld hl, $66B7
	call UnknownCall_0xB16B
	ld a, b
	cp $80
	jr z, UnknownRJump_0xA6A6
	call UnknownCall_0xB270
	ld hl, $66C3
	call UnknownCall_0xB16B
	call UnknownCall_0xB26A
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	ret

UnknownRJump_0xA6A6:
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 36
	ldh [$FFE9], a
	ld a, 128
	ldh [$FFDC], a
	ret

UnknownData_0xA6B7:
INCBIN "baserom.gb", $A6B7, $A6CE - $A6B7

	ld b, 2
	call UnknownCall_0xB26A
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ld a, 20
	ldh [$FFDF], a
	xor a
	ldh [$FFDD], a
	ld a, 64
	ldh [$FFEC], a
	ld a, 36
	ldh [$FFE9], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0xA6F2
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0xA6F2:
	ld b, 2
	call UnknownCall_0xB264
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	xor a
	ldh [$FFDC], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ret
	ld hl, $6730
	call UnknownCall_0xB16B
	ld a, b
	cp $80
	jr z, UnknownRJump_0xA723
	call UnknownCall_0xB276
	ld hl, $673C
	call UnknownCall_0xB16B
	call UnknownCall_0xB264
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	ret

UnknownRJump_0xA723:
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 84
	ldh [$FFE9], a
	ret

UnknownData_0xA730:
INCBIN "baserom.gb", $A730, $A747 - $A730

	ld b, 2
	call UnknownCall_0xB264
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 69
	ldh [$FFDB], a
	xor a
	ldh [$FFEA], a
	ld a, 68
	ldh [$FFE2], a
	ret
	ld hl, $64EA
	call UnknownCall_0xB16B
	ld a, b
	cp $80
	jr z, UnknownRJump_0xA780
	call UnknownCall_0xB270
	ld hl, $64F7
	call UnknownCall_0xB16B
	call UnknownCall_0xB264
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	ret

UnknownRJump_0xA780:
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 68
	ldh [$FFE8], a
	ret
	ld b, 1
	call UnknownCall_0xB270
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 66
	ldh [$FFDB], a
	xor a
	ldh [$FFEA], a
	ld a, 96
	ldh [$FFDD], a
	ret
	ld hl, $64F7
	call UnknownCall_0xB16B
	ld a, b
	cp $80
	jr z, UnknownRJump_0xA7C6
	call UnknownCall_0xB270
	ld hl, $64EA
	call UnknownCall_0xB16B
	call UnknownCall_0xB26A
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	ret

UnknownRJump_0xA7C6:
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 28
	ldh [$FFE9], a
	ret
	ld b, 2
	call UnknownCall_0xB26A
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 69
	ldh [$FFDB], a
	xor a
	ldh [$FFEA], a
	ld a, 64
	ldh [$FFDD], a
	ld a, 69
	ldh [$FFE2], a
	ld a, 96
	ldh [$FFE8], a
	ret
	ld b, 3
	call UnknownCall_0xB276
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ld a, 28
	ldh [$FFDF], a
	ld a, 66
	ldh [$FFDB], a
	xor a
	ldh [$FFEA], a
	ld a, 32
	ldh [$FFDD], a
	ld a, 56
	ldh [$FFE9], a
	ret
	ld b, 2
	call UnknownCall_0xB26A
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 69
	ldh [$FFDB], a
	xor a
	ldh [$FFEA], a
	ld a, 68
	ldh [$FFE2], a
	ld a, 32
	ldh [$FFDD], a
	ld a, 96
	ldh [$FFE8], a
	ret
	ld hl, $64EA
	call UnknownCall_0xB16B
	ld a, b
	cp $80
	jr z, UnknownRJump_0xA857
	call UnknownCall_0xB270
	ld hl, $64F7
	call UnknownCall_0xB16B
	call UnknownCall_0xB26A
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	ret

UnknownRJump_0xA857:
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 60
	ldh [$FFE8], a
	ret
	ld b, 1
	call UnknownCall_0xB270
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ld a, 31
	ldh [$FFDF], a
	ld a, 66
	ldh [$FFDB], a
	xor a
	ldh [$FFEA], a
	ld a, 32
	ldh [$FFDD], a
	ld a, 36
	ldh [$FFE9], a
	ld b, 4
	call UnknownCall_0xB264
	ld a, 128
	ldh [$FFDC], a
	ret
	ld b, 2
	call UnknownCall_0xB26A
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ld a, 3
	ldh [$FFDF], a
	xor a
	ldh [$FFDD], a
	ld a, 69
	ldh [$FFE2], a
	ld a, 36
	ldh [$FFE9], a
	ld a, 64
	ldh [$FFEC], a
	ret
	call UnknownCall_0x9285
	ld a, [$AF3E]
	and a
	jr z, UnknownRJump_0xA8D6
	ldh a, [$FFDB]
	ld [$AF37], a
	ldh a, [$FFDF]
	ld [$AFC4], a
	ldh a, [$FFE2]
	ld [$AFCC], a
	ld a, [$AFC3]
	and a
	jp z, UnknownJump_0x9725
	ld a, 82
	ldh [$FFDB], a
	ld a, [$AFCD]
	ldh [$FFEC], a
	jp UnknownJump_0x9725

UnknownRJump_0xA8D6:
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0xA90A
	ld a, [$A266]
	cp $61
	call z, UnknownCall_0xA8FF
	ld a, [$AFCF]
	and a
	call nz, UnknownCall_0xB2EF
	call UnknownCall_0xB14E
	ret nz
	xor a
	ld [$AFCF], a
	ld a, 3
	ldh [$FFDF], a
	ld a, 65
	ldh [$FFE2], a
	ld a, 79
	ldh [$FFDB], a
	ret

UnknownCall_0xA8FF:
	ld a, 15
	ld [$A470], a
	ld a, 1
	ld [$AFCF], a
	ret

UnknownRJump_0xA90A:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0xA90E:
INCBIN "baserom.gb", $A90E, $A920 - $A90E

	call UnknownCall_0xB40E
	call UnknownCall_0xB18F
	call UnknownCall_0xB276
	ldh a, [$FFD9]
	cp $8A
	ret c
	ld a, 6
	ldh [$FFDF], a
	ld a, 128
	ldh [$FFEC], a
	ret
	call UnknownCall_0xB40E
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	xor a
	ldh [$FFEA], a
	ldh [$FFDE], a
	ld a, 8
	ldh [$FFDF], a
	ld a, 76
	ldh [$FFDB], a
	ld a, 32
	ldh [$FFDD], a
	ret
	ld a, [$AFD0]
	and a
	ret z
	call UnknownCall_0xB321
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 11
	ldh [$FFDF], a
	ld a, 114
	ldh [$FFDB], a
	xor a
	ld [$AFD0], a
	ret
	ld a, 5
	ld [$A266], a
	call UnknownCall_0xB40E
	call UnknownCall_0xB339
	ld b, 2
	call UnknownCall_0xB26A
	ldh a, [$FFDA]
	cp $C0
	ret c
	call UnknownCall_0xB15B
	ld a, 1
	ld [$A2DC], a
	xor a
	ld [$A28B], a
	ld hl, $AB00
	ld a, 255
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, 7
	ld [hli], a
	ld a, 200
	ld [hli], a
	ld a, 0
	ld [hli], a
	ld a, 0
	ld [hli], a
	ld a, 176
	ld [hli], a
	ld a, 29
	ld [hli], a
	ld [hl], 255
	ld a, 171
	ld [$AF1E], a
	ld a, 6
	ld [$AF1F], a
	ld a, 1
	ld [$AF06], a
	ret
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0xA9D4
	call UnknownCall_0xB1E4
	call UnknownCall_0xB270
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 1
	ldh [$FFE8], a
	ret

UnknownRJump_0xA9D4:
	call UnknownCall_0xB17F
	call UnknownCall_0xB276
	ldh a, [$FFD9]
	cp $8A
	ret c
	xor a
	ldh [$FFE0], a
	ldh [$FFE8], a
	ld a, 9
	ldh [$FFDF], a
	ld a, 52
	ld [$A2B3], a
	ld a, 1
	ld [$AFCE], a
	ld a, 24
	ld [$A460], a
	ld a, 48
	ldh [$FFEC], a
	ret

UnknownRJump_0xA9FC:
	ld a, 5
	ldh [$FFDF], a
	ld a, 79
	ldh [$FFDB], a
	ret
	ld a, [sTimerLow]
	and $07
	jr z, UnknownRJump_0xA9FC
	call UnknownCall_0xB339
	ld b, 2
	ldh a, [$FFE9]
	and a
	jr nz, UnknownRJump_0xAA20
	call UnknownCall_0xB264
	ldh a, [$FFDA]
	cp $10
	ret nc
	jr UnknownRJump_0xAA28

UnknownRJump_0xAA20:
	call UnknownCall_0xB26A
	ldh a, [$FFDA]
	cp $98
	ret c

UnknownRJump_0xAA28:
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ldh a, [$FFE9]
	xor $01
	ldh [$FFE9], a
	ld a, 8
	ldh [$FFEC], a
	ret
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0xAA46
	call UnknownCall_0xB1D6
	call UnknownCall_0xB270
	jr UnknownRJump_0xAA4C

UnknownRJump_0xAA46:
	call UnknownCall_0xB18F
	call UnknownCall_0xB276

UnknownRJump_0xAA4C:
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFE8]
	xor $01
	ldh [$FFE8], a
	ret nz
	ld a, 9
	ldh [$FFDF], a
	ld a, 56
	ld [$A2B3], a
	ldh [$FFEC], a
	ld a, 1
	ld [$AFCE], a
	ld a, 24
	ld [$A460], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0xAA79
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0xAA79:
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0xAA86
	call UnknownCall_0xB1E4
	call UnknownCall_0xB270
	jr UnknownRJump_0xAA8C

UnknownRJump_0xAA86:
	call UnknownCall_0xB183
	call UnknownCall_0xB276

UnknownRJump_0xAA8C:
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh [$FFEA], a
	ld a, 76
	ldh [$FFDB], a
	ldh a, [$FFE8]
	xor $01
	ldh [$FFE8], a
	ret nz
	ld a, 4
	ldh [$FFDF], a
	ret
	ldh a, [$FFDF]
	rst $28

UnknownData_0xAAA8:
INCBIN "baserom.gb", $AAA8, $AAB0 - $AAA8

	ld a, 1
	ldh [$FFDF], a
	ret
	call UnknownCall_0xAACA
	ld a, [$AFCE]
	and a
	ret z
	xor a
	ld [$AFCE], a
	ld a, 2
	ldh [$FFDF], a
	ld a, 64
	ldh [$FFE2], a
	ret

UnknownCall_0xAACA:
	ldh a, [$FFF0]
	and $03
	ret nz
	ld b, 3
	ldh a, [$FFE9]
	and a
	jr nz, UnknownRJump_0xAADB
	call UnknownCall_0xB264
	jr UnknownRJump_0xAADE

UnknownRJump_0xAADB:
	call UnknownCall_0xB26A

UnknownRJump_0xAADE:
	ldh a, [$FFDA]
	cp $B0
	ret c
	ldh a, [$FFE9]
	xor $01
	ldh [$FFE9], a
	ret
	call UnknownCall_0xB40E
	call UnknownCall_0xB177
	call UnknownCall_0xB276
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFDE], a
	ldh [$FFE0], a
	ld a, 3
	ldh [$FFDF], a
	ret
	ldh a, [$FFF0]
	and $07
	ret nz
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	cp $63
	ret nz
	ld a, 56
	ldh [$FFD9], a
	ld a, 96
	ldh [$FFDB], a
	xor a
	ldh [$FFE2], a
	ldh [$FFDF], a
	ldh [$FFE9], a
	ldh_a_n $04
	and $01
	jr z, UnknownRJump_0xAB29
	ld a, 167
	ldh [$FFDA], a
	ret

UnknownRJump_0xAB29:
	xor a
	ldh [$FFDA], a
	inc a
	ldh [$FFE9], a
	ret
	ldh a, [$FFDF]
	rst $28

UnknownData_0xAB33:
INCBIN "baserom.gb", $AB33, $AB37 - $AB33

	ld a, 112
	ldh [$FFDB], a
	ld a, [$AD0A]
	ldh [$FFDA], a
	ld a, 16
	ldh [$FFD9], a
	ld a, 1
	ldh [$FFDF], a
	ld a, 16
	ldh [$FFDE], a
	ret
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 1
	call UnknownCall_0xB276
	ld a, [$AD09]
	and $F0
	ld c, a
	ldh a, [$FFD9]
	and $F0
	add 32
	cp c
	ret nz
	ld a, 1
	ld [$AFD0], a
	call UnknownCall_0xB157
	ret
	ldh a, [$FFDF]
	rst $28

UnknownData_0xAB71:
INCBIN "baserom.gb", $AB71, $AB75 - $AB71

	ld a, 113
	ldh [$FFDB], a
	ld a, [$AD0A]
	ldh [$FFDA], a
	ld a, 16
	ldh [$FFD9], a
	ld a, 1
	ldh [$FFDF], a
	ld a, 16
	ldh [$FFDE], a
	ret
	call UnknownCall_0x9285
	ld a, [$AF3E]
	and a
	jr z, UnknownRJump_0xABB6
	ldh a, [$FFDB]
	ld [$AF37], a
	ldh a, [$FFDF]
	ld [$AFC4], a
	ldh a, [$FFE2]
	ld [$AFCC], a
	ld a, [$AFC3]
	and a
	jp z, UnknownJump_0x9725
	ld a, 82
	ldh [$FFDB], a
	ld a, [$AFCD]
	ldh [$FFEC], a
	jp UnknownJump_0x9725

UnknownRJump_0xABB6:
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0xAC00
	ld a, 7
	ldh [$FFDF], a
	ld a, 32
	ldh [$FFEC], a
	ld a, 22
	ld [$AF36], a
	ld a, 14
	ld [$AF37], a
	call UnknownCall_0xB224
	ret
	ld a, [$A266]
	cp $61
	call z, UnknownCall_0xABF5
	ld a, [$AFCF]
	and a
	call nz, UnknownCall_0xB2EF
	call UnknownCall_0xB14E
	ret nz
	xor a
	ld [$AFCF], a
	ld a, 3
	ldh [$FFDF], a
	ld a, 65
	ldh [$FFE2], a
	ld a, 86
	ldh [$FFDB], a
	ret

UnknownCall_0xABF5:
	ld a, 1
	ld [$A470], a
	ld a, 1
	ld [$AFCF], a
	ret

UnknownRJump_0xAC00:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0xAC04:
INCBIN "baserom.gb", $AC04, $AC1A - $AC04

	ld a, 5
	ld [$A266], a
	call UnknownCall_0xB40E
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	xor a
	ldh [$FFEA], a
	ldh [$FFDE], a
	ld a, 8
	ldh [$FFDF], a
	ld a, 83
	ldh [$FFDB], a
	ld a, 32
	ldh [$FFDD], a
	ret
	ld a, [$AFD0]
	and a
	ret z
	call UnknownCall_0xB315
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 11
	ldh [$FFDF], a
	ld a, 116
	ldh [$FFDB], a
	xor a
	ld [$AFD0], a
	ret
	ld a, 5
	ld [$A266], a
	call UnknownCall_0xB339
	call UnknownCall_0xB40E
	ld b, 2
	call UnknownCall_0xB26A
	ldh a, [$FFDA]
	cp $C0
	ret c
	call UnknownCall_0xB15B
	ld a, 2
	ld [$A2DC], a
	xor a
	ld [$A28B], a
	ld a, 171
	ld [$AF1E], a
	ld a, 6
	ld [$AF1F], a
	ld a, 1
	ld [$AF06], a
	ld hl, $AB00
	ld a, 255
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, 8
	ld [hli], a
	ld a, 200
	ld [hli], a
	ld a, 0
	ld [hli], a
	ld a, 0
	ld [hli], a
	ld a, 176
	ld [hli], a
	ld a, [sEasyMode]
	and $01
	jr nz, UnknownRJump_0xACAC
	ld a, 27
	ld [hli], a
	ld [hl], 255
	ret

UnknownRJump_0xACAC:
	ld a, 29
	ld [hli], a
	ld [hl], 255
	ret
	call UnknownCall_0xB1C8
	call UnknownCall_0xB270
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	call UnknownCall_0xB27C
	ldh a, [$FFDF]
	add 3
	ldh [$FFDF], a
	ld a, 2
	ld [$A478], a
	ret
	call UnknownCall_0xB2EF
	ld b, 1
	call UnknownCall_0xB264
	ldh a, [$FFDA]
	cp $20
	jr c, UnknownRJump_0xACDE
	jr UnknownRJump_0xACFE

UnknownRJump_0xACDE:
	ldh a, [$FFDF]
	xor $01
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ld a, 2
	ld [$A478], a
	ret
	call UnknownCall_0xB2EF
	ld b, 1
	call UnknownCall_0xB26A
	ldh a, [$FFDA]
	cp $90
	jr nc, UnknownRJump_0xACDE

UnknownRJump_0xACFE:
	ldh a, [$FFF0]
	and $07
	ret nz
	call UnknownCall_0xB2DB
	cp $20
	jr nc, UnknownRJump_0xAD1E
	ld a, [sTimerLow]
	and $03
	jr nz, UnknownRJump_0xAD1E
	ld a, 10
	ldh [$FFDF], a
	ld a, 86
	ldh [$FFDB], a
	ld a, 32
	ldh [$FFEC], a
	ret

UnknownRJump_0xAD1E:
	ld b, 1
	call UnknownCall_0xB276
	ldh a, [$FFD9]
	cp $8A
	ret c

UnknownJump_0xAD28:
	ld a, 3
	ldh [$FFDF], a
	ld a, 86
	ldh [$FFDB], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0xAD3A
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0xAD3A:
	call UnknownCall_0xB18F
	call UnknownCall_0xB276
	ldh a, [$FFD9]
	cp $8A
	ret c
	xor a
	ldh [$FFE0], a
	ld a, 9
	ldh [$FFDF], a
	ld a, 56
	ld [$A2B3], a
	ld a, 48
	ldh [$FFEC], a
	ld a, 1
	ld [$AFCE], a
	ld a, 24
	ld [$A460], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0xAD69
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0xAD69:
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0xAD76
	call UnknownCall_0xB1E4
	call UnknownCall_0xB270
	jr UnknownRJump_0xAD7C

UnknownRJump_0xAD76:
	call UnknownCall_0xB183
	call UnknownCall_0xB276

UnknownRJump_0xAD7C:
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh [$FFEA], a
	ld a, 83
	ldh [$FFDB], a
	ldh a, [$FFE8]
	xor $01
	ldh [$FFE8], a
	ret nz
	jp UnknownJump_0xAD28
	call UnknownCall_0x9285
	ld a, [$AF3E]
	and a
	jr z, UnknownRJump_0xADBE
	ldh a, [$FFDB]
	ld [$AF37], a
	ldh a, [$FFDF]
	ld [$AFC4], a
	ldh a, [$FFE2]
	ld [$AFCC], a
	ld a, [$AFC3]
	and a
	jp z, UnknownJump_0x9725
	ld a, 82
	ldh [$FFDB], a
	ld a, [$AFCD]
	ldh [$FFEC], a
	jp UnknownJump_0x9725

UnknownRJump_0xADBE:
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0xADF9
	ld a, 12
	ldh [$FFDF], a
	ld a, 32
	ldh [$FFEC], a
	ld a, 25
	ld [$AF36], a
	ld a, 14
	ld [$AF37], a
	call UnknownCall_0xB224
	ret
	ld a, [$A266]
	cp $61
	call z, UnknownCall_0xABF5
	ld a, [$AFCF]
	and a
	call nz, UnknownCall_0xB2EF
	call UnknownCall_0xB14E
	ret nz
	xor a
	ld [$AFCF], a
	ld a, 3
	ldh [$FFDF], a
	ld a, 65
	ldh [$FFE2], a
	ret

UnknownRJump_0xADF9:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0xADFD:
INCBIN "baserom.gb", $ADFD, $AE17 - $ADFD

	ld a, 1
	ld [$A2E3], a
	call UnknownCall_0xB32D
	call UnknownCall_0xB18F
	call UnknownCall_0xB276
	ldh a, [$FFD9]
	cp $8A
	ret c
	ld a, 13
	ldh [$FFDF], a
	ld a, 128
	ldh [$FFEC], a
	ld a, 2
	ldh [$FFE0], a
	ld a, 24
	ld [$A468], a
	ret
	call UnknownCall_0xB32D
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ldh a, [$FFE0]
	dec a
	ldh [$FFE0], a
	ret nz
	ld a, 8
	ldh [$FFDF], a
	ld a, 255
	ldh [$FFEC], a
	ld a, 100
	ldh [$FFDB], a
	ret
	ld a, 5
	ld [$A266], a
	call UnknownCall_0xB2E8
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	jr z, UnknownRJump_0xAE6F
	cp $20
	ret nc
	ld a, 99
	ldh [$FFDB], a
	ret

UnknownRJump_0xAE6F:
	ld a, 48
	ldh [$FFEC], a
	call UnknownCall_0xB27C
	ld a, 9
	ldh [$FFDF], a
	ld a, 99
	ldh [$FFDB], a
	ld a, 28
	ld [$AF36], a
	ld a, 108
	ld [$AF37], a
	ldh a, [$FFDD]
	ld [$AF38], a
	call UnknownCall_0xB224
	ret
	ld a, 5
	ld [$A266], a
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 10
	ldh [$FFDF], a
	ld a, 102
	ldh [$FFDB], a
	xor a
	ldh [$FFDD], a
	ldh [$FFEA], a
	ld a, 48
	ldh [$FFEC], a
	ret
	ld a, 5
	ld [$A266], a
	call UnknownCall_0xB35A
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0xAEBF
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0xAEBF:
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 3
	call UnknownCall_0xB26A
	ldh a, [$FFDA]
	cp $C0
	ret c
	call UnknownCall_0xB15B
	ld a, 3
	ld [$A2DC], a
	xor a
	ld [$A28B], a
	ret
	xor a
	ldh [$FFEA], a
	ld a, 92
	ldh [$FFDB], a
	call UnknownCall_0xB27C
	ldh a, [$FFDF]
	add 3
	ldh [$FFDF], a
	ld a, 27
	ld [$AF36], a
	ld a, 14
	ld [$AF37], a
	ldh a, [$FFDD]
	ld [$AF38], a
	call UnknownCall_0xB224
	ld a, 8
	ld [$A478], a
	ld a, 80
	ldh [$FFEC], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0xAF15
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 88
	ldh [$FFDB], a
	ret

UnknownRJump_0xAF15:
	call UnknownCall_0xB339
	ld b, 2
	call UnknownCall_0xB264
	ldh a, [$FFDA]
	cp $18
	jr c, UnknownRJump_0xAF25
	jr UnknownRJump_0xAF4E

UnknownRJump_0xAF25:
	ldh a, [$FFDF]
	xor $01
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0xAF40
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 88
	ldh [$FFDB], a
	ret

UnknownRJump_0xAF40:
	call UnknownCall_0xB339
	ld b, 2
	call UnknownCall_0xB26A
	ldh a, [$FFDA]
	cp $98
	jr nc, UnknownRJump_0xAF25

UnknownRJump_0xAF4E:
	call UnknownCall_0xB2DB
	cp $30
	jr c, UnknownRJump_0xAF66
	ld a, [sTimerLow]
	and $03
	ret nz
	ld a, [$AD2B]
	cp $0E
	ret nc
	ld a, 3
	ldh [$FFDF], a
	ret

UnknownRJump_0xAF66:
	ldh a, [$FFDF]
	add 2
	ldh [$FFDF], a
	ld a, 91
	ldh [$FFDB], a
	ld a, [sCurPowerup]
	sub 2
	ld [$AFD1], a
	ret
	ld b, 1
	call UnknownCall_0xB264
	ldh a, [$FFDA]
	cp $18
	jr c, UnknownRJump_0xAF25
	jr UnknownRJump_0xAF91
	ld b, 1
	call UnknownCall_0xB26A
	ldh a, [$FFDA]
	cp $98
	jr nc, UnknownRJump_0xAF25

UnknownRJump_0xAF91:
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0xAFA9
	ld a, [$AFD1]
	and a
	jr z, UnknownRJump_0xAFA1
	call UnknownCall_0xB1EB
	jr UnknownRJump_0xAFA4

UnknownRJump_0xAFA1:
	call UnknownCall_0xB1CF

UnknownRJump_0xAFA4:
	call UnknownCall_0xB270
	jr UnknownRJump_0xAFBA

UnknownRJump_0xAFA9:
	ld a, [$AFD1]
	and a
	jr z, UnknownRJump_0xAFB4
	call UnknownCall_0xB187
	jr UnknownRJump_0xAFB7

UnknownRJump_0xAFB4:
	call UnknownCall_0xB17B

UnknownRJump_0xAFB7:
	call UnknownCall_0xB276

UnknownRJump_0xAFBA:
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFE8]
	xor $01
	ldh [$FFE8], a
	ret nz
	ldh a, [$FFDF]
	sub 2
	ldh [$FFDF], a
	ld a, 88
	ldh [$FFDB], a
	xor a
	ldh [$FFEA], a
	ld a, [$AD2B]
	cp $0E
	ret nc
	ld a, 3
	ldh [$FFDF], a
	ret
	call UnknownCall_0xB3B9
	ldh a, [$FFDF]
	rst $28

UnknownData_0xAFE6:
INCBIN "baserom.gb", $AFE6, $AFEC - $AFE6

	ld a, 64
	ldh [$FFE2], a
	call UnknownCall_0x3CB1
	ld a, 104
	ldh [$FFDB], a
	xor a
	ldh [$FFEA], a
	ld b, 16
	call UnknownCall_0xB270
	ret
	ld hl, $7039
	call UnknownCall_0xB16B
	ld a, b
	cp $80
	jr z, UnknownRJump_0xB010
	call UnknownCall_0xB264
	jr UnknownRJump_0xB023

UnknownRJump_0xB010:
	ld a, 58
	ldh [$FFE0], a
	ret
	ld hl, $7039
	call UnknownCall_0xB16B
	ld a, b
	cp $80
	jr z, UnknownRJump_0xB010
	call UnknownCall_0xB26A

UnknownRJump_0xB023:
	ldh a, [$FFDA]
	cp $B0
	jp nc, UnknownJump_0xB157
	ld hl, $707E
	call UnknownCall_0xB16B
	call UnknownCall_0xB276
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	ret

UnknownData_0xB039:
INCBIN "baserom.gb", $B039, $B0C2 - $B039

	ldh a, [$FFDF]
	rst $28

UnknownData_0xB0C5:
INCBIN "baserom.gb", $B0C5, $B0CF - $B0C5

	call UnknownCall_0x3CB1
	ret
	ld b, 2
	call UnknownCall_0xB264
	jr UnknownRJump_0xB0DF
	ld b, 2
	call UnknownCall_0xB26A

UnknownRJump_0xB0DF:
	call UnknownCall_0xB3C0
	ldh a, [$FFF0]
	and $03
	ret nz
	call UnknownCall_0xB2DB
	cp $08
	jr c, UnknownRJump_0xB10F
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0xB0FB
	call UnknownCall_0xB1EB
	call UnknownCall_0xB270
	jr UnknownRJump_0xB101

UnknownRJump_0xB0FB:
UnknownData_0xB0FB:
INCBIN "baserom.gb", $B0FB, $B101 - $B0FB


UnknownRJump_0xB101:
	ldh a, [$FFE0]
	cp c
	ret nz

UnknownData_0xB105:
INCBIN "baserom.gb", $B105, $B10F - $B105


UnknownRJump_0xB10F:
	ld a, 3
	ldh [$FFDF], a
	xor a
	ldh [$FFE0], a
	ldh [$FFE8], a
	ld a, 6
	ld [$A460], a
	ret
	call UnknownCall_0xB3C0
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0xB138
	call UnknownCall_0xB1E4
	call UnknownCall_0xB270
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 1
	ldh [$FFE8], a
	ret

UnknownRJump_0xB138:
	ldh a, [$FFD9]
	cp $90
	jr nc, UnknownRJump_0xB145
	call UnknownCall_0xB18F
	call UnknownCall_0xB276
	ret

UnknownRJump_0xB145:
	ld a, 108
	ldh [$FFDB], a
	ld a, 4
	ldh [$FFDF], a
	ret

UnknownCall_0xB14E:
	ld a, [$A266]
	ld b, a
	ld a, [$A267]
	or b
	ret

UnknownJump_0xB157:
UnknownCall_0xB157:
	ld hl, $AFC1
	dec [hl]

UnknownCall_0xB15B:
	ld hl, $FFD0
	xor a
	ld b, 32

UnknownRJump_0xB161:
	ld [hli], a
	dec b
	jr nz, UnknownRJump_0xB161
	ld a, 1
	ld [$AF3E], a
	ret

UnknownCall_0xB16B:
	ldh a, [$FFE0]
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	ret

UnknownData_0xB173:
INCBIN "baserom.gb", $B173, $B177 - $B173


UnknownCall_0xB177:
	ld c, 36
	jr UnknownRJump_0xB191

UnknownCall_0xB17B:
	ld c, 27
	jr UnknownRJump_0xB191

UnknownCall_0xB17F:
	ld c, 24
	jr UnknownRJump_0xB191

UnknownCall_0xB183:
	ld c, 12
	jr UnknownRJump_0xB191

UnknownCall_0xB187:
	ld c, 15
	jr UnknownRJump_0xB191

UnknownData_0xB18B:
INCBIN "baserom.gb", $B18B, $B18F - $B18B


UnknownCall_0xB18F:
	ld c, 21

UnknownRJump_0xB191:
	ld hl, $71A3
	ldh a, [$FFE0]
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	ld hl, $FFE0
	ld a, [hl]
	cp c
	ret z
	inc [hl]
	ret

UnknownData_0xB1A3:
INCBIN "baserom.gb", $B1A3, $B1C8 - $B1A3


UnknownCall_0xB1C8:
	ld c, 36
	ld hl, $71FF
	jr UnknownRJump_0xB1F0

UnknownCall_0xB1CF:
	ld c, 27
	ld hl, $7208
	jr UnknownRJump_0xB1F0

UnknownCall_0xB1D6:
	ld c, 21
	ld hl, $720E
	jr UnknownRJump_0xB1F0

UnknownData_0xB1DD:
INCBIN "baserom.gb", $B1DD, $B1E4 - $B1DD


UnknownCall_0xB1E4:
	ld c, 12
	ld hl, $7217
	jr UnknownRJump_0xB1F0

UnknownCall_0xB1EB:
	ld c, 15
	ld hl, $7214

UnknownRJump_0xB1F0:
	ldh a, [$FFE0]
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	ld hl, $FFE0
	ld a, [hl]
	cp c
	ret z
	inc [hl]
	ret

UnknownData_0xB1FF:
INCBIN "baserom.gb", $B1FF, $B224 - $B1FF


UnknownCall_0xB224:
	ld a, [$AFC1]
	inc a
	cp $10
	jr z, UnknownRJump_0xB259
	ld hl, $AD05
	ld de, $0020

UnknownRJump_0xB232:
	add hl, de
	dec a
	jr nz, UnknownRJump_0xB232
	ld d, h
	ld e, l
	ld a, [$AF36]
	ld [de], a
	inc e
	ld hl, $FFD6
	ld b, 5
	call UnknownCall_0x3CAA
	ld h, d
	ld l, e
	ld a, [$AF37]
	ld [hli], a
	inc l
	ld a, [$AF38]
	ld [hl], a
	ld a, l
	add 6
	ld e, a
	ld d, h
	ld hl, $AFC1
	inc [hl]

UnknownRJump_0xB259:
	xor a
	ld [$AF36], a
	ld [$AF37], a
	ld [$AF38], a
	ret

UnknownCall_0xB264:
	ldh a, [$FFDA]
	sub b
	ldh [$FFDA], a
	ret

UnknownCall_0xB26A:
	ldh a, [$FFDA]
	add b
	ldh [$FFDA], a
	ret

UnknownCall_0xB270:
	ldh a, [$FFD9]
	sub b
	ldh [$FFD9], a
	ret

UnknownCall_0xB276:
	ldh a, [$FFD9]
	add b
	ldh [$FFD9], a
	ret

UnknownCall_0xB27C:
	call UnknownCall_0xB296
	ld a, [$AF2C]
	dec a
	jr z, UnknownRJump_0xB28D
	ld a, 1
	ldh [$FFDF], a
	xor a
	ldh [$FFDD], a
	ret

UnknownRJump_0xB28D:
	ld a, 2
	ldh [$FFDF], a
	ld a, 32
	ldh [$FFDD], a
	ret

UnknownCall_0xB296:
	xor a
	ld [$AF2C], a
	ldh a, [$FFDA]
	ld b, a
	ld a, [sMarioScreenX]
	cp b
	jr c, UnknownRJump_0xB2A9
	ld a, 1
	ld [$AF2C], a
	ret

UnknownRJump_0xB2A9:
	ld a, 255
	ld [$AF2C], a
	ret

UnknownData_0xB2AF:
INCBIN "baserom.gb", $B2AF, $B2C2 - $B2AF


UnknownCall_0xB2C2:
	xor a
	ld [$AF2C], a
	ldh a, [$FFD9]
	ld b, a
	ld a, [sMarioScreenY]
	cp b
	jr c, UnknownRJump_0xB2D5
	ld a, 1
	ld [$AF2C], a
	ret

UnknownRJump_0xB2D5:
	ld a, 255
	ld [$AF2C], a
	ret

UnknownCall_0xB2DB:
	ld hl, $FFDA
	ld a, [sMarioScreenX]
	sub [hl]
	bit 7, a
	ret z
	cpl
	inc a
	ret

UnknownCall_0xB2E8:
	ldh a, [$FFF0]
	and $0F
	ret nz
	jr UnknownRJump_0xB302

UnknownCall_0xB2EF:
	ldh a, [$FFF0]
	and $07
	ret nz
	jr UnknownRJump_0xB302

UnknownCall_0xB2F6:
	ldh a, [$FFF0]
	and $01
	ret nz
	jr UnknownRJump_0xB302

UnknownCall_0xB2FD:
	ldh a, [$FFF0]
	and $03
	ret nz

UnknownRJump_0xB302:
	ldh a, [$FFDB]
	xor $01
	ldh [$FFDB], a
	ret

UnknownCall_0xB309:
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDB]
	xor $06
	ldh [$FFDB], a
	ret

UnknownCall_0xB315:
	ldh a, [$FFF0]
	and $07
	ret nz
	ldh a, [$FFDB]
	xor $0B
	ldh [$FFDB], a
	ret

UnknownCall_0xB321:
	ldh a, [$FFF0]
	and $07
	ret nz
	ldh a, [$FFDB]
	xor $1F
	ldh [$FFDB], a
	ret

UnknownCall_0xB32D:
	ldh a, [$FFF0]
	and $07
	ret nz
	ldh a, [$FFDB]
	xor $31
	ldh [$FFDB], a
	ret

UnknownCall_0xB339:
	ldh a, [$FFF0]
	and $03
	ret nz
	ld hl, $FFEA
	inc [hl]
	ld a, [hl]
	cp $04
	jr nz, UnknownRJump_0xB349
	xor a
	ld [hl], a

UnknownRJump_0xB349:
	ld hl, $7356
	ld e, a
	ld d, 0
	add hl, de
	ldh a, [$FFDB]
	add [hl]
	ldh [$FFDB], a
	ret

UnknownData_0xB356:
INCBIN "baserom.gb", $B356, $B35A - $B356


UnknownCall_0xB35A:
	ldh a, [$FFF0]
	and $03
	ret nz
	ld hl, $FFEA
	inc [hl]
	ld a, [hl]
	cp $04
	jr nz, UnknownRJump_0xB370
	xor a
	ld [hl], a
	ldh a, [$FFDD]
	res 5, a
	ldh [$FFDD], a

UnknownRJump_0xB370:
	ld hl, $7388
	ld e, a
	ld d, 0
	add hl, de
	ldh a, [$FFDB]
	add [hl]
	ldh [$FFDB], a
	ldh a, [$FFEA]
	cp $03
	ret nz
	ldh a, [$FFDD]
	set 5, a
	ldh [$FFDD], a
	ret

UnknownData_0xB388:
INCBIN "baserom.gb", $B388, $B38C - $B388


UnknownCall_0xB38C:
	ldh a, [$FFF0]
	and $01
	ret nz
	ld hl, $FFEA
	inc [hl]
	ld a, [hl]
	ld e, a
	cp $03
	jr z, UnknownRJump_0xB3A2
	cp $05
	jr nz, UnknownRJump_0xB3A8
	xor a
	ld [hl], a
	ld e, a

UnknownRJump_0xB3A2:
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a

UnknownRJump_0xB3A8:
	ld hl, $73B4
	ld d, 0
	add hl, de
	ldh a, [$FFDB]
	add [hl]
	ldh [$FFDB], a
	ret

UnknownData_0xB3B4:
INCBIN "baserom.gb", $B3B4, $B3B9 - $B3B4


UnknownCall_0xB3B9:
	ldh a, [$FFF0]
	and $01
	ret nz
	jr UnknownRJump_0xB3C5

UnknownCall_0xB3C0:
	ldh a, [$FFF0]
	and $03
	ret nz

UnknownRJump_0xB3C5:
	ld hl, $FFEA
	inc [hl]
	ld a, [hl]
	cp $04
	jr nz, UnknownRJump_0xB3EE
	xor a
	ld [hl], a
	ldh a, [$FFDB]
	sub 3
	ldh [$FFDB], a
	ret

UnknownCall_0xB3D7:
	ldh a, [$FFF0]
	and $03
	ret nz
	ld hl, $FFEA
	inc [hl]
	ld a, [hl]
	cp $08
	jr nz, UnknownRJump_0xB3EE
	xor a
	ld [hl], a
	ldh a, [$FFDB]
	sub 7
	ldh [$FFDB], a
	ret

UnknownRJump_0xB3EE:
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	ret

UnknownCall_0xB3F4:
	ldh a, [$FFF0]
	and $03
	ret nz
	jr UnknownRJump_0xB407

UnknownData_0xB3FB:
INCBIN "baserom.gb", $B3FB, $B402 - $B3FB


UnknownCall_0xB402:
	ldh a, [$FFF0]
	and $0F
	ret nz

UnknownRJump_0xB407:
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret

UnknownCall_0xB40E:
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDE]
	xor $10
	ldh [$FFDE], a
	ret

UnknownData_0xB41A:
INCBIN "baserom.gb", $B41A, $C000 - $B41A



SECTION "bank03", ROMX, BANK[$03]


UnknownCall_0xC000:
	ldh a, [$FFD8]
	cp $02
	ret nz
	call UnknownCall_0xC090
	ld hl, $4F11
	ld a, [$AF06]
	and a
	jr nz, UnknownRJump_0xC014
	ld hl, $40B1

UnknownRJump_0xC014:
	ld a, [$AF3E]
	and a
	ret nz
	ldh a, [$FFE2]
	cp $80
	ret z
	ldh a, [$FFD9]
	cp $B8
	ret nc
	ldh a, [$FFDA]
	cp $B8
	ret nc
	ldh a, [$FFDB]
	ld d, 0
	ld e, a
	sla e
	rl d
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld h, 161
	ldh_a_n $8D
	ld l, a
	ldh a, [$FFD9]
	ld b, a
	ldh a, [$FFDA]
	ld c, a

UnknownRJump_0xC042:
	ld a, [de]
	cp $80
	ret z
	ld a, [$AF2B]
	bit 6, a
	jr z, UnknownRJump_0xC053
	ld a, [de]
	cpl
	sub 7
	jr UnknownRJump_0xC054

UnknownRJump_0xC053:
	ld a, [de]

UnknownRJump_0xC054:
	add b
	cp $A0
	jr nc, UnknownRJump_0xC068
	ld [hli], a
	inc de
	ld a, [$AF2B]
	bit 5, a
	jr z, UnknownRJump_0xC076
	ld a, [de]
	cpl
	sub 7
	jr UnknownRJump_0xC077

UnknownRJump_0xC068:
	inc de
	inc de
	inc de
	inc de
	jr UnknownRJump_0xC042

UnknownRJump_0xC06E:
	dec l
	ld [hl], 0
	inc de
	inc de
	inc de
	jr UnknownRJump_0xC042

UnknownRJump_0xC076:
	ld a, [de]

UnknownRJump_0xC077:
	add c
	cp $A8
	jr nc, UnknownRJump_0xC06E
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	push hl
	ld hl, $AF2B
	ld a, [de]
	xor [hl]
	pop hl
	ld [hli], a
	ld a, l
	ldh_n_a $8D
	inc de
	jr UnknownRJump_0xC042

UnknownCall_0xC090:
	ld a, [sScrollY]
	ld b, a
	ldh a, [$FFD4]
	add 16
	sub b
	ldh [$FFD9], a
	ld a, [sScrollX]
	ld b, a
	ldh a, [$FFD1]
	add 8
	sub b
	ldh [$FFDA], a
	ld hl, $FFDC
	ld a, [hli]
	xor [hl]
	inc l
	xor [hl]
	ld [$AF2B], a
	ret

UnknownData_0xC0B1:
INCBIN "baserom.gb", $C0B1, $C201 - $C0B1

INCLUDE "gfx/spritemappings2.asm"

INCBIN "baserom.gb", $CF11, $D0D9 - $CF11

INCLUDE "gfx/spritemappings3.asm"

INCBIN "baserom.gb", $E037, $EBB6 - $E037

UnknownRJump_0xEBB6:
	ld a, 255
	ld [hli], a
	ld [hl], a
	ret

UnknownCall_0xEBBB:
	call UnknownCall_0xEC40
	call UnknownCall_0xEC17
	call UnknownCall_0xEC31
	call UnknownCall_0xEC4B
	ld a, [sCurLevel]
	add a
	ld e, a
	ld d, 0
	ld hl, $6037
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, $AB06

UnknownRJump_0xEBD8:
	ld a, [de]
	cp $FF
	jr z, UnknownRJump_0xEBB6
	ld b, a
	and $0F
	ld [hli], a
	inc de
	ld a, [de]
	ld c, a
	and $1F
	rlca
	rlca
	rlca
	ld [hli], a
	inc de
	ld a, [de]
	rlca
	rl [hl]
	inc hl
	rlca
	rl [hl]
	rlca
	rl [hl]
	inc hl
	ld a, [de]
	and $1F
	rlca
	rlca
	rlca
	ld [hli], a
	ld a, b
	rrca
	rrca
	and $3C
	bit 2, a
	jr z, UnknownRJump_0xEC0B
	set 6, a
	res 2, a

UnknownRJump_0xEC0B:
	ld b, a
	ld a, c
	rrca
	swap a
	and $07
	add b
	ld [hli], a
	inc de
	jr UnknownRJump_0xEBD8

UnknownCall_0xEC17:
	ld hl, $AB00
	ld bc, $0200
	xor a

UnknownRJump_0xEC1E:
	ld [hli], a
	dec c
	jr nz, UnknownRJump_0xEC1E
	dec b
	jr nz, UnknownRJump_0xEC1E
	ld hl, $AB00
	ld a, 255
	ld b, 6

UnknownRJump_0xEC2C:
	ld [hli], a
	dec b
	jr nz, UnknownRJump_0xEC2C
	ret

UnknownCall_0xEC31:
	ld hl, $AD00
	ld bc, $0200
	xor a

UnknownRJump_0xEC38:
	ld [hli], a
	dec c
	jr nz, UnknownRJump_0xEC38
	dec b
	jr nz, UnknownRJump_0xEC38
	ret

UnknownCall_0xEC40:
	ld hl, $AF00
	ld b, 0
	xor a

UnknownRJump_0xEC46:
	ld [hli], a
	dec b
	jr nz, UnknownRJump_0xEC46
	ret

UnknownCall_0xEC4B:
	ld a, 171
	ld [$AF1E], a
	ld a, 6
	ld [$AF1F], a
	ld a, [sCurLevel]
	cp $0A
	ret c
	ld a, 1
	ld [$AF06], a
	ret

UnknownData_0xEC61:
INCBIN "baserom.gb", $EC61, $FFA0 - $EC61


UnknownCall_0xFFA0:
UnknownData_0xFFA0:
INCBIN "baserom.gb", $FFA0, $10000 - $FFA0



SECTION "bank04", ROMX, BANK[$04]


UnknownCall_0x10000:
	ld hl, $A400

UnknownRJump_0x10003:
	ld [hl], 0
	inc l
	jr nz, UnknownRJump_0x10003
	ld hl, $A500

UnknownRJump_0x1000B:
	ld [hl], 0
	inc l
	jr nz, UnknownRJump_0x1000B
	ld a, 128
	ldh [rAUDENA], a
	ld a, 119
	ldh [rAUDVOL], a
	ld a, 255
	ldh [rAUDTERM], a
	ret

UnknownData_0x1001D:
INCBIN "baserom.gb", $1001D, $1002D - $1001D


UnknownCall_0x1002D:
	jp UnknownJump_0x13F5E

_UpdateSound: ;$10030
	ld a, [$A45E]
	cp $01
	jp z, UnknownJump_0x118F7
	cp $02
	jp z, UnknownJump_0x11926
	ld a, [$A45D]
	and a
	jp nz, UnknownJump_0x11936

UnknownJump_0x10044:
	ld hl, $A468
	ld a, [hli]
	and a
	jr nz, UnknownRJump_0x10078
	ld a, [$A53F]
	and a
	jr z, UnknownRJump_0x10057
	ld a, 51
	ldh [rAUDVOL], a
	jr UnknownRJump_0x1005B

UnknownRJump_0x10057:
	ld a, 119
	ldh [rAUDVOL], a

UnknownRJump_0x1005B:
	call UnknownCall_0x100DE
	call UnknownCall_0x106D3
	call UnknownCall_0x10E90

UnknownRJump_0x10064:
	call UnknownCall_0x11638

UnknownJump_0x10067:
	xor a
	ld [$A460], a
	ld [$A468], a
	ld [$A470], a
	ld [$A478], a
	ld [$A45E], a
	ret

UnknownRJump_0x10078:
	ld [hl], a
	call UnknownCall_0x112E0
	jr UnknownRJump_0x10064

UnknownData_0x1007E:
INCBIN "baserom.gb", $1007E, $100DE - $1007E


UnknownCall_0x100DE:
	ld hl, $A460
	ld a, [hl]
	and a
	jr z, UnknownRJump_0x10116
	cp $09
	jr z, UnknownRJump_0x10110
	cp $0C
	jr z, UnknownRJump_0x10110
	cp $0F
	jr z, UnknownRJump_0x10110
	cp $10
	jr z, UnknownRJump_0x10110
	cp $11
	jr z, UnknownRJump_0x10110
	cp $13
	jr z, UnknownRJump_0x10110
	cp $14
	jr z, UnknownRJump_0x10110
	cp $17
	jr z, UnknownRJump_0x10110
	ld a, [$A520]
	and a
	jr nz, UnknownRJump_0x10110
	ld a, [$A536]
	and a
	ret nz

UnknownRJump_0x10110:
	ld a, [hl]
	ld hl, $407E
	jr UnknownRJump_0x1011D

UnknownRJump_0x10116:
	inc hl
	ld a, [hl]
	and a
	ret z
	ld hl, $40AE

UnknownRJump_0x1011D:
	call UnknownCall_0x111A6
	ld de, $A500
	ld bc, $A504
	jp hl
	ld hl, $4134
	jp UnknownJump_0x1068A
	call UnknownCall_0x111B3
	ret nz
	jp UnknownJump_0x106A8

UnknownData_0x10134:
INCBIN "baserom.gb", $10134, $1013A - $10134

	ld hl, $4152
	jp UnknownJump_0x1068A
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $02
	jp z, UnknownJump_0x106A8
	ld hl, $4158
	jp UnknownJump_0x111BB

UnknownData_0x10152:
INCBIN "baserom.gb", $10152, $1015E - $10152

	ld a, [$A461]
	cp $03
	ret z
	ld hl, $417C
	jp UnknownJump_0x1068A
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $02
	jp z, UnknownJump_0x106A8
	ld hl, $4182
	jp UnknownJump_0x111BB

UnknownData_0x1017C:
INCBIN "baserom.gb", $1017C, $10188 - $1017C

	ld a, 5
	ld [$A52D], a
	ld hl, $41A3
	jp UnknownJump_0x1068A
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111DC
	jp z, UnknownJump_0x106A8
	ld hl, $41A3
	jp UnknownJump_0x111BB

UnknownData_0x101A3:
INCBIN "baserom.gb", $101A3, $101A9 - $101A3

	ld a, 2
	ld [$A52D], a
	ld hl, $46C6
	jp UnknownJump_0x10685
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $05
	jr z, UnknownRJump_0x101C8

UnknownRJump_0x101BF:
	ld hl, $41D3
	call UnknownCall_0x111A6
	jp UnknownJump_0x111BB

UnknownRJump_0x101C8:
	call UnknownCall_0x111DC
	jp z, UnknownJump_0x106A8
	ld a, 1
	ld [bc], a
	jr UnknownRJump_0x101BF

UnknownData_0x101D3:
INCBIN "baserom.gb", $101D3, $101F3 - $101D3

	ld hl, $420B
	jp UnknownJump_0x1068A
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $02
	jp z, UnknownJump_0x106A8
	ld hl, $4211
	jp UnknownJump_0x111BB

UnknownData_0x1020B:
INCBIN "baserom.gb", $1020B, $10217 - $1020B

	ld hl, $422F
	jp UnknownJump_0x1068A
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $02
	jp z, UnknownJump_0x106A8
	ld hl, $4235
	jp UnknownJump_0x106CC

UnknownData_0x1022F:
INCBIN "baserom.gb", $1022F, $10238 - $1022F

	ld hl, $4259
	jp UnknownJump_0x10685
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $04
	jp z, UnknownJump_0x106A8
	ld hl, $4253
	call UnknownCall_0x111A6
	jp UnknownJump_0x111BB

UnknownData_0x10253:
INCBIN "baserom.gb", $10253, $10271 - $10253

	ld a, 3
	ld [$A52D], a
	ld hl, $42AA
	call UnknownCall_0x111F9
	jp UnknownJump_0x10685
	call UnknownCall_0x111B3
	ret nz
	ld a, 5
	ld [de], a
	call UnknownCall_0x111B7
	cp $07
	jr z, UnknownRJump_0x10293

UnknownRJump_0x1028D:
	ld hl, $429E
	jp UnknownJump_0x11214

UnknownRJump_0x10293:
	call UnknownCall_0x111DC
	jp z, UnknownJump_0x106A8
	ld a, 1
	ld [bc], a
	jr UnknownRJump_0x1028D

UnknownData_0x1029E:
INCBIN "baserom.gb", $1029E, $102B2 - $1029E

	ld hl, $42D3
	jp UnknownJump_0x1068A
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $04
	jp z, UnknownJump_0x106A2
	ld hl, $42CD
	call UnknownCall_0x111A6
	jp UnknownJump_0x106CC

UnknownData_0x102CD:
INCBIN "baserom.gb", $102CD, $102E2 - $102CD

	call UnknownCall_0x13F5E
	ld a, 6
	ld [$A52D], a
	ld hl, $4343
	jp UnknownJump_0x10685
	call UnknownCall_0x111B3
	ret nz
	ld a, [$A535]
	inc a
	ld [$A535], a
	cp $03
	jr z, UnknownRJump_0x10321

UnknownRJump_0x102FF:
	ld hl, $433F
	call UnknownCall_0x111A6
	ld a, [$A535]
	cp $01
	jr z, UnknownRJump_0x1032E
	call UnknownCall_0x111BB

UnknownRJump_0x1030F:
	ld bc, $A504
	call UnknownCall_0x111B7
	dec a
	ld c, a
	ld b, 0
	ld hl, $4333
	add hl, bc
	ld a, [hl]
	jp UnknownJump_0x111DA

UnknownRJump_0x10321:
	call UnknownCall_0x111DC
	jp z, UnknownJump_0x106A8
	ld a, 1
	ld [$A535], a
	jr UnknownRJump_0x102FF

UnknownRJump_0x1032E:
	call UnknownCall_0x111C1
	jr UnknownRJump_0x1030F

UnknownData_0x10333:
INCBIN "baserom.gb", $10333, $1034E - $10333

	ld a, 12
	ld [$A52D], a
	ld hl, $4388
	call UnknownCall_0x111F9
	jp UnknownJump_0x10685
	call UnknownCall_0x111B7
	cp $0B
	jr z, UnknownRJump_0x10369

UnknownRJump_0x10363:
	ld hl, $4374
	jp UnknownJump_0x11214

UnknownRJump_0x10369:
	call UnknownCall_0x111DC
	jp z, UnknownJump_0x106A8
	ld a, 1
	ld [bc], a
	jr UnknownRJump_0x10363

UnknownData_0x10374:
INCBIN "baserom.gb", $10374, $1038E - $10374

	ld a, 4
	ld [$A52D], a
	ld hl, $43CA
	jp UnknownJump_0x1068A
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $02
	jr z, UnknownRJump_0x103B2
	cp $06
	jp z, UnknownJump_0x106A8

UnknownJump_0x103A9:
	ld hl, $43C0
	call UnknownCall_0x111A6
	jp UnknownJump_0x111BB

UnknownRJump_0x103B2:
	call UnknownCall_0x111DC
	ld a, 2
	jp z, UnknownJump_0x103A9
	ld a, 1
	ld [bc], a
	jp UnknownJump_0x103A9

UnknownData_0x103C0:
INCBIN "baserom.gb", $103C0, $103DC - $103C0

	call UnknownCall_0x13F5E
	ld hl, $4402
	jp UnknownJump_0x10680
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $05
	jp z, UnknownJump_0x106A8
	ld hl, $43FA
	call UnknownCall_0x111A6
	jp UnknownJump_0x111BB

UnknownData_0x103FA:
INCBIN "baserom.gb", $103FA, $10408 - $103FA

	ld a, [$A279]
	and a
	ret z
	cp $05
	ret nc
	ld hl, $4431
	call UnknownCall_0x111A6
	jp UnknownJump_0x10680
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $02
	jp z, UnknownJump_0x106A8
	ld a, [$A279]
	ld hl, $4439
	call UnknownCall_0x111A6
	jp UnknownJump_0x106CC

UnknownData_0x10431:
INCBIN "baserom.gb", $10431, $10465 - $10431

	call UnknownCall_0x13F5E
	jp UnknownJump_0x1049C
	ld hl, $448A
	jp UnknownJump_0x1068A
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $03
	jp z, UnknownJump_0x106A8
	ld hl, $4486
	call UnknownCall_0x111A6
	jp UnknownJump_0x111BB

UnknownData_0x10486:
INCBIN "baserom.gb", $10486, $1049C - $10486


UnknownJump_0x1049C:
	ld a, 10
	ld [$A52D], a
	ld hl, $44D2
	call UnknownCall_0x111F9
	jp UnknownJump_0x10685
	call UnknownCall_0x111B7
	cp $09
	jr z, UnknownRJump_0x104B7

UnknownRJump_0x104B1:
	ld hl, $44C2
	jp UnknownJump_0x11214

UnknownRJump_0x104B7:
	call UnknownCall_0x111DC
	jp z, UnknownJump_0x106A8
	ld a, 1
	ld [bc], a
	jr UnknownRJump_0x104B1

UnknownData_0x104C2:
INCBIN "baserom.gb", $104C2, $104D8 - $104C2

	ld hl, $4542
	jp UnknownJump_0x10685
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $18
	jp z, UnknownJump_0x106A8
	cp $10
	jr nc, UnknownRJump_0x1050E
	cp $08
	jr nc, UnknownRJump_0x10508
	ld a, 160
	ldh [rAUD1ENV], a

UnknownRJump_0x104F6:
	ld a, 47
	ldh [rAUD1SWEEP], a
	ld a, 187
	ldh [rAUD1LEN], a
	ld a, [bc]
	ld hl, $4514
	call UnknownCall_0x111A6
	jp UnknownJump_0x106CC

UnknownRJump_0x10508:
	ld a, 64
	ldh [rAUD1ENV], a
	jr UnknownRJump_0x104F6

UnknownRJump_0x1050E:
	ld a, 32
	ldh [rAUD1ENV], a
	jr UnknownRJump_0x104F6

UnknownData_0x10514:
INCBIN "baserom.gb", $10514, $10560 - $10514

	ld a, 4
	ld [$A52D], a
	ld hl, $4595
	call UnknownCall_0x111F9
	jp UnknownJump_0x10685
	call UnknownCall_0x111B3
	ret nz
	ld a, 4
	ld [de], a
	call UnknownCall_0x111B7
	cp $05
	jr z, UnknownRJump_0x10582

UnknownRJump_0x1057C:
	ld hl, $458D
	jp UnknownJump_0x11214

UnknownRJump_0x10582:
	call UnknownCall_0x111DC
	jp z, UnknownJump_0x106A8
	ld a, 1
	ld [bc], a
	jr UnknownRJump_0x1057C

UnknownData_0x1058D:
INCBIN "baserom.gb", $1058D, $1059B - $1058D

	ld hl, $45DC
	jp UnknownJump_0x1068A
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $09
	jp z, UnknownJump_0x106A2
	ld hl, $45CC
	call UnknownCall_0x111A6
	ld a, [$A504]
	cp $08
	jp z, UnknownJump_0x111BB
	and $01
	jr z, UnknownRJump_0x105C6
	ld a, 48
	ldh [rAUD1ENV], a

UnknownRJump_0x105C3:
	jp UnknownJump_0x106CC

UnknownRJump_0x105C6:
	ld a, 176
	ldh [rAUD1ENV], a
	jr UnknownRJump_0x105C3

UnknownData_0x105CC:
INCBIN "baserom.gb", $105CC, $105F1 - $105CC

	ld a, 4
	ld [$A52D], a
	ld hl, $4626
	call UnknownCall_0x111F9
	jp UnknownJump_0x10685
	call UnknownCall_0x111B3
	ret nz
	ld a, 4
	ld [de], a
	call UnknownCall_0x111B7
	cp $05
	jr z, UnknownRJump_0x10613

UnknownRJump_0x1060D:
	ld hl, $461E
	jp UnknownJump_0x11214

UnknownRJump_0x10613:
	call UnknownCall_0x111DC
	jp z, UnknownJump_0x106A8
	ld a, 1
	ld [bc], a
	jr UnknownRJump_0x1060D

UnknownData_0x1061E:
INCBIN "baserom.gb", $1061E, $1062C - $1061E

	ld a, 8
	ld [$A52D], a
	ld hl, $467A
	call UnknownCall_0x111F9
	jp UnknownJump_0x10685
	call UnknownCall_0x111B7
	cp $15
	jr z, UnknownRJump_0x10647

UnknownRJump_0x10641:
	ld hl, $4652
	jp UnknownJump_0x11214

UnknownRJump_0x10647:
	call UnknownCall_0x111DC
	jp z, UnknownJump_0x106A8
	ld a, 9
	ld [bc], a
	jr UnknownRJump_0x10641

UnknownData_0x10652:
INCBIN "baserom.gb", $10652, $10680 - $10652


UnknownJump_0x10680:
	ld a, 1
	ld [$A520], a

UnknownJump_0x10685:
	ld a, 1
	ld [$A536], a

UnknownJump_0x1068A:
	ld a, [$A460]
	ld [$A461], a
	xor a
	ld [$A500], a
	ld [$A504], a
	ld a, [$A41F]
	set 7, a
	ld [$A41F], a
	jp UnknownJump_0x111BB

UnknownJump_0x106A2:
	ld hl, $46C6
	call UnknownCall_0x111BB

UnknownJump_0x106A8:
	xor a
	ld [$A461], a
	ld [$A500], a
	ldh [rAUD1SWEEP], a
	ld [$A504], a
	ld [$A52D], a
	ld [$A520], a
	ld [$A536], a
	ld a, [$A41F]
	res 7, a
	ld [$A41F], a
	ret

UnknownData_0x106C6:
INCBIN "baserom.gb", $106C6, $106CC - $106C6


UnknownJump_0x106CC:
	ld b, 2
	ld c, 19
	jp UnknownJump_0x111D3

UnknownCall_0x106D3:
	ld hl, $A470
	ld a, [hl]
	and a
	jr z, UnknownRJump_0x106E9
	cp $14
	jr z, UnknownRJump_0x106E3
	ld a, [$A538]
	and a
	ret nz

UnknownRJump_0x106E3:
	ld a, [hl]
	ld hl, $46FA
	jr UnknownRJump_0x106F0

UnknownRJump_0x106E9:
	inc hl
	ld a, [hl]
	and a
	ret z
	ld hl, $472A

UnknownRJump_0x106F0:
	call UnknownCall_0x111A6
	ld de, $A502
	ld bc, $A506
	jp hl

UnknownData_0x106FA:
INCBIN "baserom.gb", $106FA, $1075A - $106FA

	ld a, 2
	ld [$A52F], a
	call UnknownCall_0x10E49
	ld hl, $47D1
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $18
	jr z, UnknownRJump_0x10798

UnknownRJump_0x10773:
	ld hl, $47A3
	call UnknownCall_0x111A6
	ld a, [$A506]
	cp $04
	jp z, UnknownJump_0x111C7
	cp $08
	jp z, UnknownJump_0x111C7
	cp $0C
	jp z, UnknownJump_0x111C7
	cp $10
	jp z, UnknownJump_0x111C7
	cp $14
	jp z, UnknownJump_0x111C7
	jp UnknownJump_0x10E5D

UnknownRJump_0x10798:
	call UnknownCall_0x111E8
	jp z, UnknownJump_0x10E1D
	ld a, 12
	ld [bc], a
	jr UnknownRJump_0x10773

UnknownData_0x107A3:
INCBIN "baserom.gb", $107A3, $1080A - $107A3

	call UnknownCall_0x10E4E
	ld hl, $4866
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $12
	jp z, UnknownJump_0x10E1D
	ld hl, $4844
	call UnknownCall_0x111A6
	ld a, [$A506]
	cp $03
	jp z, UnknownJump_0x111C7
	cp $06
	jp z, UnknownJump_0x111C7
	cp $09
	jp z, UnknownJump_0x111C7
	cp $0C
	jp z, UnknownJump_0x111C7
	cp $0F
	jp z, UnknownJump_0x111C7
	jp UnknownJump_0x10E5D

UnknownData_0x10844:
INCBIN "baserom.gb", $10844, $1089C - $10844

	ld a, 2
	ld [$A52F], a
	call UnknownCall_0x10E4E
	ld hl, $48E2
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $08
	jr z, UnknownRJump_0x108C6
	ld hl, $48D4
	call UnknownCall_0x111A6
	ld a, [$A506]
	cp $04
	jp z, UnknownJump_0x111C7
	jp UnknownJump_0x10E5D

UnknownRJump_0x108C6:
	call UnknownCall_0x111E8
	jp z, UnknownJump_0x10E1D
	xor a
	ld [bc], a
	ld hl, $48E2
	jp UnknownJump_0x111C7

UnknownData_0x108D4:
INCBIN "baserom.gb", $108D4, $108F7 - $108D4

	ld a, 36
	ld [$A52F], a
	call UnknownCall_0x10E53
	ld hl, $4926
	call UnknownCall_0x111FF
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111E8
	jp z, UnknownJump_0x10E17
	cp $12
	jr z, UnknownRJump_0x1091B
	ld a, 1
	ld [bc], a
	ld hl, $4924
	jp UnknownJump_0x1121E

UnknownRJump_0x1091B:
	ld hl, $492C
	call UnknownCall_0x111FF
	jp UnknownJump_0x111C7

UnknownData_0x10924:
INCBIN "baserom.gb", $10924, $10932 - $10924

	ld a, 2
	ld [$A52F], a
	call UnknownCall_0x10E4E
	ld hl, $4988
	call UnknownCall_0x111FF
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $11
	jr z, UnknownRJump_0x10957
	ld a, 2
	ld [de], a
	ld hl, $4968
	jp UnknownJump_0x1121E

UnknownRJump_0x10957:
	call UnknownCall_0x111E8
	jp z, UnknownJump_0x10E17
	xor a
	ld [bc], a
	ld hl, $498E
	call UnknownCall_0x111FF
	jp UnknownJump_0x111C7

UnknownData_0x10968:
INCBIN "baserom.gb", $10968, $10994 - $10968

	ld a, [$A471]
	cp $06
	ret z
	call UnknownCall_0x10E58
	ld hl, $A53E
	ld a, [hl]
	and a
	jr z, UnknownRJump_0x109AB
	dec [hl]
	ld hl, $49E1
	jp UnknownJump_0x10DF8

UnknownRJump_0x109AB:
	inc [hl]
	ld hl, $49ED
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $03
	jp z, UnknownJump_0x10E1D
	ld a, [$A53E]
	and a
	ld a, [$A506]
	jr z, UnknownRJump_0x109D0
	ld hl, $49DD
	call UnknownCall_0x111A6
	jp UnknownJump_0x111C7

UnknownRJump_0x109D0:
	ld hl, $49D9
	call UnknownCall_0x111A6
	jp UnknownJump_0x111C7

UnknownData_0x109D9:
INCBIN "baserom.gb", $109D9, $109F9 - $109D9

	ld a, 48
	ld [$A52F], a
	call UnknownCall_0x10E58
	ld hl, $4A28
	call UnknownCall_0x111FF
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111E8
	jp z, UnknownJump_0x10E17
	cp $18
	jr z, UnknownRJump_0x10A1D
	ld a, 1
	ld [bc], a
	ld hl, $4A26
	jp UnknownJump_0x1121E

UnknownRJump_0x10A1D:
	ld hl, $4A2E
	call UnknownCall_0x111FF
	jp UnknownJump_0x111C7

UnknownData_0x10A26:
INCBIN "baserom.gb", $10A26, $10A34 - $10A26

	ld a, 2
	ld [$A52F], a
	call UnknownCall_0x10E4E
	ld hl, $4AA3
	call UnknownCall_0x111FF
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $1D
	jr z, UnknownRJump_0x10A5A
	ld a, 1
	ld [de], a
	ld a, [bc]
	ld hl, $4A6B
	jp UnknownJump_0x1121E

UnknownRJump_0x10A5A:
	call UnknownCall_0x111E8
	jp z, UnknownJump_0x10E17
	xor a
	ld [bc], a
	ld hl, $4AA9
	call UnknownCall_0x111FF
	jp UnknownJump_0x111C7

UnknownData_0x10A6B:
INCBIN "baserom.gb", $10A6B, $10AEA - $10A6B


UnknownJump_0x10AEA:
	call UnknownCall_0x10E58
	ld hl, $4B14
	call UnknownCall_0x111FF
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111B7
	cp $0B
	jp z, UnknownJump_0x10E17
	ld hl, $4B04
	jp UnknownJump_0x1121E

UnknownData_0x10B04:
INCBIN "baserom.gb", $10B04, $10B1A - $10B04

	ld a, 3
	ld [$A52F], a
	call UnknownCall_0x10E53
	ld hl, $4B83
	call UnknownCall_0x111FF
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111B3
	ret nz
	ld a, 2
	ld [de], a
	call UnknownCall_0x111B7
	cp $15
	jr z, UnknownRJump_0x10B3F
	ld hl, $4B5B
	jp UnknownJump_0x1121E

UnknownRJump_0x10B3F:
	call UnknownCall_0x111E8
	jp z, UnknownJump_0x10E17
	cp $01
	jp z, UnknownJump_0x10B56
	ld hl, $4B89

UnknownRJump_0x10B4D:
	ld a, 4
	ld [bc], a
	call UnknownCall_0x111FF
	jp UnknownJump_0x111C7

UnknownJump_0x10B56:
	ld hl, $4B8F
	jr UnknownRJump_0x10B4D

UnknownData_0x10B5B:
INCBIN "baserom.gb", $10B5B, $10B95 - $10B5B

	ld a, 2
	ld [$A52F], a
	jp UnknownJump_0x10AEA
	call UnknownCall_0x111B7
	cp $0B
	jp z, UnknownJump_0x10BAB
	ld hl, $4B04
	jp UnknownJump_0x1121E

UnknownJump_0x10BAB:
	call UnknownCall_0x111E8
	jp z, UnknownJump_0x10E17
	xor a
	ld [bc], a
	ld hl, $4BBC
	call UnknownCall_0x111FF
	jp UnknownJump_0x111C7

UnknownData_0x10BBC:
INCBIN "baserom.gb", $10BBC, $10BC2 - $10BBC

	ld a, 2
	ld [$A52F], a
	ld hl, $5B86
	call UnknownCall_0x10E43
	ld hl, $4C13
	call UnknownCall_0x111FF
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111B3
	ret nz
	ld a, 2
	ld [de], a
	call UnknownCall_0x111B7
	cp $0B
	jr z, UnknownRJump_0x10BEA
	ld hl, $4BFB
	jp UnknownJump_0x1121E

UnknownRJump_0x10BEA:
	call UnknownCall_0x111E8
	jp z, UnknownJump_0x10E17
	xor a
	ld [bc], a
	ld hl, $4C19
	call UnknownCall_0x111FF
	jp UnknownJump_0x111C7

UnknownData_0x10BFB:
INCBIN "baserom.gb", $10BFB, $10C2F - $10BFB

	ld hl, $4C1F
	call UnknownCall_0x10E43
	ld hl, $4C42
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111B3
	ret nz
	jp UnknownJump_0x10E1D

UnknownData_0x10C42:
INCBIN "baserom.gb", $10C42, $10C48 - $10C42

	ld hl, $4C6C
	push hl

UnknownRJump_0x10C4C:
	ld a, 8
	ld [$A52F], a
	call UnknownCall_0x10E58
	pop hl
	call UnknownCall_0x111FF
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111E8
	jp z, UnknownJump_0x10E1D
	ld a, 1
	ld [bc], a
	ld hl, $4C6A
	jp UnknownJump_0x1121E

UnknownData_0x10C6A:
INCBIN "baserom.gb", $10C6A, $10C72 - $10C6A

	ld hl, $4C89
	push hl
	jr UnknownRJump_0x10C4C
	call UnknownCall_0x111E8
	jp z, UnknownJump_0x10E1D
	ld a, 1
	ld [bc], a
	ld hl, $4C87
	jp UnknownJump_0x1121E

UnknownData_0x10C87:
INCBIN "baserom.gb", $10C87, $10C8F - $10C87

	call UnknownCall_0x10E4E
	ld hl, $4CB9
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $07
	jp z, UnknownJump_0x10E1D
	ld hl, $4CAD
	call UnknownCall_0x111A6
	jp UnknownJump_0x111C7

UnknownData_0x10CAD:
INCBIN "baserom.gb", $10CAD, $10CE1 - $10CAD

	ld a, 7
	ld [$A52F], a
	ld hl, $4CD1
	call UnknownCall_0x10E43
	ld hl, $4D32
	call UnknownCall_0x111FF
	jp UnknownJump_0x10DF3
	call UnknownCall_0x111B7
	cp $09
	jp z, UnknownJump_0x10D08
	cp $11
	jp z, UnknownJump_0x10E17

UnknownRJump_0x10D02:
	ld hl, $4D12
	jp UnknownJump_0x1121E

UnknownJump_0x10D08:
	call UnknownCall_0x111E8
	jr z, UnknownRJump_0x10D02
	ld a, 1
	ld [bc], a
	jr UnknownRJump_0x10D02

UnknownData_0x10D12:
INCBIN "baserom.gb", $10D12, $10D38 - $10D12


UnknownJump_0x10D38:
	call UnknownCall_0x10E58
	ld hl, $4D60
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $06
	jp z, UnknownJump_0x10E1D
	ld hl, $4D56
	call UnknownCall_0x111A6
	jp UnknownJump_0x111C7

UnknownData_0x10D56:
INCBIN "baserom.gb", $10D56, $10D6C - $10D56

	ld a, 10
	ld [$A52F], a
	call UnknownCall_0x10E58
	ld hl, $4DA8
	call UnknownCall_0x111FF
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111B7
	cp $03
	jr z, UnknownRJump_0x10D8A

UnknownRJump_0x10D84:
	ld hl, $4DA4
	jp UnknownJump_0x1121E

UnknownRJump_0x10D8A:
	call UnknownCall_0x111E8
	jp z, UnknownJump_0x10E1D
	cp $05
	jr z, UnknownRJump_0x10D99
	ld a, 1
	ld [bc], a
	jr UnknownRJump_0x10D84

UnknownRJump_0x10D99:
	xor a
	ld [bc], a
	ld hl, $4DA8
	call UnknownCall_0x111FF
	jp UnknownJump_0x111C7

UnknownData_0x10DA4:
INCBIN "baserom.gb", $10DA4, $10DAE - $10DA4

	ld a, 7
	ld [$A52F], a
	ld hl, $5BA6
	call UnknownCall_0x10E43
	ld hl, $4DE5
	call UnknownCall_0x111FF
	jp UnknownJump_0x10DF8
	call UnknownCall_0x111B3
	ret nz
	ld a, 2
	ld [de], a
	call UnknownCall_0x111B7
	cp $03
	jr z, UnknownRJump_0x10DD6

UnknownRJump_0x10DD0:
	ld hl, $4DE1
	jp UnknownJump_0x1121E

UnknownRJump_0x10DD6:
	call UnknownCall_0x111E8
	jp z, UnknownJump_0x10E17
	ld a, 1
	ld [bc], a
	jr UnknownRJump_0x10DD0

UnknownData_0x10DE1:
INCBIN "baserom.gb", $10DE1, $10DEB - $10DE1

	ld a, [$A471]
	and a
	ret nz
	jp UnknownJump_0x10D38

UnknownJump_0x10DF3:
	ld a, 1
	ld [$A538], a

UnknownJump_0x10DF8:
	ld a, [$A470]
	ld [$A471], a
	push hl
	ld hl, $A43F
	set 7, [hl]
	pop hl
	xor a
	ld [$A502], a
	ld [$A506], a
	ldh [rAUD3ENA], a
	jp UnknownJump_0x111C7

UnknownData_0x10E11:
INCBIN "baserom.gb", $10E11, $10E17 - $10E11


UnknownJump_0x10E17:
	ld hl, $4E3C
	call UnknownCall_0x111C7

UnknownJump_0x10E1D:
	xor a
	ld [$A502], a
	ld [$A506], a
	ld [$A471], a
	ldh [rAUD3ENA], a
	ld [$A538], a
	ld hl, $A43F
	res 7, [hl]
	ld a, [$A436]
	ld l, a
	ld a, [$A437]
	ld h, a
	jp UnknownJump_0x112A7

UnknownData_0x10E3C:
INCBIN "baserom.gb", $10E3C, $10E43 - $10E3C


UnknownRJump_0x10E43:
UnknownCall_0x10E43:
	xor a
	ldh [rAUD3ENA], a
	jp UnknownJump_0x112A7

UnknownCall_0x10E49:
	ld hl, $5BD6
	jr UnknownRJump_0x10E43

UnknownCall_0x10E4E:
	ld hl, $5BE6
	jr UnknownRJump_0x10E43

UnknownCall_0x10E53:
	ld hl, $5BF6
	jr UnknownRJump_0x10E43

UnknownCall_0x10E58:
	ld hl, $5B96
	jr UnknownRJump_0x10E43

UnknownJump_0x10E5D:
	ld c, 29
	ld b, 2
	jp UnknownJump_0x111D3

UnknownData_0x10E64:
INCBIN "baserom.gb", $10E64, $10E90 - $10E64


UnknownCall_0x10E90:
	ld hl, $A478
	ld a, [hl]
	and a
	jr z, UnknownRJump_0x10EA2
	ld a, [$A539]
	and a
	ret nz
	ld a, [hl]
	ld hl, $4E64
	jr UnknownRJump_0x10EA9

UnknownRJump_0x10EA2:
	inc hl
	ld a, [hl]
	and a
	ret z
	ld hl, $4E7A

UnknownRJump_0x10EA9:
	call UnknownCall_0x111A6
	ld de, $A503
	ld bc, $A508
	jp hl
	ld hl, $4EDC
	jp UnknownJump_0x11163
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $08
	jp z, UnknownJump_0x11181
	ld hl, $4ECE
	call UnknownCall_0x111A6
	jp UnknownJump_0x111CD

UnknownData_0x10ECE:
INCBIN "baserom.gb", $10ECE, $10EEB - $10ECE

	ld a, 3
	ld [$A530], a
	ld hl, $4F34
	jp UnknownJump_0x11163
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $0C
	jp z, UnknownJump_0x11181
	and $01
	jr nz, UnknownRJump_0x10F18
	ld a, 73
	ldh [rAUD4ENV], a

UnknownRJump_0x10F0A:
	ld a, 47
	ldh [rAUD4LEN], a
	ld a, [bc]
	ld hl, $4F1E
	call UnknownCall_0x111A6
	jp UnknownJump_0x1119F

UnknownRJump_0x10F18:
	ld a, 32
	ldh [rAUD4ENV], a
	jr UnknownRJump_0x10F0A

UnknownData_0x10F1E:
INCBIN "baserom.gb", $10F1E, $10F4B - $10F1E

	ld a, 3
	ld [$A479], a
	ld hl, $4F60
	jp UnknownJump_0x111CD
	xor a
	ld [$A479], a
	ld hl, $4F65
	jp UnknownJump_0x111CD

UnknownData_0x10F60:
INCBIN "baserom.gb", $10F60, $10F6A - $10F60

	ld a, [$A479]
	cp $04
	ret z
	ld hl, $4F7D
	jp UnknownJump_0x11163
	call UnknownCall_0x111B3
	ret nz
	jp UnknownJump_0x11181

UnknownData_0x10F7D:
INCBIN "baserom.gb", $10F7D, $10F82 - $10F7D

	ld hl, $4FAB
	jp UnknownJump_0x11163
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $08
	jp z, UnknownJump_0x11181
	ld hl, $4F9D
	call UnknownCall_0x111A6
	jp UnknownJump_0x1119F

UnknownData_0x10F9D:
INCBIN "baserom.gb", $10F9D, $10FC5 - $10F9D

	ld hl, $4FEA
	jp UnknownJump_0x11163
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $06
	jp z, UnknownJump_0x11181
	ld hl, $4FE0
	call UnknownCall_0x111A6
	jp UnknownJump_0x111CD

UnknownData_0x10FE0:
INCBIN "baserom.gb", $10FE0, $11008 - $10FE0

	ld a, [$A479]
	cp $07
	ret z
	ld hl, $5026
	jp UnknownJump_0x11163
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $02
	jp z, UnknownJump_0x11181
	ld hl, $502B
	jp UnknownJump_0x111CD

UnknownData_0x11026:
INCBIN "baserom.gb", $11026, $11030 - $11026

	ld hl, $506D
	jp UnknownJump_0x11163
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $0A
	jp z, UnknownJump_0x1117B
	ld hl, $505B
	call UnknownCall_0x111A6
	ld a, [$A508]
	cp $05
	jr nc, UnknownRJump_0x11052
	jp UnknownJump_0x111CD

UnknownRJump_0x11052:
	inc hl
	inc hl
	ld a, 32
	ldh [rAUD4ENV], a
	jp UnknownJump_0x1119F

UnknownData_0x1105B:
INCBIN "baserom.gb", $1105B, $11086 - $1105B

	ld hl, $50C4
	jp UnknownJump_0x11163
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $0C
	jp z, UnknownJump_0x11181
	ld hl, $50AE
	call UnknownCall_0x111A6
	ld a, [$A508]
	cp $04
	jp z, UnknownJump_0x111CD
	cp $08
	jp z, UnknownJump_0x111CD
	jp UnknownJump_0x1119F

UnknownData_0x110AE:
INCBIN "baserom.gb", $110AE, $110DC - $110AE

	ld a, 5
	ld [$A530], a
	ld hl, $5108
	jp UnknownJump_0x11163
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $07
	jp z, UnknownJump_0x1117B
	ld hl, $50FC
	call UnknownCall_0x111A6
	jp UnknownJump_0x1119F

UnknownData_0x110FC:
INCBIN "baserom.gb", $110FC, $1111C - $110FC

	ld hl, $5145
	jp UnknownJump_0x11163
	call UnknownCall_0x111B3
	ret nz
	call UnknownCall_0x111B7
	cp $08
	jp z, UnknownJump_0x11181
	ld hl, $5137
	call UnknownCall_0x111A6
	jp UnknownJump_0x111CD

UnknownData_0x11137:
INCBIN "baserom.gb", $11137, $11163 - $11137


UnknownJump_0x11163:
	ld a, [$A478]
	ld [$A479], a
	xor a
	ld [$A503], a
	ld [$A508], a
	ld a, [$A44F]
	set 7, a
	ld [$A44F], a
	jp UnknownJump_0x111CD

UnknownJump_0x1117B:
	ld hl, $519A
	call UnknownCall_0x111CD

UnknownJump_0x11181:
	xor a
	ld [$A479], a
	ld [$A503], a
	ld [$A508], a
	ld [$A530], a
	ld [$A539], a
	ld a, [$A44F]
	res 7, a
	ld [$A44F], a
	ret

UnknownData_0x1119A:
INCBIN "baserom.gb", $1119A, $1119F - $1119A


UnknownJump_0x1119F:
	ld b, 2
	ld c, 34
	jp UnknownJump_0x111D3

UnknownCall_0x111A6:
	dec a
	sla a
	ld c, a
	ld b, 0
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld h, b
	ld l, c
	ret

UnknownCall_0x111B3:
	ld a, [de]
	dec a
	ld [de], a
	ret

UnknownCall_0x111B7:
	ld a, [bc]
	inc a
	ld [bc], a
	ret

UnknownJump_0x111BB:
UnknownCall_0x111BB:
	ld b, 5
	ld c, 16
	jr UnknownRJump_0x111D3

UnknownCall_0x111C1:
	ld b, 4
	ld c, 22
	jr UnknownRJump_0x111D3

UnknownJump_0x111C7:
UnknownCall_0x111C7:
	ld b, 5
	ld c, 26
	jr UnknownRJump_0x111D3

UnknownJump_0x111CD:
UnknownCall_0x111CD:
	ld b, 4
	ld c, 32
	jr UnknownRJump_0x111D3

UnknownJump_0x111D3:
UnknownRJump_0x111D3:
	ld a, [hli]
	ld [$FF00+c], a
	inc c
	dec b
	jr nz, UnknownRJump_0x111D3
	ld a, [hl]

UnknownJump_0x111DA:
	ld [de], a
	ret

UnknownCall_0x111DC:
	push de
	ld de, $A52D
	jr UnknownRJump_0x111F4

UnknownData_0x111E2:
INCBIN "baserom.gb", $111E2, $111E8 - $111E2


UnknownCall_0x111E8:
	push de
	ld de, $A52F
	jr UnknownRJump_0x111F4

UnknownData_0x111EE:
INCBIN "baserom.gb", $111EE, $111F4 - $111EE


UnknownRJump_0x111F4:
	call UnknownCall_0x111B3
	pop de
	ret

UnknownCall_0x111F9:
	push de
	ld de, $A531
	jr UnknownRJump_0x11205

UnknownCall_0x111FF:
	push de
	ld de, $A533
	jr UnknownRJump_0x11205

UnknownRJump_0x11205:
	inc hl
	inc hl
	inc hl
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hld]
	and $0F
	ld [de], a
	dec hl
	dec hl
	dec hl
	pop de
	ret

UnknownJump_0x11214:
	push de
	ld de, $A532
	ld a, [bc]
	ld c, 19
	push bc
	jr UnknownRJump_0x11228

UnknownJump_0x1121E:
	push de
	ld de, $A534
	ld a, [bc]
	ld c, 29
	push bc
	jr UnknownRJump_0x11228

UnknownRJump_0x11228:
	dec a
	sla a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a
	ld a, [de]
	dec e
	ld h, a
	ld a, [de]
	ld l, a
	add hl, bc
	pop bc
	ld a, l
	ld [$FF00+c], a
	ld [de], a
	inc c
	inc e
	ld a, h
	ld [$FF00+c], a
	ld [de], a
	pop de
	ret

UnknownData_0x11244:
INCBIN "baserom.gb", $11244, $11298 - $11244


UnknownCall_0x11298:
	inc e
	dec a
	sla a
	ld c, a
	ld b, 0
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld l, c
	ld h, b
	ld a, h
	ret

UnknownJump_0x112A7:
UnknownCall_0x112A7:
	push bc
	ld c, 48

UnknownRJump_0x112AA:
	ld a, [hli]
	ld [$FF00+c], a
	inc c
	ld a, c
	cp $40
	jr nz, UnknownRJump_0x112AA
	pop bc
	ret

UnknownData_0x112B4:
INCBIN "baserom.gb", $112B4, $112DD - $112B4


UnknownRJump_0x112DD:
	jp UnknownJump_0x13F5E

UnknownCall_0x112E0:
	cp $FF
	jr z, UnknownRJump_0x112DD
	cp $2B
	ret nc
	ld [hl], a
	ld b, a
	ld hl, $5244
	and $3F
	call UnknownCall_0x11298
	call StartMusic
	jp UnknownJump_0x113F3

UnknownData_0x112F7:
INCBIN "baserom.gb", $112F7, $113F3 - $112F7


UnknownJump_0x113F3:
	ld a, [sCurSong]
	ld hl, $52F7

UnknownRJump_0x113F9:
	dec a
	jr z, UnknownRJump_0x11404
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	jr UnknownRJump_0x113F9

UnknownRJump_0x11404:
	ld bc, $A455
	ld a, [hli]
	ld [bc], a
	inc c
	xor a
	ld [bc], a
	inc c
	ld a, [hli]
	ld [bc], a
	inc c
	xor a
	ld [bc], a
	inc c
	ld a, [hli]
	ld [bc], a
	ldh [rAUDTERM], a
	inc c
	ld a, [hli]
	ld [bc], a
	inc c
	ld a, [hli]
	ld [bc], a
	inc c
	ld a, [hli]
	ld [bc], a
	ret

UnknownCall_0x11421:
	ld hl, $A455
	ld a, [hli]
	cp $01
	ret z

UnknownData_0x11428:
INCBIN "baserom.gb", $11428, $11449 - $11428


UnknownCall_0x11449:
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld a, [bc]
	ld [de], a
	inc e
	inc bc
	ld a, [bc]
	ld [de], a
	ret

UnknownCall_0x11454:
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	ret

StartMusic: ;$1145A
	call UnknownCall_0x13F6B
	ld a, [$A468]
	cp $02
	jr z, .SetNormalMusicSpeed
	cp $03
	jr z, .SetNormalMusicSpeed
	cp $0C
	jr z, .SetNormalMusicSpeed
	cp $0F
	jr z, .SetNormalMusicSpeed
	cp $18
	jr z, .SetNormalMusicSpeed
	cp $09
	jr nz, .StartMusic
	ld a, 1
	ld [sFastMusic], a
	jr .StartMusic

.SetNormalMusicSpeed ;$1147F
	xor a
	ld [sFastMusic], a

.StartMusic ;$11483
	ld de, $A400
	ld b, 0
	ld a, [hli]
	ld [de], a
	ld a, [sFastMusic]
	and a
	jr z, .SkipFastMusic
	ld b, 4
	ld a, [de]
	add b
	ld [de], a
	ld b, 0

.SkipFastMusic ;$11497
	inc e
	call UnknownCall_0x11454
	ld a, [sFastMusic]
	and a
	jr z, UnknownRJump_0x114A7
	dec e
	call UnknownCall_0x11454
	jr UnknownRJump_0x114A9

UnknownRJump_0x114A7:
	inc hl
	inc hl

UnknownRJump_0x114A9:
	ld de, $A410
	call UnknownCall_0x11454
	ld de, $A420
	call UnknownCall_0x11454
	ld de, $A430
	call UnknownCall_0x11454
	ld de, $A440
	call UnknownCall_0x11454
	ld hl, $A410
	ld de, $A414
	call UnknownCall_0x11449
	ld hl, $A420
	ld de, $A424
	call UnknownCall_0x11449
	ld hl, $A430
	ld de, $A434
	call UnknownCall_0x11449
	ld hl, $A440
	ld de, $A444
	call UnknownCall_0x11449
	ld bc, $0410
	ld hl, $A412

UnknownRJump_0x114EB:
	ld [hl], 1
	ld a, c
	add l
	ld l, a
	dec b
	jr nz, UnknownRJump_0x114EB
	xor a
	ld [$A41E], a
	ld [$A42E], a
	ld [$A43E], a
	ret

UnknownRJump_0x114FE:
	push hl
	ld a, [$A471]
	and a
	jr nz, UnknownRJump_0x1150D
	xor a
	ldh [rAUD3ENA], a
	ld l, e
	ld h, d
	call UnknownCall_0x112A7

UnknownRJump_0x1150D:
	pop hl
	jr UnknownRJump_0x11540

UnknownJump_0x11510:
	call UnknownCall_0x11546
	call UnknownCall_0x1155B
	ld e, a
	call UnknownCall_0x11546
	call UnknownCall_0x1155B
	ld d, a
	call UnknownCall_0x11546
	call UnknownCall_0x1155B
	ld c, a
	ld a, [$A48D]
	and a
	jr nz, UnknownRJump_0x11536
	inc l
	inc l
	ld [hl], e
	inc l
	ld [hl], d
	inc l
	ld [hl], c
	dec l
	dec l
	dec l
	dec l

UnknownRJump_0x11536:
	push hl
	ld hl, $A450
	ld a, [hl]
	pop hl
	cp $03
	jr z, UnknownRJump_0x114FE

UnknownRJump_0x11540:
	call UnknownCall_0x11546
	jp UnknownJump_0x11655

UnknownCall_0x11546:
	push de
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
	inc de

UnknownRJump_0x1154C:
	ld a, e
	ld [hli], a
	ld a, d
	ld [hld], a
	pop de
	ret

UnknownCall_0x11552:
	push de
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
	inc de
	inc de
	jr UnknownRJump_0x1154C

UnknownCall_0x1155B:
	ld a, [hli]
	ld c, a
	ld a, [hld]
	ld b, a
	ld a, [bc]
	ld b, a
	ret

UnknownRJump_0x11562:
	pop hl
	jr UnknownRJump_0x11596

UnknownJump_0x11565:
	ld a, [$A450]
	cp $03
	jr nz, UnknownRJump_0x1157C
	ld a, [$A438]
	bit 7, a
	jr z, UnknownRJump_0x1157C

UnknownData_0x11573:
INCBIN "baserom.gb", $11573, $1157C - $11573


UnknownRJump_0x1157C:
	push hl
	ld a, l
	add 9
	ld l, a
	ld a, [hl]
	and a
	jr nz, UnknownRJump_0x11562
	ld a, l
	add 4
	ld l, a
	bit 7, [hl]
	jr nz, UnknownRJump_0x11562
	pop hl
	call UnknownCall_0x11817
	push hl
	call UnknownCall_0x11899
	pop hl

UnknownJump_0x11596:
UnknownRJump_0x11596:
	dec l
	dec l
	jp UnknownJump_0x117F7

UnknownJump_0x1159B:
	dec l
	dec l
	dec l
	dec l
	call UnknownCall_0x11552

UnknownRJump_0x115A2:
	ld a, l
	add 4
	ld e, a
	ld d, h
	call UnknownCall_0x11449
	cp $00
	jr z, UnknownRJump_0x115CD
	cp $FF
	jr z, UnknownRJump_0x115B6
	inc l
	jp UnknownJump_0x11653

UnknownRJump_0x115B6:
	dec l
	push hl
	call UnknownCall_0x11552
	call UnknownCall_0x1155B
	ld e, a
	call UnknownCall_0x11546
	call UnknownCall_0x1155B
	ld d, a
	pop hl
	ld a, e
	ld [hli], a
	ld a, d
	ld [hld], a
	jr UnknownRJump_0x115A2

UnknownRJump_0x115CD:
	ld hl, sCurSong
	ld [hl], 0
	call UnknownCall_0x13F5E
	ret

UnknownJump_0x115D6:
	call UnknownCall_0x11546
	call UnknownCall_0x1155B
	ld [$A401], a
	call UnknownCall_0x11546
	call UnknownCall_0x1155B
	ld [$A402], a
	jr UnknownRJump_0x115F3

UnknownJump_0x115EA:
UnknownData_0x115EA:
INCBIN "baserom.gb", $115EA, $115F3 - $115EA


UnknownRJump_0x115F3:
	call UnknownCall_0x11546
	jr UnknownRJump_0x11655

UnknownJump_0x115F8:
	call UnknownCall_0x11546
	call UnknownCall_0x1155B
	push hl
	ld a, l
	add 11
	ld l, a
	ld c, [hl]
	ld a, b
	or c
	ld [hl], a
	ld b, h
	ld c, l
	dec c
	dec c
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
	inc de
	ld a, e
	ld [hli], a
	ld a, d
	ld [hld], a
	ld a, d
	ld [bc], a
	dec c
	ld a, e
	ld [bc], a
	jr UnknownRJump_0x11655

UnknownJump_0x1161C:
	push hl
	ld a, l
	add 11
	ld l, a
	ld a, [hl]
	dec [hl]
	ld a, [hl]
	and $7F
	jr z, UnknownRJump_0x11635
	ld b, h
	ld c, l
	dec c
	dec c
	dec c
	pop hl
	ld a, [bc]
	ld [hli], a
	inc c
	ld a, [bc]
	ld [hld], a
	jr UnknownRJump_0x11655

UnknownRJump_0x11635:
	pop hl
	jr UnknownRJump_0x115F3

UnknownCall_0x11638:
	ld hl, sCurSong
	ld a, [hl]
	and a
	ret z
	call UnknownCall_0x11421
	ld a, 1
	ld [$A450], a
	ld hl, $A410

UnknownJump_0x11649:
	inc l
	ld a, [hli]
	and a
	jp z, UnknownJump_0x11596
	dec [hl]
	jp nz, UnknownJump_0x11565

UnknownJump_0x11653:
	inc l
	inc l

UnknownJump_0x11655:
UnknownRJump_0x11655:
	call UnknownCall_0x1155B
	cp $00
	jp z, UnknownJump_0x1159B
	cp $9D
	jp z, UnknownJump_0x11510
	cp $9E
	jp z, UnknownJump_0x115D6
	cp $9F
	jp z, UnknownJump_0x115EA
	cp $9B
	jp z, UnknownJump_0x115F8
	cp $9C
	jp z, UnknownJump_0x1161C
	cp $99
	jp z, UnknownJump_0x11989
	cp $9A
	jp z, UnknownJump_0x11994
	cp $97
	jp z, UnknownJump_0x119CC
	cp $98
	jp z, UnknownJump_0x119DB
	cp $95
	jp z, UnknownJump_0x119FF
	cp $96
	jp z, UnknownJump_0x11A0E
	and $F0
	cp $A0
	jr nz, UnknownRJump_0x116E7
	ld a, b
	and $0F
	ld c, a
	ld b, 0
	push hl
	ld de, $A401
	ld a, [de]
	ld l, a
	inc e
	ld a, [de]
	ld h, a
	add hl, bc
	ld a, [hl]
	pop hl
	push hl
	ld d, a
	inc l
	inc l
	inc l
	ld a, [hl]
	and $F0
	jr nz, UnknownRJump_0x116B9
	ld a, d
	jr UnknownRJump_0x116DE

UnknownRJump_0x116B9:
	ld e, a
	ld a, d
	push af
	srl a
	sla e
	jr c, UnknownRJump_0x116CA
	ld d, a
	srl a
	sla e
	jr c, UnknownRJump_0x116CA
	add d

UnknownRJump_0x116CA:
	ld c, a
	and a
	jr nz, UnknownRJump_0x116D0
	ld c, 2

UnknownRJump_0x116D0:
	ld de, $A450
	ld a, [de]
	dec a
	ld e, a
	ld d, 0
	ld hl, $A407
	add hl, de
	ld [hl], c
	pop af

UnknownRJump_0x116DE:
	pop hl
	dec l
	ld [hli], a
	call UnknownCall_0x11546
	call UnknownCall_0x1155B

UnknownRJump_0x116E7:
	ld a, [$A450]
	cp $04
	jr z, UnknownRJump_0x11728
	push de
	ld de, $A51A
	call UnknownCall_0x11A71
	ld a, [de]
	and a
	jr z, UnknownRJump_0x116FF
	ld a, 1
	ld [de], a
	inc e
	xor a
	ld [de], a

UnknownRJump_0x116FF:
	ld de, $A520
	call UnknownCall_0x11A71
	xor a
	ld [de], a
	inc e
	ld [de], a
	ld de, $A526
	call UnknownCall_0x11A71
	inc e
	xor a
	ld [de], a
	ld a, [$A450]
	cp $03
	jr nz, UnknownRJump_0x11727
	ld de, $A50E
	ld a, [de]
	and a
	jr z, UnknownRJump_0x11727
	ld a, 1
	ld [de], a
	xor a
	ld [$A51F], a

UnknownRJump_0x11727:
	pop de

UnknownRJump_0x11728:
	ld c, b
	ld b, 0
	call UnknownCall_0x11546
	ld a, [$A450]
	cp $04
	jp z, UnknownJump_0x1176A
	push hl
	ld a, l
	add 5
	ld l, a
	ld e, l
	ld d, h
	inc l
	inc l
	ld a, c
	cp $01
	jr z, UnknownRJump_0x11765
	ld [hl], 0
	ld a, [$A400]
	and a
	jr z, UnknownRJump_0x11758
	ld l, a
	ld h, 0
	bit 7, l
	jr z, UnknownRJump_0x11755

UnknownData_0x11753:
INCBIN "baserom.gb", $11753, $11755 - $11753


UnknownRJump_0x11755:
	add hl, bc
	ld b, h
	ld c, l

UnknownRJump_0x11758:
	ld hl, $5AF4
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	jp UnknownJump_0x1179B

UnknownRJump_0x11765:
	ld [hl], 1
	pop hl
	jr UnknownRJump_0x1179B

UnknownJump_0x1176A:
	push hl
	ld a, c
	cp $1F
	jr z, UnknownRJump_0x11788
	ld de, $A446
	ld hl, $5C06
	add hl, bc

UnknownRJump_0x11777:
	ld a, [hli]
	ld [de], a
	inc e
	ld a, e
	cp $4B
	jr nz, UnknownRJump_0x11777
	ld c, 32
	ld hl, $A444
	ld b, 0
	jr UnknownRJump_0x117C9

UnknownRJump_0x11788:
	ld a, [$A44F]
	bit 7, a
	jp nz, UnknownJump_0x117F2
	ld a, 3
	ld [$A478], a
	call UnknownCall_0x10E90
	jp UnknownJump_0x117F2

UnknownJump_0x1179B:
UnknownRJump_0x1179B:
	push hl
	ld b, 0
	ld a, [$A450]
	cp $01
	jr z, UnknownRJump_0x117C6
	cp $02
	jr z, UnknownRJump_0x117C2
	ld c, 26
	ld a, [$A43F]
	bit 7, a
	jr nz, UnknownRJump_0x117B7
	xor a
	ld [$FF00+c], a
	ld a, 128
	ld [$FF00+c], a

UnknownRJump_0x117B7:
	inc c
	inc l
	inc l
	inc l
	inc l
	ld a, [hli]
	ld e, a
	ld d, 0
	jr UnknownRJump_0x117D0

UnknownRJump_0x117C2:
	ld c, 22
	jr UnknownRJump_0x117C9

UnknownRJump_0x117C6:
	ld c, 16
	inc c

UnknownRJump_0x117C9:
	inc l
	inc l
	ld a, [hli]
	ld e, a
	inc l
	ld a, [hli]
	ld d, a

UnknownRJump_0x117D0:
	push hl
	inc l
	inc l
	ld a, [hli]
	and a
	jr z, UnknownRJump_0x117D9
	ld e, 8

UnknownRJump_0x117D9:
	inc l
	inc l
	ld [hl], 0
	inc l
	ld a, [hl]
	pop hl
	bit 7, a
	jr nz, UnknownRJump_0x117F2
	ld a, d
	or b
	ld [$FF00+c], a
	inc c
	ld a, e
	ld [$FF00+c], a
	inc c
	ld a, [hli]
	ld [$FF00+c], a
	inc c
	ld a, [hl]
	or $80
	ld [$FF00+c], a

UnknownJump_0x117F2:
UnknownRJump_0x117F2:
	pop hl
	dec l
	ld a, [hld]
	ld [hld], a
	dec l

UnknownJump_0x117F7:
	ld de, $A450
	ld a, [de]
	cp $04
	jr z, UnknownRJump_0x11808
	inc a
	ld [de], a
	ld a, 16
	add l
	ld l, a
	jp UnknownJump_0x11649

UnknownRJump_0x11808:
	ld hl, $A41E
	inc [hl]
	ld hl, $A42E
	inc [hl]
	ld hl, $A43E
	inc [hl]
	ret

UnknownJump_0x11815:
	pop hl
	ret

UnknownCall_0x11817:
	push hl
	ld a, l
	add 6
	ld l, a
	ld a, [hl]
	and $0F
	jr z, UnknownRJump_0x11839
	ld [$A451], a
	ld a, [$A450]
	ld c, 19
	cp $01
	jr z, UnknownRJump_0x11879
	ld c, 24
	cp $02
	jr z, UnknownRJump_0x11879
	ld c, 29
	cp $03
	jr z, UnknownRJump_0x11879

UnknownJump_0x11839:
UnknownRJump_0x11839:
	ld a, [$A450]
	cp $04
	jp z, UnknownJump_0x11815
	ld c, 19
	cp $01
	jp z, UnknownJump_0x11851
	ld c, 24
	cp $02
	jp z, UnknownJump_0x11851
	ld c, 29

UnknownJump_0x11851:
	ld de, $A51A
	call UnknownCall_0x11A71
	ld a, [de]
	and a
	jp nz, UnknownJump_0x11A18
	ld de, $A526
	call UnknownCall_0x11A71
	ld a, [de]
	and a
	jp nz, UnknownJump_0x119E4
	ld a, [$A450]
	cp $03
	jp nz, UnknownJump_0x11815
	ld a, [$A50E]
	and a
	jp nz, UnknownJump_0x1199A
	jp UnknownJump_0x11815

UnknownRJump_0x11879:
	inc l
	ld a, [hli]
	ld e, a
	ld a, [hl]
	and $0F
	ld d, a
	push de
	ld a, l
	add 4
	ld l, a
	ld b, [hl]
	ld a, [$A451]
	cp $01
	jp z, UnknownJump_0x11A87
	ld hl, rIE
	pop de
	add hl, de
	call UnknownCall_0x11A60
	jp UnknownJump_0x11839

UnknownCall_0x11899:
	ld a, [$A41B]
	and a
	jr nz, UnknownRJump_0x118C0
	ld a, [$A417]
	and a
	jr z, UnknownRJump_0x118C0
	and $0F
	ld b, a
	ld hl, $A407
	ld a, [$A41E]
	cp [hl]
	jr nz, UnknownRJump_0x118C0
	ld c, 18
	ld de, $A41A
	ld a, [$A41F]
	bit 7, a
	jr nz, UnknownRJump_0x118C0
	call UnknownCall_0x118E4

UnknownRJump_0x118C0:
	ld a, [$A42B]
	and a
	ret nz
	ld a, [$A427]
	and a
	ret z
	and $0F
	ld b, a
	ld hl, $A408
	ld a, [$A42E]
	cp [hl]
	ret nz
	ld a, [$A42F]
	bit 7, a
	ret nz
	ld c, 23
	ld de, $A42A
	call UnknownCall_0x118E4
	ret

UnknownCall_0x118E4:
	push bc
	dec b
	ld c, b
	ld b, 0
	ld hl, $5CAC
	add hl, bc
	ld a, [hl]
	pop bc
	ld [$FF00+c], a
	inc c
	inc c
	ld a, [de]
	or $80
	ld [$FF00+c], a
	ret

UnknownJump_0x118F7:
	call UnknownCall_0x13FE7
	xor a
	ld [$A461], a
	ld [$A471], a
	ld [$A479], a
	ld [$A505], a
	ld a, 1
	ld [$A45D], a
	ld b, 4
	ld hl, $A41F
	ld de, $0010

UnknownRJump_0x11914:
	res 7, [hl]
	add hl, de
	dec b
	jr nz, UnknownRJump_0x11914
	ld hl, $5970
	ld de, $A501
	call UnknownCall_0x111C1
	jp UnknownJump_0x10067

UnknownJump_0x11926:
	xor a
	ld [$A45D], a
	ld [$A536], a
	ld [$A538], a
	ld [$A539], a
	jp UnknownJump_0x10044

UnknownJump_0x11936:
	ld de, $A501
	call UnknownCall_0x111B3
	jp nz, UnknownJump_0x10067
	ld bc, $A505
	call UnknownCall_0x111B7
	cp $06
	jp z, UnknownJump_0x11959
	ld hl, $5966
	call UnknownCall_0x111A6
	ld de, $A501
	call UnknownCall_0x111C1
	jp UnknownJump_0x10067

UnknownJump_0x11959:
	ld a, 240
	ld [$A501], a
	ld a, 5
	ld [$A505], a
	jp UnknownJump_0x10067

UnknownData_0x11966:
INCBIN "baserom.gb", $11966, $11989 - $11966


UnknownJump_0x11989:
	ld a, 1

UnknownRJump_0x1198B:
	ld [$A50E], a
	call UnknownCall_0x11546
	jp UnknownJump_0x11655

UnknownJump_0x11994:
	xor a
	ld [$A50E], a
	jr UnknownRJump_0x1198B

UnknownJump_0x1199A:
	cp $02
	jp z, UnknownJump_0x11815
	ld bc, $A51F
	call UnknownCall_0x111B7
	ld c, 28
	ld b, 64
	cp $03
	jr z, UnknownRJump_0x119C7
	ld b, 96
	cp $05
	jr z, UnknownRJump_0x119C7
	cp $0A
	jr z, UnknownRJump_0x119C7
	ld b, 0
	cp $07
	jr z, UnknownRJump_0x119C7
	cp $0D
	jp nz, UnknownJump_0x11815
	ld a, 2
	ld [$A50E], a

UnknownRJump_0x119C7:
	ld a, b
	ld [$FF00+c], a
	jp UnknownJump_0x11815

UnknownJump_0x119CC:
	ld de, $A526
	call UnknownCall_0x11A71
	ld a, 1

UnknownRJump_0x119D4:
	ld [de], a
	call UnknownCall_0x11546
	jp UnknownJump_0x11655

UnknownJump_0x119DB:
	ld de, $A526
	call UnknownCall_0x11A71
	xor a
	jr UnknownRJump_0x119D4

UnknownJump_0x119E4:
	inc e
	ld a, [de]
	and a
	jr nz, UnknownRJump_0x119FA
	inc a
	ld [de], a
	pop hl
	push hl
	call UnknownCall_0x11A55

UnknownRJump_0x119F0:
	ld hl, $FF9C
	add hl, de
	call UnknownCall_0x11A60
	jp UnknownJump_0x11815

UnknownRJump_0x119FA:
	call UnknownCall_0x11A7A
	jr UnknownRJump_0x119F0

UnknownJump_0x119FF:
	ld de, $A51A
	call UnknownCall_0x11A71
	ld a, 1

UnknownJump_0x11A07:
	ld [de], a
	call UnknownCall_0x11546
	jp UnknownJump_0x11655

UnknownJump_0x11A0E:
	ld de, $A51A
	call UnknownCall_0x11A71
	xor a
	jp UnknownJump_0x11A07

UnknownJump_0x11A18:
	cp $02
	jp z, UnknownJump_0x11815
	inc e
	ld a, [de]
	and a
	jr z, UnknownRJump_0x11A44
	cp $05
	jr z, UnknownRJump_0x11A35
	inc a
	ld [de], a
	call UnknownCall_0x11A7A
	ld hl, $0001
	add hl, de
	call UnknownCall_0x11A60
	jp UnknownJump_0x11815

UnknownRJump_0x11A35:
	ld de, $A51A
	call UnknownCall_0x11A71
	ld a, 2
	ld [de], a
	inc e
	xor a
	ld [de], a
	jp UnknownJump_0x11815

UnknownRJump_0x11A44:
	inc a
	ld [de], a
	pop hl
	push hl
	call UnknownCall_0x11A55
	ld hl, $FFFC
	add hl, de
	call UnknownCall_0x11A60
	jp UnknownJump_0x11815

UnknownCall_0x11A55:
	ld a, 7
	add l
	ld l, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	and $0F
	ld d, a
	ret

UnknownCall_0x11A60:
	ld de, $A514
	call UnknownCall_0x11A71
	ld a, l
	ld [$FF00+c], a
	ld [de], a
	inc c
	inc e
	ld a, h
	and $0F
	ld [$FF00+c], a
	ld [de], a
	ret

UnknownCall_0x11A71:
	ld a, [$A450]
	dec a
	sla a
	add e
	ld e, a
	ret

UnknownCall_0x11A7A:
	ld de, $A514
	call UnknownCall_0x11A71
	ld a, [de]
	ld l, a
	inc e
	ld a, [de]
	ld d, a
	ld e, l
	ret

UnknownJump_0x11A87:
	pop de
	ld de, $A520
	call UnknownCall_0x11A71
	ld a, [de]
	inc a
	ld [de], a
	inc e
	cp $19
	jr z, UnknownRJump_0x11AC7
	cp $2D
	jr z, UnknownRJump_0x11AC0
	ld a, [de]
	and a
	jp z, UnknownJump_0x11839

UnknownRJump_0x11A9F:
	dec e
	ld a, [de]
	sub 25
	sla a
	ld l, a
	ld h, 0
	ld de, $5ACC
	add hl, de
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ld e, a
	pop hl
	push hl
	push de
	call UnknownCall_0x11A55
	ld h, d
	ld l, e
	pop de
	add hl, de
	call UnknownCall_0x11A60
	jp UnknownJump_0x11839

UnknownRJump_0x11AC0:
	dec e
	ld a, 25
	ld [de], a
	inc e
	jr UnknownRJump_0x11A9F

UnknownRJump_0x11AC7:
	ld a, 1
	ld [de], a
	jr UnknownRJump_0x11A9F

UnknownData_0x11ACC:
INCBIN "baserom.gb", $11ACC, $13F5E - $11ACC


UnknownJump_0x13F5E:
UnknownCall_0x13F5E:
	ld a, 255
	ldh [rAUDTERM], a
	ld a, 3
	ld [$A455], a
	xor a
	ld [sCurSong], a

UnknownCall_0x13F6B:
	xor a
	ld [$A461], a
	ld [$A471], a
	ld [$A479], a
	ld [$A41F], a
	ld [$A42F], a
	ld [$A43F], a
	ld [$A44F], a
	ld [$A45E], a
	ld [$A50E], a
	ld [$A51F], a
	ld [$A52C], a
	ld [$A51A], a
	ld [$A51C], a
	ld [$A51E], a
	ld [$A51B], a
	ld [$A51D], a
	ld [$A51F], a
	ld [$A526], a
	ld [$A527], a
	ld [$A528], a
	ld [$A529], a
	ld [$A52A], a
	ld [$A52B], a
	ld [$A504], a
	ld [$A505], a
	ld [$A506], a
	ld [$A508], a
	ld [$A500], a
	ld [$A501], a
	ld [$A502], a
	ld [$A503], a
	ld [$A535], a
	ld [$A536], a
	ld [$A537], a
	ld [$A538], a
	ld [$A539], a
	ld [$A520], a
	ld [$A521], a
	ld [$A522], a
	ld [$A523], a
	ld [$A53F], a

UnknownCall_0x13FE7:
	ld a, 8
	ldh [rAUD1ENV], a
	ldh [rAUD2ENV], a
	ldh [rAUD4ENV], a
	ld a, 128
	ldh [rAUD1HIGH], a
	ldh [rAUD2HIGH], a
	ldh [rAUD4GO], a
	xor a
	ldh [rAUD1SWEEP], a
	ldh [rAUD3ENA], a
	ret

UnknownData_0x13FFD:
INCBIN "baserom.gb", $13FFD, $14000 - $13FFD



SECTION "bank05", ROMX, BANK[$05]


UnknownData_0x14000:
INCBIN "baserom.gb", $14000, $14043 - $14000


UnknownJump_0x14043:
	call UnknownCall_0x2ABE
	ld de, $9800
	ld hl, $59E5

UnknownRJump_0x1404C:
	ld a, [hli]
	ld [de], a
	inc de
	ld a, d
	cp $9C
	jr nz, UnknownRJump_0x1404C
	ld a, 7
	ldh_n_a $4B
	ld a, 136
	ldh_n_a $4A
	xor a
	ld [sScrollY], a
	ld a, 195
	ldh_n_a $40
	ld a, 5
	ld [$A267], a
	ld a, 64
	ld [$A266], a
	ld a, 255
	ld [$A468], a
	ld a, 1
	ldh_n_a $9B
	ret

UnknownJump_0x1407C:
	call UnknownCall_0x031C
	ld a, 228
	ld [sBGPalette], a
	ld a, 208
	ld [sOAMPalette1], a
	call UnknownCall_0x14113
	ld a, [$A267]
	cp $05
	ret nc
	and a
	jr z, UnknownRJump_0x140D6
	ldh_a_n $81
	cp $04
	jr z, UnknownRJump_0x140A8
	ldh_a_n $81
	cp $08
	ret nz
	ld a, 25
	ldh_n_a $9B
	ret

UnknownRJump_0x140A8:
UnknownData_0x140A8:
INCBIN "baserom.gb", $140A8, $140D6 - $140A8


UnknownRJump_0x140D6:
	ld a, [$A0F0]
	and $03
	ld b, a
	ld a, 127
	sub b
	ld h, a
	ld l, 0
	ld de, $A300

UnknownRJump_0x140E5:
	ld a, [hli]
	ld [de], a
	inc de
	ld a, l
	and a
	jr nz, UnknownRJump_0x140E5
	ld a, 15
	ld [sSoundDisabled], a
	xor a
	ld [$A2CF], a
	ldh_n_a $97
	ld hl, $4121
	ld a, [$A0F0]
	and $03
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [sCurLevel], a
	ld a, 255
	ld [$A468], a
	ld a, 11
	ldh_n_a $9B
	ret

UnknownCall_0x14113:
	ld h, 161
	ldh_a_n $8D
	ld l, a

UnknownRJump_0x14119:
	xor a
	ld [hli], a
	ld a, l
	cp $A0
	jr c, UnknownRJump_0x14119
	ret

UnknownData_0x14121:
INCBIN "baserom.gb", $14121, $141E5 - $14121

GFX_TitleScreen: ;$141E5
INCBIN "gfx/titlescreen.2bpp"

INCBIN "baserom.gb", $159E5, $18000 - $159E5


SECTION "bank06", ROMX, BANK[$06]


GFX_Mario: ;$18000
INCBIN "gfx/mario.2bpp"

GFX_MarioDark: ;$18800
INCBIN "gfx/mariodark.2bpp"

GFX_MarioMoon: ;$19000
INCBIN "gfx/mariomoon.2bpp"

GFX_EnemiesClassic: ;$19800
INCBIN "gfx/enemies/classic.2bpp"

GFX_EnemiesTreeZone1: ;$19B80
INCBIN "gfx/enemies/treezone1.2bpp"

GFX_EnemiesTreeZone2: ;$19F00
INCBIN "gfx/enemies/treezone2.2bpp"

GFX_EnemiesTreeZone3: ;$1A280
INCBIN "gfx/enemies/treezone3.2bpp"

GFX_EnemiesTreeZone4: ;$1A600
INCBIN "gfx/enemies/treezone4.2bpp"

GFX_EnemiesTreeZoneBoss: ;$1A980
INCBIN "gfx/enemies/treezoneboss.2bpp"

UnknownData_0x1AD00: ;mixed tiles/data at the TreeZone bank tail, unclassified
	db $07, $07, $1F, $18, $3F, $23, $7C, $4F, $73, $5C, $F7, $98, $EF, $B0, $EF, $B0
	db $0F, $0F, $17, $1C, $2F, $39, $5E, $73, $5D, $76, $5D, $76, $BB, $EC, $BB, $EC
	db $E0, $E0, $E0, $20, $F0, $90, $78, $C8, $B8, $68, $B8, $68, $DC, $34, $DC, $34
	db $18, $18, $24, $3C, $2C, $3C, $4A, $7E, $56, $7A, $56, $7A, $56, $7A, $56, $7A
	db $00, $00, $08, $08, $1C, $14, $3E, $36, $7F, $41, $3E, $36, $18, $10, $08, $08
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $20, $20, $20, $20, $20
	db $20, $20, $53, $54, $41, $46, $46, $20, $20, $20, $20, $20, $20, $20, $20, $F1
	db $F1, $F1, $F1, $F1, $F1, $F1, $20, $5E, $5E, $20, $54, $45, $41, $4D, $20, $4D
	db $45, $54, $52, $4F, $49, $44, $20, $5E, $5E, $20, $F1, $F1, $F1, $F1, $F1, $20
	db $50, $52, $4F, $44, $55, $43, $45, $52, $20, $20, $20, $20, $20, $20, $20, $20
	db $20, $20, $20, $F1, $F1, $20, $20, $47, $55, $4E, $50, $45, $49, $20, $59, $4F
	db $4B, $4F, $49, $20, $20, $20, $20, $20, $20, $F1, $F1, $F1, $F1, $F1, $F1, $F1
	db $20, $44, $49, $52, $45, $43, $54, $4F, $52, $20, $20, $20, $20, $20, $20, $20
	db $20, $20, $20, $20, $F1, $F1, $20, $20, $48, $49, $52, $4F, $4A, $49, $20, $4B
	db $49, $59, $4F, $54, $41, $4B, $45, $20, $20, $20, $F1, $F1, $20, $20, $48, $49
	db $52, $4F, $59, $55, $4B, $49, $20, $4B, $49, $4D, $55, $52, $41, $20, $20, $20
	db $F1, $F1, $F1, $F1, $F1, $F1, $F1, $20, $4D, $41, $49, $4E, $20, $50, $52, $4F
	db $47, $52, $41, $4D, $4D, $45, $52, $20, $20, $20, $20, $F1, $F1, $20, $20, $54
	db $41, $4B, $41, $48, $49, $52, $4F, $20, $48, $41, $52, $41, $44, $41, $20, $20
	db $20, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $20, $50, $52, $4F, $47, $52, $41, $4D
	db $4D, $45, $52, $20, $20, $20, $20, $20, $20, $20, $20, $20, $F1, $F1, $20, $20
	db $4D, $41, $53, $41, $52, $55, $20, $59, $41, $4D, $41, $4E, $41, $4B, $41, $20
	db $20, $20, $F1, $20, $20, $4D, $41, $53, $41, $4F, $20, $59, $41, $4D, $41, $4D
	db $4F, $54, $4F, $20, $20, $20, $20, $F1, $20, $20, $49, $53, $41, $4F, $20, $48
	db $49, $52, $41, $4E, $4F, $20, $20, $20, $20, $20, $20, $20, $F1, $F1, $F1, $F1
	db $F1, $F1, $20, $47, $52, $41, $50, $48, $49, $43, $20, $44, $45, $53, $49, $47
	db $4E, $45, $52, $20, $20, $20, $F1, $F1, $20, $20, $48, $49, $52, $4F, $4A, $49
	db $20, $4B, $49, $59, $4F, $54, $41, $4B, $45, $20, $20, $20, $F1, $20, $20, $48
	db $49, $52, $4F, $59, $55, $4B, $49, $20, $4B, $49, $4D, $55, $52, $41, $20, $20
	db $20, $F1, $F1, $F1, $F1, $F1, $F1, $20, $50, $52, $4F, $47, $52, $41, $4D, $20
	db $41, $53, $53, $49, $53, $54, $41, $4E, $54, $20, $20, $F1, $F1, $20, $20, $59
	db $55, $5A, $55, $52, $55, $20, $4F, $47, $41, $57, $41, $20, $20, $20, $20, $20
	db $20, $F1, $20, $20, $4E, $4F, $42, $55, $48, $49, $52, $4F, $20, $4F, $5A, $41
	db $4B, $49, $20, $20, $20, $20, $F1, $F1, $F1, $F1, $F1, $F1, $20, $53, $4F, $55
	db $4E, $44, $20, $50, $52, $4F, $47, $52, $41, $4D, $4D, $45, $52, $20, $20, $20
	db $F1, $F1, $20, $20, $52, $59, $4F, $48, $4A, $49, $20, $59, $4F, $53, $48, $49
	db $54, $4F, $4D, $49, $20, $20, $F1, $F1, $F1, $F1, $F1, $F1, $20, $44, $45, $53
	db $49, $47, $4E, $45, $52, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
	db $F1, $F1, $20, $20, $4D, $41, $4B, $4F, $54, $4F, $20, $4B, $41, $4E, $4F, $48
	db $20, $20, $20, $20, $20, $20, $F1, $20, $20, $4D, $41, $53, $41, $46, $55, $4D
	db $49, $20, $53, $41, $4B, $41, $53, $48, $49, $54, $41, $F1, $20, $20, $54, $4F
	db $4D, $4F, $59, $4F, $53, $48, $49, $20, $59, $41, $4D, $41, $4E, $45, $20, $20
	db $F1, $20, $20, $54, $41, $4B, $45, $48, $49, $4B, $4F, $20, $48, $4F, $53, $4F
	db $4B, $41, $57, $41, $20, $F1, $20, $20, $59, $41, $53, $55, $4F, $20, $49, $4E
	db $4F, $55, $45, $20, $20, $20, $20, $20, $20, $20, $F1, $F1, $F1, $F1, $F1, $F1
	db $20, $44, $45, $42, $55, $47, $47, $45, $52, $20, $20, $20, $20, $20, $20, $20
	db $20, $20, $20, $20, $F1, $F1, $20, $20, $4D, $41, $53, $41, $52, $55, $20, $4F
	db $4B, $41, $44, $41, $20, $20, $20, $20, $20, $20, $F1, $20, $20, $4B, $45, $4E
	db $4A, $49, $20, $4E, $49, $53, $48, $49, $5A, $41, $57, $41, $20, $20, $20, $F1
	db $20, $20, $48, $49, $52, $4F, $46, $55, $4D, $49, $20, $4D, $41, $54, $53, $55
	db $4F, $4B, $41, $20, $F1, $20, $20, $54, $4F, $48, $52, $55, $20, $4F, $48, $53
	db $41, $57, $41, $20, $20, $20, $20, $20, $20, $F1, $20, $20, $4B, $4F, $48, $54
	db $41, $20, $46, $55, $4B, $55, $49, $20, $20, $20, $20, $20, $20, $20, $F1, $20
	db $20, $4B, $45, $49, $53, $55, $4B, $45, $20, $54, $45, $52, $41, $53, $41, $4B
	db $49, $20, $20, $F1, $20, $20, $4B, $45, $4E, $49, $43, $48, $49, $20, $53, $55
	db $47, $49, $4E, $4F, $20, $20, $20, $20, $F1, $20, $20, $48, $49, $54, $4F, $53
	db $48, $49, $20, $59, $41, $4D, $41, $47, $41, $4D, $49, $20, $20, $F1, $20, $20
	db $4B, $41, $54, $53, $55, $59, $41, $20, $59, $41, $4D, $41, $4E, $4F, $20, $20
	db $20, $20, $F1, $20, $20, $59, $55, $4A, $49, $20, $48, $4F, $52, $49, $20, $20
	db $20, $20, $20, $20, $20, $20, $20, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $20
	db $5E, $20, $53, $50, $45, $43, $49, $41, $4C, $20, $54, $48, $41, $4E, $4B, $53
	db $20, $5E, $20, $F1, $20, $20, $20, $20, $20, $20, $20, $20, $20, $54, $4F, $20
	db $20, $20, $20, $20, $20, $20, $20, $20, $F1, $F1, $20, $20, $54, $41, $4B, $45
	db $48, $49, $52, $4F, $20, $49, $5A, $55, $53, $48, $49, $20, $20, $20, $F1, $20
	db $20, $50, $48, $49, $4C, $20, $53, $41, $4E, $44, $48, $4F, $50, $20, $20, $20
	db $20, $20, $20, $F1, $20, $20, $54, $4F, $4E, $59, $20, $53, $54, $41, $4E, $43
	db $5A, $59, $4B, $20, $20, $20, $20, $20, $F1, $20, $20, $59, $55, $4B, $41, $20
	db $4E, $41, $4B, $41, $54, $41, $20, $20, $20, $20, $20, $20, $20, $F1, $20, $20
	db $48, $49, $52, $4F, $20, $59, $41, $4D, $41, $44, $41, $20, $20, $20, $20, $20
	db $20, $20, $F1, $20, $20, $44, $41, $4E, $20, $4F, $57, $53, $45, $4E, $20, $20
	db $20, $20, $20, $20, $20, $20, $20, $F1, $20, $20, $44, $59, $4C, $41, $4E, $20
	db $43, $55, $54, $48, $42, $45, $52, $54, $20, $20, $20, $20, $F1, $20, $20, $53
	db $41, $43, $48, $49, $45, $20, $49, $4E, $4F, $4B, $45, $20, $20, $20, $20, $20
	db $20, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $20
	db $20, $20, $50, $52, $45, $53, $45, $4E, $54, $45, $44, $20, $20, $20, $20, $20
	db $20, $20, $20, $F1, $20, $20, $20, $20, $20, $20, $20, $42, $59, $20, $20, $20
	db $20, $20, $20, $20, $20, $20, $20, $20, $F1, $20, $20, $20, $20, $20, $4E, $49
	db $4E, $54, $45, $4E, $44, $4F, $20, $20, $20, $20, $20, $20, $20, $F1, $F1, $F1
	db $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $F1, $20, $20
	db $20, $20, $20, $21, $22, $23, $20, $24, $25, $20, $26, $20, $20, $20, $20, $20
	db $20, $20, $20, $20, $20, $20, $20, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $20
	db $20, $20, $20, $20, $20, $20, $F1, $F1, $F1, $F1, $F1, $20, $20, $54, $49, $4D
	db $45, $20, $20, $20, $1B, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $F1
	db $F1, $F1, $F0, $F7, $FF, $76, $E7, $F7, $6F, $75, $6F, $52, $7B, $77, $5F, $75
	db $7B, $9F, $B7, $F5, $DF, $57, $DD, $7C, $78, $2C, $FF, $67, $F3, $77, $EF, $FF
	db $04, $30, $41, $00, $04, $00, $56, $41, $23, $22, $15, $01, $11, $04, $5D, $21
	db $22, $24, $00, $D1, $00, $01, $67, $04, $00, $40, $05, $24, $00, $22, $05, $60
	db $13, $64, $02, $14, $80, $4C, $82, $0E, $40, $10, $00, $01, $30, $34, $60, $04
	db $00, $20, $0A, $04, $60, $2C, $48, $09, $20, $06, $44, $90, $00, $61, $00, $0D
	db $A7, $42, $01, $0A, $20, $14, $00, $45, $21, $41, $2E, $01, $30, $47, $30, $40
	db $81, $80, $41, $48, $0B, $21, $02, $00, $23, $61, $37, $13, $20, $27, $41, $70
	db $12, $01, $00, $01, $81, $10, $55, $08, $02, $46, $54, $0E, $00, $04, $80, $42
	db $32, $00, $04, $04, $40, $01, $03, $82, $01, $33, $43, $20, $13, $80, $22, $00
	db $B8, $FD, $B9, $77, $FF, $2D, $B5, $D6, $FF, $5B, $BF, $37, $F7, $5E, $3F, $F7
	db $AD, $75, $57, $B7, $7D, $73, $D5, $EF, $F5, $67, $F7, $5B, $F7, $7E, $F7, $F7
	db $73, $7F, $FF, $67, $77, $67, $FF, $77, $E7, $3C, $DE, $DF, $D6, $2B, $7B, $D6
	db $AD, $3F, $F7, $3D, $BF, $D7, $FF, $37, $31, $F3, $FB, $F7, $7D, $6D, $DB, $F7
	db $77, $EF, $75, $BF, $7F, $FD, $BF, $7D, $F7, $37, $76, $5A, $FF, $D7, $F9, $E7
	db $38, $F7, $33, $DA, $F9, $DA, $FF, $7F, $ED, $5F, $67, $77, $F1, $A6, $DF, $F2
	db $57, $9F, $33, $5D, $25, $FD, $79, $FF, $FB, $F6, $EF, $6D, $FF, $7D, $F5, $FF
	db $FF, $77, $66, $FF, $AF, $E7, $73, $7F, $71, $95, $5B, $7D, $5E, $F7, $7F, $33
	db $00, $04, $19, $90, $40, $11, $45, $41, $40, $41, $10, $2D, $20, $06, $28, $00
	db $25, $35, $60, $04, $28, $40, $44, $11, $23, $50, $04, $10, $30, $10, $45, $83
	db $20, $44, $24, $34, $00, $00, $45, $57, $00, $40, $10, $18, $00, $02, $14, $36
	db $04, $08, $30, $20, $55, $38, $09, $00, $01, $84, $41, $00, $69, $20, $29, $03
	db $54, $25, $14, $14, $22, $51, $42, $40, $01, $51, $10, $67, $21, $00, $60, $11
	db $80, $12, $21, $E0, $34, $C1, $00, $30, $28, $80, $14, $10, $64, $02, $40, $40
	db $8A, $82, $40, $08, $50, $55, $60, $25, $2E, $40, $40, $84, $04, $07, $02, $40
	db $24, $00, $01, $40, $40, $10, $03, $16, $09, $2C, $40, $47, $10, $02, $41, $40
	db $BF, $FF, $CF, $7F, $FB, $EB, $FF, $EF, $59, $EB, $A3, $7F, $9F, $FE, $75, $F5
	db $9F, $EF, $CF, $BB, $6E, $F6, $FC, $C7, $ED, $CF, $D5, $FF, $EF, $FF, $EF, $CF
	db $FF, $7D, $FF, $FE, $4D, $CF, $EF, $6B, $F1, $6F, $EE, $FF, $EF, $6D, $65, $77
	db $3F, $FF, $BE, $FF, $6E, $CF, $ED, $F7, $CA, $FC, $B7, $FF, $FF, $F8, $ED, $AA
	db $DF, $5F, $D3, $AF, $CF, $FD, $6D, $F1, $EF, $FD, $77, $F9, $B3, $9E, $5F, $E7
	db $E7, $FF, $F7, $DE, $06, $EA, $FC, $9F, $FE, $FF, $A7, $BF, $FF, $BE, $76, $38
	db $FC, $CF, $FD, $BD, $AE, $FE, $F3, $DF, $CB, $D7, $B7, $E6, $F7, $FF, $F9, $B2
	db $6D, $EF, $6F, $CF, $AD, $BF, $BD, $4F, $BF, $BE, $79, $97, $DD, $F6, $F3, $E6
	db $10, $80, $2A, $32, $68, $81, $A0, $15, $04, $F0, $81, $C4, $E5, $06, $0D, $C5
	db $41, $30, $00, $81, $00, $90, $01, $40, $B4, $18, $00, $11, $05, $04, $C0, $00
	db $21, $1B, $20, $25, $18, $24, $88, $98, $01, $40, $8F, $28, $3C, $42, $EB, $08
	db $A0, $42, $54, $A4, $0D, $41, $C0, $06, $06, $43, $49, $00, $65, $80, $40, $00
	db $0C, $14, $40, $25, $22, $45, $40, $03, $A0, $3D, $8C, $48, $A0, $00, $50, $B0
	db $62, $03, $41, $80, $C4, $44, $A0, $49, $A0, $58, $46, $52, $82, $10, $40, $15
	db $8E, $49, $83, $41, $24, $55, $40, $22, $08, $05, $40, $20, $10, $43, $96, $14
	db $29, $12, $08, $84, $80, $10, $A0, $8D, $26, $79, $70, $D4, $21, $01, $80, $06
	db $7B, $BF, $AF, $FE, $BE, $FD, $EE, $BF, $FD, $BB, $FD, $FF, $F6, $85, $30, $FF
	db $DF, $FE, $AF, $3C, $F7, $FD, $FE, $FD, $FB, $F7, $E7, $F5, $FF, $FE, $DB, $7E
	db $DF, $7F, $FF, $BD, $63, $FF, $EF, $DF, $FB, $9F, $FE, $1E, $DC, $FE, $7F, $FD
	db $FF, $FF, $BF, $7B, $FF, $EF, $BF, $DE, $7A, $7A, $D4, $F9, $AF, $B7, $AA, $BF
	db $FB, $4D, $BB, $FD, $FF, $FF, $FF, $BB, $B9, $7F, $FA, $DD, $FF, $7F, $7C, $5D
	db $79, $FF, $FD, $1F, $9B, $6F, $9B, $6B, $7B, $EE, $FA, $A7, $FF, $5F, $E9, $8F
	db $ED, $9E, $FF, $B7, $BE, $FB, $DB, $3B, $AF, $FC, $BF, $FD, $7F, $7F, $DB, $CD
	db $AD, $BB, $DF, $FF, $28, $CF, $7B, $FD, $FC, $4E, $FE, $FC, $FD, $F7, $F7, $7F
	db $09, $00, $20, $14, $10, $0D, $38, $34, $D5, $42, $45, $2A, $60, $40, $80, $18
	db $1C, $10, $E4, $00, $01, $0C, $04, $0C, $0C, $66, $80, $04, $04, $7D, $20, $50
	db $00, $80, $00, $20, $33, $18, $40, $01, $22, $89, $02, $22, $42, $10, $0B, $22
	db $29, $13, $95, $D0, $8D, $10, $40, $05, $78, $18, $90, $00, $48, $D4, $42, $20
	db $00, $9A, $02, $00, $40, $08, $8A, $04, $10, $01, $4C, $82, $6A, $05, $46, $08
	db $80, $E0, $00, $13, $B2, $30, $19, $24, $44, $18, $08, $94, $1D, $64, $84, $82
	db $0E, $28, $20, $30, $29, $80, $10, $94, $01, $86, $F4, $44, $05, $40, $9A, $1C
	db $E2, $A1, $20, $41, $06, $15, $AA, $81, $48, $00, $02, $14, $05, $DA, $02, $70
	db $DF, $95, $72, $FF, $3E, $F9, $4F, $7F, $3A, $F3, $FB, $FD, $B2, $66, $5F, $BF
	db $F3, $FC, $F9, $79, $7F, $F7, $FF, $EE, $CD, $7B, $FC, $EF, $75, $F8, $ED, $DF
	db $B5, $FE, $FF, $F7, $DF, $FF, $CB, $7F, $EB, $FB, $7D, $CF, $7B, $FF, $FF, $FD
	db $9F, $1F, $B5, $1E, $FC, $68, $FF, $EF, $7F, $F7, $FB, $E7, $FD, $AA, $99, $C4
	db $B0, $EE, $EF, $B6, $1C, $6E, $F9, $F3, $BB, $BF, $FD, $FE, $73, $6D, $7B, $DC
	db $7F, $FD, $EB, $6E, $3C, $EE, $EB, $DF, $FB, $6F, $7B, $FB, $FA, $5E, $6C, $B6
	db $BC, $73, $FF, $79, $BF, $F7, $FC, $CF, $FF, $DF, $BF, $FB, $FB, $19, $F5, $6D
	db $E7, $FF, $AF, $AD, $DE, $0D, $A7, $E8, $F3, $BF, $7F, $E3, $FF, $FF, $F6, $7F
	db $29, $1C, $60, $5D, $0A, $09, $06, $08, $37, $54, $38, $C8, $42, $A2, $A9, $13
	db $C5, $06, $C0, $90, $01, $00, $11, $14, $C8, $40, $00, $15, $44, $70, $70, $10
	db $20, $00, $B2, $19, $00, $58, $48, $0D, $01, $08, $10, $10, $12, $19, $40, $00
	db $A0, $04, $00, $CE, $02, $10, $92, $25, $5A, $F0, $C1, $A0, $87, $72, $03, $46
	db $18, $34, $01, $AC, $65, $A0, $48, $90, $04, $06, $50, $24, $88, $48, $19, $81
	db $03, $20, $02, $24, $AD, $01, $C0, $41, $38, $92, $41, $98, $40, $40, $0E, $04
	db $34, $00, $02, $01, $49, $63, $41, $41, $E2, $41, $20, $05, $40, $00, $20, $65
	db $0A, $08, $00, $86, $BB, $44, $A4, $05, $C2, $1C, $09, $10, $01, $14, $64, $63
	db $2B, $FF, $B5, $CF, $DE, $EA, $54, $FF, $FF, $BE, $F5, $6E, $FB, $9F, $47, $FD
	db $8E, $E7, $2F, $1F, $E7, $DA, $BF, $F7, $FE, $FF, $F6, $FF, $D7, $F9, $FF, $DF
	db $7A, $BF, $FF, $6F, $E7, $62, $AD, $FF, $BF, $7B, $7F, $7F, $79, $DF, $F6, $D9
	db $FB, $ED, $FF, $7F, $FD, $FF, $B4, $FF, $AF, $FE, $AC, $5D, $F2, $F6, $07, $DF
	db $D3, $F7, $9D, $EE, $ED, $DD, $FB, $7D, $6E, $7D, $AD, $FF, $DB, $5D, $BC, $EE
	db $FA, $7D, $6D, $FD, $DF, $7D, $DF, $FC, $EB, $DF, $7F, $7F, $F6, $7F, $EB, $F7
	db $E1, $DC, $8F, $DF, $5D, $F3, $73, $D9, $EF, $5F, $FF, $FC, $F7, $DE, $5F, $BF
	db $DB, $BD, $EF, $BD, $7F, $FD, $FF, $D7, $FE, $97, $DF, $6F, $FF, $EF, $DA, $FC
	db $10, $B5, $65, $85, $0B, $02, $00, $34, $02, $00, $80, $00, $04, $D0, $00, $4B
	db $60, $02, $18, $28, $01, $00, $01, $13, $58, $52, $88, $55, $42, $58, $98, $10
	db $10, $D4, $96, $43, $00, $1A, $01, $C8, $0C, $41, $34, $01, $A0, $42, $84, $0D
	db $02, $00, $15, $86, $22, $05, $21, $84, $02, $10, $42, $01, $9C, $94, $08, $04
	db $B5, $33, $04, $81, $03, $60, $C1, $10, $88, $05, $51, $80, $80, $68, $44, $50
	db $C0, $04, $C1, $00, $0A, $15, $A2, $29, $44, $1B, $21, $82, $0A, $21, $00, $40
	db $08, $40, $00, $1E, $80, $90, $00, $78, $23, $05, $02, $14, $98, $50, $7D, $15
	db $10, $34, $42, $04, $18, $A4, $28, $15, $04, $48, $A1, $42, $22, $25, $02, $C5
	db $F5, $FE, $EE, $FE, $FF, $BB, $FF, $BF, $D8, $FE, $BF, $5F, $F7, $57, $AF, $FF
	db $C3, $FF, $7D, $F3, $D9, $FB, $BA, $D3, $33, $FF, $BF, $FD, $BB, $FE, $7D, $F7
	db $BB, $FF, $FF, $FD, $BE, $6F, $6A, $F7, $FB, $F5, $F7, $F3, $BC, $BF, $ED, $BB
	db $FB, $8F, $B7, $95, $DF, $DB, $FF, $53, $FD, $3D, $BE, $F7, $F2, $AF, $FB, $B7
	db $A2, $FE, $E5, $BF, $99, $AF, $D3, $BF, $E6, $9F, $E9, $E5, $37, $7E, $FE, $3F
	db $FF, $A7, $CF, $77, $79, $7D, $BD, $D7, $7D, $39, $F7, $BF, $F5, $BE, $FE, $FF
	db $9F, $FD, $7D, $BF, $FE, $97, $DF, $E6, $EF, $FF, $E8, $67, $E6, $3F, $4A, $77
	db $FF, $9F, $FA, $AA, $C2, $DF, $93, $EF, $DF, $FF, $BD, $FF, $7B, $FD, $F9, $B9
	db $04, $98, $00, $90, $00, $10, $51, $8E, $20, $62, $20, $52, $00, $A3, $9B, $82
	db $CA, $54, $58, $00, $80, $00, $02, $3E, $A1, $48, $72, $C0, $18, $18, $03, $20
	db $03, $43, $55, $0F, $34, $01, $64, $80, $30, $29, $19, $8C, $24, $20, $43, $24
	db $E8, $21, $04, $18, $28, $CC, $40, $91, $84, $00, $29, $60, $49, $44, $42, $69
	db $38, $95, $40, $50, $90, $C9, $04, $F4, $A1, $A0, $66, $01, $58, $44, $C8, $D1
	db $10, $03, $2C, $CC, $14, $02, $04, $88, $12, $B8, $05, $53, $BA, $06, $70, $4A
	db $A0, $C4, $9B, $00, $4F, $A0, $C1, $81, $C8, $01, $88, $52, $22, $14, $A0, $08
	db $18, $01, $10, $01, $01, $80, $82, $80, $5C, $C7, $00, $80, $21, $58, $08, $01
	db $FF, $BE, $BF, $E8, $76, $D9, $E3, $FF, $E2, $ED, $F5, $FE, $36, $4D, $D7, $E3
	db $FD, $F5, $C6, $D7, $E7, $CF, $5F, $DF, $BD, $5E, $BD, $F7, $AB, $2F, $FD, $BF
	db $E9, $BF, $3F, $76, $FF, $EF, $DE, $BB, $7D, $F7, $9F, $F9, $FB, $FF, $7F, $DF
	db $B7, $E7, $BF, $BF, $9E, $DB, $FB, $AE, $FF, $EF, $CE, $FB, $EF, $F7, $DE, $51
	db $BD, $6F, $F7, $67, $FF, $E6, $FE, $7F, $FF, $7F, $F7, $F6, $EB, $3D, $FC, $FF
	db $45, $54, $FB, $FF, $F9, $EF, $FF, $BF, $CF, $FF, $E7, $FF, $77, $BF, $81, $7B
	db $7F, $5B, $E7, $BF, $F7, $FF, $FF, $45, $EF, $1D, $DF, $FF, $D3, $CF, $FB, $E7
	db $BE, $FE, $F8, $FD, $1F, $D6, $DE, $D9, $EF, $77, $FF, $FE, $DA, $DF, $FF, $75
	db $30, $1A, $4A, $05, $F1, $D4, $04, $0B, $05, $1C, $44, $F7, $21, $55, $18, $60
	db $20, $81, $20, $06, $40, $01, $04, $10, $02, $14, $02, $04, $20, $44, $26, $40
	db $03, $45, $0C, $80, $64, $0A, $04, $A1, $84, $00, $50, $CA, $04, $D0, $87, $14
	db $68, $40, $14, $52, $88, $54, $8A, $29, $20, $01, $28, $12, $01, $A3, $10, $01
	db $81, $0C, $08, $01, $20, $42, $03, $06, $01, $1C, $10, $40, $0A, $81, $B0, $61
	db $00, $12, $08, $00, $98, $01, $00, $08, $89, $59, $5E, $09, $82, $60, $41, $34
	db $04, $80, $04, $11, $11, $84, $2D, $A2, $00, $57, $4C, $04, $17, $04, $10, $AC
	db $8B, $14, $94, $38, $00, $A2, $00, $C1, $C9, $01, $35, $11, $12, $4D, $32, $18
	db $BD, $7D, $6B, $F8, $FA, $9F, $CF, $DF, $5A, $77, $5C, $D7, $7F, $F6, $FD, $FD
	db $F7, $7A, $5E, $FF, $FF, $D7, $3F, $77, $7F, $FD, $1E, $3D, $CF, $DD, $9D, $D7
	db $AE, $F8, $FA, $FF, $2F, $DF, $BF, $CF, $BF, $D7, $6D, $2C, $BF, $77, $CD, $FF
	db $FE, $85, $FF, $F7, $C6, $EF, $F5, $1E, $F9, $FF, $FF, $EF, $55, $F6, $2F, $FB
	db $FF, $DF, $7F, $AF, $F6, $7C, $BF, $BB, $FF, $EB, $F6, $7E, $FF, $FE, $CD, $FD
	db $EF, $FF, $6F, $FF, $FC, $FF, $FF, $9F, $FF, $FE, $FE, $5F, $FF, $76, $72, $6D
	db $EF, $F7, $FF, $FF, $7F, $DF, $DF, $53, $DF, $DE, $C2, $FF, $FF, $FF, $FA, $B7
	db $DF, $DF, $FF, $6D, $EF, $D5, $FB, $04, $AF, $F7, $BF, $7F, $DE, $EF, $FB, $95
	db $1A, $20, $A0, $05, $C4, $98, $14, $52, $D4, $02, $14, $31, $08, $24, $21, $90
	db $20, $04, $82, $0A, $10, $00, $18, $0E, $21, $C4, $04, $10, $08, $08, $30, $12
	db $09, $04, $A1, $81, $10, $98, $94, $42, $1A, $11, $22, $25, $31, $C1, $4E, $64
	db $A2, $6C, $13, $20, $52, $00, $24, $85, $4A, $24, $20, $40, $45, $84, $49, $00
	db $10, $16, $36, $D7, $24, $14, $80, $12, $A8, $00, $04, $45, $A0, $11, $09, $0B
	db $26, $00, $00, $4A, $40, $51, $20, $11, $04, $21, $05, $50, $48, $3B, $71, $08
	db $95, $81, $09, $60, $02, $11, $52, $10, $80, $00, $22, $03, $00, $70, $10, $44
	db $3C, $18, $4D, $24, $88, $68, $20, $20, $30, $80, $02, $10, $16, $02, $8C, $48
	db $7B, $F5, $EF, $EB, $DE, $97, $8E, $DD, $1E, $35, $95, $DE, $FF, $FB, $FB, $F9
	db $BD, $B7, $BB, $DD, $D7, $D7, $5F, $CF, $1F, $77, $D7, $FE, $E7, $FD, $F7, $FC
	db $F7, $FF, $1F, $DF, $FF, $74, $EB, $7D, $BF, $EF, $7D, $FE, $EF, $B5, $FD, $5A
	db $F7, $FF, $B8, $E7, $FB, $BF, $DE, $7F, $F7, $67, $F4, $7F, $AD, $DF, $7F, $B7
	db $F7, $DA, $75, $8E, $7F, $F2, $DD, $F6, $AF, $EB, $F8, $B7, $55, $3B, $DB, $BB
	db $FF, $D4, $FA, $7F, $7F, $FB, $FE, $6F, $BF, $74, $6F, $FF, $9F, $B9, $DB, $FF
	db $BF, $FF, $F7, $7F, $BD, $7E, $FD, $7F, $5F, $47, $57, $7F, $EA, $9E, $DE, $7F
	db $BF, $CF, $FF, $17, $FF, $7B, $3E, $1D, $3F, $FF, $FF, $F4, $B3, $8B, $ED, $FD
	db $20, $04, $30, $00, $48, $44, $80, $11, $0D, $0C, $40, $14, $63, $59, $C1, $19
	db $B4, $04, $44, $24, $D3, $10, $00, $08, $01, $11, $80, $40, $86, $55, $22, $1D
	db $8A, $21, $51, $A9, $00, $21, $16, $00, $E1, $14, $22, $65, $23, $45, $42, $5C
	db $22, $00, $14, $49, $09, $07, $98, $06, $15, $39, $64, $05, $54, $BE, $20, $00
	db $04, $00, $20, $95, $18, $C5, $24, $1C, $0C, $1E, $C5, $44, $00, $0D, $84, $51
	db $10, $60, $6D, $01, $04, $4C, $C8, $05, $23, $01, $08, $05, $C1, $30, $46, $01
	db $48, $80, $3A, $4C, $13, $35, $33, $0C, $02, $84, $08, $86, $01, $60, $50, $3A
	db $0A, $28, $02, $44, $40, $44, $20, $30, $14, $44, $81, $45, $24, $31, $87, $78
	db $8E, $32, $FE, $FD, $B9, $ED, $C6, $EF, $9E, $E3, $F4, $FF, $EF, $FD, $FF, $6D
	db $E4, $FF, $AE, $CC, $3A, $CE, $7B, $FF, $F7, $7F, $BE, $E5, $FC, $CE, $2C, $EB
	db $FE, $CB, $24, $62, $6F, $FE, $EE, $BF, $EF, $5A, $B2, $FF, $FF, $6F, $FF, $BF
	db $FF, $AD, $AA, $D5, $EE, $FB, $0B, $FF, $DC, $B7, $EB, $F6, $B9, $FC, $FF, $EF
	db $AB, $FB, $BF, $B8, $3E, $ED, $FF, $92, $8A, $FB, $7E, $F7, $BA, $9E, $FB, $8B
	db $E8, $6F, $AE, $6F, $EF, $DF, $E6, $E7, $FD, $ED, $FE, $9E, $77, $E8, $F7, $F0
	db $CF, $67, $7E, $ED, $B7, $F2, $BD, $AE, $FC, $EE, $BE, $F4, $FF, $F4, $CB, $FC
	db $BF, $FC, $AF, $A6, $D5, $AF, $F3, $ED, $FC, $7C, $E7, $CE, $BE, $ED, $CF, $ED
	db $88, $C3, $0A, $10, $80, $00, $00, $40, $44, $22, $40, $80, $20, $18, $22, $98
	db $14, $04, $12, $A0, $8B, $55, $C0, $08, $52, $40, $60, $58, $05, $01, $EC, $14
	db $88, $07, $63, $44, $08, $C0, $4A, $0C, $00, $C0, $8C, $49, $15, $40, $10, $08
	db $00, $00, $64, $22, $B2, $22, $C4, $73, $88, $22, $40, $A0, $46, $06, $2B, $69
	db $C8, $04, $86, $01, $08, $08, $08, $20, $41, $22, $A0, $00, $81, $40, $02, $64
	db $20, $80, $10, $04, $22, $01, $24, $22, $0A, $0A, $11, $00, $A8, $A0, $40, $44
	db $20, $3C, $A2, $60, $41, $02, $92, $C2, $80, $AA, $02, $08, $80, $08, $04, $06
	db $48, $10, $46, $08, $20, $23, $48, $22, $4A, $0E, $5C, $20, $00, $02, $29, $32
	db $FF, $83, $AE, $FB, $F3, $CE, $7F, $DF, $AE, $04, $BE, $F6, $BA, $86, $CE, $FE
	db $FB, $F6, $EF, $7E, $E7, $CE, $FB, $FE, $FA, $FB, $DF, $0E, $C5, $EC, $F9, $78
	db $AE, $67, $E6, $6D, $AE, $BB, $8F, $DF, $EE, $7F, $FF, $FF, $FE, $76, $AE, $EB
	db $EA, $EA, $E7, $F7, $FF, $FE, $F7, $DF, $AA, $FF, $FC, $DE, $FF, $B3, $FF, $7D
	db $F6, $EF, $FA, $FA, $5E, $EF, $FE, $CD, $2C, $DB, $FC, $5F, $EF, $46, $ED, $ED
	db $76, $7F, $CE, $EB, $EF, $D2, $F2, $C5, $4E, $F7, $FA, $EF, $FE, $3E, $F8, $E7
	db $E2, $B7, $DD, $DF, $FE, $9E, $9F, $77, $B4, $3E, $37, $FE, $FC, $FB, $BE, $65
	db $DF, $FF, $F8, $73, $FC, $7C, $7E, $4D, $EE, $6E, $AD, $4A, $FB, $EF, $EE, $FF
	db $80, $80, $80, $49, $22, $80, $02, $20, $A0, $0C, $29, $D4, $C2, $00, $22, $42
	db $5A, $50, $44, $34, $82, $24, $40, $26, $08, $40, $00, $12, $48, $27, $00, $00
	db $20, $20, $24, $60, $40, $84, $A6, $10, $06, $02, $04, $4A, $00, $00, $C0, $24
	db $06, $04, $40, $91, $C1, $60, $91, $00, $08, $AD, $06, $09, $08, $89, $4A, $80
	db $40, $06, $80, $08, $20, $00, $A1, $27, $00, $8D, $C0, $02, $0D, $44, $34, $00
	db $20, $AA, $08, $14, $84, $02, $60, $04, $E0, $00, $86, $08, $10, $A7, $40, $42
	db $44, $08, $41, $CC, $48, $14, $20, $08, $A2, $70, $02, $50, $1E, $21, $4A, $84
	db $6A, $14, $28, $68, $0A, $0C, $22, $80, $12, $4C, $04, $03, $E8, $44, $00, $72
	db $4F, $FF, $DD, $C7, $FD, $E7, $6E, $75, $7E, $4F, $E5, $5E, $EF, $7E, $6D, $EB
	db $BE, $E5, $BA, $EB, $F7, $DF, $BF, $9F, $FF, $FC, $FF, $33, $FE, $6E, $AE, $FF
	db $DF, $4C, $CF, $EF, $FE, $FE, $CA, $FF, $36, $BF, $66, $ED, $F6, $EE, $E9, $6E
	db $DE, $6C, $FC, $FB, $FA, $F7, $9A, $DB, $EE, $CF, $79, $6D, $7C, $45, $EF, $3E
	db $A8, $FA, $6E, $EF, $AF, $51, $FF, $5E, $CE, $4F, $EF, $FF, $78, $6B, $FE, $8E
	db $EE, $D7, $EF, $DC, $DD, $DF, $7B, $FF, $DF, $AB, $97, $CE, $FE, $EF, $77, $AF
	db $F7, $F6, $7E, $FE, $ED, $FE, $CB, $EF, $EE, $EB, $E7, $7E, $FF, $BD, $FF, $EF
	db $9F, $FE, $4B, $EE, $EB, $FF, $FF, $9F, $DE, $DE, $BE, $EE, $FE, $FE, $D9, $67
	db $1A, $90, $E4, $48, $04, $01, $00, $28, $02, $26, $CC, $40, $00, $24, $00, $03
	db $40, $38, $23, $42, $48, $11, $C0, $C6, $09, $06, $08, $40, $09, $6A, $04, $00
	db $20, $00, $08, $8A, $48, $10, $82, $26, $21, $08, $04, $A4, $02, $80, $00, $0C
	db $90, $94, $62, $B5, $6E, $2E, $92, $00, $E0, $02, $48, $02, $08, $80, $C8, $16
	db $06, $00, $28, $40, $23, $84, $04, $48, $04, $76, $60, $81, $00, $04, $04, $80
	db $08, $20, $8E, $00, $08, $0C, $71, $41, $E0, $2A, $62, $42, $24, $50, $04, $81
	db $84, $40, $82, $56, $00, $14, $06, $64, $40, $20, $85, $08, $42, $44, $20, $01
	db $0A, $82, $8A, $DC, $8A, $22, $07, $80, $29, $44, $A0, $8A, $42, $48, $0C, $AE
	db $67, $F8, $7A, $FA, $DF, $FE, $E3, $DF, $BA, $B3, $DA, $A9, $E7, $FF, $EA, $DB
	db $BF, $FE, $EF, $D7, $E6, $FF, $FE, $77, $DE, $3F, $D7, $59, $7F, $A2, $6F, $95
	db $B2, $BE, $E7, $57, $EF, $FF, $F3, $FE, $FE, $BB, $BD, $D7, $FD, $FD, $6F, $DF
	db $EF, $6F, $FE, $7C, $FF, $DE, $EE, $7F, $BB, $DF, $D1, $BA, $B7, $D9, $FF, $EF
	db $6F, $FD, $7F, $BE, $7D, $EF, $FF, $FD, $7F, $FE, $AF, $FF, $FB, $57, $7E, $FD
	db $AD, $FF, $53, $FF, $FD, $FE, $6F, $E5, $3E, $DF, $BE, $7A, $EA, $FE, $A7, $7B
	db $7D, $FF, $BB, $9E, $EF, $DE, $FD, $3E, $FF, $9B, $9F, $AF, $EF, $DD, $FA, $FB
	db $B7, $CF, $D7, $F7, $AB, $F7, $E3, $DF, $FB, $7E, $D7, $DE, $BB, $6F, $FF, $A5
	db $08, $00, $04, $14, $48, $11, $03, $50, $80, $04, $08, $74, $02, $00, $10, $01
	db $62, $8C, $10, $0E, $46, $50, $0F, $20, $41, $10, $00, $40, $04, $4E, $64, $A2
	db $82, $22, $48, $10, $0B, $10, $86, $00, $00, $59, $02, $30, $70, $08, $14, $05
	db $80, $15, $0A, $C1, $12, $90, $84, $C7, $40, $86, $02, $00, $00, $0A, $92, $00
	db $A0, $44, $42, $52, $80, $11, $2F, $84, $54, $30, $92, $3F, $D3, $0B, $00, $55
	db $02, $20, $68, $28, $00, $41, $01, $04, $94, $02, $05, $10, $37, $41, $31, $63
	db $00, $14, $C4, $19, $00, $01, $10, $14, $10, $61, $34, $7A, $00, $11, $98, $10
	db $08, $52, $48, $43, $34, $4F, $12, $58, $30, $33, $03, $04, $85, $91, $0D, $39



SECTION "bank07", ROMX, BANK[$07]


GFX_TilesetLevel1: ;$1C000
INCBIN "gfx/tilesets/level1.2bpp"

GFX_TilesetTreeZone1: ;$1C600
INCBIN "gfx/tilesets/treezone1.2bpp"

GFX_TilesetTreeZone2: ;$1CC00
INCBIN "gfx/tilesets/treezone2.2bpp"

GFX_TilesetTreeZone3: ;$1D200
INCBIN "gfx/tilesets/treezone3.2bpp"

GFX_TilesetTreeZone4: ;$1D800
INCBIN "gfx/tilesets/treezone4.2bpp"

GFX_TilesetTreeZone5: ;$1DE00
INCBIN "gfx/tilesets/treezone5.2bpp"

GFX_TilesetTreeZoneBoss: ;$1E400
INCBIN "gfx/tilesets/treezoneboss.2bpp"

GFX_TilesetTreeZoneExtra: ;$1EA00
INCBIN "gfx/tilesets/treezone_extra.2bpp"



SECTION "bank08", ROMX, BANK[$08]


Level_TileMap_01: ;$20000
INCBIN "tilemaps/mappings/01.bin"

Level_TileMap_02: ;$20200
INCBIN "tilemaps/mappings/02.bin"

Level_TileMap_03: ;$20400
INCBIN "tilemaps/mappings/03.bin"

Level_TileMap_04: ;$20600
INCBIN "tilemaps/mappings/04.bin"

Level_TileMap_05: ;$20800
INCBIN "tilemaps/mappings/05.bin"

Level_TileMap_06: ;$20A00
INCBIN "tilemaps/mappings/06.bin"

Level_TileMap_07: ;$20C00
INCBIN "tilemaps/mappings/07.bin"

Level_TileMap_08: ;$20E00
INCBIN "tilemaps/mappings/08.bin"

Level_TileMap_09: ;$21000
INCBIN "tilemaps/mappings/09.bin"

Level_TileMap_10: ;$21200
INCBIN "tilemaps/mappings/10.bin"

Level_TileMap_11: ;$21400
INCBIN "tilemaps/mappings/11.bin"

Level_TileMap_12: ;$21600
INCBIN "tilemaps/mappings/12.bin"

Level_TileMap_13: ;$21800
INCBIN "tilemaps/mappings/13.bin"

Level_TileMap_14: ;$21A00
INCBIN "tilemaps/mappings/14.bin"

Level_TileMap_15: ;$21C00
INCBIN "tilemaps/mappings/15.bin"

Level_TileMap_16: ;$21E00
INCBIN "tilemaps/mappings/16.bin"

Level_TileMap_17: ;$22000
INCBIN "tilemaps/mappings/17.bin"

Level_TileMap_18: ;$22200
INCBIN "tilemaps/mappings/18.bin"

Level_TileMap_19: ;$22400
INCBIN "tilemaps/mappings/19.bin"

Level_TileMap_20: ;$22600
INCBIN "tilemaps/mappings/20.bin"

Level_TileMap_21: ;$22800
INCBIN "tilemaps/mappings/21.bin"

Level_TileMap_22: ;$22A00
INCBIN "tilemaps/mappings/22.bin"

Level_TileMap_23: ;$22C00
INCBIN "tilemaps/mappings/23.bin"

Level_TileMap_24: ;$22E00
INCBIN "tilemaps/mappings/24.bin"

Level_TileMap_25: ;$23000
INCBIN "tilemaps/mappings/25.bin"

Level_TileMap_26: ;$23200
INCBIN "tilemaps/mappings/26.bin"

Level_TileMap_27: ;$23400
INCBIN "tilemaps/mappings/27.bin"

Level_TileMap_28: ;$23600
INCBIN "tilemaps/mappings/28.bin"

UnknownData_0x23800: ;level-layout-like data (0xAA-heavy), unclassified
	db $BF, $EF, $AE, $AB, $F3, $BB, $EB, $EB, $DF, $FF, $8E, $AB, $BD, $BB, $BA, $AB
	db $BE, $AA, $EE, $AF, $AA, $EB, $FA, $AF, $AA, $EF, $AB, $F2, $FA, $4E, $EB, $AE
	db $AA, $FE, $FA, $FE, $BC, $EF, $EF, $DA, $EC, $EB, $D8, $FF, $AA, $FE, $E9, $FA
	db $AA, $AA, $AF, $BF, $BA, $EA, $FB, $FF, $F2, $EA, $BE, $2E, $BE, $BE, $EF, $AB
	db $27, $DA, $BB, $FE, $A8, $AA, $F6, $A2, $BB, $8B, $FB, $2C, $EE, $A2, $EB, $BB
	db $EF, $7A, $AE, $AE, $48, $EB, $EF, $B3, $82, $BE, $3B, $FC, $3E, $EB, $FA, $BE
	db $ED, $EF, $CE, $EA, $AB, $BB, $FB, $FE, $EA, $36, $B8, $7F, $EA, $BB, $AE, $FA
	db $EB, $8B, $AB, $AE, $AB, $EF, $EA, $EA, $E2, $9B, $CF, $EA, $F8, $BA, $FB, $FA
	db $C8, $0A, $A8, $2A, $08, $2A, $82, $AA, $80, $08, $8A, $82, $A2, $20, $8B, $6A
	db $DA, $0C, $02, $A2, $00, $22, $88, $28, $26, $2B, $A4, $AA, $0A, $6A, $0A, $88
	db $EA, $3E, $83, $A0, $18, $AA, $8A, $22, $A8, $22, $88, $82, $A2, $BA, $A8, $28
	db $AC, $AA, $AA, $A8, $A2, $B8, $22, $AA, $AA, $02, $2C, $2A, $A0, $0A, $22, $29
	db $28, $82, $8A, $88, $AA, $22, $A2, $82, $8A, $F2, $88, $A8, $CA, $C2, $00, $A9
	db $EA, $30, $01, $0E, $8A, $84, $A2, $AA, $A0, $6A, $2A, $2A, $88, $C8, $0A, $68
	db $81, $AA, $8C, $20, $A2, $AA, $08, $2B, $08, $22, $E0, $A8, $20, $84, $A2, $E0
	db $28, $02, $68, $A8, $0A, $22, $3A, $A0, $2A, $BA, $22, $AB, $0B, $8A, $0A, $2A
	db $EE, $F9, $48, $8B, $B6, $EA, $A9, $AC, $EA, $FE, $BB, $E7, $BE, $B3, $CD, $AB
	db $FF, $FE, $FB, $AE, $AA, $FA, $FE, $EE, $EB, $AE, $DE, $EF, $AE, $BD, $AF, $EA
	db $6A, $BF, $EB, $F6, $BF, $FA, $AB, $6C, $6B, $EE, $EE, $A6, $AC, $B7, $FA, $FC
	db $D3, $FE, $AA, $AA, $EA, $DB, $F6, $FE, $CB, $AA, $FB, $EB, $EA, $BA, $CB, $EA
	db $AA, $AF, $BE, $9D, $6E, $BF, $E6, $AE, $6F, $FA, $AA, $AA, $AB, $EE, $DB, $6A
	db $AF, $9E, $BF, $FF, $EF, $EF, $BE, $AB, $AE, $E8, $B2, $2F, $DE, $FA, $3E, $BF
	db $BA, $EA, $AB, $FB, $FF, $3B, $AE, $BB, $7A, $BE, $7D, $AF, $2A, $AA, $AF, $FB
	db $EA, $EB, $FE, $EA, $FA, $EF, $2A, $BB, $EA, $AA, $BF, $8B, $BE, $EE, $E7, $AF
	db $82, $C0, $A2, $08, $80, $28, $6C, $A2, $80, $B0, $86, $AA, $27, $02, $22, $A2
	db $8E, $08, $88, $AA, $16, $0A, $28, $22, $22, $C8, $90, $28, $82, $6A, $A1, $A8
	db $A3, $A0, $A2, $29, $88, $0A, $AA, $A2, $A8, $82, $80, $22, $89, $02, $22, $88
	db $A0, $A1, $98, $A2, $3A, $90, $EA, $68, $A1, $BA, $08, $A8, $26, $08, $AA, $88
	db $02, $0A, $44, $20, $A2, $1A, $80, $1A, $83, $81, $2E, $2F, $3A, $27, $AA, $AA
	db $9B, $02, $0E, $A3, $82, $A6, $8A, $02, $A8, $2A, $92, $2A, $2A, $B2, $84, $8A
	db $B6, $8C, $4A, $A0, $20, $AA, $A2, $AA, $6E, $AA, $8A, $81, $A8, $6A, $86, $24
	db $28, $EB, $68, $28, $A3, $28, $42, $82, $80, $0A, $18, $88, $2F, $AA, $40, $A8
	db $AA, $EE, $FB, $BE, $AE, $2E, $BB, $BF, $2B, $AB, $BE, $BB, $BE, $BF, $EE, $AF
	db $4E, $BA, $FF, $AE, $BF, $6A, $B2, $EB, $FE, $BF, $F7, $AF, $8E, $FE, $3F, $AF
	db $EB, $8F, $BF, $EF, $EF, $A2, $3B, $EA, $BE, $A9, $FE, $4B, $FF, $AF, $BE, $E7
	db $BF, $BE, $E8, $EA, $8B, $BF, $FE, $9B, $B1, $FF, $AE, $AB, $8B, $AE, $CA, $7F
	db $A6, $A8, $AA, $D2, $AB, $EE, $AF, $A8, $BE, $FA, $AB, $FE, $E7, $BE, $FB, $AE
	db $FF, $BE, $F8, $AF, $DE, $EE, $7B, $DF, $EE, $8F, $E8, $AC, $FF, $EA, $FE, $EB
	db $BA, $F3, $FF, $AE, $AB, $F2, $A8, $9A, $EE, $2B, $B3, $A6, $BF, $E7, $EF, $FE
	db $E6, $A3, $EE, $BA, $FB, $FB, $8F, $8A, $EA, $BB, $EA, $AA, $FB, $BB, $EF, $2E
	db $9E, $20, $8E, $22, $2A, $48, $F2, $A2, $20, $A8, $2C, $AA, $AB, $A0, $2E, $8A
	db $20, $8C, $02, $22, $A8, $8A, $A8, $AB, $2B, $28, $4A, $9A, $82, $8A, $89, $B8
	db $00, $58, $0A, $8A, $03, $8A, $A0, $AA, $E2, $8A, $04, $82, $8A, $08, $82, $A2
	db $8A, $81, $60, $84, $A4, $B2, $1A, $24, $AA, $2E, $62, $A2, $88, $04, $0A, $88
	db $8A, $2A, $8A, $AA, $29, $A0, $2A, $8A, $20, $88, $10, $A8, $A0, $28, $D2, $2A
	db $22, $00, $88, $A2, $BA, $A2, $CA, $83, $40, $BE, $82, $2A, $B0, $2A, $A0, $2B
	db $BA, $4A, $FD, $82, $EA, $60, $AE, $A2, $A0, $AA, $AA, $A8, $2A, $22, $6E, $22
	db $A2, $22, $AB, $A2, $83, $82, $A2, $EA, $A2, $8A, $9A, $2A, $82, $2A, $AA, $B4
	db $BE, $AE, $9E, $FE, $2F, $AB, $9B, $EF, $AE, $AB, $4A, $E9, $CB, $A9, $92, $EF
	db $7E, $E8, $AB, $FE, $FB, $BC, $FE, $6C, $2A, $AE, $FE, $FA, $3E, $AB, $8B, $A7
	db $B9, $EB, $EE, $AA, $BB, $AD, $BF, $BF, $AE, $BB, $2A, $FB, $9F, $FE, $AB, $E8
	db $FF, $EF, $AA, $FF, $87, $AA, $AB, $A2, $FF, $BF, $EB, $FB, $E3, $2D, $FB, $EB
	db $F8, $F8, $AB, $AA, $BB, $EA, $E3, $E2, $BE, $EE, $93, $EA, $98, $EE, $AF, $AB
	db $FA, $EA, $7C, $AA, $D7, $3E, $BE, $FF, $FB, $BA, $EA, $EB, $AF, $BE, $A2, $FA
	db $AB, $9B, $9B, $BE, $BF, $EE, $BE, $AF, $AF, $AE, $AA, $EE, $EF, $BF, $B3, $EE
	db $AA, $EF, $F9, $8F, $EB, $AA, $8E, $2A, $B3, $BE, $BA, $BC, $EA, $A3, $8F, $BA
	db $08, $B2, $00, $A3, $A8, $8A, $89, $8A, $22, $02, $B1, $8A, $52, $09, $22, $B8
	db $1A, $08, $8E, $8A, $82, $08, $A2, $EA, $A8, $4A, $22, $03, $A8, $BA, $01, $AA
	db $E0, $18, $80, $8A, $AA, $AA, $BA, $A9, $A4, $98, $88, $20, $A8, $83, $C8, $B6
	db $A8, $AA, $E1, $8B, $0A, $78, $A4, $BA, $AA, $02, $A0, $0A, $24, $2E, $A2, $A0
	db $D2, $38, $0A, $CA, $2A, $94, $4A, $89, $A0, $48, $02, $29, $A0, $88, $80, $88
	db $EA, $A0, $B0, $6A, $2A, $AA, $80, $A2, $00, $80, $02, $A8, $A2, $98, $30, $0B
	db $C2, $06, $2A, $22, $B0, $30, $8C, $AA, $28, $0A, $0A, $90, $22, $A2, $8E, $0A
	db $83, $8A, $A4, $2A, $88, $AA, $8A, $AA, $2A, $A9, $86, $98, $22, $2D, $6C, $08
	db $AB, $AA, $EA, $CE, $46, $FF, $2B, $E9, $AE, $8E, $AE, $AA, $E2, $FF, $EE, $FB
	db $EE, $EA, $AA, $EA, $BA, $EB, $AC, $FE, $F7, $E9, $EE, $EA, $AF, $AE, $38, $EF
	db $BF, $EE, $EB, $BF, $2E, $AC, $2E, $AE, $EB, $EC, $EB, $EE, $FB, $9A, $8F, $AA
	db $BA, $A6, $EA, $7E, $FA, $BE, $AE, $6E, $CE, $7E, $BE, $AE, $6E, $AA, $FE, $BF
	db $E8, $AA, $AA, $AA, $A8, $AA, $AD, $BA, $AA, $EE, $EE, $EA, $AA, $FE, $2F, $AA
	db $EA, $F6, $AB, $2F, $BE, $EA, $2B, $EA, $AE, $AE, $6D, $AA, $FE, $CB, $2A, $6F
	db $EE, $8C, $EA, $EE, $AA, $6A, $EE, $2A, $5C, $EA, $EF, $EE, $AA, $AE, $EA, $FE
	db $AE, $BE, $FE, $EA, $EB, $AB, $5A, $EA, $EA, $EA, $FC, $EE, $EF, $F2, $AA, $EC
	db $0A, $AA, $A2, $AE, $A0, $0A, $AA, $EA, $F0, $B2, $6A, $0A, $82, $08, $E8, $A2
	db $83, $22, $2E, $28, $AA, $00, $A2, $28, $8A, $AA, $A2, $AA, $0C, $A0, $D8, $A8
	db $A4, $AA, $AA, $A2, $20, $8E, $42, $A8, $E0, $A0, $2A, $E8, $00, $AA, $20, $AA
	db $B0, $8B, $6A, $0A, $82, $8A, $A0, $28, $88, $AA, $40, $82, $00, $A8, $9A, $0A
	db $0A, $2A, $AC, $A8, $A8, $EE, $AA, $08, $A2, $1A, $A0, $28, $AF, $22, $26, $A2
	db $AA, $02, $2A, $A8, $6A, $22, $AA, $22, $82, $2A, $08, $AA, $86, $A8, $22, $A2
	db $0A, $A6, $A8, $40, $8E, $8A, $08, $20, $AA, $62, $AA, $A3, $80, $A8, $2A, $2A
	db $8A, $02, $8E, $22, $22, $8A, $02, $AA, $22, $0C, $4A, $A0, $A8, $A2, $2A, $08
	db $EE, $FE, $AE, $AA, $AB, $BA, $AE, $EE, $EF, $A5, $C8, $BB, $FE, $C7, $EA, $EE
	db $F4, $EA, $AE, $8A, $BE, $AA, $A8, $FE, $83, $AA, $EA, $AC, $CA, $2C, $EE, $AE
	db $EA, $2A, $FE, $AA, $BF, $AA, $FE, $EE, $EB, $26, $AE, $AB, $A8, $C2, $FF, $AB
	db $EF, $FA, $6E, $BE, $A6, $AA, $AA, $EE, $EE, $AA, $BA, $EE, $EA, $EA, $8E, $EE
	db $AE, $EA, $AA, $EE, $EA, $AA, $E9, $AE, $AE, $E6, $8E, $AE, $AE, $BA, $E8, $6E
	db $AA, $A8, $BA, $AA, $EA, $0E, $EA, $FE, $EA, $4F, $AA, $EA, $DE, $AE, $A2, $EA
	db $E6, $AE, $3C, $EE, $7A, $BA, $A2, $EA, $DE, $BE, $DB, $EF, $D8, $AE, $FF, $EA
	db $AA, $EF, $EA, $BA, $B8, $EA, $42, $AE, $E2, $AB, $2A, $DE, $FF, $AE, $AE, $22
	db $08, $22, $AA, $0A, $A8, $08, $AA, $20, $A8, $2A, $8E, $80, $AA, $8A, $4A, $AA
	db $28, $20, $28, $2A, $0A, $82, $0A, $A2, $02, $2B, $A2, $C8, $A2, $20, $08, $A8
	db $42, $AC, $88, $66, $D2, $2A, $B2, $AC, $EA, $81, $EA, $20, $EA, $A0, $A1, $21
	db $02, $C8, $A8, $22, $AA, $2A, $8B, $0E, $8A, $0A, $0A, $AA, $AA, $A8, $2E, $8A
	db $82, $60, $2A, $AE, $8E, $A3, $AA, $A8, $A1, $CA, $A0, $CA, $80, $EE, $82, $A6
	db $62, $00, $40, $28, $1A, $08, $00, $00, $AC, $EA, $36, $8A, $82, $88, $82, $88
	db $0A, $86, $AA, $22, $08, $E0, $8A, $8A, $10, $AE, $AA, $AA, $C0, $00, $1A, $8A
	db $28, $28, $A8, $AA, $88, $66, $00, $08, $8C, $82, $AA, $2A, $EA, $C8, $AA, $48
	db $AA, $DF, $8B, $BA, $AE, $EB, $EE, $EA, $AA, $AE, $8F, $6E, $EE, $AA, $EA, $E6
	db $6E, $AA, $9A, $EA, $E9, $FE, $BA, $AA, $BA, $EF, $EA, $2E, $FB, $EA, $EA, $AB
	db $28, $AC, $DA, $B2, $BF, $AA, $EA, $8E, $FE, $AE, $FA, $2B, $CE, $EE, $EE, $8E
	db $B8, $AA, $AA, $BA, $A8, $AA, $AE, $AE, $A8, $3F, $A7, $EE, $9E, $AE, $CE, $2B
	db $EE, $EB, $AF, $F8, $BE, $2A, $3B, $AB, $FB, $AA, $EF, $BA, $EE, $2F, $EA, $EA
	db $AA, $AA, $EA, $AE, $EA, $EE, $2A, $EB, $36, $AA, $AB, $AA, $AA, $EE, $EE, $AA
	db $BA, $EE, $BF, $BB, $BE, $EA, $8E, $AE, $EA, $EE, $F6, $BF, $AE, $EE, $AA, $BE
	db $FB, $C2, $0E, $EA, $EA, $EE, $AD, $BB, $AC, $FA, $BF, $BF, $A6, $EA, $8A, $EA
	db $A6, $28, $A4, $2E, $83, $02, $82, $B2, $C8, $22, $8A, $A8, $E8, $0A, $CA, $A2
	db $A4, $AA, $CA, $2A, $2A, $80, $20, $2A, $48, $B8, $A8, $08, $80, $AA, $AE, $88
	db $0A, $8A, $AA, $CA, $0A, $38, $8A, $20, $00, $2E, $00, $88, $88, $22, $02, $22
	db $82, $82, $A2, $09, $EA, $A2, $A8, $A2, $0A, $A2, $2A, $02, $2A, $AA, $27, $AA
	db $AA, $AA, $02, $82, $2A, $3A, $AE, $CA, $A8, $08, $88, $A2, $0A, $A2, $A2, $A2
	db $0A, $02, $6A, $AA, $82, $8A, $09, $A8, $0E, $AA, $A2, $82, $88, $E8, $42, $AA
	db $2A, $AA, $C2, $62, $2E, $4A, $AE, $88, $2A, $A8, $22, $AA, $0C, $2A, $22, $68
	db $08, $2F, $AA, $A8, $28, $AA, $AC, $34, $02, $8A, $28, $A8, $AA, $8A, $28, $20
	db $EA, $E6, $BE, $FE, $E9, $E6, $3E, $8A, $EA, $EA, $EA, $2E, $2F, $DA, $D9, $BE
	db $2A, $6A, $BE, $AF, $EE, $EA, $A7, $FE, $EE, $3F, $BE, $BA, $BE, $DB, $FA, $FA
	db $A9, $AA, $8F, $AA, $2F, $BE, $EF, $BB, $AE, $AB, $BF, $FF, $FE, $2F, $B8, $FE
	db $AA, $FB, $B0, $8A, $FA, $BB, $2B, $AB, $8E, $8E, $AF, $EE, $BA, $AA, $EA, $FE
	db $AB, $AA, $AA, $2F, $EB, $FB, $AE, $AA, $F2, $3B, $AE, $2E, $CE, $FB, $EA, $1F
	db $EC, $BE, $BA, $BE, $FA, $B3, $2E, $E8, $AA, $AC, $CF, $AE, $FF, $FA, $EA, $FE
	db $B5, $BF, $AE, $FC, $A3, $FE, $EA, $BE, $B6, $EB, $EE, $6B, $E2, $EE, $AB, $E7
	db $FE, $EB, $6A, $BB, $6A, $A2, $A8, $EE, $EB, $EA, $EB, $BB, $AB, $AA, $AB, $9A
	db $0A, $E8, $80, $8A, $03, $98, $4A, $A8, $BA, $AA, $9A, $60, $8A, $AA, $A8, $0A
	db $A8, $2E, $0A, $8A, $A0, $22, $20, $88, $82, $00, $53, $82, $CE, $0A, $0C, $28
	db $83, $0B, $02, $E8, $30, $0E, $A8, $2A, $9A, $02, $AA, $BA, $83, $CC, $AC, $38
	db $22, $43, $A4, $A8, $A6, $0A, $9A, $02, $C3, $8B, $90, $A8, $22, $60, $04, $8A
	db $02, $3A, $82, $08, $AA, $9A, $28, $A2, $22, $A2, $98, $22, $B2, $28, $22, $2B
	db $02, $29, $24, $A2, $2E, $28, $22, $A8, $92, $AA, $BC, $80, $42, $28, $88, $62
	db $02, $02, $A8, $AE, $AA, $6A, $20, $60, $A8, $4A, $21, $A2, $29, $CA, $EB, $AA
	db $E8, $E2, $A2, $00, $02, $2A, $88, $82, $30, $00, $B1, $82, $A2, $8A, $90, $00

SECTION "bank09", ROMX, BANK[$09]


UnknownData_0x24000:
INCBIN "baserom.gb", $24000, $242F0 - $24000
;$242F0 Pointers to levels 
	dw Level_01
	dw Level_26
	dw Level_27
	dw Level_28
	
INCBIN "baserom.gb", $242F8, $24500 - $242F8

Level_01: ;$24500
INCBIN "levels/level01.bin"

Level_26: ;$24E5B
INCBIN "levels/level26.bin"

Level_27: ;$25105
INCBIN "levels/level27.bin"

Level_28: ;$25526
INCBIN "levels/level28.bin"

INCBIN "baserom.gb", $25CF7, $28000 - $25CF7


SECTION "bank0A", ROMX, BANK[$0A]


UnknownData_0x28000: ;per-level group block preceding the Level_02/03/04 pointer list
	db $04, $40, $94, $40, $06, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $05, $0A, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $09, $0A, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $0C, $0C, $09, $0E, $0C, $0C, $05, $0E, $0C, $0C, $04, $0C, $0C, $0C, $0C
	db $0C, $05, $0F, $00, $0A, $08, $08, $08, $0C, $0D, $00, $03, $03, $07, $0E, $04
	db $04, $08, $0D, $0D, $0A, $08, $08, $08, $08, $09, $08, $0B, $0E, $0C, $0C, $0C
	db $0C, $0C, $0C, $00, $0E, $0C, $0D, $0E, $0C, $0D, $0E, $0C, $0D, $0E, $0C, $0D
	db $0E, $0C, $0D, $0D, $0E, $0D, $00, $00, $00, $00, $0E, $0C, $0D, $00, $00, $0E
	db $0C, $0D, $00, $00, $0A, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $09, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $07, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $06, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $A0, $40, $02, $A6, $EA, $8E, $A9, $2A, $80, $20, $A2, $A0
	db $82, $AC, $02, $0A, $A8, $AA, $AA, $88, $08, $AA, $AA, $28, $AA, $AA, $AA, $28
	db $AA, $82, $8A, $82, $A2, $2A, $A8, $A8, $2A, $82, $08, $A8, $22, $A2, $EA, $AA
	db $CA, $2A, $02, $4A, $8A, $E2, $A8, $E2, $2A, $23, $C2, $A6, $2E, $E8, $2A, $22
	db $22, $02, $2A, $A2, $8A, $AA, $80, $2A, $20, $2A, $2A, $A8, $82, $82, $4A, $EE
	db $2C, $A8, $A0, $6A, $02, $A2, $80, $22, $AA, $22, $2A, $28, $A2, $A2, $28, $A2
	db $A8, $3E, $EA, $3F, $AE, $2F, $BB, $EA, $EA, $BE, $AA, $AE, $EB, $EF, $AE, $FA
	db $EE, $AE, $AE, $EE, $BE, $CA, $B8, $FB, $FE, $BE, $BB, $AE, $A0, $BA, $6A, $AE
	db $AE, $B8, $AF, $EE, $BE, $AF, $CE, $EE, $BB, $2A, $BB, $2F, $AA, $EE, $AC, $6A
	db $AE, $EA, $AA, $AE, $AA, $AB, $EF, $DE, $BA, $AA, $BA, $AF, $AB, $EA, $AE, $AA
	db $C8, $A8, $9A, $AE, $FE, $FC, $CE, $AE, $9E, $AA, $BE, $8A, $BF, $FA, $BA, $EB
	db $3E, $AA, $AF, $AA, $FA, $6E, $A6, $A2, $2A, $7B, $FE, $AA, $AA, $EF, $89, $AA
	db $EA, $EE, $FF, $AA, $2A, $FB, $EE, $EC, $EE, $EA, $BE, $A8, $26, $EE, $AE, $EE
	db $EB, $FA, $AE, $A2, $AC, $EA, $2F, $3F, $AE, $3A, $EA, $BA, $EE, $FA, $A8, $A2
	db $A2, $02, $38, $EA, $C8, $42, $AA, $8A, $A2, $0A, $A2, $AA, $8A, $82, $28, $A0
	db $0A, $2A, $69, $4A, $88, $08, $A2, $0E, $60, $88, $8C, $AA, $AA, $A0, $0A, $88
	db $A8, $AC, $AA, $82, $22, $A8, $E0, $8A, $A8, $88, $AE, $A8, $88, $00, $8A, $84
	db $0A, $EA, $20, $A2, $20, $A2, $20, $A2, $A8, $08, $02, $88, $80, $AA, $A8, $AA
	db $2A, $A2, $02, $80, $AA, $88, $2A, $22, $38, $08, $A2, $A0, $AA, $C8, $88, $8A
	db $88, $AA, $88, $80, $20, $CA, $A0, $82, $AA, $82, $AA, $AB, $AA, $AA, $A6, $88
	db $82, $A8, $A0, $2E, $AA, $AA, $22, $25, $8A, $2A, $A2, $A0, $2A, $82, $E0, $AA
	db $A2, $8A, $A0, $AA, $2A, $FA, $A0, $22, $AA, $AA, $0A, $88, $AA, $A8, $22, $82
	db $EF, $AA, $BE, $BA, $EE, $F2, $AA, $BA, $AE, $AE, $A8, $E2, $EB, $EA, $EA, $AC
	db $AE, $AE, $BB, $E3, $EE, $FA, $EA, $EE, $EC, $A9, $3E, $AE, $E3, $CE, $BA, $AA
	db $EA, $EA, $4F, $EA, $A7, $26, $EE, $EA, $BA, $9A, $EA, $AA, $EA, $AA, $EE, $AA
	db $AA, $AA, $2E, $AD, $EA, $EB, $BA, $AA, $FA, $8E, $EF, $E2, $EA, $2A, $FE, $EE
	db $EE, $7A, $DF, $DA, $EE, $EE, $AA, $EE, $BF, $FE, $AB, $AB, $8F, $6A, $AF, $6F
	db $AE, $2F, $FB, $EE, $EE, $EA, $AE, $EA, $EA, $AE, $E8, $EE, $EA, $AA, $2A, $EB
	db $EA, $EE, $F6, $AA, $8A, $AE, $BA, $7A, $EA, $AA, $A6, $A6, $AA, $AE, $EA, $AA
;$282F0 Pointers to levels 
	dw Level_02
	dw Level_03
	dw Level_04
	
UnknownData_0x282F6: ;shared group block between the pointer list and Level_02
	db $6E, $AA, $AE, $8E, $BE, $AA, $AB, $8A, $EA, $6E, $AA, $00, $0A, $82, $0A, $CA
	db $8A, $22, $A2, $2A, $28, $A2, $A8, $20, $AA, $A8, $0A, $80, $2A, $0A, $22, $2A
	db $2A, $CA, $22, $08, $2A, $88, $22, $2A, $AA, $8A, $20, $02, $02, $A2, $82, $AA
	db $22, $AA, $AA, $22, $28, $A0, $6A, $28, $AA, $A2, $0A, $A8, $86, $AA, $28, $02
	db $AA, $A8, $08, $24, $8A, $A0, $0A, $20, $02, $88, $8A, $A8, $88, $E0, $88, $22
	db $2A, $82, $8A, $2A, $12, $88, $AA, $8B, $AA, $88, $88, $AA, $A8, $AA, $A2, $04
	db $20, $8A, $F0, $82, $A2, $20, $8E, $28, $02, $8A, $2A, $A9, $08, $22, $88, $02
	db $A8, $AF, $2E, $EA, $A0, $A2, $AA, $22, $0C, $80, $82, $80, $0A, $8A, $88, $28
	db $08, $22, $A8, $A8, $2A, $23, $A2, $AA, $EE, $32, $AA, $4A, $FF, $AB, $A8, $CA
	db $AA, $EE, $EE, $EF, $AA, $AE, $AA, $F2, $8A, $AA, $BE, $AB, $7E, $EB, $EB, $F6
	db $AA, $EA, $EF, $CA, $AA, $EA, $AA, $AA, $A3, $FE, $BF, $AA, $AE, $EE, $A8, $EC
	db $AB, $AA, $EE, $AB, $AA, $EB, $EF, $BA, $BE, $AA, $AA, $BE, $EE, $AC, $AA, $EA
	db $EA, $BA, $DA, $FE, $AE, $EA, $AA, $2C, $AA, $BE, $3E, $AE, $EE, $EE, $AA, $AA
	db $AA, $AA, $E2, $EE, $EA, $6A, $FA, $BA, $AA, $FA, $8A, $AC, $EF, $FE, $BE, $EB
	db $E2, $6A, $8E, $9A, $AB, $8F, $FA, $AA, $EB, $BA, $AA, $AE, $EE, $A7, $EA, $BE
	db $38, $3A, $A2, $EA, $FA, $BE, $EB, $AE, $CA, $AA, $AA, $AE, $AA, $AA, $EA, $EE
	db $AB, $AA, $BB, $AA, $AB, $EA, $A4, $FE, $AA, $BB, $28, $9B, $AA, $8A, $A2, $A2
	db $2A, $EA, $8A, $A2, $AA, $20, $A8, $81, $8A, $AA, $22, $82, $22, $40, $A2, $A2
	db $82, $AA, $A8, $AA, $E2, $AC, $18, $A8, $A2, $A8, $AA, $A3, $02, $80, $0A, $6A
	db $AA, $E8, $86, $82, $AA, $A2, $AA, $AA, $9A, $BA, $28, $6A, $80, $8A, $A2, $A8
	db $08, $AA, $A0, $0A, $0A, $AA, $0A, $88, $AA, $A2, $8A, $88, $A2, $0E, $AE, $A9
	db $2A, $08, $82, $A0, $0A, $2E, $40, $0A, $20, $2A, $38, $8A, $98, $19, $82, $BA
	db $0A, $22, $A8, $2A, $08, $A8, $A2, $8A, $22, $AA, $2E, $28, $AA, $8C, $02, $AA
	db $A2, $22, $A0, $28, $8A, $A6, $22, $08, $2A, $A8, $2E, $A8, $AA, $AA, $28, $A0
	db $0D, $88, $22, $A0, $0A, $08, $AA, $20, $8A, $8E, $EB, $AB, $EB, $EF, $FB, $AF
	db $AB, $9E, $AA, $BA, $FA, $EA, $BA, $8B, $FB, $F6, $AA, $FB, $AB, $FB, $A2, $AE
	db $E2, $AA, $FE, $AF, $EF, $AA, $AF, $7F, $EE, $BA, $EE, $A9, $AE, $EA, $FF, $FB
	db $AB, $AB, $AA, $BF, $AA, $AA, $EB, $BF, $7F, $AA, $AF, $CB, $2F, $BB, $AE, $FA
	db $AF, $BF, $EA, $BA, $AA, $FE, $BA, $A8, $E6, $8B, $BF, $FF, $2D, $67, $FD, $CA
	db $7A, $FE, $BB, $EC, $BB, $AA, $FB, $EB, $8F, $EB, $EF, $FA, $BF, $FA, $AB, $AE
	db $FA, $AB, $EF, $BE, $AB, $8E, $EE, $EA, $AB, $BA, $B2, $AB, $AA, $AA, $AA, $BE
	db $BE, $FD, $EE, $BB, $DF, $AF, $6E, $AF, $AA, $AB, $EB, $A8, $FA, $AA, $BB, $BC
	db $EA, $AE, $2F, $AF, $AA, $FB, $BA, $BA, $AF, $AB

Level_02: ;$28500
INCBIN "levels/level02.bin"

Level_03: ;$2919B
INCBIN "levels/level03.bin"

Level_04: ;$2AA87
INCBIN "levels/level04.bin"

UnknownData_0x2B215: ;level-data tail after the last layout stream in bank $0A
	db $AA, $2A, $AB, $AA, $BE, $AB, $2D, $EB, $F2, $DA, $B6, $FE, $BB, $AE, $EE, $AF
	db $FE, $BA, $BB, $B3, $32, $AA, $AF, $EB, $BB, $AB, $CB, $FF, $B9, $F7, $EA, $BE
	db $6A, $AA, $CF, $BA, $DB, $EF, $AA, $6A, $F9, $FE, $FE, $AF, $33, $BA, $F2, $A2
	db $3A, $FF, $A6, $EE, $A7, $79, $FF, $FA, $AE, $F3, $AF, $BB, $EA, $FA, $AB, $9A
	db $F6, $AA, $EA, $BE, $9F, $6F, $A3, $F6, $AF, $BB, $0E, $EE, $BB, $A7, $BA, $BF
	db $E9, $6A, $F6, $EB, $6F, $83, $3B, $7E, $3F, $EE, $BA, $BE, $BE, $FB, $FE, $FF
	db $BF, $AE, $B2, $AE, $B6, $EA, $FE, $BA, $F7, $BA, $BA, $28, $20, $09, $26, $8A
	db $28, $1A, $AA, $90, $0B, $22, $A8, $3A, $83, $02, $28, $2A, $28, $92, $B2, $83
	db $22, $83, $00, $68, $AA, $02, $80, $A9, $8A, $28, $BA, $83, $C8, $60, $02, $A8
	db $0A, $EA, $02, $2A, $2A, $A6, $A2, $60, $A0, $BA, $0A, $20, $AC, $8A, $A2, $22
	db $00, $22, $8A, $0E, $AA, $22, $E2, $D8, $0A, $23, $A0, $8A, $0A, $20, $2A, $02
	db $EA, $28, $60, $00, $A8, $24, $42, $01, $A2, $82, $84, $34, $B2, $2A, $28, $02
	db $A0, $82, $82, $CE, $0B, $A2, $82, $08, $A2, $1A, $08, $28, $26, $68, $A0, $AA
	db $90, $02, $04, $28, $20, $82, $02, $2A, $AA, $22, $32, $22, $A1, $18, $26, $8A
	db $28, $A0, $90, $AA, $6A, $28, $08, $22, $A8, $02, $03, $3A, $EA, $7B, $BB, $FB
	db $EA, $BC, $AE, $AA, $BA, $FA, $EA, $87, $EF, $EA, $62, $E6, $AA, $B2, $AB, $AF
	db $BB, $AB, $6F, $EE, $EB, $FE, $BE, $EE, $F7, $E7, $C2, $AA, $FE, $BE, $A5, $E2
	db $7B, $EA, $AF, $AB, $AA, $2A, $FD, $F1, $B3, $ED, $6E, $FE, $AD, $6A, $9F, $A3
	db $7A, $BA, $62, $AA, $B2, $EA, $B7, $EB, $96, $AE, $EF, $EE, $AE, $EA, $BB, $2A
	db $EA, $CE, $EE, $BA, $BE, $AA, $EB, $7A, $9B, $2F, $6A, $FA, $AD, $B7, $66, $BB
	db $AE, $A6, $B7, $E8, $CE, $EE, $EA, $FE, $FF, $EF, $FE, $E7, $3E, $7A, $6F, $A6
	db $AE, $89, $BD, $E7, $A3, $EF, $BF, $AB, $AF, $EE, $ED, $EF, $AF, $AE, $FB, $E6
	db $E8, $3B, $AB, $AE, $9F, $3B, $BA, $BF, $BF, $FA, $FB, $A0, $A8, $A8, $22, $00
	db $6A, $8C, $A2, $AA, $B8, $A0, $2A, $2A, $2A, $80, $08, $10, $AA, $0C, $62, $22
	db $02, $A3, $2C, $22, $A2, $80, $28, $82, $8A, $03, $22, $0E, $2E, $82, $A3, $02
	db $02, $12, $6A, $28, $20, $20, $80, $88, $82, $02, $60, $C8, $0A, $A2, $A2, $02
	db $02, $30, $03, $60, $48, $22, $80, $00, $00, $28, $2A, $0A, $6C, $00, $00, $80
	db $04, $21, $8A, $A2, $88, $22, $88, $A2, $8A, $8A, $2A, $02, $A2, $88, $8A, $28
	db $49, $80, $2A, $22, $23, $62, $0A, $E2, $24, $60, $81, $09, $20, $A8, $82, $02
	db $02, $22, $82, $42, $0A, $A2, $A0, $00, $22, $22, $A9, $D8, $A4, $02, $23, $21
	db $A0, $A2, $2A, $82, $28, $22, $26, $12, $A2, $0A, $20, $A2, $AF, $AA, $EA, $AB
	db $DA, $BE, $92, $FE, $A3, $AC, $BA, $AA, $FB, $FB, $A1, $AA, $EA, $EF, $FA, $BA
	db $EB, $EF, $1A, $BF, $EF, $3F, $FB, $E2, $AA, $0A, $BA, $FC, $FE, $EE, $FA, $AE
	db $BF, $FE, $EB, $BB, $7B, $FF, $BB, $AB, $FB, $EA, $AB, $F2, $E1, $AF, $FB, $BE
	db $EF, $EA, $FB, $AA, $BB, $AA, $BF, $E9, $BE, $EA, $6A, $FE, $82, $EA, $EB, $EF
	db $EA, $FB, $AC, $EA, $AA, $FE, $F2, $DA, $FB, $F3, $AE, $EA, $F9, $AE, $B7, $B9
	db $BE, $AA, $E8, $3A, $FC, $FA, $EA, $BB, $9B, $EA, $A2, $EF, $AA, $88, $EF, $BB
	db $7A, $EE, $EF, $FA, $BA, $BB, $BF, $EE, $BA, $AB, $AB, $AB, $3D, $3E, $DA, $FA
	db $F8, $EB, $FA, $B1, $AB, $BA, $FF, $BE, $EE, $BA, $AA, $6E, $2B, $00, $EA, $AA
	db $AA, $8A, $02, $A2, $20, $3A, $EA, $99, $06, $AA, $AA, $88, $AA, $B2, $A0, $2A
	db $80, $80, $A6, $EA, $A2, $80, $23, $A2, $AA, $B2, $B6, $BC, $82, $AA, $A0, $20
	db $A2, $3A, $88, $82, $AA, $2A, $A2, $0A, $93, $04, $A0, $A2, $9A, $28, $AA, $88
	db $8A, $2A, $02, $A2, $A0, $8A, $8A, $20, $AA, $AA, $8A, $02, $98, $AA, $88, $88
	db $A6, $01, $88, $A0, $CA, $A8, $88, $0A, $AA, $0A, $E2, $EE, $2A, $28, $AA, $C6
	db $80, $A8, $E8, $AA, $8A, $A2, $22, $22, $62, $AC, $8A, $A0, $8A, $82, $A8, $22
	db $0A, $8A, $A8, $22, $02, $8A, $22, $22, $2A, $23, $2B, $A2, $AB, $8E, $24, $A8
	db $88, $3A, $2A, $20, $A0, $20, $A8, $A4, $28, $08, $00, $EB, $BF, $BB, $FA, $EA
	db $FB, $BF, $FE, $F3, $EA, $FB, $B2, $2E, $EA, $AF, $AB, $BA, $BE, $AE, $FF, $EE
	db $BF, $EF, $9E, $BA, $EA, $F7, $EF, $2E, $BE, $AE, $BF, $BF, $FB, $9F, $EF, $A2
	db $BB, $BB, $8A, $EB, $AF, $FB, $BE, $EB, $AB, $EF, $BA, $EA, $EE, $BF, $EF, $8A
	db $BA, $AB, $AA, $3B, $EA, $BA, $AA, $6A, $EF, $EB, $AE, $AE, $BE, $EF, $A8, $BB
	db $AF, $6B, $F7, $8E, $AA, $BA, $EE, $E3, $FA, $EA, $FB, $FE, $AE, $AA, $BE, $FB
	db $BF, $AB, $FA, $AD, $BB, $AE, $2B, $CB, $FE, $AA, $2F, $EB, $8A, $EF, $BB, $AA
	db $6E, $FE, $2B, $FE, $AB, $EF, $FB, $AE, $AB, $AA, $FE, $FA, $AB, $AF, $BA, $FF
	db $EA, $B3, $BB, $BF, $AA, $AE, $BE, $BE, $BB, $62, $EB, $A8, $AA, $AA, $6A, $AA
	db $82, $20, $2A, $A0, $B0, $A8, $82, $A8, $AA, $AA, $82, $8A, $88, $A2, $2A, $03
	db $C1, $E0, $38, $A2, $E2, $12, $48, $36, $80, $4A, $6A, $03, $A8, $93, $02, $A8
	db $28, $E8, $28, $A2, $A0, $90, $80, $22, $A8, $8A, $03, $BE, $12, $10, $9A, $A8
	db $22, $A8, $2A, $C8, $63, $A3, $A8, $22, $A8, $0A, $82, $AA, $2A, $A8, $A0, $50
	db $58, $2A, $8A, $0A, $2E, $02, $08, $82, $A2, $96, $88, $A3, $28, $A2, $A2, $28
	db $22, $AA, $0A, $AA, $8A, $40, $A8, $28, $84, $20, $82, $8C, $2E, $06, $2C, $8A
	db $B2, $86, $08, $A2, $88, $A6, $00, $8B, $2A, $0A, $88, $AA, $28, $17, $B2, $80
	db $EA, $0A, $A8, $AA, $88, $BA, $3A, $C2, $08, $38, $88, $3F, $BA, $AE, $AF, $E6
	db $EA, $A7, $A8, $FE, $EB, $BE, $6F, $CC, $BA, $A8, $2B, $AA, $FA, $AB, $FB, $BE
	db $8F, $AB, $FE, $EB, $EB, $BA, $EA, $AA, $B9, $A3, $BE, $BB, $EB, $AB, $EA, $AA
	db $AA, $AE, $E3, $AF, $AB, $BE, $BB, $89, $BA, $BF, $AE, $BB, $BE, $FB, $8F, $FB
	db $BA, $FE, $BA, $8A, $AB, $BE, $EB, $EB, $FE, $EE, $FB, $BF, $A6, $AC, $BA, $BF
	db $FF, $AA, $F7, $FB, $BE, $AA, $BF, $EB, $EF, $EA, $A2, $FE, $BB, $2E, $AD, $BA
	db $9A, $FA, $BA, $BE, $EF, $BB, $2E, $FE, $FB, $A2, $BA, $AB, $EA, $AE, $FA, $AA
	db $FB, $EC, $EA, $AB, $7F, $BA, $EF, $BB, $FF, $EE, $BE, $FE, $8B, $FA, $7E, $FB
	db $BE, $EA, $AC, $FE, $FA, $FB, $AE, $8A, $EF, $EF, $AE, $A3, $82, $0A, $A8, $82
	db $82, $89, $8A, $9A, $A2, $22, $0A, $8E, $12, $08, $CA, $A2, $A2, $82, $A8, $09
	db $A3, $A8, $80, $A0, $DA, $82, $90, $7A, $0A, $88, $80, $8A, $AA, $C8, $03, $80
	db $AC, $8A, $A8, $90, $20, $E8, $82, $AA, $A8, $A0, $8F, $0E, $AE, $2A, $88, $C0
	db $00, $2E, $8A, $EA, $80, $8B, $80, $C2, $88, $22, $2A, $00, $8A, $82, $0A, $20
	db $A2, $02, $A2, $8A, $AA, $BA, $AC, $1A, $E9, $2B, $68, $A0, $A8, $EA, $A2, $A0
	db $8A, $28, $E8, $20, $BA, $80, $22, $00, $80, $8A, $BA, $38, $22, $8A, $88, $23
	db $00, $82, $AA, $83, $0A, $AA, $A8, $48, $88, $82, $9A, $21, $88, $22, $8A, $AA
	db $88, $A2, $A2, $0E, $A2, $AA, $8A, $A0, $A8, $58, $AC, $EF, $BA, $2A, $AD, $CE
	db $FA, $EE, $BF, $6B, $BE, $AA, $AA, $FA, $7F, $AF, $A8, $FE, $BF, $EE, $AE, $BD
	db $BA, $7F, $BB, $FF, $AE, $BA, $EA, $EB, $EB, $BF, $FB, $FF, $AA, $EB, $EE, $FB
	db $FF, $EF, $AE, $BA, $FF, $BE, $FE, $AA, $AA, $FE, $F7, $E8, $BF, $EE, $EB, $B8
	db $AE, $AE, $EF, $CF, $EA, $AB, $BA, $AA, $B2, $6A, $BF, $AE, $BE, $2B, $8E, $AB
	db $F6, $EA, $EE, $8A, $EE, $BC, $BB, $FE, $EF, $EE, $8E, $EF, $AB, $3E, $FA, $BB
	db $BF, $FF, $E9, $AA, $EB, $EA, $FD, $BE, $DF, $AE, $A8, $EE, $FF, $AA, $DE, $FB
	db $FE, $FA, $AF, $FE, $7B, $AA, $BA, $AF, $BF, $BA, $AE, $BB, $AD, $EA, $AE, $EA
	db $A3, $AA, $BF, $AC, $BE, $EE, $8A, $FF, $EB, $9F, $EF, $AA, $2A, $8A, $B2, $03
	db $2A, $0A, $A0, $A2, $A2, $AA, $39, $28, $BA, $AA, $B8, $88, $A0, $06, $02, $AC
	db $A0, $8A, $08, $AA, $80, $20, $9A, $8E, $12, $80, $A8, $A2, $8A, $AB, $A8, $AA
	db $AA, $8A, $8B, $2A, $A2, $B0, $A8, $02, $83, $3B, $A9, $A2, $28, $20, $08, $82
	db $88, $20, $E1, $26, $A2, $C2, $28, $AA, $08, $6A, $A2, $9A, $2A, $82, $0A, $2A
	db $28, $A8, $08, $A8, $AA, $8A, $28, $B8, $A2, $66, $00, $82, $BA, $1A, $82, $AA
	db $0A, $8A, $A2, $22, $28, $00, $B8, $42, $A4, $80, $80, $2A, $A8, $2A, $AA, $92
	db $02, $A2, $0A, $A0, $A0, $8A, $22, $20, $22, $B8, $2A, $B2, $A2, $08, $03, $02
	db $A0, $82, $AA, $88, $A2, $0A, $2A, $A2, $28, $92, $60, $EA, $AA, $BB, $FE, $AF
	db $AB, $BA, $B3, $2D, $EB, $AB, $BF, $FE, $AB, $EA, $FE, $EB, $BE, $AA, $AF, $BE
	db $6F, $B0, $AF, $BB, $BA, $EE, $EE, $AD, $9B, $EE, $BE, $DB, $EF, $FE, $EA, $BE
	db $B2, $BB, $6B, $DE, $FA, $AF, $FB, $BE, $7F, $EA, $BA, $FA, $AA, $BB, $BA, $EA
	db $AB, $CA, $A8, $EA, $7B, $E8, $FF, $CE, $EA, $A9, $CF, $EA, $AF, $BB, $EA, $EF
	db $FA, $EB, $EF, $EE, $BE, $FF, $FE, $FE, $AA, $BF, $EE, $BB, $FE, $8B, $7F, $BD
	db $8B, $2B, $6B, $4F, $FB, $EF, $A8, $FF, $AA, $AF, $AF, $3B, $FB, $AE, $EF, $9B
	db $E9, $C7, $EF, $CE, $BF, $EE, $EB, $EA, $EE, $EA, $AB, $AA, $EE, $EB, $A0, $AB
	db $62, $FC, $AB, $EA, $3E, $AE, $EB, $F8, $AB, $EF, $EA, $AB, $83, $8A, $A2, $B2
	db $2A, $0C, $8A, $22, $A2, $68, $10, $AE, $20, $82, $A8, $E2, $0B, $2A, $83, $6A
	db $2A, $02, $23, $AC, $32, $AA, $A2, $0A, $22, $A8, $88, $A8, $88, $82, $EA, $22
	db $29, $2A, $28, $02, $9A, $C0, $82, $8A, $20, $AA, $A0, $C8, $2B, $22, $80, $F7
	db $E8, $A0, $82, $02, $AA, $0A, $68, $B1, $2A, $20, $A3, $E8, $8A, $08, $22, $82
	db $88, $A9, $0A, $0B, $8A, $88, $80, $AA, $20, $AA, $0A, $A3, $A8, $80, $2A, $9A
	db $AA, $0A, $AC, $2A, $A3, $8A, $9A, $22, $32, $80, $A2, $A0, $2A, $82, $E9, $22
	db $88, $00, $2A, $6A, $0A, $8A, $A2, $08, $AB, $AA, $2A, $E6, $2A, $A8, $B2, $A2
	db $28, $28, $BB, $A2, $08, $80, $04, $AA, $1A, $AA, $A1, $FA, $BA, $DA, $AF, $BA
	db $B8, $AE, $BB, $FE, $EE, $BF, $AA, $AF, $AE, $7A, $DB, $EB, $9C, $EA, $EF, $3E
	db $DA, $FB, $EB, $BA, $AE, $BE, $FB, $EB, $FB, $BA, $EF, $BF, $AA, $FA, $BA, $BE
	db $BE, $BB, $BE, $FA, $CB, $6E, $EA, $FE, $DE, $2E, $AE, $FE, $AF, $EA, $FF, $FA
	db $BA, $EA, $BB, $EA, $AF, $BE, $EA, $FF, $EA, $AF, $EE, $FE, $F6, $BE, $FF, $E3
	db $6B, $8E, $AA, $FA, $FE, $BF, $AE, $FB, $FE, $BA, $A4, $FF, $FC, $B7, $EF, $AE
	db $C9, $EB, $EF, $DB, $BA, $6B, $E6, $FA, $AF, $AB, $EA, $FB, $EE, $AE, $EF, $FA
	db $96, $FA, $FF, $E9, $BA, $FA, $8F, $8B, $AB, $B9, $B6, $8A, $3F, $EA, $AA, $BA
	db $7A, $BE, $FF, $EB, $FB, $BF, $A6, $AA, $FA, $BF, $9A, $AE, $8A, $E2, $88, $B8
	db $8A, $AA, $A0, $0A, $88, $A0, $AA, $A0, $A0, $02, $A8, $2A, $86, $CA, $A2, $AA
	db $E2, $4A, $9A, $A0, $22, $AE, $22, $2A, $AA, $AA, $AA, $AA, $08, $8E, $AA, $A8
	db $A2, $28, $08, $9A, $00, $02, $20, $22, $82, $A8, $28, $A8, $22, $2A, $28, $8A
	db $0A, $0A, $AA, $B9, $2A, $A8, $A0, $AA, $82, $A8, $A0, $22, $A8, $B2, $2E, $82
	db $88, $A8, $08, $20, $AB, $E2, $8A, $22, $82, $91, $E1, $CA, $09, $A0, $AA, $A2
	db $00, $2A, $0A, $20, $BA, $26, $AA, $A8, $AA, $A0, $A0, $22, $BA, $8A, $A8, $88
	db $2B, $E8, $00, $8A, $AA, $28, $A3, $2A, $02, $A6, $20, $28, $8A, $92, $A8, $AA
	db $2A, $0E, $A0, $34, $A8, $82, $8A, $AA, $8A, $A8, $41, $AC, $BE, $EA, $FB, $EB
	db $FE, $AB, $BE, $AF, $E6, $B3, $FE, $6B, $BE, $AA, $F8, $3F, $BA, $AB, $BF, $AB
	db $8E, $EF, $EF, $AA, $2A, $BE, $CB, $AE, $EB, $AA, $EF, $FB, $AF, $EE, $FE, $BE
	db $A9, $B7, $EA, $7F, $AB, $BF, $AE, $BF, $9A, $FF, $AB, $F7, $FE, $EF, $FA, $E6
	db $7F, $9A, $FD, $BA, $BA, $FB, $E8, $BE, $FB, $BE, $2A, $EC, $BA, $EE, $FA, $EF
	db $BA, $7A, $BB, $8E, $E3, $AF, $2A, $A8, $BB, $AB, $AA, $EA, $FE, $FB, $8E, $FA
	db $A9, $AE, $2A, $FF, $BC, $AB, $AF, $BE, $AA, $AC, $AE, $AB, $BE, $AA, $AB, $AF
	db $FE, $FF, $E2, $BE, $EA, $FF, $AF, $CB, $AE, $AF, $FB, $AE, $EB, $A9, $FB, $AB
	db $DB, $AB, $AF, $FA, $AF, $93, $AF, $BB, $EF, $AF, $BA, $AA, $A0, $B0, $0A, $20
	db $2A, $AA, $A3, $AB, $A2, $E2, $A0, $8C, $22, $8A, $22, $82, $9A, $22, $10, $22
	db $23, $08, $AB, $28, $AA, $08, $0A, $2A, $83, $82, $83, $2A, $2A, $82, $38, $A8
	db $A2, $08, $88, $82, $AA, $80, $A9, $A2, $00, $EA, $2A, $8A, $0A, $AA, $0A, $A2
	db $20, $0A, $AA, $0A, $AA, $80, $0A, $AA, $90, $D1, $08, $74, $AA, $2A, $2A, $E2
	db $82, $B0, $3C, $88, $A6, $A2, $8E, $CA, $2A, $9A, $A0, $AA, $7A, $2A, $82, $AA
	db $88, $2A, $A8, $A6, $20, $2A, $A8, $A0, $B2, $82, $2A, $82, $AA, $86, $00, $82
	db $AA, $A0, $AA, $C2, $88, $18, $2A, $BA, $02, $2A, $8A, $98, $8A, $AA, $89, $E2
	db $9A, $2B, $8A, $2A, $A3, $28, $A2, $8A, $0E, $A4, $02, $BF, $AB, $BA, $AA, $EB
	db $AF, $AE, $AB, $EA, $AE, $9F, $AB, $E7, $BA, $F7, $AE, $EA, $AE, $EB, $AA, $CF
	db $3E, $BF, $BB, $B6, $AA, $BB, $EF, $BB, $EA, $D6, $EA, $FE, $FA, $BA, $FF, $EF
	db $AE, $EB, $AB, $EB, $AF, $E9, $FE, $3F, $AA, $B2, $FA, $FE, $AA, $9B, $FB, $AB
	db $FA, $EB, $BB, $FE, $AF, $FA, $8F, $EB, $FF, $EA, $FE, $EF, $BA, $EF, $BA, $7A
	db $EA, $FF, $FA, $FE, $F6, $FE, $6B, $FE, $EB, $FE, $AE, $AE, $FB, $8A, $3E, $2A
	db $BB, $FF, $AB, $AF, $BE, $AA, $BA, $AA, $BF, $EB, $BA, $EF, $EF, $FE, $B3, $AF
	db $AE, $EA, $BE, $AF, $AE, $EA, $FE, $2B, $AE, $AE, $AF, $2A, $EB, $AE, $AF, $FE
	db $BE, $EA, $EA, $AE, $FE, $BB, $AB, $FA, $C8, $AB, $8E, $8A, $8A, $2A, $8A, $8A
	db $A2, $88, $28, $A8, $30, $A9, $AA, $A0, $20, $88, $88, $A8, $A8, $A2, $80, $A8
	db $8A, $8E, $CA, $BA, $A8, $2A, $28, $88, $A2, $20, $AA, $08, $2E, $80, $AA, $B6
	db $2A, $A3, $68, $28, $AA, $8E, $B8, $0A, $88, $0A, $8E, $9E, $2A, $00, $08, $06
	db $C0, $A0, $28, $AA, $20, $22, $AA, $08, $8A, $B0, $F8, $BA, $2A, $AA, $82, $AA
	db $A8, $0A, $EB, $AA, $A2, $22, $A8, $98, $8A, $19, $08, $88, $A0, $06, $10, $A8
	db $12, $2A, $8A, $02, $E8, $A2, $80, $13, $CE, $2E, $AA, $0D, $88, $0A, $A8, $EA
	db $10, $08, $4A, $8E, $AA, $A2, $A2, $04, $82, $AD, $22, $92, $2A, $BA, $AA, $8A
	db $2A, $2E, $00, $A0, $AA, $AA, $8A, $4A, $BA, $20, $08, $A8, $FB, $BA, $EA, $BA
	db $FE, $BB, $AE, $EA, $AE, $AA, $A8, $AE, $FA, $A7, $FE, $FA, $FA, $AF, $AE, $AF
	db $AE, $8A, $EF, $EA, $EA, $AA, $AA, $9E, $EF, $BA, $F9, $6B, $AE, $FB, $BA, $AE
	db $EF, $BA, $EA, $EA, $BA, $AA, $EE, $FA, $EE, $AA, $8A, $EE, $EA, $EA, $AB, $EA
	db $EA, $EB, $CB, $DA, $EB, $F2, $AB, $EB, $8A, $AA, $FE, $EE, $6E, $CE, $CB, $BA
	db $EA, $EA, $EF, $AE, $BA, $DA, $A8, $BE, $AB, $EE, $EA, $EA, $E2, $EA, $8B, $BE
	db $9F, $AA, $6A, $AF, $EE, $66, $FA, $AA, $E6, $AB, $EB, $9A, $CA, $FA, $FE, $AB
	db $EA, $7A, $AF, $AF, $AA, $AA, $EA, $EA, $EA, $AB, $AE, $AA, $AA, $A8, $AA, $EF
	db $3E, $EA, $EB, $AB, $FA, $AC, $FE, $AB, $EE, $AA, $AE, $8A, $AA, $AA, $AA, $EA
	db $08, $08, $0A, $E0, $AE, $A8, $8A, $AA, $A0, $21, $AA, $0A, $A8, $68, $82, $22
	db $A8, $2A, $A0, $68, $28, $0A, $AC, $80, $28, $2A, $2A, $A2, $88, $E0, $A0, $2A
	db $AA, $D8, $8B, $82, $28, $A2, $22, $22, $12, $0A, $2A, $AE, $AE, $AA, $A8, $AA
	db $A2, $2A, $80, $E8, $A8, $2C, $AA, $A2, $A8, $A2, $22, $AA, $0A, $08, $AA, $A0
	db $02, $9A, $80, $2A, $AE, $E0, $AA, $A2, $AA, $8A, $82, $A0, $AE, $88, $AA, $A2
	db $2A, $A0, $A0, $AA, $08, $A2, $2A, $28, $A6, $0C, $A8, $6A, $AA, $A2, $20, $00
	db $88, $EA, $A2, $00, $A8, $22, $2A, $EA, $20, $22, $28, $A2, $2A, $AA, $0A, $80
	db $A0, $28, $A2, $80, $88, $AA, $28, $1C, $8A, $A6, $08, $EB, $AA, $A2, $AF, $EF
	db $DA, $AB, $AF, $FA, $CB, $AA, $AE, $BA, $FB, $EE, $FE, $EA, $EA, $8E, $EA, $F6
	db $8E, $AB, $6A, $BB, $EE, $AE, $FC, $BE, $E8, $ED, $AE, $BE, $AD, $AB, $EA, $B2
	db $AE, $E2, $EE, $AE, $FB, $EE, $FA, $EA, $AA, $EB, $EC, $AA, $EF, $AA, $BE, $FB
	db $AF, $BE, $EF, $AE, $EE, $AA, $EB, $A8, $EB, $AB, $AF, $BE, $FA, $AE, $6F, $BE
	db $FA, $AA, $BE, $AE, $E2, $AA, $E2, $AA, $EE, $BA, $FE, $AA, $BA, $EA, $CA, $EE
	db $AF, $ED, $A7, $BB, $EA, $AE, $EF, $AE, $AE, $EA, $EA, $BA, $EB, $EA, $EE, $AB
	db $AE, $AE, $AB, $8A, $BC, $AA, $AF, $AB, $BE, $BE, $BE, $EE, $BE, $AB, $AF, $EE
	db $E2, $AE, $AA, $AA, $EB, $6A, $BA, $EE, $EB, $02, $EE, $8A, $22, $28, $A0, $22
	db $00, $80, $00, $C2, $02, $A8, $8A, $28, $0A, $A8, $BA, $62, $2E, $A2, $22, $08
	db $2A, $2A, $AA, $0A, $28, $80, $AA, $20, $28, $28, $22, $62, $8A, $A0, $22, $28
	db $80, $AA, $8A, $8A, $2A, $42, $2C, $AA, $A2, $AA, $83, $AA, $A0, $0A, $8A, $20
	db $08, $AE, $02, $2A, $A8, $2A, $AE, $A2, $0A, $A8, $AA, $8A, $3A, $8A, $AE, $28
	db $0A, $80, $80, $08, $22, $22, $CA, $88, $A2, $AA, $8A, $8A, $2E, $08, $04, $0A
	db $AA, $02, $02, $4A, $8A, $1A, $8A, $A2, $A0, $A2, $A0, $82, $2A, $06, $00, $88
	db $8A, $24, $6A, $0A, $00, $AA, $E8, $AA, $82, $8E, $82, $2A, $22, $84, $A0, $2A
	db $88, $A8, $88, $2C, $8A, $2E, $2A, $88, $8C, $AA, $00, $AE, $AE, $AA, $AA, $BE
	db $AA, $A8, $FA, $AF, $B7, $EE, $AE, $AE, $EE, $AE, $EA, $EE, $F2, $EE, $8E, $AE
	db $BA, $A2, $FF, $6F, $AE, $AB, $F8, $6A, $EA, $AA, $EA, $BB, $AE, $BC, $EA, $D6
	db $BA, $AB, $30, $FE, $AF, $DE, $A2, $A8, $AE, $AF, $EF, $7F, $AE, $EA, $AB, $BB
	db $AF, $EA, $EE, $E2, $AE, $AE, $AE, $BA, $AA, $FE, $2B, $FB, $2E, $AE, $ED, $AF
	db $AE, $AB, $BB, $8A, $2E, $AA, $EE, $EE, $BA, $EE, $EB, $0A, $F9, $8E, $AB, $CB
	db $BA, $EA, $FB, $AA, $AA, $EA, $EE, $EF, $B6, $AA, $EE, $AE, $EA, $EB, $BF, $BE
	db $AA, $EE, $AA, $AB, $AA, $EA, $AE, $EE, $AA, $E2, $EE, $8A, $EE, $AA, $BE, $EB
	db $FB, $AA, $BE, $EC, $8A, $EE, $AA, $AA, $FA, $AE, $AB, $2B, $22, $A2, $0A, $30
	db $8A, $AA, $A2, $00, $22, $4A, $2A, $B2, $A8, $88, $88, $3A, $0A, $AA, $EA, $88
	db $22, $32, $8A, $8B, $28, $8A, $A8, $0A, $8A, $4A, $A8, $88, $12, $4A, $2A, $2A
	db $8A, $AA, $AB, $AA, $22, $A2, $8E, $A9, $8A, $A8, $A8, $E2, $AA, $00, $AA, $AA
	db $2A, $6A, $A2, $A8, $2A, $A0, $6A, $2A, $A2, $2A, $A2, $8A, $AA, $AA, $AA, $8A
	db $08, $00, $6E, $0A, $A2, $AA, $08, $2A, $AA, $A4, $A8, $AA, $8A, $AA, $62, $8A
	db $AA, $AA, $EA, $A0, $2A, $A0, $28, $A8, $88, $0A, $8A, $88, $48, $08, $0A, $AC
	db $2E, $A8, $88, $28, $A8, $AA, $AE, $E8, $08, $A8, $E0, $E8, $8A, $28, $CA, $BA
	db $A2, $A2, $28, $AA, $6A, $00, $08, $AC, $A8, $0A, $04, $DA, $BA, $BB, $EA, $FE
	db $7A, $EE, $EA, $FF, $E2, $FB, $EC, $FA, $76, $AA, $6F, $BF, $EB, $E2, $EF, $F8
	db $AB, $8A, $FA, $BE, $BA, $AE, $8A, $AE, $DB, $BE, $EA, $EA, $FA, $FE, $FF, $3B
	db $7B, $BE, $BA, $BB, $FC, $AB, $FA, $DA, $B3, $9A, $FD, $DA, $AA, $BE, $EA, $FE
	db $BA, $82, $EB, $BE, $EE, $BB, $AB, $A8, $A6, $FE, $9A, $FA, $AA, $AB, $BE, $EF
	db $AF, $AE, $BE, $EF, $FA, $FB, $AB, $B6, $EE, $FE, $AE, $EA, $AE, $A8, $3B, $6E
	db $FB, $AA, $AB, $FF, $AA, $AA, $CB, $EB, $2E, $EA, $AE, $AF, $FE, $EB, $BB, $EF
	db $EA, $AA, $EA, $AE, $AB, $AF, $F2, $AF, $3A, $BE, $AE, $AA, $AC, $AE, $E2, $EF
	db $2A, $FE, $EF, $4D, $EA, $AB, $EB, $AA, $EE, $AC, $F6, $0A, $E2, $AA, $8A, $88
	db $30, $86, $0E, $26, $BE, $20, $8A, $0A, $8A, $22, $02, $B4, $A2, $82, $AA, $B9
	db $2A, $A6, $A6, $AA, $A2, $26, $2A, $28, $C2, $3A, $2A, $88, $6A, $B2, $B0, $AA
	db $23, $2A, $A2, $88, $A2, $28, $2A, $AE, $AA, $8A, $A8, $20, $48, $88, $AA, $80
	db $BA, $2A, $AC, $82, $AA, $E8, $84, $AE, $28, $00, $8A, $8A, $C2, $2A, $88, $20
	db $AA, $AA, $52, $6A, $A2, $38, $26, $A0, $28, $AA, $8A, $28, $88, $A0, $8E, $CE
	db $8A, $A8, $2A, $BA, $20, $A3, $2C, $B2, $82, $A8, $02, $12, $BA, $18, $8A, $EA
	db $A8, $A8, $0A, $A8, $02, $0A, $A3, $E2, $82, $2A, $A2, $8A, $0A, $A2, $B0, $00
	db $82, $A6, $E2, $22, $AE, $AA, $A2, $0A, $AA, $2A, $00



SECTION "bank0B", ROMX, BANK[$0B]


UnknownData_0x2C000:
INCBIN "baserom.gb", $2C000, $2C2F0 - $2C000
;$2C2F0 Pointers to levels 
	dw Level_05
	dw Level_06
	dw Level_31
	dw Level_30
	dw Level_29
	dw Level_32
	
INCBIN "baserom.gb", $2C2FC, $2C500 - $2C2FC

Level_05: ;$2C500
INCBIN "levels/level05.bin"

Level_06: ;$2CCA7
INCBIN "levels/level06.bin"

Level_31: ;$2D192
INCBIN "levels/level31.bin"

Level_30: ;$2D40B
INCBIN "levels/level30.bin"

Level_29: ;$2D8D7
INCBIN "levels/level29.bin"

Level_32: ;$2E0F5
INCBIN "levels/level32.bin"

INCBIN "baserom.gb", $2E6AA, $30000 - $2E6AA

SECTION "bank0C", ROMX, BANK[$0C]


UnknownJump_0x30000:
	call DisableVBlank
	call UnknownCall_0x2B8B
	ld de, $9800
	ld hl, $4A52

UnknownRJump_0x3000C:
	ld a, [hli]
	ld [de], a
	inc de
	ld a, d
	cp $9C
	jr nz, UnknownRJump_0x3000C
	ld a, 228
	ld [sBGPalette], a
	ldh_n_a $47
	ld a, 208
	ld [sOAMPalette1], a
	ldh_n_a $48
	ld a, 56
	ld [sOAMPalette2], a
	ldh_n_a $49
	ld a, 40
	ldh [$FFC2], a
	ld a, 16
	ldh [$FFC0], a
	call UnknownCall_0x28D9
	xor a
	ld [$A277], a
	ld [sScrollY], a
	ld [sScrollX], a
	ld [$A2C6], a
	ld a, 131
	ldh_n_a $40
	ld a, 5
	ld [$A460], a
	ld a, 13
	ld [$A468], a
	xor a
	ld [sEasyMode], a
	ldh_a_n $9B
	inc a
	ldh_n_a $9B
	ret

UnknownJump_0x3005F:
	ld a, 1
	ldh [$FFBB], a
	xor a
	ld [$A2C7], a
	ld a, [sEasyMode]
	cp $01
	jr nz, UnknownRJump_0x3007D
	ld a, 68
	ldh [$FFC5], a
	ld a, 48
	ldh [$FFC4], a
	ld a, 241
	ldh [$FFC6], a
	call UnknownCall_0x2B13

UnknownRJump_0x3007D:
	call UnknownCall_0x3012E
	ld a, [$A2C7]
	and a
	jr nz, UnknownRJump_0x300E6
	ldh a, [$FFC0]
	ldh [$FFC4], a
	ldh a, [$FFC2]
	ldh [$FFC5], a
	ld a, [sEasyMode]
	cp $01
	jr nz, UnknownRJump_0x3009B
	ldh a, [$FFC6]
	add 32
	ldh [$FFC6], a

UnknownRJump_0x3009B:
	ld a, [$A2C6]
	and a
	jr z, UnknownRJump_0x300E1
	ld a, [$A277]
	cp $04
	jr z, UnknownRJump_0x300B4
	ldh_a_n $97
	and $01
	jr nz, UnknownRJump_0x300B4
	ld a, 4
	ld [$A478], a

UnknownRJump_0x300B4:
	ld hl, $412A
	ldh_a_n $97
	and $0C
	srl a
	srl a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld b, a
	ld a, 201
	add b
	ldh [$FFC6], a
	ld a, b
	and $01
	ld c, a
	ldh a, [$FFC4]
	inc a
	sub c
	ldh [$FFC4], a
	ld a, [sMarioDirection]
	cp $01
	jr z, UnknownRJump_0x300E1
	ld a, 204
	add b
	ldh [$FFC6], a

UnknownRJump_0x300E1:
	call UnknownCall_0x2B13
	jr UnknownRJump_0x300FE

UnknownRJump_0x300E6:
	ldh a, [$FFC0]
	ldh [$FFC4], a
	ldh a, [$FFC2]
	ldh [$FFC5], a
	ldh_a_n $97
	and $0C
	srl a
	srl a
	add 207
	ldh [$FFC6], a
	call UnknownCall_0x2B13

UnknownRJump_0x300FE:
	ld a, 88
	ldh [$FFC4], a
	ld a, 32
	ldh [$FFC5], a
	ld a, [$A042]
	ldh [$FFC6], a
	call UnknownCall_0x2B3B
	ld a, 64
	ldh [$FFC5], a
	ld a, [$A092]
	ldh [$FFC6], a
	call UnknownCall_0x2B3B
	ld a, 96
	ldh [$FFC5], a
	ld a, [$A0E2]
	ldh [$FFC6], a
	call UnknownCall_0x2B3B
	call UnknownCall_0x2B63
	ret

UnknownData_0x3012A:
INCBIN "baserom.gb", $3012A, $3012E - $3012A


UnknownCall_0x3012E:
	ld a, [$A277]
	rst $28

UnknownData_0x30132:
INCBIN "baserom.gb", $30132, $30140 - $30132

	ld a, [$A278]
	dec a
	ld [$A278], a
	jr nz, UnknownRJump_0x30159

UnknownRJump_0x30149:
	ld a, 124
	ldh [$FFC0], a
	ld a, 1
	ld [$A277], a
	xor a
	ld [$A2C6], a
	ldh [$FFBB], a
	ret

UnknownRJump_0x30159:
	srl a
	and $F0
	swap a
	add 211
	ldh [$FFC6], a
	ldh a, [$FFC2]
	ldh [$FFC5], a
	xor a
	ldh [$FFBB], a
	ld a, [$A278]
	cp $40
	jr c, UnknownRJump_0x3017C
	srl a
	srl a
	add 112
	ldh [$FFC4], a
	call UnknownCall_0x2B13

UnknownRJump_0x3017C:
	ld a, [$A278]
	and $F0
	swap a
	sub 4
	ld b, a
	ld a, [$A2D1]
	sub b
	ld [$A2D1], a
	ld a, [$A278]
	cp $40
	jr nc, UnknownRJump_0x301A6
	ld a, [$A2D1]
	cp $7C
	jr c, UnknownRJump_0x301A6
	ld a, 124
	ld [$A2D1], a
	ld a, 16
	ldh [$FFC6], a
	jr UnknownRJump_0x30149

UnknownRJump_0x301A6:
	ld a, [$A2D1]
	ldh [$FFC4], a
	ld a, [$A278]
	and $18
	sla a
	swap a
	ld e, a
	ld d, 0
	ld hl, $41C2
	add hl, de
	ld a, [hl]
	ldh [$FFC6], a
	call UnknownCall_0x2B13
	ret

UnknownData_0x301C2:
INCBIN "baserom.gb", $301C2, $301C6 - $301C2

	xor a
	ldh [$FFBB], a
	ld a, 16
	ldh [$FFC6], a
	ldh a, [$FFC0]
	add 1
	ldh [$FFC0], a
	ld a, [$A278]
	dec a
	ld [$A278], a
	ret nz
	ld a, 21
	ld [$A224], a
	ldh a, [$FFC2]
	and $60
	srl a
	swap a
	dec a
	ld [$A2A3], a
	ld a, [$A2C6]
	and a
	jr nz, UnknownRJump_0x30227
	ld a, 21
	ldh_n_a $9B
	ld a, [$A2A3]
	ld b, a
	sla a
	sla a
	add b
	swap a
	ld e, a
	ld d, 160
	ld hl, $A840
	ld b, 64

UnknownRJump_0x3020A:
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, UnknownRJump_0x3020A
	ld l, e
	ld h, d
	ld a, [hli]
	ld [sCoinLow], a
	ld a, [hli]
	ld [sCoinHigh], a
	ld a, [hli]
	ld [$A2C5], a
	ld a, [hli]
	ld [$A22C], a
	ld a, [hli]
	ld [$A28D], a
	ret

UnknownRJump_0x30227:
	ld a, [$A2A3]
	ld b, a
	sla a
	sla a
	add b
	swap a
	ld l, a
	ld h, 160
	ld b, 64
	xor a

UnknownRJump_0x30238:
	ld [hli], a
	dec b
	jr nz, UnknownRJump_0x30238
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, 5
	ld [hli], a
	xor a
	ld [hli], a
	ld a, 2
	ld [hli], a
	ld a, 18
	ld [hli], a
	ld a, 52
	ld [hli], a
	ld a, 86
	ld [hli], a
	ld a, 120
	ld [hl], a
	ld a, 128
	ld [$A278], a
	ld a, 6
	ld [$A277], a
	xor a
	ld [$A2C6], a
	ld a, 144
	ld [$A2D1], a
	ld a, 5
	ld [$A478], a
	ret
	ld a, 9
	ldh [$FFC6], a
	ld a, [$A278]
	dec a
	ld [$A278], a
	cp $2B
	call z, UnknownCall_0x30291
	ld a, [$A278]
	cp $2B
	jr nc, UnknownRJump_0x3028A
	cp $0B
	jr nc, UnknownRJump_0x302C2
	jr UnknownRJump_0x302AD

UnknownRJump_0x3028A:
	ldh a, [$FFC0]
	dec a
	dec a
	ldh [$FFC0], a
	ret

UnknownCall_0x30291:
	ld a, [$A2C6]
	xor $FF
	ld [$A2C6], a
	ld a, 255
	ld [sMarioDirection], a
	ld a, 8
	ld [$A460], a
	ld a, [$A2C6]
	and a
	ret z
	xor a
	ld [sEasyMode], a
	ret

UnknownRJump_0x302AD:
	ldh a, [$FFC0]
	inc a
	inc a
	ldh [$FFC0], a
	ld a, [$A278]
	and a
	ret nz
	ld a, 1
	ld [$A277], a
	ld a, 124
	ldh [$FFC0], a
	ret

UnknownRJump_0x302C2:
	ld a, 255
	ld [$A2C7], a
	ret
	ld a, 255
	ld [sMarioDirection], a
	call UnknownCall_0x3040D
	ld a, [$A222]
	and $0C
	srl a
	srl a
	add 5
	ldh [$FFC6], a
	ldh a, [$FFC2]
	sub 1
	ldh [$FFC2], a
	ld a, [$A278]
	dec a
	ld [$A278], a
	ret nz
	ld a, 1
	ld [$A277], a
	ret
	ld a, 1
	ld [sMarioDirection], a
	call UnknownCall_0x3040D
	ld a, [$A222]
	and $0C
	srl a
	srl a
	add 1
	ldh [$FFC6], a
	ldh a, [$FFC2]
	add 1
	ldh [$FFC2], a
	ld a, [$A278]
	dec a
	ld [$A278], a
	ret nz
	ld a, 1
	ld [$A277], a
	ret

UnknownJump_0x3031A:
UnknownRJump_0x3031A:
	ld a, [sMarioDirection]
	xor $FF
	add 2
	sla a
	ldh [$FFC6], a
	ret
	ldh_a_n $81
	cp $04
	jp z, UnknownJump_0x3037D
	ldh_a_n $80
	and $30
	jr z, UnknownRJump_0x30342
	ldh_a_n $80
	cp $10
	jp z, UnknownJump_0x30398
	cp $20
	jp z, UnknownJump_0x303B7

UnknownRJump_0x30342:
	ldh_a_n $81
	cp $80
	jr z, UnknownRJump_0x30367
	cp $08
	jr z, UnknownRJump_0x30367
	cp $01
	jr nz, UnknownRJump_0x3031A
	ldh a, [$FFC2]
	cp $88
	jr nz, UnknownRJump_0x3031A
	ld a, 4
	ld [$A277], a
	ld a, 55
	ld [$A278], a
	ld a, 1
	ld [$A460], a
	ret

UnknownRJump_0x30367:
	ldh a, [$FFC2]
	cp $80
	jr nc, UnknownRJump_0x3031A
	ld a, 5
	ld [$A277], a
	ld a, 64
	ld [$A278], a
	ld a, 5
	ld [$A460], a
	ret

UnknownJump_0x3037D:
	ld a, [$A2C6]
	and a
	ret nz
	ld a, [sEasyMode]
	xor $FF
	and $01
	ld [sEasyMode], a
	ld a, [sMarioDirection]
	xor $FF
	add 2
	sla a
	ldh [$FFC6], a
	ret

UnknownJump_0x30398:
	ldh a, [$FFC2]
	cp $88
	jp nc, UnknownJump_0x3031A
	ld a, 2
	ld [$A277], a
	ld a, 32
	ld [$A278], a
	ld a, [$A222]
	and $0C
	srl a
	srl a
	add 1
	ldh [$FFC6], a
	ret

UnknownJump_0x303B7:
	ldh a, [$FFC2]
	cp $30
	jp c, UnknownJump_0x3031A
	ld a, 3
	ld [$A277], a
	ld a, 32
	ld [$A278], a
	ld a, [$A222]
	and $0C
	srl a
	srl a
	add 5
	ldh [$FFC6], a
	ret
	ld a, 16
	ldh [$FFC6], a
	xor a
	ldh [$FFBB], a
	ldh a, [$FFC0]
	cp $30
	jr c, UnknownRJump_0x303EB
	ld a, 10
	ldh [$FFC6], a
	ld a, 1
	ldh [$FFBB], a

UnknownRJump_0x303EB:
	ldh a, [$FFC0]
	cp $7C
	jr nc, UnknownRJump_0x30400
	add 2
	ldh [$FFC0], a
	cp $40
	jr c, UnknownRJump_0x303FF
	ldh a, [$FFC0]
	add 1
	ldh [$FFC0], a

UnknownRJump_0x303FF:
	ret

UnknownRJump_0x30400:
	ld a, 1
	ld [$A277], a
	ld [sMarioDirection], a
	ld a, 124
	ldh [$FFC0], a
	ret

UnknownCall_0x3040D:
	ld a, [$A222]
	add 1
	ld [$A222], a
	cp $0C
	ret c
	xor a
	ld [$A222], a
	ret

UnknownJump_0x3041D:
	ld a, [$A27D]
	bit 7, a
	jr nz, UnknownRJump_0x3042D
	ld a, [$A2C5]
	add 1
	daa
	ld [$A2C5], a

UnknownRJump_0x3042D:
	xor a
	ld [$A299], a
	ld a, 192
	ldh [$FFC0], a
	ld hl, $4985
	ld a, [sCurLevel]
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ldh [$FFC2], a
	xor a
	ld [$A277], a
	ld [$A222], a
	ldh_a_n $9B
	inc a
	ldh_n_a $9B
	ret

UnknownJump_0x30451:
	call UnknownCall_0x3046B
	call UnknownCall_0x307BC
	call UnknownCall_0x2B63
	ret

UnknownJump_0x3045B:
	ldh a, [$FFC0]
	ldh [$FFC4], a
	ldh a, [$FFC2]
	ldh [$FFC5], a
	ld a, 1
	ldh [$FFBB], a
	call UnknownCall_0x2B13
	ret

UnknownCall_0x3046B:
	ld a, [$A277]
	rst $28

UnknownData_0x3046F:
INCBIN "baserom.gb", $3046F, $30477 - $3046F

	ld a, [$A266]
	and a
	ret nz
	ld a, [$A2CA]
	ld [$A2C9], a
	and a
	jr z, UnknownRJump_0x30494
	dec a
	ld [$A2CA], a
	ld a, 64
	ld [$A266], a
	ld a, 10
	ld [$A478], a
	ret

UnknownRJump_0x30494:
	ld a, [$A277]
	inc a
	ld [$A277], a
	ld a, 255
	ld [$A266], a
	ret
	ld a, [$A266]
	and a
	ret nz
	ld a, 20
	ldh_n_a $9B
	ret
	ld a, [$A267]
	ld b, a
	ld a, [$A266]
	or b
	jr nz, UnknownRJump_0x3050A
	ld a, 208
	ld [sOAMPalette1], a
	ld hl, $44F1
	ld a, [sCurLevel]
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld e, a
	ld d, 0
	ld hl, $A848
	add hl, de
	ld a, 128
	ld [hl], a
	ld a, [$A2CB]
	cp $05
	jr z, UnknownRJump_0x304DD
	ld a, 20
	ldh_n_a $9B
	ret

UnknownRJump_0x304DD:
	ld a, [$A277]
	inc a
	ld [$A277], a
	ld a, 64
	ld [$A266], a
	ld a, 5
	ld [$A2CA], a
	jp UnknownJump_0x3045B

UnknownData_0x304F1:
INCBIN "baserom.gb", $304F1, $3050A - $304F1


UnknownRJump_0x3050A:
	ld hl, $499D
	ld a, [sCurLevel]
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ldh [$FFC0], a
	ld hl, $49B5
	ld a, [sCurLevel]
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ldh [$FFC6], a
	ld a, 208
	ld [sOAMPalette1], a
	ldh_a_n $97
	and $1F
	cp $04
	jp nc, UnknownJump_0x3045B
	ld a, 0
	ld [sOAMPalette1], a
	jp UnknownJump_0x3045B
	ldh a, [$FFC0]
	ldh [$FFC4], a
	ldh a, [$FFC2]
	ldh [$FFC5], a
	ld a, 1
	ldh [$FFBB], a
	ldh_a_n $97
	and $04
	srl a
	srl a
	add 197
	ldh [$FFC6], a
	call UnknownCall_0x2B13
	ld a, [$A222]
	add 8
	ld [$A222], a
	cp $50
	jr c, UnknownRJump_0x30567
	xor a
	ld [$A222], a

UnknownRJump_0x30567:
	ld a, [$A222]
	and $F0
	swap a
	add 191
	ldh [$FFC6], a
	ld hl, $499D
	ld a, [sCurLevel]
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld b, a
	ldh a, [$FFC0]
	cp b
	jr z, UnknownRJump_0x30593
	ldh_a_n $97
	bit 0, a
	jp nz, UnknownJump_0x3045B
	ldh a, [$FFC0]
	inc a
	ldh [$FFC0], a
	jp UnknownJump_0x3045B

UnknownRJump_0x30593:
	ld a, 15
	ld [$A468], a
	ld a, [$A2CB]
	cp $05
	jr nz, UnknownRJump_0x305A4
	ld a, 26
	ld [$A468], a

UnknownRJump_0x305A4:
	ld a, 1
	ld [$A277], a
	ld a, 1
	ld [$A267], a
	ld a, 255
	ld [$A266], a
	jp UnknownJump_0x3045B

UnknownJump_0x305B6:
	call DisableVBlank
	ld bc, $1800
	ld hl, $4C92
	ld de, $8000
	call CopyMem
	ld de, $9800
	ld hl, $6492

UnknownRJump_0x305CB:
	ld a, [hli]
	ld [de], a
	inc de
	ld a, d
	cp $9B
	jr nz, UnknownRJump_0x305CB
	xor a
	ld [$A2CC], a
	ld a, [$A84D]
	bit 7, a
	jr z, UnknownRJump_0x30629
	ld a, [$A851]
	bit 7, a
	jr z, UnknownRJump_0x30629
	ld a, [$A865]
	bit 7, a
	jr z, UnknownRJump_0x30629
	ld a, [$A85F]
	bit 7, a
	jr z, UnknownRJump_0x30629
	ld a, [$A859]
	bit 7, a
	jr z, UnknownRJump_0x30629
	ld a, [$A856]
	bit 7, a
	jr z, UnknownRJump_0x30629
	ld a, 116
	ld hl, $99C8
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $99A8
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $9988
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $9968
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld hl, $9948
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld [$A2CC], a

UnknownRJump_0x30629:
	ld a, 228
	ld [sBGPalette], a
	ldh_n_a $47
	ld a, 208
	ld [sOAMPalette1], a
	ldh_n_a $48
	ld a, 56
	ld [sOAMPalette2], a
	ldh_n_a $49
	xor a
	ld [sScrollY], a
	ldh_n_a $42
	ld [sScrollX], a
	ldh_n_a $43
	ld [$A26E], a
	ld a, 64
	ld [$A278], a
	xor a
	ld [$A277], a
	ld a, 88
	ldh [$FFC2], a
	ldh_a_n $9B
	cp $1D
	jr z, UnknownRJump_0x3066A
	ld a, 255
	ld [$A468], a

UnknownRJump_0x3066A:
	call UnknownCall_0x2B77
	ld a, 195
	ldh_n_a $40
	ldh_a_n $9B
	inc a
	ldh_n_a $9B
	ret

UnknownJump_0x3067A:
	call UnknownCall_0x30693
	ldh a, [$FFC0]
	ldh [$FFC4], a
	ldh a, [$FFC2]
	ldh [$FFC5], a
	ld a, 1
	ldh [$FFBB], a
	call UnknownCall_0x2B13
	call UnknownCall_0x307BC
	call UnknownCall_0x2B63
	ret

UnknownCall_0x30693:
	ld a, [$A277]
	rst $28

UnknownData_0x30697:
INCBIN "baserom.gb", $30697, $3069F - $30697

	ld hl, $46D1
	ld a, [$A266]
	and $F0
	swap a
	sla a
	sla a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld [sBGPalette], a
	ld a, [hli]
	ld [sOAMPalette1], a
	ld a, [hl]
	ld [sOAMPalette2], a
	ld a, 187
	ldh [$FFC6], a
	ld a, [$A266]
	and a
	ret nz
	ld a, 24
	ld [sCurLevel], a
	ld a, 22
	ldh_n_a $9B
	ret

UnknownData_0x306D1:
INCBIN "baserom.gb", $306D1, $306E1 - $306D1

	ld a, 187
	ldh [$FFC6], a
	ld a, [$A2CB]
	cp $06
	jr nz, UnknownRJump_0x30700
	ldh_a_n $81
	and $49
	jr z, UnknownRJump_0x30700
	ld a, [$A277]
	inc a
	ld [$A277], a
	ld a, 64
	ld [$A266], a
	ret

UnknownRJump_0x30700:
	ldh_a_n $81
	cp $80
	ret nz
	ld a, 1
	ld [$A277], a
	ld a, 64
	ld [$A278], a
	ret
	ldh_a_n $97
	and $0C
	srl a
	srl a
	ld e, a
	ld d, 0
	ld hl, $4748
	add hl, de
	ld a, [hl]
	ldh [$FFC6], a
	ld a, [$A278]
	dec a
	ld [$A278], a
	jr z, UnknownRJump_0x30736
	srl a
	ld b, a
	ld a, 168
	sub b
	ldh [$FFC0], a
	ret

UnknownRJump_0x30736:
	ld a, 20
	ldh_n_a $9B
	xor a
	ld [$A266], a
	ld [$A267], a
	ld a, 1
	ld [$A224], a
	ret

UnknownData_0x30748:
INCBIN "baserom.gb", $30748, $3074C - $30748

	ldh_a_n $97
	and $0C
	srl a
	srl a
	ld e, a
	ld d, 0
	ld hl, $4777
	add hl, de
	ld a, [hl]
	ldh [$FFC6], a
	ld a, [$A278]
	dec a
	ld [$A278], a
	jr z, UnknownRJump_0x30771
	srl a
	ld b, a
	ld a, 136
	add b
	ldh [$FFC0], a
	ret

UnknownRJump_0x30771:
	ld a, 2
	ld [$A277], a
	ret

UnknownData_0x30777:
INCBIN "baserom.gb", $30777, $307BC - $30777


UnknownCall_0x307BC:
	xor a
	ld [$A2CB], a
	ld a, 1
	ldh [$FFBB], a
	ld a, [$A84D]
	bit 7, a
	jr z, UnknownRJump_0x307E4
	ld a, [$498A]
	ldh [$FFC5], a
	ld a, [$49A2]
	ldh [$FFC4], a
	ld a, [$49BA]
	ldh [$FFC6], a
	call UnknownCall_0x2B13
	ld a, [$A2CB]
	inc a
	ld [$A2CB], a

UnknownRJump_0x307E4:
	ld a, [$A851]
	bit 7, a
	jr z, UnknownRJump_0x30804
	ld a, [$498E]
	ldh [$FFC5], a
	ld a, [$49A6]
	ldh [$FFC4], a
	ld a, [$49BE]
	ldh [$FFC6], a
	call UnknownCall_0x2B13
	ld a, [$A2CB]
	inc a
	ld [$A2CB], a

UnknownRJump_0x30804:
	ld a, [$A865]
	bit 7, a
	jr z, UnknownRJump_0x30824
	ld a, [$4992]
	ldh [$FFC5], a
	ld a, [$49AA]
	ldh [$FFC4], a
	ld a, [$49C2]
	ldh [$FFC6], a
	call UnknownCall_0x2B13
	ld a, [$A2CB]
	inc a
	ld [$A2CB], a

UnknownRJump_0x30824:
	ld a, [$A85F]
	bit 7, a
	jr z, UnknownRJump_0x30844
	ld a, [$4995]
	ldh [$FFC5], a
	ld a, [$49AD]
	ldh [$FFC4], a
	ld a, [$49C5]
	ldh [$FFC6], a
	call UnknownCall_0x2B13
	ld a, [$A2CB]
	inc a
	ld [$A2CB], a

UnknownRJump_0x30844:
	ld a, [$A859]
	bit 7, a
	jr z, UnknownRJump_0x30864
	ld a, [$4998]
	ldh [$FFC5], a
	ld a, [$49B0]
	ldh [$FFC4], a
	ld a, [$49C8]
	ldh [$FFC6], a
	call UnknownCall_0x2B13
	ld a, [$A2CB]
	inc a
	ld [$A2CB], a

UnknownRJump_0x30864:
	ld a, [$A856]
	bit 7, a
	ret z
	ld a, [$499C]
	ldh [$FFC5], a
	ld a, [$49B4]
	ldh [$FFC4], a
	ld a, [$49CC]
	ldh [$FFC6], a
	call UnknownCall_0x2B13
	ld a, [$A2CB]
	inc a
	ld [$A2CB], a
	ret

UnknownCall_0x30884:
	xor a
	ld [$A2D3], a
	ld a, [$A267]
	and a
	jr nz, UnknownRJump_0x3089A
	ld a, [$A266]
	cp $80
	jr nc, UnknownRJump_0x3089A
	sub 128
	ld [$A2D3], a

UnknownRJump_0x3089A:
	ld a, 1
	ldh [$FFBB], a
	ld a, [$A2B5]
	bit 5, a
	jr z, UnknownRJump_0x308C3
	ld a, [$498A]
	ldh [$FFC5], a
	ld a, [$A2D3]
	ld b, a
	ld a, [$49A2]
	add b
	ldh [$FFC4], a
	ld a, [$49BA]
	ldh [$FFC6], a
	ld a, b
	and a
	jr z, UnknownRJump_0x308C0
	call UnknownCall_0x3097C

UnknownRJump_0x308C0:
	call UnknownCall_0x2B13

UnknownRJump_0x308C3:
	ld a, [$A2B5]
	bit 4, a
	jr z, UnknownRJump_0x308E8
	ld a, [$498E]
	ldh [$FFC5], a
	ld a, [$A2D3]
	ld b, a
	ld a, [$49A6]
	add b
	ldh [$FFC4], a
	ld a, [$49BE]
	ldh [$FFC6], a
	ld a, b
	and a
	jr z, UnknownRJump_0x308E5
	call UnknownCall_0x3097C

UnknownRJump_0x308E5:
	call UnknownCall_0x2B13

UnknownRJump_0x308E8:
	ld a, [$A2B5]
	bit 3, a
	jr z, UnknownRJump_0x3090D
	ld a, [$4992]
	ldh [$FFC5], a
	ld a, [$A2D3]
	ld b, a
	ld a, [$49AA]
	add b
	ldh [$FFC4], a
	ld a, [$49C2]
	ldh [$FFC6], a
	ld a, b
	and a
	jr z, UnknownRJump_0x3090A
	call UnknownCall_0x3097C

UnknownRJump_0x3090A:
	call UnknownCall_0x2B13

UnknownRJump_0x3090D:
	ld a, [$A2B5]
	bit 2, a
	jr z, UnknownRJump_0x30932
	ld a, [$4995]
	ldh [$FFC5], a
	ld a, [$A2D3]
	ld b, a
	ld a, [$49AD]
	add b
	ldh [$FFC4], a
	ld a, [$49C5]
	ldh [$FFC6], a
	ld a, b
	and a
	jr z, UnknownRJump_0x3092F
	call UnknownCall_0x3097C

UnknownRJump_0x3092F:
	call UnknownCall_0x2B13

UnknownRJump_0x30932:
	ld a, [$A2B5]
	bit 1, a
	jr z, UnknownRJump_0x30957
	ld a, [$4998]
	ldh [$FFC5], a
	ld a, [$A2D3]
	ld b, a
	ld a, [$49B0]
	add b
	ldh [$FFC4], a
	ld a, [$49C8]
	ldh [$FFC6], a
	ld a, b
	and a
	jr z, UnknownRJump_0x30954
	call UnknownCall_0x3097C

UnknownRJump_0x30954:
	call UnknownCall_0x2B13

UnknownRJump_0x30957:
	ld a, [$A2B5]
	bit 0, a
	ret z
	ld a, [$499C]
	ldh [$FFC5], a
	ld a, [$A2D3]
	ld b, a
	ld a, [$49B4]
	add b
	ldh [$FFC4], a
	ld a, [$49CC]
	ldh [$FFC6], a
	ld a, b
	and a
	jr z, UnknownRJump_0x30978
	call UnknownCall_0x3097C

UnknownRJump_0x30978:
	call UnknownCall_0x2B13
	ret

UnknownCall_0x3097C:
	and $06
	srl a
	add 222
	ldh [$FFC6], a
	ret

UnknownData_0x30985:
INCBIN "baserom.gb", $30985, $309CD - $30985


UnknownJump_0x309CD:
	ld a, [$A2C9]
	dec a
	sla a
	sla a
	ld e, a
	ld d, 0
	ld hl, $4A2A
	add hl, de
	ld de, $99C8
	ld b, 4

UnknownRJump_0x309E1:
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, UnknownRJump_0x309E1
	ld de, $99A8
	ld b, 4

UnknownRJump_0x309EC:
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, UnknownRJump_0x309EC
	ld de, $9988
	ld b, 4

UnknownRJump_0x309F7:
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, UnknownRJump_0x309F7
	ld de, $9968
	ld b, 4

UnknownRJump_0x30A02:
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, UnknownRJump_0x30A02
	ld de, $9948
	ld b, 4

UnknownRJump_0x30A0D:
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, UnknownRJump_0x30A0D
	xor a
	ld [$A2C9], a
	call $FFA0
	ld a, [$A24E] ;prepare bank switch
	ld [$2100], a
	ld a, 1
	ldh_n_a $82
	pop hl
	pop de
	pop bc
	pop af
	reti

UnknownData_0x30A2A:
INCBIN "baserom.gb", $30A2A, $34000 - $30A2A



SECTION "bank0D", ROMX, BANK[$0D]


GFX_OW_Overworld: ;$34000
INCBIN "gfx/overworld/overworld.2bpp"

GFX_OW_MacroZoneBase: ;$35800
INCBIN "gfx/overworld/macrozone_base.2bpp"

GFX_OW_MacroZone: ;$35A00
INCBIN "gfx/overworld/macrozone.2bpp"

TileMapping_Overworld1x1: ;$37000
INCBIN "tilemaps/overworld/overworld1x1.bin"

TileMapping_Overworld2x1: ;$37400
INCBIN "tilemaps/overworld/overworld2x1.bin"

TileMapping_Overworld1x2: ;$37800
INCBIN "tilemaps/overworld/overworld1x2.bin"

TileMapping_Overworld2x2: ;$37C00
INCBIN "tilemaps/overworld/overworld2x2.bin"


SECTION "bank0E", ROMX, BANK[$0E]


GFX_OW_PumpkinZoneBase: ;$38000
INCBIN "gfx/overworld/pumpkinzone_base.2bpp"

GFX_OW_PumpkinZone: ;$38200
INCBIN "gfx/overworld/pumpkinzone.2bpp"

GFX_OW_TreeZoneBase: ;$39800
INCBIN "gfx/overworld/treezone_base.2bpp"

GFX_OW_TreeZone: ;$39A000
INCBIN "gfx/overworld/treezone.2bpp"

TileMapping_PumpkinZone: ;$3B000
INCBIN "tilemaps/overworld/pumpkinzone.bin"

TileMapping_TreeZone:
INCBIN "tilemaps/overworld/treezone.bin"

TileMapping_SpaceZone:
INCBIN "tilemaps/overworld/spacezone.bin"

TileMapping_MacroZone:
INCBIN "tilemaps/overworld/macrozone.bin"

TileMapping_TurtleZone:
INCBIN "tilemaps/overworld/turtlezone.bin"

TileMapping_MarioZone:
INCBIN "tilemaps/overworld/mariozone.bin"

TileMapping_WarioCastle:
INCBIN "tilemaps/overworld/wariocastle.bin"

UnknownData_0x3BFC0: ;64 bytes after the overworld tilemaps (wariocastle tail?)
	db $A8, $B3, $32, $A2, $22, $20, $62, $C8, $01, $0A, $00, $08, $00, $63, $20, $21
	db $02, $02, $2D, $78, $38, $30, $00, $B2, $01, $02, $40, $BA, $56, $02, $23, $22
	db $04, $12, $68, $55, $02, $20, $92, $83, $06, $90, $C2, $09, $18, $47, $C2, $52
	db $AA, $5C, $00, $A0, $00, $2E, $00, $A0, $32, $62, $1A, $1E, $24, $20, $A4, $88



SECTION "bank0F", ROMX, BANK[$0F]


UnknownJump_0x3C000:
	ld a, [$A68B]
	or a
	jp z, UnknownJump_0x3C04D
	cp $01
	jp z, UnknownJump_0x3C063
	cp $02
	jp z, UnknownJump_0x3C06F
	cp $03
	jp z, UnknownJump_0x3C07B
	cp $04
	jp z, UnknownJump_0x3C087
	cp $05
	jp z, UnknownJump_0x3C093
	cp $06
	jp z, UnknownJump_0x3C09F
	cp $07
	jp z, UnknownJump_0x3C0AB
	cp $08
	jp z, UnknownJump_0x3C0B7
	cp $09
	jp z, UnknownJump_0x3C0C3
	cp $0A
	jp z, UnknownJump_0x3C0CA
	cp $0B
	jp z, UnknownJump_0x3C0D1
	cp $0C
	jp z, UnknownJump_0x3C0D8
	cp $0D
	jp z, UnknownJump_0x3C0DF
	cp $0E
	jp z, UnknownJump_0x3C10E

UnknownJump_0x3C04D:
	call UnknownCall_0x3ED4C
	call UnknownCall_0x3C38C
	ld a, [$A68B]
	or a
	jp nz, UnknownJump_0x3C169
	call UnknownCall_0x3C13E
	call UnknownCall_0x3CFC8
	jp UnknownJump_0x3C169

UnknownJump_0x3C063:
	call UnknownCall_0x3C13E
	call UnknownCall_0x3D8E6
	call UnknownCall_0x3C38C
	jp UnknownJump_0x3C169

UnknownJump_0x3C06F:
	call UnknownCall_0x3C13E
	call UnknownCall_0x3DA2D
	call UnknownCall_0x3C38C
	jp UnknownJump_0x3C169

UnknownJump_0x3C07B:
	call UnknownCall_0x3C13E
	call UnknownCall_0x3DB12
	call UnknownCall_0x3C38C
	jp UnknownJump_0x3C169

UnknownJump_0x3C087:
	call UnknownCall_0x3C13E
	call UnknownCall_0x3DB40
	call UnknownCall_0x3C38C
	jp UnknownJump_0x3C169

UnknownJump_0x3C093:
	call UnknownCall_0x3C13E
	call UnknownCall_0x3DDD3
	call UnknownCall_0x3C38C
	jp UnknownJump_0x3C169

UnknownJump_0x3C09F:
	call UnknownCall_0x3C13E
	call UnknownCall_0x3DEC7
	call UnknownCall_0x3C38C
	jp UnknownJump_0x3C169

UnknownJump_0x3C0AB:
	call UnknownCall_0x3C13E
	call UnknownCall_0x3DFE8
	call UnknownCall_0x3C38C
	jp UnknownJump_0x3C169

UnknownJump_0x3C0B7:
	call UnknownCall_0x3C13E
	call UnknownCall_0x3DD8C
	call UnknownCall_0x3C38C
	jp UnknownJump_0x3C169

UnknownJump_0x3C0C3:
	call UnknownCall_0x3C13E
	call UnknownCall_0x3DDC3
	ret

UnknownJump_0x3C0CA:
	call UnknownCall_0x3C13E
	call UnknownCall_0x3DDC7
	ret

UnknownJump_0x3C0D1:
	call UnknownCall_0x3C13E
	call UnknownCall_0x3DDCB
	ret

UnknownJump_0x3C0D8:
	call UnknownCall_0x3C13E
	call UnknownCall_0x3DDCF
	ret

UnknownJump_0x3C0DF:
	call UnknownCall_0x3C13E
	ld a, 24
	ld hl, $4512
	call UnknownCall_0x3E00
	ld a, [$A7A6]
	cp $04
	jr c, UnknownRJump_0x3C101
	cp $07
	jr nc, UnknownRJump_0x3C101
	ldh_a_n $80
	and $20
	jr z, UnknownRJump_0x3C101

UnknownData_0x3C0FC:
INCBIN "baserom.gb", $3C0FC, $3C101 - $3C0FC


UnknownRJump_0x3C101:
	ld a, [$A7A6]
	cp $0A
	ret nz
	call UnknownCall_0x3E9FB
	call UnknownCall_0x3EF2B
	ret

UnknownJump_0x3C10E:
	call UnknownCall_0x3C13E
	ld a, 24
	ld hl, $4028
	call UnknownCall_0x3E00
	ld a, [$A7A6]
	cp $05
	jr nz, UnknownRJump_0x3C131
	ldh_a_n $80
	and $20
	jr z, UnknownRJump_0x3C131

UnknownData_0x3C127:
INCBIN "baserom.gb", $3C127, $3C131 - $3C127


UnknownRJump_0x3C131:
	ld a, [$A7A6]
	cp $0A
	ret nz
	call UnknownCall_0x3E9FB
	call UnknownCall_0x3EF2B
	ret

UnknownCall_0x3C13E:
	ld c, 4
	ld a, [$FF00+c]
	ld d, a
	ld a, [$A6B2]
	xor d
	ld [$A6B2], a
	ld a, [$A69A]
	inc a
	ld [$A69A], a
	ld a, [$A697]
	dec a
	ld [$A697], a
	ret nz
	ld a, 40
	ld [$A697], a
	ld c, 4
	ld a, [$FF00+c]
	ld d, a
	ld a, [$A696]
	xor d
	ld [$A696], a
	ret

UnknownJump_0x3C169:
	ei
	ld a, [$A690]
	or a
	ret nz
	ldh_a_n $81
	and $09
	ret z
	ld a, [$A7A0]
	or a
	ret nz
	ld a, [$A840]
	ld hl, $650E
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld e, a
	ld hl, $A848
	add hl, de
	ld c, [hl]
	bit 7, c
	jr z, UnknownRJump_0x3C1A2
	ld a, e
	cp $05
	ret z
	cp $09
	ret z
	cp $0E
	ret z
	cp $17
	ret z
	cp $1D
	ret z
	cp $11
	ret z

UnknownRJump_0x3C1A2:
	xor a
	ld [$A27D], a
	ld a, [$A840]
	ld hl, $4218
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	cp $FE
	jr z, UnknownRJump_0x3C201
	ld [sCurLevel], a
	ld a, c
	ld [$A27D], a
	ld a, 255
	ld [$A468], a
	call UnknownCall_0x2AAA
	ld a, [$A68B]
	cp $03
	jr z, UnknownRJump_0x3C1EC
	ld hl, $A102
	ld a, 27
	ld [hli], a
	ld a, 0
	ld [hl], a
	ld l, 6
	ld a, 10
	ld [hli], a
	ld a, 32
	ld [hl], a
	ld l, 10
	ld a, 28
	ld [hli], a
	ld a, 0
	ld [hl], a
	ld l, 14
	ld a, 11
	ld [hli], a
	ld a, 32
	ld [hl], a

UnknownRJump_0x3C1EC:
	ld a, 22
	ld [$A460], a
	call UnknownCall_0x3E9FB
	call UnknownCall_0x2934
	ld a, 7
	ldh [rWX], a
	ld a, 22
	ldh_n_a $9B
	ret

UnknownRJump_0x3C201:
	ldh_a_n $81
	and $01
	ret z
	ld a, 16
	ld [$A7B8], a
	ld a, [$A840]
	cp $6E
	ret c
	ld a, 2
	ld [$A460], a
	ret

UnknownData_0x3C218:
INCBIN "baserom.gb", $3C218, $3C29A - $3C218


UnknownCall_0x3C29A:
	ld a, 16
	ldh_n_a $81
	ret

UnknownCall_0x3C2A0:
	ld a, 32
	ldh_n_a $81
	ret

UnknownCall_0x3C2A6:
	ld a, 128
	ldh_n_a $81
	ret

UnknownCall_0x3C2AC:
	ld a, 64
	ldh_n_a $81
	ret

UnknownCall_0x3C2B2:
	ld a, 8
	ldh_n_a $81
	ret

UnknownCall_0x3C2B8:
	ldh_a_n $81
	bit 4, a
	jr z, UnknownRJump_0x3C2D0
	ld a, [$A855]
	bit 7, a
	ret z
	ld a, 54
	ld [$A840], a
	ld a, 16
	ldh_n_a $81
	ret

UnknownRJump_0x3C2D0:
	ldh_a_n $81
	bit 5, a
	ret z
	ld a, [$A86B]
	bit 7, a
	ret z
	ld a, 55
	ld [$A840], a
	ld a, 32
	ldh_n_a $81
	ret

UnknownCall_0x3C2E7:
	ldh_a_n $81
	bit 6, a
	ret z
	ld a, [$A853]
	bit 0, a
	ret z
	ld a, 57
	ld [$A840], a
	ld a, 64
	ldh_n_a $81
	ret

UnknownCall_0x3C2FE:
	ldh_a_n $81
	bit 4, a
	ret z
	ld a, [$A86B]
	bit 7, a
	ret z
	ld a, 108
	ld [$A840], a
	ld a, 16
	ldh_n_a $81
	ret

UnknownData_0x3C315:
INCBIN "baserom.gb", $3C315, $3C316 - $3C315


UnknownJump_0x3C316:
	ld a, [$A690]
	or a
	jp nz, UnknownJump_0x3C4CC
	ld a, [$A848]
	bit 7, a
	jp z, UnknownJump_0x3C4CC

UnknownData_0x3C325:
INCBIN "baserom.gb", $3C325, $3C32D - $3C325


UnknownCall_0x3C32D:
	ld a, [$A690]
	or a
	ret nz
	ld a, [$A224]
	or a
	ret nz
	ld a, 255
	ld [$A224], a
	ld a, [$A840]
	ld hl, $650E
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	cp $FE
	ret nc
	ld b, a
	ld e, a
	ld hl, $4364
	add hl, de
	ld a, [hl]
	ld e, a
	ld hl, $A848
	add hl, de
	ld a, [hl]
	bit 7, a
	ret nz
	ld e, b
	ld hl, $6591
	add hl, de
	ld a, [hl]
	ldh_n_a $81
	ret

UnknownData_0x3C364:
INCBIN "baserom.gb", $3C364, $3C38C - $3C364


UnknownCall_0x3C38C:
	ei
	ld a, [$A840]
	cp $14
	call z, UnknownCall_0x3C2AC
	ld a, [$A840]
	cp $35
	call z, UnknownCall_0x3C2B8
	ld a, [$A840]
	cp $32
	call z, UnknownCall_0x3C2E7
	ld a, [$A840]
	cp $6A
	call z, UnknownCall_0x3C2FE
	ld a, [$A840]
	cp $17
	call z, UnknownCall_0x3C2A0
	ld a, [$A840]
	cp $4B
	call z, UnknownCall_0x3C2A6
	ld a, [$A840]
	cp $2C
	call z, UnknownCall_0x3C2A6
	ld a, [$A840]
	cp $4A
	call z, UnknownCall_0x3C2AC
	ld a, [$A840]
	cp $2F
	call z, UnknownCall_0x3C2AC
	ld a, [$A840]
	cp $31
	call z, UnknownCall_0x3C2A6
	ld a, [$A840]
	cp $38
	call z, UnknownCall_0x3C2A6
	ld a, [$A840]
	cp $2E
	call z, UnknownCall_0x3C2AC
	ld a, [$A840]
	cp $6B
	call z, UnknownCall_0x3C2AC
	ld a, [$A840]
	cp $47
	call z, UnknownCall_0x3C2AC
	ld a, [$A840]
	cp $65
	call z, UnknownCall_0x3C2A0
	ld a, [$A840]
	cp $45
	call z, UnknownCall_0x3C2A0
	ld a, [$A840]
	cp $27
	call z, UnknownCall_0x3C2A0
	ld a, [$A840]
	cp $67
	call z, UnknownCall_0x3C2B2
	ld a, [$A840]
	cp $5B
	call z, UnknownCall_0x3C2B2
	ld a, [$A840]
	cp $5A
	call z, UnknownCall_0x3C2AC
	ld a, [$A840]
	cp $68
	call z, UnknownCall_0x3C29A
	ld a, [$A840]
	cp $25
	call z, UnknownCall_0x3C29A
	ld a, [$A840]
	cp $6C
	call z, UnknownCall_0x3C29A
	ld a, [$A840]
	cp $43
	call z, UnknownCall_0x3C29A
	ld a, [$A840]
	cp $79
	call z, UnknownCall_0x3C29A
	ld a, [$A840]
	cp $69
	call z, UnknownCall_0x3C2A6
	ld a, [$A840]
	cp $73
	call z, UnknownCall_0x3C2A0
	ld a, [$A840]
	cp $72
	call z, UnknownCall_0x3C29A
	ld a, [$A840]
	cp $3F
	call z, UnknownCall_0x3C29A
	ld a, [$A840]
	cp $74
	call z, UnknownCall_0x3C2A0
	ld a, [$A840]
	cp $75
	call z, UnknownCall_0x3C29A
	ld a, [$A840]
	cp $11
	call z, UnknownCall_0x3C2B2
	ld a, [$A840]
	cp $02
	call z, UnknownCall_0x3C2B2
	ld a, [$A840]
	cp $0C
	call z, UnknownCall_0x3C2B2
	ld a, [$A840]
	cp $0B
	call z, UnknownCall_0x3C2B2
	ld a, [$A840]
	cp $09
	call z, UnknownCall_0x3C2B2
	ld a, [$A840]
	cp $06
	call z, UnknownCall_0x3C2B2
	ld a, [$A840]
	cp $64
	call z, UnknownCall_0x3C29A
	ld a, [$A840]
	cp $1E
	call nc, UnknownCall_0x3C32D
	ld a, [$A840]
	or a
	jp z, UnknownJump_0x3C316

UnknownJump_0x3C4CC:
	ld a, [$A690]
	or a
	jp nz, UnknownJump_0x3C7EC
	call UnknownCall_0x3E1D7
	or a
	jp z, UnknownJump_0x3C5DA
	ld a, [$A840]
	cp $0C
	jr z, UnknownRJump_0x3C4E7
	cp $1E
	jr z, UnknownRJump_0x3C4E7
	jr UnknownRJump_0x3C505

UnknownRJump_0x3C4E7:
	ldh_a_n $81
	and $F6
	jr nz, UnknownRJump_0x3C505
	ldh_a_n $81
	and $09
	jr z, UnknownRJump_0x3C505
	ld a, 1
	ld [$A789], a
	ld a, 25
	ld [$A468], a
	ld bc, $5BF6
	jp UnknownJump_0x3C588

UnknownRJump_0x3C505:
	ld a, [$A68B]
	or a
	jr nz, UnknownRJump_0x3C52B
	ldh_a_n $80
	bit 1, a
	jp nz, UnknownJump_0x3C5B2
	ld a, [$A7A0]
	or a
	jr z, UnknownRJump_0x3C52B
	ld a, [$A840]
	ld [$A840], a
	call UnknownCall_0x3EEA4
	call UnknownCall_0x3ED4C
	call UnknownCall_0x3F156
	call UnknownCall_0x3EA9A

UnknownRJump_0x3C52B:
	xor a
	ld [$A7A0], a
	ldh_a_n $81
	and $F0
	jp z, UnknownJump_0x3C5DA
	ldh_a_n $81
	and $F0
	swap a
	ld d, a
	ld a, [$A840]
	ld hl, $563A
	ld b, 0
	sla a
	rl b
	sla a
	rl b
	sla a
	rl b
	ld c, a
	add hl, bc
	ld bc, $0000
	bit 1, d
	jr z, UnknownRJump_0x3C560
	ld c, 2
	jr UnknownRJump_0x3C56E

UnknownRJump_0x3C560:
	bit 2, d
	jr z, UnknownRJump_0x3C568
	ld c, 4
	jr UnknownRJump_0x3C56E

UnknownRJump_0x3C568:
	bit 3, d
	jr z, UnknownRJump_0x3C56E
	ld c, 6

UnknownRJump_0x3C56E:
	add hl, bc
	ld a, 24
	call UnknownCall_0x3E7B
	ei
	ld c, a
	inc hl
	ld a, 24
	call UnknownCall_0x3E7B
	ei
	ld b, a
	ld a, b
	xor $FF
	ld d, a
	ld a, c
	xor $FF
	or d
	jr z, UnknownRJump_0x3C5DA

UnknownJump_0x3C588:
	ld hl, $A692
	ld [hl], c
	inc hl
	ld [hl], b
	ld a, 24
	call UnknownCall_0x3E8F
	ei
	ld d, a
	ld [$A844], a
	ld a, 255
	ld [$A690], a
	ld a, 9
	ld [$A694], a
	ld a, d
	and $F0
	cp $10
	jp nz, UnknownJump_0x3C7EC
	ld a, 5
	ld [$A694], a
	jp UnknownJump_0x3C7EC

UnknownJump_0x3C5B2:
	ld a, 255
	ld [$A7A0], a
	ldh_a_n $80
	bit 4, a
	call nz, UnknownCall_0x3CA37
	ldh_a_n $80
	bit 5, a
	call nz, UnknownCall_0x3CA63
	ldh_a_n $80
	bit 6, a
	call nz, UnknownCall_0x3CA8A
	ldh_a_n $80
	bit 7, a
	call nz, UnknownCall_0x3CAB1
	jp UnknownJump_0x3C9F4

UnknownJump_0x3C5DA:
UnknownRJump_0x3C5DA:
	ld a, [$A840]
	cp $15
	call z, UnknownCall_0x3C2B2
	ld a, [$A840]
	cp $0D
	jr nz, UnknownRJump_0x3C5F4
	call UnknownCall_0x3C2B2
	ld a, [$A789]
	or a
	jr z, UnknownRJump_0x3C5F4
	jr UnknownRJump_0x3C60B

UnknownRJump_0x3C5F4:
	ldh_a_n $81
	and $09
	jp z, UnknownJump_0x3C66C
	ld a, [$A68B]
	or a
	jp z, UnknownJump_0x3C60B
	cp $08
	jp z, UnknownJump_0x3C60B
	jp UnknownJump_0x3C66C

UnknownJump_0x3C60B:
UnknownRJump_0x3C60B:
	ld a, [$A840]
	cp $02
	jp z, UnknownJump_0x3D0D7
	cp $19
	jp z, UnknownJump_0x3D0D7
	cp $09
	jp z, UnknownJump_0x3D1E0
	cp $1C
	jp z, UnknownJump_0x3D1E0
	cp $06
	jp z, UnknownJump_0x3D33A
	cp $1B
	jp z, UnknownJump_0x3D33A
	cp $12
	jp z, UnknownJump_0x3D477
	cp $0D
	jp z, UnknownJump_0x3D5EC
	cp $67
	jp z, UnknownJump_0x3D5D0
	cp $0B
	jp z, UnknownJump_0x3D760
	cp $1D
	jp z, UnknownJump_0x3D760
	cp $15
	jp z, UnknownJump_0x3D848
	cp $6E
	jp z, UnknownJump_0x3F45E
	cp $6F
	jp z, UnknownJump_0x3F427
	cp $70
	jp z, UnknownJump_0x3F3F0
	cp $71
	jp z, UnknownJump_0x3F3B9
	cp $11
	jr nz, UnknownRJump_0x3C66C
	ld a, [$A68B]
	or a
	jp nz, UnknownJump_0x3C66C
	jp UnknownJump_0x3D6C3

UnknownJump_0x3C66C:
UnknownRJump_0x3C66C:
	ld a, [$A68B]
	or a
	jp z, UnknownJump_0x3C7D9
	ld a, [$A840]
	cp $23
	jp z, UnknownJump_0x3C6B0
	cp $28
	jp z, UnknownJump_0x3C6CA
	cp $2D
	jp z, UnknownJump_0x3C6E4
	cp $30
	jp z, UnknownJump_0x3C6F6
	cp $32
	jp z, UnknownJump_0x3C708
	cp $40
	jp z, UnknownJump_0x3C731
	cp $46
	jp z, UnknownJump_0x3C743
	cp $4A
	jp z, UnknownJump_0x3C75D
	cp $50
	jp z, UnknownJump_0x3C76F
	cp $5C
	jp z, UnknownJump_0x3C789
	cp $74
	jp z, UnknownJump_0x3C7A3
	jp UnknownJump_0x3C7D9

UnknownJump_0x3C6B0:
	ldh_a_n $81
	cp $80
	jp nz, UnknownJump_0x3C7D9
	ld a, 8
	call UnknownCall_0x3E2F7

UnknownJump_0x3C6BD:
	ld a, 25
	call UnknownCall_0x3C7CA
	ld a, 8
	ld [$A844], a
	jp UnknownJump_0x3C7BD

UnknownJump_0x3C6CA:
	ldh_a_n $81
	cp $80
	jp nz, UnknownJump_0x3C7D9
	ld a, 8
	call UnknownCall_0x3E2F7

UnknownJump_0x3C6D7:
	ld a, 28
	call UnknownCall_0x3C7CA
	ld a, 8
	ld [$A844], a
	jp UnknownJump_0x3C7BD

UnknownJump_0x3C6E4:
	ld a, 8
	call UnknownCall_0x3E2F7
	ld a, 121
	call UnknownCall_0x3C7CA
	ld a, 8
	ld [$A844], a
	jp UnknownJump_0x3C7BD

UnknownJump_0x3C6F6:
	ld a, 4
	call UnknownCall_0x3E2F7
	ld a, 122
	call UnknownCall_0x3C7CA
	ld a, 8
	ld [$A844], a
	jp UnknownJump_0x3C7BD

UnknownJump_0x3C708:
	ldh_a_n $81
	cp $20
	jp nz, UnknownJump_0x3C7D9
	ld a, 34
	ld [$A844], a
	ld a, 255
	ld [$A690], a
	ld a, 2
	call UnknownCall_0x3E2F7
	ld a, 0
	ld [$A690], a

UnknownJump_0x3C724:
	ld a, 27
	call UnknownCall_0x3C7CA
	ld a, 34
	ld [$A844], a
	jp UnknownJump_0x3C7BD

UnknownJump_0x3C731:
	ld a, 2
	call UnknownCall_0x3E2F7

UnknownJump_0x3C736:
	ld a, 26
	call UnknownCall_0x3C7CA
	ld a, 2
	ld [$A844], a
	jp UnknownJump_0x3C7BD

UnknownJump_0x3C743:
	ldh_a_n $81
	cp $40
	jp nz, UnknownJump_0x3C7D9
	ld a, 4
	call UnknownCall_0x3E2F7

UnknownJump_0x3C750:
	ld a, 30
	call UnknownCall_0x3C7CA
	ld a, 4
	ld [$A844], a
	jp UnknownJump_0x3C7BD

UnknownJump_0x3C75D:
	ld a, 4
	call UnknownCall_0x3E2F7
	ld a, 101
	call UnknownCall_0x3C7CA
	ld a, 4
	ld [$A844], a
	jp UnknownJump_0x3C7BD

UnknownJump_0x3C76F:
	ldh_a_n $81
	cp $20
	jp nz, UnknownJump_0x3C7D9
	ld a, 2
	call UnknownCall_0x3E2F7

UnknownJump_0x3C77C:
	ld a, 29
	call UnknownCall_0x3C7CA
	ld a, 2
	ld [$A844], a
	jp UnknownJump_0x3C7BD

UnknownJump_0x3C789:
	ldh_a_n $81
	and $90
	jp z, UnknownJump_0x3C7D9
	ld a, 1
	call UnknownCall_0x3E2F7
	ld a, 100
	call UnknownCall_0x3C7CA
	ld a, 1
	ld [$A844], a
	jp UnknownJump_0x3C7BD

UnknownJump_0x3C7A3:
	ldh_a_n $81
	cp $20
	jp nz, UnknownJump_0x3C7D9
	ld a, 2
	call UnknownCall_0x3E2F7
	ld a, 23
	call UnknownCall_0x3C7CA
	ld a, 2
	ld [$A844], a
	jp UnknownJump_0x3C7BD

UnknownJump_0x3C7BD:
	call UnknownCall_0x3F156
	ld a, 12
	ldh_n_a $9B
	call UnknownCall_0x3EA9A
	ei
	ret

UnknownCall_0x3C7CA:
	ld [$A840], a
	call UnknownCall_0x3EEA4
	call UnknownCall_0x3ED4C
	ld a, 0
	ld [$A68B], a
	ret

UnknownJump_0x3C7D9:
	xor a
	ld [$A690], a
	ld a, 8
	ld [$A694], a
	ld a, [$A68C]
	inc a
	ld [$A68C], a
	jp UnknownJump_0x3C8F4

UnknownJump_0x3C7EC:
	ld a, [$A878]
	rrca
	ld [$A878], a
	jr nc, UnknownRJump_0x3C7F8
	jp UnknownJump_0x3C901

UnknownRJump_0x3C7F8:
	ld a, [$A694]
	dec a
	ld [$A694], a
	jr nz, UnknownRJump_0x3C83C
	ld a, 8
	ld [$A694], a
	ld hl, $A692
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc bc
	ld [hl], b
	dec hl
	ld [hl], c
	ld a, 24
	call UnknownCall_0x3E8F
	ei
	or a
	jr nz, UnknownRJump_0x3C82D
	xor a
	ld [$A690], a
	inc bc
	ld a, 24
	call UnknownCall_0x3E8F
	ei
	ld [$A840], a
	ld [$A840], a
	jp UnknownJump_0x3C901

UnknownRJump_0x3C82D:
	ld [$A844], a
	ld a, [$A844]
	bit 4, a
	jr z, UnknownRJump_0x3C83C
	ld a, 4
	ld [$A694], a

UnknownRJump_0x3C83C:
	ld a, [$A68C]
	inc a
	ld [$A68C], a
	ld a, [$A844]
	and $0F
	jp z, UnknownJump_0x3C8F4
	ld a, [$A844]
	bit 2, a
	jr z, UnknownRJump_0x3C872
	ld a, [$A68C]
	and $0C
	rrca
	rrca
	add 8
	ld [$A695], a
	ld a, [$A843]
	cp $08
	ccf
	sbc 0
	ld [$A843], a
	ld a, [$A68B]
	or a
	call z, UnknownCall_0x3CA84
	jr UnknownRJump_0x3C893

UnknownRJump_0x3C872:
	bit 3, a
	jr z, UnknownRJump_0x3C893
	ld a, [$A68C]
	and $0C
	rrca
	rrca
	add 12
	ld [$A695], a
	ld a, [$A843]
	cp $8A
	adc 0
	ld [$A843], a
	ld a, [$A68B]
	or a
	call z, UnknownCall_0x3CAAB

UnknownRJump_0x3C893:
	ld a, [$A844]
	bit 0, a
	jr z, UnknownRJump_0x3C8C1
	ld a, [$A68C]
	and $0C
	cp $0C
	jr nz, UnknownRJump_0x3C8A7
	xor a
	ld [$A68C], a

UnknownRJump_0x3C8A7:
	rrca
	rrca
	add 4
	ld [$A695], a
	ld a, [$A842]
	cp $94
	adc 0
	ld [$A842], a
	ld a, [$A68B]
	or a
	call z, UnknownCall_0x3CA31
	jr UnknownRJump_0x3C901

UnknownRJump_0x3C8C1:
	bit 1, a
	jr z, UnknownRJump_0x3C8EB
	ld a, [$A68C]
	and $0C
	cp $0C
	jr nz, UnknownRJump_0x3C8D2
	xor a
	ld [$A68C], a

UnknownRJump_0x3C8D2:
	rrca
	rrca
	ld [$A695], a
	ld a, [$A842]
	cp $08
	ccf
	sbc 0
	ld [$A842], a
	ld a, [$A68B]
	or a
	call z, UnknownCall_0x3CA5D
	jr UnknownRJump_0x3C901

UnknownRJump_0x3C8EB:
	ld a, [$A844]
	and $0F
	jr nz, UnknownRJump_0x3C901

UnknownData_0x3C8F2:
INCBIN "baserom.gb", $3C8F2, $3C8F4 - $3C8F2


UnknownJump_0x3C8F4:
	ld a, [$A68C]
	and $18
	rrca
	rrca
	rrca
	add 12
	ld [$A695], a

UnknownJump_0x3C901:
UnknownRJump_0x3C901:
UnknownCall_0x3C901:
	ld a, [$A695]
	add a
	ld d, 0
	ld e, a
	ld hl, $4AD7
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [$A844]
	and $F0
	swap a
	cp $08
	jr nz, UnknownRJump_0x3C92A
	ld de, $4B77
	ld a, [$A68C]
	and $08
	ld l, a
	ld h, 0
	add hl, de
	ld d, h
	ld e, l
	jr UnknownRJump_0x3C990

UnknownRJump_0x3C92A:
	bit 2, a
	jr z, UnknownRJump_0x3C933
	ld de, $4B87
	jr UnknownRJump_0x3C990

UnknownRJump_0x3C933:
	cp $0A
	jr z, UnknownRJump_0x3C990
	and $02
	jr z, UnknownRJump_0x3C990
	ld a, [$A690]
	or a
	jr z, UnknownRJump_0x3C971
	ld a, [$A844]
	bit 1, a
	jr z, UnknownRJump_0x3C959
	ld de, $4B8F
	ld a, [$A68C]
	and $0C
	rlca
	ld l, a
	ld h, 0
	add hl, de
	ld d, h
	ld e, l
	jr UnknownRJump_0x3C990

UnknownRJump_0x3C959:
	ld a, [$A844]
	bit 0, a
	jr z, UnknownRJump_0x3C971
	ld de, $4BAF
	ld a, [$A68C]
	and $0C
	rlca
	ld l, a
	ld h, 0
	add hl, de
	ld d, h
	ld e, l
	jr UnknownRJump_0x3C990

UnknownRJump_0x3C971:
	ld a, [$A68C]
	and $18
	rrca
	rrca
	rrca
	ld l, a
	ld h, 0
	ld bc, $498C
	add hl, bc
	ld a, [hl]
	ld h, 0
	ld l, a
	ld de, $4BCF
	add hl, de
	ld d, h
	ld e, l
	jr UnknownRJump_0x3C990

UnknownData_0x3C98C:
INCBIN "baserom.gb", $3C98C, $3C990 - $3C98C


UnknownRJump_0x3C990:
	ld hl, $A102
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	inc de
	ld l, 6
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	inc de
	ld l, 10
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	inc de
	ld l, 14
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	call UnknownCall_0x3C9B5
	ei
	ret

UnknownCall_0x3C9B5:
	ld bc, $0000
	ld a, [$A844]
	and $0F
	jr z, UnknownRJump_0x3C9CA
	ld a, [$A844]
	bit 5, a
	jr z, UnknownRJump_0x3C9CA
	ld b, 4
	ld c, 8

UnknownRJump_0x3C9CA:
	ld a, [$A842]
	add b
	ld d, a
	ld a, [$A843]
	add c
	ld e, a
	ld hl, $A100
	ld [hl], e
	inc hl
	ld [hl], d
	ld l, 4
	ld a, d
	add 8
	ld [hl], e
	inc hl
	ld [hl], a
	ld l, 8
	ld a, e
	add 8
	ld [hli], a
	ld [hl], d
	ld l, 12
	ld a, e
	add 8
	ld [hli], a
	ld a, d
	add 8
	ld [hl], a
	ret

UnknownJump_0x3C9F4:
	ldh_a_n $97
	swap a
	and $01
	jr nz, UnknownRJump_0x3CA02
	ld bc, $4A11
	jr UnknownRJump_0x3CA05

UnknownRJump_0x3CA02:
	ld bc, $4A21

UnknownRJump_0x3CA05:
	ld hl, $A100
	ld d, 16

UnknownRJump_0x3CA0A:
	ld a, [bc]
	ld [hli], a
	inc bc
	dec d
	jr nz, UnknownRJump_0x3CA0A
	ret

UnknownData_0x3CA11:
INCBIN "baserom.gb", $3CA11, $3CA31 - $3CA11


UnknownCall_0x3CA31:
	ld a, [$A842]
	cp $4C
	ret nz

UnknownCall_0x3CA37:
	ld hl, $FFB9
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	or a
	jr z, UnknownRJump_0x3CA45
	ld a, e
	cp $60
	ret nc

UnknownRJump_0x3CA45:
	inc de
	ld a, d
	ld [hld], a
	ld [hl], e
	ld a, [sScrollX]
	inc a
	ld [sScrollX], a
	ld a, [$A7A0]
	or a
	ret nz
	ld a, [$A842]
	dec a
	ld [$A842], a
	ret

UnknownCall_0x3CA5D:
	ld a, [$A842]
	cp $4A
	ret nz

UnknownCall_0x3CA63:
	ld hl, $FFB9
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	or e
	ret z
	dec de
	ld a, d
	ld [hld], a
	ld [hl], e
	ld a, [sScrollX]
	dec a
	ld [sScrollX], a
	ld a, [$A7A0]
	or a
	ret nz
	ld a, [$A842]
	inc a
	ld [$A842], a
	ret

UnknownCall_0x3CA84:
	ld a, [$A843]
	cp $4B
	ret nz

UnknownCall_0x3CA8A:
	ld hl, $FFB7
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	or e
	ret z
	dec de
	ld a, d
	ld [hld], a
	ld [hl], e
	ld a, [sScrollY]
	dec a
	ld [sScrollY], a
	ld a, [$A7A0]
	or a
	ret nz
	ld a, [$A843]
	inc a
	ld [$A843], a
	ret

UnknownCall_0x3CAAB:
	ld a, [$A843]
	cp $4D
	ret nz

UnknownCall_0x3CAB1:
	ld hl, $FFB7
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	or a
	jr z, UnknownRJump_0x3CABF
	ld a, e
	cp $70
	ret nc

UnknownRJump_0x3CABF:
	inc de
	ld a, d
	ld [hld], a
	ld [hl], e
	ld a, [sScrollY]
	inc a
	ld [sScrollY], a
	ld a, [$A7A0]
	or a
	ret nz
	ld a, [$A843]
	dec a
	ld [$A843], a
	ret

UnknownData_0x3CAD7:
INCBIN "baserom.gb", $3CAD7, $3CBE7 - $3CAD7


UnknownCall_0x3CBE7:
	xor a
	ld [$A781], a
	ld hl, $A6B5
	ld c, 72
	ld de, $4BFD

UnknownRJump_0x3CBF3:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, UnknownRJump_0x3CBF3
	call UnknownCall_0x3CFC8
	ret

UnknownData_0x3CBFD:
INCBIN "baserom.gb", $3CBFD, $3CE43 - $3CBFD


UnknownCall_0x3CE43:
	ld hl, $4E37
	ld de, $A6C8
	ld b, 6

UnknownRJump_0x3CE4B:
	push bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	push hl
	ld h, b
	ld l, c
	ld a, [hl]
	bit 7, a
	jr z, UnknownRJump_0x3CE5C
	ld a, 2
	jr UnknownRJump_0x3CE5E

UnknownRJump_0x3CE5C:
	ld a, 255

UnknownRJump_0x3CE5E:
	ld h, d
	ld l, e
	ld [hl], a
	inc de
	inc de
	inc de
	inc de
	pop hl
	pop bc
	dec b
	jr nz, UnknownRJump_0x3CE4B
	ret

UnknownCall_0x3CE6B:
	ld a, [$A69A]
	and $07
	jr nz, UnknownRJump_0x3CE93
	ld a, [$A780]
	inc a
	cp $03
	jr c, UnknownRJump_0x3CE7B
	xor a

UnknownRJump_0x3CE7B:
	ld [$A780], a
	add 2
	ld hl, $A6C8
	ld de, $0004
	ld b, 6
	ld c, a

UnknownRJump_0x3CE89:
	ld a, [hl]
	cp $FF
	jr z, UnknownRJump_0x3CE8F
	ld [hl], c

UnknownRJump_0x3CE8F:
	add hl, de
	dec b
	jr nz, UnknownRJump_0x3CE89

UnknownRJump_0x3CE93:
	ld a, [$A69A]
	and $03
	jr nz, UnknownRJump_0x3CEB7
	ld hl, $A6BA
	ld de, $0004
	ld a, [$A781]
	inc a
	ld [$A781], a
	bit 6, a
	jr z, UnknownRJump_0x3CEB2
	inc [hl]
	add hl, de
	inc [hl]
	add hl, de
	inc [hl]
	jr UnknownRJump_0x3CEB7

UnknownRJump_0x3CEB2:
	dec [hl]
	add hl, de
	dec [hl]
	add hl, de
	dec [hl]

UnknownRJump_0x3CEB7:
	ld a, [$A69A]
	and $03
	jr nz, UnknownRJump_0x3CF16
	ld a, [$A7A9]
	or a
	jr z, UnknownRJump_0x3CF09

UnknownRJump_0x3CEC4:
	ld a, 255
	ld [$A6F8], a
	ld [$A6FC], a
	ld a, [$A7A9]
	dec a
	ld [$A7A9], a
	bit 0, a
	jr z, UnknownRJump_0x3CF16
	ld a, 10
	ld [$A6F8], a
	ld [$A6FC], a
	ldh a, [rDIV]
	and $0E
	ld d, 0
	ld e, a
	ld hl, $4FA8
	add hl, de
	ld a, [hli]
	ld [$A6F6], a
	ld a, [hl]
	ld [$A6F7], a
	ldh a, [rDIV]
	and $E0
	swap a
	ld d, 0
	ld e, a
	ld hl, $4FB8
	add hl, de
	ld a, [hli]
	ld [$A6FA], a
	ld a, [hl]
	ld [$A6FB], a
	jr UnknownRJump_0x3CF16

UnknownRJump_0x3CF09:
	ldh a, [rDIV]
	and $72
	jr nz, UnknownRJump_0x3CF16
	ld a, 4
	ld [$A7A9], a
	jr UnknownRJump_0x3CEC4

UnknownRJump_0x3CF16:
	ld a, [$A789]
	or a
	ret z
	inc a
	ld [$A789], a
	ld d, a
	ld c, 0
	cp $10
	jr c, UnknownRJump_0x3CF2E
	sub 2
	and $18
	rlca
	swap a
	ld c, a

UnknownRJump_0x3CF2E:
	ld a, d
	cp $58
	jr c, UnknownRJump_0x3CF3A
	ld hl, $A6F0
	ld a, 5
	ld [hl], a
	ret

UnknownRJump_0x3CF3A:
	cp $2C
	jr nc, UnknownRJump_0x3CF48
	ld a, [$A6EE]
	dec a
	ld [$A6EE], a
	ld e, a
	jr UnknownRJump_0x3CF52

UnknownRJump_0x3CF48:
	ld a, [$A6EE]
	inc a
	ld [$A6EE], a
	ld e, a
	ld c, 0

UnknownRJump_0x3CF52:
	ld hl, $A6F0
	ld a, c
	add 5
	ld [hl], a
	ld a, 255
	ld [$A6E0], a
	ld [$A6E4], a
	ld [$A6E8], a
	ld [$A6EC], a
	ld [$A6F4], a
	ld a, e
	sub 88
	srl a
	srl a
	srl a
	and $07
	ld e, a
	cp $06
	jr nc, UnknownRJump_0x3CF80
	ld a, 11
	ld [$A6E0], a
	ld a, e

UnknownRJump_0x3CF80:
	cp $05
	jr nc, UnknownRJump_0x3CF8A
	ld a, 11
	ld [$A6E4], a
	ld a, e

UnknownRJump_0x3CF8A:
	cp $04
	jr nc, UnknownRJump_0x3CF94
	ld a, 11
	ld [$A6E8], a
	ld a, e

UnknownRJump_0x3CF94:
	cp $03
	jr nc, UnknownRJump_0x3CF9E
	ld a, 11
	ld [$A6EC], a
	ld a, e

UnknownRJump_0x3CF9E:
	cp $02
	jr nc, UnknownRJump_0x3CFA7
	ld a, 11
	ld [$A6F4], a

UnknownRJump_0x3CFA7:
	ret

UnknownData_0x3CFA8:
INCBIN "baserom.gb", $3CFA8, $3CFC8 - $3CFA8


UnknownCall_0x3CFC8:
	call UnknownCall_0x3CE6B
	xor a
	ld hl, $A134
	ld d, 108

UnknownRJump_0x3CFD1:
	ld [hli], a
	dec d
	jr nz, UnknownRJump_0x3CFD1
	ld a, 13
	ld [$A6B3], a
	ld hl, $A6B5
	ld a, 18

UnknownRJump_0x3CFDF:
	push af
	push hl
	inc hl
	inc hl
	inc hl
	ld a, [hl]
	cp $FF
	jr z, UnknownRJump_0x3CFF7
	dec hl
	dec hl
	dec hl
	call UnknownCall_0x3D044
	ld e, a
	ld a, [$A6B4]
	or a
	call z, UnknownCall_0x3D001

UnknownRJump_0x3CFF7:
	pop hl
	ld bc, $0004
	add hl, bc
	pop af
	dec a
	jr nz, UnknownRJump_0x3CFDF
	ret

UnknownCall_0x3D001:
	ld hl, $4C4D
	sla e
	ld d, 0
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [$A6B3]
	cp $28
	ret nc
	add a
	add a
	ld de, $A100
	add e
	ld e, a
	ld a, d
	adc 0
	ld d, a

UnknownRJump_0x3D01D:
	ld a, [$A6B3]
	cp $28
	ret nc
	ld a, [hli]
	add c
	ld [de], a
	inc de
	ld a, [hli]
	add b
	ld [de], a
	inc de
	ld a, [hli]
	cp $FF
	jr z, UnknownRJump_0x3D03E
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [$A6B3]
	inc a
	ld [$A6B3], a
	jr UnknownRJump_0x3D01D

UnknownRJump_0x3D03E:
	dec de
	xor a
	ld [de], a
	dec de
	ld [de], a
	ret

UnknownCall_0x3D044:
	ld a, [hli]
	ld d, a
	and $F0
	swap a
	or $06
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, d
	and $0F
	or $06
	ld d, a
	ld a, [hli]
	ld e, a
	push hl
	xor a
	ld [$A6B4], a
	push de
	ld a, [$A680]
	ld l, a
	ld a, [$A681]
	or $06
	ld h, a
	push hl
	ld de, $FFD0
	add hl, de
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	jr c, UnknownRJump_0x3D079
	ld a, 255
	ld [$A6B4], a

UnknownRJump_0x3D079:
	pop hl
	ld de, $00D0
	add hl, de
	ld a, l
	sub c
	ld l, a
	ld a, h
	sbc b
	ld h, a
	jr nc, UnknownRJump_0x3D08B
	ld a, 255
	ld [$A6B4], a

UnknownRJump_0x3D08B:
	pop de
	push bc
	ld a, [$A682]
	ld l, a
	ld a, [$A683]
	or $06
	ld h, a
	push hl
	ld bc, $FFC8
	add hl, bc
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	jr c, UnknownRJump_0x3D0A9
	ld a, 255
	ld [$A6B4], a

UnknownRJump_0x3D0A9:
	pop hl
	ld bc, $00C8
	add hl, bc
	ld a, l
	sub e
	ld l, a
	ld a, h
	sbc d
	ld h, a
	jr nc, UnknownRJump_0x3D0BB
	ld a, 255
	ld [$A6B4], a

UnknownRJump_0x3D0BB:
	pop bc
	ld a, [$A6B4]
	or a
	jr nz, UnknownRJump_0x3D0D4
	ld a, [$A680]
	ld b, a
	ld a, c
	sub b
	add 8
	ld b, a
	ld a, [$A682]
	ld d, a
	ld a, e
	sub d
	add 16
	ld c, a

UnknownRJump_0x3D0D4:
	pop hl
	ld a, [hl]
	ret

UnknownJump_0x3D0D7:
	ld a, 48
	ld [$A842], a
	ld a, 158
	ld [$A843], a
	ld a, 35
	ld [$A840], a
	ld a, 255
	ld [$A224], a
	call UnknownCall_0x3E9FB
	ld a, 255
	ld [$A468], a
	call UnknownCall_0x2AAA
	call UnknownCall_0x3D0FF
	ld a, 4
	call UnknownCall_0x3E3BA
	ret

UnknownCall_0x3D0FF:
	call DisableVBlank
	ld a, BANK(GFX_OW_Overworld) ;prepare bank switch
	ld bc, $0200
	ld hl, GFX_OW_Overworld
	ld de, $8000
	call FarCopyMem
	ld a, BANK(GFX_OW_TreeZone) ;prepare bank switch
	ld bc, $1600
	ld hl, GFX_OW_TreeZone
	ld de, $8200
	call FarCopyMem
	ld a, 14 ;prepare bank switch
	ld bc, $0400
	ld hl, $7240
	ld de, $9800
	call FarCopyMem
	ld a, 0
	ld [sScrollX], a
	ld [sScrollY], a
	ld [$A690], a
	ld a, 2
	ld [$A68B], a
	call UnknownCall_0x3E46
	ld de, $65BA
	call UnknownCall_0x3E2A2
	ld a, [$A84D]
	bit 7, a
	jr z, UnknownRJump_0x3D151
	ld a, 255
	ld [$A6B7], a

UnknownRJump_0x3D151:
	ld hl, $A849
	ld de, $A6C3
	ld b, 5
	call UnknownCall_0x3DB00
	call UnknownCall_0x3E277
	call UnknownCall_0x3D1C9
	call UnknownCall_0x3D18E
	call UnknownCall_0x3D1B5
	ld a, 195
	ldh_n_a $40
	xor a
	ldh_n_a $81
	ld [$A69A], a
	ld [$A6B0], a
	ld [$A6B1], a
	ld [$A7BE], a
	ld [$A7BF], a
	ld a, 16
	ld [$A783], a
	ld a, 16
	ld [$A468], a
	call UnknownCall_0x2AAA
	ret

UnknownCall_0x3D18E:
	ld a, [$A2B4]
	or a
	ret z
	ld a, [$A224]
	or a
	ret nz
	ld a, [$A84A]
	and $01
	jr nz, UnknownRJump_0x3D1A4
	ld a, 106
	ld [$A6D2], a

UnknownRJump_0x3D1A4:
	ld a, 37
	ld [$A840], a
	call UnknownCall_0x3EEA4
	ld a, [$A84A]
	set 0, a
	ld [$A84A], a
	ret

UnknownCall_0x3D1B5:
	ld a, [$A840]
	cp $26
	ret nz
	ld a, 39
	ld [$A840], a
	call UnknownCall_0x3EEA4
	ld a, 255
	ld [$A224], a
	ret

UnknownCall_0x3D1C9:
	ld a, [$A84A]
	and $01
	ret z
	ld a, 109
	ld [$A6D2], a
	ld a, [$A86C]
	bit 7, a
	ret z
	ld a, 124
	ld [$A6D2], a
	ret

UnknownJump_0x3D1E0:
	ld a, 83
	ld [$A842], a
	ld a, 137
	ld [$A843], a
	ld a, 40
	ld [$A840], a
	ld a, 255
	ld [$A224], a
	ld a, 255
	ld [$A468], a
	call UnknownCall_0x2AAA
	call UnknownCall_0x3E9FB
	call UnknownCall_0x3D208
	ld a, 4
	call UnknownCall_0x3E3BA
	ret

UnknownCall_0x3D208:
	call DisableVBlank
	ld a, BANK(GFX_OW_Overworld) ;prepare bank switch
	ld bc, $0200
	ld hl, GFX_OW_Overworld
	ld de, $8000
	call FarCopyMem
	ld a, BANK(GFX_OW_PumpkinZone) ;prepare bank switch
	ld bc, $1600
	ld hl, GFX_OW_PumpkinZone
	ld de, $8200
	call FarCopyMem
	ld a, 14 ;prepare bank switch
	ld bc, $0400
	ld hl, $7000
	ld de, $9800
	call FarCopyMem
	ld a, 0
	ld [sScrollX], a
	ld [sScrollY], a
	ld [$A690], a
	ld a, 1
	ld [$A68B], a
	call UnknownCall_0x3E46
	ld de, $65DE
	call UnknownCall_0x3E2A2
	ld a, [$A851]
	bit 7, a
	jr z, UnknownRJump_0x3D25A
	ld a, 255
	ld [$A6BD], a

UnknownRJump_0x3D25A:
	call UnknownCall_0x3D2FC
	call UnknownCall_0x3D324
	call UnknownCall_0x3D29F
	ld hl, $A84E
	ld de, $A6C0
	ld b, 4
	call UnknownCall_0x3DB00
	call UnknownCall_0x3E277
	xor a
	ld [$A6A8], a
	ld [$A6A7], a
	ld [$A6AD], a
	ld [$A6AC], a
	ld [$A6A6], a
	ld [$A6A5], a
	ld [$A7BE], a
	ld [$A7BF], a
	ld a, 195
	ldh_n_a $40
	xor a
	ldh_n_a $81
	ld [$A69A], a
	ld a, 30
	ld [$A468], a
	call UnknownCall_0x2AAA
	ret

UnknownCall_0x3D29F:
	xor a
	ld [$A7BA], a
	ld a, [$A2B4]
	or a
	ret z
	ld a, [$A224]
	or a
	ret nz
	ld a, [$A840]
	cp $2C
	jr nz, UnknownRJump_0x3D2D5
	ld a, 31
	ld [$A7D2], a
	call UnknownCall_0x3F8E
	ld a, 44
	ld [$A840], a
	call UnknownCall_0x3EEA4
	ld a, [$A84F]
	bit 0, a
	ret nz
	set 0, a
	ld [$A84F], a
	ld a, 255
	ld [$A7BA], a
	ret

UnknownRJump_0x3D2D5:
	ld a, [$A840]
	cp $2F
	ret nz
	ld a, 39
	ld [$A7D5], a
	call UnknownCall_0x3F8E
	ld a, 47
	ld [$A840], a
	call UnknownCall_0x3EEA4
	ld a, [$A850]
	bit 0, a
	ret nz
	set 0, a
	ld [$A850], a
	ld a, 255
	ld [$A7BA], a
	ret

UnknownCall_0x3D2FC:
	ld a, [$A84F]
	and $01
	ret z
	ld a, 31

UnknownRJump_0x3D304:
	ld [$A7D2], a
	push af
	call UnknownCall_0x3F8E
	pop af
	inc a
	cp $27
	jr nz, UnknownRJump_0x3D304
	ld a, [$A86E]
	bit 7, a
	ret z
	ld hl, $4500
	ld de, $8800
	ld bc, $0220
	call UnknownCall_0x3FA4
	ret

UnknownCall_0x3D324:
	ld a, [$A850]
	and $01
	ret z
	ld a, 39

UnknownRJump_0x3D32C:
	ld [$A7D2], a
	push af
	call UnknownCall_0x3F8E
	pop af
	inc a
	cp $2F
	jr nz, UnknownRJump_0x3D32C
	ret

UnknownJump_0x3D33A:
	ld a, 226
	ld [$A842], a
	ld a, 118
	ld [$A843], a
	ld a, 33
	ld [$A844], a
	ld a, 50
	ld [$A840], a
	ld a, 255
	ld [$A224], a
	call UnknownCall_0x3E9FB
	ld a, 255
	ld [$A468], a
	call UnknownCall_0x2AAA
	call UnknownCall_0x3D371
	ld a, 255
	ld [$A690], a
	ld a, 1
	call UnknownCall_0x3E3BA
	ld a, 0
	ld [$A690], a
	ret

UnknownCall_0x3D371:
	call DisableVBlank
	ld a, BANK(GFX_OW_Overworld) ;prepare bank switch
	ld bc, $0200
	ld hl, GFX_OW_Overworld
	ld de, $8000
	call FarCopyMem
	ld a, BANK(GFX_OW_MacroZone) ;prepare bank switch
	ld bc, $1600
	ld hl, GFX_OW_MacroZone
	ld de, $8200
	call FarCopyMem
	ld a, 14 ;prepare bank switch
	ld bc, $0400
	ld hl, $76C0
	ld de, $9800
	call FarCopyMem
	ld a, 0
	ld [sScrollX], a
	ld [sScrollY], a
	ld [$A690], a
	ld a, 33
	ld [$A844], a
	ld a, 3
	ld [$A68B], a
	call UnknownCall_0x3E46
	ld de, $662C
	call UnknownCall_0x3E2A2
	call UnknownCall_0x3D45D
	call UnknownCall_0x3D409
	call UnknownCall_0x3D43D
	ld a, [$A844]
	or $20
	ld [$A844], a
	ld a, 0
	ld [$A690], a
	ld hl, $A853
	ld de, $A6C3
	ld b, 4
	call UnknownCall_0x3DB00
	ld hl, $A86B
	ld de, $A6B7
	ld b, 1
	call UnknownCall_0x3DB00
	call UnknownCall_0x3E277
	ld a, 195
	ldh_n_a $40
	xor a
	ldh_n_a $81
	ld [$A69A], a
	ld [$A6B0], a
	ld [$A6B1], a
	ld [$A783], a
	ld a, 5
	ld [$A468], a
	call UnknownCall_0x2AAA
	ret

UnknownCall_0x3D409:
	ld a, [$A840]
	cp $32
	ret nz
	ld a, [$A2B4]
	or a
	ret z
	ld a, [$A224]
	or a
	ret nz
	ld a, 16
	ld [$A7D2], a
	ld a, 107
	ld [$A840], a
	call UnknownCall_0x3EEA4
	ld a, [$A853]
	bit 0, a
	jr z, UnknownRJump_0x3D432

UnknownData_0x3D42D:
INCBIN "baserom.gb", $3D42D, $3D432 - $3D42D


UnknownRJump_0x3D432:
	set 0, a
	ld [$A853], a
	ld a, 255
	ld [$A7BA], a
	ret

UnknownCall_0x3D43D:
	ld a, [$A840]
	cp $6A
	ret nz
	ld a, [$A224]
	or a
	jr nz, UnknownRJump_0x3D45C
	ld a, 108
	ld [$A840], a
	call UnknownCall_0x3EEA4
	ld hl, $A86B
	set 7, [hl]
	ld a, 255
	ld [$A224], a
	ret

UnknownRJump_0x3D45C:
	ret

UnknownCall_0x3D45D:
	xor a
	ld [$A7BA], a
	ld a, [$A853]
	and $01
	ret z
	ld a, 16

UnknownRJump_0x3D469:
	ld [$A7D2], a
	push af
	call UnknownCall_0x3F8E
	pop af
	inc a
	cp $1F
	jr nz, UnknownRJump_0x3D469
	ret

UnknownJump_0x3D477:
UnknownData_0x3D477:
INCBIN "baserom.gb", $3D477, $3D49F - $3D477


UnknownCall_0x3D49F:
	call DisableVBlank
	ld a, BANK(GFX_OW_Overworld) ;prepare bank switch
	ld bc, $0200
	ld hl, GFX_OW_Overworld
	ld de, $8000
	call FarCopyMem
	ld a, BANK(GFX_OW_SpaceZone) ;prepare bank switch
	ld bc, $1600
	ld hl, GFX_OW_SpaceZone
	ld de, $8200
	call FarCopyMem
	ld a, 14 ;prepare bank switch
	ld bc, $0240
	ld hl, $7480
	ld de, $9800
	call FarCopyMem
	ld hl, $9B00
	ld a, 126
	ld c, 255

UnknownRJump_0x3D4D3:
	ld [hli], a
	dec c
	jr nz, UnknownRJump_0x3D4D3
	ld a, 0
	ld [sScrollX], a
	ld [sScrollY], a
	ld [$A690], a
	ld a, 4
	ld [$A68B], a
	call UnknownCall_0x3E46
	ld de, $65FF
	call UnknownCall_0x3E2A2
	call UnknownCall_0x3D58D
	call UnknownCall_0x3D533
	call UnknownCall_0x3D56B
	ld hl, $A858
	ld de, $A6C3
	ld b, 2
	call UnknownCall_0x3DB00
	ld hl, $A871
	ld de, $A6D5
	ld b, 1
	call UnknownCall_0x3DB00
	call UnknownCall_0x3E277
	ld a, 195
	ldh_n_a $40
	xor a
	ldh_n_a $81
	ld [$A69A], a
	ld [$A6B0], a
	ld [$A6B1], a
	ld [$A783], a
	ld [$A7BD], a
	ld a, 28
	ld [$A468], a
	call UnknownCall_0x2AAA
	ret

UnknownCall_0x3D533:
	ld a, [$A2B4]
	or a
	ret z
	ld a, [$A224]
	or a
	ret nz
	ld a, 47
	ld [$A7D2], a
	ld a, 67
	ld [$A840], a
	call UnknownCall_0x3EEA4
	ld a, [$A858]
	bit 0, a
	jr nz, UnknownRJump_0x3D562
	ld e, a
	ld a, 1
	ld [$A7BB], a
	ld a, 60
	ld [$A7BC], a
	ld a, 117
	ld [$A6D2], a
	ld a, e

UnknownRJump_0x3D562:
	set 0, a
	ld [$A858], a
	call UnknownCall_0x3F8E
	ret

UnknownCall_0x3D56B:
	ld a, [$A840]
	cp $44
	ret nz
	ld a, 69
	ld [$A840], a
	call UnknownCall_0x3EEA4
	ld a, 255
	ld [$A224], a
	ld a, [$A871]
	bit 7, a
	ret z
	ld a, 57
	ld [$A7D2], a
	call UnknownCall_0x3F8E
	ret

UnknownCall_0x3D58D:
	ld a, 0
	ld [$A7BB], a
	ld a, [$A858]
	and $01
	ret z
	ld a, 56
	ld [$A7D2], a
	call UnknownCall_0x3F8E
	ld a, 51
	ld [$A7D2], a
	ld a, 52
	ld [$A7D5], a
	call UnknownCall_0x3F8E
	ld a, 112
	ld [$A6CC], a
	ld a, 3
	ld [$A7BB], a
	ld a, 0
	ld [$A7BC], a
	ld a, 123
	ld [$A6D2], a
	ld a, [$A871]
	bit 7, a
	ret z
	ld a, 57
	ld [$A7D2], a
	call UnknownCall_0x3F8E
	ret

UnknownJump_0x3D5D0:
	ld a, [$A844]
	and $0F
	ld [$A844], a
	ld a, 146
	ld [$A842], a
	ld a, 234
	ld [$A843], a
	ld a, 75
	ld [$A840], a
	ld [$A840], a
	jr UnknownRJump_0x3D606

UnknownJump_0x3D5EC:
	ld a, [$A844]
	and $0F
	ld [$A844], a
	ld a, 75
	ld [$A842], a
	ld a, 242
	ld [$A843], a
	ld a, 70
	ld [$A840], a
	ld [$A840], a

UnknownRJump_0x3D606:
	ld a, 255
	ld [$A224], a
	call UnknownCall_0x3E9FB
	ld a, 255
	ld [$A468], a
	call UnknownCall_0x2AAA
	call UnknownCall_0x3D61F
	ld a, 8
	call UnknownCall_0x3E3BA
	ret

UnknownCall_0x3D61F:
	call DisableVBlank
	ld a, BANK(GFX_OW_Overworld) ;prepare bank switch
	ld bc, $0200
	ld hl, GFX_OW_Overworld
	ld de, $8000
	call FarCopyMem
	ld a, BANK(GFX_OW_TreeZone) ;prepare bank switch
	ld bc, $1600
	ld hl, GFX_OW_TreeZone
	ld de, $8200
	call FarCopyMem
	ld a, 14 ;prepare bank switch
	ld bc, $0400
	ld hl, $7900
	ld de, $9800
	call FarCopyMem
	ld a, 0
	ld [sScrollX], a
	ld [sScrollY], a
	ld [$A690], a
	ld a, 5
	ld [$A68B], a
	call UnknownCall_0x3E46
	ld de, $6680
	call UnknownCall_0x3E2A2
	call UnknownCall_0x3D6B7
	call UnknownCall_0x3D69C
	ld hl, $A85D
	ld de, $A6C3
	ld b, 3
	call UnknownCall_0x3DB00
	call UnknownCall_0x3E277
	ld a, 195
	ldh_n_a $40
	xor a
	ldh_n_a $81
	ld [$A69A], a
	ld [$A6B0], a
	ld [$A6B1], a
	ld [$A783], a
	ld a, 160
	ld [$A6A7], a
	ld a, 18
	ld [$A468], a
	call UnknownCall_0x2AAA
	ret

UnknownCall_0x3D69C:
	ld a, [$A2B4]
	or a
	ret z
	ld a, [$A224]
	or a
	ret nz
	ld a, [$A85E]
	bit 0, a
	ret nz
	set 0, a
	ld [$A85E], a
	ld a, 125
	ld [$A6D5], a
	ret

UnknownCall_0x3D6B7:
	ld a, [$A85E]
	and $01
	ret z
	ld a, 129
	ld [$A6D5], a
	ret

UnknownJump_0x3D6C3:
	ld a, 129
	ld [$A842], a
	ld a, 137
	ld [$A843], a
	ld a, 90
	ld [$A840], a
	ld a, 255
	ld [$A224], a
	ld a, 255
	ld [$A468], a
	call UnknownCall_0x2AAA
	call UnknownCall_0x3E9FB
	call UnknownCall_0x3D6EB
	ld a, 2
	call UnknownCall_0x3E3BA
	ret

UnknownCall_0x3D6EB:
	call DisableVBlank
	ld a, 13 ;prepare bank switch
	ld bc, $0200
	ld hl, $4000
	ld de, $8000
	call FarCopyMem
	ld a, 17 ;prepare bank switch
	ld bc, $1600
	ld hl, $5A00
	ld de, $8200
	call FarCopyMem
	ld a, 14 ;prepare bank switch
	ld bc, $0400
	ld hl, $7D80
	ld de, $9800
	call FarCopyMem
	ld a, 0
	ld [sScrollX], a
	ld [sScrollY], a
	ld [$A690], a
	ld a, 7
	ld [$A68B], a
	call UnknownCall_0x3E46
	ld a, 225
	ld [sBGPalette], a
	ld a, 57
	ld [sOAMPalette2], a
	ld de, $66AA
	call UnknownCall_0x3E2A2
	ld a, 195
	ldh_n_a $40
	xor a
	ldh_n_a $81
	ld [$A69A], a
	ld [$A79E], a
	ld [$A79D], a
	ld a, 1
	ld [$A79F], a
	ld a, 23
	ld [$A78B], a
	ld a, 14
	ld [$A468], a
	call UnknownCall_0x2AAA
	ret

UnknownJump_0x3D760:
	ld a, 12
	ld [$A842], a
	ld a, 112
	ld [$A843], a
	ld a, 80
	ld [$A840], a
	ld [$A840], a
	ld a, 255
	ld [$A224], a
	call UnknownCall_0x3E9FB
	ld a, 255
	ld [$A468], a
	call UnknownCall_0x2AAA
	call UnknownCall_0x3D79A
	ld a, [$A862]
	and $80
	swap a
	ld b, a
	rlca
	or b
	add 56
	ld [$A6C4], a
	ld a, 1
	call UnknownCall_0x3E3BA
	ret

UnknownCall_0x3D79A:
	call DisableVBlank
	ld a, BANK(GFX_OW_Overworld) ;prepare bank switch
	ld bc, $0200
	ld hl, GFX_OW_Overworld
	ld de, $8000
	call FarCopyMem
	ld a, BANK(GFX_OW_MarioZone) ;prepare bank switch
	ld bc, $1600
	ld hl, GFX_OW_MarioZone
	ld de, $8200
	call FarCopyMem
	ld a, 14 ;prepare bank switch
	ld bc, $0400
	ld hl, $7B40
	ld de, $9800
	call FarCopyMem
	ld a, 0
	ld [sScrollX], a
	ld [sScrollY], a
	ld [$A690], a
	ld a, 6
	ld [$A68B], a
	call UnknownCall_0x3E46
	ld de, $664D
	call UnknownCall_0x3E2A2
	ld a, 74
	ld [$A6C4], a
	ld a, [$A865]
	and $80
	swap a
	sla a
	add 76
	ld [$A6BB], a
	ld a, [$A865]
	and $80
	rlca
	ld b, a
	rlca
	or b
	add 16
	ld [$A6BC], a
	ld a, [$A863]
	and $80
	rlca
	rlca
	add 6
	ld [$A7D8], a
	ld a, [$A864]
	and $80
	rlca
	rlca
	add 9
	ld [$A7DB], a
	call UnknownCall_0x3F8E
	ld hl, $A862
	ld de, $A6CC
	ld b, 4
	call UnknownCall_0x3DB00
	call UnknownCall_0x3E277
	ld a, 195
	ldh_n_a $40
	xor a
	ldh_n_a $81
	ld [$A69A], a
	ld [$A6B0], a
	ld [$A6B1], a
	ld [$A783], a
	ld a, 27
	ld [$A468], a
	call UnknownCall_0x2AAA
	ret

UnknownJump_0x3D848:
	ld a, 255
	ld [$A468], a
	call UnknownCall_0x2AAA
	call UnknownCall_0x3E9FB
	call UnknownCall_0x3D880
	ld a, [$A844]
	and $0F
	ld [$A844], a
	ld a, 212
	ld [$A842], a
	ld a, 131
	ld [$A843], a
	ld a, 114
	ld [$A840], a
	ld [$A840], a
	ld a, 255
	ld [$A224], a
	ld a, 0
	ld [sBGPalette], a
	ld a, 1
	call UnknownCall_0x3E3BA
	ret

UnknownCall_0x3D880:
	call DisableVBlank
	ld a, BANK(GFX_OW_Overworld) ;prepare bank switch
	ld bc, $0200
	ld hl, GFX_OW_Overworld
	ld de, $8000
	call FarCopyMem
	ld a, BANK(GFX_OW_PumpkinZone) ;prepare bank switch
	ld bc, $1600
	ld hl, GFX_OW_PumpkinZone
	ld de, $8200
	call FarCopyMem
	ld a, 16 ;prepare bank switch
	ld bc, $0400
	ld hl, $7000
	ld de, $9800
	call FarCopyMem
	ld a, 0
	ld [sScrollX], a
	ld [sScrollY], a
	ld [$A690], a
	ld a, 8
	ld [$A68B], a
	call UnknownCall_0x3E46
	ld de, $66BC
	call UnknownCall_0x3E2A2
	ld a, 195
	ldh_n_a $40
	xor a
	ldh_n_a $81
	ld [$A69A], a
	ld [$A7AA], a
	ld a, 13
	ld [$A468], a
	call UnknownCall_0x2AAA
	call UnknownCall_0x3EEA4
	ld a, 228
	ld [sBGPalette], a
	ret

UnknownCall_0x3D8E6:
	ld a, [$A699]
	inc a
	ld [$A699], a
	and $38
	rlca
	swap a
	ld d, 0
	ld e, a
	ld hl, $5A21
	add hl, de
	ld a, [hl]
	ld [$A6B7], a
	ld a, [$A699]
	and $0C
	rrca
	rrca
	ld e, a
	ld d, 0
	ld hl, $5A29
	add hl, de
	ld a, [hl]
	ld [$A6BA], a
	ld a, [$A6B9]
	ld b, a
	ld a, [$A69A]
	ld c, a
	and $07
	jr nz, UnknownRJump_0x3D927
	bit 5, c
	jr nz, UnknownRJump_0x3D922
	inc b
	jr UnknownRJump_0x3D923

UnknownRJump_0x3D922:
	dec b

UnknownRJump_0x3D923:
	ld a, b
	ld [$A6B9], a

UnknownRJump_0x3D927:
	ld a, [$A697]
	and $01
	jr z, UnknownRJump_0x3D96F
	ld a, [$A6BC]
	ld b, a
	ld a, [$A6A2]
	inc a
	cp $50
	jr c, UnknownRJump_0x3D93B
	xor a

UnknownRJump_0x3D93B:
	ld [$A6A2], a
	ld hl, $6227
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [$A6A5], a
	ld d, a
	and $07
	bit 3, d
	jr nz, UnknownRJump_0x3D953
	add b
	jr UnknownRJump_0x3D956

UnknownRJump_0x3D953:
	ld c, a
	ld a, b
	sub c

UnknownRJump_0x3D956:
	ld [$A6BC], a
	ld a, [$A6BB]
	ld b, a
	ld a, d
	swap a
	and $07
	bit 7, d
	jr nz, UnknownRJump_0x3D969
	add b
	jr UnknownRJump_0x3D96C

UnknownRJump_0x3D969:
	ld c, a
	ld a, b
	sub c

UnknownRJump_0x3D96C:
	ld [$A6BB], a

UnknownRJump_0x3D96F:
	ld a, [$A6A2]
	and $78
	rrca
	rrca
	rrca
	ld hl, $5A16
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	add 22
	ld e, a
	ld a, [$A6A5]
	bit 7, a
	jr nz, UnknownRJump_0x3D98D
	ld a, e
	add 3
	ld e, a

UnknownRJump_0x3D98D:
	ld a, e
	ld [$A6BD], a
	ld a, [$A851]
	bit 7, a
	jr z, UnknownRJump_0x3D99D
	ld a, 255
	ld [$A6BD], a

UnknownRJump_0x3D99D:
	ld a, [$A69A]
	and $07
	jr nz, UnknownRJump_0x3DA12
	ld a, [$A7BA]
	or a
	jr z, UnknownRJump_0x3DA12
	ld a, [$A840]
	cp $2C
	jr nz, UnknownRJump_0x3D9DE
	ld a, [$A86E]
	bit 7, a
	jr nz, UnknownRJump_0x3D9DE
	ld a, [$A7D2]
	cp $27
	jr nc, UnknownRJump_0x3D9DE
	inc a
	cp $27
	jr c, UnknownRJump_0x3D9D3
	ld a, 21
	ld [$A460], a
	ld a, 255
	ld [$A7D2], a
	call UnknownCall_0x3F8E
	jr UnknownRJump_0x3D9DE

UnknownRJump_0x3D9D3:
	ld [$A7D2], a
	call UnknownCall_0x3F8E
	ld a, 6
	ld [$A460], a

UnknownRJump_0x3D9DE:
	ld a, [$A840]
	cp $2F
	jr nz, UnknownRJump_0x3DA12
	ld a, [$A86F]
	bit 7, a
	jr nz, UnknownRJump_0x3DA12
	ld a, [$A7D5]
	cp $2F
	jr nc, UnknownRJump_0x3DA12
	inc a
	cp $2F
	jr c, UnknownRJump_0x3DA07
	ld a, 21
	ld [$A460], a
	ld a, 255
	ld [$A7D5], a
	call UnknownCall_0x3F8E
	jr UnknownRJump_0x3DA12

UnknownRJump_0x3DA07:
	ld [$A7D5], a
	call UnknownCall_0x3F8E
	ld a, 6
	ld [$A460], a

UnknownRJump_0x3DA12:
	call UnknownCall_0x3E277
	ret

UnknownData_0x3DA16:
INCBIN "baserom.gb", $3DA16, $3DA2D - $3DA16


UnknownCall_0x3DA2D:
	ld a, [$A784]
	inc a
	ld [$A784], a
	cp $0A
	jr c, UnknownRJump_0x3DA66
	xor a
	ld [$A784], a
	ld a, [$A783]
	inc a
	ld [$A783], a
	ld d, a
	and $03
	ld e, a
	ld a, d
	and $10
	swap a
	rlca
	rlca
	or e
	add 87
	ld [$A6BD], a
	bit 4, d
	jr nz, UnknownRJump_0x3DA60
	ld hl, $A6BB
	inc [hl]
	inc hl
	dec [hl]
	jr UnknownRJump_0x3DA66

UnknownRJump_0x3DA60:
	ld hl, $A6BB
	dec [hl]
	inc hl
	inc [hl]

UnknownRJump_0x3DA66:
	ld a, [$A697]
	and $02
	srl a
	add 4
	ld [$A6BA], a
	ld a, [$A697]
	and $01
	jr z, UnknownRJump_0x3DAB7
	ld a, [$A6B9]
	ld b, a
	ld a, [$A6B0]
	inc a
	cp $50
	jr c, UnknownRJump_0x3DA86
	xor a

UnknownRJump_0x3DA86:
	ld [$A6B0], a
	ld hl, $6227
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld d, a
	and $07
	bit 3, d
	jr nz, UnknownRJump_0x3DA9B
	add b
	jr UnknownRJump_0x3DA9E

UnknownRJump_0x3DA9B:
	ld c, a
	ld a, b
	sub c

UnknownRJump_0x3DA9E:
	ld [$A6B9], a
	ld a, [$A6B8]
	ld b, a
	ld a, d
	swap a
	and $07
	bit 7, d
	jr nz, UnknownRJump_0x3DAB1
	add b
	jr UnknownRJump_0x3DAB4

UnknownRJump_0x3DAB1:
	ld c, a
	ld a, b
	sub c

UnknownRJump_0x3DAB4:
	ld [$A6B8], a

UnknownRJump_0x3DAB7:
	ld a, [$A696]
	and $30
	swap a
	ld [$A6B7], a
	ld a, [$A84D]
	bit 7, a
	jr z, UnknownRJump_0x3DACD
	ld a, 255
	ld [$A6B7], a

UnknownRJump_0x3DACD:
	call UnknownCall_0x3DADF
	ld hl, $A849
	ld de, $A6C3
	ld b, 5
	call UnknownCall_0x3DB00
	call UnknownCall_0x3E277
	ret

UnknownCall_0x3DADF:
	ld a, [$A69A]
	and $0F
	ret nz
	ld a, [$A6D2]
	cp $6D
	ret nc
	inc a
	ld [$A6D2], a
	ld a, 6
	ld [$A460], a
	ld a, [$A6D2]
	cp $6D
	ret c
	ld a, 21
	ld [$A460], a
	ret

UnknownRJump_0x3DB00:
UnknownCall_0x3DB00:
	ld a, [hli]
	bit 7, a
	jr z, UnknownRJump_0x3DB09
	ld a, 14
	jr UnknownRJump_0x3DB0B

UnknownRJump_0x3DB09:
	ld a, 255

UnknownRJump_0x3DB0B:
	ld [de], a
	inc de
	inc de
	inc de
	dec b
	jr nz, UnknownRJump_0x3DB00

UnknownCall_0x3DB12:
	ld a, [$A7BA]
	or a
	ret z
	ld a, [$A69A]
	and $07
	ret nz
	ld a, [$A7D2]
	cp $1F
	ret nc
	inc a
	cp $1F
	jr c, UnknownRJump_0x3DB34
	ld a, 21
	ld [$A460], a
	ld a, 255
	ld [$A7D2], a
	jr UnknownRJump_0x3DB3C

UnknownRJump_0x3DB34:
	ld [$A7D2], a
	ld a, 6
	ld [$A460], a

UnknownRJump_0x3DB3C:
	call UnknownCall_0x3F8E
	ret

UnknownCall_0x3DB40:
	ld a, [$A69A]
	and $03
	jr nz, UnknownRJump_0x3DB7A
	ld a, [$A7BD]
	or a
	jr nz, UnknownRJump_0x3DB68
	push bc
	ldh a, [rDIV]
	ld b, a
	swap a
	add b
	ld b, a
	ld a, [$A7B7]
	add b
	ld b, a
	ldh_a_n $97
	add b
	ld [$A7B7], a
	pop bc
	and $07
	jr nz, UnknownRJump_0x3DB7A
	ld a, 5

UnknownRJump_0x3DB68:
	dec a
	ld [$A7BD], a
	dec a
	and $03
	ld hl, $5D58
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [$A6B7], a

UnknownRJump_0x3DB7A:
	ld a, [$A69A]
	and $18
	srl a
	srl a
	srl a
	ld hl, $5D5C
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [$A6C9], a
	ld a, [$A6C7]
	dec a
	ld [$A6C7], a
	ld a, [$A69A]
	and $03
	jr nz, UnknownRJump_0x3DBAD
	ld a, [$A6C8]
	inc a
	ld [$A6C8], a
	or a
	jr nz, UnknownRJump_0x3DBAD
	ldh a, [rDIV]
	ld [$A6C7], a

UnknownRJump_0x3DBAD:
	ld a, [$A69A]
	ld d, a
	and $07
	jp nz, UnknownJump_0x3DC3D
	ld a, d
	and $18
	srl a
	srl a
	srl a
	ld hl, $5D60
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [$A6BA], a
	ld a, e
	or a
	jr nz, UnknownRJump_0x3DBE1
	ldh a, [rDIV]
	and $1E
	ld d, 0
	ld e, a
	ld hl, $5D6C
	add hl, de
	ld a, [hli]
	ld [$A6B8], a
	ld a, [hl]
	ld [$A6B9], a

UnknownRJump_0x3DBE1:
	ld a, [$A69A]
	and $18
	srl a
	srl a
	srl a
	ld hl, $5D64
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [$A6BD], a
	ld a, e
	cp $01
	jr nz, UnknownRJump_0x3DC0F
	ldh a, [rDIV]
	and $1E
	ld d, 0
	ld e, a
	ld hl, $5D6C
	add hl, de
	ld a, [hli]
	ld [$A6BB], a
	ld a, [hl]
	ld [$A6BC], a

UnknownRJump_0x3DC0F:
	ld a, [$A69A]
	and $18
	srl a
	srl a
	srl a
	ld hl, $5D68
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	ld [$A6C0], a
	ld a, e
	cp $02
	jr nz, UnknownRJump_0x3DC3D
	ldh a, [rDIV]
	and $1E
	ld d, 0
	ld e, a
	ld hl, $5D6C
	add hl, de
	ld a, [hli]
	ld [$A6BE], a
	ld a, [hl]
	ld [$A6BF], a

UnknownJump_0x3DC3D:
UnknownRJump_0x3DC3D:
	call UnknownCall_0x3DC62
	call UnknownCall_0x3E277
	ld a, [$A6D2]
	cp $7B
	ret nc
	ld a, [$A69A]
	and $07
	ret nz
	ld a, [$A6D2]
	inc a
	cp $7C
	jr c, UnknownRJump_0x3DC59

UnknownData_0x3DC57:
INCBIN "baserom.gb", $3DC57, $3DC59 - $3DC57


UnknownRJump_0x3DC59:
	ld [$A6D2], a
	ld a, 6
	ld [$A460], a
	ret

UnknownCall_0x3DC62:
	ld a, [$A7BB]
	or a
	jr nz, UnknownRJump_0x3DC71
	ld a, 255
	ld [$A6CC], a
	ld [$A6CF], a
	ret

UnknownRJump_0x3DC71:
	cp $01
	jr nz, UnknownRJump_0x3DCC4
	ld a, [$A69A]
	and $01
	ret z
	ld a, 111
	ld [$A6CC], a
	ld a, [$A69A]
	and $0C
	rrca
	rrca
	add 113
	ld [$A6CF], a
	ld a, [$A6CA]
	add 3
	ld [$A6CA], a
	ld [$A6CD], a
	ld a, [$A6CB]
	sub 3
	ld [$A6CB], a
	ld [$A6CE], a
	ld a, [$A7BC]
	dec a
	ld [$A7BC], a
	ret nz
	ld a, 2
	ld [$A7BB], a
	ld a, 168
	ld [$A6CA], a
	ld a, 14
	ld [$A6CB], a
	ld a, 255
	ld [$A6CF], a
	ld a, 10
	ld [$A7BC], a
	ret

UnknownRJump_0x3DCC4:
	cp $02
	jr nz, UnknownRJump_0x3DD16
	ld a, [$A6CA]
	sub 2
	ld [$A6CA], a
	ld a, [$A6CB]
	add 2
	ld [$A6CB], a
	ld a, 111
	ld [$A6CC], a
	ld a, [$A7BC]
	dec a
	ld [$A7BC], a
	ret nz
	ld a, 3
	ld [$A7BB], a
	ld a, 156
	ld [$A6CA], a
	ld a, 36
	ld [$A6CB], a
	ld a, 112
	ld [$A6CC], a
	ld a, 255
	ld [$A6CF], a
	ld a, 56
	ld [$A7D2], a
	ld a, 52
	ld [$A7D5], a
	call UnknownCall_0x3F8E
	ld a, 20
	ld [$A7BC], a
	ld a, 24
	ld [$A460], a
	ret

UnknownRJump_0x3DD16:
	ld a, 140
	ld [$A6CA], a
	ld a, 36
	ld [$A6CB], a
	ld a, 255
	ld [$A6CC], a
	ld a, 255
	ld [$A6CF], a
	ld a, 0
	ld [sScrollX], a
	ld [sScrollY], a
	ld a, [$A7BC]
	or a
	ret z
	dec a
	ld [$A7BC], a
	ld a, [$A69A]
	bit 1, a
	ret z
	ld a, [$A7BC]
	srl a
	ld [sScrollX], a
	cpl
	ld [sScrollY], a
	ld a, [$A7BC]
	or a
	ret nz

UnknownData_0x3DD52:
INCBIN "baserom.gb", $3DD52, $3DD8C - $3DD52


UnknownCall_0x3DD8C:
	ld a, [$A6B5]
	ld e, a
	ld a, [$A69A]
	ld d, a
	and $07
	jr nz, UnknownRJump_0x3DDA0
	bit 7, d
	jr z, UnknownRJump_0x3DD9F
	inc e
	jr UnknownRJump_0x3DDA0

UnknownRJump_0x3DD9F:
	dec e

UnknownRJump_0x3DDA0:
	ld a, e
	ld [$A6B5], a
	ld a, [$A6B8]
	ld e, a
	ld a, [$A69A]
	ld d, a
	and $07
	jr nz, UnknownRJump_0x3DDB8
	bit 7, d
	jr z, UnknownRJump_0x3DDB7
	dec e
	jr UnknownRJump_0x3DDB8

UnknownRJump_0x3DDB7:
	inc e

UnknownRJump_0x3DDB8:
	ld a, e
	ld [$A6B8], a
	call UnknownCall_0x3E4EB
	call UnknownCall_0x3E277
	ret

UnknownCall_0x3DDC3:
	call UnknownCall_0x3F4A0
	ret

UnknownCall_0x3DDC7:
	call UnknownCall_0x3F4A0
	ret

UnknownCall_0x3DDCB:
	call UnknownCall_0x3F4A0
	ret

UnknownCall_0x3DDCF:
	call UnknownCall_0x3F4A0
	ret

UnknownCall_0x3DDD3:
	ld a, [$A69A]
	and $30
	swap a
	add 42
	ld [$A6BA], a
	ld [$A6BD], a
	ld [$A6C0], a
	ld a, [$A69A]
	and $30
	swap a
	add 46
	ld [$A6CC], a
	ld [$A6CF], a
	ld a, [$A69A]
	and $7C
	srl a
	srl a
	ld c, a
	ld a, 80
	sub c
	ld [$A6CE], a
	ld a, c
	and $0F
	ld c, a
	ld a, 64
	sub c
	ld [$A6CB], a
	ld a, [$A86D]
	bit 7, a
	jr nz, UnknownRJump_0x3DE25
	ld a, [$A69A]
	and $60
	srl a
	swap a
	add 38
	ld [$A6B7], a
	jr UnknownRJump_0x3DE4E

UnknownRJump_0x3DE25:
	ld a, [$A69A]
	and $0F
	jr nz, UnknownRJump_0x3DE4E
	push bc
	ldh a, [rDIV]
	ld b, a
	swap a
	add b
	ld b, a
	ld a, [$A7B7]
	add b
	ld b, a
	ldh_a_n $97
	add b
	ld [$A7B7], a
	pop bc
	ld a, [$A7B7]
	and $01
	add 53
	ld [$A7D2], a
	call UnknownCall_0x3F8E

UnknownRJump_0x3DE4E:
	ld a, [$A69A]
	ld d, a
	and $02
	srl a
	and d
	ld d, a
	ld a, [$A6A8]
	bit 0, a
	jr nz, UnknownRJump_0x3DE7F
	ld a, [$A6A7]
	sub d
	ld c, a
	ld [$A6A7], a
	cp $C0
	jr nz, UnknownRJump_0x3DE78
	ld a, [$A6A8]
	xor $FF
	ld [$A6A8], a
	ld a, 120
	ld [$A6D1], a

UnknownRJump_0x3DE78:
	ld a, 50
	ld [$A6D2], a
	jr UnknownRJump_0x3DE9D

UnknownRJump_0x3DE7F:
	ld a, [$A6A7]
	add d
	ld c, a
	ld [$A6A7], a
	cp $B0
	jr nz, UnknownRJump_0x3DE98
	ld a, [$A6A8]
	xor $FF
	ld [$A6A8], a
	ld a, 64
	ld [$A6D1], a

UnknownRJump_0x3DE98:
	ld a, 51
	ld [$A6D2], a

UnknownRJump_0x3DE9D:
	ld a, c
	ld [$A6D0], a
	ld a, [$A69A]
	and $0F
	jr nz, UnknownRJump_0x3DEC3
	ld a, [$A6D5]
	cp $81
	jr nc, UnknownRJump_0x3DEC3
	inc a
	ld c, a
	ld [$A6D5], a
	ld a, 6
	ld [$A460], a
	ld a, c
	cp $81
	jr nz, UnknownRJump_0x3DEC3
	ld a, 21
	ld [$A460], a

UnknownRJump_0x3DEC3:
	call UnknownCall_0x3E277
	ret

UnknownCall_0x3DEC7:
	ld a, [$A69A]
	and $03
	jr nz, UnknownRJump_0x3DEF2
	ld a, [$A865]
	bit 7, a
	jr nz, UnknownRJump_0x3DEF2
	ld a, [$A864]
	bit 7, a
	jr z, UnknownRJump_0x3DEF2
	ld a, [$A6BB]
	cp $5C
	jr nc, UnknownRJump_0x3DEF2
	inc a
	ld [$A6BB], a
	ld a, [$A6BC]
	cp $13
	jr nc, UnknownRJump_0x3DEF2
	inc a
	ld [$A6BC], a

UnknownRJump_0x3DEF2:
	ld a, [$A69A]
	and $01
	jr nz, UnknownRJump_0x3DF0B
	ld a, [$A842]
	cp $2E
	jr c, UnknownRJump_0x3DF0B
	ld a, [$A6C4]
	cp $4A
	jr nc, UnknownRJump_0x3DF0B
	inc a
	ld [$A6C4], a

UnknownRJump_0x3DF0B:
	ld a, [$A69A]
	and $70
	swap a
	ld d, 0
	ld e, a
	ld hl, $5FA0
	add hl, de
	ld a, [hl]
	ld [$A6C9], a
	ld a, [$A69A]
	and $70
	swap a
	ld d, 0
	ld e, a
	ld hl, $5FA8
	add hl, de
	ld a, [hl]
	ld [$A6B6], a
	ld hl, $5FB0
	add hl, de
	ld a, [hl]
	ld [$A6B9], a
	ld hl, $5FB8
	add hl, de
	ld a, [hl]
	ld [$A6BE], a
	ld hl, $5FC0
	add hl, de
	ld a, [hl]
	ld [$A6C1], a
	call UnknownCall_0x3E277
	ld a, [$A69A]
	ld c, a
	and $0F
	ret nz
	ld a, c
	and $E0
	rrca
	swap a
	ld d, 0
	ld e, a
	ld hl, $5FC8
	add hl, de
	ld a, [hl]
	ld [$A7D2], a
	ld hl, $5FD0
	add hl, de
	ld a, [hl]
	ld [$A7D5], a
	ld a, [$A863]
	bit 7, a
	jr nz, UnknownRJump_0x3DF83
	ld a, [$A862]
	bit 7, a
	jr z, UnknownRJump_0x3DF83
	ld a, [$A7D8]
	cp $08
	jr nc, UnknownRJump_0x3DF83
	inc a
	ld [$A7D8], a

UnknownRJump_0x3DF83:
	ld a, [$A864]
	bit 7, a
	jr nz, UnknownRJump_0x3DF9C
	ld a, [$A863]
	bit 7, a
	jr z, UnknownRJump_0x3DF9C
	ld a, [$A7DB]
	cp $0B
	jr nc, UnknownRJump_0x3DF9C
	inc a
	ld [$A7DB], a

UnknownRJump_0x3DF9C:
	call UnknownCall_0x3F8E
	ret

UnknownData_0x3DFA0:
INCBIN "baserom.gb", $3DFA0, $3DFE8 - $3DFA0


UnknownCall_0x3DFE8:
	ld a, [$A69A]
	and $07
	jr nz, UnknownRJump_0x3E003
	ld a, [$A796]
	inc a
	ld [$A796], a
	cp $03
	jr c, UnknownRJump_0x3DFFE
	xor a
	ld [$A796], a

UnknownRJump_0x3DFFE:
	add 53
	ld [$A6BA], a

UnknownRJump_0x3E003:
	ld a, [$A69A]
	and $03
	jr nz, UnknownRJump_0x3E02E
	ld a, 255
	ld [$A6BD], a
	ldh a, [rDIV]
	and $7E
	jr nz, UnknownRJump_0x3E02E
	ld a, 56
	ld [$A6BD], a
	ld a, [$A799]
	inc a
	and $03
	ld [$A799], a
	ld d, 0
	ld e, a
	ld hl, $61D3
	add hl, de
	ld a, [hl]
	ld [$A6BB], a

UnknownRJump_0x3E02E:
	ld a, [$A79D]
	or a
	jr nz, UnknownRJump_0x3E08F
	ld a, [$A69A]
	and $03
	jr nz, UnknownRJump_0x3E08F
	ld a, [$A797]
	cp $01
	jr nz, UnknownRJump_0x3E053
	ld a, 2
	ld [$A797], a
	ld a, 225
	ld [sBGPalette], a
	ld a, 57
	ld [sOAMPalette2], a
	jr UnknownRJump_0x3E08F

UnknownRJump_0x3E053:
	cp $02
	jr nz, UnknownRJump_0x3E06B
	xor a
	ld [$A797], a
	ld a, 225
	xor $FF
	ld [sBGPalette], a
	ld a, 57
	xor $FF
	ld [sOAMPalette2], a
	jr UnknownRJump_0x3E08F

UnknownRJump_0x3E06B:
	ld a, 225
	ld [sBGPalette], a
	ld a, 57
	ld [sOAMPalette2], a
	ld a, [$A6BD]
	cp $38
	jr nz, UnknownRJump_0x3E08F
	ld a, 225
	xor $FF
	ld [sBGPalette], a
	ld a, 57
	xor $FF
	ld [sOAMPalette2], a
	ld a, 1
	ld [$A797], a

UnknownRJump_0x3E08F:
	ld a, [$A69A]
	and $01
	jr nz, UnknownRJump_0x3E0C7
	ld a, [$A798]
	inc a
	ld [$A798], a
	ld a, [$A79E]
	cp $01
	jr nz, UnknownRJump_0x3E0A9
	call UnknownCall_0x3E0CB
	jr UnknownRJump_0x3E0C7

UnknownRJump_0x3E0A9:
	cp $02
	jr nz, UnknownRJump_0x3E0B2
	call UnknownCall_0x3E0FD
	jr UnknownRJump_0x3E0C7

UnknownRJump_0x3E0B2:
	cp $03
	jr nz, UnknownRJump_0x3E0BB
	call UnknownCall_0x3E12F
	jr UnknownRJump_0x3E0C7

UnknownRJump_0x3E0BB:
	cp $04
	jr nz, UnknownRJump_0x3E0C4
	call UnknownCall_0x3E147
	jr UnknownRJump_0x3E0C7

UnknownRJump_0x3E0C4:
	call UnknownCall_0x3E15F

UnknownRJump_0x3E0C7:
	call UnknownCall_0x3E277
	ret

UnknownCall_0x3E0CB:
	ld a, [$A798]
	and $03
	ld d, 0
	ld e, a
	ld hl, $61CB
	add hl, de
	ld a, [hl]
	add 57
	ld [$A6C0], a
	ld a, [$A6BE]
	cp $28
	jp c, UnknownJump_0x3E17E
	res 1, e
	sub e
	ld [$A6BE], a
	cp $40
	ret c
	cp $60
	ret nc
	ld a, [$A6BF]
	cp $50
	ret c
	ld a, 255
	ld [$A6C0], a
	ret

UnknownCall_0x3E0FD:
	ld a, [$A798]
	and $03
	ld d, 0
	ld e, a
	ld hl, $61CB
	add hl, de
	ld a, [hl]
	add 60
	ld [$A6C0], a
	ld a, [$A6BE]
	cp $78
	jp nc, UnknownJump_0x3E17E
	res 1, e
	add e
	ld [$A6BE], a
	cp $40
	ret c
	cp $60
	ret nc
	ld a, [$A6BF]
	cp $50
	ret c

UnknownData_0x3E129:
INCBIN "baserom.gb", $3E129, $3E12F - $3E129


UnknownCall_0x3E12F:
	ld a, 63
	ld [$A6C0], a
	ld a, [$A6BF]
	cp $36
	jp c, UnknownJump_0x3E1B3
	sub 4
	ld [$A6BF], a
	ld a, 255
	ld [$A6C0], a
	ret

UnknownCall_0x3E147:
	ld a, 63
	ld [$A6C0], a
	ld a, [$A6BF]
	cp $62
	jp nc, UnknownJump_0x3E1B3
	add 4
	ld [$A6BF], a
	ld a, 255
	ld [$A6C0], a
	ret

UnknownCall_0x3E15F:
	ld a, [$A798]
	and $0C
	rrca
	rrca
	ld d, 0
	ld e, a
	ld hl, $61CF
	add hl, de
	ld a, [hl]
	add 63
	ld [$A6C0], a
	ld a, [$A79F]
	or a
	jr z, UnknownRJump_0x3E17E
	dec a
	ld [$A79F], a
	ret

UnknownJump_0x3E17E:
UnknownRJump_0x3E17E:
	ldh a, [rDIV]
	ld e, a
	ldh a, [rTIMA]
	add e
	and $07
	ld e, a
	ld a, [$A79E]
	ld d, a
	cp e
	jr z, UnknownRJump_0x3E17E
	ld a, e
	or a
	jr z, UnknownRJump_0x3E1A9
	cp $05
	jr c, UnknownRJump_0x3E199
	sub 4
	ld e, a

UnknownRJump_0x3E199:
	cp $03
	jr nc, UnknownRJump_0x3E1A4
	ld a, d
	cp $03
	jr c, UnknownRJump_0x3E17E

UnknownData_0x3E1A2:
INCBIN "baserom.gb", $3E1A2, $3E1A4 - $3E1A2


UnknownRJump_0x3E1A4:
	ld a, d
	cp $03
	jr nc, UnknownRJump_0x3E17E

UnknownRJump_0x3E1A9:
	ld a, e
	ld [$A79E], a
	ld a, 30
	ld [$A79F], a
	ret

UnknownJump_0x3E1B3:
	ld a, [$A6BE]
	cp $32
	jr c, UnknownRJump_0x3E1C0
	ld a, 1
	ld [$A79E], a
	ret

UnknownRJump_0x3E1C0:
	ld a, 2
	ld [$A79E], a
	ld a, 30
	ld [$A79F], a
	ret

UnknownData_0x3E1CB:
INCBIN "baserom.gb", $3E1CB, $3E1D7 - $3E1CB


UnknownCall_0x3E1D7:
	ld a, [$A68B]
	or a
	jr z, UnknownRJump_0x3E210
	ldh_a_n $80
	and $F0
	ld e, a
	ld hl, $4218
	ld a, [$A840]
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
	cp $FE
	jr z, UnknownRJump_0x3E210
	ld hl, $650E
	add hl, bc
	ld a, [hl]
	ld b, 0
	ld c, a
	ld hl, $6591
	add hl, bc
	ld a, [hl]
	and e
	jr z, UnknownRJump_0x3E210
	ld hl, $A848
	add hl, bc
	ld a, [hl]
	bit 7, a
	jr z, UnknownRJump_0x3E20D
	jr UnknownRJump_0x3E210

UnknownRJump_0x3E20D:
	ld a, 0
	ret

UnknownRJump_0x3E210:
	ld a, 255
	ret

UnknownData_0x3E213:
INCBIN "baserom.gb", $3E213, $3E277 - $3E213


UnknownCall_0x3E277:
	xor a
	ld hl, $A110
	ld d, 144

UnknownRJump_0x3E27D:
	ld [hli], a
	dec d
	jr nz, UnknownRJump_0x3E27D
	ld a, 4
	ld [$A782], a
	ld hl, $A6B5
	ld a, 16

UnknownRJump_0x3E28B:
	push af
	push hl
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld a, [hl]
	ld e, a
	cp $FF
	call nz, UnknownCall_0x3F75
	pop hl
	ld bc, $0003
	add hl, bc
	pop af
	dec a
	jr nz, UnknownRJump_0x3E28B
	ret

UnknownCall_0x3E2A2:
	xor a
	ld [$A781], a
	ld a, 255
	ld c, 48
	ld hl, $A6B7

UnknownRJump_0x3E2AD:
	ld [hli], a
	dec c
	jr nz, UnknownRJump_0x3E2AD
	ld a, 255
	ld c, 48
	ld hl, $A7D0

UnknownRJump_0x3E2B8:
	ld [hli], a
	dec c
	jr nz, UnknownRJump_0x3E2B8
	ld hl, $A6B5
	ld c, 16

UnknownRJump_0x3E2C1:
	ld a, [de]
	cp $FF
	jr z, UnknownRJump_0x3E2D1
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, UnknownRJump_0x3E2C1

UnknownRJump_0x3E2D1:
	push de
	call UnknownCall_0x3E277
	pop de
	inc de
	inc de
	inc de
	ld hl, $A7D0
	ld c, 16

UnknownRJump_0x3E2DE:
	ld a, [de]
	cp $FF
	jr z, UnknownRJump_0x3E2EE
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, UnknownRJump_0x3E2DE

UnknownRJump_0x3E2EE:
	ld a, [$A68B]
	cp $0D
	call c, UnknownCall_0x3F8E
	ret

UnknownCall_0x3E2F7:
	ld [$A786], a
	ld a, 2
	ld [$A79D], a
	ld a, 40

UnknownRJump_0x3E301:
	push af
	call UnknownCall_0x3E426
	call UnknownCall_0x3E367
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E367
	call UnknownCall_0x3E9EC
	pop af
	dec a
	jr nz, UnknownRJump_0x3E301
	ld d, 228
	ld e, 4

UnknownRJump_0x3E319:
	call UnknownCall_0x3E9EC
	ld a, d
	ld [sBGPalette], a
	push de
	ld hl, $6A53
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [sOAMPalette1], a
	ld [sOAMPalette2], a
	pop de
	ld b, 2

UnknownRJump_0x3E331:
	call UnknownCall_0x3E426
	call UnknownCall_0x3E367
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E367
	call UnknownCall_0x3E9EC
	dec b
	jr nz, UnknownRJump_0x3E331
	sla d
	sla d
	dec e
	jr nz, UnknownRJump_0x3E319
	ld hl, $9800
	ld bc, $0400
	ld d, 255

UnknownRJump_0x3E352:
	push hl
	ld hl, rSTAT

UnknownRJump_0x3E356:
	bit 1, [hl]
	jr nz, UnknownRJump_0x3E356
	pop hl
	ld a, d
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, UnknownRJump_0x3E352
	xor a
	ld [$A79D], a
	ret

UnknownCall_0x3E367:
	push af
	push bc
	push de
	push hl
	call UnknownCall_0x3C13E
	ld a, [$A68B]
	cp $01
	jr nz, UnknownRJump_0x3E37A
	call UnknownCall_0x3D8E6
	jr UnknownRJump_0x3E3B5

UnknownRJump_0x3E37A:
	cp $02
	jr nz, UnknownRJump_0x3E383
	call UnknownCall_0x3DA2D
	jr UnknownRJump_0x3E3B5

UnknownRJump_0x3E383:
	cp $03
	jr nz, UnknownRJump_0x3E38C
	call UnknownCall_0x3DB12
	jr UnknownRJump_0x3E3B5

UnknownRJump_0x3E38C:
	cp $04
	jr nz, UnknownRJump_0x3E395
	call UnknownCall_0x3DB40
	jr UnknownRJump_0x3E3B5

UnknownRJump_0x3E395:
	cp $05
	jr nz, UnknownRJump_0x3E39E
	call UnknownCall_0x3DDD3
	jr UnknownRJump_0x3E3B5

UnknownRJump_0x3E39E:
	cp $06
	jr nz, UnknownRJump_0x3E3A7
	call UnknownCall_0x3DEC7
	jr UnknownRJump_0x3E3B5

UnknownRJump_0x3E3A7:
	cp $07
	jr nz, UnknownRJump_0x3E3B0
	call UnknownCall_0x3DFE8
	jr UnknownRJump_0x3E3B5

UnknownRJump_0x3E3B0:
	cp $08
	call z, UnknownCall_0x3DD8C

UnknownRJump_0x3E3B5:
	pop hl
	pop de
	pop bc
	pop af
	ret

UnknownCall_0x3E3BA:
	ld [$A786], a
	ld a, 1
	ld [$A79D], a
	ld a, 146
	ld [$A878], a
	ld d, 228
	ld a, [$A68B]
	cp $07
	jp z, UnknownJump_0x3E4C1
	ld e, 1

UnknownRJump_0x3E3D3:
	call UnknownCall_0x3E9EC
	ld a, [sBGPalette]
	srl d
	rra
	srl d
	rra
	ld [sBGPalette], a
	push de
	ld hl, $6A53
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [sOAMPalette1], a
	ld [sOAMPalette2], a
	pop de
	ld b, 2

UnknownRJump_0x3E3F3:
	call UnknownCall_0x3E426
	call UnknownCall_0x3E367
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E367
	call UnknownCall_0x3E9EC
	dec b
	jr nz, UnknownRJump_0x3E3F3
	inc e
	ld a, e
	cp $05
	jr nz, UnknownRJump_0x3E3D3
	ld a, 40

UnknownRJump_0x3E40D:
	push af
	call UnknownCall_0x3E426
	call UnknownCall_0x3E367
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E367
	call UnknownCall_0x3E9EC
	pop af
	dec a
	jr nz, UnknownRJump_0x3E40D
	xor a
	ld [$A79D], a
	ret

UnknownCall_0x3E426:
	ld a, [$A786]
	cp $01
	jr z, UnknownRJump_0x3E49F
	cp $02
	jr z, UnknownRJump_0x3E47F
	cp $04
	jr z, UnknownRJump_0x3E43A
	cp $08
	jr z, UnknownRJump_0x3E45D

UnknownData_0x3E439:
INCBIN "baserom.gb", $3E439, $3E43A - $3E439


UnknownRJump_0x3E43A:
	push af
	push bc
	push de
	push hl
	ld a, [$A68C]
	inc a
	ld [$A68C], a
	and $0C
	rrca
	rrca
	add 8
	ld [$A695], a
	ld a, [$A843]
	dec a
	ld [$A843], a
	call UnknownCall_0x3C901
	pop hl
	pop de
	pop bc
	pop af
	ret

UnknownRJump_0x3E45D:
	push af
	push bc
	push de
	push hl
	ld a, [$A68C]
	inc a
	ld [$A68C], a
	and $06
	rrca
	add 12
	ld [$A695], a
	ld a, [$A843]
	inc a
	ld [$A843], a
	call UnknownCall_0x3C901
	pop hl
	pop de
	pop bc
	pop af
	ret

UnknownRJump_0x3E47F:
	push af
	push bc
	push de
	push hl
	ld a, [$A68C]
	inc a
	ld [$A68C], a
	and $06
	rrca
	ld [$A695], a
	ld a, [$A842]
	dec a
	ld [$A842], a
	call UnknownCall_0x3C901
	pop hl
	pop de
	pop bc
	pop af
	ret

UnknownRJump_0x3E49F:
	push af
	push bc
	push de
	push hl
	ld a, [$A68C]
	inc a
	ld [$A68C], a
	and $06
	rrca
	add 4
	ld [$A695], a
	ld a, [$A842]
	inc a
	ld [$A842], a
	call UnknownCall_0x3C901
	pop hl
	pop de
	pop bc
	pop af
	ret

UnknownJump_0x3E4C1:
	ld a, 225
	ld [sBGPalette], a
	ld a, 208
	ld [sOAMPalette1], a
	ld a, 57
	ld [sOAMPalette2], a
	ld a, 48

UnknownRJump_0x3E4D2:
	push af
	call UnknownCall_0x3E426
	call UnknownCall_0x3E367
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E367
	call UnknownCall_0x3E9EC
	pop af
	dec a
	jr nz, UnknownRJump_0x3E4D2
	xor a
	ld [$A79D], a
	ret

UnknownCall_0x3E4EB:
	ld a, [sCoinLow]
	ld l, a
	ld a, [sCoinHigh]
	ld h, a
	ld a, h
	and $0F
	add 96
	ld [$A6C0], a
	ld a, l
	swap a
	and $0F
	add 96
	ld [$A6C3], a
	ld a, l
	and $0F
	add 96
	ld [$A6C6], a
	ret

UnknownData_0x3E50E:
INCBIN "baserom.gb", $3E50E, $3E7BE - $3E50E


UnknownCall_0x3E7BE:
	ld hl, $88E0
	ld de, $A700
	ld c, 32
	call UnknownCall_0x3E7EB
	ld hl, $89E0
	ld de, $A720
	ld c, 32
	call UnknownCall_0x3E7EB
	ld hl, $8CE0
	ld de, $A740
	ld c, 32
	call UnknownCall_0x3E7EB
	ld hl, $8DE0
	ld de, $A760
	ld c, 32
	call UnknownCall_0x3E7EB
	ret

UnknownRJump_0x3E7EB:
UnknownCall_0x3E7EB:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, UnknownRJump_0x3E7EB
	ret

UnknownCall_0x3E7F2:
	ld a, [$A689]
	inc a
	ld [$A689], a
	ld e, a
	and $03
	jr nz, UnknownRJump_0x3E823
	ld a, [$A78A]
	dec a
	ld [$A78A], a
	ld a, e
	and $04
	jr nz, UnknownRJump_0x3E823
	ld a, [$A78B]
	dec a
	cp $18
	jr c, UnknownRJump_0x3E814
	ld a, 23

UnknownRJump_0x3E814:
	ld [$A78B], a
	ld a, e
	and $08
	jr nz, UnknownRJump_0x3E823
	ld a, [$A78C]
	dec a
	ld [$A78C], a

UnknownRJump_0x3E823:
	ld e, 255

UnknownRJump_0x3E825:
	ldh a, [rLY]
	cp $0F
	jr nc, UnknownRJump_0x3E832
	ld a, [$A78A]
	ldh [rSCX], a
	jr UnknownRJump_0x3E84B

UnknownRJump_0x3E832:
	cp $17
	jr nc, UnknownRJump_0x3E83D
	ld a, [$A78B]
	ldh [rSCX], a
	jr UnknownRJump_0x3E84B

UnknownRJump_0x3E83D:
	cp $1F
	jr nc, UnknownRJump_0x3E848
	ld a, [$A78C]
	ldh [rSCX], a
	jr UnknownRJump_0x3E84B

UnknownRJump_0x3E848:
	xor a
	ldh [rSCX], a

UnknownRJump_0x3E84B:
	nop
	nop
	nop
	nop
	dec e
	jr nz, UnknownRJump_0x3E825
	ret

UnknownCall_0x3E853:
	ld a, [$A689]
	inc a
	ld b, a
	ld [$A689], a
	and $07
	rlca
	ld e, a
	ld d, 0
	bit 0, b
	jp z, UnknownJump_0x3E929
	ld h, 136
	ld bc, $A700
	ld a, e
	or $F0
	ld l, a
	ld a, c
	add e
	ld c, a
	ld a, [bc]
	ld d, a
	set 4, c
	ld a, [bc]
	srl a
	rr d
	rla
	rrca
	ld [hl], a
	ld [bc], a
	res 4, c
	res 4, l
	ld a, d
	ld [hl], a
	ld [bc], a
	ld h, 137
	ld bc, $A720
	ld a, e
	or $F0
	ld l, a
	ld a, c
	add e
	ld c, a
	ld a, [bc]
	ld d, a
	set 4, c
	ld a, [bc]
	srl a
	rr d
	rla
	rrca
	ld [hl], a
	ld [bc], a
	res 4, c
	res 4, l
	ld a, d
	ld [hl], a
	ld [bc], a
	ld h, 140
	ld bc, $A740
	ld a, e
	or $F0
	ld l, a
	ld a, c
	add e
	ld c, a
	ld a, [bc]
	ld d, a
	set 4, c
	ld a, [bc]
	srl a
	rr d
	rla
	rrca
	ld [hl], a
	ld [bc], a
	res 4, c
	res 4, l
	ld a, d
	ld [hl], a
	ld [bc], a
	ld h, 141
	ld bc, $A760
	ld a, e
	or $F0
	ld l, a
	ld a, c
	add e
	ld c, a
	ld a, [bc]
	ld d, a
	set 4, c
	ld a, [bc]
	srl a
	rr d
	rla
	rrca
	ld [hl], a
	ld [bc], a
	res 4, c
	res 4, l
	ld a, d
	ld [hl], a
	ld [bc], a
	set 0, e
	ld h, 140
	ld bc, $A740
	ld a, e
	or $F0
	ld l, a
	ld a, c
	add e
	ld c, a
	ld a, [bc]
	ld d, a
	set 4, c
	ld a, [bc]
	srl a
	rr d
	rla
	rrca
	ld [hl], a
	ld [bc], a
	res 4, c
	res 4, l
	ld a, d
	ld [hl], a
	ld [bc], a
	ld h, 141
	ld bc, $A760
	ld a, e
	or $F0
	ld l, a
	ld a, c
	add e
	ld c, a
	ld a, [bc]
	ld d, a
	set 4, c
	ld a, [bc]
	srl a
	rr d
	rla
	rrca
	ld [hl], a
	ld [bc], a
	res 4, c
	res 4, l
	ld a, d
	ld [hl], a
	ld [bc], a
	ret

UnknownJump_0x3E929:
	ld h, 136
	ld bc, $A700
	ld a, e
	or $F0
	ld l, a
	ld a, c
	add e
	ld c, a
	ld a, [bc]
	ld d, a
	set 4, c
	ld a, [bc]
	sla a
	rl d
	rra
	rlca
	ld [hl], a
	ld [bc], a
	res 4, c
	res 4, l
	ld a, d
	ld [hl], a
	ld [bc], a
	ld h, 137
	ld bc, $A720
	ld a, e
	or $F0
	ld l, a
	ld a, c
	add e
	ld c, a
	ld a, [bc]
	ld d, a
	set 4, c
	ld a, [bc]
	sla a
	rl d
	rra
	rlca
	ld [hl], a
	ld [bc], a
	res 4, c
	res 4, l
	ld a, d
	ld [hl], a
	ld [bc], a
	ld h, 140
	ld bc, $A740
	ld a, e
	or $F0
	ld l, a
	ld a, c
	add e
	ld c, a
	ld a, [bc]
	ld d, a
	set 4, c
	ld a, [bc]
	sla a
	rl d
	rra
	rlca
	ld [hl], a
	ld [bc], a
	res 4, c
	res 4, l
	ld a, d
	ld [hl], a
	ld [bc], a
	ld h, 141
	ld bc, $A760
	ld a, e
	or $F0
	ld l, a
	ld a, c
	add e
	ld c, a
	ld a, [bc]
	ld d, a
	set 4, c
	ld a, [bc]
	sla a
	rl d
	rra
	rlca
	ld [hl], a
	ld [bc], a
	res 4, c
	res 4, l
	ld a, d
	ld [hl], a
	ld [bc], a
	set 0, e
	ld h, 140
	ld bc, $A740
	ld a, e
	or $F0
	ld l, a
	ld a, c
	add e
	ld c, a
	ld a, [bc]
	ld d, a
	set 4, c
	ld a, [bc]
	sla a
	rl d
	rra
	rlca
	ld [hl], a
	ld [bc], a
	res 4, c
	res 4, l
	ld a, d
	ld [hl], a
	ld [bc], a
	ld h, 141
	ld bc, $A760
	ld a, e
	or $F0
	ld l, a
	ld a, c
	add e
	ld c, a
	ld a, [bc]
	ld d, a
	set 4, c
	ld a, [bc]
	sla a
	rl d
	rra
	rlca
	ld [hl], a
	ld [bc], a
	res 4, c
	res 4, l
	ld a, d
	ld [hl], a
	ld [bc], a
	ret

UnknownCall_0x3E9EC:
	ei
	xor a
	ld [$A785], a

UnknownRJump_0x3E9F1:
	ld a, [$A785]
	or a
	jr z, UnknownRJump_0x3E9F1
	call UnknownCall_0x3EAD7
	ret

UnknownCall_0x3E9FB:
	ld d, 228
	ld e, 4

UnknownRJump_0x3E9FF:
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E9EC
	ld a, d
	ld [sBGPalette], a
	push de
	ld hl, $6A53
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [sOAMPalette1], a
	ld [sOAMPalette2], a
	pop de
	sla d
	sla d
	dec e
	jr nz, UnknownRJump_0x3E9FF
	ld hl, $9800
	ld bc, $0400
	ld d, 255

UnknownRJump_0x3EA45:
	ldh a, [rSTAT]
	and $03
	jr nz, UnknownRJump_0x3EA45
	ld a, d
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, UnknownRJump_0x3EA45
	ret

UnknownData_0x3EA53:
INCBIN "baserom.gb", $3EA53, $3EA9A - $3EA53


UnknownCall_0x3EA9A:
	ld a, 6
	ld [$A468], a
	ld a, 0
	ld [$A878], a
	ld d, 228
	ld e, 1

UnknownRJump_0x3EAA8:
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E9EC
	call UnknownCall_0x3E9EC
	ld a, [sBGPalette]
	srl d
	rra
	srl d
	rra
	ld [sBGPalette], a
	push de
	ld hl, $6A5A
	ld d, 0
	sla e
	add hl, de
	ld a, [hli]
	ld [sOAMPalette1], a
	ld a, [hl]
	ld [sOAMPalette2], a
	pop de
	inc e
	ld a, e
	cp $05
	jr nz, UnknownRJump_0x3EAA8
	ei
	ret

UnknownCall_0x3EAD7:
	push af
	push bc
	push de
	push hl
	di
	call UnknownCall_0x2AAA
	ei
	pop hl
	pop de
	pop bc
	pop af
	ret

UnknownRJump_0x3EAE5:
UnknownCall_0x3EAE5:
	ld a, 13
	call UnknownCall_0x3E22
	inc bc
	dec d
	jr nz, UnknownRJump_0x3EAE5
	ld d, 32
	ld a, c
	add d
	ld c, a
	ld a, b
	adc 0
	and $0F
	or $B0
	ld b, a
	dec e
	jr nz, UnknownRJump_0x3EAE5
	ret

UnknownJump_0x3EAFF:
	ld a, [$A68B]
	or a
	call z, UnknownCall_0x3E853
	ld a, [$A68B]
	cp $07
	call z, UnknownCall_0x3E7F2
	ld a, [$A68B]
	cp $0D
	jr nc, UnknownRJump_0x3EB1A
	cp $09
	call nc, UnknownCall_0x3EBD5

UnknownRJump_0x3EB1A:
	ld a, [$A68B]
	cp $01
	call z, UnknownCall_0x3EC7D
	ld a, [$A68B]
	cp $02
	call z, UnknownCall_0x3ECF5
	ld a, [$A68B]
	cp $05
	call z, UnknownCall_0x3ED35
	ld a, [$A68B]
	or a
	jp nz, UnknownJump_0x01C5
	ldh_a_n $97
	and $03
	cp $01
	jr nz, UnknownRJump_0x3EB48
	call UnknownCall_0x3EBAE
	jp UnknownJump_0x01C5

UnknownRJump_0x3EB48:
	cp $02
	jr nz, UnknownRJump_0x3EB52
	call UnknownCall_0x3EB94
	jp UnknownJump_0x01C5

UnknownRJump_0x3EB52:
	cp $03
	jr nz, UnknownRJump_0x3EB5C
	call UnknownCall_0x3EB7B
	jp UnknownJump_0x01C5

UnknownRJump_0x3EB5C:
	call UnknownCall_0x3EB62
	jp UnknownJump_0x01C5

UnknownCall_0x3EB62:
	ld hl, $A600
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld d, 20

UnknownRJump_0x3EB6B:
	ld a, [hli]
	ld [bc], a
	ld a, c
	inc a
	and $1F
	ld e, a
	ld a, c
	and $E0
	or e
	ld c, a
	dec d
	jr nz, UnknownRJump_0x3EB6B
	ret

UnknownCall_0x3EB7B:
	ld hl, $A620
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld d, 20

UnknownRJump_0x3EB84:
	ld a, [hli]
	ld [bc], a
	ld a, c
	inc a
	and $1F
	ld e, a
	ld a, c
	and $E0
	or e
	ld c, a
	dec d
	jr nz, UnknownRJump_0x3EB84
	ret

UnknownCall_0x3EB94:
	ld hl, $A640
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld d, 20
	ld e, 32

UnknownRJump_0x3EB9F:
	ld a, [hli]
	ld [bc], a
	ld a, c
	add e
	ld c, a
	ld a, b
	adc 0
	res 2, a
	ld b, a
	dec d
	jr nz, UnknownRJump_0x3EB9F
	ret

UnknownCall_0x3EBAE:
	ld hl, $A660
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld d, 20
	ld e, 32

UnknownRJump_0x3EBB9:
	ld a, [hli]
	ld [bc], a
	ld a, c
	add e
	ld c, a
	ld a, b
	adc 0
	res 2, a
	ld b, a
	dec d
	jr nz, UnknownRJump_0x3EBB9
	ret

UnknownCall_0x3EBC8:
	call UnknownCall_0x3EB62
	call UnknownCall_0x3EB7B
	call UnknownCall_0x3EB94
	call UnknownCall_0x3EBAE
	ret

UnknownCall_0x3EBD5:
	ld a, [$A840]
	sub 110
	ld d, a
	add a
	ld b, 0
	ld c, a
	ld hl, $6C75
	add hl, bc
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, [$A7A5]
	and $7C
	srl a
	srl a
	cp $1E
	jr c, UnknownRJump_0x3EBFD
	ld a, [$A7A5]
	and $77
	ld [$A7A5], a
	ld a, 29

UnknownRJump_0x3EBFD:
	ld d, 0
	ld e, a
	ld h, d
	ld l, e
	add hl, de
	add hl, de
	sla l
	rl h
	add hl, bc
	ld d, 9
	ld bc, $988A

UnknownRJump_0x3EC0E:
	call UnknownCall_0x3E51
	push hl
	ld hl, $001B
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	dec d
	jr nz, UnknownRJump_0x3EC0E
	ld bc, $9825
	ld a, [sCoinLow]
	ld d, a
	and $0F
	add 128
	ld [bc], a
	dec bc
	ld a, d
	swap a
	and $0F
	add 128
	ld [bc], a
	dec bc
	ld a, [sCoinHigh]
	and $0F
	add 128
	ld [bc], a
	ld bc, $9864
	ld a, [$A22C]
	ld d, a
	and $0F
	add 128
	ld [bc], a
	dec bc
	ld a, d
	swap a
	and $0F
	add 128
	ld [bc], a
	ld a, [$A7AA]
	bit 7, a
	ret z
	and $0F
	ld hl, $988C
	ld b, 0
	ld c, a
	swap c
	sla c
	rl b
	add hl, bc
	ld a, 212
	ld [hli], a
	ld a, 213
	ld [hl], a
	ld bc, $001F
	add hl, bc
	ld a, 216
	ld [hli], a
	ld a, 217
	ld [hl], a
	ret

UnknownData_0x3EC75:
INCBIN "baserom.gb", $3EC75, $3EC7D - $3EC75


UnknownCall_0x3EC7D:
	ld a, [$A86F]
	bit 7, a
	ret z
	ld a, [$A7BE]
	inc a
	cp $0E
	jr c, UnknownRJump_0x3EC8C
	xor a

UnknownRJump_0x3EC8C:
	ld [$A7BE], a
	or a
	ret nz
	ld a, [$A7BF]
	inc a
	ld [$A7BF], a
	and $3F
	ld d, 0
	ld e, a
	ld hl, $6CB5
	add hl, de
	ld a, [hl]
	ld e, 0
	srl a
	rr e
	srl a
	rr e
	ld d, a
	ld hl, $5300
	add hl, de
	call UnknownCall_0x3EA4
	ret

UnknownData_0x3ECB5:
INCBIN "baserom.gb", $3ECB5, $3ECF5 - $3ECB5


UnknownCall_0x3ECF5:
	ld a, [$A86C]
	bit 7, a
	ret z
	ld a, [$A7BE]
	inc a
	cp $0E
	jr c, UnknownRJump_0x3ED04
	xor a

UnknownRJump_0x3ED04:
	ld [$A7BE], a
	or a
	ret nz
	ld a, [$A7BF]
	inc a
	ld [$A7BF], a
	and $07
	ld d, 0
	ld e, a
	ld hl, $6D2D
	add hl, de
	ld a, [hl]
	ld e, 0
	srl a
	rr e
	srl a
	rr e
	ld d, a
	ld hl, $5800
	add hl, de
	call UnknownCall_0x3ECB
	ret

UnknownData_0x3ED2D:
INCBIN "baserom.gb", $3ED2D, $3ED35 - $3ED2D


UnknownCall_0x3ED35:
	ld a, [$A69A]
	ld e, a
	and $0F
	ret z
	ld a, e
	and $30
	sla a
	ld hl, $5C00
	ld d, 0
	ld e, a
	add hl, de
	call UnknownCall_0x3EF2
	ret

UnknownCall_0x3ED4C:
	di
	ld hl, $A680
	ldh_a_n $B9
	ld [hli], a
	ldh_a_n $BA
	ld [hl], a
	ld hl, $A682
	ldh_a_n $B7
	ld [hli], a
	ldh_a_n $B8
	ld [hl], a
	ld a, [$A680]
	srl a
	srl a
	srl a
	ld b, a
	ld [$A600], a
	ld [$A620], a
	dec a
	and $1F
	ld [$A640], a
	ld a, b
	add 20
	and $1F
	ld [$A660], a
	ld a, [$A682]
	srl a
	srl a
	srl a
	ld b, a
	dec a
	and $1F
	ld [$A641], a
	ld [$A661], a
	ld [$A601], a
	ld a, b
	add 18
	and $1F
	ld [$A621], a
	ld hl, $A600
	call UnknownCall_0x3EE8C
	ld hl, $A620
	call UnknownCall_0x3EE8C
	ld hl, $A640
	call UnknownCall_0x3EE8C
	ld hl, $A660
	call UnknownCall_0x3EE8C
	ld a, [$A680]
	ld l, a
	ld a, [$A681]
	ld h, a
	srl h
	rr l
	srl l
	srl l
	ld h, 0
	ld a, [$A682]
	and $F8
	ld c, a
	ld a, [$A683]
	ld b, a
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $FFC0
	add hl, de
	ld a, h
	and $0F
	or $B0
	ld h, a
	ld b, 20
	push de
	ld de, $A602

UnknownRJump_0x3EDF2:
	ld a, 13
	call UnknownCall_0x3E34
	inc de
	ld a, l
	inc a
	and $3F
	ld c, a
	ld a, l
	and $C0
	or c
	ld l, a
	dec b
	jr nz, UnknownRJump_0x3EDF2
	pop de
	ld hl, $0480
	add hl, de
	ld a, h
	and $0F
	or $B0
	ld h, a
	ld b, 20
	push de
	ld de, $A622

UnknownRJump_0x3EE16:
	ld a, 13
	call UnknownCall_0x3E34
	inc de
	ld a, l
	inc a
	and $3F
	ld c, a
	ld a, l
	and $C0
	or c
	ld l, a
	dec b
	jr nz, UnknownRJump_0x3EE16
	pop de
	ld hl, $FFC0
	add hl, de
	ld a, h
	and $0F
	or $B0
	ld h, a
	ld a, l
	dec a
	and $3F
	ld b, a
	ld a, l
	and $C0
	or b
	ld l, a
	ld b, 20
	push de
	ld de, $A642

UnknownRJump_0x3EE44:
	ld a, 13
	call UnknownCall_0x3E34
	inc de
	ld a, l
	add 64
	ld l, a
	ld a, h
	adc 0
	and $0F
	or $B0
	ld h, a
	dec b
	jr nz, UnknownRJump_0x3EE44
	pop de
	ld hl, $FFC0
	add hl, de
	ld a, h
	and $0F
	or $B0
	ld h, a
	ld a, l
	add 20
	and $3F
	ld b, a
	ld a, l
	and $C0
	or b
	ld l, a
	ld b, 20
	push de
	ld de, $A662

UnknownRJump_0x3EE75:
	ld a, 13
	call UnknownCall_0x3E34
	inc de
	ld a, l
	add 64
	ld l, a
	ld a, h
	adc 0
	and $0F
	or $B0
	ld h, a
	dec b
	jr nz, UnknownRJump_0x3EE75
	pop de
	ret

UnknownCall_0x3EE8C:
	ld a, [hli]
	ld b, [hl]
	ld c, 0
	srl b
	rr c
	srl b
	rr c
	srl b
	rr c
	or c
	ld c, a
	ld a, 152
	or b
	ld [hld], a
	ld [hl], c
	ret

UnknownCall_0x3EEA4:
	ld a, [$A840]
	ld hl, $5EE6
	ld d, 0
	sla a
	rl d
	sla a
	rl d
	sla a
	rl d
	ld e, a
	add hl, de
	ld a, 24
	call UnknownCall_0x3E7B
	inc hl
	ldh_n_a $BA
	ld a, 24
	call UnknownCall_0x3E7B
	inc hl
	ldh_n_a $B9
	ld a, 24
	call UnknownCall_0x3E7B
	inc hl
	ldh_n_a $B8
	ld a, 24
	call UnknownCall_0x3E7B
	inc hl
	ldh_n_a $B7
	ld a, 24
	call UnknownCall_0x3E7B
	inc hl
	ld [$A842], a
	ld a, 24
	call UnknownCall_0x3E7B
	ld [$A843], a
	ret

UnknownCall_0x3EEF0:
	ld a, [$A840]
	ld d, 0
	ld e, a
	ld hl, $650E
	add hl, de
	ld a, [hl]
	cp $FE
	ret nc
	ld d, 0
	ld e, a
	ld hl, $A848
	add hl, de
	ld a, [$A224]
	or a
	jr nz, UnknownRJump_0x3EF19
	ld a, [$A2B4]
	or a
	jr nz, UnknownRJump_0x3EF25
	set 7, [hl]
	res 3, [hl]
	call UnknownCall_0x2934
	ret

UnknownRJump_0x3EF19:
	ld a, [$A2A0]
	cp $FF
	ret nz
	set 3, [hl]
	call UnknownCall_0x2934
	ret

UnknownRJump_0x3EF25:
	res 3, [hl]
	call UnknownCall_0x2934
	ret

UnknownJump_0x3EF2B:
UnknownCall_0x3EF2B:
	ld a, 228
	ld [sBGPalette], a
	ld a, 208
	ld [sOAMPalette1], a
	ld a, 57
	ld [sOAMPalette2], a
	ld a, [$A24F]
	or a
	jr z, UnknownRJump_0x3EF56
	ld a, [$A840]
	bit 0, a
	jr nz, UnknownRJump_0x3EF4C
	call UnknownCall_0x3F4B1
	jr UnknownRJump_0x3EF4F

UnknownRJump_0x3EF4C:
	call UnknownCall_0x3F5A4

UnknownRJump_0x3EF4F:
	ld a, 12
	ldh_n_a $9B
	ei
	ret

UnknownRJump_0x3EF56:
	ld a, [$A2B4]
	or a
	jr z, UnknownRJump_0x3EFB2
	ld a, [$A224]
	or a
	jr nz, UnknownRJump_0x3EFB2
	ld a, [$A840]
	cp $48
	jr nz, UnknownRJump_0x3EF70
	ld a, 71
	ld [$A840], a
	jr UnknownRJump_0x3EFB2

UnknownRJump_0x3EF70:
	ld a, [$A840]
	cp $1A
	jr z, UnknownRJump_0x3EF81
	cp $05
	jr z, UnknownRJump_0x3EF81
	cp $12
	jr z, UnknownRJump_0x3EF81
	jr UnknownRJump_0x3EF88

UnknownRJump_0x3EF81:
	ld a, 105
	ld [$A840], a
	jr UnknownRJump_0x3EFB2

UnknownRJump_0x3EF88:
	ld a, [$A840]
	cp $29
	jr nz, UnknownRJump_0x3EF96
	ld a, 44
	ld [$A840], a
	jr UnknownRJump_0x3EFB2

UnknownRJump_0x3EF96:
	ld a, [$A840]
	cp $2A
	jr nz, UnknownRJump_0x3EFA4
	ld a, 47
	ld [$A840], a
	jr UnknownRJump_0x3EFB2

UnknownRJump_0x3EFA4:
	ld a, [$A840]
	cp $3C
	jr nz, UnknownRJump_0x3EFB2
	ld a, 64
	ld [$A840], a
	jr UnknownRJump_0x3EFB2

UnknownRJump_0x3EFB2:
	call UnknownCall_0x3EEF0
	ld a, BANK(GFX_OW_Overworld) ;prepare bank switch
	ld bc, $0200
	ld hl, GFX_OW_Overworld
	ld de, $8000
	di
	call FarCopyMem
	call UnknownCall_0x3EEA4
	ld a, 8
	ld [$A844], a
	xor a
	ld [$A68B], a
	ld a, [$A224]
	or a
	jr nz, UnknownRJump_0x3F003
	ld a, [$A840]
	ld hl, $650E
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	cp $FE
	jr nc, UnknownRJump_0x3F003
	cp $05
	jp z, UnknownJump_0x3C6BD
	cp $09
	jp z, UnknownJump_0x3C6D7
	cp $0E
	jp z, UnknownJump_0x3C724
	cp $11
	jp z, UnknownJump_0x3C736
	cp $17
	jp z, UnknownJump_0x3C750
	cp $1D
	jp z, UnknownJump_0x3C77C

UnknownRJump_0x3F003:
	ld a, [$A840]
	cp $1E
	jr nc, UnknownRJump_0x3F04D
	cp $05
	jr z, UnknownRJump_0x3F014
	cp $1A
	jr z, UnknownRJump_0x3F014
	jr UnknownRJump_0x3F024

UnknownRJump_0x3F014:
	ld a, [$A224]
	or a
	jr nz, UnknownRJump_0x3F03D
	ld a, 63
	ld [$A840], a
	call UnknownCall_0x3EEA4
	jr UnknownRJump_0x3F07E

UnknownRJump_0x3F024:
	or a
	jr nz, UnknownRJump_0x3F03D
	ld a, [$A224]
	or a
	jr nz, UnknownRJump_0x3F03D
	ld a, [$A848]
	set 7, a
	ld [$A848], a
	ld a, 20
	ld [$A840], a
	call UnknownCall_0x3EEA4

UnknownJump_0x3F03D:
UnknownRJump_0x3F03D:
	call UnknownCall_0x3F156
	call UnknownCall_0x2934
	ld a, 12
	ldh_n_a $9B
	call UnknownCall_0x3EA9A
	ei
	ret

UnknownRJump_0x3F04D:
	cp $28
	jr nc, UnknownRJump_0x3F05C
	call UnknownCall_0x3D0FF
	ld a, 2
	ld [$A68B], a
	jp UnknownJump_0x3F147

UnknownRJump_0x3F05C:
	cp $32
	jr nc, UnknownRJump_0x3F06B

UnknownJump_0x3F060:
	call UnknownCall_0x3D208
	ld a, 1
	ld [$A68B], a
	jp UnknownJump_0x3F147

UnknownRJump_0x3F06B:
	cp $3C
	jr nc, UnknownRJump_0x3F07A

UnknownJump_0x3F06F:
	call UnknownCall_0x3D371
	ld a, 3
	ld [$A68B], a
	jp UnknownJump_0x3F147

UnknownRJump_0x3F07A:
	cp $46
	jr nc, UnknownRJump_0x3F089

UnknownRJump_0x3F07E:
	call UnknownCall_0x3D49F
	ld a, 4
	ld [$A68B], a
	jp UnknownJump_0x3F147

UnknownRJump_0x3F089:
	cp $50
	jr nc, UnknownRJump_0x3F098
	call UnknownCall_0x3D61F
	ld a, 5
	ld [$A68B], a
	jp UnknownJump_0x3F147

UnknownRJump_0x3F098:
	cp $5A
	jr nc, UnknownRJump_0x3F0A7
	call UnknownCall_0x3D79A
	ld a, 6
	ld [$A68B], a
	jp UnknownJump_0x3F147

UnknownRJump_0x3F0A7:
	cp $64
	jr nc, UnknownRJump_0x3F0C2
	cp $5B
	jr nz, UnknownRJump_0x3F0B7
	ld a, 92
	ld [$A840], a
	call UnknownCall_0x3EEA4

UnknownRJump_0x3F0B7:
	call UnknownCall_0x3D6EB
	ld a, 7
	ld [$A68B], a
	jp UnknownJump_0x3F147

UnknownRJump_0x3F0C2:
	cp $6E
	jr nc, UnknownRJump_0x3F0F6
	cp $66
	jr nz, UnknownRJump_0x3F0E4
	ld a, 104
	ld [$A840], a
	call UnknownCall_0x3EEA4
	ld a, [$A224]
	or a
	jp nz, UnknownJump_0x3F03D
	ld a, [$A86D]
	set 7, a
	ld [$A86D], a
	jp UnknownJump_0x3F03D

UnknownRJump_0x3F0E4:
	cp $6A
	jp z, UnknownJump_0x3F06F
	cp $6B
	jp z, UnknownJump_0x3F06F
	cp $6C
	jp z, UnknownJump_0x3F06F
	jp UnknownJump_0x3F03D

UnknownRJump_0x3F0F6:
	cp $78
	jr nc, UnknownRJump_0x3F104
	call UnknownCall_0x3D880
	ld a, 8
	ld [$A68B], a
	jr UnknownRJump_0x3F147

UnknownRJump_0x3F104:
	cp $78
	jp nz, UnknownJump_0x3F123
	ld a, 46
	ld [$A840], a
	call UnknownCall_0x3EEA4
	ld a, [$A224]
	or a
	jp nz, UnknownJump_0x3F060
	ld a, [$A86E]
	set 7, a
	ld [$A86E], a
	jp UnknownJump_0x3F060

UnknownJump_0x3F123:
	cp $7A
	jp nz, UnknownJump_0x3F142
	ld a, 49
	ld [$A840], a
	call UnknownCall_0x3EEA4
	ld a, [$A224]
	or a
	jp nz, UnknownJump_0x3F060
	ld a, [$A86F]
	set 7, a
	ld [$A86F], a
	jp UnknownJump_0x3F060

UnknownJump_0x3F142:
UnknownData_0x3F142:
INCBIN "baserom.gb", $3F142, $3F147 - $3F142


UnknownJump_0x3F147:
UnknownRJump_0x3F147:
	ld a, 146
	ld [$A878], a
	ei
	call UnknownCall_0x2934
	ld a, 12
	ldh_n_a $9B
	ret

UnknownCall_0x3F156:
	di
	xor a
	ld [sBGPalette], a
	call DisableVBlank
	ld a, 255
	ld [$A468], a
	call UnknownCall_0x2AAA
	di
	ldh_a_n $B7
	ld [sScrollY], a
	ldh_a_n $B9
	ld [sScrollX], a
	ld a, 0
	ld [$A690], a
	ld [$A789], a
	ld [$A68B], a
	ld hl, $7800
	ld bc, $B800
	ld de, $2020
	call UnknownCall_0x3EAE5
	ld hl, $7C00
	ld bc, $B820
	ld de, $2020
	call UnknownCall_0x3EAE5
	ld hl, $7000
	ld bc, $B000
	ld de, $2020
	call UnknownCall_0x3EAE5
	ld hl, $7400
	ld bc, $B020
	ld de, $2020
	call UnknownCall_0x3EAE5
	call UnknownCall_0x3ED4C
	call UnknownCall_0x3E46
	ld a, [$A840]
	cp $17
	jr z, UnknownRJump_0x3F1C2
	cp $18
	jr z, UnknownRJump_0x3F1C2
	call UnknownCall_0x3C901

UnknownRJump_0x3F1C2:
	ld a, BANK(GFX_OW_Overworld) ;prepare bank switch
	ld bc, $1800
	ld hl, GFX_OW_Overworld
	ld de, $8000
	di
	call FarCopyMem
	call UnknownCall_0x3E7BE
	call UnknownCall_0x3F275
	call UnknownCall_0x3EBC8
	call UnknownCall_0x3F203
	ld a, 136
	ldh [rWY], a
	ld a, 80
	ldh [rWX], a
	ld a, 227
	ldh_n_a $40
	call UnknownCall_0x3CBE7
	call UnknownCall_0x3CE43
	xor a
	ld [$A7A0], a
	ld [$A7A9], a
	ld a, 0
	ld [$A878], a
	ld a, 6
	ld [$A468], a
	ei
	ret

UnknownCall_0x3F203:
	ld hl, $A110
	ld de, $7251
	ld c, 36

UnknownRJump_0x3F20B:
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr nz, UnknownRJump_0x3F20B
	ld a, [$A22C]
	ld b, a
	and $F0
	swap a
	or $70
	ld [$A11A], a
	ld a, b
	and $0F
	or $70
	ld [$A11E], a
	ld a, [sCoinHigh]
	and $0F
	or $70
	ld [$A12A], a
	ld a, [sCoinLow]
	ld b, a
	and $F0
	swap a
	or $70
	ld [$A12E], a
	ld a, b
	and $0F
	or $70
	ld [$A132], a
	ld a, 225
	ld c, 64
	ld hl, $9C00

UnknownRJump_0x3F24C:
	ld [hli], a
	dec c
	jr nz, UnknownRJump_0x3F24C
	ret

UnknownData_0x3F251:
INCBIN "baserom.gb", $3F251, $3F275 - $3F251


UnknownCall_0x3F275:
	ld a, [$A683]
	ld h, a
	ld a, [$A682]
	and $F8
	ld l, a
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	ld a, [$A681]
	ld b, a
	ld a, [$A680]
	srl b
	rr a
	srl a
	srl a
	or l
	ld l, a
	ld a, h
	or $B0
	ld h, a
	ld a, [$A682]
	and $F8
	ld c, a
	ld b, 0
	sla c
	rl b
	sla c
	rl b
	ld a, [$A680]
	srl a
	srl a
	srl a
	or c
	ld c, a
	ld a, 152
	or b
	ld b, a
	ld d, 32

UnknownRJump_0x3F2C1:
	ld e, 0
	push bc

UnknownRJump_0x3F2C4:
	push hl
	ld a, l
	add e
	and $3F
	push af
	ld a, l
	and $C0
	ld l, a
	pop af
	or l
	ld l, a
	ld a, 13
	call UnknownCall_0x3E10
	pop hl
	ld a, c
	inc a
	and $1F
	push af
	ld a, c
	and $E0
	ld c, a
	pop af
	or c
	ld c, a
	inc e
	ld a, e
	cp $20
	jr nz, UnknownRJump_0x3F2C4
	ld bc, $0040
	add hl, bc
	ld a, h
	and $0F
	or $B0
	ld h, a
	pop bc
	push hl
	ld h, b
	ld l, c
	ld bc, $0020
	add hl, bc
	ld a, h
	and $03
	or $98
	ld b, a
	ld c, l
	pop hl
	dec d
	jr nz, UnknownRJump_0x3F2C1
	ret

UnknownCall_0x3F307:
	ld a, 255
	ld [$A468], a
	call UnknownCall_0x2AAA
	call DisableVBlank
	ld a, 25 ;prepare bank switch
	ld bc, $1000
	ld hl, $4000
	ld de, $8800
	call FarCopyMem
	call UnknownCall_0x3F58
	xor a
	ld [sScrollX], a
	ld [sScrollY], a
	ld [$A690], a
	ldh_n_a $81
	ld [$A69A], a
	ld [$A795], a
	ld [$A796], a
	ld [$A797], a
	ld [$A798], a
	ld [$A799], a
	ld [$A79A], a
	ld [$A79B], a
	ld [$A79C], a
	ld [$A7A7], a
	ld [$A7A8], a
	ld a, 4
	ld [$A7A6], a
	call UnknownCall_0x3E46
	ret

UnknownCall_0x3F35A:
	ld a, 40
	ldh_n_a $C5
	ld a, 156
	ldh_n_a $C4
	call UnknownCall_0x3F37F
	add 16
	ldh_n_a $C6
	ld a, 0
	ldh_n_a $C7
	ld a, 0
	ldh_n_a $BB
	call UnknownCall_0x3F30
	ld a, 5
	ld [$A460], a
	ret

UnknownCall_0x3F37F:
	ld a, [sCurPowerup]
	ld d, 0
	ld e, a
	ld hl, $738B
	add hl, de
	ld a, [hl]
	ret

UnknownData_0x3F38B:
INCBIN "baserom.gb", $3F38B, $3F38F - $3F38B


UnknownCall_0x3F38F:
	ld a, [sCoinLow]
	sub l
	daa
	ld a, [sCoinHigh]
	sbc h
	daa
	jr c, UnknownRJump_0x3F3B1
	ld a, [sCoinLow]
	sub l
	daa
	ld [sCoinLow], a
	ld a, [sCoinHigh]
	sbc h
	daa
	ld [sCoinHigh], a
	call UnknownCall_0x2934
	ld a, 0
	ret

UnknownRJump_0x3F3B1:
	ld a, 19
	ld [$A460], a
	ld a, 1
	ret

UnknownJump_0x3F3B9:
	ld hl, $0999
	call UnknownCall_0x3F38F
	or a
	jp nz, UnknownJump_0x3C7D9
	call UnknownCall_0x3F307
	ld a, 16 ;prepare bank switch
	ld bc, $0400
	ld hl, $7240
	ld de, $9800
	call FarCopyMem
	ld a, 9
	ld [$A68B], a
	ld de, $66D4
	call UnknownCall_0x3E2A2
	call UnknownCall_0x3F35A
	ld a, 225
	ld [sBGPalette], a
	ld a, 195
	ldh_n_a $40
	call UnknownCall_0x3F495
	ret

UnknownJump_0x3F3F0:
	ld hl, $0200
	call UnknownCall_0x3F38F
	or a
	jp nz, UnknownJump_0x3C7D9
	call UnknownCall_0x3F307
	ld a, 16 ;prepare bank switch
	ld bc, $0400
	ld hl, $7480
	ld de, $9800
	call FarCopyMem
	ld a, 10
	ld [$A68B], a
	ld de, $671C
	call UnknownCall_0x3E2A2
	call UnknownCall_0x3F35A
	ld a, 225
	ld [sBGPalette], a
	ld a, 195
	ldh_n_a $40
	call UnknownCall_0x3F495
	ret

UnknownJump_0x3F427:
	ld hl, $0050
	call UnknownCall_0x3F38F
	or a
	jp nz, UnknownJump_0x3C7D9
	call UnknownCall_0x3F307
	ld a, 16 ;prepare bank switch
	ld bc, $0400
	ld hl, $76C0
	ld de, $9800
	call FarCopyMem
	ld a, 11
	ld [$A68B], a
	ld de, $6704
	call UnknownCall_0x3E2A2
	call UnknownCall_0x3F35A
	ld a, 225
	ld [sBGPalette], a
	ld a, 195
	ldh_n_a $40
	call UnknownCall_0x3F495
	ret

UnknownJump_0x3F45E:
	ld hl, $0030
	call UnknownCall_0x3F38F
	or a
	jp nz, UnknownJump_0x3C7D9
	call UnknownCall_0x3F307
	ld a, 16 ;prepare bank switch
	ld bc, $0400
	ld hl, $7900
	ld de, $9800
	call FarCopyMem
	ld a, 12
	ld [$A68B], a
	ld de, $66EC
	call UnknownCall_0x3E2A2
	call UnknownCall_0x3F35A
	ld a, 225
	ld [sBGPalette], a
	ld a, 195
	ldh_n_a $40
	call UnknownCall_0x3F495
	ret

UnknownCall_0x3F495:
	ld a, 21
	ld [$A468], a
	ld a, 5
	ld [$A460], a
	ret

UnknownCall_0x3F4A0:
	ld a, 24
	ld hl, $4A81
	call UnknownCall_0x3E00
	ld a, [$A7A6]
	cp $03
	call z, UnknownCall_0x3D880
	ret

UnknownCall_0x3F4B1:
	ld a, 255
	ld [$A468], a
	call UnknownCall_0x2AAA
	call DisableVBlank
	ld a, 25 ;prepare bank switch
	ld bc, $1000
	ld hl, $5000
	ld de, $8800
	call FarCopyMem
	call UnknownCall_0x3F58
	xor a
	ld [sScrollX], a
	ld [sScrollY], a
	ld [$A690], a
	ldh_n_a $81
	ld [$A69A], a
	ld [$A795], a
	ld [$A796], a
	ld [$A797], a
	ld [$A798], a
	ld [$A799], a
	ld [$A79A], a
	ld [$A79B], a
	ld [$A79C], a
	ld [$A7A6], a
	ld [$A7A7], a
	ld a, [sTimerHigh]
	and $0F
	jr nz, UnknownRJump_0x3F507

UnknownData_0x3F502:
INCBIN "baserom.gb", $3F502, $3F507 - $3F502


UnknownRJump_0x3F507:
	cp $01
	jr nz, UnknownRJump_0x3F510

UnknownData_0x3F50B:
INCBIN "baserom.gb", $3F50B, $3F510 - $3F50B


UnknownRJump_0x3F510:
	ld hl, $4A58
	ld a, l
	ld [$A7AE], a
	ld [$A7B5], a
	ld a, h
	ld [$A7AF], a
	ld [$A7B6], a
	call UnknownCall_0x3E46
	ld a, 17 ;prepare bank switch
	ld bc, $0400
	ld hl, $7800
	ld de, $9800
	call FarCopyMem
	ld a, 13
	ld [$A68B], a
	ld de, $6734
	call UnknownCall_0x3E2A2
	ld a, 240
	ldh_n_a $C5
	ld a, 124
	ldh_n_a $C4
	call UnknownCall_0x3F37F
	ldh_n_a $C6
	ld a, 0
	ldh_n_a $C7
	ld a, 1
	ldh_n_a $BB
	call UnknownCall_0x3F30
	ld a, 5
	ld [$A460], a
	ld a, 144
	ld hl, $A7D5
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, 96
	ld hl, $A7DA
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, 3
	ld hl, $A7D0
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, 2
	ld hl, $A7DF
	ld [hli], a
	add 24
	ld [hli], a
	add 24
	ld [hli], a
	add 24
	ld [hli], a
	add 24
	ld [hl], a
	ld a, 0
	ld [$A7E9], a
	ld a, 195
	ldh_n_a $40
	ld a, 21
	ld [$A468], a
	ld a, 0
	ld [$A24F], a
	ret

UnknownCall_0x3F5A4:
	ld a, 255
	ld [$A468], a
	call UnknownCall_0x2AAA
	call DisableVBlank
	ld a, 25 ;prepare bank switch
	ld bc, $1000
	ld hl, $5000
	ld de, $8800
	call FarCopyMem
	call UnknownCall_0x3F58
	xor a
	ld [sScrollX], a
	ld [sScrollY], a
	ld [$A690], a
	ldh_n_a $81
	ld [$A69A], a
	ld [$A795], a
	ld [$A796], a
	ld [$A797], a
	ld [$A798], a
	ld [$A799], a
	ld [$A79A], a
	ld [$A79B], a
	ld [$A79C], a
	ld [$A7A6], a
	ld [$A7A7], a
	ld [$A7B0], a
	ld [$A7B1], a
	ld [$A7B3], a
	ld [$A7A8], a
	call UnknownCall_0x3E46
	ld a, 17 ;prepare bank switch
	ld bc, $0240
	ld hl, $7A40
	ld de, $9800
	call FarCopyMem
	ld a, 14
	ld [$A68B], a
	ld de, $6761
	call UnknownCall_0x3E2A2
	ld a, 240
	ldh_n_a $C5
	ld a, 124
	ldh_n_a $C4
	call UnknownCall_0x3F37F
	ldh_n_a $C6
	ld a, 0
	ldh_n_a $C7
	ld a, 1
	ldh_n_a $BB
	call UnknownCall_0x3F30
	ld a, 5
	ld [$A460], a
	ld a, 57
	ld [sOAMPalette2], a
	ld a, 195
	ldh_n_a $40
	ld a, 21
	ld [$A468], a
	ld a, 0
	ld [$A24F], a
	ret

UnknownData_0x3F64D:
INCBIN "baserom.gb", $3F64D, $40000 - $3F64D



SECTION "bank10", ROMX, BANK[$10]


GFX_OW_SpaceZoneBase: ;$40000
INCBIN "gfx/overworld/spacezone_base.2bpp"

GFX_OW_SpaceZone: ;$40200
INCBIN "gfx/overworld/spacezone.2bpp"

GFX_OW_MarioCastleBase: ;$41800
INCBIN "gfx/overworld/mariocastle_base.2bpp"

GFX_OW_MarioCastle: ;$42000
INCBIN "gfx/overworld/mariocastle.2bpp"

INCBIN "tilemaps/overworld/minigamehill.bin"
INCBIN "tilemaps/minigame/30coin.bin"
INCBIN "tilemaps/minigame/50coin.bin"
INCBIN "tilemaps/minigame/200coin.bin"
INCBIN "tilemaps/minigame/999coin.bin"
UnknownData_0x43B40: ;follows the minigame tilemaps; unclassified
	db $DA, $53, $53, $53, $53, $54, $44, $44, $24, $25, $44, $44, $44, $44, $34, $35
	db $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $22, $23, $44, $44, $44, $44
	db $32, $33, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $20, $21, $44, $44
	db $44, $44, $30, $31, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $24, $25
	db $44, $44, $44, $44, $34, $35, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44
	db $22, $23, $44, $44, $44, $44, $32, $33, $44, $44, $DA, $53, $53, $53, $53, $54
	db $44, $44, $20, $21, $44, $44, $44, $44, $30, $31, $44, $44, $DA, $53, $53, $53
	db $53, $54, $44, $44, $24, $25, $44, $44, $44, $44, $34, $35, $44, $44, $DA, $53
	db $53, $53, $53, $54, $44, $44, $22, $23, $44, $44, $44, $44, $32, $33, $44, $44
	db $DA, $53, $53, $53, $53, $54, $44, $44, $20, $21, $44, $44, $44, $44, $30, $31
	db $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $26, $27, $44, $44, $44, $44
	db $36, $37, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $24, $25, $44, $44
	db $44, $44, $34, $35, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $22, $23
	db $44, $44, $44, $44, $32, $33, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44
	db $20, $21, $44, $44, $44, $44, $30, $31, $44, $44, $DA, $53, $53, $53, $53, $54
	db $44, $44, $59, $6E, $6F, $44, $44, $44, $44, $44, $44, $44, $DA, $53, $53, $53
	db $53, $54, $44, $44, $24, $25, $44, $44, $44, $44, $34, $35, $44, $44, $DA, $53
	db $53, $53, $53, $54, $44, $44, $20, $21, $44, $44, $44, $44, $30, $31, $44, $44
	db $DA, $53, $53, $53, $53, $54, $44, $44, $22, $23, $44, $44, $44, $44, $32, $33
	db $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $20, $21, $44, $44, $44, $44
	db $30, $31, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $49, $6E, $6F, $44
	db $44, $44, $44, $44, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $22, $23
	db $44, $44, $44, $44, $32, $33, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44
	db $24, $25, $44, $44, $44, $44, $34, $35, $44, $44, $DA, $53, $53, $53, $53, $54
	db $44, $44, $49, $6E, $6F, $44, $44, $44, $44, $44, $44, $44, $DA, $53, $53, $53
	db $53, $54, $44, $44, $26, $27, $44, $44, $44, $44, $36, $37, $44, $44, $DA, $53
	db $53, $53, $53, $54, $44, $44, $59, $6E, $6F, $44, $44, $44, $44, $44, $44, $44
	db $DA, $53, $53, $53, $53, $54, $44, $44, $24, $25, $44, $44, $44, $44, $34, $35
	db $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $20, $21, $44, $44, $44, $44
	db $30, $31, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $64, $6E, $6F, $44
	db $44, $44, $44, $44, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $26, $27
	db $44, $44, $44, $44, $36, $37, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $56
	db $46, $6E, $6F, $44, $44, $44, $44, $44, $44, $44, $DA, $53, $53, $53, $53, $54
	db $44, $44, $49, $6E, $6F, $44, $44, $44, $44, $44, $44, $44, $DA, $53, $53, $53
	db $53, $54, $44, $44, $59, $6E, $6F, $44, $44, $44, $44, $44, $44, $44, $DA, $53
	db $53, $53, $53, $54, $44, $44, $49, $6E, $6F, $44, $44, $44, $44, $44, $44, $44
	db $DA, $53, $53, $53, $53, $54, $44, $44, $64, $6E, $6F, $44, $44, $44, $44, $44
	db $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $59, $6E, $6F, $44, $44, $44
	db $44, $44, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $49, $6E, $6F, $44
	db $44, $44, $44, $44, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $26, $27
	db $44, $44, $44, $44, $36, $37, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44
	db $64, $6E, $6F, $44, $44, $44, $44, $44, $44, $44, $DA, $53, $53, $53, $53, $54
	db $44, $44, $26, $27, $44, $44, $44, $44, $36, $37, $44, $44, $DA, $53, $53, $53
	db $53, $54, $44, $56, $46, $6E, $6F, $44, $44, $44, $44, $44, $44, $44, $DA, $53
	db $53, $53, $53, $54, $44, $64, $46, $6E, $6F, $44, $44, $44, $44, $44, $44, $44
	db $DA, $53, $53, $53, $53, $54, $44, $56, $46, $6E, $6F, $44, $44, $44, $44, $44
	db $44, $44, $DA, $53, $53, $53, $53, $54, $44, $77, $7E, $64, $46, $46, $44, $44
	db $44, $44, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $56, $46, $6E, $6F, $44
	db $44, $44, $44, $44, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $44, $64, $6E
	db $6F, $44, $44, $44, $44, $44, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $73
	db $73, $6E, $6F, $44, $44, $44, $44, $44, $44, $44, $DA, $53, $53, $53, $53, $54
	db $44, $44, $64, $6E, $6F, $44, $44, $44, $44, $44, $44, $44, $DA, $53, $53, $53
	db $53, $54, $44, $77, $7E, $59, $46, $46, $44, $44, $44, $44, $44, $44, $DA, $53
	db $53, $53, $53, $54, $44, $56, $46, $6E, $6F, $44, $44, $44, $44, $44, $44, $44
	db $DA, $53, $53, $53, $53, $54, $44, $77, $7E, $64, $46, $46, $44, $44, $44, $44
	db $44, $44, $DA, $53, $53, $53, $53, $54, $44, $64, $46, $6E, $6F, $44, $44, $44
	db $44, $44, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $56, $46, $6E, $6F, $44
	db $44, $44, $44, $44, $44, $44, $DA, $53, $53, $53, $53, $54, $44, $77, $7E, $64
	db $46, $46, $44, $44, $44, $44, $44, $44, $A0, $08, $28, $2A, $E6, $82, $E4, $02
	db $12, $82, $A0, $88, $06, $CB, $20, $A2, $0E, $08, $28, $34, $32, $4A, $00, $AA
	db $8B, $FE, $6A, $7B, $FE, $AE, $AB, $DA, $AE, $B7, $EF, $FF, $CB, $3B, $EF, $FE
	db $AE, $3A, $BA, $A6, $2E, $26, $FE, $B9, $17, $DB, $BD, $E8, $B8, $87, $92, $3E
	db $3B, $BA, $2F, $AA, $A4, $ED, $CB, $BF, $FE, $FA, $AF, $AF, $EE, $E6, $DA, $FC
	db $BE, $AA, $BE, $EF, $78, $8B, $FA, $4A, $B7, $EA, $A8, $F8, $F3, $AA, $FC, $DE
	db $D8, $CA, $56, $7E, $FD, $EF, $AE, $8A, $FA, $DB, $FF, $BF, $7B, $5A, $22, $7B
	db $EF, $BB, $FC, $FA, $2B, $B1, $86, $A8, $08, $9A, $E9, $EB, $FE, $BB, $7A, $EA
	db $32, $FA, $BE, $EE, $BA, $9B, $ED, $BA, $EF, $3E, $BB, $BA, $E9, $AA, $AE, $6E
	db $AE, $CE, $ED, $2E, $5E, $6B, $F2, $FA, $BE, $AA, $EE, $FA, $BF, $BB, $BB, $9A
	db $AA, $A0, $98, $C1, $D0, $88, $4C, $BA, $9A, $0A, $A9, $23, $09, $28, $04, $02
	db $3E, $A8, $0D, $A8, $EA, $0A, $32, $CA, $82, $00, $03, $E9, $0E, $88, $A4, $4A
	db $98, $48, $48, $B2, $0B, $3A, $00, $A2, $03, $0E, $68, $62, $40, $03, $B8, $A7
	db $A8, $61, $20, $A6, $13, $8A, $93, $AB, $A2, $82, $33, $2A, $16, $04, $88, $AE
	db $22, $32, $3E, $09, $27, $06, $68, $92, $80, $EA, $C0, $AC, $2A, $18, $48, $0A
	db $99, $87, $00, $20, $20, $A2, $10, $A1, $3A, $32, $5A, $22, $99, $AA, $70, $8A
	db $2E, $80, $9A, $9A, $2A, $24, $C3, $9A, $A9, $A2, $D8, $A2, $0C, $2A, $98, $A2
	db $A0, $90, $60, $10, $80, $1A, $40, $9B, $8A, $30, $80, $B8, $98, $EA, $08, $A8



SECTION "bank11", ROMX, BANK[$11]


UnknownData_0x44000: ;512 zero bytes before GFX_OW_MarioZone (filler)
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

GFX_OW_MarioZone: ;$44200
INCBIN "gfx/overworld/mariozone.2bpp"

GFX_OW_MarioZoneExtra: ;$45800
INCBIN "gfx/overworld/mariozone_extra.2bpp"

GFX_OW_WarioCastle: ;$46000
INCBIN "gfx/overworld/wariocastle.2bpp"

GFX_OW_WarioCastleExtra: ;$47000
INCBIN "gfx/overworld/wariocastle_extra.2bpp"
INCBIN "tilemaps/minigame/conveyor.bin"
INCBIN "tilemaps/minigame/rat.bin"
UnknownData_0x47C80: ;unclassified packed data (0xAA-heavy)
	db $A2, $28, $88, $23, $9A, $AA, $20, $2A, $22, $AE, $82, $88, $9C, $0A, $2A, $0C
	db $22, $A2, $08, $02, $4A, $2A, $60, $00, $0A, $0A, $24, $20, $88, $8C, $8A, $26
	db $A8, $8A, $82, $02, $AA, $A2, $20, $AA, $AA, $0A, $A8, $A8, $20, $0E, $08, $82
	db $38, $E8, $AE, $AE, $AA, $A0, $8B, $28, $0A, $C2, $A2, $02, $88, $A6, $8E, $08
	db $A6, $2A, $A8, $82, $0A, $02, $83, $2C, $8A, $6A, $8A, $88, $0A, $82, $20, $82
	db $20, $A8, $A2, $80, $22, $2C, $08, $02, $E8, $0A, $82, $A2, $08, $00, $AA, $AA
	db $AA, $0E, $8A, $2A, $AA, $2C, $0A, $80, $22, $06, $A8, $A0, $20, $0A, $28, $A8
	db $82, $A3, $80, $8A, $2A, $2A, $A0, $22, $00, $22, $06, $2A, $A2, $2A, $A6, $82
	db $CE, $EC, $AE, $AE, $EE, $FE, $AB, $DA, $B7, $B2, $BA, $EA, $A7, $B8, $BA, $E1
	db $EA, $F9, $EA, $AE, $EF, $BB, $A7, $EA, $99, $AA, $FF, $FE, $BE, $EB, $CE, $6E
	db $AC, $EA, $3B, $BE, $EF, $CE, $AE, $AE, $6A, $EE, $AA, $EE, $EB, $BE, $AB, $FB
	db $AF, $AE, $EE, $AB, $3E, $EB, $EA, $AD, $ED, $AB, $E8, $BB, $AA, $E7, $5E, $FA
	db $BE, $AD, $EA, $3F, $F7, $AA, $8B, $FE, $FA, $EE, $EA, $CA, $E4, $BB, $EF, $E8
	db $AA, $AE, $FE, $FA, $E3, $EF, $A2, $B6, $AE, $EE, $EE, $BA, $AE, $4A, $A6, $FE
	db $AE, $6B, $FA, $AF, $CF, $B3, $AF, $AE, $EA, $EF, $AE, $EA, $AB, $AF, $FA, $EF
	db $AA, $AF, $EA, $FC, $CE, $FE, $AB, $AE, $AE, $BB, $AE, $A6, $EA, $EF, $AF, $EE
	db $AA, $A8, $AC, $A2, $22, $AE, $A0, $1B, $0A, $82, $42, $C4, $E0, $88, $AA, $20
	db $AA, $82, $00, $2A, $A0, $0E, $8A, $80, $9A, $80, $00, $A2, $2E, $80, $22, $C8
	db $A2, $08, $E8, $82, $22, $88, $AA, $E8, $28, $89, $A2, $8C, $2A, $8A, $8B, $2A
	db $E2, $82, $A8, $0C, $8A, $2A, $08, $2A, $29, $84, $E0, $A6, $A0, $83, $28, $A0
	db $42, $26, $EE, $A0, $A0, $4A, $8A, $20, $82, $4A, $8A, $A0, $88, $80, $8B, $06
	db $06, $0A, $00, $00, $AA, $2A, $12, $88, $08, $88, $82, $C0, $8A, $9A, $08, $A8
	db $20, $80, $28, $C2, $82, $22, $0A, $42, $A2, $A2, $08, $82, $28, $30, $6A, $47
	db $A4, $20, $88, $A8, $0C, $08, $08, $8A, $83, $0A, $22, $82, $8A, $0A, $8A, $68
	db $BA, $EA, $A3, $EE, $A3, $EA, $AA, $DA, $AB, $EA, $F8, $FE, $AA, $AA, $BA, $AB
	db $B2, $ED, $BE, $AE, $9A, $AA, $AE, $FE, $F6, $EA, $AE, $FB, $EA, $AF, $BB, $BE
	db $EA, $7E, $AE, $EA, $AE, $AE, $AC, $AB, $EF, $EA, $ED, $AE, $AF, $EE, $AA, $EA
	db $EA, $FE, $EA, $82, $FA, $EF, $AA, $2E, $AA, $EE, $AF, $EE, $AB, $EA, $EA, $EE
	db $AA, $EB, $FA, $FB, $AE, $EE, $FE, $A9, $EA, $FF, $AA, $EF, $AA, $AE, $EE, $EF
	db $AA, $EB, $FE, $FF, $EE, $A9, $AB, $E7, $BA, $A8, $EC, $EF, $AA, $AE, $6F, $9A
	db $AF, $4A, $9B, $BA, $EE, $8F, $EF, $EA, $AE, $BE, $AE, $FF, $FF, $A9, $6C, $E6
	db $EA, $EE, $BA, $AA, $AA, $E2, $2E, $FA, $BE, $AA, $3A, $EB, $FE, $EA, $FE, $6B
	db $20, $AA, $A6, $26, $24, $02, $CE, $A0, $A2, $E8, $AA, $C2, $EA, $2A, $40, $88
	db $27, $A2, $0A, $00, $E0, $8A, $2B, $02, $20, $22, $08, $22, $22, $8A, $62, $08
	db $A2, $A0, $AA, $AA, $AE, $00, $A2, $02, $A0, $88, $AA, $0A, $02, $0A, $0A, $22
	db $82, $A2, $88, $20, $66, $00, $28, $40, $26, $00, $28, $2A, $82, $48, $80, $A2
	db $A3, $2B, $42, $A6, $20, $20, $08, $AA, $88, $20, $CA, $AA, $88, $20, $20, $A0
	db $AA, $A0, $00, $88, $28, $4A, $AA, $C2, $22, $88, $A2, $88, $A8, $B3, $08, $09
	db $80, $AE, $B0, $2A, $A8, $22, $08, $0C, $AA, $AA, $8A, $A2, $20, $0A, $AC, $A0
	db $2B, $CA, $E8, $A0, $0A, $28, $28, $A2, $BA, $42, $AA, $28, $88, $0C, $02, $A8
	db $AE, $FF, $AE, $EE, $EE, $AA, $EA, $AE, $BE, $FA, $FA, $BF, $BA, $9A, $EB, $F7
	db $BB, $BA, $FA, $AB, $AE, $2E, $BE, $4A, $FA, $6B, $EF, $2F, $B2, $FF, $FF, $FE
	db $EE, $FA, $BA, $FC, $A7, $BF, $2B, $DE, $BF, $E8, $EA, $FA, $F6, $3E, $FE, $BB
	db $AE, $EA, $EB, $29, $EA, $FA, $BB, $BC, $AE, $EB, $EA, $CE, $E8, $F9, $EA, $2B
	db $F6, $BE, $FA, $9B, $FB, $97, $EB, $BD, $A7, $BA, $9B, $EB, $EA, $AA, $FE, $E2
	db $E3, $EA, $BF, $EF, $AB, $FC, $FB, $B6, $EE, $A8, $CC, $EE, $EB, $EB, $B9, $BB
	db $A2, $EA, $EF, $F6, $FE, $EA, $FA, $FA, $AB, $BA, $EE, $AE, $BA, $2F, $AB, $8B
	db $EB, $AA, $A2, $7A, $66, $BA, $AA, $A5, $FF, $F2, $AE, $DF, $CA, $EF, $AA, $AA
	db $A8, $20, $AA, $A0, $00, $A8, $02, $68, $AA, $A0, $B9, $28, $A0, $8A, $C0, $A8
	db $A9, $A0, $08, $08, $AA, $88, $3A, $A2, $C2, $A8, $6A, $8A, $2F, $A0, $88, $81
	db $60, $AA, $62, $02, $2A, $A6, $8A, $0A, $1A, $8B, $AA, $A8, $AA, $03, $CA, $80
	db $A2, $26, $AA, $B8, $AA, $0A, $28, $4A, $AA, $A6, $82, $48, $88, $A4, $21, $41
	db $0A, $A2, $2A, $38, $23, $82, $88, $A2, $A0, $82, $A6, $00, $06, $02, $0A, $08
	db $20, $AA, $84, $62, $02, $20, $0A, $AA, $A2, $AA, $1B, $E0, $AC, $28, $30, $22
	db $8A, $00, $AA, $80, $8A, $2A, $0C, $0A, $A8, $EA, $24, $E0, $AA, $82, $A2, $4A
	db $A8, $0E, $88, $92, $E8, $82, $22, $2A, $28, $87, $0C, $0E, $0A, $32, $5B, $A2



SECTION "bank12", ROMX, BANK[$12]


UnknownData_0x48000:
INCBIN "baserom.gb", $48000, $482F0 - $48000
;$482F0 Pointers to levels 
	dw Level_07
	dw Level_08
	dw Level_09
	dw Level_10
	
INCBIN "baserom.gb", $482F8, $48500 - $482F8

Level_07: ;$48500
INCBIN "levels/level07.bin"

Level_08: ;$48E29
INCBIN "levels/level08.bin"

Level_09: ;$494D9
INCBIN "levels/level09.bin"

Level_10: ;$49FF2
INCBIN "levels/level10.bin"

INCBIN "baserom.gb", $4A948, $4C000 - $4A948

SECTION "bank13", ROMX, BANK[$13]


UnknownData_0x4C000: ;per-level group block preceding the Level_xx pointer list
	db $04, $40, $C4, $40, $0E, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $05
	db $04, $04, $04, $05, $0E, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $09
	db $08, $08, $08, $09, $0E, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $0C, $0C, $0D, $06, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $05
	db $04, $04, $04, $05, $0A, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $09
	db $08, $08, $08, $09, $0A, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $0E
	db $0C, $0D, $08, $09, $0E, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $0C, $0C, $0D, $0A, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $09
	db $08, $08, $08, $09, $0A, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $09
	db $08, $08, $08, $09, $06, $04, $04, $04, $04, $04, $04, $0F, $0F, $0F, $0F, $0F
	db $0F, $0F, $04, $05, $07, $0E, $0C, $0C, $0D, $0E, $0D, $0F, $0F, $0F, $0F, $0C
	db $0C, $0C, $0D, $07, $0B, $0E, $0C, $0C, $0C, $0D, $0E, $0C, $0D, $0E, $0C, $0C
	db $0C, $0C, $0D, $0B, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $02, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $0D, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1B, $1B, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $08, $09, $09, $00, $13, $00
	db $00, $00, $00, $03, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $AA, $EE, $AE, $EB, $6E, $FA, $EE, $BA, $BE, $FA, $EA, $FF
	db $EA, $EA, $BA, $AA, $AA, $6E, $EE, $2A, $2A, $AE, $A8, $2B, $EA, $EA, $AA, $6A
	db $AE, $EA, $EE, $BF, $AA, $EE, $EB, $EA, $CA, $AA, $AE, $EA, $AA, $AA, $EF, $EE
	db $AE, $2A, $8A, $AB, $AA, $AA, $A9, $AA, $AE, $AA, $AE, $EA, $AB, $EA, $AB, $B3
	db $AA, $E8, $EE, $EB, $AE, $AE, $E0, $BE, $AE, $EA, $EE, $AA, $AF, $AF, $AE, $AB
	db $AA, $AE, $FA, $0A, $AB, $AE, $BA, $8A, $AA, $EE, $FA, $EC, $AA, $2E, $88, $AE
	db $AA, $AE, $BA, $AF, $EA, $EC, $EA, $2A, $EA, $6A, $CE, $E2, $AA, $A3, $EA, $A2
	db $EE, $AD, $EE, $EE, $AE, $EC, $EA, $AA, $AA, $BE, $A2, $E8, $6A, $AA, $DA, $AA
	db $AA, $E0, $AA, $2A, $AA, $8A, $2A, $A2, $8A, $AA, $A8, $08, $28, $2A, $A0, $0A
	db $A0, $AA, $6A, $88, $06, $22, $2A, $22, $82, $A2, $AA, $8A, $22, $A0, $82, $2C
	db $A8, $AA, $AA, $AA, $BA, $00, $8A, $2A, $AA, $AA, $AA, $8A, $AE, $22, $2A, $A2
	db $2A, $80, $02, $2E, $A2, $0A, $EA, $A8, $A6, $0A, $20, $AA, $A0, $80, $62, $98
	db $E8, $AA, $82, $A2, $98, $A2, $62, $1A, $A2, $A2, $08, $AA, $AA, $A0, $AA, $88
	db $A2, $02, $0A, $08, $2A, $8A, $80, $A2, $AA, $0A, $AA, $80, $80, $A8, $8A, $02
	db $A8, $2E, $42, $22, $AA, $AA, $AA, $AA, $22, $0A, $A0, $0E, $AA, $A0, $C2, $02
	db $AA, $89, $AA, $AA, $82, $A0, $2A, $8A, $8A, $A2, $AA, $AA, $A2, $A2, $A2, $A0
	db $8A, $BA, $AA, $AE, $AE, $28, $AA, $6A, $EA, $EA, $AA, $AE, $2A, $EA, $8A, $BA
	db $CA, $EE, $FA, $AE, $F6, $3A, $AB, $EA, $EA, $6A, $AA, $AE, $B9, $EA, $8A, $BE
	db $AA, $AA, $B9, $EB, $AE, $AE, $AA, $BE, $AB, $B2, $AA, $BE, $AE, $AA, $8A, $BE
	db $AA, $A0, $AA, $3E, $AA, $FA, $EA, $AE, $AA, $8E, $A9, $CF, $EA, $AE, $AE, $EA
	db $AE, $EE, $AE, $2A, $BE, $EA, $AA, $AA, $AC, $BA, $EA, $AE, $AE, $AE, $BA, $EE
	db $EE, $AA, $EE, $EA, $AE, $EA, $A9, $BB, $AA, $A2, $AA, $E2, $8B, $AE, $EA, $BA
	db $AF, $FE, $AA, $6E, $AE, $FA, $EE, $BD, $B6, $EE, $AA, $AA, $AB, $EE, $AB, $AB
;$4C2F0 Pointers to levels 
	dw Level_18
	dw Level_19
	dw Level_20
	dw Level_25
	
UnknownData_0x4C2F8: ;shared group block between the pointer list and Level_18
	db $AA, $EA, $E6, $EA, $FE, $E8, $EE, $E8, $88, $AA, $C2, $6E, $A8, $2A, $0A, $AA
	db $AA, $02, $AA, $A9, $A2, $AA, $A2, $AA, $AA, $AA, $88, $AA, $B2, $AA, $82, $AA
	db $A8, $00, $A2, $22, $8A, $AA, $22, $C0, $AA, $28, $2A, $8A, $AA, $BA, $8A, $2A
	db $20, $68, $AA, $A8, $8A, $8A, $8A, $2A, $A8, $82, $AA, $AA, $0A, $AA, $A8, $A2
	db $AA, $2E, $2A, $E0, $28, $A2, $0A, $8A, $28, $F4, $A2, $A2, $EA, $28, $2A, $8A
	db $AC, $2A, $AA, $0A, $A8, $00, $AA, $0A, $2A, $28, $28, $A2, $82, $88, $A8, $AA
	db $A0, $88, $B2, $2A, $60, $A8, $A0, $0A, $82, $CA, $22, $2A, $20, $AA, $A0, $A2
	db $EC, $22, $2A, $8A, $AA, $A2, $A2, $A8, $8A, $88, $AA, $2E, $A2, $A8, $0A, $08
	db $2A, $28, $AA, $4A, $22, $A2, $A8, $60, $AA, $BE, $AA, $AA, $8A, $EE, $EE, $EE
	db $AA, $EE, $AA, $86, $08, $EE, $AE, $B8, $AB, $EE, $EA, $E0, $AA, $AB, $AA, $EA
	db $AE, $AC, $FA, $EC, $EC, $2A, $FE, $BF, $AF, $EE, $AE, $EE, $AE, $AE, $9A, $FA
	db $2A, $BA, $AE, $AF, $EA, $AB, $EA, $AF, $82, $AA, $8A, $AB, $AB, $BE, $EA, $AE
	db $AA, $FB, $AA, $A2, $EA, $EA, $CE, $6A, $AA, $F6, $AA, $EB, $E8, $AA, $AE, $ED
	db $AA, $EE, $AA, $AA, $AA, $A2, $AE, $AE, $EE, $AA, $AA, $EB, $B2, $AE, $6A, $AE
	db $AE, $FA, $EE, $AE, $EA, $EF, $8A, $FE, $AA, $EB, $AE, $EA, $E8, $EA, $AA, $B2
	db $CB, $AF, $A6, $2A, $AA, $AE, $B2, $AA, $BE, $AA, $8B, $BA, $AA, $EA, $AB, $CC
	db $2B, $EB, $AE, $8B, $AA, $AA, $AA, $AB, $AA, $0A, $AA, $C2, $82, $B3, $82, $2A
	db $A5, $38, $A3, $8A, $88, $0A, $A1, $AA, $8A, $88, $AA, $AA, $AB, $32, $A0, $BA
	db $22, $23, $AA, $A8, $F2, $07, $A7, $2A, $2A, $8A, $8A, $AE, $AA, $A8, $AA, $A0
	db $82, $AF, $2A, $8B, $22, $2A, $AA, $80, $A8, $A8, $A0, $A2, $EA, $AA, $A4, $A0
	db $8A, $AA, $AE, $28, $AA, $A8, $AE, $A2, $AA, $A2, $A2, $A2, $8A, $A8, $88, $A8
	db $AA, $00, $8A, $A8, $A8, $A3, $A8, $32, $AA, $A2, $2A, $80, $AA, $8A, $AA, $A6
	db $2A, $2A, $A2, $A8, $A0, $AA, $A0, $23, $AA, $A9, $2A, $A8, $AC, $38, $0E, $80
	db $02, $20, $8B, $8E, $AE, $8A, $A1, $3A, $2A, $BA, $AA, $82, $A8, $AE, $92, $AE
	db $08, $A8, $2A, $90, $AB, $A8, $02, $20, $2B, $AA, $FF, $9A, $AB, $EE, $AD, $EB
	db $EF, $AE, $AF, $AA, $BA, $EA, $3E, $AB, $BE, $AE, $EA, $EA, $BA, $AA, $BE, $EA
	db $AA, $BF, $AE, $AA, $AE, $83, $E7, $7E, $AA, $EA, $EA, $FA, $EA, $AE, $2A, $FA
	db $BA, $AE, $EA, $DA, $E8, $BF, $EF, $1F, $AA, $FB, $EA, $2B, $B2, $AA, $2E, $BA
	db $FA, $BA, $7B, $A6, $8E, $AF, $EA, $6B, $A2, $AB, $6F, $BA, $AA, $EF, $AB, $EB
	db $AE, $B6, $AE, $AA, $DE, $AA, $BB, $EF, $FB, $AF, $BB, $2E, $2A, $BD, $FE, $EB
	db $AA, $8F, $AB, $EA, $BA, $A0, $BA, $EC, $AA, $BA, $B6, $AF, $AE, $AE, $AA, $BE
	db $EA, $BF, $EA, $BE, $AE, $B2, $AB, $AB, $BA, $86, $FB, $AA, $AE, $8E, $AB, $BB
	db $AB, $AF, $EF, $AA, $AA, $AE, $E7, $3E

Level_18: ;$4C500
INCBIN "levels/level18.bin"

Level_19: ;$4CE19
INCBIN "levels/level19.bin"

Level_20: ;$4DAFF
INCBIN "levels/level20.bin"

Level_25: ;$4E33A
INCBIN "levels/level25.bin"

SECTION "bank14", ROMX, BANK[$14]


UnknownData_0x50000:
INCBIN "baserom.gb", $50000, $502F0 - $50000
;$502F0 Pointers to levels 
	dw Level_15
	dw Level_16
	dw Level_17
	
INCBIN "baserom.gb", $502F6, $50500 - $502F6

Level_15: ;$50500
INCBIN "levels/level15.bin"

Level_16: ;$50AB4
INCBIN "levels/level16.bin"

Level_17: ;$51EC9
INCBIN "levels/level17.bin"

INCBIN "baserom.gb", $52341, $54000 - $52341

SECTION "bank15", ROMX, BANK[$15]


UnknownData_0x54000:
INCBIN "baserom.gb", $54000, $542F0 - $54000
;$542F0 Pointers to levels 
	dw Level_21
	dw Level_22
	dw Level_23
	dw Level_24
	
INCBIN "baserom.gb", $542F8, $54500 - $542F8

Level_21: ;$54500
INCBIN "levels/level21.bin"

Level_22: ;$54B41
INCBIN "levels/level22.bin"

Level_23: ;$55242
INCBIN "levels/level23.bin"

Level_24: ;$55C4C
INCBIN "levels/level24.bin"

INCBIN "baserom.gb", $562DE, $58000 - $562DE



SECTION "bank16", ROMX, BANK[$16]


UnknownCall_0x58000:
	ld a, [$A224]
	cp $FF
	ret z
	ld a, [$A24F]
	and a
	jr z, UnknownRJump_0x5800F
	xor a
	ldh [$FFE2], a

UnknownRJump_0x5800F:
	call UnknownCall_0x3A8C
	ld a, [$AF3E]
	and a
	ret nz
	ldh a, [$FFDF]
	and a
	jr z, UnknownRJump_0x5802B
	ld a, [$AF08]
	ld b, a
	ld a, [$AF29]
	swap a
	and $03
	srl a
	xor b
	ret nz

UnknownRJump_0x5802B:
	ld a, 1
	ld [$AF09], a
	ldh a, [$FFEB]
	and a
	jp nz, UnknownJump_0x58101
	ld a, [$AF06]
	and a
	jp nz, UnknownJump_0x59C04
	ldh a, [$FFD5]
	rst $28

UnknownData_0x58040:
INCBIN "baserom.gb", $58040, $58101 - $58040


UnknownJump_0x58101:
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58110
	call UnknownCall_0x5B3C6
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret

UnknownRJump_0x58110:
	dec a
	rst $28

UnknownData_0x58112:
INCBIN "baserom.gb", $58112, $5811A - $58112

	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3BB8
	ld a, [$AF2F]
	bit 0, a
	jr z, UnknownRJump_0x5812E
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a

UnknownRJump_0x5812E:
	call UnknownCall_0x5B481
	call UnknownCall_0x3D2D
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	add 2
	ldh [$FFDF], a
	ret
	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3C1C
	ld a, [$AF2F]
	bit 1, a
	jr z, UnknownRJump_0x5812E
	ldh a, [$FFDF]
	dec a
	ldh [$FFDF], a
	jr UnknownRJump_0x5812E
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3BB8
	ld a, [$AF2F]
	bit 0, a
	jr z, UnknownRJump_0x5816C
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a

UnknownRJump_0x5816C:
	call UnknownCall_0x5B451
	call UnknownCall_0x3D3D
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	ret z
	ldh a, [$FFEB]
	cp $02
	jr z, UnknownRJump_0x5819B
	call UnknownCall_0x3AA0
	ret
	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3C1C
	ld a, [$AF2F]
	bit 1, a
	jr z, UnknownRJump_0x5816C
	ldh a, [$FFDF]
	dec a
	ldh [$FFDF], a
	jr UnknownRJump_0x5816C

UnknownRJump_0x5819B:
	ldh a, [$FFE2]
	ld [$AFCC], a
	call UnknownCall_0x3AA0
	ld a, [$AFCC]
	ldh [$FFE2], a
	call UnknownCall_0x3CB1
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ret
	ldh a, [$FFDF]
	dec a
	jr z, UnknownRJump_0x581CE
	dec a
	jr z, UnknownRJump_0x581E2

UnknownJump_0x581B9:
	ld b, 20
	call UnknownCall_0x3D2D
	ldh a, [$FFDD]
	xor $40
	ldh [$FFDD], a
	xor a
	ldh [$FFE0], a
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ret

UnknownRJump_0x581CE:
	call UnknownCall_0x5B465
	sla b
	call UnknownCall_0x3D2D
	ldh a, [$FFE0]
	cp c
	ret nz
	ld a, 2
	ldh [$FFDF], a
	xor a
	ldh [$FFE0], a
	ret

UnknownRJump_0x581E2:
	call UnknownCall_0x5B451
	sla b
	call UnknownCall_0x3D3D
	ldh a, [$FFD9]
	cp $A0
	ret c
	ld a, 2
	ld [$AF26], a
	call UnknownCall_0x5B2D7
	ld a, [$A2E0]
	and a
	ret z
	dec a
	ld [$A2E0], a
	ret
	call UnknownCall_0x5B51A
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58215
	call UnknownCall_0x5B3C6
	ld a, 16
	ldh [$FFDE], a
	ld a, 78
	ldh [$FFE2], a
	ret

UnknownJump_0x58215:
UnknownRJump_0x58215:
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5821E:
INCBIN "baserom.gb", $5821E, $58226 - $5821E


UnknownJump_0x58226:
	call UnknownCall_0x3C1C
	ld a, [$AF2F]
	bit 1, a
	jr nz, UnknownRJump_0x58237
	ld b, 1
	call UnknownCall_0x3D22
	jr UnknownRJump_0x58243

UnknownRJump_0x58237:
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret

UnknownRJump_0x58243:
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	ret nz
	ldh a, [$FFDF]
	add 2
	ldh [$FFDF], a
	ret

UnknownJump_0x58253:
	call UnknownCall_0x3BB8
	ld a, [$AF2F]
	bit 0, a
	jr nz, UnknownRJump_0x58264
	ld b, 1
	call UnknownCall_0x3D32
	jr UnknownRJump_0x58243

UnknownRJump_0x58264:
	ldh a, [$FFDF]
	sub 1
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret

UnknownJump_0x58271:
	call UnknownCall_0x3C1C
	ld a, [$AF2F]
	bit 1, a
	jr nz, UnknownRJump_0x58237
	ld b, 1
	call UnknownCall_0x3D22
	jr UnknownRJump_0x58293

UnknownJump_0x58282:
	call UnknownCall_0x3BB8
	ld a, [$AF2F]
	bit 0, a
	jr nz, UnknownRJump_0x58264
	ld b, 1
	call UnknownCall_0x3D32
	jr UnknownRJump_0x58293

UnknownRJump_0x58293:
	call UnknownCall_0x5B451
	call UnknownCall_0x3D3D
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	ret z
	ldh a, [$FFDF]
	sub 2
	ldh [$FFDF], a
	ret
	ldh a, [$FFDF]
	dec a
	jr z, UnknownRJump_0x582C3
	ld a, 16
	ldh [$FFDE], a
	ld a, 1
	ldh [$FFDF], a
	ld a, 32
	ldh [$FFE0], a
	xor a
	ldh [$FFE2], a
	ld a, 3
	ld [$A460], a
	ret

UnknownRJump_0x582C3:
	ld hl, $FFE0
	dec [hl]
	ret nz
	ld a, 1
	ld [$AF26], a
	call UnknownCall_0x5B2D7
	ret
	call UnknownCall_0x5B585
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x582F5
	ld a, 86
	ldh [$FFE2], a

UnknownJump_0x582DD:
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	jr nz, UnknownRJump_0x582EE

UnknownData_0x582E7:
INCBIN "baserom.gb", $582E7, $582EE - $582E7


UnknownRJump_0x582EE:
	xor a
	ldh [$FFE0], a
	call UnknownCall_0x5B3C6
	ret

UnknownJump_0x582F5:
UnknownRJump_0x582F5:
	dec a
	rst $28

UnknownData_0x582F7:
INCBIN "baserom.gb", $582F7, $582FB - $582F7


UnknownJump_0x582FB:
UnknownCall_0x582FB:
	ldh a, [$FFF0]
	and $01
	jr nz, UnknownRJump_0x58339
	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3C1C
	ld a, [$AF2F]
	bit 1, a
	ret z
	ld a, 2
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret

UnknownJump_0x5831A:
UnknownCall_0x5831A:
	ldh a, [$FFF0]
	and $01
	jr nz, UnknownRJump_0x58339
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3BB8
	ld a, [$AF2F]
	bit 0, a
	ret z
	ld a, 1
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret

UnknownRJump_0x58339:
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	ret nz
	ldh a, [$FFDF]
	xor $03
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret
	ldh a, [$FFDF]
	dec a
	jr z, UnknownRJump_0x58364
	dec a
	jr z, UnknownRJump_0x58380
	ld a, 6
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ld a, 192
	ldh [$FFEC], a
	ret

UnknownRJump_0x58364:
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	jr z, UnknownRJump_0x5837B
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	ret nz
	call UnknownCall_0x5B451
	call UnknownCall_0x3D3D
	ret

UnknownRJump_0x5837B:
	ld a, 2
	ldh [$FFDF], a
	ret

UnknownRJump_0x58380:
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDB]
	xor $0B
	ldh [$FFDB], a
	ldh a, [$FFEC]
	inc a
	ldh [$FFEC], a
	cp $08
	ret nz
	ld a, 1
	ldh [$FFD5], a
	call UnknownCall_0x3AA0
	ret
	ldh a, [$FFE2]
	bit 6, a
	call nz, UnknownCall_0x5B697
	call UnknownCall_0x5B607
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x583B2
	call UnknownCall_0x5B3C6
	ld a, 95
	ldh [$FFE2], a
	ret

UnknownRJump_0x583B2:
	dec a
	rst $28

UnknownData_0x583B4:
INCBIN "baserom.gb", $583B4, $583BC - $583B4

	call UnknownCall_0x3BA4
	ld a, [$AF2F]
	bit 0, a
	jr nz, UnknownRJump_0x583DB
	ld b, 3
	call UnknownCall_0x3D32

UnknownRJump_0x583CB:
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	ret nz
	ldh a, [$FFDF]
	add 2
	ldh [$FFDF], a
	ret

UnknownRJump_0x583DB:
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ld a, 2
	ld [$A460], a
	ret
	call UnknownCall_0x3C08
	ld a, [$AF2F]
	bit 1, a
	jr nz, UnknownRJump_0x583F7
	ld b, 3
	call UnknownCall_0x3D22
	jr UnknownRJump_0x583CB

UnknownRJump_0x583F7:
	ldh a, [$FFDF]
	dec a
	ldh [$FFDF], a
	ld a, 2
	ld [$A460], a
	ret
	call UnknownCall_0x3BA4
	ld a, [$AF2F]
	bit 0, a
	jr nz, UnknownRJump_0x583DB
	ld b, 3
	call UnknownCall_0x3D32

UnknownRJump_0x58411:
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	jr nz, UnknownRJump_0x58423
	call UnknownCall_0x5B451
	inc b
	call UnknownCall_0x3D3D
	ret

UnknownRJump_0x58423:
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	sub 2
	ldh [$FFDF], a
	ldh a, [$FFD4]
	and $F0
	ldh [$FFD4], a
	ret
	call UnknownCall_0x3C08
	ld a, [$AF2F]
	bit 1, a
	jr nz, UnknownRJump_0x583F7
	ld b, 3
	call UnknownCall_0x3D22
	jr UnknownRJump_0x58411
	ld a, [sPipeTravelDirection]
	and $F0
	jr z, UnknownRJump_0x58452
	xor a
	ld [$AF3A], a
	jp UnknownJump_0x5B2D7

UnknownRJump_0x58452:
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5845F
	xor a
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ret

UnknownRJump_0x5845F:
	dec a
	rst $28

UnknownData_0x58461:
INCBIN "baserom.gb", $58461, $58463 - $58461

	call UnknownCall_0x5B4C1
	call UnknownCall_0x5B697
	ld a, [$AF2E]
	and a
	jr nz, UnknownRJump_0x584C3
	call UnknownCall_0x3B68
	ld a, [$AF2F]
	bit 2, a
	jr nz, UnknownRJump_0x584C3
	ldh_a_n $80
	bit 1, a
	ret nz
	xor a
	ld [$AF3A], a
	call UnknownCall_0x3AB4
	ld b, 16
	ld a, [sMarioDirection]
	cp $01
	jr z, UnknownRJump_0x584A9
	call UnknownCall_0x3D22
	call UnknownCall_0x3C08
	ld a, [$AF2F]
	bit 1, a
	ret z
	ld b, 16
	call UnknownCall_0x3D32
	ld a, 95
	ldh [$FFE2], a
	ld a, 2
	ldh [$FFDF], a
	ret

UnknownRJump_0x584A9:
	call UnknownCall_0x3D32
	call UnknownCall_0x3BA4
	ld a, [$AF2F]
	bit 0, a
	ret z
	ld b, 16
	call UnknownCall_0x3D22
	ld a, 95
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ret

UnknownRJump_0x584C3:
	xor a
	ld [$AF3A], a
	call UnknownCall_0x3ADC
	ret
	ld a, [sPipeTravelDirection]
	and $F0
	jp nz, UnknownJump_0x5B2D7
	ldh a, [$FFDF]
	dec a
	jr z, UnknownRJump_0x5851C
	dec a
	jr z, UnknownRJump_0x5850C
	dec a
	jr z, UnknownRJump_0x58537
	jr UnknownRJump_0x584F3
	ld a, [sPipeTravelDirection]
	and $F0
	jp nz, UnknownJump_0x5B2D7
	ldh a, [$FFDF]
	dec a
	jr z, UnknownRJump_0x5850C
	dec a
	jr z, UnknownRJump_0x5851C
	dec a
	jr z, UnknownRJump_0x58537

UnknownRJump_0x584F3:
	ld a, 128
	ldh [$FFDC], a
	call UnknownCall_0x5B4B4
	cp $18
	ret c
	ld a, 1
	ldh [$FFDF], a
	ld a, 32
	ldh [$FFE8], a
	ldh [$FFE9], a
	ld a, 68
	ldh [$FFE2], a
	ret

UnknownRJump_0x5850C:
	call UnknownCall_0x5B51A
	ld b, 1
	call UnknownCall_0x3D2D
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	jr UnknownRJump_0x5852A

UnknownRJump_0x5851C:
	call UnknownCall_0x5B51A
	ld b, 1
	call UnknownCall_0x3D3D
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz

UnknownRJump_0x5852A:
	ldh a, [$FFE9]
	ldh [$FFE8], a
	ld hl, $FFDF
	inc [hl]
	ld a, 24
	ldh [$FFEC], a
	ret

UnknownRJump_0x58537:
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	xor a
	ldh [$FFDF], a
	ret
	ld a, [sPipeTravelDirection]
	and $F0
	jp nz, UnknownJump_0x5B2D7
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5855A
	call UnknownCall_0x5B3E0
	inc a
	jr z, UnknownRJump_0x58556
	ld a, 32

UnknownRJump_0x58556:
	ldh [$FFDD], a
	jr UnknownRJump_0x584F3

UnknownRJump_0x5855A:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5855E:
INCBIN "baserom.gb", $5855E, $58566 - $5855E

	call UnknownCall_0x585DA
	ld b, 1
	call UnknownCall_0x3D2D
	ldh a, [$FFE8]
	dec a
	ldh [$FFE8], a
	ret nz
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	ld a, 14
	ld [$AF36], a
	ld a, 22
	ld [$AF37], a
	ldh a, [$FFDD]
	ld [$AF38], a
	ldh a, [$FFDB]
	cp $13
	jr z, UnknownRJump_0x58596
	ld a, [$AF38]
	set 6, a
	ld [$AF38], a

UnknownRJump_0x58596:
	call UnknownCall_0x5B36D
	ld a, 2
	ldh [$FFDF], a
	ld a, 48
	ldh [$FFEC], a
	ret
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 3
	ldh [$FFDF], a
	ldh a, [$FFE9]
	ldh [$FFE8], a
	ldh a, [$FFDB]
	dec a
	ldh [$FFDB], a
	ret
	call UnknownCall_0x585DA
	ld b, 1
	call UnknownCall_0x3D3D
	ldh a, [$FFE8]
	dec a
	ldh [$FFE8], a
	ret nz
	ld a, 4
	ldh [$FFDF], a
	ldh [$FFEC], a
	ret
	ldh a, [$FFF0]
	and $07
	ret nz
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	xor a
	ldh [$FFDF], a
	ret

UnknownCall_0x585DA:
	call UnknownCall_0x5B41A
	ld a, [$AF2C]
	dec a
	jr z, UnknownRJump_0x585E8
	ld a, 18
	ldh [$FFDB], a
	ret

UnknownRJump_0x585E8:
	ld a, 20
	ldh [$FFDB], a
	ret
	call UnknownCall_0x5B521
	ldh a, [$FFDF]
	dec a
	jr z, UnknownRJump_0x58613
	dec a
	jr z, UnknownRJump_0x5861A
	ld a, 64
	ldh [$FFE2], a
	ld b, 12
	call UnknownCall_0x3D2D
	ldh a, [$FFDD]
	bit 6, a
	jr z, UnknownRJump_0x5860F
	res 6, a
	ldh [$FFDD], a
	ld a, 1
	ldh [$FFE8], a

UnknownRJump_0x5860F:
	call UnknownCall_0x3CB1
	ret

UnknownRJump_0x58613:
	ld b, 2
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5861F

UnknownRJump_0x5861A:
	ld b, 2
	call UnknownCall_0x3D32

UnknownRJump_0x5861F:
	ld b, 1
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x5862A
	call UnknownCall_0x3D2D
	ret

UnknownRJump_0x5862A:
	call UnknownCall_0x3D3D
	ret
	call UnknownCall_0x5B521
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58642
	call UnknownCall_0x5B3C6
	ld a, 16
	ldh [$FFDE], a
	ld a, 86
	ldh [$FFE2], a
	ret

UnknownJump_0x58642:
UnknownRJump_0x58642:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x58646:
INCBIN "baserom.gb", $58646, $5864E - $58646

	ldh a, [$FFF0]
	and $01
	jr nz, UnknownRJump_0x5868C
	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3C1C
	ld a, [$AF2F]
	bit 1, a
	ret z
	ld a, 2
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret
	ldh a, [$FFF0]
	and $01
	jr nz, UnknownRJump_0x5868C
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3BB8
	ld a, [$AF2F]
	bit 0, a
	ret z
	ld a, 1
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret

UnknownRJump_0x5868C:
	ldh a, [$FFE8]
	dec a
	jr z, UnknownRJump_0x586AD
	call UnknownCall_0x5B47A
	ldh a, [$FFE0]
	cp c
	jr z, UnknownRJump_0x586A5
	call UnknownCall_0x3D2D
	call UnknownCall_0x3B7C
	ld a, [$AF2F]
	bit 2, a
	ret z

UnknownRJump_0x586A5:
	xor a
	ldh [$FFE0], a
	ld a, 1
	ldh [$FFE8], a
	ret

UnknownRJump_0x586AD:
	call UnknownCall_0x5B451
	call UnknownCall_0x3D3D
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	ret z
	xor a
	ldh [$FFE8], a
	ldh a, [$FFE9]
	inc a
	cp $04
	jr z, UnknownRJump_0x586D6
	ldh [$FFE9], a
	ld a, 10
	ldh [$FFE0], a
	ldh a, [$FFDF]
	cp $03
	ret nc
	add 2
	ldh [$FFDF], a
	ret

UnknownRJump_0x586D6:
	xor a
	ldh [$FFE0], a
	ldh [$FFE8], a
	ldh [$FFE9], a
	call UnknownCall_0x5B3C6
	ret
	ld a, 133
	ldh [$FFE2], a
	ret
	ld a, 137
	ldh [$FFE2], a
	ret

UnknownData_0x586EB:
INCBIN "baserom.gb", $586EB, $586EE - $586EB

	ldh a, [$FFD5]
	add 102
	ldh [$FFE2], a
	ret
	ld a, 1
	ldh [$FFDF], a
	call UnknownCall_0x5B68B
	ld b, 2
	call UnknownCall_0x3D2D
	ldh a, [$FFE8]
	add b
	ldh [$FFE8], a
	cp $20
	ret nz
	ld a, 2
	ld [$AF26], a
	call UnknownCall_0x5B2D7
	ret
	ldh a, [$FFDF]
	dec a
	jr z, UnknownRJump_0x58734
	dec a
	jr z, UnknownRJump_0x58749
	dec a
	jr z, UnknownRJump_0x5874C
	dec a
	jr z, UnknownRJump_0x5874F
	dec a
	jr z, UnknownRJump_0x58752
	ld a, 128
	ldh [$FFE2], a
	xor a
	ldh [$FFE8], a
	ld a, 128
	ldh [$FFDC], a
	ld a, 1
	ld [$AF3E], a
	ret

UnknownRJump_0x58734:
	ld b, 1
	call UnknownCall_0x3D2D
	ldh a, [$FFE8]
	inc a
	ldh [$FFE8], a
	cp $08
	ret nz
	ld a, 3
	ldh [$FFDF], a
	xor a
	ldh [$FFDC], a
	ret

UnknownRJump_0x58749:
	jp UnknownJump_0x58226

UnknownRJump_0x5874C:
	jp UnknownJump_0x58253

UnknownRJump_0x5874F:
	jp UnknownJump_0x58271

UnknownRJump_0x58752:
	jp UnknownJump_0x58282
	call UnknownCall_0x5B68B
	ldh a, [$FFDF]
	dec a
	jr z, UnknownRJump_0x58787
	dec a
	ret z
	ld a, 128
	ldh [$FFE2], a
	ldh a, [$FFD2]
	cp $10
	jr z, UnknownRJump_0x58777
	ld a, 128
	ldh [$FFDC], a
	ld a, 1
	ld [$AF3E], a
	ld a, 2
	ldh [$FFDF], a
	ret

UnknownRJump_0x58777:
	ldh a, [$FFD5]
	add 112
	ldh [$FFE2], a
	ld a, 2
	ldh [$FFDF], a
	ld b, 8
	call UnknownCall_0x3D3D
	ret

UnknownRJump_0x58787:
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 1
	call UnknownCall_0x3D2D
	ldh a, [$FFE8]
	inc a
	ldh [$FFE8], a
	cp $08
	ret nz
	ld a, 2
	ldh [$FFDF], a
	xor a
	ldh [$FFDC], a
	ret
	call UnknownCall_0x5B68B
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x587B7
	ld a, 132
	ldh [$FFE2], a
	ld b, 56
	call UnknownCall_0x3D2D
	ld a, 1
	ldh [$FFDF], a
	ret

UnknownRJump_0x587B7:
	ld b, 1
	call UnknownCall_0x3D3D
	ret
	ldh a, [$FFDF]
	dec a
	jr z, UnknownRJump_0x587D3
	ld a, 134
	ldh [$FFE2], a
	ldh a, [$FFE7]
	bit 4, a
	ret z
	ld a, 1
	ldh [$FFDF], a
	xor a
	ldh [$FFE2], a
	ret

UnknownRJump_0x587D3:
	call UnknownCall_0x5B545
	ret
	ldh a, [$FFDF]
	dec a
	jr z, UnknownRJump_0x587D3
	dec a
	jr z, UnknownRJump_0x587EE
	ld a, [$A2A0]
	and a
	jr nz, UnknownRJump_0x587FB
	ld a, 135
	ldh [$FFE2], a
	ld a, 2
	ldh [$FFDF], a
	ret

UnknownRJump_0x587EE:
	ldh a, [$FFE7]
	bit 4, a
	ret z
	ld a, 1
	ldh [$FFDF], a
	xor a
	ldh [$FFE2], a
	ret

UnknownRJump_0x587FB:
	ld a, 2
	ld [$AF26], a
	call UnknownCall_0x5B2D7
	ret
	ldh a, [$FFDF]
	rst $28

UnknownData_0x58807:
INCBIN "baserom.gb", $58807, $5880F - $58807

	ld a, 1
	ldh [$FFDF], a
	ret
	call UnknownCall_0x5B4B4
	cp $30
	ret nc
	ld a, 2
	ldh [$FFDF], a
	ld a, 136
	ldh [$FFE2], a
	ret
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	cp $88
	ret nz
	ld a, 3
	ldh [$FFDF], a
	ret
	ldh a, [$FFE7]
	bit 4, a
	jr nz, UnknownRJump_0x58844
	call UnknownCall_0x5B511
	ld b, 1
	call UnknownCall_0x3D2D
	ret

UnknownRJump_0x58844:
	call UnknownCall_0x5B2D7
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58859
	call UnknownCall_0x5B3C6
	ld a, 77
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFEC], a
	ret

UnknownRJump_0x58859:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5885D:
INCBIN "baserom.gb", $5885D, $58865 - $5885D

	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x58872
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 56
	ldh [$FFDB], a

UnknownRJump_0x58872:
	call UnknownCall_0x3C1C
	ld a, [$AF2F]
	bit 1, a
	jr nz, UnknownRJump_0x588E2
	ld b, 1
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5889F
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x58890
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 56
	ldh [$FFDB], a

UnknownRJump_0x58890:
	call UnknownCall_0x3BB8
	ld a, [$AF2F]
	bit 0, a
	jr nz, UnknownRJump_0x588E2
	ld b, 1
	call UnknownCall_0x3D32

UnknownRJump_0x5889F:
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x588B9
	call UnknownCall_0x5B46C
	call UnknownCall_0x3D2D
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	inc a
	ldh [$FFE8], a
	ld a, 52
	ldh [$FFDB], a
	ret

UnknownRJump_0x588B9:
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	jr nz, UnknownRJump_0x588CA
	call UnknownCall_0x5B445
	call UnknownCall_0x3D3D
	ret

UnknownRJump_0x588CA:
	xor a
	ldh [$FFE0], a
	ldh [$FFE8], a
	ld a, 8
	ldh [$FFEC], a
	call UnknownCall_0x5B4B4
	cp $30
	jr c, UnknownRJump_0x588E8
	ldh a, [$FFE9]
	inc a
	ldh [$FFE9], a
	cp $03
	ret nz

UnknownJump_0x588E2:
UnknownRJump_0x588E2:
	xor a
	ldh [$FFE9], a
	jp UnknownJump_0x59D2D

UnknownRJump_0x588E8:
	ld a, 8
	ldh [$FFEC], a
	call UnknownCall_0x5B3E0
	bit 7, a
	jr z, UnknownRJump_0x58900
	ld b, 1
	ldh a, [$FFDF]
	xor b
	jr z, UnknownRJump_0x5891D

UnknownData_0x588FA:
INCBIN "baserom.gb", $588FA, $58900 - $588FA


UnknownRJump_0x58900:
	ld b, 2
	ldh a, [$FFDF]
	xor b
	jr z, UnknownRJump_0x5891D
	ld a, 4
	ldh [$FFDF], a
	ldh a, [$FFE9]
	inc a
	ldh [$FFE9], a
	ld b, a
	ld a, 3
	sub b
	ldh [$FFE9], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret

UnknownRJump_0x5891D:
	ldh a, [$FFE9]
	inc a
	ldh [$FFE9], a
	ldh a, [$FFDF]
	add 2
	ldh [$FFDF], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x58932
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0x58932:
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFEA]
	cp $03
	jr nc, UnknownRJump_0x5894B
	inc a
	ldh [$FFEA], a
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	ld b, 4
	call UnknownCall_0x3D22
	ret

UnknownRJump_0x5894B:
	cp $06
	jr z, UnknownRJump_0x5895D
	inc a
	ldh [$FFEA], a
	ldh a, [$FFDB]
	dec a
	ldh [$FFDB], a
	ld b, 4
	call UnknownCall_0x3D32
	ret

UnknownRJump_0x5895D:
	xor a
	ldh [$FFEA], a
	ld a, 8
	ldh [$FFEC], a
	ldh a, [$FFDF]
	sub 2
	ldh [$FFDF], a
	ldh a, [$FFE9]
	cp $03
	jp z, UnknownJump_0x588E2
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x5897B
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0x5897B:
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFEA]
	cp $03
	jr nc, UnknownRJump_0x58994
	inc a
	ldh [$FFEA], a
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	ld b, 4
	call UnknownCall_0x3D32
	ret

UnknownRJump_0x58994:
	cp $06
	jr z, UnknownRJump_0x5895D
	inc a
	ldh [$FFEA], a
	ldh a, [$FFDB]
	dec a
	ldh [$FFDB], a
	ld b, 4
	call UnknownCall_0x3D22
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x589BA
	ld a, 32
	ldh [$FFE2], a
	call UnknownCall_0x5B4B4
	cp $40
	ret nc
	ld a, 5
	ldh [$FFDF], a
	ret

UnknownRJump_0x589BA:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x589BE:
INCBIN "baserom.gb", $589BE, $589CA - $589BE

	call UnknownCall_0x5B521
	ldh a, [$FFF0]
	and $01
	jr nz, UnknownRJump_0x589E7
	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3C30
	ld a, [$AF2F]
	bit 1, a
	ret z

UnknownData_0x589E1:
INCBIN "baserom.gb", $589E1, $589E7 - $589E1


UnknownRJump_0x589E7:
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	ret nz

UnknownData_0x589F0:
INCBIN "baserom.gb", $589F0, $589F7 - $589F0

	call UnknownCall_0x5B521
	ldh a, [$FFF0]
	and $01
	jr nz, UnknownRJump_0x589E7
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3BCC
	ld a, [$AF2F]
	bit 0, a
	ret z

UnknownData_0x58A0E:
INCBIN "baserom.gb", $58A0E, $58A3D - $58A0E

	call UnknownCall_0x5B521
	ldh a, [$FFEA]
	inc a
	ldh [$FFEA], a
	cp $20
	ret nz
	xor a
	ldh [$FFEA], a
	ld a, 6
	ldh [$FFDF], a
	ret
	ldh a, [$FFF0]
	and $07
	ret nz
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	cp $3E
	ret nz
	call UnknownCall_0x5B3C6
	ld a, 77
	ldh [$FFE2], a
	ldh a, [$FFE7]
	bit 3, a
	ret z
	ld a, 8
	call UnknownCall_0x3D10
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58A76
	jr UnknownRJump_0x58ABE

UnknownRJump_0x58A76:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x58A7A:
INCBIN "baserom.gb", $58A7A, $58A82 - $58A7A

	call UnknownCall_0x5B68B
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x58A96
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 64
	ldh [$FFDB], a
	ld a, 76
	ldh [$FFE2], a

UnknownRJump_0x58A96:
	call UnknownCall_0x5B5E6
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh_a_n $04
	and $3F
	jr z, UnknownRJump_0x58ABE
	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3C1C
	ld a, [$AF2F]
	bit 1, a
	ret z
	ld a, 2
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret

UnknownRJump_0x58ABE:
	call UnknownCall_0x5B3C6
	ldh a, [$FFDF]
	add 2
	ldh [$FFDF], a
	ld a, 68
	ldh [$FFDB], a
	xor a
	ldh [$FFDE], a
	ld a, 77
	ldh [$FFE2], a
	ret
	call UnknownCall_0x5B68B
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x58AE7

UnknownData_0x58ADB:
INCBIN "baserom.gb", $58ADB, $58AE7 - $58ADB


UnknownRJump_0x58AE7:
	call UnknownCall_0x5B5E6
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh_a_n $04
	and $3F
	jr z, UnknownRJump_0x58ABE
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3BB8
	ld a, [$AF2F]
	bit 0, a
	ret z
	ld a, 1
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret
	call UnknownCall_0x5B521
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFE9]
	inc a
	ldh [$FFE9], a
	cp $28
	jr z, UnknownRJump_0x58B21
	ret

UnknownRJump_0x58B21:
	xor a
	ldh [$FFE9], a
	ldh [$FFEA], a
	ldh a, [$FFDF]
	sub 2
	ldh [$FFDF], a
	ld a, 36
	ldh [$FFEC], a
	ret

UnknownData_0x58B31:
INCBIN "baserom.gb", $58B31, $58B43 - $58B31

	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58B50
	call UnknownCall_0x5B3C6
	ld a, 77
	ldh [$FFE2], a
	ret

UnknownRJump_0x58B50:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x58B54:
INCBIN "baserom.gb", $58B54, $58B58 - $58B54

	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x58B66
	call UnknownCall_0x5B5B6
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz

UnknownRJump_0x58B66:
	call UnknownCall_0x5B5B4
	ldh a, [$FFF0]
	and $01
	ret nz
	call UnknownCall_0x5B451
	call UnknownCall_0x3D22

UnknownRJump_0x58B74:
	ld b, 1
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x58B80
	call UnknownCall_0x3D3D
	jr UnknownRJump_0x58B83

UnknownRJump_0x58B80:
	call UnknownCall_0x3D2D

UnknownRJump_0x58B83:
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	call UnknownCall_0x5B3C6
	call UnknownCall_0x5B41A
	dec a
	jr z, UnknownRJump_0x58B95
	ld a, 1

UnknownRJump_0x58B95:
	ldh [$FFE8], a
	ld a, 40
	ldh [$FFEC], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x58BAA
	call UnknownCall_0x5B5B6
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz

UnknownRJump_0x58BAA:
	call UnknownCall_0x5B5B4
	ldh a, [$FFF0]
	and $01
	ret nz
	call UnknownCall_0x5B451
	call UnknownCall_0x3D32
	jr UnknownRJump_0x58B74
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58BDC
	ld a, 32
	ldh [$FFE2], a
	call UnknownCall_0x5B407
	ld a, 44
	ldh [$FFE8], a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58BDC
	ld a, 32
	ldh [$FFE2], a
	call UnknownCall_0x5B407
	ld a, 20
	ldh [$FFE8], a
	ret

UnknownRJump_0x58BDC:
	dec a
	rst $28

UnknownData_0x58BDE:
INCBIN "baserom.gb", $58BDE, $58BE6 - $58BDE

	ldh a, [$FFE8]
	ld c, a
	ld b, 1
	call UnknownCall_0x3D2D
	call UnknownCall_0x3D10
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 4
	ldh [$FFDF], a
	ret
	ldh a, [$FFE8]
	ld c, a
	ld b, 1
	call UnknownCall_0x3D3D
	call UnknownCall_0x3CDF
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 3
	ldh [$FFDF], a
	ret
	ld b, 1
	call UnknownCall_0x3D2D
	call UnknownCall_0x3D10

UnknownRJump_0x58C22:
	ldh a, [$FFE8]
	add a
	ld c, a
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	xor $07
	ldh [$FFDF], a
	ret
	ld b, 1
	call UnknownCall_0x3D3D
	call UnknownCall_0x3CDF
	jr UnknownRJump_0x58C22
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58C7B
	ld a, 32
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 60
	ldh [$FFE8], a
	ret
	call UnknownCall_0x5B51A
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58C7B
	ld a, 32
	ldh [$FFE2], a
	ld a, 16
	ldh [$FFDE], a
	call UnknownCall_0x5B3C6
	ld a, 36
	ldh [$FFE8], a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58C7B
	ld a, 32
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 36
	ldh [$FFE8], a
	ret

UnknownRJump_0x58C7B:
	dec a
	rst $28

UnknownData_0x58C7D:
INCBIN "baserom.gb", $58C7D, $58C85 - $58C7D

	ldh a, [$FFE8]
	ld c, a
	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3CF1
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 4
	ldh [$FFDF], a
	ret
	ldh a, [$FFE8]
	ld c, a
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3CC0
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 3
	ldh [$FFDF], a
	ret
	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3CF1

UnknownRJump_0x58CC1:
	ldh a, [$FFE8]
	add a
	ld c, a
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	xor $07
	ldh [$FFDF], a
	ret
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3CC0
	jr UnknownRJump_0x58CC1
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58CF4
	ld a, 32
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 24
	ldh [$FFE8], a
	add a
	ldh [$FFE9], a
	ret

UnknownRJump_0x58CF4:
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x58CFD:
INCBIN "baserom.gb", $58CFD, $58D01 - $58CFD

	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3CF1
	ld b, 1
	call UnknownCall_0x3D3D
	call UnknownCall_0x3CDF

UnknownRJump_0x58D11:
	ldh a, [$FFE8]
	dec a
	ldh [$FFE8], a
	ret nz
	ldh a, [$FFE9]
	ldh [$FFE8], a
	ldh a, [$FFDF]
	xor $03
	ldh [$FFDF], a
	ret
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3CC0
	ld b, 1
	call UnknownCall_0x3D2D
	call UnknownCall_0x3D10
	jr UnknownRJump_0x58D11
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58D45
	ld a, 32
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 24
	ldh [$FFE8], a
	ret

UnknownRJump_0x58D45:
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x58D4E:
INCBIN "baserom.gb", $58D4E, $58D78 - $58D4E

	ldh a, [$FFE8]
	ld c, a
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3CC0
	ld b, 1
	call UnknownCall_0x3D3D
	call UnknownCall_0x3CDF
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 3
	ldh [$FFDF], a
	ret
	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3CF1
	ld b, 1
	call UnknownCall_0x3D2D
	call UnknownCall_0x3D10

UnknownRJump_0x58DAA:
	ldh a, [$FFE8]
	add a
	ld c, a
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	xor $07
	ldh [$FFDF], a
	ret
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3CC0
	ld b, 1
	call UnknownCall_0x3D3D
	call UnknownCall_0x3CDF
	jr UnknownRJump_0x58DAA
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58DDF
	ld a, 32
	ldh [$FFE2], a
	ld a, 2
	ldh [$FFDF], a
	ret

UnknownRJump_0x58DDF:
	dec a
	rst $28

UnknownData_0x58DE1:
INCBIN "baserom.gb", $58DE1, $58DE5 - $58DE1

	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x58DEE
	dec a
	ldh [$FFEC], a
	ret nz

UnknownRJump_0x58DEE:
	call UnknownCall_0x5B451
	call UnknownCall_0x3D3D
	call UnknownCall_0x3CDF
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	ret z
	call UnknownCall_0x5B2D7
	ret
	ldh a, [$FFE7]
	bit 3, a
	ret z
	ld a, 1
	ldh [$FFDF], a
	ld a, 28
	ldh [$FFEC], a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58E30
	ld a, 32
	ldh [$FFE2], a
	ld a, 3
	ldh [$FFDF], a
	ret
	ldh a, [$FFE7]
	bit 3, a
	ret z
	ld a, 1
	ldh [$FFDF], a
	ld a, 64
	ldh [$FFE8], a
	ldh [$FFE9], a
	ret

UnknownRJump_0x58E30:
	dec a
	rst $28

UnknownData_0x58E32:
INCBIN "baserom.gb", $58E32, $58E38 - $58E32


UnknownJump_0x58E38:
	ldh a, [$FFE7]
	bit 3, a
	jr z, UnknownRJump_0x58E4E
	ldh a, [$FFE8]
	and a
	ret z
	dec a
	ldh [$FFE8], a
	ld b, 1
	call UnknownCall_0x3D2D
	call UnknownCall_0x3D10
	ret

UnknownRJump_0x58E4E:
	ld a, 2
	ldh [$FFDF], a
	ld a, 16
	ldh [$FFEC], a
	ret

UnknownJump_0x58E57:
	ldh a, [$FFE7]
	bit 3, a
	jr nz, UnknownRJump_0x58E76
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x58E66
	dec a
	ldh [$FFEC], a
	ret nz

UnknownRJump_0x58E66:
	ldh a, [$FFE9]
	ld c, a
	ldh a, [$FFE8]
	cp c
	ret z
	inc a
	ldh [$FFE8], a
	ld b, 1
	call UnknownCall_0x3D3D
	ret

UnknownRJump_0x58E76:
	ld a, 1
	ldh [$FFDF], a
	xor a
	ldh [$FFEC], a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58E99
	ld b, 32
	call UnknownCall_0x3D2D
	call UnknownCall_0x5B3C6
	ld a, 32
	ldh [$FFE2], a
	ld a, 40
	ldh [$FFE9], a
	add a
	ldh [$FFE8], a
	ldh [$FFE0], a
	ret

UnknownRJump_0x58E99:
	dec a
	rst $28

UnknownData_0x58E9B:
INCBIN "baserom.gb", $58E9B, $58EA7 - $58E9B

	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3CF1
	ldh a, [$FFE9]
	dec a
	ldh [$FFE9], a
	ret nz
	ld a, 3
	ldh [$FFDF], a
	ldh a, [$FFE0]
	ldh [$FFE9], a
	ret

UnknownData_0x58EBE:
INCBIN "baserom.gb", $58EBE, $58EC8 - $58EBE

	ld b, 1
	call UnknownCall_0x3D3D
	call UnknownCall_0x3CDF
	ldh a, [$FFE8]
	dec a
	ldh [$FFE8], a
	ret nz
	ldh a, [$FFE0]
	ldh [$FFE8], a
	ldh a, [$FFDD]
	and a
	jr nz, UnknownRJump_0x58EE4
	ld a, 4
	ldh [$FFDF], a
	ret

UnknownRJump_0x58EE4:
UnknownData_0x58EE4:
INCBIN "baserom.gb", $58EE4, $58EE9 - $58EE4

	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3CC0
	ldh a, [$FFE9]
	dec a
	ldh [$FFE9], a
	ret nz
	ldh a, [$FFE0]
	ldh [$FFE9], a
	ldh a, [$FFDD]
	and a
	jr nz, UnknownRJump_0x58F05
	ld a, 5
	ldh [$FFDF], a
	ret

UnknownRJump_0x58F05:
UnknownData_0x58F05:
INCBIN "baserom.gb", $58F05, $58F0A - $58F05

	ld b, 1
	call UnknownCall_0x3D2D
	call UnknownCall_0x3D10
	ldh a, [$FFE8]
	dec a
	ldh [$FFE8], a
	ret nz
	ldh a, [$FFE0]
	ldh [$FFE8], a
	ldh a, [$FFDD]
	and a
	jr nz, UnknownRJump_0x58F26
	ld a, 6
	ldh [$FFDF], a
	ret

UnknownRJump_0x58F26:
UnknownData_0x58F26:
INCBIN "baserom.gb", $58F26, $58F2B - $58F26

	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3CF1
	ldh a, [$FFE9]
	dec a
	ldh [$FFE9], a
	ret nz

UnknownData_0x58F39:
INCBIN "baserom.gb", $58F39, $58F4C - $58F39

	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x58F5D
	call UnknownCall_0x5B3C6
	ld a, 77
	ldh [$FFE2], a
	ld a, 16
	ldh [$FFDE], a
	ret

UnknownRJump_0x58F5D:
	dec a
	rst $28

UnknownData_0x58F5F:
INCBIN "baserom.gb", $58F5F, $58F69 - $58F5F

	call UnknownCall_0x5B54C
	ldh a, [$FFF0]
	and $01
	jr nz, UnknownRJump_0x58FA5
	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3C1C
	ld a, [$AF2F]
	bit 1, a
	ret z

UnknownRJump_0x58F80:
	ld a, 5
	ldh [$FFDF], a
	ld a, 88
	ldh [$FFDB], a
	xor a
	ldh [$FFEA], a
	ret

UnknownData_0x58F8C:
INCBIN "baserom.gb", $58F8C, $58FA5 - $58F8C


UnknownRJump_0x58FA5:
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	ret nz
	jr UnknownRJump_0x58F80
	call UnknownCall_0x5B521
	ld b, 1
	call UnknownCall_0x3D2D
	ldh a, [$FFE8]
	inc a
	ldh [$FFE8], a
	cp $28
	ret nz

UnknownData_0x58FC0:
INCBIN "baserom.gb", $58FC0, $5902D - $58FC0

	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x59078

UnknownJump_0x59032:
	xor a
	ldh [$FFE2], a
	ldh [$FFDD], a
	ld a, 16
	ldh [$FFDE], a
	call UnknownCall_0x59136
	ld a, [$AF3E]
	and a
	ret nz
	ld d, 0
	ld hl, $5082
	add hl, de
	ld a, [hl]
	bit 7, a
	jr z, UnknownRJump_0x59056
	cpl
	inc a
	ld b, a
	call UnknownCall_0x3D2D
	jr UnknownRJump_0x5905A

UnknownRJump_0x59056:
	ld b, a
	call UnknownCall_0x3D3D

UnknownRJump_0x5905A:
	ld hl, $508A
	add hl, de
	ld a, [hl]
	bit 7, a
	jr z, UnknownRJump_0x5906B
	cpl
	inc a
	ld b, a
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5906F

UnknownRJump_0x5906B:
	ld b, a
	call UnknownCall_0x3D32

UnknownRJump_0x5906F:
	ld a, 3
	ldh [$FFDF], a
	ld a, 48
	ldh [$FFEC], a
	ret

UnknownRJump_0x59078:
	dec a
	rst $28

UnknownData_0x5907A:
INCBIN "baserom.gb", $5907A, $59092 - $5907A

	call UnknownCall_0x5B518
	ldh a, [$FFF0]
	and $03
	ret nz
	call UnknownCall_0x590E9
	ld a, 3
	sub b
	ld b, a
	call UnknownCall_0x3D22
	call UnknownCall_0x5B3C6
	ret
	call UnknownCall_0x5B518
	ldh a, [$FFF0]
	and $03
	ret nz
	call UnknownCall_0x590E9
	ld a, 3
	sub b
	ld b, a
	call UnknownCall_0x3D32
	call UnknownCall_0x5B3C6
	ret
	call UnknownCall_0x5B511
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 4
	ldh [$FFDF], a
	ld a, 82
	ldh [$FFE2], a
	ld a, 110
	ldh [$FFDB], a
	ld a, 24
	ldh [$FFEC], a
	ret
	call UnknownCall_0x5B51A
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	call UnknownCall_0x5B3C6
	ld a, 8
	ldh [$FFE8], a
	ret

UnknownCall_0x590E9:
	call UnknownCall_0x5B41A
	ld hl, $FFE8
	ld a, [$AF2C]
	inc a
	jr z, UnknownRJump_0x59100
	ld hl, $FFE8
	ld a, [hl]
	cp $10
	jr z, UnknownRJump_0x5910A
	inc [hl]
	jr UnknownRJump_0x59105

UnknownRJump_0x59100:
	ld a, [hl]
	and a
	jr z, UnknownRJump_0x59116
	dec [hl]

UnknownRJump_0x59105:
	ld a, [hl]
	cp $08
	jr c, UnknownRJump_0x59116

UnknownRJump_0x5910A:
	ld e, a
	ld d, 0
	ld hl, $5125
	add hl, de
	ld b, [hl]
	call UnknownCall_0x3D3D
	ret

UnknownRJump_0x59116:
	ld e, a
	ld d, 0
	ld hl, $5125
	add hl, de
	ld a, [hl]
	cpl
	inc a
	ld b, a
	call UnknownCall_0x3D2D
	ret

UnknownData_0x59125:
INCBIN "baserom.gb", $59125, $59136 - $59125


UnknownCall_0x59136:
	ld hl, $AF4E
	xor a
	ld [hl], a
	ldh_a_n $04
	and $07
	ld e, a
	ld [$AF4F], a
	ld d, a
	inc d
	ld a, 8
	ld b, a
	sub e
	ld c, a
	ldh a, [$FFEF]

UnknownRJump_0x5914D:
	rrca
	inc [hl]
	dec d
	jr nz, UnknownRJump_0x5914D
	jr nc, UnknownRJump_0x59166

UnknownData_0x59154:
INCBIN "baserom.gb", $59154, $59166 - $59154


UnknownRJump_0x59166:
	dec b
	set 7, a
	ld d, a
	ld a, b
	add c
	ld b, a
	ld a, d

UnknownRJump_0x5916E:
	rrca
	inc [hl]
	dec b
	jr nz, UnknownRJump_0x5916E
	ldh [$FFEF], a
	ld a, e
	and $07
	ld e, a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x59189
	ld a, 16
	ldh [$FFDE], a
	call UnknownCall_0x5B31D
	jp UnknownJump_0x581B9

UnknownJump_0x59189:
UnknownRJump_0x59189:
	dec a
	rst $28

UnknownData_0x5918B:
INCBIN "baserom.gb", $5918B, $5918F - $5918B

	call UnknownCall_0x5B451
	call UnknownCall_0x3D3D
	ldh a, [$FFD9]
	cp $A0
	ret c
	ldh a, [$FFD5]
	dec a
	ldh [$FFD5], a
	call UnknownCall_0x5B2BF
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x591CC
	call UnknownCall_0x5B511
	ld a, 32
	ldh [$FFE2], a
	ld a, 16
	ldh [$FFDE], a
	ldh a, [$FFE7]
	bit 3, a
	ret z
	ld a, 1
	ldh [$FFDF], a
	ld a, 96
	ldh [$FFE8], a
	ldh [$FFE9], a
	ld a, 98
	ldh [$FFDB], a
	ld a, 22
	ld [$A470], a
	ret

UnknownRJump_0x591CC:
	dec a
	rst $28

UnknownData_0x591CE:
INCBIN "baserom.gb", $591CE, $591D2 - $591CE

	call UnknownCall_0x5B5B6
	jp UnknownJump_0x58E38
	call UnknownCall_0x5B5B6
	jp UnknownJump_0x58E57
	call UnknownCall_0x5B5B6
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x591EF
	ld a, 77
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ret

UnknownRJump_0x591EF:
	dec a
	rst $28

UnknownData_0x591F1:
INCBIN "baserom.gb", $591F1, $591F3 - $591F1

	ld b, 1
	call UnknownCall_0x3D22
	ret
	call UnknownCall_0x5B521
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5920D
	ld a, 86
	ldh [$FFE2], a
	ld a, 16
	ldh [$FFDE], a
	call UnknownCall_0x5B407
	ret

UnknownRJump_0x5920D:
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x59216:
INCBIN "baserom.gb", $59216, $5921E - $59216

	call UnknownCall_0x5B481
	call UnknownCall_0x3D2D

UnknownRJump_0x59224:
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	add 2
	ldh [$FFDF], a
	ret
	call UnknownCall_0x5B481
	call UnknownCall_0x3D3D
	jr UnknownRJump_0x59224
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x59243

UnknownData_0x5923F:
INCBIN "baserom.gb", $5923F, $59243 - $5923F


UnknownRJump_0x59243:
	call UnknownCall_0x5B449
	call UnknownCall_0x3D3D

UnknownRJump_0x59249:
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	cp $04
	jr z, UnknownRJump_0x5925A
	dec a
	ldh [$FFDF], a
	ret

UnknownRJump_0x5925A:
	ld a, 1
	ldh [$FFDF], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x59268

UnknownData_0x59264:
INCBIN "baserom.gb", $59264, $59268 - $59264


UnknownRJump_0x59268:
	call UnknownCall_0x5B449
	call UnknownCall_0x3D2D
	jr UnknownRJump_0x59249
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x59285
	ld a, 32
	ldh [$FFE2], a
	ld a, 16
	ldh [$FFDE], a
	call UnknownCall_0x5B3C6
	ld a, 20
	ldh [$FFE8], a
	ret

UnknownRJump_0x59285:
	call UnknownCall_0x5B5B6
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5928C:
INCBIN "baserom.gb", $5928C, $59298 - $5928C

	ldh a, [$FFE8]
	ld c, a
	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3CF1
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 1
	call UnknownCall_0x3D3D
	call UnknownCall_0x3CDF
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 3
	ldh [$FFDF], a
	ret
	ldh a, [$FFE8]
	ld c, a
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3CC0
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 1
	call UnknownCall_0x3D3D
	call UnknownCall_0x3CDF
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 5
	ldh [$FFDF], a
	ret
	ld b, 1
	call UnknownCall_0x3D2D
	call UnknownCall_0x3D10

UnknownRJump_0x592EE:
	ldh a, [$FFE8]
	add a
	ld c, a
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	bit 0, a
	ret nz
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3CC0
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 1
	call UnknownCall_0x3D3D
	call UnknownCall_0x3CDF
	jr UnknownRJump_0x592EE
	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3CF1
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 1
	call UnknownCall_0x3D3D
	call UnknownCall_0x3CDF
	ldh a, [$FFE8]
	add a
	ld c, a
	ldh a, [$FFE0]
	inc a
	ldh [$FFE0], a
	cp c
	ret nz

UnknownData_0x59342:
INCBIN "baserom.gb", $59342, $5934A - $59342

	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x59352
	jp UnknownJump_0x59032

UnknownRJump_0x59352:
	dec a
	rst $28

UnknownData_0x59354:
INCBIN "baserom.gb", $59354, $5935C - $59354

	call UnknownCall_0x5B511
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 4
	ldh [$FFDF], a

UnknownJump_0x59369:
	ld a, 82
	ldh [$FFE2], a
	ld a, 112
	ldh [$FFDB], a
	ld a, 48
	ldh [$FFEC], a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5938C
	xor a
	ldh [$FFE2], a
	ld a, 16
	ldh [$FFDE], a
	ld a, 1
	ldh [$FFDF], a
	ld a, 1
	ld [$A478], a
	ret

UnknownRJump_0x5938C:
	dec a
	rst $28

UnknownData_0x5938E:
INCBIN "baserom.gb", $5938E, $59394 - $5938E

	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	jr nz, UnknownRJump_0x593A5
	call UnknownCall_0x5B451
	call UnknownCall_0x3D3D
	ret

UnknownRJump_0x593A5:
	ld a, 2
	ldh [$FFDF], a
	ld a, 128
	ldh [$FFEC], a
	ret
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 3
	ldh [$FFDF], a
	ld a, 64
	ldh [$FFEC], a
	call UnknownCall_0x5B539
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 62
	ldh [$FFD5], a
	call UnknownCall_0x3AA0
	call UnknownCall_0x5B3C6
	ld a, 8
	ldh [$FFE8], a
	ld a, 16
	ldh [$FFDE], a
	jp UnknownJump_0x59369
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x593F2
	ld a, 16
	ldh [$FFDE], a
	ld a, 72
	ldh [$FFE2], a
	call UnknownCall_0x5B4B4
	cp $30
	ret nc
	ld a, 1
	ldh [$FFDF], a
	ret

UnknownRJump_0x593F2:
	dec a
	rst $28

UnknownData_0x593F4:
INCBIN "baserom.gb", $593F4, $593F8 - $593F4

	call UnknownCall_0x5B518

UnknownJump_0x593FB:
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	jr nz, UnknownRJump_0x5940D
	call UnknownCall_0x5B451
	inc b
	call UnknownCall_0x3D3D
	ret

UnknownRJump_0x5940D:
	xor a
	ldh [$FFE0], a
	ld a, 2
	ldh [$FFDF], a
	ld a, 10
	ld [$A470], a
	ret
	call UnknownCall_0x5B51A
	call UnknownCall_0x3B7C
	ld a, [$AF2F]
	bit 2, a
	jr nz, UnknownRJump_0x5942D
	ld b, 1
	call UnknownCall_0x3D2D
	ret

UnknownRJump_0x5942D:
	xor a
	ldh [$FFDF], a
	ret
	call UnknownCall_0x5B511
	ldh a, [$FFDF]
	dec a
	jp z, UnknownJump_0x582FB
	dec a
	jp z, UnknownJump_0x5831A
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	jr nz, UnknownRJump_0x5944F

UnknownData_0x59448:
INCBIN "baserom.gb", $59448, $5944F - $59448


UnknownRJump_0x5944F:
	xor a
	ldh [$FFE0], a
	call UnknownCall_0x5B3C6
	ld a, 77
	ldh [$FFE2], a
	ret
	call UnknownCall_0x5B511
	ldh a, [$FFDF]
	dec a
	jp z, UnknownJump_0x582FB
	dec a
	jp z, UnknownJump_0x5831A
	ld a, 16
	ldh [$FFDE], a
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	jr nz, UnknownRJump_0x5947C

UnknownData_0x59475:
INCBIN "baserom.gb", $59475, $5947C - $59475


UnknownRJump_0x5947C:
	xor a
	ldh [$FFE0], a
	call UnknownCall_0x5B3C6
	ld a, 72
	ldh [$FFE2], a
	ret
	call UnknownCall_0x5B5DF
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5949E
	ld a, 1
	ldh [$FFDF], a
	ld a, 77
	ldh [$FFE2], a
	ld a, 128
	ldh [$FFDC], a
	ldh [$FFEC], a
	ret

UnknownRJump_0x5949E:
	dec a
	rst $28

UnknownData_0x594A0:
INCBIN "baserom.gb", $594A0, $594A4 - $594A0

	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x594AD
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0x594AD:
UnknownData_0x594AD:
INCBIN "baserom.gb", $594AD, $594EB - $594AD

	call UnknownCall_0x5B585
	ldh a, [$FFDF]
	and a
	jp nz, UnknownJump_0x582F5
	ld a, 82
	ldh [$FFE2], a
	jp UnknownJump_0x582DD
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5950C
	xor a
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ld a, 48
	ldh [$FFEC], a
	ret

UnknownRJump_0x5950C:
	dec a
	rst $28

UnknownData_0x5950E:
INCBIN "baserom.gb", $5950E, $59512 - $5950E

	call UnknownCall_0x5B521
	call UnknownCall_0x5B68B
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 2
	ldh [$FFDF], a
	ld a, 16
	ldh [$FFDE], a
	ld a, 72
	ldh [$FFE2], a
	ld a, 130
	ldh [$FFDB], a
	ld a, 13
	ld [$A470], a
	ret
	call UnknownCall_0x5B5A6
	ldh a, [$FFDB]
	cp $84
	ret nz
	ld a, 1
	ld [$AF26], a
	call UnknownCall_0x5B2D7
	ret
	ldh a, [$FFF0]
	and $03
	ret nz
	call UnknownCall_0x5B3E0
	ld hl, $A22B
	ld a, [$AF2C]
	cp [hl]
	jr nz, UnknownRJump_0x5957F
	ldh a, [$FFDF]
	dec a
	jr z, UnknownRJump_0x59587
	dec a
	jr z, UnknownRJump_0x5959D
	ld a, 13
	ldh [$FFDB], a
	ld a, 32
	ldh [$FFDD], a
	ld a, [$AF2C]
	cp $01
	jr z, UnknownRJump_0x59572
	xor a
	ldh [$FFDD], a
	ld a, 2

UnknownRJump_0x59572:
	ldh [$FFDF], a
	ld a, 8
	ldh [$FFE8], a
	ldh [$FFE9], a
	ld a, 72
	ldh [$FFE2], a
	ret

UnknownRJump_0x5957F:
	ld a, 14
	ldh [$FFDB], a
	xor a
	ldh [$FFDF], a
	ret

UnknownRJump_0x59587:
	call UnknownCall_0x590E9
	ldh a, [$FFE9]
	ld e, a
	ld d, 0
	ld b, 1
	call UnknownCall_0x3D32
	ld hl, $FFE9
	ld a, [hl]
	cp $10
	ret z
	inc [hl]
	ret

UnknownRJump_0x5959D:
	call UnknownCall_0x590E9
	ldh a, [$FFE9]
	ld e, a
	ld d, 0
	ld b, 1
	call UnknownCall_0x3D22
	ld hl, $FFE9
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x595CF
	ld a, 72
	ldh [$FFE2], a
	call UnknownCall_0x5B4B4
	cp $38
	ret nc
	ld a, 1
	ldh [$FFDF], a
	ld a, 16
	ldh [$FFEC], a
	ld a, 21
	ld [$A470], a
	ret

UnknownRJump_0x595CF:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x595D3:
INCBIN "baserom.gb", $595D3, $595D7 - $595D3

	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	jr z, UnknownRJump_0x595F0
	ld b, 3
	ldh a, [$FFE9]
	xor $01
	ldh [$FFE9], a
	jr nz, UnknownRJump_0x595EC
	call UnknownCall_0x3D22
	ret

UnknownRJump_0x595EC:
	call UnknownCall_0x3D32
	ret

UnknownRJump_0x595F0:
	ld a, 2
	ldh [$FFDF], a
	ret
	call UnknownCall_0x5B451
	sla b
	call UnknownCall_0x3D3D
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x59619
	ld a, 72
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ld b, 4
	call UnknownCall_0x3D22
	ld a, 64
	ldh [$FFE8], a
	ld a, 32
	ldh [$FFEC], a
	ret

UnknownRJump_0x59619:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5961D:
INCBIN "baserom.gb", $5961D, $59621 - $5961D

	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x59633
	call UnknownCall_0x5B68B
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 16
	ldh [$FFDE], a

UnknownRJump_0x59633:
	ld b, 2
	call UnknownCall_0x3D3D
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz

UnknownRJump_0x5963E:
	ld a, 64
	ldh [$FFE8], a
	ld a, 32
	ldh [$FFEC], a
	ldh a, [$FFDF]
	xor $03
	ldh [$FFDF], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x5965F
	call UnknownCall_0x5B68B
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 16
	ldh [$FFDE], a

UnknownRJump_0x5965F:
	ld b, 2
	call UnknownCall_0x3D2D
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	jr UnknownRJump_0x5963E

UnknownData_0x5966C:
INCBIN "baserom.gb", $5966C, $596D9 - $5966C

	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x596E6
	ld a, 77
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ret

UnknownRJump_0x596E6:
	dec a
	rst $28

UnknownData_0x596E8:
INCBIN "baserom.gb", $596E8, $596EE - $596E8

	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x596F7
	dec a
	ldh [$FFEC], a
	ret nz

UnknownRJump_0x596F7:
	ld a, 43
	ldh [$FFDB], a
	ld a, 44
	ld [$AF37], a
	ldh a, [$FFDD]
	ld [$AF38], a
	ld a, 82
	ld [$AF36], a
	call UnknownCall_0x5B36D
	ld a, 16
	ldh [$FFEC], a
	ld a, 3
	ldh [$FFDF], a
	ret
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 42
	ldh [$FFDB], a
	call UnknownCall_0x5B3C6
	ld a, 96
	ldh [$FFEC], a
	ret
	ldh a, [$FFDF]
	dec a
	jr z, UnknownRJump_0x5973D
	dec a
	jr z, UnknownRJump_0x59750
	ld a, 77
	ldh [$FFE2], a
	call UnknownCall_0x3CB1
	ld a, 11
	ld [$A478], a
	ret

UnknownRJump_0x5973D:
	call UnknownCall_0x5B5B6
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 2
	call UnknownCall_0x3D22
	ld b, 1
	call UnknownCall_0x3D2D
	ret

UnknownRJump_0x59750:
	call UnknownCall_0x5B5B6
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 2
	call UnknownCall_0x3D32
	ld b, 1
	call UnknownCall_0x3D2D
	ret
	call UnknownCall_0x5B57E
	ldh a, [$FFDF]
	and a
	jp nz, UnknownJump_0x58215
	call UnknownCall_0x5B3C6
	ld a, 77
	ldh [$FFE2], a
	ret
	ldh a, [$FFDF]
	dec a
	jr z, UnknownRJump_0x59795
	dec a
	jr z, UnknownRJump_0x597A9
	dec a
	jr z, UnknownRJump_0x59788
	ld a, 77
	ldh [$FFE2], a
	ld a, 3
	ldh [$FFDF], a
	ret

UnknownRJump_0x59788:
	call UnknownCall_0x5B678
	call UnknownCall_0x5B4B4
	cp $30
	ret nc
	call UnknownCall_0x5B3C6
	ret

UnknownRJump_0x59795:
	call UnknownCall_0x5B585
	call UnknownCall_0x3C58
	ld a, [$AF2F]
	bit 1, a
	jp nz, UnknownJump_0x59D2D
	ld b, 2
	call UnknownCall_0x3D22
	ret

UnknownRJump_0x597A9:
	call UnknownCall_0x5B585
	call UnknownCall_0x3BF4
	ld a, [$AF2F]
	bit 0, a
	jp nz, UnknownJump_0x59D2D
	ld b, 2
	call UnknownCall_0x3D32
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x597D2
	ld a, 72
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 1
	ldh [$FFE8], a
	ld a, 1
	ldh [$FFE9], a
	ret

UnknownRJump_0x597D2:
	call UnknownCall_0x5B57E
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x597DE:
INCBIN "baserom.gb", $597DE, $597EE - $597DE

	call UnknownCall_0x598CE
	ld hl, $594E
	call UnknownCall_0x5990E
	ld hl, $FFE9
	inc [hl]
	ld a, [hl]
	cp $15
	ret nz
	ld [hl], 1
	ld a, 3
	ldh [$FFDF], a
	ret
	call UnknownCall_0x598F5
	ld hl, $5964
	call UnknownCall_0x5990E
	ld hl, $FFE9
	inc [hl]
	ld a, [hl]
	cp $15
	ret nz
	ld [hl], 1
	ld a, 5
	ldh [$FFDF], a
	xor a
	ldh [$FFEA], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret
	call UnknownCall_0x59919
	ld hl, $5990
	call UnknownCall_0x598EA
	ld hl, $FFE9
	inc [hl]
	ld a, [hl]
	cp $15
	ret nz

UnknownData_0x59838:
INCBIN "baserom.gb", $59838, $598CE - $59838


UnknownCall_0x598CE:
	ld hl, $5938
	call UnknownCall_0x598DF
	ld hl, $FFE8
	inc [hl]
	ld a, [hl]
	cp $15
	ret nz
	ld [hl], 20
	ret

UnknownCall_0x598DF:
	ldh a, [$FFE8]
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	call UnknownCall_0x3D2D
	ret

UnknownCall_0x598EA:
	ldh a, [$FFE9]
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	call UnknownCall_0x3D32
	ret

UnknownCall_0x598F5:
	ld hl, $5938
	call UnknownCall_0x59903
	ld hl, $FFE8
	dec [hl]
	ret nz
	ld [hl], 1
	ret

UnknownCall_0x59903:
	ldh a, [$FFE8]
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	call UnknownCall_0x3D3D
	ret

UnknownCall_0x5990E:
	ldh a, [$FFE9]
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	call UnknownCall_0x3D22
	ret

UnknownCall_0x59919:
	ld hl, $597A
	call UnknownCall_0x59903
	ld hl, $FFE8
	inc [hl]
	ld a, [hl]
	cp $15
	ret nz

UnknownData_0x59927:
INCBIN "baserom.gb", $59927, $599A6 - $59927

	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x599B4
	ld a, 77
	ldh [$FFE2], a
	ld a, 5
	ldh [$FFDF], a
	ret

UnknownRJump_0x599B4:
	dec a
	rst $28

UnknownData_0x599B6:
INCBIN "baserom.gb", $599B6, $599C4 - $599B6

	ld b, 2
	call UnknownCall_0x3D2D
	ldh a, [$FFE8]
	add b
	ldh [$FFE8], a
	cp $40
	ret nz
	ld a, 9
	ldh [$FFE8], a
	ld a, 6
	ldh [$FFDF], a
	ret
	ld b, 3
	call UnknownCall_0x3D3D
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ld a, 7
	ldh [$FFDF], a
	ld a, 151
	ldh [$FFDB], a
	ret
	call UnknownCall_0x5B465
	call UnknownCall_0x3D3D
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	call UnknownCall_0x5B3C6
	ret

UnknownRJump_0x599FF:
	xor a
	ldh [$FFE8], a
	ldh [$FFE9], a
	ldh [$FFE0], a
	ld a, 5
	ldh [$FFDF], a
	ld a, 150
	ldh [$FFDB], a
	ret
	ld hl, $5A9D
	call UnknownCall_0x5B33E
	call UnknownCall_0x3D22
	ldh a, [$FFE9]
	inc a
	ldh [$FFE9], a

UnknownRJump_0x59A1D:
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	jr nz, UnknownRJump_0x599FF
	ld hl, $5A8D
	call UnknownCall_0x5B33A
	call UnknownCall_0x3D3D
	ldh a, [$FFE8]
	inc a
	ldh [$FFE8], a
	cp $10
	ret nz
	xor a
	ldh [$FFE8], a
	ld hl, $FFDF
	ld a, [hl]
	cp $03
	jr nc, UnknownRJump_0x59A4B
	add 2
	ld [hl], a
	ld hl, $FFE9
	dec [hl]
	ret

UnknownRJump_0x59A4B:
	cp $04
	jr z, UnknownRJump_0x59A55
	dec [hl]
	ld hl, $FFE9
	inc [hl]
	ret

UnknownRJump_0x59A55:
	ld a, 1
	ld [hl], a
	ld hl, $FFE9
	inc [hl]
	ret
	ld hl, $5A9D
	call UnknownCall_0x5B33E
	call UnknownCall_0x3D32
	ldh a, [$FFE9]
	inc a
	ldh [$FFE9], a
	jr UnknownRJump_0x59A1D
	ld hl, $5A9D
	call UnknownCall_0x5B33E
	call UnknownCall_0x3D32
	ldh a, [$FFE9]
	dec a
	ldh [$FFE9], a
	jr UnknownRJump_0x59A1D
	ld hl, $5A9D
	call UnknownCall_0x5B33E
	call UnknownCall_0x3D22
	ldh a, [$FFE9]
	dec a
	ldh [$FFE9], a
	jr UnknownRJump_0x59A1D

UnknownData_0x59A8D:
INCBIN "baserom.gb", $59A8D, $59AAD - $59A8D

	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x59ABA
	call UnknownCall_0x5B3C6
	ld a, 72
	ldh [$FFE2], a
	ret

UnknownRJump_0x59ABA:
	call UnknownCall_0x5B511
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x59AC6:
INCBIN "baserom.gb", $59AC6, $59ACA - $59AC6

	ld b, 1
	call UnknownCall_0x3D22
	jr UnknownRJump_0x59AD6
	ld b, 1
	call UnknownCall_0x3D32

UnknownRJump_0x59AD6:
	ldh a, [$FFE8]
	dec a
	jr z, UnknownRJump_0x59AE9
	dec a
	jr z, UnknownRJump_0x59AF1
	dec a
	jr z, UnknownRJump_0x59AF9
	call UnknownCall_0x5B46C
	call UnknownCall_0x3D2D
	jr UnknownRJump_0x59AFF

UnknownRJump_0x59AE9:
	call UnknownCall_0x5B445
	call UnknownCall_0x3D3D
	jr UnknownRJump_0x59AFF

UnknownRJump_0x59AF1:
	call UnknownCall_0x5B46C
	call UnknownCall_0x3D3D
	jr UnknownRJump_0x59AFF

UnknownRJump_0x59AF9:
	call UnknownCall_0x5B445
	call UnknownCall_0x3D2D

UnknownRJump_0x59AFF:
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFE8]
	inc a
	and $03
	ldh [$FFE8], a
	ret
	call UnknownCall_0x5B678
	ldh a, [$FFDF]
	and a
	jp nz, UnknownJump_0x58642
	call UnknownCall_0x5B3C6
	ld a, 77
	ldh [$FFE2], a
	ret
	call UnknownCall_0x5B51A
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x59B2F
	call UnknownCall_0x5B3C6
	ld a, 77
	ldh [$FFE2], a
	ret

UnknownRJump_0x59B2F:
	dec a
	rst $28

UnknownData_0x59B31:
INCBIN "baserom.gb", $59B31, $59B35 - $59B31

	ldh a, [$FFF0]
	and $01
	jr nz, UnknownRJump_0x59B73
	ld b, 2
	call UnknownCall_0x3D22
	call UnknownCall_0x3C1C
	ld a, [$AF2F]
	bit 1, a
	ret z

UnknownData_0x59B49:
INCBIN "baserom.gb", $59B49, $59B54 - $59B49

	ldh a, [$FFF0]
	and $01
	jr nz, UnknownRJump_0x59B73
	ld b, 2
	call UnknownCall_0x3D32
	call UnknownCall_0x3BB8
	ld a, [$AF2F]
	bit 0, a
	ret z

UnknownData_0x59B68:
INCBIN "baserom.gb", $59B68, $59B73 - $59B68


UnknownRJump_0x59B73:
	ldh a, [$FFE8]
	dec a
	jr z, UnknownRJump_0x59B94
	call UnknownCall_0x5B46C
	ldh a, [$FFE0]
	cp c
	jr z, UnknownRJump_0x59B8C
	call UnknownCall_0x3D2D
	call UnknownCall_0x3B7C
	ld a, [$AF2F]
	bit 2, a
	ret z

UnknownRJump_0x59B8C:
	xor a
	ldh [$FFE0], a
	ld a, 1
	ldh [$FFE8], a
	ret

UnknownRJump_0x59B94:
	call UnknownCall_0x5B451
	call UnknownCall_0x3D3D
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	ret z
	xor a
	ldh [$FFE0], a
	ldh [$FFE8], a
	ldh a, [$FFDF]
	xor $03
	ldh [$FFDF], a
	ret
	call UnknownCall_0x5B57E
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x59BBF
	ld a, 77
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ret

UnknownRJump_0x59BBF:
	dec a
	rst $28

UnknownData_0x59BC1:
INCBIN "baserom.gb", $59BC1, $59BC5 - $59BC1

	call UnknownCall_0x5B585
	ldh a, [$FFDF]
	rst $28

UnknownData_0x59BCB:
INCBIN "baserom.gb", $59BCB, $59BD1 - $59BCB

	ld a, 16
	ldh [$FFDE], a
	ld a, 78
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 1
	ldh [$FFEC], a
	ret
	ldh a, [$FFDF]
	rst $28

UnknownData_0x59BE4:
INCBIN "baserom.gb", $59BE4, $59BE8 - $59BE4

	ld a, 16
	ldh [$FFDE], a
	ld a, 1
	ldh [$FFDF], a
	ld a, 32
	ldh [$FFEC], a
	ret
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 1
	ld [$AF26], a
	call UnknownCall_0x5B2D7
	ret

UnknownJump_0x59C04:
	ldh a, [$FFD5]
	rst $28

UnknownData_0x59C07:
INCBIN "baserom.gb", $59C07, $59CE7 - $59C07

	call UnknownCall_0x5B51A
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x59CFF
	ld a, 16
	ldh [$FFDE], a
	ld a, 76
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 1
	ldh [$FFEC], a
	ret

UnknownRJump_0x59CFF:
	dec a
	rst $28

UnknownData_0x59D01:
INCBIN "baserom.gb", $59D01, $59D05 - $59D01

	call UnknownCall_0x3C1C
	ld a, [$AF2F]
	bit 1, a
	jr nz, UnknownRJump_0x59D2D
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x59D1D
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 48
	ldh [$FFE9], a
	ret

UnknownRJump_0x59D1D:
	ld b, 1
	call UnknownCall_0x3D22

UnknownRJump_0x59D22:
	ldh a, [$FFE9]
	dec a
	ldh [$FFE9], a
	ret nz
	ld a, 16
	ldh [$FFEC], a
	ret

UnknownJump_0x59D2D:
UnknownRJump_0x59D2D:
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a

UnknownJump_0x59D33:
	ldh a, [$FFDF]
	xor $03
	ldh [$FFDF], a
	ret

UnknownJump_0x59D3A:
	ld b, 1
	call UnknownCall_0x3D32
	jr UnknownRJump_0x59D22
	call UnknownCall_0x3BB8
	ld a, [$AF2F]
	bit 0, a
	jr nz, UnknownRJump_0x59D2D
	ldh a, [$FFEC]
	and a
	jp z, UnknownJump_0x59D3A
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 48
	ldh [$FFE9], a
	ret
	call UnknownCall_0x5B51A
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x59D6E
	ld a, 16
	ldh [$FFDE], a
	ld a, 72
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ret

UnknownRJump_0x59D6E:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x59D72:
INCBIN "baserom.gb", $59D72, $59D7A - $59D72

	call UnknownCall_0x3C44
	ld a, [$AF2F]
	bit 1, a
	jr nz, UnknownRJump_0x59D2D
	ld b, 1
	call UnknownCall_0x3D22
	jr UnknownRJump_0x59D9B
	call UnknownCall_0x3BE0
	ld a, [$AF2F]
	bit 0, a
	jp nz, UnknownJump_0x59D2D
	ld b, 1
	call UnknownCall_0x3D32

UnknownRJump_0x59D9B:
	call UnknownCall_0x5B4B4
	cp $24
	ret nc
	ldh a, [$FFDF]
	add 2
	ldh [$FFDF], a
	ret
	call UnknownCall_0x3C44
	ld a, [$AF2F]
	bit 1, a
	jr nz, UnknownRJump_0x59DF9
	ldh a, [$FFE9]
	and a
	jr nz, UnknownRJump_0x59DBF
	call UnknownCall_0x5B449
	call UnknownCall_0x3D22
	jr UnknownRJump_0x59DE4

UnknownRJump_0x59DBF:
	call UnknownCall_0x5B481
	call UnknownCall_0x3D22
	jr UnknownRJump_0x59DE4
	call UnknownCall_0x3BE0
	ld a, [$AF2F]
	bit 0, a
	jr nz, UnknownRJump_0x59DF9
	ldh a, [$FFE9]
	and a
	jr nz, UnknownRJump_0x59DDE
	call UnknownCall_0x5B449
	call UnknownCall_0x3D32
	jr UnknownRJump_0x59DE4

UnknownRJump_0x59DDE:
	call UnknownCall_0x5B481
	call UnknownCall_0x3D32

UnknownRJump_0x59DE4:
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFE9]
	xor $01
	ldh [$FFE9], a
	ret nz
	ldh a, [$FFDF]
	sub 2
	ldh [$FFDF], a
	ret

UnknownRJump_0x59DF9:
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ldh a, [$FFDF]
	xor $07
	ldh [$FFDF], a
	ret
	call UnknownCall_0x5B51A
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x59E1F
	ld a, 16
	ldh [$FFDE], a
	ld a, 76
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ld a, 48
	ldh [$FFE8], a
	ret

UnknownRJump_0x59E1F:
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x59E28:
INCBIN "baserom.gb", $59E28, $59E2C - $59E28

	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x59E35
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0x59E35:
	ld b, 1
	call UnknownCall_0x3D2D

UnknownRJump_0x59E3A:
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ld a, 48
	ldh [$FFE8], a
	ld a, 16
	ldh [$FFEC], a
	jp UnknownJump_0x59D33
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x59E54
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0x59E54:
	ld b, 1
	call UnknownCall_0x3D3D
	jr UnknownRJump_0x59E3A
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x59E70
	ld a, 16
	ldh [$FFDE], a
	ld a, 76
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 48
	ldh [$FFE9], a
	ret

UnknownRJump_0x59E70:
	dec a
	rst $28

UnknownData_0x59E72:
INCBIN "baserom.gb", $59E72, $59E7A - $59E72

	call UnknownCall_0x5B51A
	call UnknownCall_0x3C1C
	ld a, [$AF2F]
	bit 1, a
	jp nz, UnknownJump_0x59D2D
	ld b, 1
	call UnknownCall_0x3D22

UnknownRJump_0x59E8D:
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ld a, 48
	ldh [$FFE9], a
	ld a, 3
	ldh [$FFDF], a
	ld a, 53
	ldh [$FFDB], a
	ret
	call UnknownCall_0x5B51A
	call UnknownCall_0x3BB8
	ld a, [$AF2F]
	bit 0, a
	jp nz, UnknownJump_0x59D2D
	ld b, 1
	call UnknownCall_0x3D32
	jr UnknownRJump_0x59E8D
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFDB]
	cp $37
	jr z, UnknownRJump_0x59EC4
	inc a
	ldh [$FFDB], a
	ret

UnknownRJump_0x59EC4:
	call UnknownCall_0x3B7C
	ld a, [$AF2F]
	bit 2, a
	jr nz, UnknownRJump_0x59EDB
	ld b, 1
	call UnknownCall_0x3D2D
	ldh a, [$FFE8]
	add b
	ldh [$FFE8], a
	cp $20
	ret nz

UnknownRJump_0x59EDB:
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ret
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFDB]
	cp $35
	jr z, UnknownRJump_0x59EF0
	dec a
	ldh [$FFDB], a
	ret

UnknownRJump_0x59EF0:
	ld b, 1
	call UnknownCall_0x3D3D
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	call UnknownCall_0x5B3C6
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x59F17
	ld a, 16
	ldh [$FFDE], a
	ld a, 72
	ldh [$FFE2], a
	call UnknownCall_0x5B4B4
	cp $30
	ret nc
	ld a, 1
	ldh [$FFDF], a
	ret

UnknownRJump_0x59F17:
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x59F20:
INCBIN "baserom.gb", $59F20, $59F24 - $59F20

	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x59F2D
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0x59F2D:
	ld b, 8
	call UnknownCall_0x3D3D
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	cp $29
	ret nz
	ld a, 8
	ldh [$FFEC], a
	jp UnknownJump_0x59D33
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x59F4A
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0x59F4A:
	ld b, 8
	call UnknownCall_0x3D2D
	ldh a, [$FFDB]
	dec a
	ldh [$FFDB], a
	cp $25
	ret nz
	ld a, 8
	ldh [$FFEC], a
	jp UnknownJump_0x59D33
	call UnknownCall_0x5B51A
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x59F76
	ld a, 16
	ldh [$FFDE], a
	ld a, 72
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 48
	ldh [$FFE9], a
	ret

UnknownRJump_0x59F76:
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x59F7F:
INCBIN "baserom.gb", $59F7F, $59F83 - $59F7F

	ld b, 2
	call UnknownCall_0x3D22

UnknownRJump_0x59F88:
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	jr nz, UnknownRJump_0x59FAA
	ld a, 48
	ldh [$FFE9], a
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x59F9D
	ld a, 1
	ldh [$FFE8], a
	ret

UnknownRJump_0x59F9D:
	xor a
	ldh [$FFE8], a
	jp UnknownJump_0x59D2D
	ld b, 2
	call UnknownCall_0x3D32
	jr UnknownRJump_0x59F88

UnknownRJump_0x59FAA:
	ld b, 1
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x59FB5
	call UnknownCall_0x3D2D
	ret

UnknownRJump_0x59FB5:
	call UnknownCall_0x3D3D
	ret
	call UnknownCall_0x5B57E
	ldh a, [$FFDF]
	and a
	jp nz, UnknownJump_0x58215
	call UnknownCall_0x5B3C6
	ld a, 16
	ldh [$FFDE], a
	ld a, 77
	ldh [$FFE2], a
	ret
	call UnknownCall_0x5B57E
	ldh a, [$FFDF]
	and a
	jp nz, UnknownJump_0x58215
	call UnknownCall_0x5B3C6
	ld a, 77
	ldh [$FFE2], a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x59FF0
	ld a, 77
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 24
	ldh [$FFEC], a
	ret

UnknownRJump_0x59FF0:
	dec a
	rst $28

UnknownData_0x59FF2:
INCBIN "baserom.gb", $59FF2, $59FF8 - $59FF2

	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x5A001
	dec a
	ldh [$FFEC], a
	ret nz

UnknownRJump_0x5A001:
	ld a, 62
	ld [$AF37], a
	ldh a, [$FFDD]
	ld [$AF38], a
	ld a, 36
	ld [$AF36], a
	call UnknownCall_0x5B36D
	ld a, 16
	ldh [$FFEC], a
	ld a, 3
	ldh [$FFDF], a
	ret
	call UnknownCall_0x5B57E
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 59
	ldh [$FFDB], a
	call UnknownCall_0x5B3C6
	ld a, 112
	ldh [$FFEC], a
	ret
	call UnknownCall_0x5B5B6
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A04F
	ld a, 72
	ldh [$FFE2], a
	call UnknownCall_0x3CB1
	ld b, 16
	ldh a, [$FFDD]
	and a
	jr nz, UnknownRJump_0x5A04B
	call UnknownCall_0x3D22
	ret

UnknownRJump_0x5A04B:
UnknownData_0x5A04B:
INCBIN "baserom.gb", $5A04B, $5A04F - $5A04B


UnknownRJump_0x5A04F:
	dec a
	rst $28

UnknownData_0x5A051:
INCBIN "baserom.gb", $5A051, $5A055 - $5A051

	call UnknownCall_0x3C1C
	ld a, [$AF2F]
	bit 1, a
	jr nz, UnknownRJump_0x5A066
	ld b, 1
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5A07E

UnknownRJump_0x5A066:
	ld a, 2
	ld [$AF26], a
	call UnknownCall_0x5B2D7
	ret

UnknownData_0x5A06F:
INCBIN "baserom.gb", $5A06F, $5A07E - $5A06F


UnknownRJump_0x5A07E:
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x5A08F
	call UnknownCall_0x5B465
	call UnknownCall_0x3D2D
	ldh a, [$FFE0]
	cp c
	ret nz
	jr UnknownRJump_0x5A0A0

UnknownRJump_0x5A08F:
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	jr nz, UnknownRJump_0x5A0A0
	call UnknownCall_0x5B441
	call UnknownCall_0x3D3D
	ret

UnknownRJump_0x5A0A0:
	xor a
	ldh [$FFE0], a
	ldh a, [$FFE8]
	xor $01
	ldh [$FFE8], a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A0BB
	ld a, 77
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 48
	ldh [$FFE9], a
	ret

UnknownRJump_0x5A0BB:
	ldh a, [$FFE9]
	dec a
	ldh [$FFE9], a
	jr z, UnknownRJump_0x5A0D5
	ldh a, [$FFDF]
	cp $03
	call c, UnknownCall_0x5B585
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5A0CD:
INCBIN "baserom.gb", $5A0CD, $5A0D5 - $5A0CD


UnknownRJump_0x5A0D5:
	ld a, 66
	ldh [$FFDB], a
	ld a, 69
	ld [$AF37], a
	ldh a, [$FFDD]
	ld [$AF38], a
	ld a, 38
	ld [$AF36], a
	call UnknownCall_0x5B36D
	ld a, 16
	ldh [$FFEC], a
	ldh a, [$FFDF]
	add 2
	ldh [$FFDF], a
	xor a
	ldh [$FFEA], a
	ld a, 17
	ld [$A470], a
	ret
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld b, 3
	ldh a, [$FFDD]
	and a
	jr nz, UnknownRJump_0x5A119
	call UnknownCall_0x3D32

UnknownRJump_0x5A10E:
	ld a, 88
	ldh [$FFE9], a
	ldh a, [$FFDF]
	sub 2
	ldh [$FFDF], a
	ret

UnknownRJump_0x5A119:
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5A10E
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A13E
	ld a, 72
	ldh [$FFE2], a
	call UnknownCall_0x3CB1
	ld b, 15
	call UnknownCall_0x3D2D
	ld b, 11
	ldh a, [$FFDF]
	dec a
	jr nz, UnknownRJump_0x5A13A
	call UnknownCall_0x3D22
	ret

UnknownRJump_0x5A13A:
	call UnknownCall_0x3D32
	ret

UnknownRJump_0x5A13E:
	dec a
	rst $28

UnknownData_0x5A140:
INCBIN "baserom.gb", $5A140, $5A148 - $5A140

	ldh a, [$FFF0]
	and $03
	ret nz
	ld b, 1
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5A15E
	ldh a, [$FFF0]
	and $03
	ret nz
	ld b, 1
	call UnknownCall_0x3D32

UnknownRJump_0x5A15E:
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	cp $49
	ret nz
	ldh a, [$FFDF]
	add 2
	ldh [$FFDF], a
	ret
	ld b, 2
	call UnknownCall_0x3D22
	ret
	ld b, 2
	call UnknownCall_0x3D32
	ret
	ldh a, [$FFDF]
	cp $03
	call c, UnknownCall_0x5B585
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A18D
	ld a, 77
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ret

UnknownRJump_0x5A18D:
	dec a
	rst $28

UnknownData_0x5A18F:
INCBIN "baserom.gb", $5A18F, $5A197 - $5A18F

	call UnknownCall_0x582FB
	jr UnknownRJump_0x5A19F
	call UnknownCall_0x5831A

UnknownRJump_0x5A19F:
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x5A1A8
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0x5A1A8:
	call UnknownCall_0x5B4B4
	cp $20
	ret nc
	ld a, 3
	ldh [$FFDF], a
	xor a
	ldh [$FFEA], a
	ld a, 99
	ldh [$FFDB], a
	ld a, 76
	ldh [$FFE2], a
	ret
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDB]
	dec a
	ldh [$FFDB], a
	cp $61
	ret nz
	ld a, 4
	ldh [$FFDF], a
	ld a, 32
	ldh [$FFEC], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x5A1DD
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0x5A1DD:
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	cp $63
	ret nz
	call UnknownCall_0x5B3C6
	ld a, 77
	ldh [$FFE2], a
	ld a, 64
	ldh [$FFEC], a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A204
	ld a, 77
	ldh [$FFE2], a
	ld a, 3
	ldh [$FFDF], a
	ret

UnknownRJump_0x5A204:
	dec a
	rst $28

UnknownData_0x5A206:
INCBIN "baserom.gb", $5A206, $5A20C - $5A206

	ldh a, [$FFDB]
	set 0, a
	ldh [$FFDB], a
	call UnknownCall_0x5B4B4
	cp $18
	ret nc
	call UnknownCall_0x5B3C6
	ld a, 23
	ld [$A470], a
	ret
	ld b, 3
	call UnknownCall_0x3D32
	jr UnknownRJump_0x5A22D
	ld b, 3
	call UnknownCall_0x3D22

UnknownRJump_0x5A22D:
	call UnknownCall_0x5B521
	ld b, 1
	call UnknownCall_0x3D2D
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A244
	ld a, 32
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ret

UnknownRJump_0x5A244:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5A248:
INCBIN "baserom.gb", $5A248, $5A24A - $5A248

	call UnknownCall_0x5B5AD
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 1
	call UnknownCall_0x3CC0
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A271
	ld a, 32
	ldh [$FFE2], a
	ldh a, [$FFE7]
	bit 3, a
	ret z
	ld a, 1
	ldh [$FFDF], a
	ld a, 24
	ldh [$FFE8], a
	ldh [$FFE9], a
	ret

UnknownRJump_0x5A271:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5A275:
INCBIN "baserom.gb", $5A275, $5A27B - $5A275

	ldh a, [$FFE7]
	bit 3, a
	jr z, UnknownRJump_0x5A297
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFE8]
	and a
	jr z, UnknownRJump_0x5A2A0
	dec a
	ldh [$FFE8], a
	ld b, 1
	call UnknownCall_0x3D3D
	call UnknownCall_0x3CDF
	ret

UnknownRJump_0x5A297:
	ld a, 2
	ldh [$FFDF], a
	ld a, 16
	ldh [$FFEC], a
	ret

UnknownRJump_0x5A2A0:
	ld a, 3
	ldh [$FFDF], a
	ret
	ldh a, [$FFE7]
	bit 3, a
	jr nz, UnknownRJump_0x5A2C4
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x5A2B4
	dec a
	ldh [$FFEC], a
	ret nz

UnknownRJump_0x5A2B4:
	ldh a, [$FFE9]
	ld c, a
	ldh a, [$FFE8]
	cp c
	ret z
	inc a
	ldh [$FFE8], a
	ld b, 1
	call UnknownCall_0x3D2D
	ret

UnknownRJump_0x5A2C4:
	ld a, 1
	ldh [$FFDF], a
	xor a
	ldh [$FFEC], a
	ret
	call UnknownCall_0x5B2BF
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A2E6
	ld a, 77
	ldh [$FFE2], a
	ld a, 5
	ldh [$FFDF], a
	ld a, 16
	ldh [$FFE8], a
	ld a, 128
	ldh [$FFDC], a
	ret

UnknownRJump_0x5A2E6:
	call UnknownCall_0x5B5AD
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5A2ED:
INCBIN "baserom.gb", $5A2ED, $5A2F7 - $5A2ED

	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 1
	call UnknownCall_0x3D2D
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	call UnknownCall_0x5B3C6
	xor a
	ldh [$FFDC], a
	ret
	call UnknownCall_0x5B521
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A325
	ld a, 72
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 56
	ldh [$FFE9], a
	add a
	ldh [$FFE8], a
	ret

UnknownJump_0x5A325:
UnknownRJump_0x5A325:
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5A32E:
INCBIN "baserom.gb", $5A32E, $5A332 - $5A32E

	ld b, 1
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5A33E
	ld b, 1
	call UnknownCall_0x3D32

UnknownRJump_0x5A33E:
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ldh a, [$FFE8]
	ldh [$FFE9], a
	ldh a, [$FFDF]
	xor $03
	ldh [$FFDF], a
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A385
	ld b, 36
	call UnknownCall_0x3D2D
	call UnknownCall_0x5B3C6
	and a
	jr z, UnknownRJump_0x5A376

UnknownData_0x5A365:
INCBIN "baserom.gb", $5A365, $5A376 - $5A365


UnknownRJump_0x5A376:
	ld a, 18
	ldh [$FFDF], a
	ld a, 1
	ldh [$FFE8], a
	ldh [$FFE9], a
	ld a, 72
	ldh [$FFE2], a
	ret

UnknownRJump_0x5A385:
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFDF]
	and $F0
	swap a
	dec a
	jr z, UnknownRJump_0x5A3A4
	dec a
	jr z, UnknownRJump_0x5A3AF
	dec a
	jr z, UnknownRJump_0x5A3BA
	ld hl, $6519
	call UnknownCall_0x5A478
	call UnknownCall_0x3D10
	jr UnknownRJump_0x5A3C3

UnknownRJump_0x5A3A4:
	ld hl, $6519
	call UnknownCall_0x5A3F7
	call UnknownCall_0x3CDF
	jr UnknownRJump_0x5A3C3

UnknownRJump_0x5A3AF:
	ld hl, $652F
	call UnknownCall_0x5A405
	call UnknownCall_0x3CDF
	jr UnknownRJump_0x5A3C3

UnknownRJump_0x5A3BA:
	ld hl, $652F
	call UnknownCall_0x5A486
	call UnknownCall_0x3D10

UnknownRJump_0x5A3C3:
	ldh a, [$FFDF]
	and $0F
	jr z, UnknownRJump_0x5A3D9
	dec a
	jr z, UnknownRJump_0x5A3E3
	dec a
	jr z, UnknownRJump_0x5A3ED
	ld hl, $652F
	call UnknownCall_0x5A4D4
	call UnknownCall_0x3CC0
	ret

UnknownRJump_0x5A3D9:
	ld hl, $6519
	call UnknownCall_0x5A49F
	call UnknownCall_0x3CC0
	ret

UnknownRJump_0x5A3E3:
	ld hl, $6519
	call UnknownCall_0x5A4B8
	call UnknownCall_0x3CF1
	ret

UnknownRJump_0x5A3ED:
	ld hl, $652F
	call UnknownCall_0x5A4C6
	call UnknownCall_0x3CF1
	ret

UnknownCall_0x5A3F7:
	call UnknownCall_0x5A413
	call UnknownCall_0x5A41E
	ld a, [$AF27]
	and a
	ret nz
	ld [hl], 1
	ret

UnknownCall_0x5A405:
	call UnknownCall_0x5A413
	call UnknownCall_0x5A41E
	ld a, [$AF27]
	and a
	ret nz
	ld [hl], 20
	ret

UnknownCall_0x5A413:
	ldh a, [$FFE8]
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	call UnknownCall_0x3D3D
	ret

UnknownCall_0x5A41E:
	xor a
	ld [$AF27], a
	ld hl, $FFE8
	inc [hl]
	ld a, [hl]
	cp $15
	jr nz, UnknownRJump_0x5A432
	ldh a, [$FFDF]
	add 16
	ldh [$FFDF], a
	ret

UnknownRJump_0x5A432:
	ld a, 1
	ld [$AF27], a
	ret

UnknownCall_0x5A438:
	xor a
	ld [$AF27], a
	ld hl, $FFE8
	dec [hl]
	jr nz, UnknownRJump_0x5A432
	ldh a, [$FFDF]
	add 16
	cp $50
	jr c, UnknownRJump_0x5A44C
	sub 64

UnknownRJump_0x5A44C:
	ldh [$FFDF], a
	ret

UnknownCall_0x5A44F:
	xor a
	ld [$AF27], a
	ld hl, $FFE9
	dec [hl]
	jr nz, UnknownRJump_0x5A432
	ldh a, [$FFDF]
	inc a
	bit 2, a
	jr z, UnknownRJump_0x5A44C
	sub 4
	ldh [$FFDF], a
	ret

UnknownCall_0x5A465:
	xor a
	ld [$AF27], a
	ld hl, $FFE9
	inc [hl]
	ld a, [hl]
	cp $15
	jr nz, UnknownRJump_0x5A432
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ret

UnknownCall_0x5A478:
	call UnknownCall_0x5A494
	call UnknownCall_0x5A438
	ld a, [$AF27]
	and a
	ret nz
	ld [hl], 1
	ret

UnknownCall_0x5A486:
	call UnknownCall_0x5A494
	call UnknownCall_0x5A438
	ld a, [$AF27]
	and a
	ret nz
	ld [hl], 20
	ret

UnknownCall_0x5A494:
	ldh a, [$FFE8]
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	call UnknownCall_0x3D2D
	ret

UnknownCall_0x5A49F:
	call UnknownCall_0x5A4AD
	call UnknownCall_0x5A44F
	ld a, [$AF27]
	and a
	ret nz
	ld [hl], 1
	ret

UnknownCall_0x5A4AD:
	ldh a, [$FFE9]
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	call UnknownCall_0x3D32
	ret

UnknownCall_0x5A4B8:
	call UnknownCall_0x5A4E2
	call UnknownCall_0x5A465
	ld a, [$AF27]
	and a
	ret nz
	ld [hl], 1
	ret

UnknownCall_0x5A4C6:
	call UnknownCall_0x5A4E2
	call UnknownCall_0x5A465
	ld a, [$AF27]
	and a
	ret nz
	ld [hl], 20
	ret

UnknownCall_0x5A4D4:
	call UnknownCall_0x5A4AD
	call UnknownCall_0x5A44F
	ld a, [$AF27]
	and a
	ret nz
	ld [hl], 20
	ret

UnknownCall_0x5A4E2:
	ldh a, [$FFE9]
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	call UnknownCall_0x3D22
	ret

UnknownData_0x5A4ED:
INCBIN "baserom.gb", $5A4ED, $5A545 - $5A4ED

	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A568
	ld a, 32
	ldh [$FFE2], a
	ld a, 16
	ldh [$FFDE], a
	call UnknownCall_0x5B3C6
	ld a, 168
	ld [$AF37], a
	ldh a, [$FFDD]
	ld [$AF38], a
	ld a, 69
	ld [$AF36], a
	call UnknownCall_0x5B36D
	ret

UnknownRJump_0x5A568:
	call UnknownCall_0x5B5D8
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5A574:
INCBIN "baserom.gb", $5A574, $5A578 - $5A574

	call UnknownCall_0x3C58
	ld a, [$AF2F]
	bit 1, a
	jp nz, UnknownJump_0x59D2D
	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3CF1
	jr UnknownRJump_0x5A5A0
	call UnknownCall_0x3BF4
	ld a, [$AF2F]
	bit 0, a
	jp nz, UnknownJump_0x59D2D
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3CC0

UnknownRJump_0x5A5A0:
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x5A5B0
	call UnknownCall_0x5B465
	call UnknownCall_0x3D2D
	call UnknownCall_0x3D10
	jr UnknownRJump_0x5A5B9

UnknownRJump_0x5A5B0:
	call UnknownCall_0x5B441
	call UnknownCall_0x3D3D
	call UnknownCall_0x3CDF

UnknownRJump_0x5A5B9:
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFE8]
	xor $01
	ldh [$FFE8], a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A5DA
	ld a, 77
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ld b, 24
	call UnknownCall_0x3D2D
	ret

UnknownRJump_0x5A5DA:
	call UnknownCall_0x5B57E
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5A5E1:
INCBIN "baserom.gb", $5A5E1, $5A5E3 - $5A5E1

	call UnknownCall_0x5B4F5
	ld b, 24
	call UnknownCall_0x3D2D
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A603
	ld a, 16
	ldh [$FFDE], a
	ld a, 32
	ldh [$FFE2], a
	ldh a, [$FFE7]
	bit 3, a
	ret z
	ld a, 1
	ldh [$FFDF], a
	ret

UnknownRJump_0x5A603:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5A607:
INCBIN "baserom.gb", $5A607, $5A60F - $5A607

	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 1
	call UnknownCall_0x3D2D
	call UnknownCall_0x3D10
	call UnknownCall_0x3D32
	call UnknownCall_0x3CC0
	ldh a, [$FFE9]
	add b
	ldh [$FFE9], a
	cp $30
	ret nz
	xor a
	ldh [$FFE9], a
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ret
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 1
	call UnknownCall_0x3D3D
	call UnknownCall_0x3CDF
	call UnknownCall_0x3D32
	call UnknownCall_0x3CC0
	ldh a, [$FFE9]
	add b
	ldh [$FFE9], a
	cp $20
	ret nz
	xor a
	ldh [$FFE9], a
	ld a, 3
	ldh [$FFDF], a
	ld a, 64
	ldh [$FFEC], a
	ret
	call UnknownCall_0x5B68B
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	call UnknownCall_0x5B2BF
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A674
	ld a, 77
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ret

UnknownRJump_0x5A674:
	call UnknownCall_0x5B57E
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5A67B:
INCBIN "baserom.gb", $5A67B, $5A683 - $5A67B

	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A691
	ld a, 32
	ldh [$FFE2], a
	ld a, 4
	ldh [$FFDF], a
	ret

UnknownRJump_0x5A691:
	dec a
	rst $28

UnknownData_0x5A693:
INCBIN "baserom.gb", $5A693, $5A69B - $5A693

	ldh a, [$FFE7]
	bit 3, a
	ret z
	ld a, 1
	ldh [$FFDF], a
	ret
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	cp $BE
	ret nz
	ld a, 2
	ldh [$FFDF], a
	ld a, 112
	ldh [$FFE9], a
	ret
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3CC0
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ld a, 3
	ldh [$FFDF], a
	ld a, 32
	ldh [$FFEC], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x5A6DB
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0x5A6DB:
	ldh a, [$FFDB]
	cp $BC
	ret z
	dec a
	ldh [$FFDB], a
	xor a
	ldh [$FFE2], a
	ret
	call UnknownCall_0x5B51A
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A6F7
	ld a, 72
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ret

UnknownRJump_0x5A6F7:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5A6FB:
INCBIN "baserom.gb", $5A6FB, $5A6FF - $5A6FB

	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3AF0
	ld a, [$AF2F]
	bit 2, a
	jp z, UnknownJump_0x59D2D
	ret
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3B04
	ld a, [$AF2F]
	bit 2, a
	jp z, UnknownJump_0x59D2D
	ret
	call UnknownCall_0x5B639
	ldh a, [$FFDF]
	and a
	jp nz, UnknownJump_0x5A325
	ld a, 72
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 56
	ldh [$FFE9], a
	add a
	ldh [$FFE8], a
	ret
	call UnknownCall_0x5B51A
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A749
	ld a, 72
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ret

UnknownRJump_0x5A749:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5A74D:
INCBIN "baserom.gb", $5A74D, $5A751 - $5A74D

	ld b, 1
	call UnknownCall_0x3D22
	call UnknownCall_0x3B18
	ld a, [$AF2F]
	bit 3, a
	jp z, UnknownJump_0x59D2D
	ret
	ld b, 1
	call UnknownCall_0x3D32
	call UnknownCall_0x3B2C
	ld a, [$AF2F]
	bit 3, a
	jp z, UnknownJump_0x59D2D
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A787
	ld a, 77
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 24
	ldh [$FFE9], a
	add a
	ldh [$FFE8], a
	ret

UnknownRJump_0x5A787:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5A78B:
INCBIN "baserom.gb", $5A78B, $5A793 - $5A78B

	call UnknownCall_0x5B51A
	ld b, 1
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5A7A5
	call UnknownCall_0x5B51A
	ld b, 1
	call UnknownCall_0x3D32

UnknownRJump_0x5A7A5:
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ldh a, [$FFDF]
	ldh [$FFEF], a
	ld a, 3
	ldh [$FFDF], a
	ld a, 16
	ldh [$FFEC], a
	call UnknownCall_0x5B41A
	ld a, [$AF2C]
	cp $FF
	jr z, UnknownRJump_0x5A7C6
	ld a, 147
	ldh [$FFDB], a
	ret

UnknownRJump_0x5A7C6:
	ld a, 148
	ldh [$FFDB], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x5A7D4
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0x5A7D4:
	ld a, 145
	ld [$AF37], a
	ldh a, [$FFDD]
	ld [$AF38], a
	ldh a, [$FFDB]
	cp $94
	jr nz, UnknownRJump_0x5A7EB
	ld a, [$AF38]
	inc a
	ld [$AF38], a

UnknownRJump_0x5A7EB:
	ld a, 78
	ld [$AF36], a
	call UnknownCall_0x5B36D
	ld a, 4
	ldh [$FFDF], a
	ld a, 32
	ldh [$FFEC], a
	ld a, 17
	ld [$A470], a
	ret
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 146
	ldh [$FFDB], a
	ldh a, [$FFEF]
	ldh [$FFDF], a
	ldh a, [$FFE8]
	ldh [$FFE9], a
	jp UnknownJump_0x59D2D
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A834
	ld a, 73
	ldh [$FFE2], a
	call UnknownCall_0x3CB1
	ldh a, [$FFDD]
	bit 0, a
	jr nz, UnknownRJump_0x5A82F
	ldh a, [$FFDF]
	add 2
	ldh [$FFDF], a
	ret

UnknownRJump_0x5A82F:
	res 0, a
	ldh [$FFDD], a
	ret

UnknownRJump_0x5A834:
	dec a
	rst $28

UnknownData_0x5A836:
INCBIN "baserom.gb", $5A836, $5A83E - $5A836

	ld b, 1
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5A84A
	ld b, 1
	call UnknownCall_0x3D32

UnknownRJump_0x5A84A:
	ld b, 1
	call UnknownCall_0x3D2D
	ret
	ld b, 2
	call UnknownCall_0x3D22
	ret
	ld b, 2
	call UnknownCall_0x3D32
	ret

UnknownData_0x5A85C:
INCBIN "baserom.gb", $5A85C, $5A8D2 - $5A85C

	ld a, 1
	ld [$AF3E], a
	ldh a, [$FFDF]
	and a
	ret nz
	ld a, 16
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A913
	call UnknownCall_0x5B3C6
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ld a, 133
	ldh [$FFE2], a
	ld a, 90
	ld [$AF37], a
	ldh a, [$FFDD]
	ld [$AF38], a
	ld a, 55
	ld [$AF36], a
	call UnknownCall_0x5B36D
	ld b, 16
	call UnknownCall_0x3D2D
	ld a, 18
	ld [$A470], a
	ret

UnknownRJump_0x5A913:
	dec a
	rst $28

UnknownData_0x5A915:
INCBIN "baserom.gb", $5A915, $5A91D - $5A915


UnknownRJump_0x5A91D:
	call UnknownCall_0x3B54
	ld a, [$AF2F]
	bit 3, a
	ret nz
	ldh a, [$FFDF]
	add 2
	ldh [$FFDF], a
	ret

UnknownData_0x5A92D:
INCBIN "baserom.gb", $5A92D, $5A939 - $5A92D

	ldh a, [$FFF0]
	and $01
	jr nz, UnknownRJump_0x5A91D

UnknownRJump_0x5A93F:
	ld b, 3
	call UnknownCall_0x3D32
	ret
	ldh a, [$FFF0]
	and $01
	jr z, UnknownRJump_0x5A93F
	jr UnknownRJump_0x5A953

UnknownData_0x5A94D:
INCBIN "baserom.gb", $5A94D, $5A953 - $5A94D


UnknownRJump_0x5A953:
	call UnknownCall_0x5B451
	call UnknownCall_0x3D3D
	call UnknownCall_0x3B54
	ld a, [$AF2F]
	bit 3, a
	ret z
	ldh a, [$FFDF]
	sub 2
	ldh [$FFDF], a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A973
	ld a, 1
	ldh [$FFDF], a
	ret

UnknownRJump_0x5A973:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5A977:
INCBIN "baserom.gb", $5A977, $5A979 - $5A977

	call UnknownCall_0x5B585
	call UnknownCall_0x5B4F5
	ld b, 20
	call UnknownCall_0x3D3D
	ld a, [$AF07]
	and a
	ret z
	ld a, 2
	ld [$AF26], a
	call UnknownCall_0x5B2D7
	ret
	call UnknownCall_0x5B521
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5A9A9
	ld a, 72
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ld a, 64
	ldh [$FFE8], a
	ldh [$FFE9], a
	ret

UnknownRJump_0x5A9A9:
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5A9B2:
INCBIN "baserom.gb", $5A9B2, $5A9B6 - $5A9B2

	ld b, 1
	call UnknownCall_0x3D3D
	jr UnknownRJump_0x5A9C2

UnknownData_0x5A9BD:
INCBIN "baserom.gb", $5A9BD, $5A9C2 - $5A9BD


UnknownRJump_0x5A9C2:
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz

UnknownData_0x5A9C8:
INCBIN "baserom.gb", $5A9C8, $5A9D3 - $5A9C8

	call UnknownCall_0x5B511
	xor a
	ldh [$FFDD], a
	ldh a, [$FFDF]
	and a
	jp nz, UnknownJump_0x58642
	ld a, 77
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ret
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5AA14
	ld b, 2
	call UnknownCall_0x3D3D
	ld a, 128
	ldh [$FFDC], a
	xor a
	ldh [$FFDD], a
	ld a, 74
	ldh [$FFE2], a
	ld a, 24
	ldh [$FFE9], a
	ld a, 24
	ldh [$FFEC], a
	ld a, 5
	ldh [$FFDF], a
	ret
	call UnknownCall_0x5B4B4
	cp $28
	ret c
	call UnknownCall_0x5B3C6
	ret

UnknownRJump_0x5AA14:
	dec a
	rst $28

UnknownData_0x5AA16:
INCBIN "baserom.gb", $5AA16, $5AA20 - $5AA16

	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x5AA29
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0x5AA29:
	ld b, 1
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5AA3E
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x5AA39
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0x5AA39:
	ld b, 1
	call UnknownCall_0x3D32

UnknownRJump_0x5AA3E:
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	xor a
	ldh [$FFDC], a
	ldh a, [$FFDF]
	add 2
	ldh [$FFDF], a
	ld a, 16
	ld [$A470], a
	ret
	ld b, 3
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5AA5F
	ld b, 3
	call UnknownCall_0x3D32

UnknownRJump_0x5AA5F:
	ldh a, [$FFDA]
	cp $B8
	ret c
	call UnknownCall_0x5B2BF
	ret
	ldh a, [$FFDF]
	and a
	jp nz, UnknownJump_0x59189
	jp UnknownJump_0x581B9
	ldh a, [$FFDF]
	and a
	jr nz, UnknownRJump_0x5AA85
	ld a, 72
	ldh [$FFE2], a
	ld a, 3
	ldh [$FFDF], a
	ld a, 8
	ldh [$FFE8], a
	ldh [$FFE9], a
	ret

UnknownRJump_0x5AA85:
	ldh a, [$FFDF]
	dec a
	rst $28

UnknownData_0x5AA89:
INCBIN "baserom.gb", $5AA89, $5AA8F - $5AA89

	call UnknownCall_0x5B4B4
	cp $20
	ret nc
	ldh a, [$FFDB]
	set 0, a
	ldh [$FFDB], a
	ld a, 1
	ldh [$FFDF], a
	ret
	ld b, 1
	call UnknownCall_0x3D2D
	jr UnknownRJump_0x5AAAC
	ld b, 1
	call UnknownCall_0x3D3D

UnknownRJump_0x5AAAC:
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ldh a, [$FFE9]
	ldh [$FFE8], a
	jp UnknownJump_0x59D33
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5AABC:
INCBIN "baserom.gb", $5AABC, $5AAC6 - $5AABC

	ld a, 16
	ldh [$FFDE], a
	ld a, 32
	ldh [$FFE2], a
	ld a, 3
	ldh [$FFDF], a
	ld a, 48
	ldh [$FFE8], a
	ldh [$FFE9], a
	ret
	ldh a, [$FFE7]
	bit 3, a
	ret z
	ld b, 8
	call UnknownCall_0x3D3D
	ld a, 221
	ldh [$FFDB], a
	ld a, 4
	ldh [$FFDF], a
	ld a, 4
	ldh [$FFEC], a
	ret
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 128
	ldh [$FFDC], a
	ld b, 64
	call UnknownCall_0x3D22
	call UnknownCall_0x3D2D
	ld a, 193
	ldh [$FFDB], a
	ld a, 1
	ldh [$FFDF], a
	ld a, 72
	ldh [$FFE2], a
	ret
	ld a, [sEasyMode]
	and $01
	jr nz, UnknownRJump_0x5AB1A
	ld b, 4
	jr UnknownRJump_0x5AB1C

UnknownRJump_0x5AB1A:
	ld b, 2

UnknownRJump_0x5AB1C:
	call UnknownCall_0x3D3D
	jr UnknownRJump_0x5AB31
	ld a, [sEasyMode]
	and $01
	jr nz, UnknownRJump_0x5AB2C
	ld b, 4
	jr UnknownRJump_0x5AB2E

UnknownRJump_0x5AB2C:
	ld b, 2

UnknownRJump_0x5AB2E:
	call UnknownCall_0x3D2D

UnknownRJump_0x5AB31:
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ldh a, [$FFE9]
	ldh [$FFE8], a
	ldh a, [$FFDF]
	cp $01
	call z, UnknownCall_0x5AB45
	jp UnknownJump_0x59D33

UnknownCall_0x5AB45:
	ld a, 10
	ld [$A470], a
	ret
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5AB4E:
INCBIN "baserom.gb", $5AB4E, $5AB58 - $5AB4E

	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 128
	ldh [$FFDC], a
	ld b, 48
	call UnknownCall_0x3D22
	ld b, 64
	call UnknownCall_0x3D2D
	ld a, 193
	ldh [$FFDB], a
	ld a, 1
	ldh [$FFDF], a
	ld a, 72
	ldh [$FFE2], a
	ret
	call UnknownCall_0x5B585
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5AB7F:
INCBIN "baserom.gb", $5AB7F, $5AB89 - $5AB7F

	ld a, 74
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ldh a, [$FFDF]
	ldh [$FFEF], a
	ret

UnknownCall_0x5AB95:
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	jr nz, UnknownRJump_0x5ABA5
	ld b, 2
	call UnknownCall_0x3D3D
	ret

UnknownRJump_0x5ABA5:
	ldh a, [$FFDF]
	add 2

UnknownRJump_0x5ABA9:
	ldh [$FFDF], a
	ldh [$FFEF], a
	ret
	call UnknownCall_0x5AB95
	jr UnknownRJump_0x5ABBB
	call UnknownCall_0x5AB95
	jr UnknownRJump_0x5ABD3
	call UnknownCall_0x5ABE8

UnknownRJump_0x5ABBB:
	call UnknownCall_0x3C1C
	ld a, [$AF2F]
	bit 1, a
	jr nz, UnknownRJump_0x5ABCB
	ld b, 2
	call UnknownCall_0x3D22
	ret

UnknownRJump_0x5ABCB:
	ldh a, [$FFDF]
	inc a
	jr UnknownRJump_0x5ABA9
	call UnknownCall_0x5ABE8

UnknownRJump_0x5ABD3:
	call UnknownCall_0x3BB8
	ld a, [$AF2F]
	bit 0, a
	jr nz, UnknownRJump_0x5ABE3
	ld b, 2
	call UnknownCall_0x3D32
	ret

UnknownRJump_0x5ABE3:
	ldh a, [$FFDF]
	dec a
	jr UnknownRJump_0x5ABFC

UnknownCall_0x5ABE8:
	call UnknownCall_0x3B7C
	ld a, [$AF2F]
	bit 2, a
	jr nz, UnknownRJump_0x5ABF8
	ld b, 2
	call UnknownCall_0x3D2D
	ret

UnknownRJump_0x5ABF8:
	ldh a, [$FFDF]
	sub 2

UnknownRJump_0x5ABFC:
	ldh [$FFDF], a
	ldh [$FFEF], a
	ret
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5AC04:
INCBIN "baserom.gb", $5AC04, $5AC08 - $5AC04

	ld a, 1
	ldh [$FFDF], a
	ld a, 56
	ldh [$FFEC], a
	ret
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, [sEasyMode]
	and $01
	jr nz, UnknownRJump_0x5AC2A
	call UnknownCall_0x3AB4
	ld a, 73
	ldh [$FFE2], a
	ldh a, [$FFEF]
	ldh [$FFDF], a
	ret

UnknownRJump_0x5AC2A:
	ld a, 2
	ld [$AF26], a
	call UnknownCall_0x5B2D7
	ld a, [$A2E0]
	and a
	ret z
	dec a
	ld [$A2E0], a
	ret
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5AC3F:
INCBIN "baserom.gb", $5AC3F, $5AC47 - $5AC3F

	ld a, 16
	ldh [$FFDE], a
	ld a, 72
	ldh [$FFE2], a
	ld a, 3
	ldh [$FFDF], a
	ret
	call UnknownCall_0x5B4B4
	cp $30
	ret nc
	ld a, 1
	ldh [$FFDF], a
	ret
	call UnknownCall_0x5B5B6
	jp UnknownJump_0x593FB
	call UnknownCall_0x5B5B6
	call UnknownCall_0x3B90
	ld a, [$AF2F]
	bit 2, a
	jr nz, UnknownRJump_0x5AC78
	ld b, 1
	call UnknownCall_0x3D2D
	ret

UnknownRJump_0x5AC78:
UnknownData_0x5AC78:
INCBIN "baserom.gb", $5AC78, $5AC7D - $5AC78

	ldh a, [$FFDF]
	rst $28

UnknownData_0x5AC80:
INCBIN "baserom.gb", $5AC80, $5AC88 - $5AC80

	ld a, 32
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ld a, [sEasyMode]
	and $01
	ret z
	ld a, 224
	ldh [$FFDB], a
	ret
	call UnknownCall_0x5B521
	ldh a, [$FFE7]
	bit 3, a
	ret z
	ld a, [sEasyMode]
	and $01
	jr nz, UnknownRJump_0x5ACAF
	ld a, 2
	ldh [$FFDF], a
	ret

UnknownRJump_0x5ACAF:
	ld a, 3
	ldh [$FFDF], a
	ret
	ldh a, [$FFF0]
	and $07
	ret nz
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	cp $CE
	jr z, UnknownRJump_0x5ACC9
	cp $D0
	ret nz
	call UnknownCall_0x5B2D7
	ret

UnknownRJump_0x5ACC9:
	ld a, 1
	ld [$A478], a
	ret
	ldh a, [$FFF0]
	and $07
	ret nz
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	cp $E2
	jr z, UnknownRJump_0x5ACC9
	cp $E4
	ret nz
	call UnknownCall_0x5B2D7
	ret
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5ACE7:
INCBIN "baserom.gb", $5ACE7, $5ACED - $5ACE7


UnknownRJump_0x5ACED:
	ld a, 32
	ldh [$FFEC], a
	ld a, 2
	ldh [$FFDF], a
	ld a, 16
	ldh [$FFDE], a
	ret
	call UnknownCall_0x5AD11
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 1
	ldh [$FFDF], a
	ld a, 80
	ldh [$FFE2], a
	ld a, 6
	ld [$A478], a
	ret

UnknownCall_0x5AD11:
	ldh a, [$FFEC]
	and $06
	ret z
	ld a, 1
	ld [$AF3E], a
	ret
	call UnknownCall_0x5B5AD
	ld b, 2
	call UnknownCall_0x3D22
	ldh a, [$FFDA]
	cp $B0
	ret c
	call UnknownCall_0x5B2BF
	ret
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5AD30:
INCBIN "baserom.gb", $5AD30, $5AD36 - $5AD30

	ld a, 32
	ldh [$FFDD], a
	jr UnknownRJump_0x5ACED
	call UnknownCall_0x5B5AD
	ld b, 2
	call UnknownCall_0x3D32
	ldh a, [$FFDA]
	cp $B8
	ret c
	call UnknownCall_0x5B2BF
	ret
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5AD50:
INCBIN "baserom.gb", $5AD50, $5AD5A - $5AD50

	ld a, 32
	ldh [$FFE2], a
	ld a, 2
	ldh [$FFDF], a
	ld a, 40
	ldh [$FFE9], a
	add a
	ldh [$FFE8], a
	ld a, 16
	ldh [$FFDE], a
	ld a, 1
	ldh [$FFE0], a
	ret
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ldh a, [$FFDF]
	inc a
	ldh [$FFDF], a
	ldh a, [$FFE8]
	ldh [$FFE9], a
	xor a
	ldh [$FFE0], a
	ret
	call UnknownCall_0x5B5DF
	ld a, [sEasyMode]
	and $01
	jr z, UnknownRJump_0x5AD94
	ldh a, [$FFF0]
	and $01
	ret nz

UnknownRJump_0x5AD94:
	ldh a, [$FFE0]
	xor $01
	ldh [$FFE0], a
	inc a
	ld b, a
	call UnknownCall_0x3D32
	call UnknownCall_0x3CC0
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ld a, 3
	ldh [$FFDF], a
	ld a, 48
	ldh [$FFEC], a
	ret
	call UnknownCall_0x5B5DF
	ld a, [sEasyMode]
	and $01
	jr z, UnknownRJump_0x5ADC0
	ldh a, [$FFF0]
	and $01
	ret nz

UnknownRJump_0x5ADC0:
	ldh a, [$FFE0]
	xor $01
	ldh [$FFE0], a
	inc a
	ld b, a
	call UnknownCall_0x3D22
	call UnknownCall_0x3CF1
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ld a, 1
	ldh [$FFDF], a
	ld a, 48
	ldh [$FFEC], a
	ret
	call UnknownCall_0x5B57E
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5ADE3:
INCBIN "baserom.gb", $5ADE3, $5ADED - $5ADE3

	ld a, 72
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 16
	ldh [$FFDE], a
	ret
	ld hl, $6E62
	call UnknownCall_0x5B33E
	ld a, b
	cp $80
	jr z, UnknownRJump_0x5AE09
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5AE1B

UnknownJump_0x5AE09:
UnknownRJump_0x5AE09:
	ld a, 3
	jr UnknownRJump_0x5AE28
	ld hl, $6E62
	call UnknownCall_0x5B33E
	ld a, b
	cp $80
	jr z, UnknownRJump_0x5AE26
	call UnknownCall_0x3D32

UnknownRJump_0x5AE1B:
	ld hl, $6EAC

UnknownJump_0x5AE1E:
	call UnknownCall_0x5B33E
	call UnknownCall_0x3D2D
	jr UnknownRJump_0x5AE59

UnknownJump_0x5AE26:
UnknownRJump_0x5AE26:
	ld a, 4

UnknownRJump_0x5AE28:
	ldh [$FFDF], a
	xor a
	ldh [$FFE9], a
	ret
	ld hl, $6E87
	call UnknownCall_0x5B33E
	ld a, b
	cp $80
	jr z, UnknownRJump_0x5AE3E
	call UnknownCall_0x3D32
	jr UnknownRJump_0x5AE50

UnknownJump_0x5AE3E:
UnknownRJump_0x5AE3E:
	ld a, 2
	jr UnknownRJump_0x5AE28
	ld hl, $6E87
	call UnknownCall_0x5B33E
	ld a, b
	cp $80
	jr z, UnknownRJump_0x5AE5E
	call UnknownCall_0x3D22

UnknownRJump_0x5AE50:
	ld hl, $6ED0

UnknownJump_0x5AE53:
	call UnknownCall_0x5B33E
	call UnknownCall_0x3D3D

UnknownRJump_0x5AE59:
	ld hl, $FFE9
	inc [hl]
	ret

UnknownJump_0x5AE5E:
UnknownRJump_0x5AE5E:
	ld a, 1
	jr UnknownRJump_0x5AE28

UnknownData_0x5AE62:
INCBIN "baserom.gb", $5AE62, $5AEF4 - $5AE62

	call UnknownCall_0x5B57E
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5AEFA:
INCBIN "baserom.gb", $5AEFA, $5AF04 - $5AEFA

	ld hl, $6F55
	call UnknownCall_0x5B33E
	ld a, b
	cp $80
	jp z, UnknownJump_0x5AE09
	call UnknownCall_0x3D22
	ld hl, $6F97
	jp UnknownJump_0x5AE1E
	ld hl, $6F55
	call UnknownCall_0x5B33E
	ld a, b
	cp $80
	jp z, UnknownJump_0x5AE26
	call UnknownCall_0x3D32
	ld hl, $6F97
	jp UnknownJump_0x5AE1E
	ld hl, $6F76
	call UnknownCall_0x5B33E
	ld a, b
	cp $80
	jp z, UnknownJump_0x5AE3E
	call UnknownCall_0x3D32
	jp UnknownJump_0x5AF4F
	ld hl, $6F76
	call UnknownCall_0x5B33E
	ld a, b
	cp $80
	jp z, UnknownJump_0x5AE5E
	call UnknownCall_0x3D22

UnknownJump_0x5AF4F:
	ld hl, $6FB7
	jp UnknownJump_0x5AE53

UnknownData_0x5AF55:
INCBIN "baserom.gb", $5AF55, $5AFD7 - $5AF55

	ldh a, [$FFDF]
	rst $28

UnknownData_0x5AFDA:
INCBIN "baserom.gb", $5AFDA, $5AFE4 - $5AFDA

	ld a, 77
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ld a, 1
	ldh [$FFE8], a
	ld a, 2
	ldh [$FFE9], a
	ret
	ld b, 1
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5B000
	ld b, 1
	call UnknownCall_0x3D32

UnknownRJump_0x5B000:
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x5B012
	call UnknownCall_0x5B481
	call UnknownCall_0x3D3D
	jr UnknownRJump_0x5B018

UnknownRJump_0x5B012:
	call UnknownCall_0x5B449
	call UnknownCall_0x3D2D

UnknownRJump_0x5B018:
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFE8]
	xor $01
	ldh [$FFE8], a
	jp z, UnknownJump_0x59D2D
	ldh a, [$FFE9]
	dec a
	ldh [$FFE9], a
	ret nz
	ldh a, [$FFDF]
	ldh [$FFEF], a
	ld a, 3
	ldh [$FFDF], a
	ret
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	cp $70
	ret nz
	ld a, 108
	ldh [$FFDB], a
	ld a, 112
	ld [$AF37], a
	ld a, 89
	ld [$AF36], a
	call UnknownCall_0x5B36D
	ld a, 4
	ldh [$FFDF], a
	ld a, 8
	ldh [$FFEC], a
	ret
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ldh a, [$FFEF]
	ldh [$FFDF], a
	ld a, 2
	ldh [$FFE9], a
	ret
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5B070:
INCBIN "baserom.gb", $5B070, $5B078 - $5B070

	ld b, 16
	call UnknownCall_0x3D2D
	ld a, 72
	ldh [$FFE2], a
	call UnknownCall_0x5B3C6
	ret
	ld b, 1
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5B091

UnknownData_0x5B08C:
INCBIN "baserom.gb", $5B08C, $5B091 - $5B08C


UnknownRJump_0x5B091:
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x5B0A8
	call UnknownCall_0x5B46C
	call UnknownCall_0x3D2D
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ld a, 1
	ldh [$FFE8], a
	ret

UnknownRJump_0x5B0A8:
	call UnknownCall_0x3B40
	ld a, [$AF2F]
	bit 3, a
	jr nz, UnknownRJump_0x5B0B9
	call UnknownCall_0x5B451
	call UnknownCall_0x3D3D
	ret

UnknownRJump_0x5B0B9:
	ld a, 113
	ldh [$FFDB], a
	ld a, 3
	ldh [$FFDF], a
	ld a, 16
	ldh [$FFEC], a
	ret
	ldh a, [$FFEC]
	dec a
	ldh [$FFEC], a
	ret nz
	ld a, 2
	ld [$AF26], a
	call UnknownCall_0x5B2D7
	ret
	call UnknownCall_0x5B521
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5B0DB:
INCBIN "baserom.gb", $5B0DB, $5B0E5 - $5B0DB

	ld a, 77
	ldh [$FFE2], a
	ld a, 24
	ldh [$FFE9], a
	add a
	ldh [$FFE8], a
	call UnknownCall_0x5B3C6
	ldh a, [$FFDF]
	ldh [$FFE0], a
	ret
	ld b, 1
	call UnknownCall_0x3D22
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ldh a, [$FFE8]
	ldh [$FFE9], a
	ldh a, [$FFE0]
	dec a
	jr z, UnknownRJump_0x5B115

UnknownRJump_0x5B10C:
	ld a, 4
	ldh [$FFDF], a
	ld a, 118
	ldh [$FFDB], a
	ret

UnknownRJump_0x5B115:
	ld a, 3
	ldh [$FFDF], a
	ld a, 120
	ldh [$FFDB], a
	ret
	ld b, 1
	call UnknownCall_0x3D32
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ldh a, [$FFE8]
	ldh [$FFE9], a
	xor a
	ldh [$FFDD], a
	ldh a, [$FFE0]
	dec a
	jr z, UnknownRJump_0x5B10C
	jr UnknownRJump_0x5B115
	ld b, 1
	call UnknownCall_0x3D3D
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ldh a, [$FFE8]
	ldh [$FFE9], a
	ld a, 116
	ldh [$FFDB], a
	ldh a, [$FFE0]
	dec a
	jr z, UnknownRJump_0x5B154

UnknownRJump_0x5B14F:
	ld a, 1
	ldh [$FFDF], a
	ret

UnknownRJump_0x5B154:
	ld a, 32
	ldh [$FFDD], a
	ld a, 2
	ldh [$FFDF], a
	ret
	ld b, 1
	call UnknownCall_0x3D2D
	ldh a, [$FFE9]
	sub b
	ldh [$FFE9], a
	ret nz
	ldh a, [$FFE8]
	ldh [$FFE9], a
	ld a, 116
	ldh [$FFDB], a
	ldh a, [$FFE0]
	dec a
	jr z, UnknownRJump_0x5B14F
	jr UnknownRJump_0x5B154
	call UnknownCall_0x5B51A
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5B17D:
INCBIN "baserom.gb", $5B17D, $5B183 - $5B17D

	ld a, 77
	ldh [$FFE2], a
	ld a, 16
	ldh [$FFDE], a
	call UnknownCall_0x5B3C6
	ret
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 2
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5B1A5
	ldh a, [$FFF0]
	and $01
	ret nz
	ld b, 2
	call UnknownCall_0x3D32

UnknownRJump_0x5B1A5:
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x5B1B3
	call UnknownCall_0x5B47A
	inc b
	call UnknownCall_0x3D2D
	jr UnknownRJump_0x5B1BA

UnknownRJump_0x5B1B3:
	call UnknownCall_0x5B451
	inc b
	call UnknownCall_0x3D3D

UnknownRJump_0x5B1BA:
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFE8]
	xor $01
	ldh [$FFE8], a
	ret
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5B1CB:
INCBIN "baserom.gb", $5B1CB, $5B1D3 - $5B1CB


UnknownRJump_0x5B1D3:
	ld a, 76
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ld a, 3
	ldh [$FFE8], a
	ldh [$FFE9], a
	ldh [$FFEA], a
	ret
	ld b, 1
	ldh a, [$FFE0]
	and a
	jr nz, UnknownRJump_0x5B1F0
	call UnknownCall_0x3D2D
	jr UnknownRJump_0x5B1F3

UnknownRJump_0x5B1F0:
	call UnknownCall_0x3D3D

UnknownRJump_0x5B1F3:
	ldh a, [$FFE8]
	sub b
	ldh [$FFE8], a
	ret nz
	ldh a, [$FFEA]
	dec a
	ldh [$FFEA], a
	jr z, UnknownRJump_0x5B20B
	ldh a, [$FFE9]
	ldh [$FFE8], a
	ldh a, [$FFE0]
	xor $01
	ldh [$FFE0], a
	ret

UnknownRJump_0x5B20B:
	xor a
	ldh [$FFE2], a
	ld a, 2
	ldh [$FFDF], a
	ret
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDB]
	inc a
	ldh [$FFDB], a
	cp $7C
	ret nz
	ld a, 32
	ldh [$FFEC], a
	ld a, 3
	ldh [$FFDF], a
	ret
	ldh a, [$FFEC]
	and a
	jr z, UnknownRJump_0x5B232
	dec a
	ldh [$FFEC], a
	ret

UnknownRJump_0x5B232:
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDB]
	dec a
	ldh [$FFDB], a
	cp $7A
	ret nz
	jr UnknownRJump_0x5B1D3
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5B244:
INCBIN "baserom.gb", $5B244, $5B24A - $5B244

	ld a, 72
	ldh [$FFE2], a
	ld a, 1
	ldh [$FFDF], a
	ret
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x5B260
	call UnknownCall_0x5B473
	call UnknownCall_0x3D2D
	jr UnknownRJump_0x5B266

UnknownRJump_0x5B260:
	call UnknownCall_0x5B44D
	call UnknownCall_0x3D2D

UnknownRJump_0x5B266:
	ldh a, [$FFE0]
	cp c
	ret nz
	xor a
	ldh [$FFE0], a
	ldh a, [$FFE8]
	xor $01
	ldh [$FFE8], a
	ret z
	jp UnknownJump_0x59D33
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x5B284
	call UnknownCall_0x5B473
	call UnknownCall_0x3D3D
	jr UnknownRJump_0x5B266

UnknownRJump_0x5B284:
	call UnknownCall_0x5B44D
	call UnknownCall_0x3D3D
	jr UnknownRJump_0x5B266
	ldh a, [$FFDF]
	rst $28

UnknownData_0x5B28F:
INCBIN "baserom.gb", $5B28F, $5B295 - $5B28F

	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x5B2A2
	call UnknownCall_0x5B473
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5B266

UnknownRJump_0x5B2A2:
	call UnknownCall_0x5B44D
	call UnknownCall_0x3D22
	jr UnknownRJump_0x5B266
	ldh a, [$FFE8]
	and a
	jr nz, UnknownRJump_0x5B2B7
	call UnknownCall_0x5B473
	call UnknownCall_0x3D32
	jr UnknownRJump_0x5B266

UnknownRJump_0x5B2B7:
	call UnknownCall_0x5B44D
	call UnknownCall_0x3D32
	jr UnknownRJump_0x5B266

UnknownCall_0x5B2BF:
	ldh a, [$FFD6]
	ld h, a
	ldh a, [$FFD7]
	ld l, a
	dec hl
	dec hl
	ld de, $FFD0
	ld b, 5
	call UnknownCall_0x3CAA
	call UnknownCall_0x3AA0
	ld a, 1
	ldh [$FFD8], a
	ret

UnknownJump_0x5B2D7:
UnknownCall_0x5B2D7:
	ld a, [$AF26]
	and a
	jr nz, UnknownRJump_0x5B2F0
	ld hl, $FFD6
	ld a, [hli]
	cp $AD
	jr nc, UnknownRJump_0x5B2F0
	ld d, a
	ld a, [hli]
	ld e, a
	ldh a, [$FFD2]
	cp $10
	jr z, UnknownRJump_0x5B2EF
	xor a

UnknownRJump_0x5B2EF:
	ld [de], a

UnknownRJump_0x5B2F0:
	ldh a, [$FFD8]
	dec a
	jr z, UnknownRJump_0x5B305
	ld hl, $AF41
	dec [hl]
	ld a, [$AF26]
	cp $01
	jr nz, UnknownRJump_0x5B309
	call UnknownCall_0x5B31D
	jr UnknownRJump_0x5B309

UnknownRJump_0x5B305:
	ld hl, $AF40
	dec [hl]

UnknownRJump_0x5B309:
	xor a
	ld hl, $FFD0
	ld b, 32

UnknownRJump_0x5B30F:
	ld [hli], a
	dec b
	jr nz, UnknownRJump_0x5B30F
	ld a, 2
	ld [$AF3E], a
	xor a
	ld [$AF26], a
	ret

UnknownCall_0x5B31D:
	ld a, [$A28D]
	add 1
	daa
	ld [$A28D], a
	ret nz
	ld a, 28
	ld [$AF37], a
	ld a, 26
	ld [$AF36], a
	call UnknownCall_0x5B346
	ld a, 8
	ld [$A460], a
	ret

UnknownCall_0x5B33A:
	ldh a, [$FFE8]
	jr UnknownRJump_0x5B340

UnknownCall_0x5B33E:
	ldh a, [$FFE9]

UnknownRJump_0x5B340:
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	ret

UnknownCall_0x5B346:
	ld hl, $ACE8
	ld de, $0020

UnknownRJump_0x5B34C:
	add hl, de
	ld a, [hl]
	and a
	jr nz, UnknownRJump_0x5B34C
	ld a, h
	cp $AF
	jr z, UnknownRJump_0x5B3AE
	ld a, l
	and $F0
	ld l, a
	ldh_a_n $CB
	ld [hli], a
	ldh_a_n $CA
	ld [hli], a
	inc l
	ldh_a_n $C9
	ld [hli], a
	ldh_a_n $C8
	ld [hli], a
	jr UnknownRJump_0x5B38C

UnknownCall_0x5B36D:
	ld hl, $ACE8
	ld de, $0020

UnknownRJump_0x5B373:
	add hl, de
	ld a, [hl]
	and a
	jr nz, UnknownRJump_0x5B373
	ld a, h
	cp $AF
	jr z, UnknownRJump_0x5B3AE
	ld d, h
	ld a, l
	and $F0
	ld e, a
	ld hl, $FFD0
	ld b, 5
	call UnknownCall_0x3CAA
	ld h, d
	ld l, e

UnknownRJump_0x5B38C:
	ld a, [$AF36]
	ld [hli], a
	ld a, [$AF28]
	ld [hli], a
	ld a, [$AF29]
	and $F0
	ld [hli], a
	ld a, 1
	ld [hl], a
	ld a, l
	add 3
	ld l, a
	ld a, [$AF37]
	ld [hli], a
	inc l
	ld a, [$AF38]
	ld [hl], a
	ld hl, $AF40
	inc [hl]

UnknownRJump_0x5B3AE:
	xor a
	ld [$AF36], a
	ld [$AF37], a
	ld [$AF38], a
	ret

UnknownData_0x5B3B9:
INCBIN "baserom.gb", $5B3B9, $5B3C6 - $5B3B9


UnknownCall_0x5B3C6:
	call UnknownCall_0x5B3E0
	ld a, [$AF2C]
	dec a
	jr z, UnknownRJump_0x5B3D7
	ld a, 1
	ldh [$FFDF], a
	xor a
	ldh [$FFDD], a
	ret

UnknownRJump_0x5B3D7:
	ld a, 2
	ldh [$FFDF], a
	ld a, 32
	ldh [$FFDD], a
	ret

UnknownCall_0x5B3E0:
	xor a
	ld [$AF2C], a
	ld hl, $FFD0
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, [$AF31]
	cp b
	jr c, UnknownRJump_0x5B3F8
	jr z, UnknownRJump_0x5B3FE

UnknownRJump_0x5B3F2:
	ld a, 1
	ld [$AF2C], a
	ret

UnknownRJump_0x5B3F8:
	ld a, 255
	ld [$AF2C], a
	ret

UnknownRJump_0x5B3FE:
	ld a, [$AF30]
	cp c
	ret z
	jr c, UnknownRJump_0x5B3F8
	jr UnknownRJump_0x5B3F2

UnknownCall_0x5B407:
	call UnknownCall_0x5B41A
	ld a, [$AF2C]
	dec a
	jr z, UnknownRJump_0x5B415
	ld a, 1
	ldh [$FFDF], a
	ret

UnknownRJump_0x5B415:
	ld a, 2
	ldh [$FFDF], a
	ret

UnknownCall_0x5B41A:
	xor a
	ld [$AF2C], a
	ld hl, $FFD3
	ld a, [hli]
	ld b, a
	ld c, [hl]
	ld a, [$AF33]
	cp b
	jr c, UnknownRJump_0x5B432
	jr z, UnknownRJump_0x5B438

UnknownRJump_0x5B42C:
	ld a, 1
	ld [$AF2C], a
	ret

UnknownRJump_0x5B432:
	ld a, 255
	ld [$AF2C], a
	ret

UnknownRJump_0x5B438:
	ld a, [$AF32]
	cp c
	ret z
	jr c, UnknownRJump_0x5B432
	jr UnknownRJump_0x5B42C

UnknownCall_0x5B441:
	ld c, 8
	jr UnknownRJump_0x5B453

UnknownCall_0x5B445:
	ld c, 12
	jr UnknownRJump_0x5B453

UnknownCall_0x5B449:
	ld c, 15
	jr UnknownRJump_0x5B453

UnknownCall_0x5B44D:
	ld c, 18
	jr UnknownRJump_0x5B453

UnknownCall_0x5B451:
	ld c, 21

UnknownRJump_0x5B453:
	ld hl, $7488

UnknownRJump_0x5B456:
	ldh a, [$FFE0]
	ld e, a
	ld d, 0
	add hl, de
	ld b, [hl]
	ld hl, $FFE0
	ld a, [hl]
	cp c
	ret z
	inc [hl]
	ret

UnknownCall_0x5B465:
	ld c, 8
	ld hl, $74AB
	jr UnknownRJump_0x5B456

UnknownCall_0x5B46C:
	ld c, 12
	ld hl, $74A7
	jr UnknownRJump_0x5B456

UnknownCall_0x5B473:
	ld c, 18
	ld hl, $74A1
	jr UnknownRJump_0x5B456

UnknownCall_0x5B47A:
	ld c, 21
	ld hl, $749E
	jr UnknownRJump_0x5B456

UnknownCall_0x5B481:
	ld c, 15
	ld hl, $74A4
	jr UnknownRJump_0x5B456

UnknownData_0x5B488:
INCBIN "baserom.gb", $5B488, $5B4B4 - $5B488


UnknownCall_0x5B4B4:
	ld hl, $FFD1
	ld a, [$AF30]
	sub [hl]
	bit 7, a
	ret z
	cpl
	inc a
	ret

UnknownCall_0x5B4C1:
	ld hl, $FFC0
	ld a, [hli]
	ldh [$FFD4], a
	ld a, [hli]
	ldh [$FFD3], a
	ld a, [hli]
	ldh [$FFD1], a
	ld a, [hl]
	ldh [$FFD0], a
	ld b, 8
	call UnknownCall_0x3D32
	ld a, [sCurPowerup]
	and a
	jr z, UnknownRJump_0x5B4E5
	ld a, [$A291]
	and a
	jr nz, UnknownRJump_0x5B4EF
	ld b, 5
	jr UnknownRJump_0x5B4F1

UnknownRJump_0x5B4E5:
	ld a, [$A291]
	and a
	jr z, UnknownRJump_0x5B4EF
	ld b, 20
	jr UnknownRJump_0x5B4F1

UnknownRJump_0x5B4EF:
	ld b, 14

UnknownRJump_0x5B4F1:
	call UnknownCall_0x3D3D
	ret

UnknownCall_0x5B4F5:
	ldh a, [$FFD6]
	ld h, a
	ldh a, [$FFD7]
	ld l, a
	ld de, $FFD0
	ld b, 5
	call UnknownCall_0x3CAA
	inc l
	inc l
	inc l
	ld a, [hl]
	sub 2
	jr z, UnknownRJump_0x5B50D
	ld a, 1

UnknownRJump_0x5B50D:
	ld [$AF07], a
	ret

UnknownCall_0x5B511:
	ldh a, [$FFF0]
	and $07
	ret nz
	jr UnknownRJump_0x5B526

UnknownCall_0x5B518:
	jr UnknownRJump_0x5B526

UnknownCall_0x5B51A:
	ldh a, [$FFF0]
	and $03
	ret nz
	jr UnknownRJump_0x5B526

UnknownCall_0x5B521:
	ldh a, [$FFF0]
	and $01
	ret nz

UnknownRJump_0x5B526:
	ldh a, [$FFDB]
	xor $01
	ldh [$FFDB], a
	ret

UnknownData_0x5B52D:
INCBIN "baserom.gb", $5B52D, $5B539 - $5B52D


UnknownCall_0x5B539:
	ldh a, [$FFF0]
	and $03
	ret nz
	ldh a, [$FFDB]
	xor $1B
	ldh [$FFDB], a
	ret

UnknownCall_0x5B545:
	ldh a, [$FFF0]
	and $03
	ret nz
	jr UnknownRJump_0x5B551

UnknownCall_0x5B54C:
	ldh a, [$FFF0]
	and $01
	ret nz

UnknownRJump_0x5B551:
	ld hl, $FFEA
	inc [hl]
	ld a, [hl]
	cp $04
	jr nz, UnknownRJump_0x5B562
	xor a
	ld [hl], a
	ldh a, [$FFDD]
	res 5, a
	ldh [$FFDD], a

UnknownRJump_0x5B562:
	ld hl, $757A
	ld e, a
	ld d, 0
	add hl, de
	ldh a, [$FFDB]
	add [hl]
	ldh [$FFDB], a
	ldh a, [$FFEA]
	cp $03
	ret nz
	ldh a, [$FFDD]
	set 5, a
	ldh [$FFDD], a
	ret

UnknownData_0x5B57A:
INCBIN "baserom.gb", $5B57A, $5B57E - $5B57A


UnknownCall_0x5B57E:
	ldh a, [$FFF0]
	and $03
	ret nz
	jr UnknownRJump_0x5B58A

UnknownCall_0x5B585:
	ldh a, [$FFF0]
	and $01
	ret nz

UnknownRJump_0x5B58A:
	ld hl, $FFEA
	inc [hl]
	ld a, [hl]
	cp $04
	jr nz, UnknownRJump_0x5B595
	xor a
	ld [hl], a

UnknownRJump_0x5B595:
	ld hl, $75A2
	ld e, a
	ld d, 0
	add hl, de
	ldh a, [$FFDB]
	add [hl]
	ldh [$FFDB], a
	ret

UnknownData_0x5B5A2:
INCBIN "baserom.gb", $5B5A2, $5B5A6 - $5B5A2


UnknownCall_0x5B5A6:
	ldh a, [$FFF0]
	and $07
	ret nz
	jr UnknownRJump_0x5B5BB

UnknownCall_0x5B5AD:
	ldh a, [$FFF0]
	and $03
	ret nz
	jr UnknownRJump_0x5B5BB

UnknownCall_0x5B5B4:
	jr UnknownRJump_0x5B5BB

UnknownCall_0x5B5B6:
	ldh a, [$FFF0]
	and $01
	ret nz

UnknownRJump_0x5B5BB:
	ld hl, $FFEA
	inc [hl]
	ld a, [hl]
	cp $03
	jr nz, UnknownRJump_0x5B5C6
	xor a
	ld [hl], a

UnknownRJump_0x5B5C6:
	ld hl, $75D3
	ld e, a
	ld d, 0
	add hl, de
	ldh a, [$FFDB]
	add [hl]
	ldh [$FFDB], a
	ret

UnknownData_0x5B5D3:
INCBIN "baserom.gb", $5B5D3, $5B5D8 - $5B5D3


UnknownCall_0x5B5D8:
	ldh a, [$FFF0]
	and $07
	ret nz
	jr UnknownRJump_0x5B5EB

UnknownCall_0x5B5DF:
	ldh a, [$FFF0]
	and $03
	ret nz
	jr UnknownRJump_0x5B5EB

UnknownCall_0x5B5E6:
	ldh a, [$FFF0]
	and $01
	ret nz

UnknownRJump_0x5B5EB:
	ld hl, $FFEA
	inc [hl]
	ld a, [hl]
	cp $04
	jr nz, UnknownRJump_0x5B5F6
	xor a
	ld [hl], a

UnknownRJump_0x5B5F6:
	ld hl, $7603
	ld e, a
	ld d, 0
	add hl, de
	ldh a, [$FFDB]
	add [hl]
	ldh [$FFDB], a
	ret

UnknownData_0x5B603:
INCBIN "baserom.gb", $5B603, $5B607 - $5B603


UnknownCall_0x5B607:
	ldh a, [$FFF0]
	and $03
	ret nz
	ld hl, $FFEA
	inc [hl]
	ld a, [hl]
	cp $04
	jr nz, UnknownRJump_0x5B61D
	xor a
	ld [hl], a
	ldh a, [$FFDD]
	res 5, a
	ldh [$FFDD], a

UnknownRJump_0x5B61D:
	ld hl, $7635
	ld e, a
	ld d, 0
	add hl, de
	ldh a, [$FFDB]
	add [hl]
	ldh [$FFDB], a
	ldh a, [$FFEA]
	cp $03
	ret nz
	ldh a, [$FFDD]
	set 5, a
	ldh [$FFDD], a
	ret

UnknownData_0x5B635:
INCBIN "baserom.gb", $5B635, $5B639 - $5B635


UnknownCall_0x5B639:
	ld hl, $FFEA
	inc [hl]
	ld a, [hl]
	cp $08
	jr nz, UnknownRJump_0x5B644
	xor a
	ld [hl], a

UnknownRJump_0x5B644:
	ld hl, $7669
	ld e, a
	ld d, 0
	add hl, de
	ldh a, [$FFDB]
	add [hl]
	ldh [$FFDB], a
	ldh a, [$FFEA]
	cp $03
	jr z, UnknownRJump_0x5B65B
	cp $06
	jr z, UnknownRJump_0x5B662
	ret

UnknownRJump_0x5B65B:
	ldh a, [$FFDD]
	set 6, a
	ldh [$FFDD], a
	ret

UnknownRJump_0x5B662:
	ldh a, [$FFDD]
	res 6, a
	ldh [$FFDD], a
	ret

UnknownData_0x5B669:
INCBIN "baserom.gb", $5B669, $5B678 - $5B669


UnknownCall_0x5B678:
	ldh a, [$FFF0]
	and $07
	ret nz
	ldh a, [$FFDD]
	xor $20
	ldh [$FFDD], a
	ret

UnknownData_0x5B684:
INCBIN "baserom.gb", $5B684, $5B68B - $5B684


UnknownCall_0x5B68B:
	ldh a, [$FFF0]
	and $01
	ret nz
	ldh a, [$FFDE]
	xor $10
	ldh [$FFDE], a
	ret

UnknownCall_0x5B697:
	ld hl, $AD12

UnknownRJump_0x5B69A:
	ld a, [hl]
	and a
	call nz, UnknownCall_0x5B6A9
	ld de, $0020
	add hl, de
	ld a, h
	cp $AF
	jr nz, UnknownRJump_0x5B69A
	ret

UnknownCall_0x5B6A9:
	ld a, [hl]
	cp $5F
	ret z
	and $A0
	ret nz
	push hl
	ld a, [hli]
	ld [$AF47], a
	ld a, [hli]
	ld [$AF48], a
	ld a, [hli]
	ld [$AF49], a
	ld a, [hli]
	ld [$AF4A], a
	ld a, [hli]
	ld [$AF4B], a
	ld a, l
	sub 14
	ld l, a
	ld a, [hli]
	ld [$AF4C], a
	ld b, a
	ld a, [hl]
	ld [$AF4D], a
	ld c, a
	ld a, [$AF48]
	add 3
	add b
	ld d, a
	ld a, [$AF49]
	add 10
	add b
	sub d
	ld e, a
	ldh a, [$FFD9]
	sub d
	cp e
	jr nc, UnknownRJump_0x5B708
	ld a, [$AF4A]
	sub 5
	add c
	ld d, a
	ld a, [$AF4B]
	add 5
	add c
	sub d
	ld e, a
	ldh a, [$FFDA]
	sub d
	cp e
	jr nc, UnknownRJump_0x5B708
	ld a, l
	add 13
	ld l, a
	set 1, [hl]
	ld a, 1
	ld [$AF2E], a

UnknownRJump_0x5B708:
	pop hl
	ret

UnknownData_0x5B70A:
INCBIN "baserom.gb", $5B70A, $5C000 - $5B70A



SECTION "bank17", ROMX, BANK[$17]


UnknownData_0x5C000: ;per-level group block preceding the Level_xx pointer list
	db $04, $40, $C4, $40, $04, $05, $04, $04, $04, $04, $04, $04, $05, $06, $04, $04
	db $04, $04, $04, $05, $00, $01, $00, $00, $00, $0F, $00, $00, $07, $04, $05, $05
	db $00, $00, $00, $01, $0A, $09, $0E, $0C, $0C, $0D, $0F, $0E, $0C, $08, $09, $09
	db $08, $08, $08, $09, $06, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $05, $0E, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $0C, $0D, $01, $0A, $08, $08, $08, $08, $0C, $0C, $08, $08, $08, $08, $08
	db $08, $08, $08, $09, $06, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $05, $0E, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $0C, $0C, $0D, $0A, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $0D
	db $08, $08, $08, $09, $06, $04, $04, $04, $04, $04, $06, $04, $0C, $0C, $0C, $0C
	db $0C, $0C, $0D, $05, $0E, $0C, $0C, $0C, $0C, $0C, $08, $09, $00, $00, $00, $00
	db $00, $00, $01, $01, $0A, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $09, $09, $00, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $12, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $EE, $AB, $34, $AA, $EA, $FE, $AE, $EB, $A2, $FB, $AF, $AF
	db $AE, $EB, $EF, $AA, $CA, $E9, $6A, $7A, $7F, $AE, $3E, $BA, $EB, $BB, $AF, $B3
	db $BE, $2F, $EE, $EE, $5F, $AD, $BB, $BA, $AA, $BE, $EE, $FE, $EB, $C2, $EE, $A6
	db $EA, $AA, $BB, $EE, $AF, $AE, $2E, $4F, $EB, $A6, $ED, $AE, $AA, $AA, $FB, $9E
	db $EE, $EF, $C3, $AA, $AA, $CE, $8A, $A2, $EF, $8B, $DA, $AE, $AA, $E7, $FE, $AE
	db $FE, $AA, $AE, $2A, $BA, $AA, $6F, $FE, $FA, $A9, $AE, $BB, $EE, $7B, $AF, $8E
	db $ED, $86, $F0, $8A, $AB, $CD, $E8, $AA, $EE, $EB, $AB, $EF, $67, $AB, $2B, $88
	db $EB, $A0, $AE, $CE, $EA, $EA, $EA, $AB, $FA, $AA, $AA, $22, $AA, $4A, $EE, $EA
	db $01, $22, $88, $B9, $AC, $82, $80, $23, $20, $C2, $8A, $02, $20, $0A, $AA, $26
	db $22, $8E, $88, $28, $4A, $88, $68, $2A, $08, $A2, $CA, $68, $42, $62, $0C, $E0
	db $24, $08, $00, $CA, $20, $82, $0A, $02, $28, $E8, $06, $0A, $28, $AA, $60, $CA
	db $62, $8A, $02, $08, $80, $38, $34, $82, $38, $02, $04, $5A, $02, $2A, $B0, $96
	db $A2, $A4, $0A, $A2, $2A, $A3, $C0, $28, $AA, $AE, $68, $48, $C2, $02, $0A, $20
	db $AE, $20, $28, $22, $2A, $6A, $16, $80, $0A, $C8, $AA, $AC, $28, $C2, $00, $88
	db $02, $00, $2A, $00, $C2, $0A, $21, $60, $AA, $8A, $AA, $2A, $88, $C0, $20, $0A
	db $22, $80, $A4, $8A, $84, $B1, $A8, $CE, $AA, $02, $62, $8E, $88, $E0, $88, $06
	db $A0, $6E, $A0, $7A, $C4, $BE, $A3, $3E, $28, $A0, $AE, $E8, $BA, $22, $E3, $6B
	db $DA, $FA, $EA, $FA, $EE, $AA, $AB, $6E, $AE, $CE, $EB, $B6, $EE, $2A, $B2, $87
	db $AE, $EE, $7A, $2A, $28, $BD, $A6, $B0, $EA, $CE, $A0, $8E, $EA, $EB, $AE, $FF
	db $BA, $43, $2E, $8C, $0E, $AE, $BF, $AF, $E8, $EA, $FE, $EA, $AB, $FA, $A8, $F4
	db $AE, $EB, $AA, $C8, $AB, $CB, $FD, $6E, $AA, $4B, $EB, $AE, $C8, $FA, $A2, $E4
	db $2C, $B6, $6E, $8F, $AC, $62, $F8, $AD, $EE, $3A, $EE, $EA, $EA, $E4, $9E, $EA
	db $62, $B2, $CC, $89, $AA, $0C, $8A, $EF, $AF, $EE, $FB, $8E, $A2, $DA, $A8, $4F
;$5C2F0 Pointers to levels 
	dw Level_11
	dw Level_12
	dw Level_13
	dw Level_14
	
UnknownData_0x5C2F8: ;shared group block between the pointer list and Level_11
	db $AF, $E1, $EA, $EE, $6A, $2E, $DA, $EE, $80, $DA, $AA, $8C, $22, $02, $62, $88
	db $AC, $2A, $80, $0C, $42, $0E, $A2, $EA, $90, $82, $08, $28, $B8, $82, $A2, $24
	db $20, $02, $0F, $AA, $06, $E8, $0C, $AA, $32, $82, $40, $8A, $A8, $EA, $2A, $84
	db $A2, $0A, $A8, $6A, $4F, $22, $A0, $AA, $22, $A8, $26, $A8, $0A, $6A, $88, $8A
	db $20, $4A, $20, $A0, $A0, $A0, $02, $A2, $A8, $82, $02, $80, $00, $28, $A0, $8A
	db $8E, $28, $88, $42, $AA, $AA, $E2, $2A, $2A, $81, $A2, $0A, $0A, $CA, $A9, $BE
	db $AA, $E0, $A8, $8A, $80, $CE, $82, $20, $8A, $A0, $A0, $2B, $01, $A8, $86, $62
	db $28, $54, $08, $A8, $24, $40, $2E, $A8, $95, $A2, $32, $2C, $08, $08, $AA, $2C
	db $A8, $A8, $88, $22, $A2, $20, $26, $AE, $AA, $6E, $BA, $A2, $AB, $9A, $B7, $EA
	db $EB, $EE, $FA, $E0, $EE, $AE, $BE, $F8, $FA, $EA, $AB, $E8, $AB, $FE, $AA, $BE
	db $2A, $EA, $AA, $AE, $EF, $BF, $FA, $CA, $EF, $EB, $EE, $BA, $4B, $8A, $AD, $68
	db $AA, $F3, $61, $A7, $E8, $AF, $8A, $AC, $7D, $EC, $EA, $AA, $A2, $AC, $BB, $9E
	db $EA, $AA, $EF, $BA, $3A, $BB, $8F, $E6, $B6, $A9, $EA, $EA, $AA, $B0, $8A, $EA
	db $EF, $FE, $AA, $AB, $6E, $8E, $AE, $AA, $BA, $AE, $2E, $AE, $EB, $ED, $AE, $AF
	db $EA, $A2, $FE, $AA, $AB, $DE, $2B, $E7, $EA, $BB, $9E, $6B, $DA, $EE, $AB, $3A
	db $AF, $AB, $9A, $EA, $ED, $EE, $A0, $EA, $2E, $FE, $6B, $AF, $EA, $8B, $AA, $BA
	db $A7, $EA, $BE, $06, $2B, $A8, $EE, $7C, $0A, $22, $A8, $20, $20, $AB, $28, $2B
	db $AB, $08, $12, $A2, $74, $A2, $24, $92, $AC, $84, $2C, $22, $02, $B4, $88, $03
	db $AA, $EE, $2C, $A9, $0C, $E3, $87, $2A, $2A, $AA, $1E, $18, $A0, $30, $C7, $80
	db $02, $2E, $92, $80, $38, $22, $B0, $7A, $09, $70, $05, $06, $80, $22, $8A, $A3
	db $20, $09, $AC, $34, $2B, $24, $2E, $A0, $02, $40, $A0, $2A, $B6, $20, $84, $A2
	db $A5, $A2, $22, $23, $B2, $6A, $48, $E0, $80, $8A, $8E, $C4, $28, $82, $23, $C2
	db $80, $96, $A2, $02, $A0, $28, $81, $6A, $21, $88, $8C, $9A, $88, $98, $12, $80
	db $A6, $88, $02, $86, $20, $22, $A2, $2B, $88, $27, $28, $24, $0A, $08, $82, $AA
	db $20, $2C, $33, $2C, $60, $AB, $AB, $88, $BA, $EE, $CA, $FA, $BA, $AF, $BA, $B8
	db $AF, $EF, $DB, $3A, $FA, $BE, $BE, $AC, $AD, $BB, $AE, $2E, $FF, $AE, $FF, $FA
	db $FE, $AC, $EA, $EB, $A0, $B8, $EF, $A3, $27, $AB, $BF, $E6, $E2, $BC, $E3, $EF
	db $8A, $CD, $B8, $ED, $DE, $AF, $EF, $9A, $3B, $B1, $EE, $E6, $8E, $EF, $BF, $BA
	db $BB, $B2, $A8, $ED, $2C, $2E, $CA, $BB, $AB, $8A, $E1, $FE, $AF, $9C, $E2, $E6
	db $B7, $2F, $CE, $EF, $CA, $FB, $AF, $DA, $E3, $2A, $AA, $0C, $EA, $7F, $3A, $BF
	db $3C, $DE, $AB, $D9, $8F, $8A, $ED, $AA, $FA, $EE, $BE, $EA, $BA, $7A, $2D, $BE
	db $EA, $5C, $DA, $AA, $BB, $AF, $E0, $AD, $6A, $0E, $A4, $0E, $FB, $A9, $B9, $EF
	db $B2, $9A, $EE, $AA, $AE, $FE, $EB, $22

Level_11: ;$5C500
INCBIN "levels/level11.bin"

Level_12: ;$5CE21
INCBIN "levels/level12.bin"

Level_13: ;$5D980
INCBIN "levels/level13.bin"

Level_14: ;$5E4F4
INCBIN "levels/level14.bin"



SECTION "bank18", ROMX, BANK[$18]


UnknownData_0x60000:
INCBIN "baserom.gb", $60000, $60028 - $60000

	ld a, [$A7A6]
	add a
	ld d, 0
	ld e, a
	ld hl, $4037
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

UnknownData_0x60037:
INCBIN "baserom.gb", $60037, $6004F - $60037

	call UnknownCall_0x6046A
	ld a, [$A69A]
	and $01
	jp z, UnknownJump_0x60461
	ldh_a_n $C5
	cp $28
	jr nz, UnknownRJump_0x6006E
	ld a, 1
	ld [$A7A6], a
	call UnknownCall_0x60C41
	ldh_n_a $C6
	jr UnknownRJump_0x60097

UnknownRJump_0x6006E:
	inc a
	ldh_n_a $C5
	ld a, [$A69A]
	and $02
	jr z, UnknownRJump_0x60088
	ld a, [$A795]
	inc a
	ld [$A795], a
	cp $03
	jr c, UnknownRJump_0x60088
	xor a
	ld [$A795], a

UnknownRJump_0x60088:
	call UnknownCall_0x60C41
	ld e, a
	ld a, [$A795]
	add e
	inc a
	ldh_n_a $C6
	jp UnknownJump_0x60461

UnknownRJump_0x60097:
	call UnknownCall_0x6046A
	ldh_a_n $80
	bit 0, a
	jr nz, UnknownRJump_0x600AC
	bit 5, a
	jr nz, UnknownRJump_0x600B9
	bit 4, a
	jr nz, UnknownRJump_0x600C6
	jp UnknownJump_0x60461

UnknownRJump_0x600AC:
	ld a, 4
	ld [$A7A6], a
	ld a, 16
	ld [$A7A7], a
	jp UnknownJump_0x60182

UnknownRJump_0x600B9:
	ld a, 2
	ld [$A7A6], a
	ld a, 32
	ld [$A7A7], a
	jp UnknownJump_0x600D3

UnknownRJump_0x600C6:
	ld a, 3
	ld [$A7A6], a
	ld a, 32
	ld [$A7A7], a
	jp UnknownJump_0x6012B

UnknownJump_0x600D3:
	call UnknownCall_0x6046A
	ld a, [$A69A]
	and $03
	jp z, UnknownJump_0x60461
	ldh_a_n $C5
	cp $28
	jp z, UnknownJump_0x6011D
	ld a, [$A7A7]
	or a
	jr z, UnknownRJump_0x6011D
	dec a
	ld [$A7A7], a
	ldh_a_n $C5
	dec a
	ldh_n_a $C5
	ld a, [$A69A]
	and $02
	jr z, UnknownRJump_0x6010D
	ld a, [$A795]
	inc a
	ld [$A795], a
	cp $03
	jr c, UnknownRJump_0x6010D
	xor a
	ld [$A795], a

UnknownRJump_0x6010D:
	call UnknownCall_0x60C41
	ld e, a
	ld a, [$A795]
	add e
	add 5
	ldh_n_a $C6
	jp UnknownJump_0x60461

UnknownJump_0x6011D:
UnknownRJump_0x6011D:
	ld a, 1
	ld [$A7A6], a
	call UnknownCall_0x60C41
	ldh_n_a $C6
	jp UnknownJump_0x60461

UnknownJump_0x6012B:
	call UnknownCall_0x6046A
	ld a, [$A69A]
	and $03
	jp z, UnknownJump_0x60461
	ldh_a_n $C5
	cp $88
	jp z, UnknownJump_0x60174
	ld a, [$A7A7]
	or a
	jr z, UnknownRJump_0x60174
	dec a
	ld [$A7A7], a
	ldh_a_n $C5
	inc a
	ldh_n_a $C5
	ld a, [$A69A]
	and $02
	jr z, UnknownRJump_0x60165
	ld a, [$A795]
	inc a
	ld [$A795], a
	cp $03
	jr c, UnknownRJump_0x60165
	xor a
	ld [$A795], a

UnknownRJump_0x60165:
	call UnknownCall_0x60C41
	ld e, a
	ld a, [$A795]
	add e
	inc a
	ldh_n_a $C6
	jp UnknownJump_0x60461

UnknownJump_0x60174:
UnknownRJump_0x60174:
	ld a, 1
	ld [$A7A6], a
	call UnknownCall_0x60C41
	ldh_n_a $C6
	jp UnknownJump_0x60461

UnknownJump_0x60182:
	call UnknownCall_0x60269
	ld a, [$A69A]
	and $03
	jp z, UnknownJump_0x60461
	ld a, [$A7A7]
	or a
	jr z, UnknownRJump_0x601D9
	dec a
	ld [$A7A7], a
	ld b, 0
	ld c, a
	ld hl, $421A
	add hl, bc
	ld a, [hl]
	ld c, a
	ldh_a_n $C4
	add c
	ldh_n_a $C4
	call UnknownCall_0x60C41
	add 8
	ldh_n_a $C6
	ld a, [$A7A7]
	cp $08
	call z, UnknownCall_0x601BA
	jp UnknownJump_0x60461

UnknownCall_0x601BA:
	ld hl, $A7ED
	ld d, 0
	ldh_a_n $C5
	sub 40
	and $60
	swap a
	rrca
	ld e, a
	add hl, de
	add hl, de
	add hl, de
	ld a, 1
	ld [hl], a
	call UnknownCall_0x610DD
	ld a, 8
	ld [$A468], a
	ret

UnknownRJump_0x601D9:
	ld a, 5
	ld [$A7A6], a
	call UnknownCall_0x60C41
	ldh_n_a $C6
	ld hl, $A7D2
	ld d, 0
	ld a, [$A7B0]
	ld e, a
	add hl, de
	add hl, de
	add hl, de
	ld a, 0
	ld [hl], a
	ld hl, $A7D2
	ld d, 0
	ld a, [$A7B1]
	ld e, a
	add hl, de
	add hl, de
	add hl, de
	ld a, 0
	ld [hl], a
	call UnknownCall_0x610DD
	ldh_a_n $C5
	sub 4
	ld [$A6DF], a
	ld a, 42
	ld [$A6E1], a
	ld a, 3
	ld [$A7B3], a
	jp UnknownJump_0x6022A

UnknownData_0x6021A:
INCBIN "baserom.gb", $6021A, $6022A - $6021A


UnknownJump_0x6022A:
	ld a, [$A69A]
	and $01
	jp z, UnknownJump_0x60461
	ld a, 4
	ld [$A478], a
	ld a, [$A69A]
	and $02
	jr z, UnknownRJump_0x6024B
	ld a, [$A6E1]
	inc a
	cp $2D
	jr c, UnknownRJump_0x60248
	ld a, 42

UnknownRJump_0x60248:
	ld [$A6E1], a

UnknownRJump_0x6024B:
	ld a, [$A7B3]
	cp $03
	call z, UnknownCall_0x60290
	ld a, [$A7B3]
	cp $01
	call z, UnknownCall_0x60314
	ld a, [$A7B3]
	cp $02
	call z, UnknownCall_0x6032A
	call UnknownCall_0x60269
	jp UnknownJump_0x60461

UnknownCall_0x60269:
	ld b, 37
	ld a, [$A69A]
	bit 3, a
	jp z, UnknownJump_0x60275
	ld b, 38

UnknownJump_0x60275:
	ld hl, $A6C6
	ld d, 0
	ld a, [$A7B0]
	ld e, a
	add hl, de
	add hl, de
	add hl, de
	ld [hl], b
	ld hl, $A6C6
	ld d, 0
	ld a, [$A7B1]
	ld e, a
	add hl, de
	add hl, de
	add hl, de
	ld [hl], b
	ret

UnknownCall_0x60290:
	ld a, [$A6E0]
	dec a
	ld [$A6E0], a
	and $07
	jr nz, UnknownRJump_0x602E9
	ld b, 0
	ld a, [$A6E0]
	and $F8
	sub 16
	sla a
	rl b
	sla a
	rl b
	ld c, a
	ld a, [$A6DF]
	sub 12
	srl a
	srl a
	srl a
	ld h, 152
	ld l, a
	add hl, bc
	push hl
	ld hl, rSTAT

UnknownRJump_0x602C0:
	bit 1, [hl]
	jr nz, UnknownRJump_0x602C0
	pop hl
	ld a, [hli]
	ld b, a
	ld a, [hl]
	cp $3D
	jr z, UnknownRJump_0x602D3
	ld a, b
	cp $3C
	jr z, UnknownRJump_0x602DE
	jr UnknownRJump_0x602E9

UnknownRJump_0x602D3:
	ld a, 1
	ld [$A7B3], a
	ld a, 32
	ld [$A7B4], a
	ret

UnknownRJump_0x602DE:
	ld a, 2
	ld [$A7B3], a
	ld a, 32
	ld [$A7B4], a
	ret

UnknownRJump_0x602E9:
	ld a, [$A6E0]
	cp $2A
	ret nc
	ld a, 6
	ld [$A7A6], a
	ld a, [$A6DF]
	sub 4
	ld [$A6E2], a
	ld a, [$A6DF]
	sub 36
	and $60
	swap a
	rrca
	ld [$A7A8], a
	ld a, 255
	ld [$A6E1], a
	ld a, 39
	ld [$A6E4], a
	ret

UnknownCall_0x60314:
	ld a, [$A6DF]
	inc a
	ld [$A6DF], a
	ld a, [$A7B4]
	dec a
	ld [$A7B4], a
	or a
	ret nz
	ld a, 3
	ld [$A7B3], a
	ret

UnknownCall_0x6032A:
	ld a, [$A6DF]
	dec a
	ld [$A6DF], a
	ld a, [$A7B4]
	dec a
	ld [$A7B4], a
	or a
	ret nz
	ld a, 3
	ld [$A7B3], a
	ret
	call UnknownCall_0x60269
	ld a, [$A6E4]
	cp $FF
	jr z, UnknownRJump_0x60373
	ld a, [$A69A]
	and $0F
	jp nz, UnknownJump_0x60461
	ld a, [$A6E4]
	cp $27
	call z, UnknownCall_0x603F9
	ld a, [$A6E4]
	cp $29
	call z, UnknownCall_0x6042D
	ld a, [$A6E4]
	cp $FF
	jr z, UnknownRJump_0x60373
	ld a, [$A6E4]
	inc a
	ld [$A6E4], a
	jp UnknownJump_0x60461

UnknownRJump_0x60373:
	ld a, [$A7A8]
	ld d, 0
	ld e, a
	ld hl, $A6B9
	add hl, de
	add hl, de
	add hl, de
	ld a, [hl]
	inc a
	ld [hl], a
	cp $70
	jr c, UnknownRJump_0x603AA
	ld a, 7
	ld [$A7A6], a
	ld hl, $A6BA
	ld a, [$A7A8]
	ld d, 0
	ld e, a
	add hl, de
	add hl, de
	add hl, de
	ld a, 255
	ld [hl], a
	call UnknownCall_0x60917
	ld a, 20
	ld [$A7A7], a
	ld a, 116
	ld [$A6E3], a
	jp UnknownJump_0x60433

UnknownRJump_0x603AA:
	call UnknownCall_0x60C41
	ldh_n_a $C6
	ld hl, $A6B8
	ld a, [$A7A8]
	ld d, 0
	ld e, a
	add hl, de
	add hl, de
	add hl, de
	ld a, [hl]
	add 8
	ld b, a
	ldh_a_n $C5
	cp b
	jp z, UnknownJump_0x60461
	jr c, UnknownRJump_0x603CE
	dec a
	ld c, 5
	jr UnknownRJump_0x603D1

UnknownRJump_0x603CE:
	inc a
	ld c, 1

UnknownRJump_0x603D1:
	ldh_n_a $C5
	ld a, [$A69A]
	and $03
	jr nz, UnknownRJump_0x603EA
	ld a, [$A795]
	inc a
	ld [$A795], a
	cp $03
	jr c, UnknownRJump_0x603EA
	xor a
	ld [$A795], a

UnknownRJump_0x603EA:
	call UnknownCall_0x60C41
	ld e, a
	ld a, [$A795]
	add e
	add c
	ldh_n_a $C6
	jp UnknownJump_0x60461

UnknownCall_0x603F9:
	ld a, [$A7A8]
	and $03
	rlca
	rlca
	add 3
	ld hl, $9840
	ld d, 0
	ld e, a
	add hl, de
	push hl
	ld hl, rSTAT

UnknownRJump_0x6040D:
	bit 1, [hl]
	jr nz, UnknownRJump_0x6040D
	pop hl
	ld a, 255
	ld [hli], a
	ld [hl], a
	ld de, $001F
	add hl, de
	push hl
	ld hl, rSTAT

UnknownRJump_0x6041E:
	bit 1, [hl]
	jr nz, UnknownRJump_0x6041E
	pop hl
	ld a, 255
	ld [hli], a
	ld [hl], a
	ld a, 22
	ld [$A468], a
	ret

UnknownCall_0x6042D:
	ld a, 255
	ld [$A6E4], a
	ret

UnknownJump_0x60433:
	ld a, [$A69A]
	and $03
	jp nz, UnknownJump_0x60461
	call UnknownCall_0x606AA
	jp UnknownJump_0x60461

UnknownData_0x60441:
INCBIN "baserom.gb", $60441, $60444 - $60441

	ld a, [$A69A]
	and $01
	jp z, UnknownJump_0x60461
	ld a, [$A7A7]
	dec a
	ld [$A7A7], a
	or a
	jr nz, UnknownRJump_0x60461
	ld a, 10
	ld [$A7A6], a
	jp UnknownJump_0x60461

UnknownData_0x6045E:
INCBIN "baserom.gb", $6045E, $60461 - $6045E


UnknownJump_0x60461:
UnknownRJump_0x60461:
	call UnknownCall_0x6106D
	call UnknownCall_0x3F44
	jp UnknownJump_0x3E07

UnknownCall_0x6046A:
	ld a, [$A69A]
	and $07
	jp nz, UnknownJump_0x604F3
	ld a, [$A7B0]
	ld c, a
	ld b, 0
	ld hl, $A6C6
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, 255
	ld [hl], a

UnknownRJump_0x60481:
	push bc
	ldh a, [rDIV]
	ld b, a
	swap a
	add b
	ld b, a
	ld a, [$A7B7]
	add b
	ld b, a
	ldh_a_n $97
	add b
	ld [$A7B7], a
	pop bc
	and $0F
	cp $09
	jr nc, UnknownRJump_0x60481
	ld c, a
	ld a, [$A7B1]
	cp c
	jr z, UnknownRJump_0x60481
	ld a, c
	ld [$A7B0], a
	ld b, 0
	ld hl, $A6C6
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, 37
	ld [hl], a
	ld a, [$A7B1]
	ld c, a
	ld b, 0
	ld hl, $A6C6
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, 255
	ld [hl], a

UnknownRJump_0x604C1:
	push bc
	ldh a, [rDIV]
	ld b, a
	swap a
	add b
	ld b, a
	ld a, [$A7B7]
	add b
	ld b, a
	ldh_a_n $97
	add b
	ld [$A7B7], a
	pop bc
	and $0F
	cp $09
	jr nc, UnknownRJump_0x604C1
	ld c, a
	ld a, [$A7B0]
	cp c
	jr z, UnknownRJump_0x604C1
	ld a, c
	ld [$A7B1], a
	ld b, 0
	ld hl, $A6C6
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, 37
	ld [hl], a
	ret

UnknownJump_0x604F3:
	ld a, [$A7B0]
	ld c, a
	ld b, 0
	ld hl, $A6C6
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, 37
	ld [hl], a
	ld a, [$A7B1]
	ld c, a
	ld b, 0
	ld hl, $A6C6
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, 37
	ld [hl], a
	ret
	ld a, [$A7A6]
	add a
	ld d, 0
	ld e, a
	ld hl, $4521
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

UnknownData_0x60521:
INCBIN "baserom.gb", $60521, $60539 - $60521

	ld a, [$A69A]
	and $01
	jp z, UnknownJump_0x607AA
	ldh_a_n $C5
	cp $20
	jr nz, UnknownRJump_0x60559
	ld a, 1
	ld [$A7A6], a
	call UnknownCall_0x60C41
	ldh_n_a $C6
	xor a
	ld [$A7B2], a
	jr UnknownRJump_0x60582

UnknownRJump_0x60559:
	inc a
	ldh_n_a $C5
	ld a, [$A69A]
	and $02
	jr z, UnknownRJump_0x60573
	ld a, [$A795]
	inc a
	ld [$A795], a
	cp $03
	jr c, UnknownRJump_0x60573
	xor a
	ld [$A795], a

UnknownRJump_0x60573:
	call UnknownCall_0x60C41
	ld e, a
	ld a, [$A795]
	add e
	inc a
	ldh_n_a $C6
	jp UnknownJump_0x607AA

UnknownRJump_0x60582:
	ldh_a_n $81
	and $01
	jr z, UnknownRJump_0x6059A
	ld a, 2
	ld [$A7A6], a
	ld a, 24
	ld [$A7A7], a
	ld a, 8
	ld [$A468], a
	jr UnknownRJump_0x605A0

UnknownRJump_0x6059A:
	call UnknownCall_0x60800
	jp UnknownJump_0x607AA

UnknownRJump_0x605A0:
	ld a, [$A69A]
	and $03
	jr nz, UnknownRJump_0x605C7
	ld a, [$A7A7]
	or a
	jr nz, UnknownRJump_0x605B9
	ld a, 3
	ld [$A7A6], a
	ld a, 0
	ld [$A7A7], a
	jr UnknownRJump_0x605CA

UnknownRJump_0x605B9:
	ld a, [$A7A7]
	dec a
	ld [$A7A7], a
	ld a, [$A6BC]
	inc a
	ld [$A6BC], a

UnknownRJump_0x605C7:
	jp UnknownJump_0x607AA

UnknownRJump_0x605CA:
	ld a, [$A69A]
	and $03
	jr nz, UnknownRJump_0x605EB
	ld a, [$A6BD]
	cp $23
	jr c, UnknownRJump_0x605E4
	ld a, 4
	ld [$A7A6], a
	ld a, 32
	ld [$A7A7], a
	jr UnknownRJump_0x605EE

UnknownRJump_0x605E4:
	ld a, [$A6BD]
	inc a
	ld [$A6BD], a

UnknownRJump_0x605EB:
	jp UnknownJump_0x607AA

UnknownRJump_0x605EE:
	ld a, [$A69A]
	and $03
	jr nz, UnknownRJump_0x60619
	ld a, [$A7A7]
	or a
	jr nz, UnknownRJump_0x60602
	ld a, 5
	ld [$A7A6], a
	jr UnknownRJump_0x60639

UnknownRJump_0x60602:
	ld a, [$A7A7]
	dec a
	ld [$A7A7], a
	or a
	call z, UnknownCall_0x6062D
	ld a, [$A6BC]
	dec a
	ld [$A6BC], a
	cp $48
	call z, UnknownCall_0x6061C

UnknownRJump_0x60619:
	jp UnknownJump_0x607AA

UnknownCall_0x6061C:
	ld a, [$A7B2]
	cp $01
	ret z
	ld a, 9
	ld [$A7A6], a
	ld a, 17
	ld [$A460], a
	ret

UnknownCall_0x6062D:
	ld a, [$A7B2]
	cp $01
	ret nz
	ld a, 22
	ld [$A468], a
	ret

UnknownRJump_0x60639:
	ld a, [$A69A]
	bit 0, a
	jr nz, UnknownRJump_0x60658
	ld a, [$A6B8]
	cp $1D
	jr nc, UnknownRJump_0x6064E
	ld a, 6
	ld [$A7A6], a
	jr UnknownRJump_0x6065B

UnknownRJump_0x6064E:
	ld a, [$A6B8]
	dec a
	ld [$A6B8], a
	ld [$A6BB], a

UnknownRJump_0x60658:
	jp UnknownJump_0x607AA

UnknownRJump_0x6065B:
	ld a, [$A69A]
	and $03
	jr nz, UnknownRJump_0x6067C
	ld a, [$A6BD]
	cp $21
	jr nz, UnknownRJump_0x60675
	ld a, 7
	ld [$A7A6], a
	ld a, 25
	ld [$A7A7], a
	jr UnknownRJump_0x6067F

UnknownRJump_0x60675:
	ld a, [$A6BD]
	dec a
	ld [$A6BD], a

UnknownRJump_0x6067C:
	jp UnknownJump_0x607AA

UnknownRJump_0x6067F:
	ld a, [$A69A]
	and $03
	jp nz, UnknownJump_0x607AA
	ld a, [$A7A7]
	or a
	jr z, UnknownRJump_0x60694
	dec a
	ld [$A7A7], a
	jp UnknownJump_0x607AA

UnknownRJump_0x60694:
UnknownData_0x60694:
INCBIN "baserom.gb", $60694, $6069C - $60694

	ld a, [$A69A]
	and $03
	jp nz, UnknownJump_0x607AA
	call UnknownCall_0x606AA
	jp UnknownJump_0x607AA

UnknownCall_0x606AA:
	ld a, [$A7A8]
	cp $03
	jr nc, UnknownRJump_0x60711
	ld a, [$A69A]
	and $0C
	jr nz, UnknownRJump_0x606BE
	ld a, [$A7AC]
	ld e, a
	jr UnknownRJump_0x606DF

UnknownRJump_0x606BE:
	cp $04
	jr nz, UnknownRJump_0x606C6
	ld e, 0
	jr UnknownRJump_0x606DF

UnknownRJump_0x606C6:
	cp $08
	jr nz, UnknownRJump_0x606D7
	ld a, [$A7AB]
	ld e, a
	or a
	jr nz, UnknownRJump_0x606DF
	ld a, [$A7AC]
	ld e, a
	jr UnknownRJump_0x606DF

UnknownRJump_0x606D7:
	ld e, 0
	jr UnknownRJump_0x606DF

UnknownJump_0x606DB:
	ld a, [$A7AC]
	ld e, a

UnknownRJump_0x606DF:
	ld d, 0
	ld hl, $4C4D
	add hl, de
	ld a, [hl]
	ldh_n_a $C6
	ld a, [$A7A7]
	dec a
	ld [$A7A7], a
	or a
	ret nz
	ld a, [$A7AC]
	ld [sCurPowerup], a
	ld d, 0
	ld e, a
	ld hl, $4C4D
	add hl, de
	ld a, [hl]
	ldh_n_a $C6
	ld a, 9
	ld [$A7A6], a
	ld a, 20
	ld [$A7A7], a
	call UnknownCall_0x2934
	ret

UnknownRJump_0x60711:
	ld c, 30
	ld a, [$A7A8]
	cp $03
	jr nz, UnknownRJump_0x60723
	ld c, 29
	ld a, [$A68B]
	cp $0E
	jr z, UnknownRJump_0x6073D

UnknownRJump_0x60723:
	ld a, c
	ld [$A6DB], a
	ld a, [$A6DA]
	cp $60
	jr c, UnknownRJump_0x60735
	dec a
	ld [$A6DA], a
	jp UnknownJump_0x606DB

UnknownRJump_0x60735:
	ld a, 255
	ld [$A6DB], a
	jp UnknownJump_0x606DB

UnknownRJump_0x6073D:
	ld a, c
	ld [$A6E4], a
	ld a, [$A6E3]
	cp $62
	jr c, UnknownRJump_0x60757
	dec a
	ld [$A6E3], a
	ldh_a_n $C5
	sub 4
	ld [$A6E2], a
	jp UnknownJump_0x606DB

UnknownRJump_0x60757:
	ld a, 255
	ld [$A6E4], a
	ld a, 176
	ld [$A6E2], a
	jp UnknownJump_0x606DB
	ld a, [$A69A]
	and $01
	jp z, UnknownJump_0x607AA
	call UnknownCall_0x60772
	jp UnknownJump_0x607AA

UnknownCall_0x60772:
	ldh_a_n $C5
	cp $E8
	jr nz, UnknownRJump_0x6077F
	ld a, 10
	ld [$A7A6], a
	ret

UnknownRJump_0x6077F:
	dec a
	ldh_n_a $C5
	ld a, [$A69A]
	and $02
	jr z, UnknownRJump_0x60799
	ld a, [$A795]
	inc a
	ld [$A795], a
	cp $03
	jr c, UnknownRJump_0x60799
	xor a
	ld [$A795], a

UnknownRJump_0x60799:
	call UnknownCall_0x60C41
	ld e, a
	ld a, [$A795]
	add e
	add 5
	ldh_n_a $C6
	ret

UnknownData_0x607A7:
INCBIN "baserom.gb", $607A7, $607AA - $607A7


UnknownJump_0x607AA:
	call UnknownCall_0x607C5
	call UnknownCall_0x6083C
	call UnknownCall_0x6083C
	call UnknownCall_0x6083C
	call UnknownCall_0x6083C
	call UnknownCall_0x6083C
	call UnknownCall_0x6106D
	call UnknownCall_0x3F44
	jp UnknownJump_0x3E07

UnknownCall_0x607C5:
	ld a, 255
	ld [$A6C0], a
	ld [$A6C3], a
	ld [$A6C6], a
	ld [$A6C9], a
	ld a, [$A6BC]
	cp $3E
	ret c
	ld a, 32
	ld [$A6C0], a
	ld a, [$A6BC]
	cp $46
	ret c
	ld a, 32
	ld [$A6C3], a
	ld a, [$A6BC]
	cp $4E
	ret c
	ld a, 32
	ld [$A6C6], a
	ld a, [$A6BC]
	cp $56
	ret c
	ld a, 32
	ld [$A6C9], a
	ret

UnknownCall_0x60800:
	ld a, [$A69A]
	and $03
	ret z
	ld a, [$A6B8]
	ld e, a
	ld a, [$A7A7]
	bit 0, a
	jr nz, UnknownRJump_0x60822
	ld a, e
	cp $78
	jr nc, UnknownRJump_0x60819
	inc e
	jr UnknownRJump_0x60828

UnknownRJump_0x60819:
	ld a, [$A7A7]
	cpl
	ld [$A7A7], a
	jr UnknownRJump_0x60828

UnknownRJump_0x60822:
	ld a, e
	cp $50
	jr c, UnknownRJump_0x60819
	dec e

UnknownRJump_0x60828:
	ld a, e
	ld [$A6B8], a
	ld [$A6BB], a
	ld [$A6BE], a
	ld [$A6C1], a
	ld [$A6C4], a
	ld [$A6C7], a
	ret

UnknownCall_0x6083C:
	ld a, [$A7E9]
	cp $05
	jr c, UnknownRJump_0x60847
	xor a
	ld [$A7E9], a

UnknownRJump_0x60847:
	ld d, 0
	ld e, a
	ld hl, $A7D0
	add hl, de
	ld a, [hl]
	or a
	jp z, UnknownJump_0x60865
	cp $01
	jp z, UnknownJump_0x608BB
	cp $02
	jp z, UnknownJump_0x608E1
	cp $03
	jp z, UnknownJump_0x60965

UnknownData_0x60862:
INCBIN "baserom.gb", $60862, $60865 - $60862


UnknownJump_0x60865:
	ld a, [$A69A]
	and $01
	jp nz, UnknownJump_0x609E4
	ld hl, $A7D5
	add hl, de
	ld a, [hl]
	dec a
	ld [hl], a
	cp $32
	jr nc, UnknownRJump_0x6088C
	ld a, 142
	ld [hl], a
	ld a, 3
	ld hl, $A7D0
	add hl, de
	ld [hl], a
	ld a, 28
	ld hl, $A7DF
	add hl, de
	ld [hl], a
	jp UnknownJump_0x60965

UnknownRJump_0x6088C:
	ld a, [$A7A6]
	cp $03
	call z, UnknownCall_0x60897
	jp UnknownJump_0x609E4

UnknownCall_0x60897:
	ld hl, $A7E4
	add hl, de
	ld a, [hl]
	cp $05
	ret nc
	ld hl, $A7D5
	add hl, de
	ld a, [$A6BB]
	sub 12
	cp [hl]
	ret nc
	add 16
	cp [hl]
	ret c
	ld hl, $A7D0
	add hl, de
	ld a, 1
	ld [hl], a
	ld a, 1
	ld [$A7B2], a
	ret

UnknownJump_0x608BB:
	ld a, [$A6BB]
	sub 4
	ld hl, $A7D5
	add hl, de
	ld [hl], a
	ld a, [$A6BC]
	add 8
	ld hl, $A7DA
	add hl, de
	ld [hl], a
	ld a, [$A7A6]
	cp $07
	jp nz, UnknownJump_0x609E4
	ld a, 2
	ld hl, $A7D0
	add hl, de
	ld [hl], a
	jp UnknownJump_0x609E4

UnknownJump_0x608E1:
	ld hl, $A7DA
	add hl, de
	ld a, [hl]
	inc a
	ld [hl], a
	cp $68
	jp c, UnknownJump_0x609E4
	ld a, 3
	ld hl, $A7D0
	add hl, de
	ld [hl], a
	ld a, 255
	ld hl, $A7DF
	add hl, de
	ld [hl], a
	ld a, 8
	ld [$A7A6], a
	ld a, 20
	ld [$A7A7], a
	ld hl, $A6CC
	add hl, de
	add hl, de
	add hl, de
	ld a, [hl]
	sub 24
	ld [$A7A8], a
	call UnknownCall_0x60917
	jp UnknownJump_0x609E4

UnknownCall_0x60917:
	ld a, [sCurPowerup]
	ld [$A7AB], a
	ld [$A7AC], a
	ld a, [$A7A8]
	cp $03
	jp nc, UnknownJump_0x60939
	ld hl, $4C51
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [$A7AC], a
	ld a, 20
	ld [$A470], a
	ret

UnknownJump_0x60939:
	ld a, 9
	ld [$A460], a
	ld a, [$A7A8]
	cp $03
	jr nz, UnknownRJump_0x60955
	ld a, [$A22C]
	add 1
	daa
	ld [$A22C], a
	ret nc

UnknownData_0x6094F:
INCBIN "baserom.gb", $6094F, $60955 - $6094F


UnknownRJump_0x60955:
	ld a, [$A22C]
	add 3
	daa
	ld [$A22C], a
	ret nc

UnknownData_0x6095F:
INCBIN "baserom.gb", $6095F, $60965 - $6095F


UnknownJump_0x60965:
	ld a, 142
	ld hl, $A7D5
	add hl, de
	ld [hl], a
	ld a, 96
	ld hl, $A7DA
	add hl, de
	ld [hl], a
	ld a, [$A7AE]
	ld l, a
	ld a, [$A7AF]
	ld h, a
	ld a, [hl]
	cp $06
	jr c, UnknownRJump_0x6098F
	ld a, [$A7B5]
	ld [$A7AE], a
	ld l, a
	ld a, [$A7B6]
	ld [$A7AF], a
	ld h, a
	ld a, [hl]

UnknownRJump_0x6098F:
	ld hl, $A7E4
	add hl, de
	ld [hl], a
	ld a, 255
	ld hl, $A6CC
	add hl, de
	add hl, de
	add hl, de
	ld [hl], a
	ld a, [$A69A]
	and $01
	jp nz, UnknownJump_0x609E4
	ld hl, $A7DF
	add hl, de
	ld a, [hl]
	cp $FF
	jp z, UnknownJump_0x609E4
	or a
	jr z, UnknownRJump_0x609B7
	dec a
	ld [hl], a
	jp UnknownJump_0x609E4

UnknownRJump_0x609B7:
	ld hl, $A7E4
	add hl, de
	ld a, [hl]
	cp $05
	jr z, UnknownRJump_0x609C9
	add 24
	ld hl, $A6CC
	add hl, de
	add hl, de
	add hl, de
	ld [hl], a

UnknownRJump_0x609C9:
	ld a, 0
	ld hl, $A7D0
	add hl, de
	ld [hl], a
	ld a, [$A7AE]
	ld l, a
	ld a, [$A7AF]
	ld h, a
	inc hl
	ld a, l
	ld [$A7AE], a
	ld a, h
	ld [$A7AF], a
	jp UnknownJump_0x609E4

UnknownJump_0x609E4:
	ld hl, $A7D5
	ld a, [hli]
	ld [$A6CA], a
	ld a, [hli]
	ld [$A6CD], a
	ld a, [hli]
	ld [$A6D0], a
	ld a, [hli]
	ld [$A6D3], a
	ld a, [hl]
	ld [$A6D6], a
	ld hl, $A7DA
	ld a, [hli]
	ld [$A6CB], a
	ld a, [hli]
	ld [$A6CE], a
	ld a, [hli]
	ld [$A6D1], a
	ld a, [hli]
	ld [$A6D4], a
	ld a, [hl]
	ld [$A6D7], a
	ld a, [$A7E9]
	inc a
	ld [$A7E9], a
	ret

UnknownData_0x60A1A:
INCBIN "baserom.gb", $60A1A, $60A81 - $60A1A

	ld a, [$A7A6]
	cp $00
	jr nz, UnknownRJump_0x60AEC
	ld a, [$A6BD]
	cp $07
	jr nz, UnknownRJump_0x60AA7
	ldh_a_n $81
	bit 0, a
	jr z, UnknownRJump_0x60AA7
	ld a, 5
	ld [$A7A6], a
	ld a, 0
	ld [$A79A], a
	ld a, 1
	ld [$A460], a
	jr UnknownRJump_0x60AEC

UnknownJump_0x60AA7:
UnknownRJump_0x60AA7:
	ld a, [$A6B9]
	ld d, a
	ld a, [$A796]
	inc a
	ld [$A796], a
	cp $28
	jr c, UnknownRJump_0x60AC2
	cp $50
	jr nc, UnknownRJump_0x60ABD
	dec d
	jr UnknownRJump_0x60AC3

UnknownRJump_0x60ABD:
	ld a, 0
	ld [$A796], a

UnknownRJump_0x60AC2:
	inc d

UnknownRJump_0x60AC3:
	ld a, d
	ld [$A6B9], a
	ld a, [$A69A]
	and $07
	jr nz, UnknownRJump_0x60AD9
	ld a, [$A6BD]
	cp $07
	jr z, UnknownRJump_0x60AD9
	inc a
	ld [$A6BD], a

UnknownRJump_0x60AD9:
	ld b, 2
	ld a, [$A7A5]
	sub b
	ld [$A7A5], a
	ld a, [$A7AD]
	inc a
	ld [$A7AD], a
	jp UnknownJump_0x60CF9

UnknownJump_0x60AEC:
UnknownRJump_0x60AEC:
	ld a, [$A7A6]
	cp $01
	jp nz, UnknownJump_0x60BBF
	ld a, [$A7A7]
	dec a
	ld [$A7A7], a
	or a
	jr nz, UnknownRJump_0x60B18
	ld a, 2
	ld [$A7A6], a
	ld a, 90
	ld [$A7A7], a
	ld a, 2
	ld [$A6BA], a
	call UnknownCall_0x60D32
	ld a, 56
	ld [$A6C2], a
	jp UnknownJump_0x60BBF

UnknownRJump_0x60B18:
	call UnknownCall_0x60D08
	ld a, [$A7A7]
	cp $78
	jr nc, UnknownRJump_0x60B88
	and $01
	jr z, UnknownRJump_0x60B49
	ld a, [$A797]
	inc a
	cp $03
	jr c, UnknownRJump_0x60B41
	ld a, 3
	ld [$A797], a
	ld a, 2
	ld [$A6BA], a
	ld a, [$A69A]
	and $04
	jr nz, UnknownRJump_0x60B49
	jr UnknownRJump_0x60B49

UnknownRJump_0x60B41:
	ld [$A797], a
	add 2
	ld [$A6BA], a

UnknownRJump_0x60B49:
	ld a, [$A7A7]
	ld d, 0
	ld e, a
	ld hl, $4FCD
	add hl, de
	ld a, [hl]
	or a
	jr nz, UnknownRJump_0x60B5C
	jp UnknownJump_0x60CF9

UnknownData_0x60B5A:
INCBIN "baserom.gb", $60B5A, $60B5C - $60B5A


UnknownRJump_0x60B5C:
	ld b, a
	ld a, [$A7A5]
	sub b
	ld [$A7A5], a
	ld a, [$A7AD]
	inc a
	ld [$A7AD], a
	ld a, [$A798]
	add b
	ld [$A798], a
	cp $03
	jp c, UnknownJump_0x60CF9
	sub 3
	ld [$A798], a
	xor a
	ld [$A797], a
	ld a, 2
	ld [$A6BA], a
	jp UnknownJump_0x60CF9

UnknownRJump_0x60B88:
	ld a, [$A6B9]
	ld d, a
	and $07
	cp $05
	jr z, UnknownRJump_0x60BAD
	ld a, [$A796]
	inc a
	ld [$A796], a
	cp $28
	jr c, UnknownRJump_0x60BA8
	cp $50
	jr nc, UnknownRJump_0x60BA4
	dec d
	jr UnknownRJump_0x60BA9

UnknownRJump_0x60BA4:
UnknownData_0x60BA4:
INCBIN "baserom.gb", $60BA4, $60BA8 - $60BA4


UnknownRJump_0x60BA8:
	inc d

UnknownRJump_0x60BA9:
	ld a, d
	ld [$A6B9], a

UnknownRJump_0x60BAD:
	ld a, [$A7A5]
	sub 2
	ld [$A7A5], a
	ld a, [$A7AD]
	inc a
	ld [$A7AD], a
	jp UnknownJump_0x60CF9

UnknownJump_0x60BBF:
	ld a, [$A7A6]
	cp $02
	jr nz, UnknownRJump_0x60C13
	ld a, [$A69A]
	bit 0, a
	jp nz, UnknownJump_0x60CF9
	ld a, 255
	ld [$A6C3], a
	ld a, [$A7A7]
	cp $3C
	jr nc, UnknownRJump_0x60BF3
	ld a, [$A6C2]
	inc a
	ld [$A6C2], a
	cp $4E
	call z, UnknownCall_0x60D80
	ld a, 32
	ld [$A6C1], a
	ld a, [$A7A8]
	add 11
	ld [$A6C3], a

UnknownRJump_0x60BF3:
	ld a, [$A7A7]
	dec a
	ld [$A7A7], a
	or a
	jp nz, UnknownJump_0x60CF9
	ld a, 100
	ld [$A7A7], a
	ld a, 6
	ld [$A7A6], a
	ld a, 255
	ld [$A6C3], a
	call UnknownCall_0x60DC7
	jp UnknownJump_0x60CF9

UnknownRJump_0x60C13:
	ld a, [$A7A6]
	cp $04
	jr nz, UnknownRJump_0x60C59
	call UnknownCall_0x60C41
	add 16
	ldh_n_a $C6
	ldh_a_n $C4
	dec a
	ldh_n_a $C4
	cp $7D
	jp nc, UnknownJump_0x60CF9
	ld a, 0
	ld [$A7A6], a
	call UnknownCall_0x60C41
	ldh_n_a $C6
	ld a, 1
	ldh_n_a $BB
	jp UnknownJump_0x60CF9

UnknownCall_0x60C41:
	ld a, [sCurPowerup]
	ld d, 0
	ld e, a
	ld hl, $4C4D
	add hl, de
	ld a, [hl]
	ret

UnknownData_0x60C4D:
INCBIN "baserom.gb", $60C4D, $60C59 - $60C4D


UnknownRJump_0x60C59:
	ld a, [$A7A6]
	cp $05
	jr nz, UnknownRJump_0x60C94
	call UnknownCall_0x60D08
	ldh_a_n $C4
	cp $6C
	jr nc, UnknownRJump_0x60C91
	ld a, [$A69A]
	and $01
	jr nz, UnknownRJump_0x60C91
	ld a, [$A6C0]
	cp $0A
	jr nc, UnknownRJump_0x60C7F
	inc a
	ld [$A6C0], a
	jp UnknownJump_0x60CF9

UnknownRJump_0x60C7F:
	ld a, 1
	ld [$A7A6], a
	ld a, 150
	ld [$A7A7], a
	ld a, 8
	ld [$A468], a
	jp UnknownJump_0x60AEC

UnknownRJump_0x60C91:
	jp UnknownJump_0x60AA7

UnknownRJump_0x60C94:
	ld a, [$A7A6]
	cp $06
	jp nz, UnknownJump_0x60CF9
	ld a, [$A7A7]
	cp $19
	jr c, UnknownRJump_0x60CD8
	ld a, [$A7A8]
	cp $00
	jr z, UnknownRJump_0x60CD8
	cp $04
	jr nc, UnknownRJump_0x60CD8
	ld a, [$A69A]
	and $0C
	jr nz, UnknownRJump_0x60CBB
	ld a, [$A7AC]
	ld e, a
	jr UnknownRJump_0x60CDC

UnknownRJump_0x60CBB:
	cp $04
	jr nz, UnknownRJump_0x60CC3
	ld e, 0
	jr UnknownRJump_0x60CDC

UnknownRJump_0x60CC3:
	cp $08
	jr nz, UnknownRJump_0x60CD4
	ld a, [$A7AB]
	ld e, a
	or a
	jr nz, UnknownRJump_0x60CDC
	ld a, [$A7AC]
	ld e, a
	jr UnknownRJump_0x60CDC

UnknownRJump_0x60CD4:
	ld e, 0
	jr UnknownRJump_0x60CDC

UnknownRJump_0x60CD8:
	ld a, [$A7AC]
	ld e, a

UnknownRJump_0x60CDC:
	ld d, 0
	ld hl, $4C4D
	add hl, de
	ld a, [hl]
	ldh_n_a $C6
	ld a, [$A7A7]
	dec a
	ld [$A7A7], a
	or a
	jp nz, UnknownJump_0x60CF9
	ld a, 3
	ld [$A7A6], a
	jp UnknownJump_0x60CF9

UnknownJump_0x60CF9:
	call UnknownCall_0x60EE6
	call UnknownCall_0x60EB5
	call UnknownCall_0x6106D
	call UnknownCall_0x3F44
	jp UnknownJump_0x3E07

UnknownCall_0x60D08:
	call UnknownCall_0x60C41
	ldh_n_a $C6
	ld a, [$A79A]
	ld d, 0
	ld e, a
	ld hl, $4FA8
	add hl, de
	ld a, [hl]
	cp $80
	ret z
	ld b, a
	inc e
	ld a, e
	ld [$A79A], a
	ldh_a_n $C4
	add b
	ldh_n_a $C4
	call UnknownCall_0x60C41
	add 8
	ldh_n_a $C6
	ret

UnknownCall_0x60D32:
	ld a, [$A7A5]
	and $7C
	srl a
	srl a
	cp $1E
	jr c, UnknownRJump_0x60D49

UnknownData_0x60D3F:
INCBIN "baserom.gb", $60D3F, $60D49 - $60D3F


UnknownRJump_0x60D49:
	ld d, a
	ld a, [$A6B9]
	sub 40
	srl a
	srl a
	srl a
	and $0F
	add d
	ld e, a
	ld d, 0
	ld hl, $4F7E
	add hl, de
	ld c, [hl]
	ld a, [$A840]
	sub 110
	add a
	ld d, 0
	ld e, a
	ld hl, $4F76
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld h, 0
	ld l, c
	add hl, de
	ld a, [hl]
	ld [$A7A8], a
	or a
	ret z
	ld a, 22
	ld [$A468], a
	ret

UnknownCall_0x60D80:
	ld a, [$A7A8]
	or a
	ret nz
	ld a, [$A6B9]
	sub 48
	srl a
	srl a
	srl a
	and $0F
	ld [$A7AA], a
	ld a, [$A6B9]
	sub 40
	srl a
	srl a
	srl a
	and $0F
	ld d, a
	ld a, [$A7A5]
	srl a
	srl a
	add d

UnknownRJump_0x60DAB:
	cp $03
	jr c, UnknownRJump_0x60DB3
	sub 3
	jr UnknownRJump_0x60DAB

UnknownRJump_0x60DB3:
	ld e, a
	ld a, 2
	sub e
	ld d, a
	ld a, [$A7AA]
	add d
	set 7, a
	ld [$A7AA], a
	ld a, 17
	ld [$A460], a
	ret

UnknownCall_0x60DC7:
	ld a, [sCurPowerup]
	ld [$A7AB], a
	ld [$A7AC], a
	ld a, [$A7A8]
	or a
	ret z
	cp $01
	jr nz, UnknownRJump_0x60DE1
	ld a, 1
	ld [sCurPowerup], a
	jp UnknownJump_0x60E7D

UnknownRJump_0x60DE1:
	cp $02
	jr nz, UnknownRJump_0x60DED
	ld a, 2
	ld [sCurPowerup], a
	jp UnknownJump_0x60E7D

UnknownRJump_0x60DED:
	cp $03
	jr nz, UnknownRJump_0x60DF9
	ld a, 3
	ld [sCurPowerup], a
	jp UnknownJump_0x60E7D

UnknownRJump_0x60DF9:
	cp $04
	jr nz, UnknownRJump_0x60E0B
	ld a, [$A22C]
	add 1
	daa
	ld [$A22C], a
	call c, UnknownCall_0x60EAF
	jr UnknownRJump_0x60E7D

UnknownRJump_0x60E0B:
	cp $05
	jr nz, UnknownRJump_0x60E1D
	ld a, [$A22C]
	add 3
	daa
	ld [$A22C], a
	call c, UnknownCall_0x60EAF
	jr UnknownRJump_0x60E7D

UnknownRJump_0x60E1D:
	cp $06
	jr nz, UnknownRJump_0x60E2F

UnknownData_0x60E21:
INCBIN "baserom.gb", $60E21, $60E2F - $60E21


UnknownRJump_0x60E2F:
	cp $07
	jr nz, UnknownRJump_0x60E41

UnknownData_0x60E33:
INCBIN "baserom.gb", $60E33, $60E41 - $60E33


UnknownRJump_0x60E41:
	cp $08
	jr nz, UnknownRJump_0x60E4C

UnknownData_0x60E45:
INCBIN "baserom.gb", $60E45, $60E4C - $60E45


UnknownRJump_0x60E4C:
	cp $09
	jr nz, UnknownRJump_0x60E5B

UnknownData_0x60E50:
INCBIN "baserom.gb", $60E50, $60E5B - $60E50


UnknownRJump_0x60E5B:
	cp $0A
	jr nz, UnknownRJump_0x60E6A
	ld a, [sCoinHigh]
	add 5
	daa
	ld [sCoinHigh], a
	jr UnknownRJump_0x60E7D

UnknownRJump_0x60E6A:
UnknownData_0x60E6A:
INCBIN "baserom.gb", $60E6A, $60E7D - $60E6A


UnknownJump_0x60E7D:
UnknownRJump_0x60E7D:
	ld a, [sCurPowerup]
	ld [$A7AC], a
	ld a, [$A7A8]
	ld d, 0
	ld e, a
	ld hl, $4F6A
	add hl, de
	ld a, [hl]
	cp $14
	jr nz, UnknownRJump_0x60E97
	ld [$A470], a
	jr UnknownRJump_0x60E9A

UnknownRJump_0x60E97:
	ld [$A460], a

UnknownRJump_0x60E9A:
	ld a, [sCoinHigh]
	and $F0
	jr z, UnknownRJump_0x60EAB

UnknownData_0x60EA1:
INCBIN "baserom.gb", $60EA1, $60EAB - $60EA1


UnknownRJump_0x60EAB:
	call UnknownCall_0x2934
	ret

UnknownCall_0x60EAF:
UnknownData_0x60EAF:
INCBIN "baserom.gb", $60EAF, $60EB5 - $60EAF


UnknownCall_0x60EB5:
	ld a, [$A7AD]
	and $0C
	rrca
	rrca
	ld e, a
	ld d, 0
	ld a, [$A840]
	cp $6E
	jr z, UnknownRJump_0x60EDD
	cp $6F
	jr z, UnknownRJump_0x60ED8
	cp $70
	jr z, UnknownRJump_0x60ED3
	ld hl, $4F66
	jr UnknownRJump_0x60EE0

UnknownRJump_0x60ED3:
	ld hl, $4F62
	jr UnknownRJump_0x60EE0

UnknownRJump_0x60ED8:
	ld hl, $4F5E
	jr UnknownRJump_0x60EE0

UnknownRJump_0x60EDD:
	ld hl, $4F5A

UnknownRJump_0x60EE0:
	add hl, de
	ld a, [hl]
	ld [$A6C4], a
	ret

UnknownCall_0x60EE6:
	ld a, [$A7A8]
	or a
	ret z
	ld a, [$A69A]
	and $03
	ret nz
	ld a, [$A7B9]
	inc a
	cp $03
	jr c, UnknownRJump_0x60EFA
	xor a

UnknownRJump_0x60EFA:
	ld [$A7B9], a
	or a
	jr z, UnknownRJump_0x60F06
	cp $01
	jr z, UnknownRJump_0x60F22
	jr UnknownRJump_0x60F3E

UnknownRJump_0x60F06:
	ld hl, $4530
	ld de, $8D30
	call UnknownCall_0x3F0E
	ld hl, $4D50
	ld de, $8E70
	call UnknownCall_0x3F0E
	ld hl, $4D50
	ld de, $9550
	call UnknownCall_0x3F0E
	ret

UnknownRJump_0x60F22:
	ld hl, $4D50
	ld de, $8D30
	call UnknownCall_0x3F0E
	ld hl, $4530
	ld de, $8E70
	call UnknownCall_0x3F0E
	ld hl, $4D50
	ld de, $9550
	call UnknownCall_0x3F0E
	ret

UnknownRJump_0x60F3E:
	ld hl, $4D50
	ld de, $8D30
	call UnknownCall_0x3F0E
	ld hl, $4D50
	ld de, $8E70
	call UnknownCall_0x3F0E
	ld hl, $4530
	ld de, $9550
	call UnknownCall_0x3F0E
	ret

UnknownData_0x60F5A:
INCBIN "baserom.gb", $60F5A, $6106D - $60F5A


UnknownCall_0x6106D:
	xor a
	ld hl, $A100
	ld d, 160

UnknownRJump_0x61073:
	ld [hli], a
	dec d
	jr nz, UnknownRJump_0x61073
	ld a, 0
	ld [$A782], a
	ld hl, $A6B5
	ld a, 16

UnknownRJump_0x61081:
	push af
	push hl
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld a, [hl]
	ld e, a
	cp $FF
	ld hl, $51B1
	call nz, UnknownCall_0x6109B
	pop hl
	ld bc, $0003
	add hl, bc
	pop af
	dec a
	jr nz, UnknownRJump_0x61081
	ret

UnknownCall_0x6109B:
	ld d, 0
	sla e
	rl d
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [$A782]
	cp $28
	ret nc
	add a
	add a
	ld de, $A100
	add e
	ld e, a
	ld a, d
	adc 0
	ld d, a

UnknownRJump_0x610B6:
	ld a, [$A782]
	cp $28
	ret nc
	ld a, [hli]
	add c
	ld [de], a
	inc de
	ld a, [hli]
	add b
	ld [de], a
	inc de
	ld a, [hli]
	cp $FF
	jr z, UnknownRJump_0x610D7
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [$A782]
	inc a
	ld [$A782], a
	jr UnknownRJump_0x610B6

UnknownRJump_0x610D7:
	xor a
	dec de
	ld [de], a
	dec de
	ld [de], a
	ret

UnknownCall_0x610DD:
	ld b, 15
	ld hl, $A7D0

UnknownRJump_0x610E2:
	push bc
	ld a, [hli]
	ld [$A787], a
	ld a, [hli]
	ld [$A788], a
	ld a, [hli]
	cp $FF
	jr z, UnknownRJump_0x61142
	sla a
	ld d, 0
	ld e, a
	push hl
	ld hl, $5213
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	pop hl

UnknownRJump_0x610FF:
	ld a, [de]
	inc de
	cp $FF
	jr z, UnknownRJump_0x61142
	ld c, a
	ld a, [$A787]
	add c
	and $1F
	ld c, a
	ld b, 152
	ld a, [de]
	inc de
	push hl
	ld l, a
	ld a, [$A788]
	add l
	and $1F
	ld h, 0
	ld l, a
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	push hl
	ld hl, rSTAT

UnknownRJump_0x61138:
	bit 1, [hl]
	jr nz, UnknownRJump_0x61138
	pop hl
	ld a, [de]
	inc de
	ld [bc], a
	jr UnknownRJump_0x610FF

UnknownRJump_0x61142:
	pop bc
	dec b
	jr nz, UnknownRJump_0x610E2
	ret

UnknownCall_0x61147:
	ld b, 15
	ld hl, $A7D0

UnknownRJump_0x6114C:
	push bc
	ld a, [hli]
	ld [$A787], a
	ld a, [hli]
	ld [$A788], a
	ld a, [hli]
	cp $FF
	jr z, UnknownRJump_0x611AC
	sla a
	ld d, 0
	ld e, a
	push hl
	ld hl, $63EA
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	pop hl

UnknownRJump_0x61169:
	ld a, [de]
	inc de
	cp $FF
	jr z, UnknownRJump_0x611AC
	ld c, a
	ld a, [$A787]
	add c
	and $1F
	ld c, a
	ld b, 152
	ld a, [de]
	inc de
	push hl
	ld l, a
	ld a, [$A788]
	add l
	and $1F
	ld h, 0
	ld l, a
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	push hl
	ld hl, rSTAT

UnknownRJump_0x611A2:
	bit 1, [hl]
	jr nz, UnknownRJump_0x611A2
	pop hl
	ld a, [de]
	inc de
	ld [bc], a
	jr UnknownRJump_0x61169

UnknownRJump_0x611AC:
	pop bc
	dec b
	jr nz, UnknownRJump_0x6114C
	ret

UnknownData_0x611B1:
INCBIN "baserom.gb", $611B1, $61602 - $611B1
include "owmovementpointers.asm"
INCBIN "baserom.gb", $61A40, $64000 - $61A40


SECTION "bank19", ROMX, BANK[$19]


UnknownData_0x64000:
INCBIN "gfx/coingame.2bpp"
INCBIN "gfx/bonusgame.2bpp"

UnknownCall_0x66000:
	ld a, [$AF3E]
	and a
	ret nz
	call UnknownCall_0x66087
	ld hl, $6092
	ldh a, [$FFDB]
	ld d, 0
	ld e, a
	sla e
	rl d
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld h, 161
	ldh_a_n $8D
	ld l, a
	ldh a, [$FFD9]
	ld b, a
	ldh a, [$FFDA]
	ld c, a
	ld a, [de]
	cp $88
	jr nz, UnknownRJump_0x66039
	ld a, [$AF2B]
	bit 6, a
	jr z, UnknownRJump_0x66037
	inc de
	ld a, [de]
	add b
	ld b, a
	jr UnknownRJump_0x66038

UnknownRJump_0x66037:
	inc de

UnknownRJump_0x66038:
	inc de

UnknownRJump_0x66039:
	ld a, [de]
	cp $80
	ret z
	ld a, [$AF2B]
	bit 6, a
	jr z, UnknownRJump_0x6604A
	ld a, [de]
	cpl
	sub 7
	jr UnknownRJump_0x6604B

UnknownRJump_0x6604A:
	ld a, [de]

UnknownRJump_0x6604B:
	add b
	cp $A0
	jr nc, UnknownRJump_0x6605F
	ld [hli], a
	inc de
	ld a, [$AF2B]
	bit 5, a
	jr z, UnknownRJump_0x6606D
	ld a, [de]
	cpl
	sub 7
	jr UnknownRJump_0x6606E

UnknownRJump_0x6605F:
	inc de
	inc de
	inc de
	inc de
	jr UnknownRJump_0x66039

UnknownRJump_0x66065:
	dec l
	ld [hl], 0
	inc de
	inc de
	inc de
	jr UnknownRJump_0x66039

UnknownRJump_0x6606D:
	ld a, [de]

UnknownRJump_0x6606E:
	add c
	cp $A8
	jr nc, UnknownRJump_0x66065
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	push hl
	ld hl, $AF2B
	ld a, [de]
	xor [hl]
	pop hl
	ld [hli], a
	ld a, l
	ldh_n_a $8D
	inc de
	jr UnknownRJump_0x66039

UnknownCall_0x66087:
	ld hl, $FFDC
	ld a, [hli]
	xor [hl]
	inc l
	xor [hl]
	ld [$AF2B], a
	ret

UnknownData_0x66092:
INCBIN "baserom.gb", $66092, $68000 - $66092



SECTION "bank1A", ROMX, BANK[$1A]


UnknownJump_0x68000:
	xor a
	ld [$A2DD], a
	ld [$A2DC], a
	ldh_a_n $9B
	inc a
	ldh_n_a $9B
	ret

UnknownJump_0x6800F:
	call UnknownCall_0x68016
	call UnknownCall_0x2B4F
	ret

UnknownCall_0x68016:
	ld a, [$A2DD]
	rst $28

UnknownData_0x6801A:
INCBIN "baserom.gb", $6801A, $68042 - $6801A

	call UnknownCall_0x684C5
	call UnknownCall_0x2A96
	ld a, [$A248]
	and a
	ret nz
	ld a, [$A2DD]
	inc a
	ld [$A2DD], a
	ld a, 6
	ld [$A460], a
	xor a
	ld [$A267], a
	ld a, 64
	ld [$A266], a
	ret
	call UnknownCall_0x684C5
	call UnknownCall_0x2A96
	ld a, [$A248]
	and a
	ret nz
	ld a, 26
	ld [$A265], a
	ld a, 86
	ldh_n_a $B1
	ld a, 70
	ldh_n_a $B2
	ld a, 0
	ldh_n_a $B3
	ld a, 128
	ldh_n_a $B4
	ld a, 0
	ldh_n_a $B5
	ld a, 8
	ldh_n_a $B6
	ld a, 255
	ld [$A248], a
	ld a, [$A2DD]
	inc a
	ld [$A2DD], a
	ret
	ld a, 195
	ldh_n_a $40

UnknownJump_0x680A3:
	ldh_a_n $44
	cp $0C
	jp nc, UnknownJump_0x680A3
	call UnknownCall_0x68492
	call UnknownCall_0x2A96

UnknownRJump_0x680B1:
	ldh_a_n $44
	cp $6F
	jr c, UnknownRJump_0x680B1

UnknownRJump_0x680B8:
	ldh_a_n $41
	and $03
	jr nz, UnknownRJump_0x680B8
	ld a, 211
	ldh_n_a $40
	ld a, [$A266]
	add 32
	cp $40
	jr nc, UnknownRJump_0x680FE
	ld hl, $444F

UnknownRJump_0x680D0:
	ldh_a_n $41
	and $03
	jr nz, UnknownRJump_0x680D0
	ldh_a_n $97
	and $3C
	srl a
	srl a
	ld b, a
	ldh_a_n $44
	add b
	and $0F
	ld e, a
	ld d, 0
	ld hl, $444F
	add hl, de
	ld a, [hl]
	ldh_n_a $43
	ldh_a_n $44
	cp $8B
	jr c, UnknownRJump_0x680D0
	ld a, [$A2D6]
	and a
	ret nz

UnknownRJump_0x680FE:
	ld a, [$A2D8]
	and a
	jr nz, UnknownRJump_0x6811D
	ld a, [$A267]
	ld b, a
	ld a, [$A266]
	or b
	ret nz
	ld a, 4
	ld [$A2D6], a
	ld a, 0
	ld [$A267], a
	ld a, 255
	ld [$A266], a
	ret

UnknownRJump_0x6811D:
	ld a, [$A2DD]
	inc a
	ld [$A2DD], a
	ret

UnknownData_0x68125:
INCBIN "baserom.gb", $68125, $68139 - $68125

	call UnknownCall_0x68400
	ld a, [$A248]
	and a
	ret nz
	ld a, [$A2DD]
	inc a
	ld [$A2DD], a
	ret
	call UnknownCall_0x68400
	ld a, [$A248]
	and a
	ret nz
	ld a, 16
	ld [$A265], a
	ld a, 0
	ldh_n_a $B1
	ld a, 96
	ldh_n_a $B2
	ld a, 0
	ldh_n_a $B3
	ld a, 136
	ldh_n_a $B4
	ld a, 0
	ldh_n_a $B5
	ld a, 16
	ldh_n_a $B6
	ld a, 255
	ld [$A248], a
	ld a, 2
	ld [$A267], a
	ld a, 0
	ld [$A266], a
	ld a, [$A2DD]
	inc a
	ld [$A2DD], a
	ret
	call UnknownCall_0x68492
	call UnknownCall_0x2A96
	ld a, [$A266]
	and $F0
	swap a
	ld b, a
	ld a, [$A267]
	and $0F
	swap a
	or b
	xor $FF
	add 25
	ld [sScrollY], a
	ld b, a
	ld a, 44
	sub b
	ld [$A2E1], a
	ld a, b
	cp $18
	ret nz
	ld hl, $56CE
	ld a, l
	ld [$A273], a
	ld a, h
	ld [$A274], a
	xor a
	ld [$A2D7], a
	ld [$A2D8], a
	ld a, 4
	ld [$A2D6], a
	ld a, [$A2DD]
	inc a
	ld [$A2DD], a
	ret
	call UnknownCall_0x2A96
	call UnknownCall_0x684E0
	ld a, [$A267]
	ld b, a
	ld a, [$A266]
	or b
	ret nz
	ld a, 0
	ld [$A267], a
	ld a, 64
	ld [$A266], a
	ld a, [$A2DD]
	inc a
	ld [$A2DD], a
	ld a, 7
	ld [$A460], a
	ld a, 44
	ld [$A2E1], a
	ret
	call UnknownCall_0x2A96
	call UnknownCall_0x684C5
	ld a, [$A267]
	ld b, a
	ld a, [$A266]
	or b
	ret nz
	ld a, 2
	ld [$A267], a
	ld a, 0
	ld [$A266], a
	ld a, [$A2DD]
	inc a
	ld [$A2DD], a
	ret
	call UnknownCall_0x2A96
	ld a, [$A267]
	ld b, a
	ld a, [$A266]
	or b
	ret nz
	ld a, 1
	ld [$A267], a
	ld a, 128
	ld [$A266], a
	ld a, [$A2DD]
	inc a
	ld [$A2DD], a
	ld a, 255
	ld [$A2E2], a
	ret
	ld a, 44
	ld [$A2E1], a
	call UnknownCall_0x68492
	call UnknownCall_0x2A96
	ld a, [$A267]
	ld b, a
	ld a, [$A266]
	or b
	ret nz
	ld a, 1
	ld [$A267], a
	ld a, 128
	ld [$A266], a
	ld a, [$A2DD]
	inc a
	ld [$A2DD], a
	ret
	ld a, 195
	ldh_n_a $40

UnknownJump_0x6826C:
	ldh_a_n $44
	cp $0C
	jp nc, UnknownJump_0x6826C
	call UnknownCall_0x68492
	call UnknownCall_0x2A96

UnknownRJump_0x6827A:
	ldh_a_n $44
	cp $6F
	jr c, UnknownRJump_0x6827A

UnknownRJump_0x68281:
	ldh_a_n $41
	and $03
	jr nz, UnknownRJump_0x68281
	ld a, 211
	ldh_n_a $40
	ret

UnknownData_0x6828E:
INCBIN "baserom.gb", $6828E, $682BA - $6828E

	ld a, [$A266]
	and $03
	jr nz, UnknownRJump_0x682C8
	ld a, [$A2E1]
	inc a
	ld [$A2E1], a

UnknownRJump_0x682C8:
	call UnknownCall_0x6845F
	call UnknownCall_0x2A96
	ld a, [$A267]
	ld b, a
	ld a, [$A266]
	or b
	ret nz
	ld a, 0
	ld [$A267], a
	ld a, 32
	ld [$A266], a
	ld a, [$A2DD]
	inc a
	ld [$A2DD], a
	ld a, 13
	ld [$A2DF], a
	ret
	call UnknownCall_0x6845F
	call UnknownCall_0x2A96
	ld a, [$A267]
	ld b, a
	ld a, [$A266]
	or b
	ret nz
	ld a, 0
	ld [$A267], a
	ld a, 128
	ld [$A266], a
	ld a, [$A2DD]
	inc a
	ld [$A2DD], a
	ret

UnknownData_0x6830F:
INCBIN "baserom.gb", $6830F, $68398 - $6830F

	call UnknownCall_0x68400
	ldh_a_n $97
	and $01
	ld b, a
	ld a, [$A2DF]
	sub b
	ld [$A2DF], a
	cp $0D
	ret nz
	ld a, 0
	ld [$A267], a
	ld a, 192
	ld [$A266], a
	ld a, [$A2DD]
	inc a
	ld [$A2DD], a
	ret
	call UnknownCall_0x68400
	ldh_a_n $97
	and $01
	ld b, a
	ld a, [$A2DF]
	add b
	ld [$A2DF], a
	cp $8B
	ret nz
	ld a, 26
	ld [$A265], a
	ld a, 150
	ldh_n_a $B1
	ld a, 80
	ldh_n_a $B2
	ld a, 0
	ldh_n_a $B3
	ld a, 152
	ldh_n_a $B4
	ld a, 0
	ldh_n_a $B5
	ld a, 4
	ldh_n_a $B6
	ld a, 255
	ld [$A248], a
	ld a, [$A2DD]
	inc a
	ld [$A2DD], a
	ret

UnknownJump_0x68400:
UnknownCall_0x68400:
	ldh_a_n $44
	cp $0C
	jp nc, UnknownJump_0x68400
	call UnknownCall_0x2A96

UnknownJump_0x6840B:
	ldh_a_n $44
	cp $10
	jp c, UnknownJump_0x6840B
	ld hl, $444F

UnknownRJump_0x68416:
	ldh_a_n $41
	and $03
	jr nz, UnknownRJump_0x68416
	ldh_a_n $97
	and $3C
	srl a
	srl a
	ld b, a
	ldh_a_n $44
	add b
	and $0F
	ld e, a
	ld d, 0
	ld hl, $444F
	add hl, de
	ld a, [hl]
	ldh_n_a $43
	ld a, [$A2DF]
	ld b, a
	ldh_a_n $44
	cp b
	jr c, UnknownRJump_0x68416

UnknownRJump_0x68442:
	ldh_a_n $41
	and $03
	jr nz, UnknownRJump_0x68442
	ld a, 0
	ldh_n_a $43
	ret

UnknownData_0x6844F:
INCBIN "baserom.gb", $6844F, $6845F - $6844F


UnknownCall_0x6845F:
	xor a
	ldh_n_a $BB
	ld a, 1
	ldh_n_a $C7
	ld a, [$A222]
	inc a
	ld [$A222], a
	cp $30
	jr c, UnknownRJump_0x68477
	xor a
	ld [$A222], a

UnknownRJump_0x68477:
	ld a, 84
	ldh_n_a $C5
	ld a, [$A2E1]
	ldh_n_a $C4
	ld a, [$A222]
	and $F0
	swap a
	add 229
	ldh_n_a $C6
	call UnknownCall_0x2B27
	ret

UnknownCall_0x68492:
	ld a, 1
	ldh_n_a $BB
	ld a, 0
	ldh_n_a $C7
	ld a, [$A222]
	inc a
	ld [$A222], a
	cp $30
	jr c, UnknownRJump_0x684AB
	xor a
	ld [$A222], a

UnknownRJump_0x684AB:
	ld a, 84
	ldh_n_a $C5
	ld a, [$A2E1]
	ldh_n_a $C4
	ld a, [$A222]
	and $F0
	swap a
	add 232
	ldh_n_a $C6
	call UnknownCall_0x2B27

UnknownCall_0x684C5:
	ld a, 0
	ldh_n_a $C7
	ld a, [$A2E1]
	add 52
	ldh_n_a $C4
	ld a, 79
	ldh_n_a $C5
	ld a, 235
	ldh_n_a $C6
	call UnknownCall_0x2B27
	ret

UnknownCall_0x684E0:
	ldh_a_n $97
	bit 0, a
	jr z, UnknownRJump_0x684EC
	ld a, 24
	ld [$A470], a

UnknownRJump_0x684EC:
	ld a, 0
	ldh_n_a $C7
	ld a, 1
	ldh_n_a $BB
	ld a, 96
	ldh_n_a $C4
	ld a, 79
	ldh_n_a $C5
	ldh_a_n $97
	and $1C
	srl a
	srl a
	ld e, a
	ld d, 0
	ld hl, $4518
	add hl, de
	ld a, [hl]
	ldh_n_a $C6
	call UnknownCall_0x2B27
	ret

UnknownData_0x68518:
INCBIN "baserom.gb", $68518, $68520 - $68518

	ld a, [$A2DD]
	inc a
	ld [$A2DD], a
	ret

UnknownJump_0x68528:
	call $FFA0
	ld a, 0
	ldh_n_a $43
	ldh_n_a $43
	ld a, [$A2D6]
	and a
	jp nz, UnknownJump_0x68572
	ld a, [$A2E2]
	and a
	jr z, UnknownRJump_0x68562
	ld a, 137
	ld [$9948], a
	ld a, 138
	ld [$9949], a
	ld a, 139
	ld [$994A], a
	ld a, 153
	ld [$9968], a
	ld a, 154
	ld [$9969], a
	ld a, 155
	ld [$996A], a
	xor a
	ld [$A2E2], a

UnknownRJump_0x68562:
	ld a, [$A24E] ;prepare bank switch
	ld [$2100], a
	ld a, 1
	ldh_n_a $82
	pop hl
	pop de
	pop bc
	pop af
	reti

UnknownJump_0x68572:
	ld a, [$A2D6]
	xor $FF
	add 5
	sla a
	swap a
	ld l, a
	ld h, 0
	ld de, $9A20
	add hl, de
	ld e, l
	ld d, h
	ld a, [$A273]
	ld l, a
	ld a, [$A274]
	ld h, a
	ld a, [hl]
	cp $FF
	jr z, UnknownRJump_0x685A5
	ld b, 20

UnknownRJump_0x68595:
	ld a, [hli]
	sub 48
	cp $F0
	jr nz, UnknownRJump_0x6859E
	ld a, 255

UnknownRJump_0x6859E:
	ld [de], a
	inc de
	dec b
	jr nz, UnknownRJump_0x68595
	jr UnknownRJump_0x685AF

UnknownRJump_0x685A5:
	inc hl
	ld b, 20

UnknownRJump_0x685A8:
	ld a, 255
	ld [de], a
	inc de
	dec b
	jr nz, UnknownRJump_0x685A8

UnknownRJump_0x685AF:
	ld a, l
	ld [$A273], a
	ld a, h
	ld [$A274], a
	ld a, [hl]
	cp $FE
	jr nz, UnknownRJump_0x685C1
	ld a, 255
	ld [$A2D8], a

UnknownRJump_0x685C1:
	ld a, [$A2D6]
	dec a
	ld [$A2D6], a
	and a
	jr nz, UnknownRJump_0x685D5
	ld a, 1
	ld [$A267], a
	ld a, 0
	ld [$A266], a

UnknownRJump_0x685D5:
	ld a, [$A24E] ;prepare bank switch
	ld [$2100], a
	ld a, 1
	ldh_n_a $82
	pop hl
	pop de
	pop bc
	pop af
	reti

UnknownData_0x685E5:
INCBIN "baserom.gb", $685E5, $6C000 - $685E5



SECTION "bank1B", ROMX, BANK[$1B]


GFX_TilesetMarioZone1: ;$6C000
INCBIN "gfx/tilesets/mariozone1.2bpp"

GFX_TilesetMarioZone2: ;$6C600
INCBIN "gfx/tilesets/mariozone2.2bpp"

GFX_TilesetMarioZone3: ;$6CC00
INCBIN "gfx/tilesets/mariozone3.2bpp"

GFX_TilesetMarioZone4: ;$6D200
INCBIN "gfx/tilesets/mariozone4.2bpp"

GFX_TilesetMarioZoneBoss: ;$6D800
INCBIN "gfx/tilesets/mariozoneboss.2bpp"

GFX_EnemiesMarioZone1: ;$6DE00
INCBIN "gfx/enemies/mariozone1.2bpp"

GFX_EnemiesMarioZone2: ;$6E180
INCBIN "gfx/enemies/mariozone2.2bpp"

GFX_EnemiesMarioZone3: ;$6E500
INCBIN "gfx/enemies/mariozone3.2bpp"

GFX_EnemiesMarioZone4: ;$6E880
INCBIN "gfx/enemies/mariozone4.2bpp"

GFX_EnemiesMarioZoneBoss: ;$6EC00
INCBIN "gfx/enemies/mariozoneboss.2bpp"

GFX_TilesetMarioZoneExtra: ;$6EF80
INCBIN "gfx/tilesets/mariozone_extra.2bpp"


SECTION "bank1C", ROMX, BANK[$1C]

GFX_TilesetMacroZone1: ;$70000
INCBIN "gfx/tilesets/macrozone1.2bpp"

GFX_TilesetMacroZone2: ;$70600
INCBIN "gfx/tilesets/macrozone2.2bpp"

GFX_TilesetMacroZone3: ;$70C00
INCBIN "gfx/tilesets/macrozone3.2bpp"

GFX_TilesetMacroZone4: ;$71200
INCBIN "gfx/tilesets/macrozone4.2bpp"

GFX_TilesetMacroZoneBoss: ;$71800
INCBIN "gfx/tilesets/macrozoneboss.2bpp"

GFX_EnemiesMacroZone1: ;$71E00
INCBIN "gfx/enemies/macrozone1.2bpp"

GFX_EnemiesMacroZone2: ;$72180
INCBIN "gfx/enemies/macrozone2.2bpp"

GFX_EnemiesMacroZone3: ;$72500
INCBIN "gfx/enemies/macrozone3.2bpp"

GFX_EnemiesMacroZone4: ;$72880
INCBIN "gfx/enemies/macrozone4.2bpp"

GFX_EnemiesMacroZoneBoss: ;$72C00
INCBIN "gfx/enemies/macrozoneboss.2bpp"

UnknownData_0x72F80: ;unclassified packed data (MacroZone bank tail)
	db $07, $07, $1F, $18, $3F, $23, $7C, $4F, $73, $5C, $F7, $98, $EF, $B0, $EF, $B0
	db $0F, $0F, $17, $1C, $2F, $39, $5E, $73, $5D, $76, $5D, $76, $BB, $EC, $BB, $EC
	db $E0, $E0, $E0, $20, $F0, $90, $78, $C8, $B8, $68, $B8, $68, $DC, $34, $DC, $34
	db $18, $18, $24, $3C, $2C, $3C, $4A, $7E, $56, $7A, $56, $7A, $56, $7A, $56, $7A
	db $00, $00, $08, $08, $1C, $14, $3E, $36, $7F, $41, $3E, $36, $18, $10, $08, $08
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $36, $EB, $C5, $FF, $0D, $F6, $EE, $BB, $AB, $EF, $BA, $98, $3C, $EE, $CE, $FF
	db $2E, $87, $9B, $FB, $BE, $9F, $FE, $27, $7A, $63, $8D, $FC, $AE, $EF, $FD, $BB
	db $E8, $FF, $FF, $FB, $3C, $FB, $77, $FF, $21, $AF, $DA, $9B, $C5, $AA, $BF, $EA
	db $8E, $FE, $FA, $B3, $EC, $6B, $AF, $FA, $7B, $EB, $F5, $AF, $39, $B6, $BA, $AF
	db $BA, $BF, $FB, $EF, $E4, $E6, $9B, $2A, $6F, $AE, $AE, $FF, $FB, $E8, $F3, $AE
	db $D9, $DE, $BF, $AF, $FB, $F6, $AA, $EA, $A2, $BA, $AC, $FB, $F6, $AA, $FB, $B9
	db $E4, $CF, $A6, $FA, $D7, $92, $CB, $F7, $E8, $FC, $EB, $FE, $A6, $EB, $EF, $AB
	db $EA, $E2, $EF, $AE, $A9, $AA, $D6, $AE, $AF, $6A, $EE, $F9, $FB, $B8, $AB, $EA
	db $B8, $20, $87, $40, $C2, $B4, $08, $02, $1A, $8C, $6A, $02, $A0, $BA, $4C, $28
	db $0E, $88, $00, $C4, $23, $8A, $8A, $0A, $82, $28, $C2, $38, $1C, $A2, $20, $08
	db $A1, $8A, $02, $00, $A5, $C2, $81, $08, $62, $0A, $20, $AA, $A3, $AA, $8C, $0B
	db $E8, $C8, $00, $3A, $82, $28, $A6, $92, $B2, $82, $AA, $02, $8A, $06, $28, $20
	db $42, $CE, $2A, $80, $A8, $E2, $88, $B8, $41, $EC, $CC, $AA, $08, $82, $A0, $D6
	db $03, $A8, $81, $8A, $C2, $FA, $A8, $22, $86, $AA, $88, $40, $80, $08, $2A, $80
	db $48, $08, $BA, $A8, $CA, $80, $83, $22, $A9, $02, $4E, $A0, $23, $8A, $B0, $2C
	db $62, $0A, $A8, $A0, $20, $8A, $A3, $A2, $79, $8A, $A2, $A2, $22, $A8, $A4, $AA
	db $F7, $7B, $FA, $AA, $F3, $EB, $AB, $FB, $FD, $B2, $2E, $FB, $3F, $CF, $FA, $BF
	db $D5, $6F, $AA, $6B, $77, $AA, $A5, $BA, $63, $FF, $BA, $7F, $63, $EE, $E6, $EB
	db $A1, $BB, $25, $BF, $FE, $9E, $AF, $AE, $BB, $BB, $FB, $B2, $FF, $7D, $F6, $FB
	db $6F, $AE, $FB, $76, $F7, $B7, $A9, $FF, $71, $2F, $BF, $FF, $A6, $FA, $FF, $E7
	db $EF, $FB, $1B, $3F, $E3, $CE, $72, $B2, $73, $EB, $FB, $FF, $FF, $BE, $E2, $DA
	db $3A, $67, $66, $AB, $3C, $A2, $F6, $3B, $BB, $9A, $AD, $23, $9F, $F3, $FB, $EB
	db $38, $FE, $FE, $F6, $7F, $9F, $6F, $BF, $3F, $BB, $EF, $AF, $2F, $BF, $7F, $FA
	db $6F, $AB, $8A, $EA, $BA, $BB, $FE, $AF, $17, $AE, $3A, $FA, $8F, $BB, $E7, $BA
	db $72, $2A, $0E, $00, $00, $A0, $E0, $A2, $68, $02, $32, $2A, $42, $A0, $24, $2A
	db $78, $E0, $82, $AA, $70, $0A, $83, $22, $4A, $C2, $00, $80, $06, $8A, $80, $88
	db $21, $80, $28, $22, $66, $A8, $20, $52, $0C, $02, $40, $42, $23, $4A, $A0, $00
	db $60, $AA, $A2, $03, $10, $A2, $2A, $A2, $31, $28, $0A, $21, $A2, $06, $00, $EA
	db $21, $31, $00, $02, $02, $82, $E3, $00, $31, $22, $22, $89, $A5, $82, $21, $22
	db $64, $A8, $A4, $02, $22, $2A, $02, $82, $21, $22, $33, $28, $C8, $2A, $A1, $02
	db $2B, $30, $40, $20, $40, $02, $80, $32, $13, $20, $E8, $4C, $92, $08, $28, $8A
	db $A8, $2A, $22, $83, $0A, $26, $2A, $18, $40, $26, $E8, $2A, $28, $22, $00, $2A
	db $2F, $FA, $FB, $E8, $FF, $33, $BA, $6B, $CC, $FA, $D3, $E6, $2E, $FA, $7F, $FE
	db $FE, $BE, $EB, $BC, $E9, $EB, $9E, $BF, $A6, $2B, $EF, $BE, $FA, $2E, $3F, $FA
	db $52, $F3, $B4, $E7, $EE, $FF, $BF, $BA, $D7, $AE, $F2, $EB, $EF, $2B, $FF, $EE
	db $BA, $F2, $FF, $E4, $7C, $FF, $56, $E3, $FE, $AB, $B6, $BA, $FF, $BD, $47, $EA
	db $4A, $CB, $B6, $86, $D0, $AB, $B6, $FB, $FB, $BF, $F2, $AB, $3A, $E7, $B6, $F3
	db $E6, $F2, $4B, $EF, $9F, $AF, $76, $8E, $EF, $AB, $B2, $6B, $23, $FB, $AF, $BA
	db $2B, $7B, $AF, $EF, $EE, $BD, $BF, $2B, $4B, $BA, $20, $FA, $7B, $5F, $BD, $EF
	db $72, $F2, $BE, $AA, $E3, $A5, $B4, $B8, $DA, $EA, $63, $FB, $71, $9E, $7D, $F0
	db $E7, $22, $31, $21, $0A, $6A, $E6, $A0, $23, $A0, $3A, $28, $32, $A8, $E2, $0E
	db $B0, $0A, $42, $00, $22, $02, $9B, $80, $6A, $28, $62, $22, $2A, $02, $22, $A3
	db $A0, $AA, $A2, $A0, $26, $4A, $00, $2A, $08, $02, $80, $AA, $28, $20, $02, $28
	db $40, $A0, $00, $AE, $A2, $8E, $02, $A2, $08, $22, $22, $06, $23, $82, $28, $A2
	db $01, $0A, $83, $18, $AA, $28, $A8, $62, $80, $08, $8A, $B0, $00, $B2, $A2, $98
	db $20, $0A, $8A, $A2, $84, $20, $04, $89, $12, $00, $02, $92, $0B, $C0, $04, $0A
	db $25, $20, $A0, $22, $04, $22, $0A, $28, $4C, $05, $02, $20, $EA, $02, $2A, $20
	db $A0, $06, $82, $24, $22, $2D, $81, $22, $28, $09, $30, $00, $A2, $6A, $82, $2A
	db $EF, $FF, $31, $5E, $D5, $B2, $BE, $EE, $9F, $F3, $F2, $A6, $7F, $BF, $F7, $FB
	db $9F, $EF, $FF, $9F, $6F, $2B, $F7, $B2, $74, $F2, $EB, $BE, $72, $B0, $FB, $AF
	db $EE, $E3, $AC, $AE, $FA, $B7, $FF, $AF, $FE, $BF, $87, $27, $FF, $AE, $33, $9F
	db $BC, $2F, $27, $EB, $FE, $EE, $7A, $AC, $2B, $B2, $E7, $EF, $EF, $AB, $AE, $AB
	db $FA, $E3, $EB, $FF, $F7, $AE, $AD, $EF, $BF, $F6, $7F, $AB, $ED, $EC, $F2, $AA
	db $86, $FE, $FA, $39, $6E, $6B, $FE, $7C, $9B, $BF, $7B, $FB, $61, $B6, $AB, $DB
	db $F6, $FB, $FD, $EF, $E7, $BF, $7E, $EF, $3B, $EB, $CB, $FB, $FF, $A3, $5F, $FB
	db $6B, $EF, $CB, $0F, $3B, $BA, $8B, $2F, $FB, $72, $BF, $EB, $BF, $AB, $FA, $A3
	db $49, $0A, $68, $02, $53, $2A, $0E, $20, $E2, $A0, $74, $08, $70, $32, $40, $02
	db $10, $80, $6A, $80, $40, $0B, $10, $2A, $A2, $0A, $22, $2A, $82, $A0, $03, $48
	db $02, $32, $E2, $20, $43, $84, $02, $02, $02, $30, $24, $AA, $E9, $2A, $90, $20
	db $63, $02, $E0, $0E, $40, $6A, $6A, $A2, $2B, $24, $60, $B2, $1C, $22, $A2, $82
	db $66, $46, $31, $2A, $62, $72, $A0, $6A, $65, $52, $AA, $88, $8A, $20, $22, $80
	db $8A, $82, $65, $02, $2A, $02, $08, $AA, $02, $82, $A4, $A0, $23, $A8, $B2, $22
	db $94, $2A, $92, $22, $00, $0C, $00, $A0, $01, $06, $A2, $20, $09, $40, $B2, $82
	db $22, $BA, $6B, $A8, $21, $80, $A8, $80, $23, $A2, $A8, $AA, $73, $06, $41, $26
	db $A8, $EA, $AE, $BB, $EF, $EB, $FB, $AA, $DD, $FF, $DF, $BB, $75, $FF, $F2, $AB
	db $FF, $BE, $47, $AB, $31, $BE, $67, $BF, $67, $88, $BA, $2F, $BF, $BF, $B6, $3E
	db $F8, $BF, $E7, $FB, $EF, $BF, $AB, $BF, $AB, $FF, $BB, $AF, $2F, $FA, $FF, $EE
	db $FA, $FC, $7E, $BF, $EE, $AA, $9A, $B8, $8B, $3D, $BF, $82, $FB, $EE, $BC, $AB
	db $E6, $B3, $EF, $EA, $4E, $DB, $AE, $F3, $AF, $B9, $EA, $FB, $EE, $BE, $FE, $AA
	db $FF, $AE, $BE, $A3, $F8, $FA, $AF, $EF, $AD, $B7, $BE, $ED, $E8, $CB, $9E, $1E
	db $30, $E6, $D9, $AE, $A7, $E4, $7E, $3B, $BB, $BA, $8B, $BC, $CE, $FF, $FE, $AB
	db $EB, $BE, $68, $DB, $E4, $FF, $BB, $AB, $AC, $E6, $FC, $BE, $B5, $AE, $BA, $EA
	db $82, $A5, $2A, $28, $10, $92, $26, $62, $8A, $20, $AE, $AA, $20, $0E, $0C, $AA
	db $11, $A2, $88, $A2, $08, $8A, $22, $2A, $41, $A3, $32, $A2, $2A, $A2, $2E, $AA
	db $08, $8B, $28, $09, $08, $A3, $02, $82, $2E, $A0, $8A, $2B, $8E, $A2, $24, $42
	db $26, $29, $AA, $A0, $A2, $28, $20, $20, $0D, $A8, $02, $80, $8A, $01, $AA, $E8
	db $A0, $20, $38, $08, $40, $A8, $80, $A0, $15, $88, $B0, $88, $91, $AA, $A6, $A8
	db $02, $AE, $28, $8A, $80, $C2, $88, $AE, $61, $82, $32, $A1, $80, $62, $23, $82
	db $30, $2E, $83, $28, $A0, $8A, $00, $A8, $48, $02, $AA, $2A, $90, $88, $6E, $AA
	db $22, $08, $42, $80, $B8, $02, $A2, $AA, $28, $0E, $2A, $80, $88, $81, $22, $88
	db $61, $BA, $AE, $AF, $29, $BB, $FB, $EF, $5F, $5B, $BE, $BB, $FA, $D9, $EB, $EF
	db $33, $AA, $7E, $BF, $FA, $BF, $FF, $E2, $FF, $FE, $EB, $B7, $FE, $E6, $FF, $AF
	db $F7, $DE, $4D, $A7, $7E, $FF, $FB, $FF, $9F, $AE, $CF, $BF, $FF, $A3, $EE, $FE
	db $FE, $EE, $FA, $AE, $BF, $BE, $BA, $AE, $E6, $FE, $77, $EE, $EB, $AE, $FA, $AF
	db $6B, $EB, $6F, $FE, $FF, $BF, $F9, $FA, $FE, $AB, $BE, $EA, $6E, $3C, $6A, $A8
	db $FE, $BC, $FB, $EF, $BF, $AF, $3E, $6E, $6F, $EC, $B7, $EA, $C9, $AB, $FE, $AA
	db $DE, $EF, $BA, $B3, $6B, $BF, $AF, $EF, $EB, $BE, $B2, $EE, $A6, $EA, $77, $EB
	db $FE, $EE, $B6, $BF, $FE, $AF, $E3, $FA, $FF, $FF, $FE, $EE, $E2, $A6, $EA, $BE
	db $82, $88, $08, $20, $9B, $A2, $D8, $A0, $8A, $9A, $B9, $20, $83, $A2, $C2, $A8
	db $D2, $C4, $68, $EA, $A2, $AA, $88, $20, $29, $22, $AB, $6A, $0E, $A0, $8C, $AA
	db $0F, $CB, $48, $AA, $08, $28, $8B, $08, $20, $02, $0A, $22, $41, $A0, $A2, $AA
	db $32, $C8, $94, $A0, $02, $CA, $38, $02, $C8, $3B, $81, $80, $A2, $CC, $86, $8A
	db $82, $A2, $3A, $2E, $40, $88, $0B, $01, $00, $3A, $A1, $29, $01, $8C, $22, $A8
	db $38, $00, $84, $88, $22, $0A, $22, $A2, $8B, $6A, $0A, $8A, $B0, $A2, $02, $A0
	db $81, $0A, $20, $A0, $82, $32, $F3, $92, $AA, $A2, $9B, $28, $22, $18, $8A, $88
	db $4A, $20, $82, $82, $28, $8B, $B8, $A0, $A6, $2A, $88, $B0, $BE, $AA, $97, $69
	db $EA, $AA, $E6, $AA, $F3, $BA, $AF, $CA, $DF, $F9, $FE, $DA, $FB, $BE, $FB, $BA
	db $AE, $EA, $BC, $9E, $36, $FE, $FB, $EA, $93, $EA, $FF, $BA, $FF, $FE, $BE, $AA
	db $26, $DA, $FB, $8F, $DB, $6E, $AE, $AE, $FE, $AF, $AA, $BF, $AA, $FA, $FB, $EF
	db $EE, $AB, $FA, $AF, $BF, $CB, $ED, $FE, $8F, $AE, $6E, $EB, $BB, $EA, $FE, $9A
	db $9B, $E7, $3F, $FF, $FB, $FF, $EE, $EB, $FE, $A6, $EF, $BF, $BE, $AA, $FE, $FF
	db $F6, $AE, $93, $EB, $BF, $FF, $83, $AA, $F3, $EA, $FB, $EF, $79, $BB, $FF, $FB
	db $FB, $D6, $EF, $BF, $7F, $AE, $FE, $BB, $2B, $F7, $99, $F3, $B6, $DF, $7D, $FA
	db $EB, $EF, $E2, $BE, $EF, $FE, $EB, $FE, $AF, $E3, $FD, $F3, $EA, $BF, $BC, $AB
	db $31, $A2, $CC, $00, $00, $22, $88, $E0, $A2, $28, $A3, $AA, $3A, $68, $00, $B0
	db $2A, $AA, $20, $B0, $9C, $20, $A0, $28, $6C, $00, $8E, $E8, $28, $8C, $A8, $2A
	db $24, $0A, $EA, $88, $23, $98, $8A, $20, $21, $0A, $AE, $0A, $AB, $88, $86, $A8
	db $00, $0A, $1A, $AE, $AB, $84, $E8, $2A, $62, $8A, $00, $2A, $A2, $8A, $88, $AA
	db $A2, $8A, $20, $BE, $89, $02, $AA, $A4, $22, $3A, $80, $AA, $0B, $2A, $82, $A2
	db $0C, $28, $A2, $8A, $0A, $0A, $80, $A2, $68, $AB, $29, $8A, $32, $0A, $2D, $A0
	db $C4, $22, $C1, $1C, $80, $8A, $22, $AC, $A8, $8C, $8E, $00, $2B, $A8, $02, $82
	db $50, $22, $02, $82, $4A, $A8, $A0, $A3, $C0, $1A, $00, $AA, $0A, $2A, $09, $88
	db $CA, $FF, $FA, $EF, $67, $EE, $FE, $FE, $AE, $9B, $2B, $A2, $BB, $EA, $BD, $EE
	db $EF, $FE, $BE, $4F, $BB, $FA, $AE, $BB, $BE, $EB, $AB, $FE, $FB, $CF, $8E, $E6
	db $DB, $3F, $B5, $CB, $4F, $FD, $EB, $BA, $FF, $AB, $BB, $EB, $DE, $BA, $FE, $CE
	db $97, $AF, $BA, $BE, $B7, $EA, $E5, $EF, $FF, $EF, $AF, $EF, $FB, $AF, $6F, $FD
	db $EF, $3F, $F9, $FB, $ED, $BE, $AF, $AB, $EF, $AE, $EA, $AB, $6B, $FA, $EB, $FE
	db $FB, $BB, $FF, $BE, $FE, $ED, $EA, $EA, $5C, $FF, $AB, $BA, $BF, $EB, $FB, $E7
	db $EB, $FA, $AF, $E9, $BB, $8F, $AD, $2B, $FB, $EF, $9A, $FE, $EE, $AA, $F7, $AF
	db $7F, $BE, $FC, $7E, $BA, $EE, $B6, $BF, $FB, $3B, $BE, $EE, $7B, $FF, $E6, $FE
	db $90, $0C, $1C, $88, $60, $A0, $A0, $2A, $90, $B0, $A9, $A2, $12, $A8, $E0, $02
	db $20, $43, $08, $24, $06, $A2, $04, $03, $80, $A8, $2A, $02, $23, $62, $A0, $AC
	db $28, $38, $C2, $02, $86, $02, $AB, $22, $20, $09, $03, $88, $10, $46, $A8, $AA
	db $D4, $8A, $20, $84, $88, $02, $A2, $42, $4A, $80, $12, $0B, $0A, $20, $9A, $A8
	db $30, $9A, $00, $00, $04, $32, $A0, $82, $02, $80, $20, $82, $C8, $6A, $43, $EB
	db $A1, $02, $08, $B0, $09, $82, $20, $EA, $8A, $A8, $68, $88, $1A, $A8, $A9, $22
	db $20, $28, $AA, $9A, $88, $29, $18, $08, $08, $80, $8A, $80, $0A, $11, $28, $0A
	db $58, $2E, $02, $08, $42, $E3, $A1, $12, $AA, $0A, $18, $AB, $A0, $B1, $A2, $AA
	db $B2, $7E, $BE, $DF, $6E, $FA, $BB, $AA, $7F, $3A, $3D, $3B, $B7, $A6, $1B, $BB
	db $39, $FF, $BA, $FB, $CF, $AA, $EB, $AB, $BA, $8B, $9E, $DE, $BA, $BE, $FC, $AB
	db $FE, $F2, $EF, $FC, $C7, $EF, $8A, $EF, $EE, $F8, $FF, $8E, $BF, $AF, $FD, $FA
	db $DB, $FB, $8F, $3B, $DA, $AE, $FE, $EE, $E5, $AF, $AF, $AF, $EE, $AA, $E6, $AA
	db $7B, $86, $FA, $EF, $2B, $AB, $BA, $BA, $FF, $3F, $A7, $BA, $FF, $FA, $AF, $EA
	db $FA, $B6, $FF, $EA, $EB, $EC, $CA, $FE, $EF, $A7, $6C, $BF, $EB, $AE, $FF, $8A
	db $FF, $FF, $7E, $BB, $67, $DD, $6A, $2A, $FF, $BB, $D2, $AB, $AE, $89, $BE, $EA
	db $EE, $AE, $6E, $FF, $EF, $AB, $BE, $AB, $BF, $CA, $8B, $FA, $FF, $EB, $EA, $BE
	db $08, $20, $0B, $88, $2C, $03, $28, $80, $28, $A2, $AA, $0A, $AA, $A2, $EA, $2A
	db $81, $00, $22, $A8, $00, $A8, $02, $82, $B0, $0A, $AB, $22, $12, $00, $AC, $83
	db $8A, $88, $A2, $E2, $02, $8A, $A8, $F8, $28, $2A, $29, $A8, $08, $28, $98, $8A
	db $8A, $8E, $82, $95, $01, $8A, $0A, $AA, $22, $0A, $A2, $2A, $42, $AA, $B8, $02
	db $A0, $00, $A2, $E2, $09, $8A, $2C, $A8, $A6, $08, $22, $A0, $38, $A3, $AC, $AA
	db $91, $26, $00, $88, $22, $9C, $02, $AA, $01, $A3, $40, $A2, $C2, $3A, $28, $80
	db $C8, $82, $02, $0A, $58, $A0, $A0, $A2, $BA, $02, $88, $0A, $08, $2A, $28, $80
	db $72, $80, $AA, $2A, $0A, $A2, $89, $2A, $A2, $22, $88, $A4, $2A, $84, $8A, $28
	db $FD, $BB, $AF, $BB, $27, $AE, $FB, $E7, $B6, $FF, $EB, $8B, $F8, $EE, $CE, $EE
	db $FE, $BA, $C6, $F2, $FE, $AF, $B6, $9F, $B7, $3A, $78, $AD, $E2, $B9, $E7, $AB
	db $BD, $7F, $EE, $FE, $FF, $ED, $FD, $AE, $7B, $EF, $AD, $EE, $B7, $B6, $BF, $E7
	db $B2, $BF, $BE, $AB, $CD, $FF, $CF, $FC, $FA, $AB, $FF, $EE, $6E, $FE, $DF, $FB
	db $DD, $B8, $68, $6C, $FE, $D9, $AB, $3B, $DE, $AE, $BF, $FB, $FA, $AE, $AB, $FF
	db $EE, $AE, $FA, $BF, $F9, $EB, $EA, $FF, $DE, $BC, $EE, $AF, $DF, $EC, $BA, $2A
	db $2F, $AA, $F6, $CE, $C3, $FF, $EE, $EB, $9A, $FB, $2E, $F7, $F3, $FF, $FE, $AE
	db $FA, $AF, $BA, $AA, $FC, $E6, $BF, $9E, $FE, $F5, $9B, $FE, $A8, $B2, $EF, $EF
	db $42, $00, $80, $0A, $00, $28, $28, $82, $A2, $80, $83, $90, $0A, $89, $10, $0A
	db $82, $20, $8B, $88, $0B, $A8, $80, $28, $0B, $82, $80, $8C, $82, $AA, $8B, $A2
	db $0A, $2A, $24, $0A, $00, $80, $32, $A8, $06, $2B, $0D, $28, $22, $2C, $A2, $8A
	db $38, $AE, $8A, $BE, $C8, $22, $0B, $AA, $7A, $2A, $0A, $88, $0A, $03, $88, $82
	db $00, $2B, $6E, $A2, $21, $82, $18, $0A, $4A, $38, $82, $2A, $C2, $0A, $42, $82
	db $4A, $A3, $2E, $E8, $8E, $80, $FA, $A8, $C0, $88, $AA, $2A, $9B, $12, $8A, $AA
	db $F6, $2A, $40, $80, $82, $8A, $A8, $AA, $00, $B2, $80, $62, $A0, $88, $A0, $01
	db $98, $00, $08, $88, $3E, $0E, $8C, $A0, $80, $82, $60, $26, $A2, $88, $A4, $AA
	db $EB, $AE, $AF, $AB, $1E, $B9, $AA, $FE, $FA, $EE, $DE, $AF, $A2, $FA, $BB, $EF
	db $7E, $BB, $6B, $FE, $7F, $F2, $6F, $78, $76, $AB, $B3, $FF, $FF, $AB, $6B, $BB
	db $E5, $3F, $F3, $FB, $3F, $AE, $AB, $FF, $FF, $EF, $BF, $FF, $FB, $FA, $BE, $AD
	db $BE, $FB, $FB, $E3, $EA, $EB, $FB, $FB, $BF, $3F, $BB, $AF, $E8, $BE, $FB, $AB
	db $EF, $FB, $EF, $EE, $BF, $EB, $F9, $AA, $FD, $7B, $BE, $FF, $7E, $BE, $7C, $BB
	db $FC, $BF, $2D, $AF, $FB, $F3, $EB, $AB, $E2, $FA, $EB, $8E, $FD, $BF, $AF, $FB
	db $FF, $FE, $BB, $BA, $F5, $A9, $EB, $FE, $DF, $BE, $79, $EE, $CA, $EE, $FE, $EF
	db $BD, $A7, $EF, $FF, $EA, $B6, $2B, $EF, $EB, $BF, $FE, $DF, $EA, $FA, $AB, $B7
	db $80, $08, $00, $A0, $0B, $8B, $66, $22, $88, $8A, $28, $28, $62, $A8, $AA, $A2
	db $0A, $00, $60, $84, $28, $20, $82, $9A, $0A, $AC, $AE, $08, $AA, $A4, $98, $2A
	db $E6, $8A, $04, $90, $2A, $D4, $08, $AA, $42, $AA, $22, $08, $E6, $A8, $C9, $8A
	db $A0, $89, $88, $AA, $B0, $A2, $E6, $82, $A8, $2A, $A9, $A1, $BA, $82, $12, $0A
	db $A4, $8E, $A3, $00, $A3, $8A, $E0, $21, $00, $2C, $63, $28, $A0, $80, $83, $80
	db $23, $02, $0E, $A0, $00, $AA, $22, $8E, $2A, $00, $28, $96, $5A, $A0, $02, $82
	db $88, $88, $89, $18, $03, $2A, $80, $AA, $20, $A2, $00, $0E, $22, $88, $60, $82
	db $BE, $B2, $B1, $82, $84, $02, $A0, $02, $28, $A8, $8E, $A2, $88, $0A, $42, $AA
	db $AE, $EC, $72, $FD, $FD, $CF, $96, $AB, $A7, $9B, $AF, $AE, $67, $8B, $FA, $F2
	db $AD, $9B, $FE, $C3, $FD, $E8, $5B, $FB, $FF, $AA, $DA, $BF, $FB, $2A, $7B, $FF
	db $7A, $8E, $AA, $BE, $B8, $EF, $BF, $3B, $57, $6B, $BF, $FB, $AD, $EB, $6F, $BF
	db $E6, $A8, $B7, $AE, $8F, $BB, $7A, $6B, $ED, $BB, $66, $AF, $1B, $FA, $FF, $A9
	db $F2, $AB, $FE, $EA, $99, $F2, $EE, $FA, $9D, $BE, $FA, $E2, $AF, $FC, $EF, $FE
	db $FA, $EE, $7B, $AA, $CA, $FF, $7B, $FB, $BB, $6A, $3B, $FE, $EB, $EF, $8A, $FF
	db $BF, $FE, $F7, $FB, $E7, $3E, $BF, $AE, $FB, $AA, $DA, $BF, $63, $F9, $FB, $DA
	db $6E, $EF, $EE, $EB, $7D, $9F, $BA, $FA, $F9, $FD, $BB, $FD, $FE, $AA, $9A, $3F
	db $66, $CE, $A2, $B0, $26, $18, $03, $C0, $42, $8A, $A1, $8A, $26, $88, $88, $AA
	db $18, $20, $CA, $8A, $B0, $0A, $EC, $28, $8E, $06, $08, $A6, $80, $80, $61, $08
	db $50, $9C, $E8, $AA, $B6, $82, $08, $88, $21, $C8, $00, $30, $08, $0A, $0F, $92
	db $00, $E0, $22, $28, $AA, $88, $C0, $A0, $42, $88, $48, $8B, $20, $A8, $A0, $36
	db $E2, $8A, $E6, $88, $8B, $82, $00, $0A, $A2, $80, $04, $08, $A2, $22, $2A, $0A
	db $02, $1C, $68, $83, $2A, $0A, $20, $80, $80, $2A, $82, $84, $1A, $C2, $8A, $B8
	db $8A, $8A, $8B, $0A, $E2, $B8, $8B, $A3, $A0, $00, $2A, $08, $20, $AA, $22, $02
	db $7A, $AA, $20, $3A, $23, $A2, $89, $8A, $22, $20, $A2, $38, $E3, $2A, $50, $A2
	db $EC, $3B, $AE, $BE, $FB, $7E, $AE, $EE, $A6, $AE, $CF, $BA, $A7, $BE, $BA, $EA
	db $FE, $A4, $BB, $EF, $F8, $EF, $EE, $FB, $EA, $AF, $76, $EB, $FF, $EA, $BE, $EC
	db $BE, $AA, $BE, $AF, $EF, $91, $CE, $F7, $B2, $B6, $B3, $EB, $AE, $ED, $AE, $EA
	db $34, $FB, $EE, $4A, $A2, $AE, $BA, $FA, $E6, $B2, $E7, $EA, $AB, $FF, $F6, $A8
	db $3E, $AF, $AE, $EE, $F2, $AE, $BD, $2B, $EE, $EA, $BB, $8B, $BB, $BA, $EF, $EB
	db $FE, $EA, $DE, $BF, $EB, $BE, $3E, $AA, $4E, $AE, $6E, $FF, $AB, $AA, $2B, $CA
	db $AE, $EF, $AF, $EE, $AF, $AE, $FF, $5E, $3F, $AE, $9F, $EB, $A7, $AE, $FF, $FA
	db $BE, $EE, $CA, $A6, $BE, $AF, $EF, $FA, $EF, $8A, $FE, $AB, $EF, $BF, $A6, $FE
	db $08, $98, $26, $22, $82, $A2, $02, $A8, $88, $A8, $28, $2A, $2A, $A8, $28, $A6
	db $80, $08, $02, $2A, $80, $88, $A8, $2A, $22, $0A, $2A, $8A, $A2, $0A, $EA, $24
	db $82, $23, $00, $90, $00, $00, $08, $A0, $A2, $01, $A0, $2A, $00, $EA, $82, $08
	db $00, $08, $A8, $02, $02, $28, $A0, $82, $C8, $88, $A2, $2A, $2A, $A8, $82, $AA
	db $08, $22, $A2, $82, $0C, $2A, $08, $AA, $0A, $20, $C8, $0A, $AE, $2E, $A4, $AA
	db $A0, $00, $00, $28, $20, $AA, $A8, $82, $20, $80, $AA, $88, $C8, $AA, $A8, $88
	db $88, $2B, $02, $08, $E8, $C2, $20, $A2, $00, $08, $8C, $A2, $E2, $0A, $22, $AA
	db $60, $4C, $08, $E8, $80, $8C, $A2, $A2, $AE, $82, $AA, $AA, $20, $22, $20, $A2
	db $EF, $CE, $EE, $7B, $3E, $FB, $EE, $AE, $FF, $EA, $E7, $EA, $FE, $AB, $EC, $CA
	db $BD, $3A, $AB, $E6, $EE, $3E, $EA, $EA, $BE, $AE, $FE, $ED, $EF, $A2, $FB, $9E
	db $EF, $BA, $EF, $AF, $6E, $66, $E4, $FB, $BE, $EA, $DF, $EF, $FF, $AC, $29, $A2
	db $2B, $EE, $BB, $CA, $D9, $DA, $FE, $AA, $8F, $E9, $E8, $EE, $FF, $E3, $AA, $AF
	db $FE, $AB, $FB, $FE, $FA, $EA, $AB, $BF, $A6, $EA, $AF, $EA, $F7, $CB, $FA, $FA
	db $B4, $66, $B2, $DF, $AF, $AB, $FE, $DA, $CA, $FB, $A2, $EF, $E2, $AB, $6F, $EA
	db $F1, $EE, $A6, $8A, $8E, $EE, $BE, $FE, $FE, $6E, $BB, $BE, $F2, $AA, $AF, $EA
	db $CA, $AB, $AE, $EF, $BB, $EA, $EE, $FE, $BE, $BE, $EE, $EE, $C2, $EE, $EE, $7A
	db $02, $8A, $22, $88, $23, $22, $CA, $8A, $20, $6A, $4A, $2A, $49, $26, $20, $20
	db $CC, $28, $AA, $AA, $20, $80, $20, $08, $58, $08, $AA, $00, $A6, $A0, $22, $AA
	db $40, $A0, $44, $20, $28, $A0, $EC, $A0, $04, $AA, $69, $AA, $06, $80, $A0, $22
	db $28, $0E, $8B, $80, $20, $28, $AA, $A2, $4C, $0B, $86, $A2, $28, $0A, $86, $80
	db $2C, $A2, $0A, $9A, $49, $20, $62, $08, $60, $A2, $24, $A8, $00, $A2, $20, $20
	db $8A, $23, $80, $68, $88, $00, $B2, $20, $82, $02, $30, $80, $06, $AA, $98, $AA
	db $8A, $88, $62, $A2, $2E, $22, $47, $A8, $82, $22, $00, $22, $20, $28, $A8, $A8
	db $E0, $88, $E0, $E8, $A2, $82, $20, $AA, $60, $2A, $6A, $8A, $80, $28, $0A, $C8
	db $AA, $EE, $CB, $BE, $CE, $FE, $BE, $6A, $FF, $B6, $E3, $BF, $EE, $9A, $EC, $A2
	db $BA, $EE, $4E, $FB, $AF, $AA, $BF, $FA, $AE, $A7, $E1, $AE, $AA, $E2, $B2, $BA
	db $4E, $AE, $CE, $BE, $AF, $F6, $EF, $AE, $EE, $3E, $FC, $AA, $AA, $A6, $8E, $EF
	db $6A, $AF, $9B, $AA, $7E, $BF, $FF, $EF, $A2, $6A, $EE, $DF, $FE, $8F, $BE, $AA
	db $EF, $FA, $7E, $FA, $7E, $BE, $E8, $AF, $3B, $EA, $A3, $EE, $EA, $AE, $BA, $3E
	db $36, $2A, $AE, $EF, $18, $BE, $EB, $AE, $EC, $A6, $AF, $EE, $9A, $E8, $F9, $AA
	db $B3, $FE, $CE, $EA, $ED, $FE, $A8, $BE, $AA, $EB, $FE, $AE, $BE, $FA, $EF, $AA
	db $78, $BA, $A3, $EE, $A2, $EB, $FC, $AE, $3E, $EE, $F6, $EA, $8E, $BD, $BE, $EA
	db $A0, $22, $0E, $2A, $9A, $A8, $88, $2A, $8A, $AA, $82, $02, $E2, $0A, $06, $20
	db $D3, $20, $0A, $22, $8A, $82, $80, $22, $02, $A2, $A8, $CA, $02, $A3, $48, $A8
	db $88, $22, $00, $28, $88, $A0, $E0, $2A, $E0, $A4, $82, $88, $82, $AA, $20, $8A
	db $88, $AA, $A0, $12, $2A, $A8, $A8, $86, $40, $AE, $A2, $A0, $48, $2A, $0A, $AA
	db $08, $AC, $00, $02, $88, $82, $0A, $A2, $89, $A0, $68, $08, $2A, $82, $62, $88
	db $88, $80, $1C, $AE, $20, $88, $20, $AA, $28, $0C, $22, $A8, $00, $02, $AA, $8A
	db $8E, $A2, $02, $B2, $80, $82, $80, $2A, $92, $28, $A8, $AA, $80, $8E, $82, $88
	db $88, $0A, $8A, $8A, $80, $A8, $A0, $08, $08, $02, $AA, $2A, $A2, $8A, $A8, $8A
	db $5B, $72, $F6, $FE, $EE, $E6, $CE, $BA, $EE, $EF, $FB, $9E, $BB, $BA, $7E, $AE
	db $0E, $BA, $DC, $AF, $ED, $FF, $B7, $FE, $37, $7B, $AB, $EA, $AB, $FF, $F9, $BE
	db $E1, $F7, $BE, $CC, $EB, $AE, $BD, $FE, $E4, $FF, $AA, $EA, $BF, $EB, $EA, $3F
	db $8F, $EE, $BA, $68, $EE, $AA, $93, $B6, $EE, $FD, $6F, $2F, $ED, $8B, $6F, $EB
	db $9E, $AF, $CE, $3E, $AF, $AF, $63, $FA, $BE, $FE, $AB, $B0, $EA, $9C, $AB, $AA
	db $F3, $3F, $FE, $FB, $EE, $F8, $AB, $AC, $EB, $BE, $BE, $FE, $F6, $FF, $EB, $AA
	db $EF, $3A, $BB, $AE, $6E, $2B, $FF, $AE, $BF, $BF, $BE, $AB, $FB, $3F, $3B, $DE
	db $C7, $AB, $FF, $FE, $AF, $6E, $E6, $EB, $A7, $EA, $BA, $EB, $FB, $AA, $E1, $BE
	db $90, $02, $48, $39, $08, $08, $81, $4A, $80, $26, $2E, $E6, $88, $A8, $08, $8A
	db $F0, $E8, $0A, $AA, $E0, $8D, $E8, $88, $0A, $99, $0A, $38, $4A, $AC, $A0, $28
	db $00, $82, $8A, $A8, $72, $C2, $8E, $8A, $AE, $2A, $0C, $80, $69, $20, $18, $2E
	db $6A, $0B, $21, $AA, $08, $8A, $28, $18, $29, $42, $22, $28, $B9, $20, $08, $2A
	db $6C, $20, $E8, $20, $1E, $08, $1A, $8A, $13, $06, $C0, $02, $00, $A6, $09, $84
	db $16, $CA, $8C, $0A, $81, $20, $A2, $83, $38, $88, $2A, $02, $0A, $A8, $89, $0A
	db $31, $20, $2A, $28, $AC, $EA, $CE, $2A, $F1, $8B, $8A, $BA, $24, $38, $8A, $80
	db $2A, $02, $00, $AA, $18, $A8, $8A, $20, $89, $02, $21, $08, $10, $08, $A8, $02


SECTION "bank1D", ROMX, BANK[$1D]

GFX_TilesetTurtleZone1: ;$74000
INCBIN "gfx/tilesets/turtlezone1.2bpp"

GFX_TilesetTurtleZone2: ;$74600
INCBIN "gfx/tilesets/turtlezone2.2bpp"

GFX_TilesetTurtleZone3: ;$74C00
INCBIN "gfx/tilesets/turtlezone3.2bpp"

GFX_TilesetTurtleZoneBoss: ;$75200
INCBIN "gfx/tilesets/turtlezoneboss.2bpp"

GFX_EnemiesTurtleZone1: ;$75800
INCBIN "gfx/enemies/turtlezone1.2bpp"

GFX_EnemiesTurtleZone2: ;$75B80
INCBIN "gfx/enemies/turtlezone2.2bpp"

GFX_EnemiesTurtleZone3: ;$75F00
INCBIN "gfx/enemies/turtlezone3.2bpp"

GFX_EnemiesTurtleZoneBoss: ;$76280
INCBIN "gfx/enemies/turtlezoneboss.2bpp"

INCBIN "baserom.gb", $76600, $78000 - $76600


SECTION "bank1E", ROMX, BANK[$1E]

GFX_TilesetSpaceZone: ;$78000
INCBIN "gfx/tilesets/spacezone.2bpp"

GFX_TilesetPumpkinZoneBoss2: ;$78600 maybe unused?
INCBIN "gfx/tilesets/pumpkinzoneboss2.2bpp"

GFX_TilesetWarioCastle: ;$78C00
INCBIN "gfx/tilesets/wariocastle.2bpp"

GFX_TilesetWarioRoom: ;$79200
INCBIN "gfx/tilesets/warioroom.2bpp"

GFX_TilesetWarioRoom2: ;$79800
INCBIN "gfx/tilesets/warioroom2.2bpp"

GFX_EnemiesHippoLevel: ;$79A00
INCBIN "gfx/enemies/hippolevel.2bpp"

GFX_EnemiesSpaceZone1: ;$79D80
INCBIN "gfx/enemies/spacezone1.2bpp"

GFX_EnemiesSpaceZone2: ;$7A100
INCBIN "gfx/enemies/spacezone2.2bpp"

GFX_EnemiesSpaceZoneBoss: ;$7A480
INCBIN "gfx/enemies/spacezoneboss.2bpp"

GFX_EnemiesSpaceZoneBoss2: ;$7A800
INCBIN "gfx/enemies/spacezoneboss2.2bpp"

GFX_EnemiesWarioCastle1: ;$7A880
INCBIN "gfx/enemies/wariocastle1.2bpp"

GFX_EnemiesWarioCastle2: ;$7AC00
INCBIN "gfx/enemies/wariocastle2.2bpp"

GFX_EnemiesWario1: ;$7AF80
INCBIN "gfx/enemies/wario1.2bpp"

GFX_EnemiesWario2: ;$7B300
INCBIN "gfx/enemies/wario2.2bpp"

UnknownData_0x7B680: ;level-layout-like data (0xAA-heavy), unclassified
	db $21, $22, $A2, $2A, $AA, $E8, $E2, $88, $80, $AE, $2A, $F3, $4A, $C8, $B8, $8A
	db $3A, $1A, $0A, $A6, $22, $A8, $2A, $AA, $EC, $A0, $4A, $8A, $1E, $A2, $AA, $82
	db $88, $88, $20, $A3, $28, $2E, $82, $A8, $8C, $88, $1B, $AA, $0E, $C2, $93, $8A
	db $28, $A1, $BA, $2A, $03, $A8, $88, $A2, $A8, $AB, $A2, $82, $8A, $0E, $20, $8A
	db $28, $18, $AE, $3A, $2E, $2A, $88, $0A, $0A, $AA, $89, $A8, $0A, $AA, $A8, $AA
	db $FA, $A8, $AA, $08, $8A, $A2, $A8, $88, $AA, $8A, $9A, $AA, $BA, $22, $AA, $20
	db $0A, $0A, $0A, $8A, $A6, $A8, $AA, $A2, $A1, $A6, $80, $2A, $CB, $E1, $98, $82
	db $84, $28, $20, $A8, $82, $AA, $22, $AA, $82, $A0, $AA, $A2, $20, $CA, $8A, $AA
	db $9E, $BB, $FF, $BA, $FB, $7A, $AA, $BF, $EF, $F7, $BE, $66, $FE, $BB, $EC, $2F
	db $E7, $CC, $BB, $BE, $DE, $8F, $EA, $E3, $CB, $2A, $AA, $A1, $BE, $F6, $A6, $EF
	db $AA, $BD, $6E, $FF, $EB, $EF, $EF, $FA, $EE, $EE, $BB, $FA, $58, $AE, $BA, $EB
	db $BA, $2B, $A7, $BA, $E6, $6F, $FB, $AE, $EA, $EA, $EE, $AA, $9F, $BE, $AF, $2B
	db $EB, $EB, $8E, $EE, $AB, $BB, $BC, $9F, $AF, $B0, $7A, $BB, $4C, $EA, $9B, $AE
	db $3B, $BF, $BD, $EA, $EE, $BF, $EE, $AE, $BE, $FA, $AB, $AE, $F2, $AE, $A8, $AF
	db $AA, $DB, $AA, $3E, $B7, $EF, $BB, $AA, $EE, $FA, $BF, $CF, $67, $FA, $FF, $AE
	db $E3, $BE, $EA, $EB, $EB, $AA, $FA, $BE, $FD, $FA, $9A, $EA, $E9, $BA, $AA, $8B
	db $AA, $F0, $2A, $88, $20, $2A, $1A, $AA, $6C, $28, $2A, $38, $6E, $02, $0A, $28
	db $A8, $88, $82, $20, $2A, $08, $AA, $8A, $AB, $E2, $AA, $AA, $AA, $A2, $C8, $09
	db $A8, $EA, $28, $8E, $AA, $0A, $6A, $8F, $32, $A0, $E0, $8A, $0C, $8A, $BA, $AA
	db $A2, $8A, $AB, $EA, $0A, $AA, $28, $2B, $88, $8E, $89, $0A, $A2, $28, $02, $2A
	db $0A, $AB, $A6, $E8, $A8, $A2, $A8, $88, $2A, $DB, $A8, $82, $C8, $86, $08, $A0
	db $A8, $22, $A8, $A8, $E0, $A8, $32, $26, $A8, $9E, $28, $EA, $02, $0A, $88, $AB
	db $C0, $22, $AE, $AA, $38, $2A, $08, $8A, $23, $49, $84, $A1, $26, $A0, $A2, $A2
	db $BE, $AA, $A0, $A2, $AE, $A0, $22, $BA, $A2, $82, $A5, $A2, $A2, $AB, $8F, $2A
	db $AA, $FB, $AA, $DA, $FB, $BA, $AA, $AA, $AE, $B8, $FB, $AA, $AF, $FF, $FA, $AE
	db $FF, $CF, $AB, $BE, $CE, $BA, $FF, $BE, $BB, $3E, $BE, $EA, $8A, $FE, $BA, $AF
	db $AA, $A2, $BE, $AA, $AF, $BB, $DB, $EE, $B7, $BB, $FE, $EA, $AB, $F4, $AB, $FF
	db $6E, $9B, $AC, $FF, $AF, $EB, $AE, $AF, $E7, $FF, $EE, $AE, $EA, $B6, $FF, $AA
	db $8F, $30, $FA, $AE, $BA, $F6, $AF, $EB, $AA, $CE, $AB, $EA, $BA, $BD, $AB, $EA
	db $6B, $EB, $AE, $FB, $EF, $FE, $EA, $FB, $FA, $3E, $BE, $EB, $EF, $AE, $AB, $EA
	db $EE, $E6, $EF, $B9, $EE, $FB, $EA, $A8, $CB, $AF, $FB, $EA, $EA, $AB, $A2, $BB
	db $2A, $FB, $EE, $AA, $F8, $AA, $EE, $83, $FA, $AB, $AF, $FA, $BE, $8B, $AC, $FA
	db $AA, $02, $0B, $8A, $23, $2E, $8A, $A8, $8A, $94, $AB, $8F, $E2, $8B, $BA, $12
	db $A2, $2C, $A8, $8A, $9E, $82, $AA, $8A, $00, $4E, $80, $80, $00, $2A, $42, $AE
	db $AC, $21, $62, $1A, $9A, $EA, $A9, $88, $82, $2A, $9D, $AA, $A2, $AA, $A0, $A2
	db $2A, $AA, $8C, $2A, $AC, $20, $08, $A8, $AD, $AA, $BA, $AA, $80, $2A, $AA, $82
	db $E2, $92, $AA, $89, $08, $88, $22, $28, $02, $A0, $1A, $AA, $8E, $CA, $AB, $82
	db $28, $0A, $2F, $2A, $A3, $88, $A2, $AA, $22, $A2, $82, $8C, $BA, $AA, $B2, $AB
	db $AA, $00, $80, $EA, $AF, $AC, $BA, $66, $AA, $AA, $A8, $A2, $00, $20, $2A, $9B
	db $E8, $8A, $38, $82, $AB, $8A, $AB, $88, $EA, $AA, $2A, $02, $A8, $A2, $AA, $AA
	db $BF, $7A, $F8, $BB, $3F, $FB, $DC, $F7, $AB, $FF, $BE, $FB, $AA, $F8, $ED, $AA
	db $EA, $EA, $EF, $EE, $AF, $BB, $F2, $AE, $BB, $EE, $FA, $E6, $BF, $EF, $E0, $EF
	db $27, $FA, $FB, $9E, $FE, $FA, $2E, $AF, $E6, $2F, $FA, $AA, $37, $EB, $FF, $38
	db $EA, $59, $AF, $36, $28, $BB, $FA, $AA, $EF, $FA, $7A, $AA, $EA, $AA, $F9, $BC
	db $EB, $AE, $AE, $C7, $EE, $FE, $8E, $EE, $FA, $9F, $B6, $A3, $3E, $E3, $AB, $BA
	db $F8, $A9, $DA, $BA, $FA, $8A, $DB, $AE, $BE, $2B, $2A, $3A, $AB, $AB, $AB, $8B
	db $AA, $E7, $EE, $EA, $69, $7F, $BA, $8B, $EF, $FA, $FB, $AF, $42, $BA, $AB, $2A
	db $CC, $AA, $3F, $EB, $F7, $8B, $F6, $EF, $AA, $EE, $EF, $E2, $B3, $B8, $EF, $7F
	db $AE, $2A, $8A, $08, $0A, $82, $8A, $08, $A0, $C0, $80, $98, $A2, $8A, $D9, $E8
	db $0A, $32, $8A, $20, $8A, $00, $20, $80, $08, $A2, $A2, $02, $A8, $A2, $02, $28
	db $A4, $08, $81, $2A, $D8, $08, $0C, $02, $EB, $B6, $3A, $8A, $8A, $20, $38, $A9
	db $7A, $3A, $15, $AA, $8A, $98, $2A, $0A, $4A, $A0, $B8, $08, $B5, $88, $A2, $22
	db $88, $AA, $80, $8A, $68, $2A, $22, $82, $2A, $AA, $B0, $24, $2A, $AA, $A5, $28
	db $02, $A2, $80, $8A, $A8, $88, $88, $A2, $A2, $88, $2A, $08, $02, $28, $A8, $A8
	db $5A, $86, $80, $88, $AA, $8C, $8A, $AA, $9A, $A2, $26, $E8, $2A, $20, $88, $A4
	db $AA, $38, $80, $2A, $BA, $20, $22, $22, $A6, $A0, $C2, $CA, $AA, $AE, $B2, $A8
	db $AA, $AF, $FF, $BA, $B2, $AB, $F9, $EE, $6B, $A2, $E6, $AA, $FA, $AC, $FA, $8E
	db $B9, $3D, $8B, $EA, $9E, $BF, $AE, $AA, $BA, $AB, $BB, $EF, $BE, $AE, $2F, $FB
	db $AA, $AF, $EE, $BE, $EF, $BF, $BD, $9F, $AA, $EB, $9B, $F2, $EB, $8B, $AA, $D3
	db $A2, $BA, $AE, $BE, $2A, $F0, $EE, $B7, $B6, $6E, $EE, $FE, $B2, $F3, $EE, $BF
	db $BF, $2F, $87, $AB, $BE, $AF, $9F, $EB, $2F, $BB, $EB, $3F, $66, $8B, $FA, $AA
	db $7A, $8E, $EE, $EF, $EA, $EE, $AF, $9A, $AA, $AB, $6E, $AE, $AE, $2F, $9B, $8B
	db $EF, $DE, $8A, $EB, $B2, $FB, $FF, $AE, $6F, $EB, $AE, $FE, $BB, $BB, $AF, $AF
	db $EF, $E2, $AE, $BF, $BE, $BE, $AF, $BA, $FE, $BE, $AD, $BE, $B3, $AA, $AB, $2E
	db $42, $22, $DA, $A0, $B8, $03, $D2, $8A, $29, $2A, $A2, $22, $00, $CA, $BA, $A2
	db $AA, $EA, $AA, $18, $A0, $A8, $A8, $A0, $AA, $28, $A9, $80, $00, $2B, $AE, $A9
	db $99, $A9, $BB, $AA, $2B, $26, $AB, $22, $19, $02, $2A, $AA, $18, $02, $A2, $A8
	db $A2, $2A, $D8, $AA, $20, $9B, $A2, $A8, $A2, $2B, $88, $2A, $80, $A8, $0A, $22
	db $A2, $AA, $28, $A0, $E8, $86, $A8, $8A, $AA, $A0, $8A, $26, $23, $80, $0A, $28
	db $00, $AE, $A2, $22, $B2, $6A, $2A, $88, $A0, $88, $F0, $B0, $A2, $8A, $28, $20
	db $68, $A8, $64, $08, $AA, $90, $02, $A2, $82, $2B, $A2, $A0, $02, $00, $3A, $AA
	db $50, $AA, $1B, $82, $04, $82, $20, $A0, $AC, $A0, $AA, $3A, $88, $8A, $8A, $C3
	db $EA, $BE, $EF, $EB, $A4, $CB, $E7, $BE, $3A, $9F, $FF, $A6, $FE, $E2, $EE, $AF
	db $9A, $AE, $E7, $AA, $FB, $AB, $AA, $EA, $EA, $82, $A6, $AE, $EB, $6B, $AB, $AA
	db $B9, $BA, $EB, $BB, $FB, $EB, $BD, $62, $CA, $EE, $2F, $EE, $F7, $A6, $9E, $AA
	db $FB, $87, $EA, $BA, $BB, $F5, $7A, $BF, $FB, $B2, $BF, $78, $EF, $E2, $AE, $EE
	db $EA, $EF, $BB, $8A, $EA, $EE, $AE, $BB, $BC, $A8, $EE, $EB, $EE, $C7, $BE, $FE
	db $A9, $E8, $AC, $FA, $2A, $6A, $EA, $BE, $BA, $AA, $6E, $FF, $2F, $89, $BB, $BA
	db $9D, $BF, $AE, $FB, $FB, $BB, $AE, $AA, $FE, $ED, $BA, $FF, $A2, $EA, $3F, $6E
	db $3B, $9B, $DB, $E2, $AA, $FB, $F5, $BA, $AE, $BA, $BE, $AB, $AA, $AF, $DE, $A2
	db $A2, $A8, $FC, $80, $22, $8B, $2A, $30, $82, $0A, $0C, $2A, $6A, $2A, $A4, $AE
	db $9B, $AA, $0A, $AE, $88, $0A, $6A, $22, $A2, $AE, $A8, $A2, $2A, $62, $96, $8A
	db $AA, $8A, $8A, $28, $A2, $28, $6E, $22, $22, $02, $A8, $2A, $1C, $00, $0A, $02
	db $BA, $2A, $8A, $8A, $AA, $BA, $08, $A8, $89, $88, $A4, $82, $0A, $AA, $E2, $AA
	db $9A, $A8, $28, $82, $8A, $02, $02, $2A, $AA, $EA, $8E, $82, $2A, $9A, $11, $A2
	db $38, $02, $2A, $A6, $80, $3A, $8E, $A2, $8B, $AA, $18, $2A, $02, $B8, $22, $A2
	db $20, $22, $AA, $8B, $8B, $A0, $0B, $A8, $0E, $2A, $AB, $8B, $AA, $AB, $EA, $82
	db $AB, $A0, $2A, $48, $A3, $3A, $2B, $8A, $80, $2B, $C8, $28, $A0, $20, $CA, $AA
	db $C7, $AA, $FF, $BA, $EA, $EA, $BF, $BA, $FE, $8A, $AE, $EB, $AA, $EE, $A0, $EA
	db $AA, $A8, $AA, $FA, $AE, $BE, $AF, $AA, $AE, $AA, $E8, $EA, $A6, $8B, $EF, $CC
	db $EE, $EB, $A8, $AA, $BE, $A0, $AA, $AA, $EA, $6A, $E8, $EA, $EA, $FE, $BA, $EB
	db $DA, $BA, $AE, $FA, $EE, $AA, $AA, $AA, $BD, $A7, $AE, $EE, $EE, $8B, $FF, $AE
	db $E6, $A4, $AE, $CA, $AA, $22, $BE, $EC, $A6, $EF, $CA, $EA, $BE, $AE, $F3, $AE
	db $AE, $AA, $AE, $BB, $CE, $C2, $A3, $AE, $AA, $BE, $EF, $9A, $AA, $FB, $23, $EA
	db $2E, $BE, $EE, $8A, $EB, $EA, $EA, $AA, $28, $AA, $A8, $EE, $EB, $EE, $F2, $AB
	db $B8, $EE, $A9, $BA, $EA, $6E, $BA, $AC, $EA, $2E, $AA, $EF, $FB, $E9, $9A, $BF
	db $A1, $EA, $A2, $88, $AA, $2B, $2A, $A0, $8A, $A8, $20, $AA, $2A, $AA, $82, $22
	db $AA, $A0, $8A, $CA, $AA, $80, $8A, $A0, $0A, $A8, $6B, $C2, $28, $A8, $28, $AA
	db $82, $8A, $0A, $82, $A8, $22, $C2, $28, $82, $2A, $A0, $AA, $FA, $86, $A2, $8A
	db $28, $20, $E2, $82, $A2, $AE, $3A, $2A, $80, $2A, $AA, $A0, $2A, $AA, $28, $4E
	db $A2, $AA, $60, $A0, $82, $48, $2A, $EA, $A8, $82, $E0, $2E, $EA, $AA, $A0, $A8
	db $A8, $88, $A6, $A2, $82, $88, $2A, $AA, $28, $22, $A8, $0A, $00, $80, $2A, $02
	db $88, $A8, $A8, $AB, $2A, $AA, $8A, $AA, $82, $A0, $28, $88, $28, $2A, $86, $0A
	db $00, $AA, $6A, $8C, $A4, $82, $28, $68, $A2, $A0, $2E, $8A, $A6, $C6, $AA, $A8
	db $AA, $EE, $29, $FA, $A6, $BB, $AF, $AA, $FE, $AB, $AA, $A8, $EE, $AF, $E6, $EA
	db $CA, $AC, $AE, $EA, $8A, $EF, $AE, $A2, $B2, $BA, $C8, $E6, $AE, $EC, $29, $AE
	db $9A, $AE, $BB, $EE, $EE, $EE, $FE, $EA, $32, $AA, $EA, $FA, $AE, $8A, $E2, $AA
	db $A2, $A2, $AF, $BA, $AE, $AE, $AA, $2E, $CC, $A2, $A6, $AA, $AA, $B1, $EE, $AE
	db $EE, $AE, $2E, $E6, $AE, $AB, $8A, $2B, $BA, $EA, $2A, $AE, $A2, $AE, $A8, $B2
	db $EE, $6D, $AA, $22, $E8, $EF, $AF, $82, $EA, $86, $AA, $FA, $EA, $EA, $8C, $FA
	db $AA, $FE, $FE, $EB, $EE, $EC, $6A, $AE, $EA, $A7, $EE, $AE, $AF, $8A, $AE, $BA
	db $BE, $EE, $AE, $EE, $A0, $AF, $0A, $BE, $8A, $FE, $3B, $DF, $EF, $EA, $AA, $8A
	db $E0, $8A, $8A, $AA, $0C, $88, $A2, $2C, $2A, $A2, $28, $A0, $82, $08, $AA, $A8
	db $82, $88, $88, $8A, $6A, $CA, $66, $AA, $6A, $AA, $EA, $08, $0C, $0A, $88, $A9
	db $6A, $A0, $8A, $AA, $A0, $A2, $28, $20, $88, $22, $22, $8C, $A2, $A8, $82, $AA
	db $6A, $A8, $32, $A8, $A0, $A2, $AA, $A2, $82, $20, $AA, $A8, $AA, $A0, $AA, $A2
	db $2A, $86, $22, $CA, $22, $A2, $0A, $28, $8A, $2A, $EA, $8A, $A8, $2A, $A0, $AA
	db $08, $AA, $0B, $AA, $2B, $AA, $27, $EA, $AA, $A8, $24, $62, $4A, $A8, $22, $A2
	db $08, $20, $28, $E2, $6A, $82, $EA, $A0, $28, $02, $86, $2A, $AA, $02, $A8, $0B
	db $0A, $2A, $C8, $AA, $88, $2A, $2A, $22, $C2, $AE, $A0, $88, $02, $A2, $80, $2A
	db $BE, $CA, $AA, $AE, $A8, $AB, $AE, $EE, $6A, $6A, $CC, $AA, $8E, $EE, $AE, $EA
	db $EA, $EE, $BA, $E2, $88, $AE, $A8, $BA, $EA, $EE, $AE, $EA, $A8, $7A, $EE, $EE
	db $EE, $AA, $2A, $2E, $AE, $A3, $AE, $2A, $EA, $AA, $EB, $FA, $EE, $CB, $AF, $AA
	db $EF, $AE, $BE, $EA, $CA, $EA, $62, $2E, $A7, $E6, $E6, $CA, $BE, $EE, $AE, $FC
	db $A8, $BA, $BA, $AA, $2A, $AB, $EE, $7E, $EA, $EA, $38, $EE, $AE, $AA, $AF, $AE
	db $AB, $6E, $8E, $AC, $EE, $AA, $EE, $AA, $EB, $2A, $EE, $AB, $AE, $2B, $EE, $FA
	db $FB, $EE, $0E, $BB, $EE, $AE, $EA, $BB, $02, $E2, $EE, $AA, $EA, $AE, $AA, $EE
	db $A2, $DA, $8A, $AB, $EE, $EA, $AA, $9A, $EA, $AB, $E7, $FA, $FA, $EA, $EA, $BA
	db $A8, $8A, $A4, $2A, $20, $EA, $E2, $A0, $8A, $00, $22, $A2, $AA, $0C, $A0, $A8
	db $88, $22, $82, $8A, $AA, $2A, $88, $AE, $EC, $08, $AA, $2A, $3A, $AA, $AA, $AA
	db $82, $82, $22, $A2, $20, $A2, $48, $AE, $AA, $22, $AA, $AA, $28, $AE, $2A, $88
	db $A8, $28, $2A, $2A, $82, $A0, $A8, $CA, $8A, $0A, $88, $22, $22, $AA, $20, $88
	db $28, $02, $28, $AA, $8A, $2A, $AA, $A2, $2A, $A8, $E8, $22, $48, $CA, $A8, $A2
	db $82, $2E, $A2, $0A, $A9, $AA, $28, $88, $00, $00, $80, $8A, $0A, $2A, $8A, $A8
	db $A2, $A8, $A4, $AA, $2A, $A2, $AE, $28, $8A, $E0, $AE, $02, $2C, $AA, $AA, $AA
	db $AA, $A2, $E2, $AA, $8A, $AA, $0A, $2A, $0C, $2A, $2A, $A8, $20, $8A, $A2, $8A
	db $DA, $A6, $FA, $E2, $AB, $FA, $AA, $A9, $EB, $DB, $30, $AA, $3E, $AE, $3A, $AE
	db $B2, $FA, $E7, $3A, $BA, $AA, $A9, $BB, $A2, $AE, $AB, $FA, $AB, $FA, $7B, $EE
	db $EE, $E2, $AE, $BA, $A9, $9A, $EA, $EE, $AB, $AA, $9E, $EE, $EA, $FE, $EF, $8E
	db $3A, $AE, $FF, $FA, $5A, $BA, $DA, $3B, $BA, $A6, $AF, $AE, $BE, $BE, $AD, $AA
	db $B3, $AA, $6A, $EE, $BA, $B6, $AE, $AA, $FA, $EB, $EA, $AA, $A8, $AF, $88, $8A
	db $BA, $EB, $AF, $6E, $BA, $EE, $E7, $AA, $3A, $FA, $AA, $6E, $AA, $2E, $EA, $EA
	db $CB, $7E, $AE, $BA, $BE, $A2, $FA, $E2, $8A, $BA, $BA, $A2, $9A, $B2, $EA, $A2
	db $AE, $F0, $2C, $AF, $AA, $B7, $8A, $EA, $28, $2C, $EA, $EE, $DE, $F6, $EA, $AA
	db $2A, $2A, $27, $02, $2A, $22, $0E, $A8, $2A, $82, $2A, $AA, $B2, $88, $A2, $A0
	db $38, $AA, $E2, $8A, $A1, $0A, $A3, $AC, $02, $4A, $03, $AB, $EA, $AA, $EA, $A2
	db $0A, $A6, $A0, $B8, $A0, $26, $21, $02, $8A, $88, $88, $20, $98, $A8, $AA, $AA
	db $30, $74, $B7, $1A, $8A, $A0, $A2, $A8, $2A, $82, $82, $AA, $1E, $02, $0E, $AA
	db $6B, $A8, $B1, $22, $AE, $28, $80, $A2, $A2, $2B, $40, $86, $82, $BE, $22, $A0
	db $8A, $A2, $A2, $62, $2A, $A8, $A2, $B2, $AC, $A2, $E8, $82, $AB, $2A, $EA, $AA
	db $AA, $A8, $8A, $28, $78, $98, $2C, $28, $EA, $E0, $AB, $AA, $88, $22, $0A, $88
	db $0E, $0B, $2A, $AA, $2A, $23, $B1, $A0, $AA, $2A, $38, $2A, $CA, $A2, $48, $8A

SECTION "bank1F", ROMX, BANK[$1F]

GFX_TilesetPumpkinZone1: ;$7C000
INCBIN "gfx/tilesets/pumpkinzone1.2bpp"

GFX_TilesetPumpkinZone2: ;$7C600
INCBIN "gfx/tilesets/pumpkinzone2.2bpp"

GFX_TilesetPumpkinZone3: ;$7CC00
INCBIN "gfx/tilesets/pumpkinzone3.2bpp"

GFX_TilesetPumpkinZone4: ;$7D200
INCBIN "gfx/tilesets/pumpkinzone4.2bpp"

GFX_TilesetPumpkinZoneBoss: ;$7D800
INCBIN "gfx/tilesets/pumpkinzoneboss.2bpp"

GFX_EnemiesPumpkinZone1: ;$7DE00
INCBIN "gfx/enemies/pumpkinzone1.2bpp"

GFX_EnemiesPumpkinZone2: ;$7E180
INCBIN "gfx/enemies/pumpkinzone2.2bpp"

GFX_EnemiesPumpkinZone3: ;$7E500
INCBIN "gfx/enemies/pumpkinzone3.2bpp"

GFX_EnemiesPumpkinZone4: ;$7E880
INCBIN "gfx/enemies/pumpkinzone4.2bpp"

GFX_EnemiesPumpkinZoneBoss: ;$7EC00
INCBIN "gfx/enemies/pumpkinzoneboss.2bpp"

UnknownData_0x7EF80: ;unclassified packed data (0xAA-heavy, PumpkinZone bank tail)
	db $07, $07, $1F, $18, $3F, $23, $7C, $4F, $73, $5C, $F7, $98, $EF, $B0, $EF, $B0
	db $0F, $0F, $17, $1C, $2F, $39, $5E, $73, $5D, $76, $5D, $76, $BB, $EC, $BB, $EC
	db $E0, $E0, $E0, $20, $F0, $90, $78, $C8, $B8, $68, $B8, $68, $DC, $34, $DC, $34
	db $18, $18, $24, $3C, $2C, $3C, $4A, $7E, $56, $7A, $56, $7A, $56, $7A, $56, $7A
	db $00, $00, $08, $08, $1C, $14, $3E, $36, $7F, $41, $3E, $36, $18, $10, $08, $08
	db $6F, $7F, $FF, $BF, $FF, $9F, $BF, $C7, $5F, $E3, $2E, $73, $1C, $3E, $00, $1C
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $00, $00, $00, $00
	db $FE, $FB, $FE, $F3, $FA, $E7, $FA, $C7, $F4, $8E, $68, $DC, $38, $7C, $00, $38
	db $EA, $AB, $FA, $BA, $2B, $AA, $AA, $2B, $AE, $EE, $AA, $BB, $EA, $B2, $AD, $CA
	db $EA, $EB, $AC, $B8, $AB, $AA, $AB, $AB, $AE, $E2, $AE, $2A, $BA, $EB, $EE, $AA
	db $EE, $EB, $8A, $AF, $8E, $AF, $AF, $AA, $EA, $A3, $AA, $AA, $EB, $EA, $AE, $EA
	db $EE, $AA, $BA, $2A, $EE, $FB, $EA, $3A, $EA, $EB, $FB, $AB, $AB, $8A, $A8, $E2
	db $AA, $BA, $DA, $9E, $FA, $AC, $EF, $AF, $AA, $8A, $8E, $A2, $AA, $FE, $EE, $FA
	db $AE, $EE, $AA, $A2, $AB, $EB, $BE, $AA, $BF, $88, $BA, $A0, $2A, $BB, $BA, $BB
	db $BB, $EF, $8A, $FF, $AA, $AF, $BA, $FF, $A6, $AA, $AB, $8A, $BE, $AE, $EA, $B6
	db $DA, $BB, $EA, $8A, $AA, $7F, $AF, $AA, $AA, $AB, $AE, $AA, $AF, $AA, $EF, $BB
	db $E2, $A0, $B2, $AE, $8A, $A2, $A9, $AA, $6A, $22, $CA, $E2, $88, $AA, $AA, $82
	db $82, $2E, $AA, $12, $82, $0A, $AA, $FA, $8A, $82, $82, $A2, $A2, $22, $A2, $2A
	db $A3, $8A, $EA, $0A, $AA, $A0, $88, $E8, $8A, $BA, $A8, $A8, $0A, $88, $AA, $8A
	db $AA, $8A, $E8, $2B, $AA, $E2, $A8, $A2, $2A, $2A, $2A, $AA, $AA, $A8, $AA, $AA
	db $6E, $A6, $AA, $AA, $8A, $A8, $AA, $8A, $12, $2E, $AA, $A2, $8A, $88, $2A, $6A
	db $AA, $A8, $22, $A0, $AB, $AA, $AA, $20, $8A, $8A, $0A, $2D, $2A, $BA, $88, $AA
	db $8E, $AA, $A3, $A8, $22, $A2, $08, $AA, $2A, $2A, $AA, $80, $2A, $AA, $2A, $0A
	db $AA, $AA, $A0, $80, $2A, $EA, $A9, $A2, $AA, $A8, $B2, $A2, $AE, $08, $A0, $22
	db $EA, $FB, $AA, $2A, $AA, $0A, $BA, $E6, $7A, $AA, $AC, $AA, $AA, $26, $FF, $EA
	db $AA, $3E, $BA, $A2, $FA, $F6, $EB, $6A, $AE, $2A, $3E, $8B, $BB, $AB, $A2, $2E
	db $FE, $AA, $BD, $FB, $A3, $BA, $FA, $B3, $AF, $AE, $EA, $AA, $AF, $AA, $AE, $B2
	db $A2, $AB, $EF, $3A, $6A, $AF, $AA, $AB, $FB, $E3, $BB, $AA, $AB, $AB, $76, $22
	db $AA, $BE, $26, $FB, $BD, $38, $BA, $AA, $AF, $EE, $EA, $BA, $EA, $AA, $EA, $CB
	db $8E, $EF, $AE, $2B, $AA, $3F, $FA, $AA, $AE, $BB, $AA, $FA, $FA, $E2, $CA, $BF
	db $A7, $8D, $BB, $A3, $E6, $EA, $E6, $F3, $AF, $7A, $AA, $AE, $3B, $8F, $AB, $E7
	db $AB, $F2, $EA, $6C, $FB, $BB, $BE, $AA, $8B, $AE, $AA, $2A, $AB, $2E, $AA, $AE
	db $22, $21, $30, $A2, $20, $82, $62, $A2, $2A, $A2, $B0, $A2, $3B, $22, $2A, $22
	db $A2, $22, $2A, $2A, $E2, $62, $A2, $20, $A8, $A2, $A2, $28, $28, $A3, $62, $80
	db $20, $2A, $08, $9A, $28, $02, $82, $A2, $20, $29, $A0, $E2, $88, $02, $AA, $A8
	db $20, $A0, $A0, $A0, $22, $82, $28, $32, $02, $0A, $2A, $02, $22, $2A, $A2, $A0
	db $82, $A2, $22, $89, $A2, $2B, $A2, $00, $2A, $2A, $20, $22, $82, $A8, $A2, $30
	db $4A, $82, $AA, $28, $22, $AA, $81, $3A, $AF, $02, $6A, $2A, $32, $AA, $20, $8A
	db $AA, $AA, $22, $A0, $22, $82, $AC, $82, $82, $E2, $AA, $A8, $A2, $18, $80, $A2
	db $2A, $AA, $AA, $2A, $82, $20, $0A, $A0, $02, $0A, $20, $0A, $82, $EA, $A2, $52
	db $AF, $EB, $A2, $9E, $6A, $AA, $EE, $BA, $2A, $2B, $AF, $AA, $2E, $3E, $AA, $8F
	db $AA, $BB, $BA, $2B, $BA, $B9, $BB, $BB, $AA, $F3, $B6, $F2, $FA, $CA, $A3, $E3
	db $AA, $AA, $EB, $FE, $3A, $AE, $BF, $EA, $EA, $AA, $AE, $EA, $B9, $EA, $BB, $AB
	db $FB, $FA, $E3, $7A, $AA, $F7, $EB, $AF, $AB, $AE, $EE, $AF, $2B, $AE, $EA, $AA
	db $AA, $E2, $EA, $AA, $EE, $BF, $AA, $BF, $AE, $A8, $EB, $A2, $AA, $22, $AA, $2A
	db $BB, $AB, $6F, $3F, $6B, $A0, $F3, $AF, $AA, $4A, $FA, $2A, $AA, $AB, $AA, $EA
	db $E3, $FB, $32, $3A, $EA, $AE, $B2, $EF, $EA, $E2, $2A, $EA, $AB, $B6, $A7, $B3
	db $FB, $EF, $2B, $A2, $AB, $FA, $AB, $AA, $BB, $BE, $AF, $BA, $BA, $BF, $AA, $CB
	db $8A, $22, $AA, $26, $2E, $00, $20, $88, $2A, $2A, $0A, $22, $00, $80, $0A, $08
	db $A6, $22, $A9, $22, $22, $2A, $2A, $AA, $A2, $32, $6C, $B2, $8A, $0A, $2A, $08
	db $68, $00, $08, $0A, $8A, $A2, $80, $AB, $A0, $8A, $AA, $8A, $2A, $82, $A2, $20
	db $A4, $A2, $8A, $22, $22, $AA, $00, $2A, $A2, $AA, $8A, $A6, $00, $AA, $22, $BA
	db $22, $A8, $A0, $22, $22, $A0, $82, $2A, $88, $22, $A2, $A8, $21, $00, $82, $8A
	db $22, $02, $82, $42, $0A, $2A, $A0, $20, $A0, $A2, $88, $AA, $82, $AA, $22, $1A
	db $88, $28, $A2, $02, $B5, $20, $0A, $AA, $A2, $0A, $82, $0A, $A2, $C0, $29, $8A
	db $2A, $AA, $A2, $28, $8A, $A0, $A2, $A8, $26, $82, $A2, $22, $B0, $42, $A2, $9A
	db $2A, $AA, $AF, $AB, $EE, $A3, $BF, $BB, $3F, $EA, $FF, $A6, $2A, $FA, $AF, $23
	db $EB, $AA, $B2, $EE, $E7, $A9, $B2, $A2, $BF, $FB, $6A, $BE, $F3, $EB, $B2, $BE
	db $AA, $BA, $AE, $B7, $FB, $F2, $EA, $AA, $AB, $BA, $F7, $B2, $AA, $2A, $EA, $EA
	db $8A, $EE, $EA, $BE, $BB, $AE, $AB, $6E, $2F, $E2, $AE, $66, $AA, $AA, $2A, $9C
	db $8A, $EB, $AC, $E2, $FE, $FA, $2A, $3A, $AA, $22, $AE, $AB, $A2, $FE, $A3, $A6
	db $B6, $AE, $B2, $AE, $BE, $3B, $BB, $E2, $FA, $F6, $EE, $AA, $BB, $FA, $8B, $A2
	db $3F, $B6, $AB, $2A, $7A, $7A, $BE, $FC, $EA, $A3, $EA, $AB, $B4, $EF, $8A, $BA
	db $AF, $EE, $AE, $6E, $CA, $3A, $EA, $FA, $AA, $2E, $33, $A0, $2B, $BA, $AB, $8F
	db $A0, $AA, $AA, $48, $A0, $2A, $0A, $22, $A2, $2B, $A2, $88, $A0, $22, $02, $AA
	db $A9, $A3, $B2, $8A, $22, $82, $22, $60, $0A, $A0, $12, $82, $AA, $28, $88, $42
	db $22, $A0, $32, $32, $A8, $86, $A8, $02, $22, $E8, $00, $0A, $80, $AA, $82, $AB
	db $02, $AA, $0A, $02, $AA, $2A, $22, $A2, $A8, $02, $A2, $22, $01, $A2, $28, $A2
	db $A2, $A0, $22, $1D, $82, $60, $4B, $08, $E2, $A0, $22, $AA, $2A, $A0, $20, $AA
	db $2A, $20, $A0, $A3, $2A, $22, $AA, $8A, $82, $80, $0A, $28, $2A, $A2, $2A, $A2
	db $9A, $8A, $8A, $0A, $2A, $A0, $0A, $2A, $02, $A0, $88, $80, $08, $9A, $02, $A8
	db $82, $2A, $2A, $A0, $82, $68, $03, $22, $00, $A8, $0A, $0C, $A0, $AA, $AA, $A0
	db $6E, $EA, $B2, $D7, $EA, $AB, $AA, $A2, $BE, $BA, $AB, $BA, $AA, $B2, $BA, $FA
	db $AA, $AF, $2B, $AA, $AE, $B2, $AA, $EA, $AF, $AA, $AB, $BB, $EF, $8E, $FA, $AA
	db $8B, $AB, $AE, $BB, $AA, $BE, $AA, $EA, $8E, $AA, $CA, $EE, $AE, $BB, $2A, $EA
	db $AA, $BE, $FA, $A2, $AA, $AA, $AF, $AB, $AE, $BA, $EF, $A7, $B3, $76, $AB, $AA
	db $22, $BF, $FF, $AA, $BB, $BB, $FF, $FF, $AB, $AF, $FA, $BA, $AF, $AB, $2F, $AA
	db $FA, $A6, $AA, $AA, $A8, $BB, $BA, $AE, $EE, $E3, $BA, $AE, $FA, $AE, $EA, $AA
	db $EA, $BA, $2B, $FA, $AA, $AB, $FA, $AA, $AF, $FF, $EA, $3A, $EF, $BE, $BA, $8E
	db $AA, $EF, $AA, $AB, $BC, $AE, $AA, $AE, $AA, $BA, $EB, $D9, $EF, $3A, $2A, $B3
	db $A8, $AA, $29, $88, $9A, $A8, $88, $8A, $A8, $82, $28, $A8, $8A, $A8, $A2, $8A
	db $2A, $2A, $22, $A2, $BC, $9A, $3A, $AA, $80, $8A, $A9, $2A, $B8, $8A, $8A, $AA
	db $02, $A0, $8A, $AA, $AC, $0A, $A0, $22, $2A, $AA, $A2, $A2, $AA, $2E, $08, $8A
	db $20, $2A, $2A, $AA, $A8, $B1, $A2, $A0, $A8, $A8, $80, $28, $0A, $A2, $82, $A2
	db $A2, $82, $A2, $A8, $8A, $A2, $88, $A2, $28, $0A, $A2, $28, $AA, $00, $8E, $8A
	db $AA, $90, $38, $28, $22, $B8, $AA, $2A, $EA, $E2, $88, $AA, $82, $AA, $EA, $A2
	db $2A, $28, $A0, $2A, $1A, $8A, $A0, $8A, $2A, $A2, $2A, $AA, $CA, $AA, $28, $2A
	db $A8, $8A, $22, $A2, $A8, $AE, $88, $BA, $AA, $08, $80, $AA, $A8, $EA, $AA, $72
	db $BE, $FB, $E2, $AA, $FA, $BA, $AE, $AA, $EE, $DB, $EE, $A3, $AB, $AA, $69, $AE
	db $AB, $5B, $AA, $AA, $AB, $AA, $FB, $FA, $AA, $AC, $9A, $AE, $FE, $AB, $EC, $B9
	db $B9, $AA, $AE, $A2, $A3, $A9, $FB, $EA, $AB, $AA, $FB, $EF, $BA, $BF, $FB, $2A
	db $AA, $EA, $AE, $B7, $EA, $EA, $BB, $EB, $7A, $FA, $8E, $BE, $EB, $EB, $A2, $AA
	db $FA, $AA, $BE, $FC, $FE, $AA, $AE, $EA, $EF, $AE, $AA, $EA, $B8, $2B, $AA, $AE
	db $BA, $E2, $AB, $BE, $AF, $AB, $BA, $EF, $AB, $AA, $AE, $AA, $BA, $A7, $AE, $7B
	db $BA, $EA, $AB, $3B, $EA, $AF, $E7, $EA, $AD, $EF, $BA, $FB, $EB, $EF, $BB, $BB
	db $BA, $BA, $AA, $EA, $FA, $BF, $EB, $FA, $EA, $AF, $9A, $EB, $BA, $AA, $AF, $AA
	db $2A, $A8, $A8, $AA, $8A, $AA, $88, $AC, $0A, $4A, $22, $A8, $AA, $2A, $A8, $AA
	db $A2, $08, $AA, $88, $02, $8A, $33, $A2, $80, $2A, $AA, $04, $AA, $AB, $2A, $AB
	db $A2, $A8, $A0, $82, $82, $30, $A8, $BA, $A9, $82, $2A, $AD, $A0, $8A, $4A, $A0
	db $AA, $AA, $08, $A2, $2A, $B8, $AB, $A8, $A2, $8A, $BA, $8A, $EA, $AB, $A9, $82
	db $2A, $AA, $22, $AA, $3A, $22, $2A, $82, $28, $84, $AA, $AA, $A2, $0A, $8A, $20
	db $A8, $EE, $A2, $82, $20, $8A, $84, $AA, $2A, $8A, $A2, $B1, $AA, $2A, $AE, $AB
	db $A2, $AA, $66, $0A, $A8, $AA, $88, $C8, $22, $20, $28, $AE, $A9, $CF, $A8, $2A
	db $AA, $A2, $82, $02, $30, $A8, $98, $08, $AA, $A8, $20, $8A, $82, $88, $AA, $A3
	db $EA, $2E, $EA, $AB, $AB, $AA, $AF, $6A, $BE, $EA, $AA, $BA, $AA, $FB, $BB, $B2
	db $FA, $BE, $FB, $2B, $A8, $AE, $AA, $AF, $2A, $AA, $BE, $BB, $FB, $BE, $FB, $8A
	db $AE, $FF, $EB, $AA, $EB, $BA, $AE, $CA, $AA, $AF, $EA, $AF, $EE, $FB, $AF, $EE
	db $BE, $FA, $AB, $3E, $BE, $EE, $8E, $BA, $EE, $EA, $AA, $EB, $FF, $FB, $BE, $AE
	db $BB, $A2, $EA, $EA, $6B, $E9, $AA, $AB, $EE, $AB, $BE, $AA, $EA, $BE, $2A, $2F
	db $AA, $8F, $AB, $AA, $AA, $AA, $E2, $2A, $BA, $9F, $FB, $FE, $BB, $A2, $AA, $AA
	db $CF, $EE, $AA, $AB, $9E, $AE, $FE, $FA, $BA, $EB, $A8, $A7, $BF, $AA, $AB, $AB
	db $AE, $BA, $BB, $AB, $AA, $88, $BB, $3A, $AA, $AA, $6A, $AA, $A7, $F7, $BE, $BE
	db $AA, $AA, $A8, $B2, $AE, $AA, $2A, $0A, $28, $23, $AD, $AA, $A8, $A2, $84, $AA
	db $AA, $AA, $80, $A0, $08, $A2, $80, $A8, $22, $AE, $8A, $AA, $AA, $B2, $A2, $2A
	db $88, $8A, $82, $0A, $A0, $A2, $08, $A8, $A8, $AA, $A2, $2A, $2A, $8A, $22, $EA
	db $A2, $A0, $B2, $AA, $86, $AA, $22, $28, $A0, $AA, $A0, $82, $0A, $A2, $6E, $EA
	db $82, $A2, $8A, $AA, $09, $28, $A6, $82, $88, $AA, $C8, $22, $8A, $82, $A0, $2A
	db $88, $AA, $AA, $AA, $AA, $28, $2A, $AA, $A0, $AA, $87, $A1, $86, $AA, $9A, $AA
	db $EA, $AA, $28, $88, $A3, $0A, $AB, $2A, $A0, $88, $A2, $2A, $2A, $AA, $8A, $2A
	db $A8, $88, $AE, $A8, $EA, $AA, $AA, $BA, $AA, $E3, $AA, $22, $AA, $AA, $88, $08
	db $AA, $EE, $EA, $EA, $AA, $BA, $AB, $AA, $BE, $AA, $AB, $AA, $EA, $AA, $AA, $3B
	db $FF, $BA, $AA, $BE, $EA, $63, $AB, $AE, $AE, $AF, $AB, $AA, $DA, $BB, $EA, $AA
	db $AB, $EF, $BB, $AA, $BA, $BB, $AF, $FC, $EA, $AA, $2B, $BE, $AB, $BF, $FA, $BA
	db $BA, $BA, $BF, $EE, $A2, $BB, $BA, $F2, $BF, $EE, $AA, $AB, $BB, $EB, $EF, $AB
	db $EA, $AA, $AB, $EB, $BA, $EA, $BF, $BE, $BA, $E3, $AA, $FF, $BA, $AF, $B8, $B2
	db $EF, $AA, $BA, $AB, $AF, $A6, $DF, $BA, $6A, $AA, $BA, $AA, $AB, $AA, $E6, $BC
	db $E8, $BA, $AA, $AA, $AB, $AA, $BB, $AA, $BE, $EA, $AF, $AE, $EB, $CB, $FF, $FE
	db $BA, $AA, $AA, $E9, $EA, $FE, $B9, $AA, $0A, $AB, $EF, $2A, $72, $B7, $AF, $AA
	db $33, $BA, $02, $AA, $28, $AA, $A2, $AE, $22, $08, $80, $2B, $86, $28, $22, $AA
	db $A2, $EA, $8A, $AA, $07, $2A, $00, $28, $A2, $A8, $CA, $0A, $A8, $28, $8A, $08
	db $22, $BA, $4A, $0A, $BA, $9A, $B2, $A2, $AB, $8E, $0B, $AA, $08, $A2, $DB, $AB
	db $8A, $22, $A2, $A8, $AA, $82, $2E, $3A, $AA, $CA, $AA, $AA, $28, $AA, $80, $AA
	db $A2, $28, $28, $AA, $88, $AA, $28, $BA, $82, $A4, $2B, $2A, $88, $AA, $88, $2A
	db $A8, $2A, $AA, $A8, $8B, $AA, $AA, $A2, $0A, $0A, $A8, $B8, $1A, $AA, $88, $A8
	db $AE, $DB, $AA, $2A, $BA, $22, $A8, $2A, $AA, $82, $26, $AA, $A2, $AA, $A2, $0A
	db $AA, $C2, $A2, $AA, $98, $A2, $AA, $A8, $2A, $8A, $08, $3A, $25, $2A, $88, $32
	db $BB, $A8, $BA, $2B, $FE, $B3, $AE, $AA, $9B, $EA, $BA, $EA, $AB, $2A, $AB, $AD
	db $E2, $E8, $AA, $BE, $66, $AC, $EA, $FE, $AB, $AB, $FB, $FA, $EA, $EB, $BA, $AB
	db $EE, $8B, $BA, $AA, $AE, $EB, $BB, $AA, $FB, $EF, $EE, $AA, $BA, $A8, $AE, $37
	db $AB, $EA, $AA, $BE, $8A, $AF, $AB, $AB, $AB, $2B, $FB, $BA, $BF, $A8, $FE, $AD
	db $EA, $AB, $FB, $FA, $BA, $2E, $AA, $AA, $AB, $AF, $AA, $BE, $EA, $2A, $FE, $AA
	db $F6, $AB, $EB, $EB, $A8, $EA, $AA, $FB, $AA, $EA, $AF, $BA, $EB, $EB, $CE, $EB
	db $FA, $BA, $FA, $AE, $A7, $FE, $AB, $AA, $EA, $2F, $2A, $FB, $BA, $FA, $E8, $AB
	db $FB, $CA, $6A, $EB, $AF, $FF, $AE, $BA, $AA, $F2, $2A, $2A, $AB, $AE, $AA, $AE
	db $E2, $8A, $B8, $82, $A2, $2A, $28, $82, $AA, $E2, $AA, $A2, $AE, $AA, $A8, $82
	db $AA, $2A, $AA, $8E, $AA, $2C, $40, $A2, $AE, $02, $A8, $6E, $08, $AA, $2A, $22
	db $02, $AA, $AA, $A0, $28, $C0, $08, $AA, $8A, $A8, $8B, $8A, $A2, $AA, $A0, $AA
	db $A8, $A9, $A8, $AA, $A8, $AA, $AA, $A8, $2A, $22, $2A, $8A, $AA, $AA, $2A, $6A
	db $0A, $E2, $EA, $A2, $22, $AA, $2A, $AA, $A2, $2A, $A8, $28, $26, $1A, $9A, $28
	db $A3, $AB, $2A, $86, $EA, $B6, $A0, $A8, $A2, $A8, $AA, $AA, $A0, $AA, $0A, $A8
	db $28, $02, $2A, $88, $AA, $0E, $AA, $80, $EA, $AA, $8A, $AA, $AA, $E2, $8A, $A8
	db $A8, $28, $E2, $2A, $8A, $2A, $88, $88, $AE, $02, $AA, $88, $A0, $28, $A8, $28
	db $BA, $AC, $AA, $FA, $AC, $EE, $AA, $AC, $98, $EE, $AA, $EA, $AA, $2F, $FF, $AF
	db $AF, $CA, $FF, $BE, $AB, $AA, $EB, $CB, $FA, $EE, $BB, $BB, $AA, $9B, $BF, $AA
	db $EE, $CF, $AA, $AB, $BF, $23, $EE, $DA, $AB, $BA, $AA, $BC, $AA, $F8, $AA, $2A
	db $A8, $AD, $EA, $EB, $FA, $EF, $BA, $DB, $AA, $AA, $AA, $EB, $EA, $FE, $FF, $EB
	db $92, $E3, $AA, $AF, $CE, $AB, $C9, $9E, $AA, $AA, $EE, $BE, $AA, $AE, $EE, $FA
	db $AE, $BB, $BB, $3A, $FE, $FE, $AA, $AB, $EA, $A6, $AA, $3B, $AA, $AC, $EA, $FB
	db $F3, $A2, $BE, $BA, $AE, $FA, $FF, $BA, $8E, $EA, $A8, $A6, $AA, $AB, $FA, $0A
	db $AF, $AB, $EA, $EA, $8A, $BE, $EE, $CA, $BE, $AF, $EA, $EA, $9F, $EB, $BB, $EE
	db $AA, $A2, $AA, $89, $89, $2A, $82, $AA, $22, $A2, $AA, $88, $22, $28, $AA, $82
	db $2A, $A8, $AA, $2A, $8A, $AB, $2A, $A8, $08, $AA, $AA, $AA, $8A, $8A, $A8, $02
	db $82, $B2, $28, $28, $C8, $AE, $AA, $8A, $A0, $EA, $8A, $2A, $00, $AA, $82, $A2
	db $AE, $A2, $22, $AA, $AB, $A9, $AA, $82, $AA, $AA, $AA, $AA, $AA, $EA, $EA, $AA
	db $2A, $20, $20, $A8, $88, $A8, $A8, $AE, $2A, $2A, $20, $02, $23, $AA, $68, $2A
	db $AA, $AA, $02, $20, $EA, $20, $C2, $6A, $AA, $20, $A0, $A1, $2D, $AA, $AE, $AA
	db $AA, $AA, $AA, $AA, $02, $AA, $CA, $20, $22, $AC, $AA, $A2, $42, $2A, $AA, $AA
	db $38, $91, $AA, $AC, $AA, $AA, $AA, $AA, $AA, $AA, $AB, $20, $A2, $AA, $2E, $29
	db $AA, $AC, $AE, $FA, $AE, $EE, $AF, $FB, $AB, $AE, $BB, $AB, $EF, $FE, $82, $BB
	db $7E, $AE, $8A, $EE, $BA, $FD, $64, $BE, $A3, $EA, $AB, $AB, $EF, $AA, $AB, $BA
	db $EE, $EC, $FA, $AA, $BF, $D4, $BE, $AB, $BB, $EA, $AE, $EB, $B2, $EB, $EB, $EA
	db $AA, $A2, $FA, $AA, $AB, $EF, $BE, $F8, $EA, $FE, $AF, $AB, $BF, $AA, $2A, $AA
	db $AA, $8A, $AA, $AF, $EE, $BF, $AB, $AB, $FB, $BF, $AE, $FA, $AA, $E2, $BE, $BA
	db $BB, $EA, $AE, $AE, $AA, $A8, $EE, $FA, $BE, $9A, $BB, $A7, $EA, $AF, $BE, $BA
	db $EA, $AA, $FA, $BF, $C8, $FF, $EA, $BA, $BA, $BB, $AB, $BB, $AB, $FC, $AA, $BA
	db $AE, $EA, $2A, $EA, $6A, $66, $BB, $AA, $AA, $EE, $AF, $EE, $BB, $BC, $AA, $B8
	db $28, $28, $AA, $AA, $A2, $A2, $8A, $08, $08, $AA, $2A, $92, $2A, $8A, $8A, $AA
	db $40, $8A, $A2, $00, $E2, $0A, $A8, $82, $02, $A2, $2A, $BA, $AA, $08, $80, $A2
	db $A8, $A8, $20, $A8, $2A, $AA, $A8, $2B, $A0, $AA, $8A, $82, $2A, $2A, $A8, $EA
	db $A8, $AE, $AA, $0A, $8A, $B2, $2A, $A8, $8A, $A7, $22, $80, $80, $AA, $2A, $CE
	db $AA, $AA, $A8, $BA, $AA, $20, $6B, $C8, $02, $AA, $AA, $2A, $A2, $C0, $A0, $8A
	db $A2, $20, $2A, $82, $0A, $AA, $AA, $A8, $A8, $A2, $A8, $28, $AA, $0E, $20, $A2
	db $28, $8A, $29, $A4, $80, $8A, $AA, $8E, $A9, $FA, $2B, $2A, $6A, $A2, $08, $88
	db $AA, $2A, $8A, $A8, $A0, $AA, $AC, $82, $A0, $AA, $20, $A1, $8A, $8A, $B2, $83
	db $FA, $EE, $AE, $BB, $AE, $A6, $AA, $AA, $ED, $EE, $AA, $AE, $AA, $AA, $FB, $AA
	db $2F, $AE, $FB, $3E, $FA, $EE, $AE, $EE, $AF, $AB, $AB, $EF, $FA, $EA, $2A, $2A
	db $AA, $EF, $BA, $FF, $AB, $EB, $A8, $AA, $EB, $EB, $AA, $AA, $EC, $AB, $BE, $A9
	db $EB, $EE, $AB, $EB, $AB, $AB, $EB, $AA, $BE, $EE, $AE, $AB, $EF, $EB, $AE, $BA
	db $EB, $AE, $3A, $B9, $BA, $AA, $AA, $AA, $EA, $BF, $A9, $EE, $AA, $BC, $A3, $A8
	db $AB, $28, $EF, $AA, $BA, $AB, $EA, $7A, $AE, $FA, $F8, $BB, $AE, $EA, $9A, $CA
	db $EA, $AA, $2A, $AF, $EA, $CE, $BE, $BF, $AA, $FB, $BA, $AE, $AA, $BA, $2B, $AA
	db $A6, $EA, $BE, $BB, $FA, $EA, $EF, $BA, $AC, $AA, $AF, $AA, $AA, $AA, $BB, $EA
	db $22, $88, $AA, $AA, $82, $A2, $A2, $2A, $88, $A2, $EA, $AA, $80, $0A, $00, $3A
	db $AE, $A8, $0A, $AA, $AA, $A8, $A8, $AA, $AA, $A0, $FD, $20, $2B, $26, $00, $A8
	db $2A, $A0, $AA, $A4, $02, $A8, $28, $28, $00, $8A, $AA, $8A, $02, $AA, $98, $BA
	db $4B, $A2, $80, $2B, $AE, $80, $AE, $A6, $A3, $80, $A6, $AA, $08, $2A, $A2, $A0
	db $E2, $0B, $22, $A8, $EA, $AA, $A3, $22, $80, $AA, $2A, $8A, $2A, $82, $A8, $E8
	db $A8, $AA, $80, $00, $82, $AA, $A8, $0A, $AA, $AB, $2A, $80, $AA, $2A, $EE, $03
	db $08, $28, $28, $38, $08, $8A, $28, $AA, $80, $3A, $8A, $B8, $82, $0A, $98, $A0
	db $AA, $AA, $AA, $AA, $2A, $00, $A0, $28, $22, $A2, $2A, $8E, $28, $8A, $B8, $5B
	db $AA, $AA, $EA, $22, $A2, $AA, $CE, $AA, $AA, $FA, $EE, $6A, $BE, $AA, $AF, $AE
	db $8E, $2A, $AA, $7E, $AE, $EA, $EA, $AA, $AE, $FE, $BA, $AE, $AA, $FA, $EE, $8A
	db $BE, $EF, $AA, $BA, $AA, $AB, $EA, $AA, $AA, $E4, $AA, $AA, $AA, $AE, $EA, $EA
	db $2E, $BE, $AA, $8E, $A2, $EB, $FA, $EA, $AB, $EA, $EE, $AA, $AA, $CE, $6A, $AE
	db $EA, $BA, $A3, $AA, $AA, $AA, $AA, $AA, $EA, $AA, $FA, $CA, $AA, $AE, $BA, $8F
	db $EB, $2E, $AB, $AA, $EA, $AE, $AA, $AA, $AB, $FE, $EA, $AE, $AF, $A8, $EF, $AE
	db $AE, $AE, $AA, $EC, $EE, $AA, $2B, $AA, $AA, $8A, $AA, $BE, $AA, $EE, $EA, $EA
	db $AA, $AE, $AA, $EA, $AF, $AA, $AA, $EE, $2E, $AE, $AE, $AB, $8A, $EA, $EA, $B8
	db $0A, $EA, $20, $88, $80, $8A, $AA, $A2, $A8, $B2, $A8, $28, $A8, $AA, $08, $8A
	db $22, $22, $08, $A8, $88, $A2, $28, $AA, $A0, $AA, $22, $8A, $0A, $AA, $AA, $AA
	db $A8, $8A, $AA, $82, $A2, $8E, $A2, $28, $80, $0C, $2A, $8A, $A8, $A8, $8A, $8A
	db $22, $E2, $64, $AA, $88, $AA, $82, $A8, $20, $AB, $08, $2A, $A2, $AA, $2A, $AA
	db $A8, $A8, $8A, $18, $2A, $A8, $8A, $82, $8A, $88, $AA, $68, $A8, $A2, $CA, $2A
	db $82, $A8, $A8, $2A, $A2, $E2, $A4, $2A, $2A, $E2, $8A, $AA, $80, $A2, $24, $28
	db $AA, $28, $88, $8A, $2A, $AA, $2A, $A2, $A8, $98, $8C, $8A, $AA, $88, $20, $8A
	db $A8, $2A, $A8, $AA, $0A, $0A, $6A, $8A, $A0, $82, $22, $82, $0A, $A2, $A0, $04
	db $AA, $BA, $EE, $AE, $BA, $AE, $AA, $FE, $AE, $AE, $EA, $AA, $AA, $EA, $AA, $AC
	db $EE, $EE, $E6, $AE, $E8, $AC, $AA, $FE, $AF, $A8, $AA, $BA, $A8, $6A, $7A, $2E
	db $AE, $EB, $AA, $AB, $EA, $AE, $EA, $AA, $EA, $AC, $BE, $AF, $BA, $DA, $8A, $AA
	db $AA, $AA, $AA, $AC, $EA, $AA, $AE, $AA, $AF, $8E, $2A, $AE, $EB, $EA, $BA, $A0
	db $EA, $AA, $AA, $B3, $EB, $AA, $AE, $6E, $AA, $EA, $EA, $EE, $AA, $AE, $AE, $AA
	db $A8, $FA, $B8, $AA, $CE, $AA, $AA, $6A, $FA, $EA, $EB, $AA, $EA, $AA, $B3, $AA
	db $AE, $AE, $CA, $EA, $2B, $AE, $AA, $AA, $AA, $AB, $AA, $EA, $AE, $AA, $AA, $8B
	db $EE, $EA, $EE, $AE, $AA, $EA, $86, $AA, $AA, $AE, $AA, $AA, $AE, $FA, $FA, $AA
	db $A0, $CC, $A3, $02, $AA, $A2, $88, $A8, $AA, $00, $8A, $24, $A8, $AA, $A0, $82
	db $8A, $AA, $A2, $AA, $A2, $AA, $0A, $AA, $AA, $A8, $80, $AA, $EE, $92, $AA, $2A
	db $AA, $EA, $10, $AB, $AA, $82, $E0, $AA, $68, $20, $12, $AC, $08, $AA, $2A, $AA
	db $A0, $AA, $02, $AA, $28, $A2, $28, $82, $A8, $08, $A2, $AA, $2A, $22, $82, $8A
	db $EE, $88, $88, $EA, $AA, $28, $08, $22, $A2, $A8, $A0, $2A, $AA, $20, $A8, $EA
	db $02, $08, $A2, $AA, $A8, $AA, $A8, $AA, $00, $AB, $A2, $AA, $E8, $20, $AA, $80
	db $A8, $00, $AA, $88, $A8, $08, $A2, $08, $2E, $A0, $A8, $2A, $A8, $0A, $A2, $8A
	db $88, $F8, $AC, $8A, $A2, $AA, $8A, $80, $AA, $24, $EA, $A8, $02, $AA, $22, $60
	db $AA, $AA, $BA, $EA, $AA, $E6, $EE, $A2, $EA, $AE, $AA, $AA, $AA, $A6, $AA, $FE
	db $AF, $EA, $AE, $AA, $AA, $AE, $EA, $8A, $AA, $EA, $A9, $EA, $A6, $AA, $AA, $AA
	db $EE, $FA, $BE, $AA, $AF, $EB, $E2, $E2, $AE, $AA, $EA, $AE, $AA, $EA, $AA, $EB
	db $AA, $AC, $EA, $AA, $A2, $BE, $EE, $AA, $E8, $EB, $EA, $2A, $AA, $8E, $AE, $BA
	db $AA, $A8, $EA, $AA, $AE, $AF, $AA, $E6, $BA, $EA, $AA, $AE, $EE, $AE, $AA, $AA
	db $EA, $8A, $AB, $EA, $AA, $B8, $6A, $AA, $22, $AA, $AB, $EE, $AE, $F8, $AA, $AE
	db $AA, $AA, $AA, $AE, $AA, $AA, $EA, $A3, $FA, $FE, $AA, $AB, $AC, $EA, $FA, $EA
	db $2E, $EA, $AA, $AA, $A8, $AE, $AE, $AA, $AB, $EE, $AB, $AE, $AE, $EE, $EA, $A2
	db $A8, $A8, $AA, $AE, $82, $A2, $0A, $2A, $A8, $20, $A0, $82, $8A, $A0, $A8, $AA
	db $A2, $A0, $8B, $88, $A8, $AA, $AA, $A8, $2A, $A2, $22, $A4, $2A, $A2, $AA, $A2
	db $A8, $8A, $E0, $A8, $A0, $8A, $A8, $22, $A4, $2A, $A2, $A2, $A2, $A0, $20, $88
	db $AA, $AA, $C2, $A8, $2A, $A2, $8A, $08, $AA, $28, $8A, $AA, $A2, $8A, $82, $22
	db $8A, $88, $A8, $8A, $AE, $28, $A8, $A8, $02, $8A, $A8, $2A, $AA, $AA, $2A, $88
	db $A8, $20, $8A, $88, $2A, $AA, $AA, $A8, $AE, $AA, $22, $A2, $8A, $A2, $AA, $AA
	db $A2, $22, $28, $AA, $AA, $22, $A2, $22, $A2, $00, $88, $A2, $20, $86, $0A, $08
	db $A2, $6A, $2E, $E2, $A2, $AA, $AA, $AA, $AA, $8A, $AA, $AA, $0A, $AE, $AA, $08
	db $EA, $AA, $BA, $2E, $EA, $EE, $6A, $BA, $FA, $DA, $BA, $BA, $FA, $A8, $A7, $AA
	db $EF, $9F, $BB, $FA, $EA, $A3, $AE, $2A, $AA, $EC, $AE, $EA, $AA, $AA, $EA, $FA
	db $EB, $AA, $2F, $AA, $BA, $B3, $8E, $EA, $EA, $BA, $2A, $FA, $FB, $EA, $EA, $AA
	db $AB, $8A, $EA, $BE, $AA, $FA, $BE, $AA, $BA, $AA, $8A, $2A, $AA, $E6, $AA, $F3
	db $AA, $AA, $AA, $AB, $6E, $AF, $7B, $AA, $AE, $FA, $AA, $AA, $BE, $FA, $EB, $BA
	db $AB, $AA, $AD, $2E, $BA, $AB, $A2, $AB, $AA, $A8, $8C, $AB, $E9, $AE, $FF, $A3
	db $AE, $BE, $AA, $FB, $BA, $AB, $FB, $FE, $9A, $BB, $FB, $AA, $AB, $BA, $BA, $AA
	db $AA, $EE, $EA, $EA, $EE, $A2, $EF, $EE, $BA, $AB, $AA, $AE, $8A, $2E, $EA, $AE
	db $28, $AA, $2A, $02, $08, $AA, $CA, $A0, $20, $AA, $8A, $A2, $A0, $A8, $20, $AC
	db $8A, $2A, $AA, $2A, $A8, $AA, $AA, $28, $A3, $82, $A6, $88, $A2, $A2, $38, $A2
	db $82, $40, $28, $02, $8A, $2A, $0B, $C8, $A2, $8A, $A8, $EA, $AA, $26, $8A, $2A
	db $88, $2A, $A8, $AA, $6A, $88, $2A, $8A, $82, $88, $A2, $2E, $AA, $AE, $AA, $AA
	db $08, $A8, $06, $82, $AA, $B2, $22, $AA, $8A, $C8, $AA, $6E, $A8, $A0, $A8, $E9
	db $00, $2A, $AA, $AB, $E8, $A8, $AA, $A2, $0A, $AA, $AA, $AA, $28, $A2, $AA, $82
	db $80, $20, $A2, $2A, $8C, $A9, $8A, $82, $A8, $22, $AA, $BA, $28, $AA, $A8, $AA
	db $80, $79, $AA, $E3, $A8, $A2, $AA, $E8, $A8, $8A, $AA, $AA, $AA, $AA, $82, $00
