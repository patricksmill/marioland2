SECTION "bank00", ROM0

;rst $00
	jp Init

;unused filler
	db $00, $00, $00, $00, $00

;rst $08
	jp Init

;unused filler (rst $10/$18/$20 included; never used)
	db $80, $1B, $9B, $10, $80, $83, $28, $E2, $A2, $1A, $28, $02, $07, $40, $20, $C2
	db $AC, $BA, $33, $AE, $02, $80, $21, $88, $8A, $28, $08, $63, $3A

;rst $28: jump table dispatch.
;Usage: a = index, then rst $28 followed directly by a table of dw targets.
;The rst pushes the address of the table as its return address; this pops
;it, adds a * 2 and jumps to the word stored there. The return address is
;consumed, so the selected handler's ret returns to the caller's caller.
;Clobbers a, de and hl. Indices must be < $80 (add a drops the carry).
;Bank $00 call site: UnknownCall_0x02AD (game state $FF9B, table UnknownData_0x02B0).
	add a
	pop hl
	ld e, a
	ld d, 0
	add hl, de
	ld e, [hl]
	inc hl
	ld d, [hl]
	push de
	pop hl
	jp hl

UnknownData_0x0034:
;unused filler (rst $30/$38 included; never used)
	db $44, $0A, $0A, $26, $41, $8A, $AA, $28, $00, $22, $2A, $CA

;VBlank interrupt vector
	jp VBlank

UnknownData_0x0043:
;unused filler
	db $F9, $C4, $32, $09, $22

;LCD STAT interrupt vector
	jp STATInterrupt

;unused filler
	db $40, $21, $22, $84, $40

;timer interrupt vector
	jp UnknownJump_0x0347

;unused filler
	db $80, $20, $C2, $00, $88

;serial interrupt vector
	jp UnknownJump_0x0153

;unused filler (joypad vector $0060 included; never enabled)
	db $80, $20, $2B, $8A, $A0, $AE, $4C, $80, $A6, $81, $E0, $69, $8A, $6A, $88, $68
	db $07, $04, $A8, $0E, $82, $72, $1A, $1A, $AA, $3D, $12, $A8, $C8, $AA, $AA, $50
	db $82, $8A, $02, $64, $88, $FE, $6F, $A8, $AF, $FD, $E8, $EE, $FF, $F9, $6A, $5F
	db $EB, $EF, $EE, $B6, $EE, $AF, $EF, $7E, $AB, $FA, $6B, $E7, $B8, $72, $8E, $BE
	db $E8, $CC, $EE, $F2, $B9, $8E, $FD, $6E, $E7, $CE, $FA, $BE, $F3, $BB, $E8, $FB
	db $AA, $9E, $AB, $93, $5B, $D8, $BA, $9D, $BD, $AD, $2E, $FC, $BE, $BE, $F7, $EE
	db $EA, $EF, $EB, $AF, $EC, $EF, $83, $CF, $BE, $CF, $E9, $6E, $B3, $FB, $A4, $B9
	db $A7, $A2, $4D, $BB, $B7, $EE, $AF, $EB, $F2, $A9, $CB, $5E, $EE, $BC, $FE, $A6
	db $BA, $DE, $E6, $A9, $A7, $6F, $AF, $9F, $FA, $B5, $BF, $DC, $EA, $BD, $6D, $5A
	db $6E, $EE, $EB, $DE, $FF, $B9, $AB, $F2, $FB, $EF, $FA, $AB, $EA, $CE, $EA, $FE
	db $FE, $E3, $9F, $BF, $EB

	nop
	jp Start

SECTION "Header", ROM0[$134]
	db $4D, $41, $52, $49, $4F, $4C, $41, $4E, $44, $32, $00, $00, $00, $00, $00 ;MARIOLAND2
	db $00 ;Monochrome GameBoy
	db $00, $00 ;New Licence
	db $00 ;No Super GameBoy
	db $03 ;MBC1+RAM+Battery
	db $04 ;Rom size 512KB
	db $02 ;Ram size 8KB
	db $01 ;Non japanese
	db $01 ;No Super GameBoy
	db $00 ;Mask Rom Version

SECTION "Home", ROM0[$150]


Start: ;$0150
	jp Init

UnknownJump_0x0153: ;serial interrupt handler (vector $0058)
	reti


VBlank: ;$0154
	di
	push af
	push bc
	push de
	push hl
	ld a, [sScrollY]
	ldh [rSCY], a
	ld a, [sScrollX]
	ldh [rSCX], a
	ld a, [sBGPalette]
	ldh [rBGP], a
	ld a, [sOAMPalette1]
	ldh [rOBP0], a
	ld a, [sOAMPalette2]
	ldh [rOBP1], a
	ld a, [sFadeTimerLow]
	sub 1
	ld [sFadeTimerLow], a
	ld a, [sFadeTimerHigh]
	sbc 0
	ld [sFadeTimerHigh], a
	jr nc, UnknownRJump_0x018B
	xor a
	ld [sFadeTimerLow], a
	ld [sFadeTimerHigh], a

UnknownRJump_0x018B:
	ld a, [sRowShiftIndex]
	and a
	jp nz, UnknownJump_0x2A4D
	ldh a, [$FF9B]
	cp $0C
	jp z, UnknownJump_0x2C18
	ld a, [sVRAMTransferActive]
	and a
	jp nz, UnknownJump_0x26D7
	ldh a, [$FF9B]
	cp $13
	jp z, UnknownJump_0x2CA3
	ld a, [sSceneId]
	and a
	jp nz, UnknownJump_0x26C3
	ld a, [$AA01]
	and a
	jr z, UnknownRJump_0x01BF
	ld a, [sLevelBank] ;prepare bank switch
	ld [$2100], a
	call ScrollLevelMap
	jr UnknownRJump_0x01C5

UnknownRJump_0x01BF:
	call UnknownCall_0x3873
	call UnknownCall_0x076B

UnknownJump_0x01C5:
UnknownRJump_0x01C5:
	call $FFA0
	ldh a, [$FF9B]
	cp $04
	call z, UpdateSound
	ldh a, [$FF9B]
	cp $18
	call z, UpdateSound
	ld a, [sCurROMBank] ;prepare bank switch
	ld [$2100], a
	ld a, 1
	ldh [$FF82], a
	pop hl
	pop de
	pop bc
	pop af
	reti

Init: ;$01E5
	ld a, 1
	di
	ldh [rIF], a
	ldh [rIE], a
	xor a
	ldh [rSCY], a
	ldh [rSCX], a
	ldh [rSTAT], a
	ldh [rSB], a
	ldh [rSC], a
	ld a, 128
	ldh [rLCDC], a

.wait
	ldh a, [rLY]
	cp $94
	jr nz, .wait
	ld a, 3
	ldh [rLCDC], a
	ld sp, $A8FF
	ld a, 10
	ld [$0000], a
	xor a
	ld hl, $DFFF
	ld c, 63
	ld b, 0

UnknownRJump_0x0215:
	ld [hld], a
	dec b
	jr nz, UnknownRJump_0x0215
	dec c
	jr nz, UnknownRJump_0x0215
	ld hl, $FEFF
	ld b, 0

UnknownRJump_0x0221:
	ld [hld], a
	dec b
	jr nz, UnknownRJump_0x0221
	ld hl, $FFFE
	ld b, 128

UnknownRJump_0x022A:
	ld [hld], a
	dec b
	jr nz, UnknownRJump_0x022A
	ld a, 147
	ld [sBGPalette], a
	ld a, 208
	ld [sOAMPalette1], a
	ld a, 56
	ld [sOAMPalette2], a
	ld c, 160
	ld b, 10
	ld hl, OAMDMARoutine

UnknownRJump_0x0244:
	ld a, [hli]
	ld [$FF00+c], a
	inc c
	dec b
	jr nz, UnknownRJump_0x0244
	call BlankBGMap1
	ld a, 1
	ldh [rIE], a
	ld a, 7
	ldh [rWX], a
	ld a, 128
	ldh [rLCDC], a
	ei
	xor a
	ldh [rIF], a
	ldh [rWY], a
	ldh [rTMA], a
	call UnknownCall_0x207D

UnknownJump_0x0264:
	xor a
	ld [$AA01], a
	ld a, [sScreenTransition]
	and a
	jr nz, UnknownRJump_0x0279
	ld a, [sBossFightPhase]
	cp $03
	call nz, ReadJoypad
	call UnknownCall_0x38B9

UnknownRJump_0x0279:
	call UnknownCall_0x02AD
	ldh a, [$FF9B]
	cp $04
	jr z, UnknownRJump_0x028D
	cp $18
	jr z, UnknownRJump_0x028D
	cp $13
	jr z, UnknownRJump_0x028D
	call UpdateSound

UnknownRJump_0x028D:
	call UnknownCall_0x20A4
	ldh a, [hKeysHeld]
	and $0F
	cp $0F
	jp z, UnknownJump_0x029F
	call UnknownCall_0x02FF
	jp UnknownJump_0x0264

UnknownJump_0x029F: ;soft reset (A+B+Start+Select held)
	ld a, 4 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x1002D
	jp Init


UnknownCall_0x02AD: ;run the handler for the current game state $FF9B
	ldh a, [$FF9B]
	rst $28 ;jump through the table below (never returns here)

UnknownData_0x02B0: ;rst $28 jump table for UnknownCall_0x02AD, indexed by game state $FF9B
	dw UnknownJump_0x2CC4 ;$00
	dw UnknownJump_0x2CDB ;$01
	dw UnknownJump_0x03F1 ;$02
	dw UnknownJump_0x04F1 ;$03
	dw UnknownJump_0x05D5 ;$04
	dw UnknownJump_0x27AF ;$05
	dw UnknownJump_0x02FE ;$06
	dw UnknownJump_0x287E ;$07
	dw UnknownJump_0x2756 ;$08
	dw UnknownJump_0x311A ;$09
	dw UnknownJump_0x02FE ;$0A
	dw UnknownJump_0x2CE9 ;$0B
	dw UnknownJump_0x2C2E ;$0C
	dw UnknownJump_0x02FE ;$0D
	dw UnknownJump_0x02FE ;$0E
	dw UnknownJump_0x02FE ;$0F
	dw UnknownJump_0x2974 ;$10
	dw UnknownJump_0x29CA ;$11
	dw UnknownJump_0x2CAE ;$12
	dw UnknownJump_0x2CB9 ;$13
	dw UnknownJump_0x2C23 ;$14
	dw UnknownJump_0x353E ;$15
	dw UnknownJump_0x3573 ;$16
	dw UnknownJump_0x35CD ;$17
	dw UnknownJump_0x3547 ;$18
	dw UnknownJump_0x2BE5 ;$19
	dw UnknownJump_0x2BF0 ;$1A
	dw UnknownJump_0x2AD3 ;$1B
	dw UnknownJump_0x2ADE ;$1C
	dw UnknownJump_0x2AD3 ;$1D
	dw UnknownJump_0x2AE9 ;$1E
	dw UnknownJump_0x2AF4 ;$1F
	dw UnknownJump_0x2A80 ;$20
	dw UnknownJump_0x2A8B ;$21
	dw UnknownJump_0x2C98 ;$22
	dw UnknownJump_0x03AF ;$23

UnknownCall_0x02F8: ;advance to the next game state ($FF9B)
	ldh a, [$FF9B]
	inc a
	ldh [$FF9B], a
	ret

UnknownJump_0x02FE: ;game state no-op handler
	ret


UnknownCall_0x02FF:
	db $76 ;halt (rgbds adds a nop after)

UnknownRJump_0x0300:
	ldh a, [$FF82]
	and a
	jr z, UnknownRJump_0x0300
	ldh a, [$FF97]
	inc a
	ldh [$FF97], a
	ld a, [sTileAnimTimer]
	inc a
	ld [sTileAnimTimer], a
	xor a
	ldh [$FF82], a
	ld a, 192
	ldh [$FF8C], a
	xor a
	ldh [$FF8D], a
	ret

UnknownCall_0x031C:
	xor a
	ld hl, $C000
	ld b, 160

UnknownRJump_0x0322:
	ld [hli], a
	dec b
	jr nz, UnknownRJump_0x0322
	ret

BlankBGMap1: ;$0327
	ld hl, $9FFF
	ld bc, $0800

.continue
	ld a, 255
	ld [hld], a
	dec bc
	ld a, b
	or c
	jr nz, .continue
	ret

CopyMem: ;$0336 copies bc bytes from hl to de.
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, CopyMem
	ret

UnknownCall_0x033F: ;copies bytes from de to hl until a $FF terminator
	ld a, [de]
	cp $FF
	ret z
	ld [hli], a
	inc de
	jr UnknownCall_0x033F

UnknownJump_0x0347: ;timer interrupt handler (vector $0050)
	reti


DisableVBlank: ;$0348
	ldh a, [rIE]
	ldh [$FF99], a
	res 0, a
	ldh [rIE], a

UnknownRJump_0x0350:
	ldh a, [rLY]
	cp $91
	jr nz, UnknownRJump_0x0350
	ldh a, [rLCDC]
	and $7F
	ldh [rLCDC], a
	ldh a, [$FF99]
	ldh [rIE], a
	ret

UnknownCall_0x0361:
	ld hl, $42F0
	ld a, [sLevelLayoutIndex]
	and $0F
	sla a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, $0000
	ld a, 10
	ld [hl], a ;enable SRAM
	ld h, 64
	ld a, 0
	ld [hl], a ;Ram Bank 0
	ld h, 96
	ld a, 1
	ld [hl], a ;Ram Banking mode
	ld hl, $B000

Read_Level_Data: ;$0386
	ld a, [de]
	inc de
	bit 7, a
	jr nz, .compressed
	ld [hli], a
	ld a, l
	or a
	jr z, .checkRAMbounds
	jr Read_Level_Data

.compressed
	and $7F
	ld [hli], a
	ld c, a
	ld a, l
	or a
	jr z, .checkRAMbounds
	ld a, [de]
	inc de
	ld b, a

.decompress
	ld [hl], c
	inc hl
	ld a, l
	or a
	jr z, .checkRAMbounds
	dec b
	jr nz, .decompress
	jr Read_Level_Data

.checkRAMbounds
	ld a, h
	cp $E0
	jr nz, Read_Level_Data
	ret

UnknownJump_0x03AF:
	ld a, [sFadeTimerLow]
	and $C0
	swap a
	ld e, a
	ld d, 0
	ld hl, UnknownData_0x03E1
	add hl, de
	ld a, [hli]
	ld [sBGPalette], a
	ld a, [hli]
	ld [sOAMPalette1], a
	ld a, [hli]
	ld [sOAMPalette2], a
	ld a, [sFadeTimerHigh]
	ld b, a
	ld a, [sFadeTimerLow]
	or b
	ret nz
	ld a, 0
	ld [sFadeTimerHigh], a
	ld a, 255
	ld [sFadeTimerLow], a
	ld a, 18
	ldh [$FF9B], a
	ret

UnknownData_0x03E1: ;fade palettes (BGP, OBP0, OBP1, pad), indexed by ($A266 & $C0) >> 4
	db $00, $00, $00, $00
	db $50, $40, $14, $00
	db $94, $90, $24, $00
	db $E4, $D0, $38, $00

UnknownJump_0x03F1:
	call UnknownCall_0x2D41
	call UnknownCall_0x0F2A
	ld a, 8 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, [sTilesetMapPtrLo]
	ld l, a
	ld a, [sTilesetMapPtrHi]
	ld h, a
	ld de, sMetatileMap

UnknownRJump_0x040A:
	ld a, [hli]
	ld [de], a
	inc de
	ld a, d
	cp $A8
	jr nz, UnknownRJump_0x040A
	ld a, [sLevelDataBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld hl, $4000
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, a
	ld a, b
	ld l, a
	ld a, [sLevelLayoutIndex]
	and $0F
	ld b, a
	sla a
	add b
	ld b, a
	and $F0
	swap a
	ld d, a
	ld a, b
	and $0F
	swap a
	ld e, a
	add hl, de
	ld de, $A960
	ld b, 48

UnknownRJump_0x043F:
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, UnknownRJump_0x043F
	ld a, [sLevelDataBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld hl, $4002
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, a
	ld a, b
	ld l, a
	ld a, [sLevelLayoutIndex]
	and $0F
	ld b, a
	sla a
	add b
	ld b, a
	and $F0
	swap a
	ld d, a
	ld a, b
	and $0F
	swap a
	ld e, a
	add hl, de
	ld de, $A900
	ld b, 48

UnknownRJump_0x0472:
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, UnknownRJump_0x0472
	ld a, [sLevelMusic]
	ld [sLevelSong], a
	ld a, [sLevelDataBank]
	ld [sLevelBank], a
	ld a, [sLevelLayoutIndex]
	and $F0
	ld [sSceneState], a
	xor a
	ld [sScreenTransition], a
	ld [sLevelLoadFlag], a
	ld [sVRAMTransferActive], a
	ld [sOAMWriteEnd], a
	ld hl, $AA80

UnknownRJump_0x049C:
	xor a
	ld [hl], a
	ld a, l
	add 16
	ld l, a
	jr nz, UnknownRJump_0x049C
	ld a, [sLevelTimeLimit]
	ld [sTimerHigh], a
	xor a
	ld [sTimerLow], a
	ld [sExitTileFlag], a
	ld a, 48
	ld [sTimerTickCounter], a
	ld hl, LevelPropertiesScroll
	ld a, [sCurLevel]
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl] ;check level autoscroll properties
	ld [sAutoScroll], a
	ld a, [sStarCarryover]
	and a
	jr z, UnknownRJump_0x04DD

	ld a, 4
	ld [sStarTimerHigh], a
	ld a, 64
	ld [sStarTimerLow], a
	ld a, 4
	ld [sMusicRequest], a
	xor a
	ld [sStarCarryover], a


UnknownRJump_0x04DD:
	ld hl, LevelPropertiesSpace
	ld a, [sCurLevel]
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl] ;check level space physics
	ld [sMoonPhysics], a
	ldh a, [$FF9B]
	inc a
	ldh [$FF9B], a
	ret

UnknownJump_0x04F1:
	call DisableVBlank
	call LoadMarioGFX
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x0361
	ld a, [sLevelBGPalette]
	ld [sBGPalette], a
	ldh [rBGP], a
	ld a, [sLevelOAMPalette1]
	ld [sOAMPalette1], a
	ldh [rOBP0], a
	ld a, [sLevelOAMPalette2]
	ld [sOAMPalette2], a
	ldh [rOBP1], a
	ld a, [sLevelCamYLo]
	ldh [$FFC8], a
	ld a, [sLevelCamYHi]
	ldh [$FFC9], a
	ld a, [sLevelCamXLo]
	ldh [$FFCA], a
	ld a, [sLevelCamXHi]
	ldh [$FFCB], a

UnknownRJump_0x052F:
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	call UnknownCall_0x08AD
	call ScrollLevelMap
	ldh a, [$FFC8]
	add 16
	ldh [$FFC8], a
	ldh a, [$FFC9]
	adc 0
	and $0F
	ldh [$FFC9], a
	ldh a, [$FFC8]
	ld b, a
	ld a, [sLevelCamYLo]
	cp b
	jr nz, UnknownRJump_0x052F
	ld a, [sLevelCamYLo]
	ldh [$FFC8], a
	ld a, [sLevelCamYHi]
	ldh [$FFC9], a
	ld a, [sLevelCamXLo]
	ldh [$FFCA], a
	ld a, [sLevelCamXHi]
	ldh [$FFCB], a
	ldh a, [$FFC8]
	sub 120
	ld [sScrollY], a
	ldh a, [$FFCA]
	sub 48
	ld [sScrollX], a
	call UnknownCall_0x07DB
	ld a, 3 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0xEBBB
	ld a, 227
	ldh [rLCDC], a
	xor a
	ld [sLevelInitDone], a
	ld a, [sSoundDisabled]
	and a
	jr nz, UnknownRJump_0x0598
	ld a, [sLevelMusic]
	ld [sMusicRequest], a

UnknownRJump_0x0598:
	ld hl, LevelPropertiesUNK
	ld a, [sCurLevel]
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl] ;level properties unknown
	ld [sMapScrollLimit], a
	xor a
	ld [sFadeTimerLow], a
	ld [sFadeTimerHigh], a
	ld [sInvincibilityTimer], a
	ld [sFireball1Active], a
	ld [sFireball2Active], a
	ld [sBossDefeated], a
	ld [sBossClearFlag], a
	ldh a, [$FF9B]
	inc a
	ldh [$FF9B], a
	ld a, [sLoadFadeFlag]
	and a
	ret z

	ld a, 0
	ld [sFadeTimerHigh], a
	ld a, 255
	ld [sFadeTimerLow], a
	ld a, 35
	ldh [$FF9B], a
	ret

UnknownJump_0x05D5:
	ld a, [sFadeTimerLow]
	ld b, a
	ld a, [sFadeTimerHigh]
	or b
	jr z, UnknownRJump_0x05E4
	xor a
	ldh [hKeysPressed], a
	ldh [hKeysHeld], a

UnknownRJump_0x05E4:
	call UnknownCall_0x2C61
	ld a, [sMarioDead]
	cp $FF
	jr z, UnknownRJump_0x0640
	ldh a, [$FFC0]
	ld [sMarioY], a
	ldh a, [$FFC1]
	ld [sMarioYU], a
	ldh a, [$FFC2]
	ld [sMarioX], a
	ldh a, [$FFC3]
	ld [sMarioXU], a
	ld a, [sScreenTransition]
	and a
	jr nz, UnknownRJump_0x060F
	xor a
	ld [sInLevelFlag], a
	call UnknownCall_0x0F71

UnknownRJump_0x060F:
	call UnknownCall_0x0879
	call UnknownCall_0x0B2A
	call UnknownCall_0x2062
	call UnknownCall_0x2D0A
	call UnknownCall_0x2C82
	ld a, [sPipeTravelDirection]
	cp $10
	call c, UnknownCall_0x2D7D
	ld a, [sMoonPhysics]
	bit 1, a
	call nz, UnknownCall_0x3753
	call UnknownCall_0x2A58
	ldh a, [$FF8D]
	ld [sSavedOAMIndex], a
	call UnknownCall_0x0652
	call UnknownCall_0x2CFF
	call UnknownCall_0x273E
	ret

UnknownRJump_0x0640:
	call UnknownCall_0x315C
	ldh a, [$FF8D]
	ld [sSavedOAMIndex], a
	call UnknownCall_0x0652
	call UnknownCall_0x2CFF
	call UnknownCall_0x273E
	ret

UnknownCall_0x0652:
	ld a, [sSceneState]
	and $F0
	jr nz, UnknownRJump_0x0665
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x8000
	ret

UnknownRJump_0x0665:
	call UnknownCall_0x3C9F
	ret

LoadMarioGFX: ;$0669
	ld a, [sCurLevel]
	ld hl, UnknownData_0x360A
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [sLevelGfxConfig], a
	and $0F
	and a
	jr nz, .MarioDark
	ld a, BANK(GFX_Mario) ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld bc, $0800
	ld hl, GFX_Mario
	ld de, $8000
	call CopyMem
	jr UnknownRJump_0x06C0

.MarioDark
	cp $01
	jr nz, .MarioMoon
	ld a, BANK(GFX_MarioDark)  ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld bc, $0800
	ld hl, GFX_MarioDark
	ld de, $8000
	call CopyMem
	jr UnknownRJump_0x06C0

.MarioMoon
	ld a, BANK(GFX_MarioMoon)  ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld bc, $0800
	ld hl, GFX_MarioMoon
	ld de, $8000
	call CopyMem

