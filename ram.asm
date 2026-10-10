; WRAM ($A200-$A2FF) Variables
DEF sHVelocityIndex EQU $A200
DEF sVVelocityIndex EQU $A201
DEF sMarioXSub EQU $A202
DEF sMapBlockPtrLow EQU $A203
DEF sMapBlockPtrHigh EQU $A204
DEF sCollisionTilePtrLow EQU $A205
DEF sCollisionTilePtrHigh EQU $A206
DEF sSavedLCDC EQU $A207
DEF sMetatileTile0 EQU $A208
DEF sMetatileTile1 EQU $A209
DEF sMetatileTile2 EQU $A20A
DEF sMetatileTile3 EQU $A20B
DEF sPrevMarioY EQU $A20C
DEF sCollisionTile EQU $A20D
DEF sScreenTransition EQU $A20E
DEF sLevelInitDone EQU $A211
DEF sFireballDirection EQU $A212
DEF sMarioOnGround EQU $A214
DEF sMarioInAir EQU $A215
DEF sCurPowerup EQU $A216
DEF sInvincibilityTimer EQU $A217
DEF sMarioXPushed EQU $A218
DEF sMarioXSubSaved EQU $A219
DEF sScanlineDeltaMax EQU $A21F
DEF sSpinJumpBounce EQU $A220
DEF sPipeTravelDirection EQU $A221
DEF sMarioWalkAnimTimer EQU $A222
DEF sMapScrollFlags EQU $A223
DEF sMarioDead EQU $A224
DEF sMarioX EQU $A227
DEF sMarioXU EQU $A228
DEF sMarioY EQU $A229
DEF sMarioYU EQU $A22A
DEF sMarioDirection EQU $A22B
DEF sLives EQU $A22C
DEF sLevelGfxIndex EQU $A22D
DEF sScrollRightEnabled EQU $A232
DEF sScrollLeftEnabled EQU $A233
DEF sScrollDeltaRight EQU $A235
DEF sScrollDeltaLeft EQU $A236
DEF sScrollDeltaUp EQU $A237
DEF sScrollDeltaDown EQU $A238
DEF sScanlineStamp EQU $A239
DEF sMarioScreenY EQU $A23B
DEF sMarioScreenX EQU $A23C
DEF sPauseState EQU $A23D
DEF sBlockAnimType EQU $A23E
DEF sBlockAnimTimer EQU $A23F
DEF sBlockAnimYLow EQU $A240
DEF sBlockAnimYHigh EQU $A241
DEF sBlockAnimXLow EQU $A242
DEF sBlockAnimXHigh EQU $A243
DEF sMarioObjectYDelta EQU $A244
DEF sMarioObjectXDelta EQU $A245
DEF sObjectHitResult EQU $A246
DEF sObjectBumpHit EQU $A247
DEF sVRAMTransferActive EQU $A248
DEF sSceneTransitionLatch EQU $A249
DEF sSceneTransitionFlag EQU $A24A
DEF sTimerTickCounter EQU $A24B
DEF sWaterCurrentState EQU $A24C
DEF sFlutterTimer EQU $A24D
DEF sCurROMBank EQU $A24E
DEF sGoalBell EQU $A24F
DEF sTimerLow EQU $A254
DEF sTimerHigh EQU $A255
DEF sObjectBumpSpecial EQU $A256
DEF sStarCarryover EQU $A257
DEF sLevelBank EQU $A258
DEF sFireballPhase EQU $A259
DEF sMarioThrowTimer EQU $A25A
DEF sFireballActive EQU $A25B
DEF sInLevelFlag EQU $A25C
DEF sFireballY EQU $A25D
DEF sFireballYU EQU $A25E
DEF sFireballX EQU $A25F
DEF sFireballXU EQU $A260
DEF sCoinLow EQU $A262
DEF sCoinHigh EQU $A263
DEF sSavedOAMIndex EQU $A264
DEF sVRAMTransferBank EQU $A265
DEF sFadeTimerLow EQU $A266
DEF sFadeTimerHigh EQU $A267
DEF sSpinJump EQU $A268
DEF sCurLevel EQU $A269
DEF sMarioOnObject EQU $A26B
DEF sPendingItemId EQU $A26C
DEF sSwimming EQU $A26D
DEF sOAMWriteEnd EQU $A26E
DEF sStarTimerHigh EQU $A271
DEF sStarTimerLow EQU $A272
DEF sCreditsTextPtrLo EQU $A273
DEF sCreditsTextPtrHi EQU $A274
DEF sMenuState EQU $A277
DEF sMenuTimer EQU $A278
DEF sStompChainCount EQU $A279
DEF sStompBounceTimer EQU $A27A
DEF sPrevSwimming EQU $A27B
DEF sFlutterCharge EQU $A27C
DEF sLevelProgressFlags EQU $A27D
DEF sBGPalette EQU $A27E
DEF sOAMPalette1 EQU $A27F
DEF sOAMPalette2 EQU $A280
DEF sPipeAlignTarget EQU $A283
DEF sFlutterArmed EQU $A284
DEF sMoonJumpPoseTimer EQU $A285
DEF sJumpFlag EQU $A286
DEF sMoonPhysics EQU $A287
DEF sSceneVramFlag EQU $A288
DEF sSidePushDir EQU $A28A
DEF sSceneState EQU $A28B
DEF sVramPumpFlag EQU $A28C
DEF sMoneyBagCount EQU $A28D
DEF sSceneId EQU $A28E
DEF sSceneIdHi EQU $A28F
DEF sMarioDucking EQU $A291
DEF sLevelSong EQU $A292
DEF sTileAnimTimer EQU $A298
DEF sTileAnimConfig EQU $A299
DEF sPaletteFadeStep EQU $A29B
DEF sMapEventFlag EQU $A29E
DEF sSecretRouteFlag EQU $A2A0
DEF sSaveFileIndex EQU $A2A3
DEF sLevelLoadFlag EQU $A2A7
DEF sSceneDoneFlag EQU $A2A8
DEF sObjectType EQU $A2A9
DEF sObjectBoxTop EQU $A2AA
DEF sObjectBoxBottom EQU $A2AB
DEF sObjectBoxLeft EQU $A2AC
DEF sObjectBoxRight EQU $A2AD
DEF sObjectY EQU $A2AE
DEF sObjectX EQU $A2AF
DEF sScrollY EQU $A2B0
DEF sScrollX EQU $A2B1
DEF sMoonFloatTimer EQU $A2B2
DEF sCameraPanTimer EQU $A2B3
DEF sExitTileFlag EQU $A2B4
DEF sGoldenCoinFlags EQU $A2B5
DEF sMoonFxState EQU $A2B6
DEF sMoonFxTimer EQU $A2B7
DEF sMoonFxYU EQU $A2B8
DEF sMoonFxY EQU $A2B9
DEF sMoonFxXU EQU $A2BA
DEF sMoonFxX EQU $A2BB
DEF sRedrawScrollY EQU $A2C0
DEF sRedrawScrollYU EQU $A2C1
DEF sRedrawScrollX EQU $A2C2
DEF sRedrawScrollXU EQU $A2C3
DEF sLevelTally EQU $A2C5
DEF sFileClearMode EQU $A2C6
DEF sCursorHopActive EQU $A2C7
DEF sAutoScroll EQU $A2C8
DEF sRowShiftIndex EQU $A2C9
DEF sRowShiftCount EQU $A2CA
DEF sMusicQueue EQU $A2CB
DEF sCastleCoinDone EQU $A2CC
DEF sTileAnimPhase EQU $A2CD
DEF sSoundDisabled EQU $A2CE
DEF sDemoInputPos EQU $A2CF
DEF sPrevKeysHeld EQU $A2D0
DEF sCursorAnimY EQU $A2D1
DEF sLevelGfxConfig EQU $A2D2
DEF sCoinIconDropY EQU $A2D3
DEF sObjectBounce EQU $A2D4
DEF sLoadFadeFlag EQU $A2D5
DEF sCreditsTextPhase EQU $A2D6
DEF sCreditsTextFlag EQU $A2D7
DEF sCreditsTextDone EQU $A2D8
DEF sMapScrollLimit EQU $A2D9
DEF sEndingColClear EQU $A2DA
DEF sEndingColCopy EQU $A2DB
DEF sBossFightPhase EQU $A2DC
DEF sEndingState EQU $A2DD
DEF sNoJumpCut EQU $A2DE
DEF sEndingRasterY EQU $A2DF
DEF sBossDefeated EQU $A2E0
DEF sCreditsScrollY EQU $A2E1
DEF sEndingTileFlag EQU $A2E2
DEF sBossClearFlag EQU $A2E3
DEF sEasyMode EQU $A2E4