UnknownRJump_0x06C0:
	ld a, 7 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, [sLevelGfxConfig]
	and $F0
	swap a
	sla a
	ld e, a
	ld d, 0
	ld hl, UnknownData_0x0763
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld bc, $0380
	ld de, $8E80
	call CopyMem
	ld a, 27 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, [sLevelGfxConfig]
	and $F0
	swap a
	ld b, a
	sla a
	add b
	ld d, a
	ld e, 0
	ld hl, $7000
	add hl, de
	ld bc, $0300
	ld de, $8800
	call CopyMem
	ld a, [sCurLevel]
	ld hl, LevelEnemySets
	sla a
	sla a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	inc hl
	ld bc, $0380 ;size of enemy sets
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld a, e
	ld l, a
	ld de, $8B00
	call CopyMem
	ld a, [sCurLevel]
	ld hl, LevelTileSets
	sla a
	sla a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	inc hl
	ld bc, $0600 ;size of tilesets
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld a, e
	ld l, a
	ld de, $9200
	call CopyMem
	ld hl, UnknownData_0x35EA
	ld a, [sCurLevel]
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	inc a
	ld [sTileAnimConfig], a
	ret

UnknownData_0x0763: ;GFX source pointers, indexed by (sLevelGfxConfig >> 4) * 2
	dw $6A00, $6D80, $7100, $7480


UnknownCall_0x076B:
	ldh a, [$FF9B]
	cp $04
	ret nz
	ld a, [sLives]
	and $F0
	swap a
	add 128
	ld [$9C02], a
	ld a, [sLives]
	and $0F
	add 128
	ld [$9C03], a
	ld a, [sCoinHigh]
	and $0F
	add 128
	ld [$9C07], a
	ld a, [sCoinLow]
	and $F0
	swap a
	add 128
	ld [$9C08], a
	ld a, [sCoinLow]
	and $0F
	add 128
	ld [$9C09], a
	ld a, [sMoneyBagCount]
	and $F0
	swap a
	add 128
	ld [$9C0D], a
	ld a, [sMoneyBagCount]
	and $0F
	add 128
	ld [$9C0E], a
	ld a, [sTimerHigh]
	add 128
	ld [$9C11], a
	ld a, [sTimerLow]
	and $F0
	swap a
	add 128
	ld [$9C12], a
	ld a, [sTimerLow]
	and $0F
	add 128
	ld [$9C13], a
	ret

UnknownCall_0x07DB:
	ld hl, UnknownData_0x07EA
	ld de, $9C00
	ld b, 20

UnknownRJump_0x07E3:
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, UnknownRJump_0x07E3
	ret

UnknownData_0x07EA: ;window/HUD tile row, 20 tiles copied to $9C00 by UnknownCall_0x07DB
	db $9E, $AC, $80, $80, $8A, $9F, $AC, $80, $80, $80, $8A, $AB, $AC, $80, $80, $8A, $8D, $80, $80, $80

UnknownCall_0x07FE:
	ldh a, [rLY]
	ld [sScanlineStamp], a
	ret

UnknownCall_0x0804:
	ld a, [sScanlineStamp]
	ld b, a
	ldh a, [rLY]
	sub b
	ld b, a
	ld a, [sScanlineDeltaMax]
	cp b
	ret nc
	ld a, b
	ld [sScanlineDeltaMax], a
	ret

UnknownCall_0x0816:
	call DisableVBlank
	ld a, [sRedrawScrollY]
	ldh [$FFC8], a
	ld a, [sRedrawScrollYU]
	ldh [$FFC9], a
	ld a, [sRedrawScrollX]
	ldh [$FFCA], a
	ld a, [sRedrawScrollXU]
	ldh [$FFCB], a

UnknownRJump_0x082D:
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	call UnknownCall_0x08AD
	call ScrollLevelMap
	ldh a, [$FFC8]
	add 16
	ldh [$FFC8], a
	ldh a, [$FFC9]
	adc 0
	and $0F
	ldh [$FFC9], a
	ldh a, [$FFC8]
	ld b, a
	ld a, [sRedrawScrollY]
	cp b
	jr nz, UnknownRJump_0x082D
	ld a, [sRedrawScrollY]
	ldh [$FFC8], a
	ld a, [sRedrawScrollYU]
	ldh [$FFC9], a
	ld a, [sRedrawScrollX]
	ldh [$FFCA], a
	ld a, [sRedrawScrollXU]
	ldh [$FFCB], a
	ldh a, [$FFC8]
	sub 120
	ld [sScrollY], a
	ldh a, [$FFCA]
	sub 48
	ld [sScrollX], a
	ld a, 227
	ldh [rLCDC], a
	ret


UnknownCall_0x0879:
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	xor a
	ld [sWaterCurrentState], a
	ldh a, [$FF97]
	and $03
	jr z, UnknownRJump_0x08A2
	cp $01
	jr z, UnknownRJump_0x08D4
	cp $02
	jr z, UnknownRJump_0x0905
	cp $03
	jp z, UnknownJump_0x0937

	ret


UnknownRJump_0x08A2:
	ld a, [sMapScrollFlags]
	bit 6, a
	ret z
	ld a, 255
	ld [sWaterCurrentState], a

UnknownCall_0x08AD:
	ldh a, [$FFCA]
	sub 128
	ldh [$FFCE], a
	ldh a, [$FFCB]
	sbc 0
	and $0F
	ldh [$FFCF], a
	ldh a, [$FFC8]
	sub 120
	ldh [$FFCC], a
	ldh a, [$FFC9]
	sbc 0
	and $0F
	ldh [$FFCD], a
	ld a, [sMapScrollFlags]
	res 6, a
	ld [sMapScrollFlags], a
	jp UnknownJump_0x0969

UnknownRJump_0x08D4:
	ld a, [sMapScrollFlags]
	bit 7, a
	ret z
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFCA]
	sub 128
	ldh [$FFCE], a
	ldh a, [$FFCB]
	sbc 0
	and $0F
	ldh [$FFCF], a
	ldh a, [$FFC8]
	add 120
	ldh [$FFCC], a
	ldh a, [$FFC9]
	adc 0
	and $0F
	ldh [$FFCD], a
	ld a, [sMapScrollFlags]
	res 7, a
	ld [sMapScrollFlags], a
	jr UnknownRJump_0x0969

UnknownRJump_0x0905:
	ld a, [sMapScrollFlags]
	bit 5, a
	ret z
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFCA]
	sub 128
	ldh [$FFCE], a
	ldh a, [$FFCB]
	sbc 0
	and $0F
	ldh [$FFCF], a
	ldh a, [$FFC8]
	sub 120
	ldh [$FFCC], a
	ldh a, [$FFC9]
	sbc 0
	and $0F
	ldh [$FFCD], a
	ld a, [sMapScrollFlags]
	res 5, a
	ld [sMapScrollFlags], a
	jp UnknownJump_0x0A35

UnknownJump_0x0937:
	ld a, [sMapScrollFlags]
	bit 4, a
	ret z
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFCA]
	add 112
	ldh [$FFCE], a
	ldh a, [$FFCB]
	adc 0
	and $0F
	ldh [$FFCF], a
	ldh a, [$FFC8]
	sub 120
	ldh [$FFCC], a
	ldh a, [$FFC9]
	sbc 0
	and $0F
	ldh [$FFCD], a
	ld a, [sMapScrollFlags]
	res 4, a
	ld [sMapScrollFlags], a
	jp UnknownJump_0x0A35

UnknownJump_0x0969:
UnknownRJump_0x0969:
UnknownCall_0x0969:
	ld a, [sMapScrollFlags]
	and $3F
	ld [sMapScrollFlags], a
	ld a, 16
	ldh [$FFAE], a
	ld hl, $9800
	ldh a, [$FFCC]
	and $F0
	ld e, a
	xor a
	ld d, a
	sla e
	rl d
	sla e
	rl d
	add hl, de
	ldh a, [$FFCE]
	and $F0
	swap a
	sla a
	ld e, a
	ld d, 0
	add hl, de
	ld a, l
	ldh [$FFAA], a
	ld a, h
	ldh [$FFAB], a
	ldh a, [$FFCD]
	and $0F
	swap a
	add 176
	ld h, a
	ldh a, [$FFCC]
	and $F0
	swap a
	or h
	ld [sMapBlockPtrHigh], a
	ldh a, [$FFCF]
	and $0F
	swap a
	ld l, a
	ldh a, [$FFCE]
	and $F0
	swap a
	or l
	ld [sMapBlockPtrLow], a

UnknownRJump_0x09BE:
	ld a, [sMapBlockPtrLow]
	ld l, a
	ld a, [sMapBlockPtrHigh]
	ld h, a
	ld a, [hl]
	ld e, a
	xor a
	ld d, a
	sla e
	rl d
	sla e
	rl d
	ld hl, sMetatileMap
	add hl, de
	ld a, [hli]
	ld [sMetatileTile0], a
	ld a, [hli]
	ld [sMetatileTile1], a
	ld a, [hli]
	ld [sMetatileTile2], a
	ld a, [hli]
	ld [sMetatileTile3], a
	ldh a, [$FFAF]
	ld l, a
	ldh a, [$FFB0]
	ld h, a
	ldh a, [$FFAA]
	ld [hli], a
	ldh a, [$FFAB]
	ld [hli], a
	ld a, [sMetatileTile0]
	ld [hli], a
	ld a, [sMetatileTile1]
	ld [hli], a
	ld a, [sMetatileTile2]
	ld [hli], a
	ld a, [sMetatileTile3]
	ld [hli], a
	ld a, l
	ldh [$FFAF], a
	ld a, h
	ldh [$FFB0], a
	ld a, [sMapBlockPtrLow]
	inc a
	ld [sMapBlockPtrLow], a
	ldh a, [$FFAA]
	add 2
	ldh [$FFAA], a
	ldh a, [$FFAB]
	adc 0
	and $9B
	ldh [$FFAB], a
	ldh a, [$FFAA]
	and $DF
	ldh [$FFAA], a
	ldh a, [$FFAE]
	dec a
	ldh [$FFAE], a
	jr nz, UnknownRJump_0x09BE
	ldh a, [$FFAF]
	ld l, a
	ldh a, [$FFB0]
	ld h, a
	ld a, 0
	ld [hli], a
	ld [hl], a
	ret

UnknownJump_0x0A35:
UnknownCall_0x0A35:
	ld a, [sMapScrollFlags]
	and $CF
	ld [sMapScrollFlags], a
	ld a, 16
	ldh [$FFAE], a
	ld hl, $9800
	ldh a, [$FFCC]
	and $F0
	ld e, a
	xor a
	ld d, a
	sla e
	rl d
	sla e
	rl d
	add hl, de
	ldh a, [$FFCE]
	and $F0
	swap a
	sla a
	ld e, a
	ld d, 0
	add hl, de
	ld a, l
	ldh [$FFAA], a
	ld a, h
	ldh [$FFAB], a
	ldh a, [$FFCD]
	and $0F
	swap a
	add 176
	ld h, a
	ldh a, [$FFCC]
	and $F0
	swap a
	or h
	ld [sMapBlockPtrHigh], a
	ldh a, [$FFCF]
	and $0F
	swap a
	ld l, a
	ldh a, [$FFCE]
	and $F0
	swap a
	or l
	ld [sMapBlockPtrLow], a

UnknownRJump_0x0A8A:
	ld a, [sMapBlockPtrLow]
	ld l, a
	ld a, [sMapBlockPtrHigh]
	ld h, a
	ld a, [hl]
	ld e, a
	xor a
	ld d, a
	sla e
	rl d
	sla e
	rl d
	ld hl, sMetatileMap
	add hl, de
	ld a, [hli]
	ld [sMetatileTile0], a
	ld a, [hli]
	ld [sMetatileTile1], a
	ld a, [hli]
	ld [sMetatileTile2], a
	ld a, [hli]
	ld [sMetatileTile3], a
	ldh a, [$FFAF]
	ld l, a
	ldh a, [$FFB0]
	ld h, a
	ldh a, [$FFAA]
	ld [hli], a
	ldh a, [$FFAB]
	ld [hli], a
	ld a, [sMetatileTile0]
	ld [hli], a
	ld a, [sMetatileTile1]
	ld [hli], a
	ld a, [sMetatileTile2]
	ld [hli], a
	ld a, [sMetatileTile3]
	ld [hli], a
	ld a, l
	ldh [$FFAF], a
	ld a, h
	ldh [$FFB0], a
	ld a, [sMapBlockPtrHigh]
	inc a
	ld [sMapBlockPtrHigh], a
	ldh a, [$FFAA]
	add 64
	ldh [$FFAA], a
	ldh a, [$FFAB]
	adc 0
	and $9B
	ldh [$FFAB], a
	ldh a, [$FFAE]
	dec a
	ldh [$FFAE], a
	jr nz, UnknownRJump_0x0A8A
	ldh a, [$FFAF]
	ld l, a
	ldh a, [$FFB0]
	ld h, a
	ld a, 0
	ld [hli], a
	ld [hl], a
	ret

ScrollLevelMap: ;$0AFB
	ld de, $A9FF

.continue
	inc de
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	and a
	jr z, .done
	inc de
	ld a, [de]
	ld [hli], a
	ld a, h
	and $9B
	ld h, a
	inc de
	ld a, [de]
	ld [hl], a
	ld bc, $001F
	add hl, bc
	ld a, h
	and $9B
	ld h, a
	inc de
	ld a, [de]
	ld [hli], a
	ld a, h
	and $9B
	ld h, a
	inc de
	ld a, [de]
	ld [hl], a
	jr .continue

.done
	xor a
	ld [$AA01], a
	ret

UnknownCall_0x0B2A:
	ld a, [sSceneState]
	and $F0
	ret nz
	ld a, [sBossDefeated]
	and a
	jr z, UnknownRJump_0x0B39
	and $F0
	ret z

UnknownRJump_0x0B39:
	ld a, [sScreenTransition]
	and a
	jp nz, UnknownJump_0x0DED
	ldh a, [$FFC9]
	swap a
	ld b, a
	ldh a, [$FFCB]
	or b
	ld e, a
	ld d, 0
	ld hl, $A960
	add hl, de
	ld a, [hl]
	ldh [$FF98], a
	ld a, [sAutoScroll]
	and a
	jr z, UnknownRJump_0x0B5E
	call UnknownCall_0x0DAF
	jp UnknownJump_0x0C7D

UnknownRJump_0x0B5E:
	ldh a, [$FF98]
	bit 0, a
	jr z, UnknownRJump_0x0B90
	ldh a, [$FFCA]
	cp $B0
	jp nz, UnknownJump_0x0B7D
	ld a, [sMarioScreenX]
	cp $A1
	jr c, UnknownRJump_0x0BE5
	ld a, 1
	ld [sScreenTransition], a
	call UnknownCall_0x0F0B
	jp UnknownJump_0x0BE5

UnknownJump_0x0B7D:
	jr c, UnknownRJump_0x0B90
	ldh a, [$FFCA]
	sub 1
	ldh [$FFCA], a
	ldh a, [$FFCB]
	sbc 0
	and $0F
	ldh [$FFCB], a
	jp UnknownJump_0x0BE5

UnknownRJump_0x0B90:
	ld a, [sScrollDeltaRight]
	and a
	jr z, UnknownRJump_0x0BE5
	ld a, [sScrollRightEnabled]
	and a
	jr z, UnknownRJump_0x0BE5
	xor a
	ld [sScrollLeftEnabled], a
	ld a, [sScrollDeltaRight]
	ld b, a
	ldh a, [$FFCA]
	add b
	ldh [$FFCA], a
	ld b, a
	ldh a, [$FFCB]
	adc 0
	and $0F
	ldh [$FFCB], a
	ld a, [sMapScrollFlags]
	set 4, a
	ld [sMapScrollFlags], a
	ldh a, [$FFC2]
	sub b
	add 96
	cp $40
	jr c, UnknownRJump_0x0BD3
	ldh a, [$FFCA]
	add 1
	ldh [$FFCA], a
	ldh a, [$FFCB]
	adc 0
	and $0F
	ldh [$FFCB], a
	jr UnknownRJump_0x0BE5

UnknownRJump_0x0BD3:
	cp $3F
	jr nc, UnknownRJump_0x0BE5
	ldh a, [$FFCA]
	sub 1
	ldh [$FFCA], a
	ldh a, [$FFCB]
	sbc 0
	and $0F
	ldh [$FFCB], a

UnknownJump_0x0BE5:
UnknownRJump_0x0BE5:
	ldh a, [$FF98]
	bit 1, a
	jr z, UnknownRJump_0x0C21
	ldh a, [$FFCA]
	cp $50
	jr nz, UnknownRJump_0x0C0F
	ld a, [sMarioScreenX]
	cp $0F
	jp nc, UnknownJump_0x0C76
	ld a, 2
	ld [sScreenTransition], a
	ld a, 0
	ldh [$FFC2], a
	ldh a, [$FFC3]
	inc a
	and $0F
	ldh [$FFC3], a
	call UnknownCall_0x0F0B
	jp UnknownJump_0x0C76

UnknownRJump_0x0C0F:
	jr nc, UnknownRJump_0x0C21
	ldh a, [$FFCA]
	add 1
	ldh [$FFCA], a
	ldh a, [$FFCB]
	adc 0
	and $0F
	ldh [$FFCB], a
	jr UnknownRJump_0x0C76

UnknownRJump_0x0C21:
	ld a, [sScrollDeltaLeft]
	and a
	jr z, UnknownRJump_0x0C76
	ld a, [sScrollLeftEnabled]
	and a
	jr z, UnknownRJump_0x0C76
	xor a
	ld [sScrollRightEnabled], a
	ld a, [sScrollDeltaLeft]
	ld b, a
	ldh a, [$FFCA]
	sub b
	ldh [$FFCA], a
	ld b, a
	ldh a, [$FFCB]
	sbc 0
	and $0F
	ldh [$FFCB], a
	ld a, [sMapScrollFlags]
	set 5, a
	ld [sMapScrollFlags], a
	ldh a, [$FFC2]
	sub b
	add 96
	cp $70
	jr nc, UnknownRJump_0x0C64
	ldh a, [$FFCA]
	sub 1
	ldh [$FFCA], a
	ldh a, [$FFCB]
	sbc 0
	and $0F
	ldh [$FFCB], a
	jr UnknownRJump_0x0C76

UnknownRJump_0x0C64:
	cp $71
	jr c, UnknownRJump_0x0C76
	ldh a, [$FFCA]
	add 1
	ldh [$FFCA], a
	ldh a, [$FFCB]
	adc 0
	and $0F
	ldh [$FFCB], a

UnknownJump_0x0C76:
UnknownRJump_0x0C76:
	xor a
	ld [sScrollDeltaRight], a
	ld [sScrollDeltaLeft], a

UnknownJump_0x0C7D:
	ldh a, [$FFC8]
	ld b, a
	ldh a, [$FFC0]
	sub b
	add 96
	ldh [$FF99], a
	ld a, [sPrevMarioY]
	ld b, a
	ldh a, [$FFC0]
	sub b
	jp z, UnknownJump_0x0D97
	bit 7, a
	jp nz, UnknownJump_0x0D05
	ld [sScrollDeltaDown], a
	ld a, [sMapScrollFlags]
	set 7, a
	ld [sMapScrollFlags], a
	ldh a, [$FF98]
	bit 3, a
	jr z, UnknownRJump_0x0CEC
	ldh a, [$FFC8]
	cp $C0
	jr nz, UnknownRJump_0x0CC0
	ld a, [sMarioScreenY]
	cp $90
	jp c, UnknownJump_0x0D97
	ld a, 8
	ld [sScreenTransition], a
	call UnknownCall_0x0F0B
	jp UnknownJump_0x0D05

UnknownRJump_0x0CC0:
	jr c, UnknownRJump_0x0CD3
	ldh a, [$FFC8]
	sub 1
	ldh [$FFC8], a
	ldh a, [$FFC9]
	sbc 0
	and $0F
	ldh [$FFC9], a
	jp UnknownJump_0x0D97

UnknownRJump_0x0CD3:
	ldh a, [$FF99]
	cp $58
	jp c, UnknownJump_0x0D97
	ld a, [sScrollDeltaDown]
	ld b, a
	ldh a, [$FFC8]
	add b
	ldh [$FFC8], a
	ldh a, [$FFC9]
	adc 0
	ldh [$FFC9], a
	jp UnknownJump_0x0D97

UnknownRJump_0x0CEC:
	ldh a, [$FF99]
	cp $50
	jp c, UnknownJump_0x0D97
	ld a, [sScrollDeltaDown]
	ld b, a
	ldh a, [$FFC8]
	add b
	ldh [$FFC8], a
	ldh a, [$FFC9]
	adc 0
	ldh [$FFC9], a
	jp UnknownJump_0x0D97

UnknownJump_0x0D05:
	cpl
	inc a
	ld [sScrollDeltaUp], a
	ld a, [sMapScrollFlags]
	set 6, a
	ld [sMapScrollFlags], a
	ldh a, [$FF98]
	bit 2, a
	jr z, UnknownRJump_0x0D74
	ldh a, [$FFC8]
	cp $48
	jr nz, UnknownRJump_0x0D3D
	ld a, [sMarioScreenY]
	cp $1B
	jr nc, UnknownRJump_0x0D97
	ld a, 4
	ld [sScreenTransition], a
	ld a, 0
	ldh [$FFC0], a
	ldh a, [$FFC9]
	ldh [$FFC1], a
	ld a, [sSceneState]
	and $F0
	call z, UnknownCall_0x0F0B
	jp UnknownJump_0x0D97

UnknownRJump_0x0D3D:
	jr nc, UnknownRJump_0x0D4F
	ldh a, [$FFC8]
	add 1
	ldh [$FFC8], a
	ldh a, [$FFC9]
	adc 0
	and $0F
	ldh [$FFC9], a
	jr UnknownRJump_0x0D97

UnknownRJump_0x0D4F:
	ld a, [sMapScrollLimit]
	and a
	jr z, UnknownRJump_0x0D5D
	ldh a, [$FF99]
	cp $40
	jr nc, UnknownRJump_0x0D97
	jr UnknownRJump_0x0D63

UnknownRJump_0x0D5D:
	ldh a, [$FF99]
	cp $38
	jr nc, UnknownRJump_0x0D97

UnknownRJump_0x0D63:
	ld a, [sScrollDeltaUp]
	ld b, a
	ldh a, [$FFC8]
	sub b
	ldh [$FFC8], a
	ldh a, [$FFC9]
	sbc 0
	ldh [$FFC9], a
	jr UnknownRJump_0x0D97

UnknownRJump_0x0D74:
	ld a, [sMapScrollLimit]
	and a
	jr z, UnknownRJump_0x0D82
	ldh a, [$FF99]
	cp $40
	jr nc, UnknownRJump_0x0D97
	jr UnknownRJump_0x0D88

UnknownRJump_0x0D82:
	ldh a, [$FF99]
	cp $28
	jr nc, UnknownRJump_0x0D97

UnknownRJump_0x0D88:
	ld a, [sScrollDeltaUp]
	ld b, a
	ldh a, [$FFC8]
	sub b
	ldh [$FFC8], a
	ldh a, [$FFC9]
	sbc 0
	ldh [$FFC9], a

UnknownJump_0x0D97:
UnknownRJump_0x0D97:
	xor a
	ld [sScrollDeltaDown], a
	ld [sScrollDeltaUp], a
	ldh a, [$FFC0]
	ld [sPrevMarioY], a
	ret

UnknownData_0x0DA4:
	db $00, $01, $01, $00, $00, $00, $01, $02, $02, $01, $01


UnknownCall_0x0DAF:
	ldh a, [$FF98]
	bit 0, a
	jr z, UnknownRJump_0x0DCA
	ldh a, [$FFCA]
	cp $B0
	jr c, UnknownRJump_0x0DCA
	ld a, [sMarioScreenX]
	cp $A1
	ret c
	ld a, 1
	ld [sScreenTransition], a
	call UnknownCall_0x0F0B
	ret

UnknownRJump_0x0DCA:
	ldh a, [$FF97]
	and $01
	ret nz
	xor a
	ld [sScrollLeftEnabled], a
	ld a, 1
	ld b, a
	ldh a, [$FFCA]
	add b
	ldh [$FFCA], a
	ld b, a
	ldh a, [$FFCB]
	adc 0
	and $0F
	ldh [$FFCB], a
	ld a, [sMapScrollFlags]
	set 4, a
	ld [sMapScrollFlags], a
	ret

UnknownJump_0x0DED:
	ld a, [sScreenTransition]
	bit 0, a
	jr z, UnknownRJump_0x0E20
	ldh a, [$FFCA]
	add 4
	ldh [$FFCA], a
	ldh a, [$FFCB]
	adc 0
	and $0F
	ldh [$FFCB], a
	ld b, 1
	call UnknownCall_0x14E3
	ld a, 16
	ld [sMapScrollFlags], a
	ldh a, [$FFC2]
	add 1
	ldh [$FFC2], a
	ldh a, [$FFC3]
	adc 0
	ldh [$FFC3], a
	ldh a, [$FFCA]
	cp $50
	ret nz
	jp UnknownJump_0x0EB0

UnknownRJump_0x0E20:
	bit 1, a
	jr z, UnknownRJump_0x0E4F
	ldh a, [$FFCA]
	sub 4
	ldh [$FFCA], a
	ldh a, [$FFCB]
	sbc 0
	and $0F
	ldh [$FFCB], a
	ld b, 1
	call UnknownCall_0x14E3
	ld a, 32
	ld [sMapScrollFlags], a
	ldh a, [$FFC2]
	sub 1
	ldh [$FFC2], a
	ldh a, [$FFC3]
	sbc 0
	ldh [$FFC3], a
	ldh a, [$FFCA]
	cp $B0
	ret nz
	jr UnknownRJump_0x0EB0

UnknownRJump_0x0E4F:
	bit 2, a
	jr z, UnknownRJump_0x0E7E
	ldh a, [$FFC8]
	sub 4
	ldh [$FFC8], a
	ldh a, [$FFC9]
	sbc 0
	and $0F
	ldh [$FFC9], a
	ld b, 1
	call UnknownCall_0x14E3
	ld a, 64
	ld [sMapScrollFlags], a
	ldh a, [$FFC0]
	sub 1
	ldh [$FFC0], a
	ldh a, [$FFC1]
	sbc 0
	ldh [$FFC1], a
	ldh a, [$FFC8]
	cp $B8
	ret nz
	jr UnknownRJump_0x0EB0

UnknownRJump_0x0E7E:
	bit 3, a
	ret z
	ldh a, [$FFC8]
	add 4
	ldh [$FFC8], a
	ldh a, [$FFC9]
	adc 0
	and $0F
	ldh [$FFC9], a
	ld b, 1
	call UnknownCall_0x14E3
	ld a, 128
	ld [sMapScrollFlags], a
	ldh a, [$FF97]
	and $01
	add 1
	ld b, a
	ldh a, [$FFC0]
	add b
	ldh [$FFC0], a
	ldh a, [$FFC1]
	adc 0
	ldh [$FFC1], a
	ldh a, [$FFC8]
	cp $48
	ret nz

UnknownJump_0x0EB0:
UnknownRJump_0x0EB0:
	xor a
	ld [sScreenTransition], a
	ld a, [sSceneState]
	and $0F
	jr z, UnknownRJump_0x0EE4
	ld a, 240
	ld [sSceneState], a
	call DisableVBlank
	call UnknownCall_0x3C94
	ld a, 195
	ldh [rLCDC], a
	ld a, 32
	ld [sMusicRequest], a
	ld [sLevelSong], a
	ld a, [sCurLevel]
	cp $18
	jr nz, UnknownRJump_0x0EE4
	ld a, [sBossFightPhase]
	add 33
	ld [sMusicRequest], a
	ld [sLevelSong], a

UnknownRJump_0x0EE4:
	ld a, [sBossDefeated]
	and $F0
	jr z, UnknownRJump_0x0EF3
	ld a, [sBossDefeated]
	and $0F
	ld [sBossDefeated], a

UnknownRJump_0x0EF3:
	ld a, 5
	ld [sSfxRequest0], a
	ld a, [sLevelBGPalette]
	ld [sBGPalette], a
	ld a, [sLevelOAMPalette1]
	ld [sOAMPalette1], a
	ld a, [sLevelOAMPalette2]
	ld [sOAMPalette2], a
	ret

UnknownCall_0x0F0B:
	ld a, 255
	ld [sMapEventFlag], a
	ldh a, [$FFC1]
	swap a
	ld e, a
	ldh a, [$FFC3]
	and $0F
	add e
	ld e, a
	ld d, 0
	ld hl, $A900
	add hl, de
	ld a, [hl]
	ld [sSceneId], a
	xor a
	ld [sPaletteFadeStep], a
	ret

UnknownCall_0x0F2A:
	ld a, [sLevelStartXLo]
	ldh [$FFC2], a
	ld a, [sLevelStartYLo]
	ldh [$FFC0], a
	ld [sPrevMarioY], a
	ld a, [sLevelStartXHi]
	ldh [$FFC3], a
	ld a, [sLevelStartYHi]
	ldh [$FFC1], a
	ld a, 128
	ld [sHVelocityIndex], a
	ld a, 24
	ld [sVVelocityIndex], a
	ld a, 1
	ld [sMarioDirection], a
	xor a
	ld [sStarTimerHigh], a
	ld [sStompChainCount], a
	ld [sPauseState], a
	ld [sGoalBell], a
	ld [sMarioDead], a
	ld a, 64
	ld [sFadeTimerLow], a
	ld [sMarioScreenY], a
	ld [sMarioScreenX], a
	ld a, 1
	ld [sFadeTimerHigh], a
	ret

UnknownCall_0x0F71:
	call UnknownCall_0x307D
	call UnknownCall_0x13FE
	ld a, [sPipeTravelDirection]
	cp $10
	jr nc, UnknownRJump_0x0FBB
	call UnknownCall_0x0FF2
	call UnknownCall_0x1BFF
	call UnknownCall_0x129F
	call UnknownCall_0x1413
	call UnknownCall_0x14A6
	call UnknownCall_0x126F
	call UnknownCall_0x160A
	call UnknownCall_0x1090
	call UnknownCall_0x14FA
	call UnknownCall_0x1701
	call UnknownCall_0x16CC
	call UnknownCall_0x181C
	call UnknownCall_0x0FBF
	call UnknownCall_0x14BF
	call UnknownCall_0x1189
	call UnknownCall_0x319F
	call UnknownCall_0x3451
	call UnknownCall_0x32C1
	call UnknownCall_0x331C
	call UnknownCall_0x324F
	ret

UnknownRJump_0x0FBB:
	call UnknownCall_0x10EC
	ret

UnknownCall_0x0FBF:
	ldh a, [$FFCA]
	ld b, a
	ldh a, [$FFC2]
	sub b
	add 96
	ld b, a
	cp $10
	jr c, UnknownRJump_0x0FD1
	cp $A0
	jr nc, UnknownRJump_0x0FE3
	ret

UnknownRJump_0x0FD1:
	sub 16
	xor $FF
	inc a
	ld b, a
	ldh a, [$FFC2]
	add b
	ldh [$FFC2], a
	ldh a, [$FFC3]
	adc 0
	ldh [$FFC3], a
	ret

UnknownRJump_0x0FE3:
	sub 160
	ld b, a
	ldh a, [$FFC2]
	sub b
	ldh [$FFC2], a
	ldh a, [$FFC3]
	sbc 0
	ldh [$FFC3], a
	ret

UnknownCall_0x0FF2:
	ld a, [sGoalBell]
	and a
	ret nz
	ld a, [sMoonPhysics]
	and a
	ret z
	bit 0, a
	jr nz, UnknownRJump_0x106F
	bit 1, a
	jr nz, UnknownRJump_0x1055
	bit 3, a
	jr nz, UnknownRJump_0x1029
	ld a, [sMarioOnGround]
	and a
	ret nz
	ldh a, [hKeysHeld]
	bit 0, a
	ret z
	ldh a, [hKeysPressed]
	bit 0, a
	jr z, UnknownRJump_0x101D
	ld a, 18
	ld [sSfxRequest0], a

UnknownRJump_0x101D:
	ld a, [sVVelocityIndex]
	cp $4A
	ret nc
	add 2
	ld [sVVelocityIndex], a
	ret

UnknownRJump_0x1029:
	ld a, [sMarioOnGround]
	and a
	jr nz, UnknownRJump_0x104A
	ldh a, [hKeysHeld]
	bit 0, a
	jr z, UnknownRJump_0x1050
	ld a, [sMoonFloatTimer]
	and a
	ret z
	dec a
	ld [sMoonFloatTimer], a
	ld a, [sVVelocityIndex]
	cp $4A
	ret nc
	add 2
	ld [sVVelocityIndex], a
	ret

UnknownRJump_0x104A:
	ld a, 50
	ld [sMoonFloatTimer], a
	ret

UnknownRJump_0x1050:
	xor a
	ld [sMoonFloatTimer], a
	ret

UnknownRJump_0x1055:
	ldh a, [hKeysPressed]
	bit 0, a
	ret z
	ld a, 52
	ld [sVVelocityIndex], a
	ld a, [sMoonJumpPoseTimer]
	and a
	ret nz
	ld a, 8
	ld [sMoonJumpPoseTimer], a
	ld a, 3
	ld [sSfxRequest0], a
	ret

UnknownRJump_0x106F:
	ld a, [sMarioOnGround]
	and a
	ret nz
	ldh a, [hKeysHeld]
	bit 0, a
	ret z
	ldh a, [hKeysPressed]
	bit 0, a
	jr z, UnknownRJump_0x1084
	ld a, 18
	ld [sSfxRequest0], a

UnknownRJump_0x1084:
	ld a, [sVVelocityIndex]
	cp $48
	ret nc
	add 4
	ld [sVVelocityIndex], a
	ret

UnknownCall_0x1090:
	ld a, [sGoalBell]
	and a
	ret nz
	ld a, [sCameraPanTimer]
	and a
	ret nz
	ld a, [sCurPowerup]
	cp $02
	jr nz, UnknownRJump_0x10EB
	ld a, [sMoonPhysics]
	and a
	jr nz, UnknownRJump_0x10EB
	ld a, [sVVelocityIndex]
	cp $48
	jr nc, UnknownRJump_0x10EB
	ldh a, [hKeysPressed]
	bit 0, a
	jr nz, UnknownRJump_0x10D7
	ld a, [sFlutterArmed]
	and a
	jr z, UnknownRJump_0x10EB
	ld a, [sMarioOnGround]
	and a
	jr nz, UnknownRJump_0x10EB
	ldh a, [hKeysHeld]
	bit 0, a
	jr z, UnknownRJump_0x10EB
	ld a, [sFlutterCharge]
	inc a
	ld [sFlutterCharge], a
	cp $0C
	jr c, UnknownRJump_0x10EB
	xor a
	ld [sFlutterCharge], a
	jr UnknownRJump_0x10DC

UnknownRJump_0x10D7:
	ld a, 255
	ld [sFlutterArmed], a

UnknownRJump_0x10DC:
	ld a, 8
	ld [sFlutterTimer], a
	ld a, 24
	ld [sVVelocityIndex], a
	ld a, 6
	ld [sSfxRequest1], a

UnknownRJump_0x10EB:
	ret

UnknownCall_0x10EC:
	ld a, [sPipeTravelDirection]
	cp $10
	jr nz, UnknownRJump_0x1111
	ldh a, [$FFC0]
	add 2
	ldh [$FFC0], a
	ldh a, [$FFC1]
	adc 0
	ldh [$FFC1], a
	ld a, 1
	ld [sScrollDeltaUp], a
	call UnknownCall_0x1DFE
	ret c
	call UnknownCall_0x1E36
	ret c
	xor a
	ld [sPipeTravelDirection], a
	ret

UnknownRJump_0x1111:
	ld a, [sPipeTravelDirection]
	cp $20
	jr nz, UnknownRJump_0x1136
	ldh a, [$FFC0]
	sub 2
	ldh [$FFC0], a
	ldh a, [$FFC1]
	sbc 0
	ldh [$FFC1], a
	ld a, 1
	ld [sScrollDeltaUp], a
	call UnknownCall_0x1DFE
	ret c
	call UnknownCall_0x1E36
	ret c
	xor a
	ld [sPipeTravelDirection], a
	ret

UnknownRJump_0x1136:
	ld a, [sPipeTravelDirection]
	cp $30
	jr nz, UnknownRJump_0x1160
	ldh a, [$FFC2]
	add 2
	ldh [$FFC2], a
	ldh a, [$FFC3]
	adc 0
	ldh [$FFC3], a
	ld a, 1
	ld [sScrollDeltaRight], a
	ld b, 1
	call UnknownCall_0x14E3
	call UnknownCall_0x1E8D
	ret c
	call UnknownCall_0x1E7C
	ret c
	xor a
	ld [sPipeTravelDirection], a
	ret

UnknownRJump_0x1160:
	ld a, [sPipeTravelDirection]
	cp $40
	ret nz
	ldh a, [$FFC2]
	sub 2
	ldh [$FFC2], a
	ldh a, [$FFC3]
	sbc 0
	ldh [$FFC3], a
	ld a, 1
	ld [sScrollDeltaLeft], a
	ld b, 1
	call UnknownCall_0x14E3
	call UnknownCall_0x1E8D
	ret c
	call UnknownCall_0x1E7C
	ret c
	xor a
	ld [sPipeTravelDirection], a
	ret

UnknownCall_0x1189:
	ld a, [sPipeTravelDirection]
	and a
	ret z
	cp $01
	jr nz, UnknownRJump_0x11C0
	ldh a, [hKeysHeld]
	bit 7, a
	ret z
	ldh a, [$FFC2]
	bit 4, a
	ret z
	and $0F
	sub 5
	cp $07
	ret nc
	ld a, 16
	ld [sPipeTravelDirection], a
	ld a, 5
	ld [sSfxRequest0], a
	xor a
	ld [sMarioDucking], a
	ld [sFireball1Active], a
	ld [sFireball2Active], a
	ld a, [sPipeTravelDirection]
	ld a, 128
	ld [sHVelocityIndex], a
	ret

UnknownRJump_0x11C0:
	cp $02
	jr nz, UnknownRJump_0x11FE
	ldh a, [hKeysHeld]
	bit 6, a
	ret z
	ldh a, [$FFC2]
	bit 4, a
	ret z
	and $0F
	sub 5
	cp $07
	ret nc
	ld a, 32
	ld [sPipeTravelDirection], a
	ldh a, [$FFC0]
	sub 2
	ldh [$FFC0], a
	ldh a, [$FFC1]
	sbc 0
	ldh [$FFC1], a
	ld a, 5
	ld [sSfxRequest0], a
	xor a
	ld [sMarioDucking], a
	ld [sFireball1Active], a
	ld [sFireball2Active], a
	ld a, [sPipeTravelDirection]
	ld a, 128
	ld [sHVelocityIndex], a
	ret

UnknownRJump_0x11FE:
	cp $03
	jr nz, UnknownRJump_0x1244
	ld a, [sAutoScroll]
	and a
	jr z, UnknownRJump_0x120E
	ldh a, [$FFCA]
	cp $B0
	jr c, UnknownRJump_0x1244

UnknownRJump_0x120E:
	ld a, [sSidePushDir]
	cp $01
	jr z, UnknownRJump_0x1225
	ldh a, [hKeysHeld]
	bit 4, a
	jr z, UnknownRJump_0x1244
	ld a, [sMarioOnGround]
	and a
	ret z
	ld a, [sBossDefeated]
	and a
	ret nz

UnknownRJump_0x1225:
	ld a, 48
	ld [sPipeTravelDirection], a
	xor a
	ld [sMarioDucking], a
	ld [sFireball1Active], a
	ld [sFireball2Active], a
	ld a, 128
	ld [sHVelocityIndex], a
	ld a, [sBossFightPhase]
	and a
	ret nz
	ld a, 5
	ld [sSfxRequest0], a
	ret

UnknownRJump_0x1244:
	ld a, [sSidePushDir]
	cp $FF
	jr z, UnknownRJump_0x1255
	ldh a, [hKeysHeld]
	bit 5, a
	ret z
	ld a, [sMarioOnGround]
	and a
	ret z

UnknownRJump_0x1255:
	ld a, 64
	ld [sPipeTravelDirection], a
	ld a, 5
	ld [sSfxRequest0], a
	xor a
	ld [sMarioDucking], a
	ld [sFireball1Active], a
	ld [sFireball2Active], a
	ld a, 128
	ld [sHVelocityIndex], a
	ret

UnknownCall_0x126F:
	ldh a, [hKeysHeld]
	bit 7, a
	jr z, UnknownRJump_0x129A
	ld a, [sCurPowerup]
	bit 0, a
	jr z, UnknownRJump_0x129A
	ld a, [sMarioOnGround]
	and a
	jr nz, UnknownRJump_0x129A
	ld a, [sMoonPhysics]
	and $0F
	jr nz, UnknownRJump_0x129A
	ld a, [sSpinJump]
	and a
	jr nz, UnknownRJump_0x1294
	ld a, 14
	ld [sSfxRequest0], a

UnknownRJump_0x1294:
	ld a, 255
	ld [sSpinJump], a
	ret

UnknownRJump_0x129A:
	xor a
	ld [sSpinJump], a
	ret

UnknownCall_0x129F:
	ld a, [sVVelocityIndex]
	cp $19
	ret nc
	xor a
	ld [sNoJumpCut], a
	ld a, [sMarioOnObject]
	and a
	jp nz, UnknownJump_0x1378
	call UnknownCall_0x1E3B
	jr c, UnknownRJump_0x12CE
	ld a, [sMarioOnGround]
	and a
	jr z, UnknownRJump_0x12C9
	ld a, [sHVelocityIndex]
	sub 72
	cp $78
	jr c, UnknownRJump_0x12C9
	ld a, 28
	ld [sVVelocityIndex], a

UnknownRJump_0x12C9:
	xor a
	ld [sMarioOnGround], a
	ret

UnknownRJump_0x12CE:
	and $FE
	cp $04
	jr nz, UnknownRJump_0x1327
	ld a, [sCollisionTile]
	cp $05
	jr z, UnknownRJump_0x1302
	ldh a, [$FF97]
	bit 0, a
	jr z, UnknownRJump_0x1327
	ldh a, [$FFC2]
	add 1
	ldh [$FFC2], a
	ldh a, [$FFC3]
	adc 0
	ldh [$FFC3], a
	ld a, 1
	ld [sSidePushDir], a
	ld a, [sHVelocityIndex]
	cp $80
	jr c, UnknownRJump_0x1327
	ld a, [sScrollDeltaRight]
	inc a
	ld [sScrollDeltaRight], a
	jr UnknownRJump_0x1327

UnknownRJump_0x1302:
	ldh a, [$FF97]
	bit 0, a
	jr z, UnknownRJump_0x1327
	ldh a, [$FFC2]
	sub 1
	ldh [$FFC2], a
	ldh a, [$FFC3]
	sbc 0
	ldh [$FFC3], a
	ld a, 255
	ld [sSidePushDir], a
	ld a, [sHVelocityIndex]
	cp $81
	jr nc, UnknownRJump_0x1327
	ld a, [sScrollDeltaLeft]
	inc a
	ld [sScrollDeltaLeft], a

UnknownRJump_0x1327:
	ld a, [sSpinJump]
	and a
	jr z, UnknownRJump_0x134F
	call UnknownCall_0x1993
	ld a, [sSpinJumpBounce]
	and a
	jr z, UnknownRJump_0x134F
	ld a, 255
	ld [sMarioInAir], a
	ld a, 48
	ld [sVVelocityIndex], a
	ldh a, [hKeysHeld]
	bit 0, a
	ret z
	ld a, 75
	ld [sVVelocityIndex], a
	xor a
	ld [sMarioOnGround], a
	ret

UnknownRJump_0x134F:
	ld a, 255
	ld [sMarioOnGround], a
	xor a
	ld [sPipeTravelDirection], a
	ld a, [sCollisionTile]
	and $FE
	cp $08
	jr nz, UnknownRJump_0x1366
	ld a, 1
	ld [sPipeTravelDirection], a

UnknownRJump_0x1366:
	ld a, [sPipeAlignTarget]
	ld b, a
	ldh a, [$FFC0]
	sub 4
	and $0F
	cp b
	ret z
	ldh a, [$FFC0]
	dec a
	ldh [$FFC0], a
	ret

UnknownJump_0x1378:
	ld a, 255
	ld [sMarioOnGround], a
	xor a
	ld [sPipeTravelDirection], a
	ret

UnknownCall_0x1382:
	ld b, 1
	ldh a, [hKeysHeld]
	bit 1, a
	jr z, UnknownRJump_0x138C
	ld b, 3

UnknownRJump_0x138C:
	ldh a, [hKeysHeld]
	bit 4, a
	jr z, UnknownRJump_0x13A6
	ldh a, [$FFC2]
	add b
	ldh [$FFC2], a
	ldh a, [$FFC3]
	adc 0
	ldh [$FFC3], a
	ld a, b
	ld [sScrollDeltaRight], a
	ld a, 1
	ld [sMarioDirection], a

UnknownRJump_0x13A6:
	ldh a, [hKeysHeld]
	bit 5, a
	jr z, UnknownRJump_0x13C0
	ldh a, [$FFC2]
	sub b
	ldh [$FFC2], a
	ldh a, [$FFC3]
	sbc 0
	ldh [$FFC3], a
	ld a, b
	ld [sScrollDeltaLeft], a
	ld a, 255
	ld [sMarioDirection], a

UnknownRJump_0x13C0:
	ldh a, [hKeysHeld]
	bit 6, a
	jr z, UnknownRJump_0x13D5
	ldh a, [$FFC0]
	sub b
	ldh [$FFC0], a
	ldh a, [$FFC1]
	sbc 0
	ldh [$FFC1], a
	ld a, b
	ld [sScrollDeltaUp], a

UnknownRJump_0x13D5:
	ldh a, [hKeysHeld]
	bit 7, a
	jr z, UnknownRJump_0x13EA
	ldh a, [$FFC0]
	add b
	ldh [$FFC0], a
	ldh a, [$FFC1]
	adc 0
	ldh [$FFC1], a
	ld a, b
	ld [sScrollDeltaDown], a

UnknownRJump_0x13EA:
	ldh a, [$FFC0]
	ldh [$FFB7], a
	ldh a, [$FFC1]
	ldh [$FFB8], a
	ldh a, [$FFC2]
	ldh [$FFB9], a
	ldh a, [$FFC3]
	ldh [$FFBA], a
	call UnknownCall_0x1EFA
	ret


UnknownCall_0x13FE:
	xor a
	ld [sMarioXSub], a
	ld [sMarioXPushed], a
	ld [sPipeAlignTarget], a
	ld a, [sPipeTravelDirection]
	cp $10
	ret nc
	xor a
	ld [sPipeTravelDirection], a
	ret

UnknownCall_0x1413:
	jr UnknownRJump_0x1432

	ld a, [sSwimming]
	and a
	jr z, UnknownRJump_0x1432
	ld a, [sHVelocityIndex]
	cp $60
	jr nc, UnknownRJump_0x1429
	ld a, 96
	ld [sHVelocityIndex], a
	jr UnknownRJump_0x1432

UnknownRJump_0x1429:
	cp $A8
	jr c, UnknownRJump_0x1432
	ld a, 167
	ld [sHVelocityIndex], a


UnknownRJump_0x1432:
	call UnknownCall_0x1E7C
	jr c, UnknownRJump_0x143D
	call UnknownCall_0x1E8D
	jr c, UnknownRJump_0x1464
	ret