DEF sCurSong EQU $A469
DEF sFastMusic EQU $A50D

; Level header block ($A800-$A813): 20 bytes copied from levels/levelheaders.asm
; by LoadLevelHeader ($5579, bank 1) at level load; secret route overlays
; $A800-$A807 from UnknownData_0x377B (home.asm).
DEF sLevelStartYLo EQU $A800      ; Mario start Y, lo -> $FFC0 (sPrevMarioY)
DEF sLevelStartYHi EQU $A801      ; Mario start Y, hi -> $FFC1
DEF sLevelStartXLo EQU $A802      ; Mario start X, lo -> $FFC2
DEF sLevelStartXHi EQU $A803      ; Mario start X, hi -> $FFC3
DEF sLevelCamYLo EQU $A804        ; starting camera Y, lo -> $FFC8 (intro pan target)
DEF sLevelCamYHi EQU $A805        ; -> $FFC9
DEF sLevelCamXLo EQU $A806        ; -> $FFCA
DEF sLevelCamXHi EQU $A807        ; -> $FFCB
DEF sVramTransferSrcLo EQU $A808  ; latch of $FFB1 by the $2297 VRAM-transfer op; WRITE-ONLY
DEF sVramTransferSrcHi EQU $A809  ; latch of $FFB2; WRITE-ONLY
DEF sTilesetMapPtrLo EQU $A80B    ; level mapping ptr (512 B -> $A600, $03F1/bank $08)
DEF sTilesetMapPtrHi EQU $A80C
DEF sLevelDataBank EQU $A80D      ; level's ROM bank -> sLevelBank
DEF sLevelMusic EQU $A80E         ; level music id -> sLevelSong / $A468 queue
DEF sLevelBGPalette EQU $A80F     ; -> sBGPalette/rBGP
DEF sLevelOAMPalette1 EQU $A810   ; -> sOAMPalette1/rOBP0
DEF sLevelOAMPalette2 EQU $A811   ; -> sOAMPalette2/rOBP1
DEF sLevelLayoutIndex EQU $A812   ; lo nibble = layout index ($42F0 table, $0361);
                                  ; hi nibble = initial sSceneState ($0472/$0609)