UnknownRJump_0x143D:
	ld a, [sCollisionTile]
	and $FC
	cp $0C
	jr nz, UnknownRJump_0x144B

	ld a, 3
	ld [sPipeTravelDirection], a


UnknownRJump_0x144B:
	ldh a, [$FFC2]
	add 1
	ldh [$FFC2], a
	ldh a, [$FFC3]
	adc 0
	ldh [$FFC3], a
	ld a, [sMarioXSub]
	inc a
	ld [sMarioXSub], a
	ld a, 255
	ld [sMarioXPushed], a
	ret

UnknownRJump_0x1464:
	ld a, [sAutoScroll]
	and a
	jr z, UnknownRJump_0x147F
	ld a, [sMarioScreenX]
	cp $12
	jr nc, UnknownRJump_0x147F
	ld a, 128
	ld [sMarioDead], a
	ld a, 15
	ld [sSfxRequest0], a
	xor a
	ld [$A53F], a

UnknownRJump_0x147F:
	ld a, [sCollisionTile]
	and $FC
	cp $0C
	jr nz, UnknownRJump_0x148D

	ld a, 3
	ld [sPipeTravelDirection], a


UnknownRJump_0x148D:
	ldh a, [$FFC2]
	sub 1
	ldh [$FFC2], a
	ldh a, [$FFC3]
	sbc 0
	ldh [$FFC3], a
	ld a, [sMarioXSub]
	dec a
	ld [sMarioXSub], a
	ld a, 255
	ld [sMarioXPushed], a
	ret

UnknownCall_0x14A6:
	xor a
	ld [sMarioDucking], a
	ld a, [sGoalBell]
	and a
	ret nz
	ldh a, [hKeysHeld]
	bit 7, a
	ret z
	ld a, [sMarioOnGround]
	and a
	ret z
	ld a, 255
	ld [sMarioDucking], a
	ret

UnknownCall_0x14BF:
	call UnknownCall_0x14D5
	ld a, [sMarioXSub]
	and a
	ret z
	cp $80
	jr nc, UnknownRJump_0x14CF
	ld [sScrollDeltaRight], a
	ret

UnknownRJump_0x14CF:
	cpl
	inc a
	ld [sScrollDeltaLeft], a
	ret

UnknownCall_0x14D5:
	ld a, [sMoonPhysics]
	and a
	jr nz, UnknownRJump_0x14E9
	ldh a, [hKeysHeld]
	and $02
	srl a
	inc a
	ld b, a

UnknownCall_0x14E3:
	ld a, [sGoalBell]
	and a
	jr z, UnknownRJump_0x14EB

UnknownRJump_0x14E9:
	ld b, 1

UnknownRJump_0x14EB:
	ld a, [sMarioWalkAnimTimer]
	add b
	ld [sMarioWalkAnimTimer], a
	cp $0C
	ret c
	xor a
	ld [sMarioWalkAnimTimer], a
	ret

UnknownCall_0x14FA:
	ld a, [sMoonPhysics]
	bit 1, a
	jr nz, UnknownRJump_0x150C
	ld a, [sFlutterTimer]
	and a
	jr z, UnknownRJump_0x150C
	dec a
	ld [sFlutterTimer], a
	ret

UnknownRJump_0x150C:
	ld a, [sMarioOnGround]
	and a
	ret nz
	ldh a, [$FFC0]
	ld [sMarioY], a
	ldh a, [$FFC1]
	ld [sMarioYU], a
	ld a, [sVVelocityIndex]
	cp $21
	jr c, UnknownRJump_0x1533
	ld a, [sNoJumpCut]
	and a
	jr nz, UnknownRJump_0x1533
	ldh a, [hKeysHeld]
	bit 0, a
	jr nz, UnknownRJump_0x1533
	ld a, 33
	ld [sVVelocityIndex], a

UnknownRJump_0x1533:
	ld a, [sVVelocityIndex]
	and a
	jr z, UnknownRJump_0x156B
	dec a
	ld [sVVelocityIndex], a
	cp $30
	jr nz, UnknownRJump_0x156B
	ld a, [sMoonPhysics]
	and a
	jr nz, UnknownRJump_0x154E
	ld a, 24
	ld [sVVelocityIndex], a
	jr UnknownRJump_0x156B

UnknownRJump_0x154E:
	ld a, [sVVelocityIndex]
	dec a
	ld [sVVelocityIndex], a
	cp $19
	jr nc, UnknownRJump_0x156B

	ld a, 24
	ld [sVVelocityIndex], a
	ldh a, [$FF97]
	and $01
	jr nz, UnknownRJump_0x156B
	ld a, 23
	ld [sVVelocityIndex], a
	jr UnknownRJump_0x156B


UnknownRJump_0x156B:
	ld hl, MarioSpeedTableVWater
	ld a, [sMoonPhysics]
	and a
	jr nz, UnknownRJump_0x1580
	ld hl, MarioSpeedTableV
	ld a, [sSwimming]
	and a
	jr z, UnknownRJump_0x1580
	ld hl, MarioSpeedTableVGoo

UnknownRJump_0x1580:
	ld a, [sVVelocityIndex]
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	add 16
	ld b, a
	ldh a, [$FFC0]
	add b
	ldh [$FFC0], a
	ldh a, [$FFC1]
	adc 0
	ldh [$FFC1], a
	ldh a, [$FFC0]
	sub 16
	ldh [$FFC0], a
	ldh a, [$FFC1]
	sbc 0
	ldh [$FFC1], a
	ld a, [sVVelocityIndex]
	cp $19
	jr nc, UnknownRJump_0x15B6
	ld a, [sMarioOnGround]
	and a
	jr z, UnknownRJump_0x1609

	ld a, 24
	ld [sVVelocityIndex], a
	jr UnknownRJump_0x1609


UnknownRJump_0x15B6:
	call UnknownCall_0x1DFE
	jr c, UnknownRJump_0x15CF

UnknownRJump_0x15BB:
	ldh a, [$FFC1]
	cp $FF
	jr nz, UnknownRJump_0x1609
	ldh a, [$FFC0]
	add 1
	ldh [$FFC0], a
	ldh a, [$FFC1]
	adc 0
	ldh [$FFC1], a
	jr UnknownRJump_0x15BB

UnknownRJump_0x15CF:
	ld a, [sMarioY]
	ldh [$FFC0], a
	ld a, [sMarioYU]
	ldh [$FFC1], a
	xor a
	ld [sMoonFloatTimer], a
	ld a, 24
	ld [sVVelocityIndex], a
	ld a, [sMoonPhysics]
	and $0F
	jr nz, UnknownRJump_0x15F4
	ld a, [sSwimming]
	and a
	jr nz, UnknownRJump_0x15F4
	ld a, 2
	ld [sSfxRequest0], a

UnknownRJump_0x15F4:
	call UnknownCall_0x1993
	xor a
	ld [sPipeTravelDirection], a
	ld a, [sCollisionTile]
	and $FE
	cp $0A
	jr nz, UnknownRJump_0x1609
	ld a, 2
	ld [sPipeTravelDirection], a

UnknownRJump_0x1609:
	ret

UnknownCall_0x160A:
	ld a, [sCameraPanTimer]
	and a
	ret nz
	ld a, [sMarioOnGround]
	and a
	jr nz, UnknownRJump_0x161E
	ld a, [sSwimming]
	and a
	jp z, UnknownJump_0x16AE
	jr UnknownRJump_0x1622

UnknownRJump_0x161E:
	xor a
	ld [sMarioInAir], a

UnknownRJump_0x1622:
	ld a, [sCurPowerup]
	cp $02
	jr nz, UnknownRJump_0x1631
	ldh a, [hKeysHeld]
	bit 0, a
	jr z, UnknownRJump_0x16AE
	jr UnknownRJump_0x1637

UnknownRJump_0x1631:
	ldh a, [hKeysPressed]
	bit 0, a
	jr z, UnknownRJump_0x16AE

UnknownRJump_0x1637:
	ld a, [sGoalBell]
	and a
	jr nz, UnknownRJump_0x16AE
	ld a, 1
	ld [sJumpFlag], a
	ld a, 1
	ld [sSfxRequest0], a
	ld a, [sMoonPhysics]
	and $0F
	jr z, UnknownRJump_0x1659
	bit 1, a
	jr nz, UnknownRJump_0x165F
	ld a, 18
	ld [sSfxRequest0], a
	jr UnknownRJump_0x1664

UnknownRJump_0x1659:
	ld a, [sSwimming]
	and a
	jr z, UnknownRJump_0x1664

UnknownRJump_0x165F:
	ld a, 3
	ld [sSfxRequest0], a

UnknownRJump_0x1664:
	ld a, [sCurPowerup]
	cp $02
	jr z, UnknownRJump_0x1675
	ldh a, [hKeysHeld]
	bit 7, a
	jr z, UnknownRJump_0x1675
	xor a
	ld [sSfxRequest0], a

UnknownRJump_0x1675:
	ld a, 255
	ld [sMarioInAir], a
	xor a
	ld [sMarioOnGround], a
	ld [sFlutterArmed], a
	ld a, 75
	ld [sVVelocityIndex], a
	ld a, [sCurPowerup]
	cp $02
	jr z, UnknownRJump_0x16AE
	ld a, [sHVelocityIndex]
	cp $48
	jr c, UnknownRJump_0x16AE
	cp $C0
	jr nc, UnknownRJump_0x16AE
	ldh a, [hKeysHeld]
	bit 6, a
	jr nz, UnknownRJump_0x16AE
	ld a, 48
	ld [sVVelocityIndex], a
	ld a, [sSwimming]
	and a
	jr z, UnknownRJump_0x16AE
	ld a, 72
	ld [sVVelocityIndex], a

UnknownJump_0x16AE:
UnknownRJump_0x16AE:
	ret

UnknownCall_0x16AF:
	ld a, 40
	ld [sVVelocityIndex], a
	ld a, [sCurPowerup]
	cp $02
	jr z, UnknownJump_0x16AE
	ld a, [sHVelocityIndex]
	cp $48
	jr c, UnknownJump_0x16AE
	cp $C0
	jr nc, UnknownJump_0x16AE
	ld a, 38
	ld [sVVelocityIndex], a
	ret


UnknownCall_0x16CC:
	ld a, [sSwimming]
	and a
	jr nz, UnknownRJump_0x16DE
	ld a, [sMoonPhysics]
	bit 1, a
	jr nz, UnknownRJump_0x16DE
	ld a, [sMarioOnGround]
	and a
	ret z

UnknownRJump_0x16DE:
	ld a, [sHVelocityIndex]
	and $FC
	cp $80
	jr z, UnknownRJump_0x16FB
	jr c, UnknownRJump_0x16F2
	ld a, [sHVelocityIndex]
	sub 4
	ld [sHVelocityIndex], a
	ret

UnknownRJump_0x16F2:
	ld a, [sHVelocityIndex]
	add 4
	ld [sHVelocityIndex], a
	ret

UnknownRJump_0x16FB:
	ld a, 128
	ld [sHVelocityIndex], a
	ret

UnknownCall_0x1701:
	ld a, [sGoalBell]
	and a
	jp nz, UnknownJump_0x17C5
	ld a, [sCameraPanTimer]
	and a
	ret nz
	ld a, [sMarioDucking]
	and a
	jp nz, UnknownJump_0x17C4
	ld a, [sMarioXPushed]
	and a
	jp nz, UnknownJump_0x17C4
	ldh a, [hKeysHeld]
	bit 4, a
	jr z, UnknownRJump_0x1771
	ld a, 1
	ld [sMarioDirection], a
	ld a, [sHVelocityIndex]
	add 8
	ld [sHVelocityIndex], a
	ld a, [sSwimming]
	ld b, a
	ld a, [sMarioOnGround]
	or b
	jr nz, UnknownRJump_0x1749
	ld a, [sHVelocityIndex]
	and $F0
	cp $C0
	jr nz, UnknownRJump_0x1763
	ld a, 184
	ld [sHVelocityIndex], a
	jp UnknownJump_0x17C4

UnknownRJump_0x1749:
	ld a, [sMoonPhysics]
	and a
	jr nz, UnknownRJump_0x1755
	ldh a, [hKeysHeld]
	bit 1, a
	jr nz, UnknownRJump_0x1763

UnknownRJump_0x1755:
	ld a, [sHVelocityIndex]
	cp $C0
	jr c, UnknownRJump_0x17C4
	ld a, 191
	ld [sHVelocityIndex], a
	jr UnknownRJump_0x17C4

UnknownRJump_0x1763:
	ld a, [sHVelocityIndex]
	cp $F4
	jr c, UnknownRJump_0x17C4
	ld a, 243
	ld [sHVelocityIndex], a
	jr UnknownRJump_0x17C4

UnknownRJump_0x1771:
	ldh a, [hKeysHeld]
	bit 5, a
	jr z, UnknownRJump_0x17C4
	ld a, 255
	ld [sMarioDirection], a
	ld a, [sHVelocityIndex]
	sub 8
	ld [sHVelocityIndex], a
	ld a, [sSwimming]
	ld b, a
	ld a, [sMarioOnGround]
	or b
	jr nz, UnknownRJump_0x179E
	ld a, [sHVelocityIndex]
	and $F0
	cp $40
	jr nz, UnknownRJump_0x17B8
	ld a, 72
	ld [sHVelocityIndex], a
	jr UnknownRJump_0x17C4

UnknownRJump_0x179E:
	ld a, [sMoonPhysics]
	and a
	jr nz, UnknownRJump_0x17AA
	ldh a, [hKeysHeld]
	bit 1, a
	jr nz, UnknownRJump_0x17B8

UnknownRJump_0x17AA:
	ld a, [sHVelocityIndex]
	cp $48
	jr nc, UnknownRJump_0x17C4
	ld a, 72
	ld [sHVelocityIndex], a
	jr UnknownRJump_0x17C4

UnknownRJump_0x17B8:
	ld a, [sHVelocityIndex]
	cp $08
	jr nc, UnknownRJump_0x17C4
	ld a, 8
	ld [sHVelocityIndex], a

UnknownJump_0x17C4:
UnknownRJump_0x17C4:
	ret

UnknownJump_0x17C5:
	ld a, 1
	ld [sMarioDirection], a
	ld a, 128
	ld [sHVelocityIndex], a
	ld a, [sMarioOnGround]
	and a
	ret z
	ld a, 184
	ld [sHVelocityIndex], a
	ret

UnknownCall_0x17DA:
	ldh a, [hKeysHeld]
	bit 4, a
	jr z, UnknownRJump_0x17FB
	ld a, 1
	ld [sMarioDirection], a
	ld a, [sHVelocityIndex]
	add 8
	ld [sHVelocityIndex], a
	ld a, [sHVelocityIndex]
	cp $A8
	jr c, UnknownJump_0x17C4
	ld a, 167
	ld [sHVelocityIndex], a
	jr UnknownJump_0x17C4

UnknownRJump_0x17FB:
	ldh a, [hKeysHeld]
	bit 5, a
	jr z, UnknownJump_0x17C4
	ld a, 255
	ld [sMarioDirection], a
	ld a, [sHVelocityIndex]
	sub 8
	ld [sHVelocityIndex], a
	ld a, [sHVelocityIndex]
	cp $60
	jr nc, UnknownJump_0x17C4
	ld a, 96
	ld [sHVelocityIndex], a
	jr UnknownJump_0x17C4


UnknownCall_0x181C:
	ldh a, [$FFC2]
	ld [sMarioX], a
	ldh a, [$FFC3]
	ld [sMarioXU], a
	ld a, [sGoalBell]
	and a
	jr nz, UnknownRJump_0x1842
	ld hl, MarioSpeedTableHWater
	ld a, [sSwimming]
	and a
	jr nz, UnknownRJump_0x1845
	ld a, [sMoonPhysics]
	bit 1, a
	jr z, UnknownRJump_0x1842
	ld a, [sMarioOnGround]
	and a
	jr nz, UnknownRJump_0x1845

UnknownRJump_0x1842:
	ld hl, MarioSpeedTableH

UnknownRJump_0x1845:
	ld a, [sHVelocityIndex]
	ld e, a
	ldh a, [$FF97]
	and $07
	add e
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld b, a
	ld a, [sMarioXSub]
	ld [sMarioXSubSaved], a
	add b
	ld [sMarioXSub], a
	add 16
	ld b, a
	ldh a, [$FFC2]
	add b
	ldh [$FFC2], a
	ldh a, [$FFC3]
	adc 0
	ldh [$FFC3], a
	ldh a, [$FFC2]
	sub 16
	ldh [$FFC2], a
	ldh a, [$FFC3]
	sbc 0
	ldh [$FFC3], a
	ld a, [sMarioXSub]
	bit 7, a
	jr nz, UnknownRJump_0x1886
	call UnknownCall_0x1E8D
	jr nc, UnknownRJump_0x18AE
	jr UnknownRJump_0x188B

UnknownRJump_0x1886:
	call UnknownCall_0x1E7C
	jr nc, UnknownRJump_0x18AE

UnknownRJump_0x188B:
	ld a, [sMarioX]
	ldh [$FFC2], a
	ld a, [sMarioXU]
	ldh [$FFC3], a
	ld a, [sMarioXSubSaved]
	ld [sMarioXSub], a
	ld a, 128
	ld [sHVelocityIndex], a
	ld a, [sCollisionTile]
	and $FC
	cp $0C
	jr nz, UnknownRJump_0x18AE
	ld a, 3
	ld [sPipeTravelDirection], a

UnknownRJump_0x18AE:
	ret

MarioSpeedTableV: ;$18AF
	db $03, $03, $02, $02, $03, $02, $02, $02, $01, $02, $01, $01, $02, $01, $01, $01
	db $01, $00, $01, $00, $01, $00, $00, $01, $00, $FF, $00, $FF, $00, $FF, $FE, $FF
	db $FE, $FE, $FE, $FD, $FE, $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FE, $FD, $FD, $FD
	db $FD, $FF, $FF, $FE, $FF, $FE, $FD, $FE, $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FD
	db $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FD

MarioSpeedTableVGoo: ;$18FB
	db $01, $01, $01, $00, $01, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $FF, $00
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $00, $00, $FF, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
		
MarioSpeedTableVWater: ;$1947 Also used for outer space and hippo bubble
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $00, $01, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $FF, $00
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

UnknownCall_0x1993:
	xor a
	ld [sSpinJumpBounce], a
	ld a, [sCollisionTile]
	cp $7E
	jr z, UnknownRJump_0x19AC
	cp $04
	ret nc
	and a
	jr z, UnknownRJump_0x19B0
	cp $01
	jr z, UnknownRJump_0x19D2
	cp $03
	jr z, UnknownRJump_0x19C1

UnknownRJump_0x19AC:
	ld b, 3
	jr UnknownRJump_0x19F1

UnknownRJump_0x19B0:
	ld b, 2
	ld a, [sCurPowerup]
	and a
	jr z, UnknownRJump_0x19F1
	ld a, 1
	ld [sSfxRequest2], a
	ld b, 1
	jr UnknownRJump_0x19F1

UnknownRJump_0x19C1:
	ld b, 6
	ld a, [sCurPowerup]
	and a
	jr z, UnknownRJump_0x19F1
	ld a, 1
	ld [sSfxRequest2], a
	ld b, 5
	jr UnknownRJump_0x19F1

UnknownRJump_0x19D2:
	ld a, 255
	ld [sSpinJumpBounce], a
	ld a, 2
	ld [sSfxRequest0], a
	ld b, 3
	call UnknownCall_0x2C6C
	ld a, [sObjectBumpSpecial]
	and a
	ret nz
	ld b, 4
	call UnknownCall_0x2C77
	ld a, 7
	ld [sSfxRequest0], a
	ret

UnknownRJump_0x19F1:
	ld a, 2
	ld [sSfxRequest0], a
	call UnknownCall_0x2C6C
	ld a, 255
	ld [sSpinJumpBounce], a
	ret

MarioSpeedTableH: ;$19FF
	db $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF
	db $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF
	db $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF, $FE, $FF
	db $FE, $FF, $FF, $FE, $FF, $FF, $FE, $FF, $FE, $FF, $FF, $FF, $FE, $FF, $FF, $FF
	db $FE, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $00, $FF, $FF, $FF, $00, $FF, $FF, $00, $FF, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FF, $00, $00, $FF, $00
	db $FF, $00, $00, $00, $FF, $00, $00, $00, $FF, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00
	db $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $01, $00, $00, $01, $00
	db $01, $00, $01, $00, $01, $00, $01, $00, $01, $01, $00, $01, $01, $00, $01, $00
	db $01, $01, $01, $00, $01, $01, $01, $00, $01, $01, $01, $01, $01, $01, $01, $01
	db $02, $01, $01, $01, $01, $01, $01, $01, $02, $01, $01, $01, $02, $01, $01, $01
	db $02, $01, $01, $02, $01, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01
	db $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01
	db $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01, $02, $01

MarioSpeedTableHWater: ;$1AFF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $FF, $FF, $00
	db $FF, $FF, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $00, $FF, $00, $00, $FF, $00, $FF, $00, $00, $00, $FF, $00, $00, $00
	db $FF, $00, $00, $00, $FF, $00, $00, $00, $FF, $00, $00, $00, $FF, $00, $00, $00
	db $FF, $00, $00, $00, $FF, $00, $00, $00, $FF, $00, $00, $00, $00, $00, $00, $00
	db $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00
	db $01, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00
	db $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00
	db $01, $00, $00, $01, $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00
	db $01, $01, $00, $01, $01, $00, $01, $00, $01, $01, $01, $00, $01, $01, $01, $00
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01

UnknownCall_0x1BFF:
	push hl
	push de
	push bc
	ld a, [sSwimming]
	ld [sPrevSwimming], a
	xor a
	ld [sSwimming], a
	ldh a, [$FFC2]
	add 16
	ldh [$FFB9], a
	ldh a, [$FFC3]
	adc 0
	ldh [$FFBA], a
	ld a, [sCurPowerup]
	and a
	jr z, UnknownRJump_0x1C39
	ld a, [sMarioDucking]
	and a
	jr nz, UnknownRJump_0x1C39
	ldh a, [$FFC0]
	add 22
	ldh [$FFB7], a
	ldh a, [$FFC1]
	adc 0
	ldh [$FFB8], a
	call UnknownCall_0x1EFA
	and $FE
	cp $50
	jr z, UnknownRJump_0x1C4E

UnknownRJump_0x1C39:
	ldh a, [$FFC0]
	add 28
	ldh [$FFB7], a
	ldh a, [$FFC1]
	adc 0
	ldh [$FFB8], a
	call UnknownCall_0x1EFA
	and $FE
	cp $50
	jr nz, UnknownRJump_0x1C82

UnknownRJump_0x1C4E:
	ld a, [sInvincibilityTimer]
	ld b, a
	ld a, [sStarTimerHigh]
	or b
	jr nz, UnknownRJump_0x1C6D
	ld a, 15
	ld [sMarioDead], a
	ld a, 20
	ld [sSfxRequest0], a
	ld a, [sCurPowerup]
	and a
	jr nz, UnknownRJump_0x1C6D
	ld a, 15
	ld [sSfxRequest0], a

UnknownRJump_0x1C6D:
	ld a, [sMarioScreenY]
	cp $80
	jp c, UnknownJump_0x1D71
	ld a, 128
	ld [sMarioDead], a
	ld a, 15
	ld [sSfxRequest0], a
	jp UnknownJump_0x1D71

UnknownRJump_0x1C82:
	ld a, [sCollisionTile]
	and $FC
	cp $4C
	jr nz, UnknownRJump_0x1CBA
	ld a, [sPrevSwimming]
	and a
	jr nz, UnknownRJump_0x1C9F
	ld a, [sVVelocityIndex]
	cp $18
	jr nc, UnknownRJump_0x1C9F
	ld a, 24
	ld [sVVelocityIndex], a
	jr UnknownRJump_0x1CAA