DEF sLevelTimeLimit EQU $A813     ; -> sTimerHigh

; Overworld map state ($A840-$A878). $A840-$A87F is the 64-byte save-record
; image (save: UnknownCall_0x2934; load: file select), so every byte persists.
DEF sMapNode EQU $A840            ; current map node: $4218 -> sCurLevel, $650E, $5EE6 (bank18)
DEF sMapCursorX EQU $A842         ; cursor screen X; OAM entry at +4
DEF sMapCursorY EQU $A843         ; cursor screen Y; OAM entry at +8
DEF sMapCursorMove EQU $A844      ; pose/move cmd: bit0 R, bit1 L, bit2 U, bit3 D, bit5 bump
DEF sLevelProgress EQU $A848      ; per-level flags (slot via $304F1/$3C364 offset tables):
                                  ; bit7 = level cleared, bit3 = secret-route marker
; Map path/element flags: bit set = element present; each group is copied into the
; $A6C3/$A6C0/$A6CC map tile buffer by UnknownCall_0x3DB00 (tile $0E vs $FF).
DEF sMapTreeAPath0 EQU $A849      ; Tree Zone scr A group ($A849-$A84D -> $A6C3)
DEF sMapTreeAPath1 EQU $A84A
DEF sGoldenCoin1 EQU $A84D        ; Tree Zone scr A golden coin (bit7 = collected)
DEF sMapPumpkinPath0 EQU $A84E    ; Pumpkin Zone scr A group ($A84E-$A851 -> $A6C0)
DEF sMapPumpkinPath1 EQU $A84F
DEF sMapPumpkinPath2 EQU $A850
DEF sGoldenCoin2 EQU $A851        ; Pumpkin Zone scr A golden coin
DEF sMapMacroPath0 EQU $A853      ; Macro Zone group ($A853-$A856 -> $A6C3)
DEF sMapMacroPath2 EQU $A855      ; read-only (no writer in ROM; census)
DEF sGoldenCoin3 EQU $A856        ; Macro Zone golden coin
DEF sMapSpacePath0 EQU $A858      ; Space Zone group ($A858-$A859 -> $A6C3)
DEF sGoldenCoin4 EQU $A859        ; Space Zone golden coin
DEF sMapTreeBPath0 EQU $A85D      ; Tree Zone scr B group ($A85D-$A85F -> $A6C3)
DEF sMapTreeBPath1 EQU $A85E
DEF sGoldenCoin5 EQU $A85F        ; Tree Zone scr B golden coin
DEF sMapMarioPath0 EQU $A862      ; Mario Zone group ($A862-$A865 -> $A6CC)
DEF sMapMarioPath1 EQU $A863
DEF sMapMarioPath2 EQU $A864
DEF sGoldenCoin6 EQU $A865        ; Mario Zone golden coin
DEF sMapGateMacro EQU $A86B       ; set7 completing node $6A; gates Macro cursor moves
DEF sMapGatePumpkinA EQU $A86C    ; read-only (no writer in ROM; census)
DEF sMapGateMario EQU $A86D       ; set7 completing node $66
DEF sMapGatePumpkinB EQU $A86E    ; set7 completing node $78
DEF sMapGatePumpkinC EQU $A86F    ; set7 completing node $7A
DEF sMapGateSpace EQU $A871       ; read-only (no writer in ROM; census)
DEF sMapCursorAnim EQU $A878      ; walk anim pattern ($92 while walking, rrca per frame)

; Fireball slots ($A880/$A890), $10 bytes each (scanner steps $10 until l==$A0):
; +0 active, +1/+2 Y (lo/hi), +3/+4 X (lo/hi), +5 direction, +6 sFireballPhase
DEF sFireball1Active EQU $A880
DEF sFireball2Active EQU $A890

; Object/actor table ($AD00-$AEFF), 16 slots x $20
DEF sObjectTable EQU $AD00
DEF sObject0Def EQU $AD05
DEF sObject0State EQU $AD08
DEF sObject0Y EQU $AD09
DEF sObject0X EQU $AD0A
DEF sObject0Type EQU $AD12
DEF sObject1Def EQU $AD25
DEF sObject1Y EQU $AD29
DEF sObject1Sprite EQU $AD2B
DEF sObject1Busy EQU $AD2F
DEF sObject2Y EQU $AD49
DEF sObject2Busy EQU $AD4F

; Object scratch page ($AF00-$AFD1)
DEF sObjectSpawnXHi EQU $AF00
DEF sObjectSpawnXLo EQU $AF01
DEF sObjectStagedMaxHi EQU $AF02
DEF sObjectStagedMaxLo EQU $AF03
DEF sObjectStagedMinHi EQU $AF04
DEF sObjectStagedMinLo EQU $AF05
DEF sSpriteMapIndex EQU $AF06
DEF sObjectSourceGone EQU $AF07
DEF sObjectUpdatePhase EQU $AF08
DEF sClearStageFlags EQU $AF09
DEF sObjectActXMaxHi EQU $AF0A
DEF sObjectActXMaxLo EQU $AF0B
DEF sObjectActXMinHi EQU $AF0C
DEF sObjectActXMinLo EQU $AF0D
DEF sObjectActYMaxHi EQU $AF0E
DEF sObjectActYMaxLo EQU $AF0F
DEF sObjectActYMinHi EQU $AF10
DEF sObjectActYMinLo EQU $AF11
DEF sObjectScanXMaxHi EQU $AF12
DEF sObjectScanXMaxLo EQU $AF13
DEF sObjectScanXMinHi EQU $AF14
DEF sObjectScanXMinLo EQU $AF15
DEF sObjectAliveYMaxHi EQU $AF16
DEF sObjectAliveYMaxLo EQU $AF17
DEF sObjectAliveYMinHi EQU $AF18
DEF sObjectAliveYMinLo EQU $AF19
DEF sObjectAliveXMaxHi EQU $AF1A
DEF sObjectAliveXMaxLo EQU $AF1B
DEF sObjectAliveXMinHi EQU $AF1C
DEF sObjectAliveXMinLo EQU $AF1D
DEF sObjectStreamPtrHi EQU $AF1E
DEF sObjectStreamPtrLo EQU $AF1F
DEF sObjectScanDir EQU $AF22
DEF sObjectPrevCamXHi EQU $AF24
DEF sObjectPrevCamXLo EQU $AF25
DEF sObjectRemoveMode EQU $AF26
DEF sObjectWalkBusy EQU $AF27
DEF sObjectSlotPtrHi EQU $AF28
DEF sObjectSlotPtrLo EQU $AF29
DEF sObjectWindowHit EQU $AF2A
DEF sSpriteFlipFlags EQU $AF2B
DEF sObjectFacing EQU $AF2C
DEF sObjectHitFlag EQU $AF2E
DEF sMoveFlags EQU $AF2F
DEF sMarioRefXLo EQU $AF30
DEF sMarioRefXHi EQU $AF31
DEF sMarioRefYLo EQU $AF32
DEF sMarioRefYHi EQU $AF33
DEF sMarioRefXSave EQU $AF34
DEF sMarioRefYSave EQU $AF35
DEF sObjectSpawnAnim EQU $AF36
DEF sObjectSpawnSprite EQU $AF37
DEF sObjectSpawnAttr EQU $AF38
DEF sActionLatch EQU $AF3A
DEF sObjectDone EQU $AF3E
DEF sStandbyObjectCount EQU $AF40
DEF sActiveObjectCount EQU $AF41
DEF sHitTestType EQU $AF47
DEF sHitTestBoxTop EQU $AF48
DEF sHitTestBoxBottom EQU $AF49
DEF sHitTestBoxLeft EQU $AF4A
DEF sHitTestBoxRight EQU $AF4B
DEF sHitTestY EQU $AF4C
DEF sHitTestX EQU $AF4D
DEF sBitScanCount EQU $AF4E
DEF sBitScanStart EQU $AF4F
DEF sObjectDefIndex EQU $AFC0
DEF sObjectDefCount EQU $AFC1
DEF sObjectSlotCount EQU $AFC2
DEF sBossHitLatch EQU $AFC3
DEF sSavedFrameState EQU $AFC4
DEF sBossHits EQU $AFC5
DEF sBossAltPhase EQU $AFC6
DEF sDoorPhase EQU $AFC7
DEF sDoorSequenceActive EQU $AFC8
DEF sDoorParity EQU $AFC9
DEF sObjectDefSprite EQU $AFCA
DEF sSceneSlotParity EQU $AFCB
DEF sSavedObjectType EQU $AFCC
DEF sTimerReload EQU $AFCD
DEF sBossTransition EQU $AFCE
DEF sEndingDoorActive EQU $AFCF
DEF sBossDelay EQU $AFD0
DEF sSavedPowerState EQU $AFD1

; HRAM Variables
DEF hKeysHeld EQU $FF80
DEF hKeysPressed EQU $FF81