UnknownRJump_0x1C9F:
	ld a, [sVVelocityIndex]
	cp $18
	jr nc, UnknownRJump_0x1CAA
	xor a
	ld [sMarioInAir], a

UnknownRJump_0x1CAA:
	ld a, 255
	ld [sSwimming], a
	ld a, [sMoonPhysics]
	res 1, a
	ld [sMoonPhysics], a
	jp UnknownJump_0x1D71

UnknownRJump_0x1CBA:
	ld a, [sCollisionTile]
	and $FE
	cp $4A
	jr nz, UnknownRJump_0x1CFB
	xor a
	ld [$A53F], a
	xor a
	ld [sExitTileFlag], a
	ld a, [sCollisionTile]
	cp $4A
	jr z, UnknownRJump_0x1CD7
	ld a, 255
	ld [sExitTileFlag], a

UnknownRJump_0x1CD7:
	ld a, 3
	ld [sMusicRequest], a
	xor a
	ld [sSfxRequest0], a
	ld [sSfxRequest2], a
	ld [sSfxRequest1], a
	ld a, 24
	ldh [$FF9B], a
	ld a, 192
	ld [sFadeTimerLow], a
	xor a
	ld [sFadeTimerHigh], a
	ld [sSecretRouteFlag], a
	ld [sTileAnimConfig], a
	jr UnknownRJump_0x1D71

UnknownRJump_0x1CFB:
	ld a, [sMoonPhysics]
	and $02
	ld b, a
	ld a, [sMoonPhysics]
	res 1, a
	ld [sMoonPhysics], a
	ld a, [sCollisionTile]
	cp $52
	jr c, UnknownRJump_0x1D28
	cp $58
	jr nc, UnknownRJump_0x1D28
	ld a, [sMoonPhysics]
	set 1, a
	ld [sMoonPhysics], a
	xor a
	ld [sFlutterArmed], a
	ld a, [sMoonPhysics]
	res 2, a
	ld [sMoonPhysics], a

UnknownRJump_0x1D28:
	ld a, [sMoonPhysics]
	and $02
	cp b
	jr z, UnknownRJump_0x1D71
	ld a, [sHVelocityIndex]
	cp $C0
	jr c, UnknownRJump_0x1D3C
	ld a, 191
	ld [sHVelocityIndex], a

UnknownRJump_0x1D3C:
	ld a, [sHVelocityIndex]
	cp $48
	jr nc, UnknownRJump_0x1D48
	ld a, 72
	ld [sHVelocityIndex], a

UnknownRJump_0x1D48:
	call UnknownCall_0x3735
	ld a, [sMoonPhysics]
	bit 1, a
	jr nz, UnknownRJump_0x1D71
	ldh a, [hKeysHeld]
	bit 6, a
	jr nz, UnknownRJump_0x1D64
	ld a, 70
	ld [sVVelocityIndex], a
	ld a, 255
	ld [sMarioInAir], a
	jr UnknownRJump_0x1D71

UnknownRJump_0x1D64:
	ld a, 70
	ld [sVVelocityIndex], a
	ld a, 255
	ld [sMarioInAir], a
	ld [sNoJumpCut], a

UnknownJump_0x1D71:
UnknownRJump_0x1D71:
	pop bc
	pop de
	pop hl
	ret

UnknownCall_0x1D75:
	ld a, [sCollisionTile]
	and $FE
	cp $48
	jr nz, UnknownRJump_0x1DA4
	ld a, 7
	ld [sSfxRequest0], a
	call UnknownCall_0x1DA5
	ld a, [sCoinLow]
	inc a
	daa
	ld [sCoinLow], a
	ld a, [sCoinHigh]
	adc 0
	ld [sCoinHigh], a
	cp $0A
	jr c, UnknownRJump_0x1DA4

	ld a, 153
	ld [sCoinLow], a
	ld a, 9
	ld [sCoinHigh], a


UnknownRJump_0x1DA4:
	ret

UnknownCall_0x1DA5:
	ld a, [sCollisionTile]
	cp $48
	jr nz, UnknownRJump_0x1DD5
	ld d, 96
	call UnknownCall_0x2C0D
	call UnknownCall_0x200C
	ld a, [sCollisionTilePtrLow]
	and $DE
	ld l, a
	ld a, [sCollisionTilePtrHigh]
	ld h, a
	ld de, $001F

UnknownRJump_0x1DC1:
	ldh a, [rSTAT]
	and $03
	jr nz, UnknownRJump_0x1DC1

UnknownRJump_0x1DC7:
	ldh a, [rSTAT]
	and $03
	jr nz, UnknownRJump_0x1DC7
	ld a, 255
	ld [hli], a
	ld [hl], a
	add hl, de
	ld [hli], a
	ld [hl], a
	ret

UnknownRJump_0x1DD5:
	ld d, 127
	call UnknownCall_0x2C0D
	call UnknownCall_0x200C
	ld a, [sCollisionTilePtrLow]
	and $DE
	ld l, a
	ld a, [sCollisionTilePtrHigh]
	ld h, a
	ld de, $001F

UnknownRJump_0x1DEA:
	ldh a, [rSTAT]
	and $03
	jr nz, UnknownRJump_0x1DEA

UnknownRJump_0x1DF0:
	ldh a, [rSTAT]
	and $03
	jr nz, UnknownRJump_0x1DF0
	ld a, 127
	ld [hli], a
	ld [hl], a
	add hl, de
	ld [hli], a
	ld [hl], a
	ret

UnknownCall_0x1DFE:
	push hl
	push de
	push bc
	ldh a, [$FFC2]
	add 16
	ldh [$FFB9], a
	ldh a, [$FFC3]
	adc 0
	ldh [$FFBA], a
	ld a, [sCurPowerup]
	and a
	jr nz, UnknownRJump_0x1E17
	ld b, 28
	jr UnknownRJump_0x1E19

UnknownRJump_0x1E17:
	ld b, 18

UnknownRJump_0x1E19:
	ldh a, [$FFC0]
	add b
	ldh [$FFB7], a
	ldh a, [$FFC1]
	adc 0
	ldh [$FFB8], a
	call UnknownCall_0x1EFA
	cp $7E
	jr z, UnknownRJump_0x1E31
	cp $38
	pop bc
	pop de
	pop hl
	ret

UnknownRJump_0x1E31:
	scf
	pop bc
	pop de
	pop hl
	ret

UnknownCall_0x1E36:
	push hl
	push de
	push bc
	jr UnknownRJump_0x1E48

UnknownCall_0x1E3B:
	push hl
	push de
	push bc
	ldh a, [$FFC0]
	sub 4
	and $0F
	cp $05
	jr nc, UnknownRJump_0x1E78

UnknownRJump_0x1E48:
	ldh a, [$FFC0]
	add 44
	ldh [$FFB7], a
	ldh a, [$FFC1]
	adc 0
	ldh [$FFB8], a
	ldh a, [$FFC2]
	add 12
	ldh [$FFB9], a
	ldh a, [$FFC3]
	adc 0
	ldh [$FFBA], a
	call UnknownCall_0x1EFA
	cp $48
	jr c, UnknownRJump_0x1E78
	ldh a, [$FFC2]
	add 20
	ldh [$FFB9], a
	ldh a, [$FFC3]
	adc 0
	ldh [$FFBA], a
	call UnknownCall_0x1EFA
	cp $48

UnknownRJump_0x1E78:
	pop bc
	pop de
	pop hl
	ret

UnknownCall_0x1E7C:
	push hl
	push de
	push bc
	ldh a, [$FFC2]
	add 11
	ldh [$FFB9], a
	ldh a, [$FFC3]
	adc 0
	ldh [$FFBA], a
	jr UnknownRJump_0x1E9C

UnknownCall_0x1E8D:
	push hl
	push de
	push bc
	ldh a, [$FFC2]
	add 20
	ldh [$FFB9], a
	ldh a, [$FFC3]
	adc 0
	ldh [$FFBA], a

UnknownRJump_0x1E9C:
	ld a, [sCurPowerup]
	and a
	jr z, UnknownRJump_0x1EBE
	ld a, [sMarioDucking]
	and a
	jr nz, UnknownRJump_0x1EBE
	ldh a, [$FFC0]
	add 20
	ldh [$FFB7], a
	ldh a, [$FFC1]
	adc 0
	ldh [$FFB8], a
	call UnknownCall_0x1EFA
	cp $38
	jr c, UnknownRJump_0x1EF0
	call UnknownCall_0x1D75

UnknownRJump_0x1EBE:
	ldh a, [$FFC0]
	add 32
	ldh [$FFB7], a
	ldh a, [$FFC1]
	adc 0
	ldh [$FFB8], a
	call UnknownCall_0x1EFA
	cp $38
	jr c, UnknownRJump_0x1EF0
	call UnknownCall_0x1D75
	ldh a, [$FFC0]
	add 40
	ldh [$FFB7], a
	ldh a, [$FFC1]
	adc 0
	ldh [$FFB8], a
	call UnknownCall_0x1EFA
	cp $38
	jr c, UnknownRJump_0x1EF0
	call UnknownCall_0x1D75
	scf
	ccf
	pop bc
	pop de
	pop hl
	ret

UnknownRJump_0x1EF0:
	scf
	pop bc
	pop de
	pop hl
	ret

UnknownCall_0x1EF5:
	ld a, 64
	cp $38
	ret


UnknownCall_0x1EFA:
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
	ld a, [hl]
	ld [sCollisionTile], a
	ret

UnknownCall_0x1F2F:
	ldh a, [$FFB8]
	and $0F
	swap a
	ld h, a
	ldh a, [$FFB7]
	and $F0
	swap a
	or h
	add 176
	ld h, a
	ldh a, [$FFBA]
	and $0F
	swap a
	ld l, a
	ldh a, [$FFB9]
	and $F0
	swap a
	or l
	ld l, a
	ld a, [hl]
	ret

UnknownData_0x1F51:
LevelPropertiesUNK: ;$1F51 1 byte per level (unknown)
	db $00, $00, $08, $08, $08, $08, $08, $00
	db $00, $00, $08, $00, $00, $00, $00, $08
	db $00, $00, $08, $08, $00, $00, $00, $00
	db $08, $00, $00, $00, $08, $00, $00, $08

LevelPropertiesScroll: ;$1F71 1 byte per level (Auto-Scroll)
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $01, $00, $00, $00, $00
	db $00, $01, $00, $00, $00, $00, $01, $00
	
LevelPropertiesSpace: ;$1F91 1 byte per level (Space Physics)
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $08, $01, $00, $00, $00, $00
	db $00, $00, $00, $00, $08, $00, $00, $00

UnknownCall_0x1FB1:
	call UnknownCall_0x200C
	ld a, [sSavedLCDC]
	and $08
	jr z, UnknownRJump_0x1FC2
	ld a, 4
	add h
	ld h, a
	ld [sCollisionTilePtrHigh], a

UnknownRJump_0x1FC2:
	ldh a, [rSTAT]
	and $03
	jr nz, UnknownRJump_0x1FC2
	ld b, [hl]

UnknownRJump_0x1FC9:
	ldh a, [rSTAT]
	and $03
	jr nz, UnknownRJump_0x1FC9
	ld a, [hl]
	and b
	ret


ReadJoypad: ;$1FD2
	ldh a, [hKeysHeld]
	ld [sPrevKeysHeld], a
	ld a, 32
	ldh [rP1], a
	ldh a, [rP1]
	ldh a, [rP1]
	cpl
	and $0F
	swap a
	ld b, a
	ld a, 16
	ldh [rP1], a
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	cpl
	and $0F
	or b
	ld c, a
	ldh a, [hKeysHeld]
	xor c
	and c
	ldh [hKeysPressed], a
	ld a, c
	ldh [hKeysHeld], a
	ld a, 48
	ldh [rP1], a
	ret

UnknownCall_0x200C:
	ldh a, [$FFB7]
	sub 16
	ld b, 8
	ld de, $0020
	ld hl, $97E0

UnknownRJump_0x2018:
	add hl, de
	sub b
	jr nc, UnknownRJump_0x2018
	ldh a, [$FFB9]
	sub b
	srl a
	srl a
	srl a
	add l
	ld l, a
	ld [sCollisionTilePtrLow], a
	ld a, h
	ld [sCollisionTilePtrHigh], a
	ret

UnknownCall_0x202F:
	ld a, [sCollisionTilePtrHigh]
	ld d, a
	ld a, [sCollisionTilePtrLow]
	ld e, a
	ld b, 4

UnknownRJump_0x2039:
	rr d
	rr e
	dec b
	jr nz, UnknownRJump_0x2039
	ld a, e
	sub 132
	and $FE
	rlca
	rlca
	add 8
	ldh [$FFB7], a
	ld a, [sCollisionTilePtrLow]
	and $1F
	rla
	rla
	rla
	add 8
	ldh [$FFB9], a
	ret

OAMDMARoutine: ;copied to $FFA0 by Init and called from VBlank (runs from HRAM)
	ld a, 161
	ldh [rDMA], a
	ld a, 40

UnknownRJump_0x205E:
	dec a
	jr nz, UnknownRJump_0x205E
	ret


UnknownCall_0x2062:
	ld b, 0
	ld a, [sCameraPanTimer]
	and a
	jr z, UnknownRJump_0x206D
	and $03
	ld b, a

UnknownRJump_0x206D:
	ldh a, [$FFC8]
	sub 72
	sub b
	ld [sScrollY], a
	ldh a, [$FFCA]
	sub 80
	ld [sScrollX], a
	ret

UnknownCall_0x207D:
	ld a, 4 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x10000
	ret

UpdateSound: ;$2089
	ld a, [sSoundDisabled]
	and a
	ret nz
	ld a, 4 ;prepare bank switch
	ld [$2100], a
	call _UpdateSound
	ret

UnknownCall_0x2097:
	ret

UnknownCall_0x2098:
	ld a, 4 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownRJump_0x10003
	ret


UnknownCall_0x20A4:
	ld a, [sSceneId]
	ld b, a
	ld a, [sSceneIdHi]
	or b
	jp z, UnknownJump_0x21EE
	ld a, [sSavedOAMIndex]
	ldh [$FF8D], a
	call UnknownCall_0x2CFF
	call UnknownCall_0x2728
	call $FFA0
	ld a, 5 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, [sSceneId]
	ld e, a
	ld d, 0
	sla e
	rl d
	ld hl, $4125
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld a, e
	ld l, a

UnknownJump_0x20D9:
	ld a, 5 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, [hl]
	cp $FF
	jp nz, UnknownJump_0x20EB
	inc hl
	jp UnknownJump_0x21EE

UnknownJump_0x20EB:
	and $F0
	cp $20
	jr nz, UnknownRJump_0x210E
	ld a, 15
	ld [sSceneState], a
	ld a, 1
	ld [sFadeTimerHigh], a
	ld a, 96
	ld [sFadeTimerLow], a
	xor a
	ld [sTileAnimConfig], a
	ld [sStarTimerHigh], a
	ld [sStarTimerLow], a
	inc hl
	jp UnknownJump_0x21E8

UnknownRJump_0x210E:
	cp $80
	jr nz, UnknownRJump_0x211E
	ld a, [hl]
	and $0F
	or $F0
	ld [sBossDefeated], a
	inc hl
	jp UnknownJump_0x21E8

UnknownRJump_0x211E:
	cp $30
	jr nz, UnknownRJump_0x214F
	ld a, [hl]
	and $0F
	jr nz, UnknownRJump_0x2131
	inc hl
	ld a, [hli]
	ldh [$FFC8], a
	ld a, [hli]
	ldh [$FFC0], a
	jp UnknownJump_0x21E8

UnknownRJump_0x2131:
	inc hl
	ld a, [hli]
	ld b, a
	ldh a, [$FFC8]
	add b
	ldh [$FFC8], a
	ldh a, [$FFC9]
	adc 0
	ldh [$FFC9], a
	ld a, [hli]
	ld b, a
	ldh a, [$FFC0]
	add b
	ldh [$FFC0], a
	ldh a, [$FFC1]
	adc 0
	ldh [$FFC1], a
	jp UnknownJump_0x21E8


UnknownRJump_0x214F:
	cp $50
	jr nz, UnknownRJump_0x2162

	ld a, 255
	ld [sBGPalette], a
	ld [sOAMPalette1], a
	ld [sOAMPalette2], a
	inc hl
	jp UnknownJump_0x21E8


UnknownRJump_0x2162:
	cp $60
	jr nz, UnknownRJump_0x216C
	call UnknownCall_0x25AF
	jp UnknownJump_0x21E8

UnknownRJump_0x216C:
	cp $B0
	jr nz, UnknownRJump_0x217E
	xor a
	ld [sSceneVramFlag], a
	ld a, 136
	ldh [rWY], a
	call UnknownCall_0x2202
	jp UnknownJump_0x21E8

UnknownRJump_0x217E:
	cp $00
	jr nz, UnknownRJump_0x218C

	ld a, 136
	ldh [rWY], a
	call UnknownCall_0x226D
	jp UnknownJump_0x21E8


UnknownRJump_0x218C:
	cp $10
	jr nz, UnknownRJump_0x2198

	inc hl
	ld a, [hli]
	ld [sLevelBGPalette], a
	jp UnknownJump_0x21E8


UnknownRJump_0x2198:
	cp $40
	jr nz, UnknownRJump_0x21A7
	call UnknownCall_0x2323
	ld a, 1
	ld [sSceneTransitionFlag], a
	jp UnknownJump_0x21E8

UnknownRJump_0x21A7:
	cp $A0
	jr nz, UnknownJump_0x21E8
	inc hl
	push hl
	call UnknownCall_0x2728
	call UnknownCall_0x2728
	call UnknownCall_0x2728
	call UnknownCall_0x2728
	ld a, 47
	ld [sFadeTimerLow], a

UnknownRJump_0x21BE:
	ld hl, UnknownData_0x21E5
	ld a, [sFadeTimerLow]
	and $F0
	swap a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hl]
	ld [sBGPalette], a
	ld [sOAMPalette1], a
	call UnknownCall_0x2728
	ld a, [sFadeTimerLow]
	cp $0E
	jr nc, UnknownRJump_0x21BE
	pop hl
	xor a
	ld [sFadeTimerLow], a
	jp UnknownJump_0x21E8

UnknownData_0x21E5:
;BGP/OBP0 fade values for the loop above, indexed by ($A266 & $F0) >> 4
	db $FF, $FB, $E7


UnknownJump_0x21E8:
	call UnknownCall_0x2728
	jp UnknownJump_0x20D9

UnknownJump_0x21EE:
	ld a, [sSceneTransitionFlag]
	ld [sSceneTransitionLatch], a
	xor a
	ld [sSceneId], a
	ld [sSceneIdHi], a
	ld [sSceneTransitionFlag], a
	ld [sSceneDoneFlag], a
	ret

UnknownCall_0x2202:
	ld a, [hli]
	and $0F
	ld b, a
	cp $01
	jr z, UnknownRJump_0x224E
	cp $03
	jr z, UnknownRJump_0x222E
	ld a, [hli]
	ld [sCurROMBank], a
	ld [sVRAMTransferBank], a
	ld a, [hli]
	ldh [$FFB1], a
	ld a, [hli]
	ldh [$FFB2], a
	ld a, 0
	ldh [$FFB3], a
	ld a, 139
	ldh [$FFB4], a
	ld a, 128
	ldh [$FFB5], a
	ld a, 3
	ldh [$FFB6], a
	jp UnknownJump_0x22B9

UnknownRJump_0x222E:
	ld a, [hli]
	ld [sCurROMBank], a
	ld [sVRAMTransferBank], a
	ld a, [hli]
	ldh [$FFB1], a
	ld a, [hli]
	ldh [$FFB2], a
	ld a, 0
	ldh [$FFB3], a
	ld a, 139
	ldh [$FFB4], a
	ld a, 0
	ldh [$FFB5], a
	ld a, 4
	ldh [$FFB6], a
	jp UnknownJump_0x22B9


UnknownRJump_0x224E:
	ld a, [hli]
	ld [sCurROMBank], a
	ld [sVRAMTransferBank], a
	ld a, [hli]
	ldh [$FFB1], a
	ld a, [hli]
	ldh [$FFB2], a
	ld a, 0
	ldh [$FFB3], a
	ld a, 146
	ldh [$FFB4], a
	ld a, 0
	ldh [$FFB5], a
	ld a, 6
	ldh [$FFB6], a
	jr UnknownJump_0x22B9

UnknownCall_0x226D:
	ld a, [hli]
	and $0F
	ld b, a
	cp $01
	jr z, UnknownRJump_0x2297
	cp $02
	jr z, UnknownRJump_0x2297
	ld a, [hli]
	ld [sCurROMBank], a
	ld [sVRAMTransferBank], a
	ld [$2100], a
	ld a, [hli]
	ldh [$FFB1], a
	ld a, [hli]
	ldh [$FFB2], a
	ld a, [hli]
	ldh [$FFB3], a
	ld a, [hli]
	ldh [$FFB4], a
	ld a, [hli]
	ldh [$FFB5], a
	ld a, [hli]
	ldh [$FFB6], a
	jr UnknownJump_0x22B9

UnknownRJump_0x2297:
	ld a, [hli]
	ld [sCurROMBank], a
	ld [sVRAMTransferBank], a
	ld [$2100], a
	ld a, [hli]
	ldh [$FFB1], a
	ld [sVramTransferSrcLo], a
	ld a, [hli]
	ldh [$FFB2], a
	ld [sVramTransferSrcHi], a
	ld a, [hli]
	ldh [$FFB3], a
	ld a, [hli]
	ldh [$FFB4], a
	ld a, [hli]
	ldh [$FFB5], a
	ld a, [hli]
	ldh [$FFB6], a


UnknownJump_0x22B9:
	ld a, 255
	ld [sVRAMTransferActive], a

UnknownRJump_0x22BE:
	ld a, [sVramPumpFlag]
	and a
	jr z, UnknownRJump_0x22D5

	call UnknownCall_0x2D0A
	call UnknownCall_0x0652
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x2CFF


UnknownRJump_0x22D5:
	call UnknownCall_0x2728
	ld a, [sVRAMTransferActive]
	and a
	jr nz, UnknownRJump_0x22BE
	ret

UnknownCall_0x22DF:
	ld a, [hli]
	ld [sCurROMBank], a
	ld [sVRAMTransferBank], a
	ld [$2100], a
	ld a, [hli]
	ldh [$FFB1], a
	ld a, [hli]
	ldh [$FFB2], a
	ld a, [hli]
	ldh [$FFB3], a
	ld a, [hli]
	ldh [$FFB4], a
	ld a, [hli]
	ldh [$FFB5], a
	ld a, [hli]
	ldh [$FFB6], a
	ld a, 255
	ld [sVRAMTransferActive], a

UnknownRJump_0x2300:
	ld a, 128
	ldh [rWY], a
	call UnknownCall_0x2D0A
	call UnknownCall_0x0652
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x2CFF
	call UnknownCall_0x2728
	ldh a, [$FFB4]
	cp $85
	jr c, UnknownRJump_0x2300
	xor a
	ld [sVramPumpFlag], a
	ret


UnknownCall_0x2323:
	inc hl
	ld a, [hl]
	swap a
	and $0F
	ldh [$FFC9], a
	ldh [$FFC1], a
	ld a, [hli]
	and $0F
	ldh [$FFCB], a
	ldh [$FFC3], a
	push hl
	call UnknownCall_0x2728
	ld a, [sScreenTransition]
	cp $01
	jr z, UnknownRJump_0x2359
	ld a, [sScreenTransition]
	cp $02
	jp z, UnknownJump_0x23E4
	ld a, [sScreenTransition]
	cp $04
	jp z, UnknownJump_0x2524
	ld a, [sScreenTransition]
	cp $08
	jp z, UnknownJump_0x246F

	pop hl
	ret


UnknownRJump_0x2359:
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFCA]
	add 80
	ldh [$FFCE], a
	ldh a, [$FFCB]
	adc 0
	and $0F
	ldh [$FFCF], a
	ldh a, [$FFC8]
	sub 116
	ldh [$FFCC], a
	ldh a, [$FFC9]
	sbc 0
	and $0F
	ldh [$FFCD], a
	call UnknownCall_0x0A35
	call UnknownCall_0x2728
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFCA]
	add 96
	ldh [$FFCE], a
	ldh a, [$FFCB]
	adc 0
	and $0F
	ldh [$FFCF], a
	call UnknownCall_0x0A35
	call UnknownCall_0x2728
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFCA]
	add 112
	ldh [$FFCE], a
	ldh a, [$FFCB]
	adc 0
	and $0F
	ldh [$FFCF], a
	call UnknownCall_0x0A35
	pop hl
	ret

UnknownJump_0x23E4:
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFCA]
	sub 96
	ldh [$FFCE], a
	ldh a, [$FFCB]
	sbc 0
	and $0F
	ldh [$FFCF], a
	ldh a, [$FFC8]
	sub 116
	ldh [$FFCC], a
	ldh a, [$FFC9]
	sbc 0
	and $0F
	ldh [$FFCD], a
	call UnknownCall_0x0A35
	call UnknownCall_0x2728
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFCA]
	sub 112
	ldh [$FFCE], a
	ldh a, [$FFCB]
	sbc 0
	and $0F
	ldh [$FFCF], a
	call UnknownCall_0x0A35
	call UnknownCall_0x2728
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFCA]
	sub 128
	ldh [$FFCE], a
	ldh a, [$FFCB]
	sbc 0
	and $0F
	ldh [$FFCF], a
	call UnknownCall_0x0A35
	pop hl
	ret

UnknownJump_0x246F:
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFCA]
	sub 128
	ldh [$FFCE], a
	ldh a, [$FFCB]
	sbc 0
	and $0F
	ldh [$FFCF], a
	ldh a, [$FFC8]
	add 120
	ldh [$FFCC], a
	ldh a, [$FFC9]
	adc 0
	and $0F
	ldh [$FFCD], a
	call UnknownCall_0x0969
	call UnknownCall_0x2728
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFC8]
	add 104
	ldh [$FFCC], a
	ldh a, [$FFC9]
	adc 0
	and $0F
	ldh [$FFCD], a
	call UnknownCall_0x0969
	call UnknownCall_0x2728
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFC8]
	add 88
	ldh [$FFCC], a
	ldh a, [$FFC9]
	adc 0
	and $0F
	ldh [$FFCD], a
	call UnknownCall_0x0969
	call UnknownCall_0x2728
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFC8]
	add 72
	ldh [$FFCC], a
	ldh a, [$FFC9]
	adc 0
	and $0F
	ldh [$FFCD], a
	call UnknownCall_0x0969
	pop hl
	ret

UnknownJump_0x2524:
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFCA]
	sub 128
	ldh [$FFCE], a
	ldh a, [$FFCB]
	sbc 0
	and $0F
	ldh [$FFCF], a
	ldh a, [$FFC8]
	sub 120
	ldh [$FFCC], a
	ldh a, [$FFC9]
	sbc 0
	and $0F
	ldh [$FFCD], a
	call UnknownCall_0x0969
	call UnknownCall_0x2728
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFC8]
	sub 104
	ldh [$FFCC], a
	ldh a, [$FFC9]
	sbc 0
	and $0F
	ldh [$FFCD], a
	call UnknownCall_0x0969
	call UnknownCall_0x2728
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, 0
	ldh [$FFAF], a
	ld a, 170
	ldh [$FFB0], a
	ld a, 255
	ld [sWaterCurrentState], a
	ldh a, [$FFC8]
	sub 88
	ldh [$FFCC], a
	ldh a, [$FFC9]
	sbc 0
	and $0F
	ldh [$FFCD], a
	call UnknownCall_0x0969
	pop hl
	ret

UnknownCall_0x25AF:
	ld a, [hli]
	and $0F
	ld [sLevelGfxIndex], a
	push hl
	call DisableVBlank
	ld a, 19 ;prepare bank switch
	ld [sLevelBank], a
	ld [$2100], a
	ld a, 3
	ld [sLevelLayoutIndex], a
	call UnknownCall_0x0361
	ld a, 7 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld bc, $0050
	ld hl, $7800
	ld de, $8E80
	call CopyMem
	ld hl, UnknownData_0x268B
	ld a, [sLevelGfxIndex]
	sla a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli] ;prepare bank switch
	ld [$2100], a
	ld hl, UnknownData_0x2699
	ld a, [sLevelGfxIndex]
	sla a
	sla a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld a, e
	ld l, a
	ld bc, $0600
	ld de, $9200
	ld a, [sCurLevel]
	cp $18
	jr nz, UnknownRJump_0x2614
	ld bc, $0800
	ld de, $9000

UnknownRJump_0x2614:
	call CopyMem
	ld hl, UnknownData_0x268B
	ld a, [sLevelGfxIndex]
	sla a
	inc a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli] ;prepare bank switch
	ld [$2100], a
	ld hl, UnknownData_0x2699 + 2
	ld a, [sLevelGfxIndex]
	sla a
	sla a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld a, e
	ld l, a
	ld bc, $0400
	ld de, $8B00
	ld a, [sCurLevel]
	cp $18
	jr nz, UnknownRJump_0x264F
	ld bc, $0700
	ld de, $8900

UnknownRJump_0x264F:
	call CopyMem
	ld a, 8 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld hl, UnknownData_0x26B5
	ld a, [sLevelGfxIndex]
	sla a
	ld e, a
	ld d, 0
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, sMetatileMap

UnknownRJump_0x266D:
	ld a, [de]
	ld [hli], a
	inc de
	ld a, h
	cp $A8
	jr nz, UnknownRJump_0x266D
	xor a
	ldh [rBGP], a
	ld [sBGPalette], a
	ldh [rOBP0], a
	ld [sOAMPalette1], a
	ldh [rOBP1], a
	ld [sOAMPalette2], a
	ld a, 227
	ldh [rLCDC], a
	pop hl
	ret

UnknownData_0x268B: ;ROM bank pairs, indexed by $A22D * 2
	db $07, $06
	db $1B, $1B
	db $1F, $1F
	db $1E, $1E
	db $1C, $1C
	db $1D, $1D
	db $1E, $1E

UnknownData_0x2699: ;GFX source pointer pairs, indexed by $A22D * 4 (UnknownData_0x2699 + 2 = second word)
	dw $6400, $6980
	dw $5800, $6C00
	dw $5800, $6C00
	dw $4600, $6480
	dw $5800, $6C00
	dw $5200, $6280
	dw $5200, $6F80

UnknownData_0x26B5: ;pointers, indexed by $A22D * 2
	dw $7400
	dw $7400
	dw $7000
	dw $7000
	dw $7200
	dw $7200
	dw $7600


UnknownJump_0x26C3:
	ld a, [$AA01]
	and a
	jr z, UnknownRJump_0x2712
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call ScrollLevelMap
	jr UnknownRJump_0x2712

UnknownJump_0x26D7:
	ld a, [sVRAMTransferBank] ;prepare bank switch
	ld [$2100], a
	ldh a, [$FFB5]
	ld c, a
	ldh a, [$FFB6]
	ld b, a
	ldh a, [$FFB1]
	ld l, a
	ldh a, [$FFB2]
	ld h, a
	ldh a, [$FFB3]
	ld e, a
	ldh a, [$FFB4]
	ld d, a

UnknownRJump_0x26EF:
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, c
	and $3F
	jr nz, UnknownRJump_0x26EF
	ld a, c
	ldh [$FFB5], a
	ld a, b
	ldh [$FFB6], a
	ld a, l
	ldh [$FFB1], a
	ld a, h
	ldh [$FFB2], a
	ld a, e
	ldh [$FFB3], a
	ld a, d
	ldh [$FFB4], a
	ld a, b
	or c
	jr nz, UnknownRJump_0x2712
	xor a
	ld [sVRAMTransferActive], a

UnknownRJump_0x2712:
	ldh a, [$FF9B]
	cp $13
	call nz, UpdateSound
	ld a, 1
	ldh [$FF82], a
	ld a, [sCurROMBank] ;prepare bank switch
	ld [$2100], a
	pop hl
	pop de
	pop bc
	pop af
	reti

UnknownCall_0x2728:
	db $76 ;halt (rgbds adds a nop after)

UnknownRJump_0x2729:
	ldh a, [$FF82]
	and a
	jr z, UnknownRJump_0x2729
	ldh a, [$FF97]
	inc a
	ldh [$FF97], a
	xor a
	ldh [$FF82], a
	ld a, 192
	ldh [$FF8C], a
	xor a
	ldh [$FF8D], a
	ret

UnknownCall_0x273E:
	ldh a, [hKeysPressed]
	cp $08
	ret nz
	ld a, [sScreenTransition]
	and a
	ret nz
	xor a
	ld [sPauseState], a
	ld a, 8
	ldh [$FF9B], a
	ld a, 1
	ld [sSoundMode], a
	ret

UnknownJump_0x2756:
	ld b, 231
	ldh a, [$FF97]
	bit 4, a
	jr z, UnknownRJump_0x2760
	ld b, 147

UnknownRJump_0x2760:
	ld a, b
	ld [sBGPalette], a
	ld [sOAMPalette1], a
	ldh a, [hKeysPressed]
	cp $04
	jr nz, UnknownRJump_0x278E
	ld a, [sLevelProgressFlags]
	bit 7, a
	jr z, UnknownRJump_0x278E
	ld a, 2
	ld [sSoundMode], a
	ld [sMarioDead], a
	xor a
	ld [sAutoScroll], a
	ld [sTileAnimConfig], a
	ld [sExitTileFlag], a
	ld [sFastMusic], a
	ld a, 20
	ldh [$FF9B], a
	ret

UnknownRJump_0x278E:
	ldh a, [hKeysPressed]
	bit 3, a
	ret z
	ld a, [sLevelBGPalette]
	ld [sBGPalette], a
	ld a, [sLevelOAMPalette1]
	ld [sOAMPalette1], a
	ld a, [sLevelOAMPalette2]
	ld [sOAMPalette2], a
	ld a, 4
	ldh [$FF9B], a
	ld a, 2
	ld [sSoundMode], a
	ret

UnknownJump_0x27AF:
	call DisableVBlank
	xor a
	ldh [$FF8D], a
	call UnknownCall_0x2D41
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld bc, $1800
	ld hl, $4C92
	ld de, $8000
	call CopyMem
	ld de, $9800
	ld hl, $6492

UnknownRJump_0x27D2:
	ld a, [hli]
	ld [de], a
	inc de
	ld a, d
	cp $9B
	jr nz, UnknownRJump_0x27D2
	xor a
	ld [sScrollY], a
	ld [sScrollX], a
	ldh [rSCY], a
	ldh [rSCX], a
	ld a, 228
	ld [sBGPalette], a
	ld a, 195
	ld [sSavedLCDC], a
	ldh [rLCDC], a
	ld a, 5
	ld [sLives], a
	xor a
	ld [sCoinLow], a
	ld [sCoinHigh], a
	ld [sMoneyBagCount], a
	ld b, a
	ld a, [sGoldenCoin1]
	and $80
	sla a
	rl b
	ld a, [sGoldenCoin2]
	and $80
	sla a
	rl b
	ld a, [sGoldenCoin6]
	and $80
	sla a
	rl b
	ld a, [sGoldenCoin5]
	and $80
	sla a
	rl b
	ld a, [sGoldenCoin4]
	and $80
	sla a
	rl b
	ld a, [sGoldenCoin3]
	and $80
	sla a
	rl b
	ld a, b
	ld [sGoldenCoinFlags], a
	ld b, 6
	ld c, 0

UnknownRJump_0x283F:
	srl a
	jr nc, UnknownRJump_0x2844
	inc c

UnknownRJump_0x2844:
	dec b
	jr nz, UnknownRJump_0x283F
	ld a, [sLevelTally]
	sub c
	daa
	ld [sLevelTally], a
	xor a
	ld [sGoldenCoin1], a
	ld [sGoldenCoin2], a
	ld [sGoldenCoin6], a
	ld [sGoldenCoin5], a
	ld [sGoldenCoin4], a
	ld [sGoldenCoin3], a
	call UnknownCall_0x2934
	ld a, 255
	ld [sFadeTimerLow], a
	ld a, 7
	ld [sMusicRequest], a
	ld a, 7
	ldh [$FF9B], a
	ret

UnknownData_0x2874:
;"GAME OVER", $80-terminated
	db $90, $8A, $96, $8E, $FF, $98, $9F, $8E, $9B, $80

UnknownJump_0x287E:
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x30884
	call UnknownCall_0x28A7
	call UnknownCall_0x2CFF
	ld a, [sFadeTimerHigh]
	ld b, a
	ld a, [sFadeTimerLow]
	or b
	ret nz
	ldh a, [hKeysPressed]
	cp $08
	ret nz
	ld a, 0
	ldh [$FF9B], a
	ld a, 255
	ld [sMusicRequest], a
	ret

UnknownCall_0x28A7:
	ld a, [sFadeTimerHigh]
	and a
	ret nz
	ldh a, [$FF97]
	and $10
	swap a
	add 227
	ldh [$FFC6], a
	ld a, 68
	ldh [$FFC5], a
	ld a, 32
	ldh [$FFC4], a
	ld a, [sFadeTimerLow]
	sub 192
	jr c, UnknownRJump_0x28CD
	srl a
	ld b, a
	ld a, 32
	sub b
	ldh [$FFC4], a

UnknownRJump_0x28CD:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x5297
	ret

UnknownCall_0x28D9:
	ld hl, $A000
	call UnknownCall_0x28EC
	ld hl, $A050
	call UnknownCall_0x28EC
	ld hl, $A0A0
	call UnknownCall_0x28EC
	ret

UnknownCall_0x28EC:
	push hl
	ld e, l
	ld d, h
	ld b, 69
	ld c, 0

UnknownRJump_0x28F3:
	ld a, [hli]
	add c
	ld c, a
	dec b
	jr nz, UnknownRJump_0x28F3
	ld a, [hli]
	cp c
	jr nz, UnknownRJump_0x2913
	ld a, [hli]
	cp $12
	jr nz, UnknownRJump_0x2913
	ld a, [hli]
	cp $34
	jr nz, UnknownRJump_0x2913
	ld a, [hli]
	cp $56
	jr nz, UnknownRJump_0x2913
	ld a, [hl]
	cp $78
	jr nz, UnknownRJump_0x2913
	pop hl
	ret

UnknownRJump_0x2913:
	pop hl
	ld b, 64
	xor a

UnknownRJump_0x2917:
	ld [hli], a
	dec b
	jr nz, UnknownRJump_0x2917
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
	ret

UnknownCall_0x2934:
	ld hl, $A000
	ld a, [sSaveFileIndex]
	ld b, a
	sla a
	sla a
	add b
	swap a
	ld e, a
	ld d, 0
	add hl, de
	ld c, 0
	ld de, sMapNode
	ld b, 64

UnknownRJump_0x294D:
	ld a, [de]
	ld [hli], a
	add c
	ld c, a
	inc de
	dec b
	jr nz, UnknownRJump_0x294D
	ld a, [sCoinLow]
	ld [hli], a
	add c
	ld c, a
	ld a, [sCoinHigh]
	ld [hli], a
	add c
	ld c, a
	ld a, [sLevelTally]
	ld [hli], a
	add c
	ld c, a
	ld a, [sLives]
	ld [hli], a
	add c
	ld c, a
	ld a, [sMoneyBagCount]
	ld [hli], a
	add c
	ld [hl], a
	ret

UnknownJump_0x2974:
	call DisableVBlank
	call BlankBGMap1
	xor a
	ldh [$FF8D], a
	call UnknownCall_0x2D41
	ld a, 5 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld hl, $41E5
	ld de, $8800
	ld bc, $1000

UnknownRJump_0x2991:
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, UnknownRJump_0x2991
	ld hl, UnknownData_0x29BD
	ld de, $9904

UnknownRJump_0x299F:
	ld a, [hli]
	cp $80
	jr z, UnknownRJump_0x29A8
	ld [de], a
	inc de
	jr UnknownRJump_0x299F

UnknownRJump_0x29A8:
	xor a
	ld [sScrollY], a
	ld [sScrollX], a
	ld a, 195
	ldh [rLCDC], a
	ld a, 255
	ld [sFadeTimerLow], a
	ld a, 17
	ldh [$FF9B], a
	ret

UnknownData_0x29BD:
;"GAME CLEARED", $80-terminated
	db $56, $50, $5C, $54, $FF, $52, $5B, $54, $50, $61, $54, $53, $80

UnknownJump_0x29CA:
	call UnknownCall_0x02FF
	ld a, [sFadeTimerLow]
	and a
	jr z, UnknownRJump_0x29D8
	ldh a, [hKeysPressed]
	cp $08
	ret nz

UnknownRJump_0x29D8:
	ld a, 0
	ldh [$FF9B], a
	ret

	call DisableVBlank
	ld a, 17 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld bc, $1800
	ld hl, $5800
	ld de, $8000
	call CopyMem
	ld a, 26 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld hl, $9800
	ld de, $548E

UnknownRJump_0x2A02:
	ld a, [de]
	ld [hli], a
	inc de
	ld a, h
	cp $9C
	jr nz, UnknownRJump_0x2A02
	xor a
	ld [sScrollY], a
	ld [sScrollX], a
	ld a, 225
	ld [sBGPalette], a
	ld a, 210
	ld [sOAMPalette1], a
	ld a, 57
	ld [sOAMPalette2], a
	ld hl, $A100

UnknownRJump_0x2A23:
	xor a
	ld [hli], a
	ld a, l
	cp $A0
	jr c, UnknownRJump_0x2A23
	ld a, 195
	ldh [rLCDC], a
	ld a, 1
	ld [sFadeTimerHigh], a
	ld a, 0
	ld [sFadeTimerLow], a
	ld a, 44
	ld [sCreditsScrollY], a
	ld a, 26 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld a, [sEndingState]
	inc a
	ld [sEndingState], a
	ret

UnknownJump_0x2A4D:
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x309CD

UnknownCall_0x2A58:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x6485

UnknownCall_0x2A63:
	ld a, 5 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld bc, $1000
	ld hl, $41E5
	ld de, $8800
	call CopyMem
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownJump_0x2A80:
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp $477B

UnknownJump_0x2A8B:
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp $47A9


UnknownCall_0x2A96:
	ld a, 4 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call _UpdateSound
	ld a, 26 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x2AAA:
	ld a, 4 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call _UpdateSound
	ld a, 15 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x2ABE:
	ld a, BANK(GFX_TitleScreen) ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld bc, $1800
	ld hl, GFX_TitleScreen
	ld de, $8000
	call CopyMem
	ret

UnknownJump_0x2AD3:
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x305B6

UnknownJump_0x2ADE:
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x3067A

UnknownJump_0x2AE9:
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x3041D

UnknownJump_0x2AF4:
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x30451

UnknownCall_0x2AFF:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x5297
	ld a, 5 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret


UnknownCall_0x2B13:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x5297
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x2B27:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x5297
	ld a, 26 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x2B3B:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x5267
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x2B4F:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x52E7
	ld a, 26 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x2B63:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x52E7
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x2B77:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x5302
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x2B8B:
	ld a, 7 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld bc, $0600
	ld hl, $5E00
	ld de, $9200
	call CopyMem
	ld bc, $0380
	ld hl, $6A00
	ld de, $8E80
	call CopyMem
	ld a, BANK(GFX_Mario) ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld bc, $0800
	ld hl, GFX_Mario
	ld de, $8000
	call CopyMem
	ld a, 27 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld hl, $7000
	ld bc, $0300
	ld de, $8800
	call CopyMem
	ld a, 12 ;prepare bank switch
	ld [$2100], a
	ld bc, $0380
	ld hl, $6ACA
	ld de, $8B00
	call CopyMem
	ret

UnknownJump_0x2BE5:
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x30000

UnknownJump_0x2BF0:
	ld a, 12 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x3005F

FarCopyMem: ;$2BFB copymem from bank a
	ld [sCurROMBank], a
	ld [$2100], a
	call CopyMem
	ld a, 15 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x2C0D:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x5CF2

UnknownJump_0x2C18:
	ld a, 15 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x3E73

UnknownJump_0x2C23:
	ld a, 15 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x3EF2B

UnknownJump_0x2C2E:
	ld a, 15 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x3C000

UnknownCall_0x2C39:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownData_0x5C52
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x2C4D:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownData_0x5E42
	ld a, 5 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret


UnknownCall_0x2C61:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x5D25

UnknownCall_0x2C6C:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x5960

UnknownCall_0x2C77:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x591F

UnknownCall_0x2C82:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x5997

UnknownCall_0x2C8D:
	ld a, 26 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x68528

UnknownJump_0x2C98:
	ld a, 26 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x68528


UnknownJump_0x2CA3:
	ld a, 26 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x68528

UnknownJump_0x2CAE:
	ld a, 26 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x68000

UnknownJump_0x2CB9:
	ld a, 26 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x6800F

UnknownJump_0x2CC4:
	call DisableVBlank
	call UnknownCall_0x031C
	xor a
	ldh [$FF8D], a
	call UnknownCall_0x2CFF
	ld a, 5 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x14043

UnknownJump_0x2CDB:
	call UnknownCall_0x031C
	ld a, 5 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x1407C

UnknownJump_0x2CE9:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x5579

UnknownCall_0x2CF4:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x5297

UnknownCall_0x2CFF:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x52E7

UnknownCall_0x2D0A:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x530D

UnknownCall_0x2D15:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x5550

UnknownCall_0x2D20:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownCall_0x5272

UnknownCall_0x2D2B:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownCall_0x5267

UnknownCall_0x2D36:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownRJump_0x534C


UnknownCall_0x2D41:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x5302

UnknownCall_0x2D4C:
	ld a, [sLevelBank]
	ld [sCurROMBank], a
	ld [$2100], a
	ldh a, [$FFC1]
	swap a
	ld e, a
	ldh a, [$FFC3]
	add e
	ld e, a
	ld d, 0
	sla e
	rl d
	ld hl, $A900
	add hl, de
	inc hl
	ld a, [hl]
	swap a
	rlc a
	and $01
	xor $01
	ldh [$FFBB], a
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret


UnknownCall_0x2D7D:
	xor a
	ld [sMarioOnObject], a
	ld [sObjectBounce], a
	ld a, [sMarioDead]
	and a
	ret nz
	ld hl, sObjectTable

UnknownRJump_0x2D8C:
	push hl
	ld a, l
	add 23
	ld l, a
	ld a, [hl]
	and $F7
	jr nz, UnknownRJump_0x2DA2
	call UnknownCall_0x2EDD
	ld a, [sObjectHitResult]
	and a
	jr z, UnknownRJump_0x2DA2
	call UnknownCall_0x2DC6

UnknownRJump_0x2DA2:
	pop hl
	ld de, $0020
	add hl, de
	ld a, h
	cp $AF
	jr nz, UnknownRJump_0x2D8C
	ld a, [sObjectBounce]
	and a
	ret z
	ld a, 255
	ld [sMarioInAir], a
	ld a, 48
	ld [sVVelocityIndex], a
	ldh a, [hKeysHeld]
	bit 0, a
	ret z
	ld a, 75
	ld [sVVelocityIndex], a
	ret

UnknownCall_0x2DC6:
	xor a
	ld [sMarioOnGround], a
	ld a, l
	and $E0
	add 23
	ld l, a
	ld a, [hl]
	set 4, a
	ld [hl], a
	ld a, [sObjectType]
	bit 7, a
	jr z, UnknownRJump_0x2DE1
	and $7F
	ld [sPendingItemId], a
	ret

UnknownRJump_0x2DE1:
	ld a, [sMarioObjectYDelta]
	ld b, a
	cp $0C
	jp nc, UnknownJump_0x2E6F
	ld a, [sFlutterTimer]
	and a
	jr nz, UnknownRJump_0x2DF7
	ld a, [sVVelocityIndex]
	cp $18
	jr nc, UnknownRJump_0x2E6F

UnknownRJump_0x2DF7:
	ld a, [sObjectType]
	and $23
	jr z, UnknownRJump_0x2E6F
	bit 5, a
	jr z, UnknownRJump_0x2E23
	ld a, 255
	ld [sMarioOnObject], a
	ld a, l
	and $E0
	add 23
	ld l, a
	ld a, 8
	ld [hl], a
	ld a, [sMarioObjectYDelta]
	cp $03
	ret c
	ldh a, [$FFC0]
	sub 1
	ldh [$FFC0], a
	ldh a, [$FFC1]
	sbc 0
	ldh [$FFC1], a
	ret

UnknownRJump_0x2E23:
	xor a
	ld [sFlutterArmed], a
	ld a, [sStarTimerHigh]
	and a
	jr nz, UnknownRJump_0x2E6F
	ld a, l
	and $E0
	add 23
	ld l, a
	ld a, 1
	ld [hl], a
	inc b
	inc b
	inc b
	inc b
	inc b
	inc b
	ldh a, [$FFC0]
	sub b
	ldh [$FFC0], a
	ldh a, [$FFC1]
	sbc 0
	ldh [$FFC1], a
	ld a, 255
	ld [sObjectBounce], a
	call UnknownCall_0x1DFE
	jr nc, UnknownRJump_0x2E5C
	ldh a, [$FFC0]
	add b
	ldh [$FFC0], a
	ldh a, [$FFC1]
	adc 0
	ldh [$FFC1], a

UnknownRJump_0x2E5C:
	ld a, [sSceneState]
	and a
	ret z
	ld a, 49
	ld [sVVelocityIndex], a
	ld a, 255
	ld [sMarioInAir], a
	ld [sNoJumpCut], a
	ret

UnknownJump_0x2E6F:
UnknownRJump_0x2E6F:
	ld a, [sStarTimerHigh]
	and a
	jp nz, UnknownJump_0x2EAA
	ld a, [sObjectType]
	bit 6, a
	ret z
	ld a, [sMoonPhysics]
	bit 2, a
	jr z, UnknownRJump_0x2E8E
	res 2, a
	ld [sMoonPhysics], a
	ld a, 128
	ld [sInvincibilityTimer], a
	ret

UnknownRJump_0x2E8E:
	ld a, [sInvincibilityTimer]
	and a
	jp nz, UnknownJump_0x2F71
	ld a, 15
	ld [sMarioDead], a
	ld a, 20
	ld [sSfxRequest0], a
	ld a, [sCurPowerup]
	and a
	ret nz
	ld a, 15
	ld [sSfxRequest0], a
	ret

UnknownJump_0x2EAA:
	ld a, [sObjectType]
	bit 5, a
	ret nz
	ld a, l
	and $E0
	add 23
	ld l, a
	ld a, 4
	ld [hl], a
	ld a, 32
	ld [sStompBounceTimer], a
	ld a, [sStompChainCount]
	inc a
	daa
	ld [sStompChainCount], a
	cp $05
	ret c
	ld a, 9
	ld [sSfxRequest0], a
	ld a, [sLives]
	inc a
	daa
	ld [sLives], a
	ret nz

	ld a, 153
	ld [sLives], a
	ret


UnknownCall_0x2EDD:
	xor a
	ld [sObjectHitResult], a
	ld a, l
	sub 5
	ld l, a
	ld a, [hl]
	bit 7, a
	jr z, UnknownRJump_0x2EF1
	and $7F
	jp z, UnknownJump_0x2F71
	jr UnknownRJump_0x2EF5

UnknownRJump_0x2EF1:
	and $63
	jr z, UnknownRJump_0x2F71

UnknownRJump_0x2EF5:
	ld a, [hli]
	ld [sObjectType], a
	ld a, [hli]
	ld [sObjectBoxTop], a
	ld a, [hli]
	ld [sObjectBoxBottom], a
	ld a, [hli]
	ld [sObjectBoxLeft], a
	ld a, [hli]
	ld [sObjectBoxRight], a
	ld a, [hl]
	and $F7
	ret nz
	ld a, l
	sub 14
	ld l, a
	ld a, [hli]
	ld [sObjectY], a
	ld b, a
	ld a, [hl]
	ld [sObjectX], a
	ld c, a
	ld a, [sObjectBoxTop]
	add b
	sub 20
	ld d, a
	ld a, [sCurPowerup]
	and a
	jr nz, UnknownRJump_0x2F34
	ld e, 0
	ld a, [sMarioDucking]
	and a
	jr z, UnknownRJump_0x2F3E
	ld e, 248
	jr UnknownRJump_0x2F3E

UnknownRJump_0x2F34:
	ld e, 8
	ld a, [sMarioDucking]
	and a
	jr z, UnknownRJump_0x2F3E
	ld e, 0

UnknownRJump_0x2F3E:
	ld a, [sObjectBoxBottom]
	add b
	add e
	sub d
	ld e, a
	ld a, [sMarioScreenY]
	sub d
	ld [sMarioObjectYDelta], a
	cp e
	jr nc, UnknownRJump_0x2F71
	ld a, [sObjectBoxLeft]
	add c
	add 11
	sub 16
	ld d, a
	ld a, [sObjectBoxRight]
	add c
	add 20
	sub 16
	sub d
	ld e, a
	ld a, [sMarioScreenX]
	sub d
	ld [sMarioObjectXDelta], a
	cp e
	jr nc, UnknownRJump_0x2F71
	ld a, 255
	ld [sObjectHitResult], a

UnknownJump_0x2F71:
UnknownRJump_0x2F71:
	ret

UnknownCall_0x2F72:
	xor a
	ld [sObjectBumpSpecial], a
	ld a, [sScrollY]
	ld b, a
	ldh a, [$FFB7]
	and $F0
	add 8
	sub b
	sub 16
	ldh [$FFB7], a
	ld a, [sScrollX]
	ld b, a
	ldh a, [$FFB9]
	add 8
	and $F0
	sub b
	sub 8
	ldh [$FFB9], a
	ld hl, sObjectTable

UnknownRJump_0x2F97:
	push hl
	ld a, l
	add 23
	ld l, a
	ld a, [hl]
	and a
	jr nz, UnknownRJump_0x2FA3
	call UnknownCall_0x2FAE

UnknownRJump_0x2FA3:
	pop hl
	ld de, $0020
	add hl, de
	ld a, h
	cp $AF
	jr nz, UnknownRJump_0x2F97
	ret

UnknownCall_0x2FAE:
	xor a
	ld [sObjectBumpHit], a
	ld a, l
	sub 5
	ld l, a
	ld a, [hli]
	ld [sObjectType], a
	and a
	jr z, UnknownRJump_0x2FEC
	ld a, l
	sub 10
	ld l, a
	ldh a, [$FFB7]
	ld b, a
	ld a, [hli]
	sub b
	cp $10
	jr nc, UnknownRJump_0x2FEC
	ldh a, [$FFB9]
	ld b, a
	ld a, [hl]
	sub b
	cp $14
	jr nc, UnknownRJump_0x2FEC
	ld a, 255
	ld [sObjectBumpHit], a
	ld a, l
	add 13
	ld l, a
	ld a, [hl]
	set 5, a
	ld [hl], a
	ld a, [sObjectType]
	cp $80
	jr nz, UnknownRJump_0x2FEC
	ld a, 255
	ld [sObjectBumpSpecial], a

UnknownRJump_0x2FEC:
	ret

UnknownCall_0x2FED:
	ld hl, sObjectTable

UnknownRJump_0x2FF0:
	push hl
	ld a, l
	add 23
	ld l, a
	ld a, [hl]
	and a
	jr nz, UnknownRJump_0x2FFC
	call UnknownCall_0x3007

UnknownRJump_0x2FFC:
	pop hl
	ld de, $0020
	add hl, de
	ld a, h
	cp $AF
	jr nz, UnknownRJump_0x2FF0
	ret

UnknownCall_0x3007:
	ld a, l
	sub 5
	ld l, a
	ld a, [hl]
	ldh [$FF98], a
	bit 7, a
	ret nz
	and a
	ret z
	ld a, [hli]
	ld [sObjectType], a
	ld a, [hli]
	ld [sObjectBoxTop], a
	ld a, [hli]
	ld [sObjectBoxBottom], a
	ld a, [hli]
	ld [sObjectBoxLeft], a
	ld a, [hli]
	ld [sObjectBoxRight], a
	ld a, l
	sub 14
	ld l, a
	ld a, [hli]
	ld [sObjectY], a
	ld b, a
	ld a, [hl]
	ld [sObjectX], a
	ld c, a
	ld a, [sObjectBoxTop]
	sub 6
	add b
	ld d, a
	ld a, [sObjectBoxBottom]
	add 6
	add b
	sub d
	ld e, a
	ldh a, [$FFC4]
	sub d
	cp e
	jp nc, UnknownJump_0x307C
	ld a, [sObjectBoxLeft]
	sub 6
	add c
	ld d, a
	ld a, [sObjectBoxRight]
	add 6
	add c
	sub d
	ld e, a
	ldh a, [$FFC5]
	sub d
	cp e
	jp nc, UnknownJump_0x307C
	ldh a, [$FF98]
	bit 2, a
	jr nz, UnknownRJump_0x3071
	ld a, 2
	ld [sSfxRequest0], a
	ld [sObjectHitResult], a
	jr UnknownRJump_0x307C

UnknownRJump_0x3071:
	ld a, l
	add 13
	ld l, a
	ld a, [hl]
	set 1, a
	ld [hl], a
	ld [sObjectHitResult], a

UnknownJump_0x307C:
UnknownRJump_0x307C:
	ret

UnknownCall_0x307D:
	ld a, [sSceneState]
	and a
	ret nz
	ld a, [sMarioOnGround]
	ld b, a
	ld a, [sMarioOnObject]
	or b
	ret z
	ldh a, [hKeysHeld]
	cp $82
	jr z, UnknownRJump_0x3098
	ldh a, [hKeysHeld]
	cp $42
	jr z, UnknownRJump_0x30D9
	ret

UnknownRJump_0x3098:
	ld a, [sMarioScreenY]
	cp $20
	ret c
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ldh a, [$FFC9]
	swap a
	ld b, a
	ldh a, [$FFCB]
	or b
	ld e, a
	ld d, 0
	ld hl, $A960
	add hl, de
	ld a, [hl]
	ldh [$FF98], a
	ld a, [sMapScrollFlags]
	set 7, a
	ld [sMapScrollFlags], a
	ldh a, [$FF98]
	bit 3, a
	jr z, UnknownRJump_0x30CC
	ldh a, [$FFC8]
	cp $C0
	ret nc

UnknownRJump_0x30CC:
	ldh a, [$FFC8]
	add 1
	ldh [$FFC8], a
	ldh a, [$FFC9]
	adc 0
	ldh [$FFC9], a
	ret

UnknownRJump_0x30D9:
	ld a, [sMarioScreenY]
	cp $70
	ret nc
	ld a, [sLevelBank] ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ldh a, [$FFC9]
	swap a
	ld b, a
	ldh a, [$FFCB]
	or b
	ld e, a
	ld d, 0
	ld hl, $A960
	add hl, de
	ld a, [hl]
	ldh [$FF98], a
	ld a, [sMapScrollFlags]
	set 6, a
	ld [sMapScrollFlags], a
	ldh a, [$FF98]
	bit 2, a
	jr z, UnknownRJump_0x310D
	ldh a, [$FFC8]
	cp $49
	ret c

UnknownRJump_0x310D:
	ldh a, [$FFC8]
	sub 1
	ldh [$FFC8], a
	ldh a, [$FFC9]
	sbc 0
	ldh [$FFC9], a
	ret

UnknownJump_0x311A:
	ld a, [sFadeTimerLow]
	and a
	jr z, UnknownRJump_0x3127

UnknownRJump_0x3120:
	ldh a, [rLY]
	cp $50
	jr nc, UnknownRJump_0x3120
	ret

UnknownRJump_0x3127:
	xor a
	ld [sTileAnimConfig], a
	ld [sBossFightPhase], a
	ld a, 20
	ldh [$FF9B], a
	call UnknownCall_0x2D41
	ld a, [sSoundDisabled]
	and a
	jp nz, UnknownJump_0x3150
	ld a, [sLives]
	sub 1
	daa
	ld [sLives], a
	jr c, UnknownRJump_0x314B
	call UnknownCall_0x2934
	ret

UnknownRJump_0x314B:
	ld a, 5
	ldh [$FF9B], a
	ret

UnknownJump_0x3150:
	ld a, [$A0F0]
	inc a
	and $03
	ld [$A0F0], a
	jp Init


UnknownCall_0x315C:
	ld hl, MarioSpeedTableDead
	ld a, [sVVelocityIndex]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld b, a
	ldh a, [$FFC0]
	add b
	ldh [$FFC0], a
	ld a, 1
	ldh [$FFBB], a
	call UnknownCall_0x2D15
	ld a, [sMarioScreenY]
	and $F0
	cp $B0
	jr z, UnknownRJump_0x3186
	ld a, [sVVelocityIndex]
	dec a
	ret z
	ld [sVVelocityIndex], a
	ret

UnknownRJump_0x3186:
	ld a, 2
	ld [sMusicRequest], a
	xor a
	ld [sCurPowerup], a
	ld [sInvincibilityTimer], a
	ld [sFadeTimerHigh], a
	ld a, 192
	ld [sFadeTimerLow], a
	ld a, 9
	ldh [$FF9B], a
	ret

UnknownCall_0x319F:
	ld a, [sMarioDead]
	and a
	ret z
	ld a, [sMarioDead]
	cp $80
	jr z, UnknownRJump_0x31D1
	ld a, [sCurPowerup]
	and a
	jr z, UnknownRJump_0x31D1
	cp $01
	jr nz, UnknownRJump_0x31C2
	xor a
	ld [sMarioDead], a
	ld [sCurPowerup], a
	ld a, 128
	ld [sInvincibilityTimer], a
	ret

UnknownRJump_0x31C2:
	xor a
	ld [sMarioDead], a
	ld a, 1
	ld [sCurPowerup], a
	ld a, 128
	ld [sInvincibilityTimer], a
	ret

UnknownRJump_0x31D1:
	ld a, 255
	ld [sMarioDead], a
	xor a
	ld [sMarioWalkAnimTimer], a
	ld a, 95
	ld [sVVelocityIndex], a
	ret

UnknownASM_0x31E0:
	ld a, 255
	ld [sMarioDead], a
	xor a
	ld [sMarioWalkAnimTimer], a
	ld a, 23
	ld [sVVelocityIndex], a
	ret

MarioSpeedTableDead: ;$31EF
	db $03, $03, $03, $02, $02, $03, $02, $02, $02, $02, $01, $02, $01, $01, $01, $01
	db $01, $01, $00, $01, $00, $01, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FE, $FF, $FE, $FE
	db $FE, $FE, $FD, $FE, $FE, $FD, $FD, $FD, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

UnknownCall_0x324F:
	ld hl, sFireball1Active

UnknownRJump_0x3252:
	ld a, [hl]
	and a
	call nz, UnknownCall_0x3261
	ld bc, $0010
	add hl, bc
	ld a, l
	cp $A0
	jr nz, UnknownRJump_0x3252
	ret

UnknownCall_0x3261:
	push hl
	inc hl
	ld a, [hli]
	ld [sFireballY], a
	inc hl
	ld a, [hli]
	ld [sFireballX], a
	inc hl
	ld a, [hl]
	ld [sFireballDirection], a
	ldh a, [$FFCA]
	ld b, a
	ld a, [sFireballX]
	sub b
	add 80
	ldh [$FFC5], a
	and $F0
	cp $C0
	jr z, UnknownRJump_0x32BD
	ldh a, [$FFC8]
	ld b, a
	ld a, [sFireballY]
	sub b
	add 70
	ldh [$FFC4], a
	and $F0
	cp $C0
	jr z, UnknownRJump_0x32BD
	ld b, 176
	ld a, [sFireballDirection]
	cp $FF
	jr z, UnknownRJump_0x329E
	ld b, 180

UnknownRJump_0x329E:
	ldh a, [$FF97]
	and $06
	srl a
	add b
	ldh [$FFC6], a
	ld a, 1
	ldh [$FFBB], a
	call UnknownCall_0x2CF4
	xor a
	ld [sObjectHitResult], a
	call UnknownCall_0x2FED
	ld a, [sObjectHitResult]
	and a
	jr nz, UnknownRJump_0x32BD
	pop hl
	ret

UnknownRJump_0x32BD:
	pop hl
	xor a
	ld [hl], a
	ret

UnknownCall_0x32C1:
	ldh a, [hKeysPressed]
	bit 1, a
	ret z
	ld a, [sCurPowerup]
	cp $03
	ret nz
	ld a, [sMarioDucking]
	and a
	ret nz
	ld a, [sGoalBell]
	and a
	ret nz
	ld hl, sFireball1Active

UnknownRJump_0x32D9:
	ld a, [hl]
	and a
	jr z, UnknownRJump_0x32E7
	ld bc, $0010
	add hl, bc
	ld a, l
	cp $A0
	jr nz, UnknownRJump_0x32D9
	ret

UnknownRJump_0x32E7:
	ld a, 1
	ld [hli], a
	ldh a, [$FFC0]
	add 28
	ld [hli], a
	ldh a, [$FFC1]
	adc 0
	ld [hli], a
	ldh a, [$FFC2]
	add 16
	ld [hli], a
	ldh a, [$FFC3]
	adc 0
	ld [hli], a
	ld a, [sMarioDirection]
	ld [hl], a
	ld a, [sSpinJump]
	and a
	jr z, UnknownRJump_0x330E
	ldh a, [$FF97]
	and $02
	dec a
	ld [hl], a

UnknownRJump_0x330E:
	inc hl
	xor a
	ld [hl], a
	ld a, 8
	ld [sMarioThrowTimer], a
	ld a, 11
	ld [sSfxRequest0], a
	ret

UnknownCall_0x331C:
	ld hl, sFireball1Active

UnknownRJump_0x331F:
	ld a, [hl]
	and a
	call nz, UnknownCall_0x332E
	ld bc, $0010
	add hl, bc
	ld a, l
	cp $A0
	jr nz, UnknownRJump_0x331F
	ret

UnknownCall_0x332E:
	ld [sFireballActive], a
	push hl
	inc hl
	ld a, [hli]
	ld [sFireballY], a
	ldh [$FFB7], a
	ld a, [hli]
	ld [sFireballYU], a
	ldh [$FFB8], a
	ld a, [hli]
	ld [sFireballX], a
	ld a, [hli]
	ld [sFireballXU], a
	ld a, [hli]
	ld [sFireballDirection], a
	sla a
	ld b, a
	ld a, [hl]
	ld [sFireballPhase], a
	ld c, a
	ld a, b
	cp $80
	jr nc, UnknownRJump_0x336E
	inc b
	ld a, [sFireballX]
	add b
	ld [sFireballX], a
	ldh [$FFB9], a
	ld a, [sFireballXU]
	adc 0
	ld [sFireballXU], a
	ldh [$FFBA], a
	jr UnknownRJump_0x3386

UnknownRJump_0x336E:
	dec b
	ld a, b
	cpl
	inc a
	ld b, a
	ld a, [sFireballX]
	sub b
	ld [sFireballX], a
	ldh [$FFB9], a
	ld a, [sFireballXU]
	sbc 0
	ld [sFireballXU], a
	ldh [$FFBA], a

UnknownRJump_0x3386:
	call UnknownCall_0x1EFA
	cp $38
	jp c, UnknownJump_0x3415
	ld a, [sFireballPhase]
	ld c, a
	ld hl, UnknownData_0x3439
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld b, a
	ld a, c
	cp $0C
	jr c, UnknownRJump_0x33B4
	ld a, [sFireballY]
	sub b
	ld [sFireballY], a
	ldh [$FFB7], a
	ld a, [sFireballYU]
	sbc 0
	ld [sFireballYU], a
	ldh [$FFB8], a
	jr UnknownRJump_0x33C7

UnknownRJump_0x33B4:
	ld a, [sFireballY]
	add b
	ld [sFireballY], a
	ldh [$FFB7], a
	ld a, [sFireballYU]
	adc 0
	ld [sFireballYU], a
	ldh [$FFB8], a

UnknownRJump_0x33C7:
	call UnknownCall_0x1EFA
	cp $48
	jr nc, UnknownRJump_0x33F1
	ld a, [sFireballPhase]
	cp $0C
	jr nc, UnknownRJump_0x33F1
	ld a, [sCollisionTile]
	cp $06
	jr z, UnknownRJump_0x341C
	ld a, 24
	ld [sFireballPhase], a
	ld a, [sFireballY]
	sub 3
	ld [sFireballY], a
	ld a, [sFireballYU]
	sbc 0
	ld [sFireballYU], a

UnknownRJump_0x33F1:
	ld a, [sFireballPhase]
	and a
	jr z, UnknownRJump_0x33FB
	dec a
	ld [sFireballPhase], a

UnknownRJump_0x33FB:
	pop hl
	push hl
	inc hl
	ld a, [sFireballY]
	ld [hli], a
	ld a, [sFireballYU]
	ld [hli], a
	ld a, [sFireballX]
	ld [hli], a
	ld a, [sFireballXU]
	ld [hli], a
	inc hl
	ld a, [sFireballPhase]
	ld [hl], a
	pop hl
	ret

UnknownJump_0x3415:
	ld a, [sCollisionTile]
	cp $06
	jr nz, UnknownRJump_0x3430

UnknownRJump_0x341C:
	ld a, 1
	ld [sSfxRequest2], a
	ld b, 1
	ld a, 2
	ld [sSfxRequest0], a
	call UnknownCall_0x2C6C
	ld a, 255
	ld [sSpinJumpBounce], a

UnknownRJump_0x3430:
	pop hl
	xor a
	ld [hl], a
	ld a, 2
	ld [sSfxRequest0], a
	ret

UnknownData_0x3439: ;indexed by sFireballPhase
	db $03, $03, $03, $03, $02, $03, $02, $02, $01, $02, $01, $00
	db $00, $01, $02, $01, $02, $02, $03, $02, $03, $03, $03, $03


UnknownCall_0x3451:
	ld a, [sPendingItemId]
	and a
	ret z
	cp $01
	jr nz, UnknownRJump_0x3467
	ld a, 1
	ld [sCurPowerup], a
	ld a, 20
	ld [sSfxRequest1], a
	jp UnknownJump_0x3534

UnknownRJump_0x3467:
	cp $02
	jr nz, UnknownRJump_0x3478
	ld a, 3
	ld [sCurPowerup], a
	ld a, 20
	ld [sSfxRequest1], a
	jp UnknownJump_0x3534

UnknownRJump_0x3478:
	cp $03
	jr nz, UnknownRJump_0x3489
	ld a, 2
	ld [sCurPowerup], a
	ld a, 20
	ld [sSfxRequest1], a
	jp UnknownJump_0x3534

UnknownRJump_0x3489:
	cp $04
	jr nz, UnknownRJump_0x34AF
	ld a, [sStarTimerHigh]
	ld b, a
	ld a, [sStarTimerLow]
	xor $FF
	or b
	jr nz, UnknownRJump_0x349D
	xor a
	ld [sStompChainCount], a

UnknownRJump_0x349D:
	ld a, 4
	ld [sStarTimerHigh], a
	ld a, 64
	ld [sStarTimerLow], a
	ld a, 4
	ld [sMusicRequest], a
	jp UnknownJump_0x3539

UnknownRJump_0x34AF:
	cp $05
	jr nz, UnknownRJump_0x34C9
	ld a, 9
	ld [sSfxRequest0], a
	ld a, [sLives]
	inc a
	daa
	ld [sLives], a
	jr nz, UnknownRJump_0x3539

	ld a, 153
	ld [sLives], a
	jr UnknownJump_0x3539


UnknownRJump_0x34C9:
	cp $07
	jr nz, UnknownRJump_0x34D9
	ld a, 21
	ld [sSfxRequest0], a
	ld a, 255
	ld [sSecretRouteFlag], a
	jr UnknownRJump_0x3539

UnknownRJump_0x34D9:
	cp $08
	jr nz, UnknownRJump_0x34EC
	ld a, 20
	ld [sSfxRequest1], a
	ld a, [sMoonPhysics]
	set 2, a
	ld [sMoonPhysics], a
	jr UnknownRJump_0x3539

UnknownRJump_0x34EC:
	cp $06
	jr nz, UnknownRJump_0x350A
	ld a, 12
	ld [sSfxRequest0], a
	ld [sGoalBell], a
	xor a
	ld [$A53F], a
	ld a, [sVVelocityIndex]
	cp $18
	jr nc, UnknownRJump_0x3539
	ld a, 24
	ld [sVVelocityIndex], a
	jr UnknownRJump_0x3539

UnknownRJump_0x350A:
	cp $09
	jr nz, UnknownRJump_0x3539
	ld a, 7
	ld [sSfxRequest0], a
	ld a, [sCoinLow]
	add 80
	daa
	ld [sCoinLow], a
	ld a, [sCoinHigh]
	adc 0
	ld [sCoinHigh], a
	cp $0A
	jr c, UnknownRJump_0x3539
	ld a, 153
	ld [sCoinLow], a
	ld a, 9
	ld [sCoinHigh], a
	jr UnknownRJump_0x3539

UnknownJump_0x3534:
	ld a, 64
	ld [sInvincibilityTimer], a

UnknownJump_0x3539:
UnknownRJump_0x3539:
	xor a
	ld [sPendingItemId], a
	ret

UnknownJump_0x353E:
	xor a
	ld [sCurPowerup], a
	ld a, 20
	ldh [$FF9B], a
	ret

UnknownJump_0x3547:
	ld a, [sFadeTimerLow]
	ld b, a
	ld a, [sFadeTimerHigh]
	or b
	jr z, UnknownRJump_0x3558

UnknownRJump_0x3551:
	ldh a, [rLY]
	cp $50
	jr nc, UnknownRJump_0x3551
	ret

UnknownRJump_0x3558:
	ld a, [sLevelProgressFlags]
	bit 7, a
	jr nz, UnknownRJump_0x356E
	ld a, [sExitTileFlag]
	and a
	jr nz, UnknownRJump_0x356E
	ld a, [sLevelTally]
	add 1
	daa
	ld [sLevelTally], a

UnknownRJump_0x356E:
	ld a, 20
	ldh [$FF9B], a
	ret

UnknownJump_0x3573:
	ld a, [sCurLevel]
	cp $FF
	jr nz, .CheckEasyMode
	ld a, 27
	ldh [$FF9B], a
	ret

.CheckEasyMode
	ld a, [sEasyMode]
	cp $01
	jr z, .EasyModeOn
	ld a, 11
	ldh [$FF9B], a
	ret

.EasyModeOn
	ld a, 208
	ld [sOAMPalette1], a
	call DisableVBlank
	ld a, 26 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld hl, $4656
	ld bc, $0300
	ld de, $8800
	call CopyMem
	call UnknownCall_0x2D41
	ld a, 224
	ld [sBGPalette], a
	ld a, 210
	ld [sOAMPalette1], a
	ld a, 57
	ld [sOAMPalette2], a
	ld a, 226
	ldh [rLCDC], a
	ld a, 0
	ld [sFadeTimerHigh], a
	ld a, 64
	ld [sFadeTimerLow], a
	ldh a, [$FF9B]
	inc a
	ldh [$FF9B], a
	ret

UnknownJump_0x35CD:
	ld a, 80
	ldh [$FFC4], a
	ld a, 52
	ldh [$FFC5], a
	ld a, 240
	ldh [$FFC6], a
	call UnknownCall_0x2CF4
	ld a, [sFadeTimerLow]
	ld b, a
	ld a, [sFadeTimerHigh]
	or b
	ret nz
	ld a, 11
	ldh [$FF9B], a
	ret

UnknownData_0x35EA: ;per-level byte, indexed by sCurLevel
	db $4D, $FF, $82, $FF, $FF, $FF, $FE, $8C, $F3, $4B, $44, $45, $46, $FF, $48, $49
	db $4A, $48, $FF, $41, $47, $68, $4B, $4F, $80, $4D, $FF, $FF, $41, $FF, $FF, $FF

UnknownData_0x360A: ;per-level byte, indexed by sCurLevel (stored to sLevelGfxConfig)
	db $00, $00, $31, $10, $10, $00, $10, $31, $31, $31, $00, $00, $00, $00, $00, $10
	db $31, $00, $35, $35, $00, $00, $00, $10, $00, $00, $00, $00, $35, $00, $00, $00
INCLUDE "levels/enemysets.asm"
INCLUDE "levels/tilesets.asm"
STATInterrupt: ;LCD STAT interrupt handler (vector $0048)
	ldh a, [$FF9B]
	cp $04
	jr nz, UnknownRJump_0x3734
	ld a, 228
	ldh [rBGP], a

UnknownRJump_0x3734:
	reti

UnknownCall_0x3735:
	ld a, 1
	ld [sMoonFxState], a
	xor a
	ld [sMoonFxTimer], a
	ldh a, [$FFC1]
	ld [sMoonFxYU], a
	ldh a, [$FFC0]
	ld [sMoonFxY], a
	ldh a, [$FFC3]
	ld [sMoonFxXU], a
	ldh a, [$FFC2]
	ld [sMoonFxX], a
	ret

UnknownCall_0x3753:
	ldh a, [$FF97]
	and $7F
	ret nz
	ld a, [sMoonFxState]
	and a
	ret nz
	ld a, 2
	ld [sMoonFxState], a
	xor a
	ld [sMoonFxTimer], a
	ldh a, [$FFC0]
	ld [sMoonFxY], a
	ldh a, [$FFC1]
	ld [sMoonFxYU], a
	ldh a, [$FFC3]
	ld [sMoonFxXU], a
	ldh a, [$FFC2]
	ld [sMoonFxX], a
	ret

UnknownData_0x377B: ;per-level 8-byte records (copied to $A800), indexed by sCurLevel * 8
	dw $01A4, $0ADA, $01B6, $0AFB
	dw $01D4, $0860, $01C0, $0881
	dw $0084, $070F, $008E, $071F
	dw $0084, $0A0C, $00A7, $0A2D
	dw $0000, $0000, $0000, $0000
	dw $0254, $06A8, $0260, $06C9
	dw $01D4, $06BA, $01C0, $06C8
	dw $0164, $0655, $017F, $0676
	dw $01C4, $0924, $01C0, $0943
	dw $01D4, $076E, $01C0, $078F
	dw $0274, $06D0, $027F, $06B0
	dw $0194, $0831, $01BA, $0852
	dw $01B4, $07CB, $01C0, $07D4
	dw $00D4, $0994, $00C0, $0999
	dw $0294, $06A3, $02A0, $06AF
	dw $0134, $068D, $014B, $06AE
	dw $0194, $0559, $019F, $055E
	dw $0000, $0000, $0000, $0000
	dw $01B4, $0771, $01BD, $0792
	dw $00B4, $0D87, $00A6, $0DA8
	dw $02C4, $0A35, $02C0, $0A47
	dw $0274, $09F5, $027E, $0A16
	dw $01D4, $08F3, $01C0, $0902
	dw $01D4, $0813, $01C0, $0834
	dw $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000
	dw $0000, $0000, $0000, $0000


UnknownCall_0x3873:
	ld a, [sTileAnimConfig]
	and a
	ret z
	dec a
	and $0F
	ld d, a
	ld a, [sTileAnimConfig]
	and $F0
	swap a
	sla a
	ld b, a
	ld a, 29 ;prepare bank switch
	ld [$2100], a
	ld a, [sTileAnimTimer]
	cp b
	ret c
	xor a
	ld [sTileAnimTimer], a
	ld e, 0
	ld hl, $6680
	add hl, de
	ld a, [sTileAnimPhase]
	inc a
	and $03
	ld [sTileAnimPhase], a
	sla a
	sla a
	swap a
	ld e, a
	ld d, 0
	add hl, de
	ld de, $9200
	ld b, 64

UnknownRJump_0x38B2:
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, UnknownRJump_0x38B2
	ret

UnknownCall_0x38B9:
	ld a, [sSoundDisabled]
	and $F0
	jr nz, UnknownRJump_0x3911
	ld a, [sSoundDisabled]
	and $0F
	jr nz, UnknownRJump_0x38C8
	ret

UnknownRJump_0x38C8:
	ldh a, [hKeysPressed]
	and $08
	jr z, UnknownRJump_0x38E5

UnknownJump_0x38CE:
	ld a, 4 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x1002D
	ld a, [$A0F0]
	inc a
	and $03
	ld [$A0F0], a
	jp Init

UnknownRJump_0x38E5:
	ld a, 5 ;prepare bank switch
	ld [$2100], a
	ld a, [sPrevKeysHeld]
	ldh [hKeysHeld], a
	ld h, 163
	ld a, [sDemoInputPos]
	ld l, a

UnknownRJump_0x38F5:
	ld a, [hli]
	cp $FF
	jp z, UnknownJump_0x38CE
	ld b, a
	ld a, [hli]
	sub 1
	jr c, UnknownRJump_0x38F5
	dec hl
	ld [hld], a
	ldh a, [hKeysHeld]
	xor b
	and b
	ldh [hKeysPressed], a
	ld a, b
	ldh [hKeysHeld], a
	ld a, l
	ld [sDemoInputPos], a
	ret

UnknownRJump_0x3911:
	ld h, 163
	ld a, [sDemoInputPos]
	ld l, a
	ld a, [hl]
	cp $FF
	jr nz, UnknownRJump_0x3921
	ld a, 6
	ldh [$FF9B], a
	ret

UnknownRJump_0x3921:
	ldh a, [hKeysHeld]
	ld b, a
	ld a, [hli]
	cp b
	jr nz, UnknownRJump_0x3931
	ld a, [hl]
	cp $FF
	jr z, UnknownRJump_0x3931
	inc a
	ld [hld], a
	jr UnknownRJump_0x3942

UnknownRJump_0x3931:
	inc hl
	ld a, l
	cp $FE
	jr z, UnknownRJump_0x393F
	ldh a, [hKeysHeld]
	ld [hli], a
	ld a, 1
	ld [hld], a
	jr UnknownRJump_0x3942

UnknownRJump_0x393F:
	ld a, 255
	ld [hl], a

UnknownRJump_0x3942:
	ld a, l
	ld [sDemoInputPos], a
	ret

UnknownData_0x3947:
;unused filler
	db $F3, $AF, $CC, $F3, $6A, $FF, $DC, $ED, $73, $CD, $C9, $F6, $AE, $FB, $DF, $7D
	db $ED, $FE, $DF, $F5, $BE, $FC, $DB, $BF, $BB, $7E, $96, $EE, $8B, $DD, $FA, $FA
	db $3F, $7D, $FF, $FD, $BF, $CA, $E5, $FF, $BF, $5B, $F1, $FF, $EA, $AC, $A6, $75
	db $DE, $7F, $E7, $FF, $F7, $F3, $BD, $EF, $6F, $13, $33, $F8, $98, $54, $08, $16
	db $02, $C1, $52, $48, $06, $05, $76, $C7, $04, $02, $40, $20, $9C, $D5, $09, $00
	db $00, $09, $41, $38, $00, $2E, $02, $00, $46, $20, $84, $C4, $01, $20, $28, $72
	db $36, $12, $04, $CC, $1D, $D7, $DE, $22, $82, $04, $25, $28, $0A, $8B, $11, $B0
	db $AE, $26, $C8, $11, $2C, $23, $C2, $00, $C2, $A8, $00, $03, $41, $20, $04, $60
	db $57, $0E, $0A, $20, $83, $45, $41, $08, $E8, $A3, $20, $C9, $0E, $0A, $8A, $20
	db $4E, $E2, $00, $83, $86, $00, $02, $D0, $06, $0C, $92, $88, $00, $40, $02, $00
	db $C1, $40, $81, $01, $46, $01, $30, $68, $62, $0F, $92, $20, $82, $06, $A1, $63
	db $24, $30, $41, $F4, $80, $00, $80, $40, $03


UnknownCall_0x3A00:
	ld a, 3 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0xEC31
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3A14:
	ld a, 25 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x66000
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3A28:
	ld a, 3 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0xEC40
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3A3C:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x8240
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret


UnknownCall_0x3A50:
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x58000
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3A64:
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x3D3D
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3A78:
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x5B31D
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3A8C:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x85AA
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3AA0:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x863C
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3AB4:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x85DC
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3AC8:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call $4638
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret


UnknownCall_0x3ADC:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x85FC
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3AF0:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x83EC
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3B04:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x8403
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3B18:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x8318
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3B2C:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x8338
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3B40:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x8358
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3B54:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x8381
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3B68:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x8394
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3B7C:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x83B0
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3B90:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x83D0
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3BA4:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x841A
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3BB8:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x843C
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3BCC:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x8462
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3BE0:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x8484
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3BF4:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x84A6
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3C08:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x84C8
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3C1C:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x84EA
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3C30:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x8510
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3C44:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x8532
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3C58:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x8554
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3C6C:
	ld a, 22 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x5B2D7
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3C80:
	ld a, 3 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0xC000
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3C94:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x8D9C

UnknownCall_0x3C9F:
	ld a, 2 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	jp UnknownJump_0x8DA9

UnknownRJump_0x3CAA:
UnknownCall_0x3CAA:
	ld a, [hli]
	ld [de], a
	inc e
	dec b
	jr nz, UnknownRJump_0x3CAA
	ret

UnknownCall_0x3CB1:
	ldh_a_n $DD
	bit 5, a
	ld a, 1
	jr z, UnknownRJump_0x3CBC
	ld a, 2

UnknownRJump_0x3CBC:
	ldh_n_a $DF
	ret

UnknownCall_0x3CC0:
	ldh_a_n $E7
	bit 3, a
	ret z
	ld hl, $FFC2
	ld a, [sHVelocityIndex]
	cp $80
	jr c, UnknownRJump_0x3CD7
	ld a, [sScrollDeltaRight]
	add b
	ld [sScrollDeltaRight], a

UnknownRJump_0x3CD7:
	ld a, [hl]
	add b
	ld [hli], a
	ld a, [hl]
	adc 0
	ld [hl], a
	ret

UnknownCall_0x3CDF:
	ldh_a_n $E7
	bit 3, a
	ret z
	ld a, [sScrollDeltaDown]
	add b
	ld [sScrollDeltaDown], a
	ld hl, $FFC0
	jr UnknownRJump_0x3CD7

UnknownCall_0x3CF1:
	ldh_a_n $E7
	bit 3, a
	ret z
	ld hl, $FFC2
	ld a, [sHVelocityIndex]
	cp $81
	jr nc, UnknownRJump_0x3D08
	ld a, [sScrollDeltaLeft]
	add b
	ld [sScrollDeltaLeft], a

UnknownRJump_0x3D08:
	ld a, [hl]
	sub b
	ld [hli], a
	ld a, [hl]
	sbc 0
	ld [hl], a
	ret

UnknownCall_0x3D10:
	ldh_a_n $E7
	bit 3, a
	ret z
	ld a, [sScrollDeltaUp]
	add b
	ld [sScrollDeltaUp], a
	ld hl, $FFC0
	jr UnknownRJump_0x3D08

UnknownCall_0x3D22:
	ld hl, $FFD1

UnknownRJump_0x3D25:
	ld a, [hl]
	sub b
	ld [hld], a
	ld a, [hl]
	sbc 0
	ld [hl], a
	ret

UnknownCall_0x3D2D:
	ld hl, $FFD4
	jr UnknownRJump_0x3D25

UnknownCall_0x3D32:
	ld hl, $FFD1

UnknownRJump_0x3D35:
	ld a, [hl]
	add b
	ld [hld], a
	ld a, [hl]
	adc 0
	ld [hl], a
	ret

UnknownCall_0x3D3D:
	ld hl, $FFD4
	jr UnknownRJump_0x3D35

UnknownData_0x3D42:
;unused filler
	db $BE, $E8, $3E, $FA, $FF, $F6, $7F, $9D, $BA, $FF, $8A, $EA, $C5, $EF, $9A, $D4
	db $D3, $DF, $BF, $FF, $5E, $2E, $FB, $2F, $C8, $3E, $DF, $BE, $EE, $AA, $BF, $FF
	db $55, $CB, $BE, $6E, $AA, $8E, $DC, $FF, $F7, $76, $FE, $ED, $FC, $DE, $FB, $DF
	db $AD, $FA, $7A, $96, $FE, $CF, $FF, $6F, $F6, $AE, $BF, $DA, $E2, $3E, $00, $52
	db $A0, $02, $80, $40, $00, $20, $E0, $2E, $02, $06, $81, $00, $18, $C8, $04, $4C
	db $10, $08, $09, $01, $08, $32, $3A, $02, $00, $02, $50, $00, $02, $A4, $28, $20
	db $46, $5B, $20, $48, $02, $02, $00, $00, $11, $06, $0C, $84, $00, $12, $C2, $2A
	db $02, $8A, $2E, $C2, $18, $01, $10, $A8, $C9, $18, $48, $C2, $A8, $62, $2A, $08
	db $90, $00, $41, $42, $82, $00, $02, $20, $F0, $48, $24, $B0, $00, $80, $88, $84
	db $A2, $C8, $C0, $00, $40, $00, $00, $04, $48, $10, $84, $0A, $40, $AA, $05, $02
	db $00, $48, $0C, $24, $88, $41, $22, $E0, $00, $22, $24, $C8, $80, $06, $8A, $08
	db $CC, $22, $80, $D2, $63, $2A, $CB, $30, $68, $80, $A8, $08, $0A, $A6


UnknownCall_0x3E00:
	ld [sCurROMBank], a
	ld [$3000], a
	jp hl

UnknownJump_0x3E07:
	ld a, 15
	ld [sCurROMBank], a
	ld [$3000], a
	ret

UnknownCall_0x3E10:
	di
	ld [sCurROMBank], a
	ld [$3000], a
	ld a, [hl]
	ld [bc], a
	ld a, 15
	ld [sCurROMBank], a
	ld [$3000], a
	ret

UnknownCall_0x3E22:
	di
	ld [sCurROMBank], a
	ld [$3000], a
	ld a, [hli]
	ld [bc], a
	ld a, 15
	ld [sCurROMBank], a
	ld [$3000], a
	ret

UnknownCall_0x3E34:
	di
	ld [sCurROMBank], a
	ld [$3000], a
	ld a, [hl]
	ld [de], a
	ld a, 15
	ld [sCurROMBank], a
	ld [$3000], a
	ret

UnknownCall_0x3E46:
	ld hl, $A100

UnknownRJump_0x3E49:
	xor a
	ld [hli], a
	ld a, l
	cp $A0
	jr c, UnknownRJump_0x3E49
	ret

UnknownCall_0x3E51:
	ld a, 16
	ld [sCurROMBank], a
	ld [$3000], a
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	ld a, 15
	ld [sCurROMBank], a
	ld [$3000], a
	ret

UnknownJump_0x3E73:
	ld a, 1
	ld [sMapFrameSyncFlag], a
	jp UnknownJump_0x3EAFF

UnknownCall_0x3E7B:
	di
	push bc
	ld [sCurROMBank], a
	ld [$3000], a
	ld b, [hl]
	ld a, 15
	ld [sCurROMBank], a
	ld [$3000], a
	ld a, b
	pop bc
	ret

UnknownCall_0x3E8F:
	di
	push de
	ld [sCurROMBank], a
	ld [$3000], a
	ld a, [bc]
	ld d, a
	ld a, 15
	ld [sCurROMBank], a
	ld [$3000], a
	ld a, d
	pop de
	ret

UnknownCall_0x3EA4:
	ld a, 16
	ld [sCurROMBank], a
	ld [$3000], a
	ld de, $88E0
	ld c, 32

UnknownRJump_0x3EB1:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, UnknownRJump_0x3EB1
	ld de, $89E0
	ld c, 32

UnknownRJump_0x3EBC:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, UnknownRJump_0x3EBC
	ld a, 15
	ld [sCurROMBank], a
	ld [$3000], a
	ret

UnknownCall_0x3ECB:
	ld a, 14
	ld [sCurROMBank], a
	ld [$3000], a
	ld de, $8820
	ld c, 32

UnknownRJump_0x3ED8:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, UnknownRJump_0x3ED8
	ld de, $8920
	ld c, 32

UnknownRJump_0x3EE3:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, UnknownRJump_0x3EE3
	ld a, 15
	ld [sCurROMBank], a
	ld [$3000], a
	ret

UnknownCall_0x3EF2:
	ld a, 14
	ld [sCurROMBank], a
	ld [$3000], a
	ld de, $9000
	ld c, 32

UnknownRJump_0x3EFF:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, UnknownRJump_0x3EFF
	ld a, 15
	ld [sCurROMBank], a
	ld [$3000], a
	ret

UnknownCall_0x3F0E:
	ld a, 25
	ld [sCurROMBank], a
	ld [$3000], a
	ld b, 16

UnknownRJump_0x3F18:
	ld a, [hli]
	push hl
	ld hl, rSTAT

UnknownRJump_0x3F1D:
	bit 1, [hl]
	jr nz, UnknownRJump_0x3F1D
	pop hl
	ld [de], a
	inc de
	dec b
	jr nz, UnknownRJump_0x3F18
	ld a, 24
	ld [sCurROMBank], a
	ld [$3000], a
	ret

UnknownCall_0x3F30:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x5297
	ld a, 15 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3F44:
	ld a, 1 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x5297
	ld a, 24 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3F58:
	ld a, BANK(GFX_Mario) ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld bc, $0800
	ld hl, GFX_Mario
	ld de, $8000
	call CopyMem
	ld a, 15 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownCall_0x3F75:
	push af
	ld a, 24 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ld hl, $62E6
	call UnknownCall_0x6109B
	ld a, 15 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	pop af
	ret

UnknownCall_0x3F8E:
	push af
	ld a, 24 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	call UnknownCall_0x61147
	ld a, 15 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	pop af
	ret

UnknownCall_0x3FA4:
	ld a, 14 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a

UnknownRJump_0x3FAC:
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, UnknownRJump_0x3FAC
	ld a, 15 ;prepare bank switch
	ld [sCurROMBank], a
	ld [$2100], a
	ret

UnknownData_0x3FBD:
;unused filler
	db $39, $0D, $68, $00, $18, $01, $75, $44, $61, $10, $12, $4B, $89, $54, $04, $86
	db $13, $32, $07, $90, $12, $32, $04, $63, $08, $04, $22, $04, $10, $14, $CA, $90
	db $20, $0C, $28, $20, $A1, $20, $B2, $82, $23, $A4, $10, $04, $F2, $90, $21, $00
	db $1D, $62, $2A, $01, $12, $30, $48, $A1, $00, $10, $00, $08, $42, $7B, $00, $D0
	db $61, $54, $00

