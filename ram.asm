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

; Overworld map screen state ($A680-$A6B4). All map screens share this block;
; sMapScreenId selects which screen's handler runs (see $3C000 dispatcher).
DEF sMapCamXLo EQU $A680          ; map camera X lo, latched from $FFB9 by $3ED4C
DEF sMapCamXHi EQU $A681          ; map sprites are culled/placed against it
DEF sMapCamYLo EQU $A682          ; map camera Y lo, latched from $FFB7
DEF sMapCamYHi EQU $A683
DEF sMapRasterPhase EQU $A689     ; rSCX wobble phase (hub $3E853, Turtle $3E7F2)
DEF sMapScreenId EQU $A68B        ; 0 hub; 1/8 Pumpkin; 2/5 Tree; 3 Macro; 4 Space;
                                  ; 6 Mario; 7 Turtle; 9-$0E castle/ending screens
DEF sMapCursorWalkFrame EQU $A68C ; cursor walk/idle animation frame ($3C8F4:
                                  ; idle pose = (($A68C & $18) >> 3) + 12)
DEF sMapCursorWalking EQU $A690   ; nonzero while the cursor walks a path
DEF sMapWalkPtrLo EQU $A692       ; ptr into the walk-command stream (bank $18):
DEF sMapWalkPtrHi EQU $A693       ; $563A + node*8 + dir*2 (dir order R,L,U,D);
                                  ; stream = move bytes (01 R, 02 L, 04 U, 08 D)
                                  ; ended by 00, then the destination node id
DEF sMapWalkStepTimer EQU $A694   ; frames per walk step (9/5 when the walk starts,
                                  ; reload 8, or 4 while sMapCursorMove bit 4 set)
DEF sMapCursorPose EQU $A695      ; cursor pose: 0-11 walking, 12-15 idle; indexes
                                  ; the $4AD7 pointer table for the cursor's OAM
DEF sMapRandLatch EQU $A696       ; 40-frame joypad XOR (pseudo-random source)
DEF sMapTickTimer EQU $A697       ; 40-frame countdown; drives sMapRandLatch
DEF sMapAnimPhase EQU $A699       ; Pumpkin animation phase ($5A21/$5A29 tables)
DEF sMapFrameCounter EQU $A69A    ; free-running frame counter; every anim phase
                                  ; source (& $01/$03/$07/$0F/$18/$30/$70/$E0)
DEF sMapAnimIndexA EQU $A6A2      ; 0-$4F index into the $6227 anim table (Pumpkin)
DEF sMapAnimValueA EQU $A6A5      ; scratch copy of $6227[sMapAnimIndexA]
DEF sMapUnused1 EQU $A6A6         ; write-only (cleared by the Pumpkin loader)
DEF sMapMovingX EQU $A6A7         ; moving object X (screen id 5 handler $3DDD3)
DEF sMapMovingDir EQU $A6A8       ; its direction flag (bit0: 0 = -x, 1 = +x)
DEF sMapUnused2 EQU $A6AC         ; write-only (census)
DEF sMapUnused3 EQU $A6AD         ; write-only (census)
DEF sMapAnimIndexB EQU $A6B0      ; $6227 index (Tree handler $3DA2D)
DEF sMapUnused4 EQU $A6B1         ; cleared with sMapAnimIndexB; no reader (census)
DEF sMapKeysXor EQU $A6B2         ; joypad XORed in every frame; NO READER (census)
DEF sMapOAMIndex EQU $A6B3        ; next OAM index for map sprites (starts at 13)
DEF sMapSpriteOffscreen EQU $A6B4 ; $FF when the current sprite is outside the
                                  ; camera window; checked before writing OAM
; Hub map-decoration sprite list: 18 entries x 4 bytes ($A6B5-$A6FC), drawn to OAM
; by $3CFC8 (slots 13+). Fields: +0 = packed coordinate pages (X page in the high
; nibble, Y page in the low nibble; used as $06|nibble), +1 = X lo, +2 = Y lo,
; +3 = sprite id into the $4C4D descriptor table ($FF = entry disabled). Screen
; pos = (Xlo - sMapCamXLo + 8, Ylo - sMapCamYLo + 16); culled unless within
; X (-$30,+$D0] / Y (-$38,+$C8] of the camera. Live (hub): k1-k3 drift +-64 px
; (k2/k3 = clouds, id 9); k4-k9 = the six coin icons, ids written by $3CE43 from
; sGoldenCoin1-6 bit7 (k4<-$A851, k5<-$A84D, k6<-$A856, k7<-$A859, k8<-$A85F,
; k9<-$A865) and cycled 2/3/4 by $3CE6B; k14 = rock (ids 5-8 while the $A789
; sequence runs); k16/k17 = random sparkles (id $0A, positions from $4FA8/$4FB8).
; NOTE: other screens reuse these bytes for stride-3 arrays ($A6C6+3k, $A6CA+3k,
; $A6CB+3k, $A6CC+3k, ...) - names below are the hub (proven) meanings.
DEF sMapSprite0Page EQU $A6B5
DEF sMapSprite0X EQU $A6B6
DEF sMapSprite0Y EQU $A6B7
DEF sMapSprite0Id EQU $A6B8
DEF sMapSprite1Page EQU $A6B9
DEF sMapSprite1X EQU $A6BA
DEF sMapSprite1Y EQU $A6BB
DEF sMapSprite1Id EQU $A6BC
DEF sMapSprite2Page EQU $A6BD
DEF sMapSprite2X EQU $A6BE
DEF sMapSprite2Y EQU $A6BF
DEF sMapSprite2Id EQU $A6C0
DEF sMapSprite3Page EQU $A6C1
DEF sMapSprite3X EQU $A6C2
DEF sMapSprite3Y EQU $A6C3
DEF sMapSprite3Id EQU $A6C4
DEF sMapSprite4Page EQU $A6C5
DEF sMapSprite4X EQU $A6C6
DEF sMapSprite4Y EQU $A6C7
DEF sMapSprite4Id EQU $A6C8
DEF sMapSprite5Page EQU $A6C9
DEF sMapSprite5X EQU $A6CA
DEF sMapSprite5Y EQU $A6CB
DEF sMapSprite5Id EQU $A6CC
DEF sMapSprite6Page EQU $A6CD
DEF sMapSprite6X EQU $A6CE
DEF sMapSprite6Y EQU $A6CF
DEF sMapSprite6Id EQU $A6D0
DEF sMapSprite7Page EQU $A6D1
DEF sMapSprite7X EQU $A6D2
DEF sMapSprite7Y EQU $A6D3
DEF sMapSprite7Id EQU $A6D4
DEF sMapSprite8Page EQU $A6D5
DEF sMapSprite8X EQU $A6D6
DEF sMapSprite8Y EQU $A6D7
DEF sMapSprite8Id EQU $A6D8
DEF sMapSprite9Page EQU $A6D9
DEF sMapSprite9X EQU $A6DA
DEF sMapSprite9Y EQU $A6DB
DEF sMapSprite9Id EQU $A6DC
DEF sMapSprite10Page EQU $A6DD
DEF sMapSprite10X EQU $A6DE
DEF sMapSprite10Y EQU $A6DF
DEF sMapSprite10Id EQU $A6E0
DEF sMapSprite11Page EQU $A6E1
DEF sMapSprite11X EQU $A6E2
DEF sMapSprite11Y EQU $A6E3
DEF sMapSprite11Id EQU $A6E4
DEF sMapSprite12Page EQU $A6E5
DEF sMapSprite12X EQU $A6E6
DEF sMapSprite12Y EQU $A6E7
DEF sMapSprite12Id EQU $A6E8
DEF sMapSprite13Page EQU $A6E9
DEF sMapSprite13X EQU $A6EA
DEF sMapSprite13Y EQU $A6EB
DEF sMapSprite13Id EQU $A6EC
DEF sMapSprite14Page EQU $A6ED
DEF sMapSprite14X EQU $A6EE
DEF sMapSprite14Y EQU $A6EF
DEF sMapSprite14Id EQU $A6F0
DEF sMapSprite15Page EQU $A6F1
DEF sMapSprite15X EQU $A6F2
DEF sMapSprite15Y EQU $A6F3
DEF sMapSprite15Id EQU $A6F4
DEF sMapSprite16Page EQU $A6F5
DEF sMapSprite16X EQU $A6F6
DEF sMapSprite16Y EQU $A6F7
DEF sMapSprite16Id EQU $A6F8
DEF sMapSprite17Page EQU $A6F9
DEF sMapSprite17X EQU $A6FA
DEF sMapSprite17Y EQU $A6FB
DEF sMapSprite17Id EQU $A6FC

; Overworld map working state ($A700-$A7FF): wave strips, per-screen animation
; counters, castle/ending scene state (bank $0F handlers + the bank $18 state
; machines at ROM $60037/$60521/$60A81) and the map tile-patch lists. The
; $A6B5/$A7D0 lists hold 16 x 3 [X, Y, id] records in the zone screens (the hub
; uses the 18 x 4 view documented above; $3E2A2 loads both lists from one table).
; $A700-$A77F: four 32-byte tile-shift strips (2 tiles each) for the hub's wave
; animation; seeded from ROM $3C8E0/$3C9E0/$3CCE0/$3CDE0 by $3E7BE, shifted one
; bit per frame by the $3E853 raster handler (direction alternates with the
; phase) and mirrored to VRAM $88E0/$89E0/$8CE0/$8DE0.
DEF sMapWaveStrip0 EQU $A700
DEF sMapWaveStrip1 EQU $A720
DEF sMapWaveStrip2 EQU $A740
DEF sMapWaveStrip3 EQU $A760
DEF sMapCoinIconPhase EQU $A780     ; 0-2 coin-icon anim phase (every 8 frames -> ids 2/3/4)
DEF sMapCloudDriftCounter EQU $A781 ; sprite 1-3 drift counter (bit 6 = direction); reset on load
DEF sMapDecorOAMIndex EQU $A782     ; OAM entry index for map decorations ($3E277 sets 4 =
                                    ; after the cursor entries; cap $28); $6106D resets to 0
DEF sMapTreeAnimStep EQU $A783      ; Tree screen anim step: bits 0-1 = frame, bit 4 = direction
DEF sMapTreeAnimTick EQU $A784      ; 10-frame tick driving sMapTreeAnimStep
DEF sMapFrameSyncFlag EQU $A785     ; set to 1 by the $3E73 raster trampoline; $3E9EC waits on it
DEF sMapTransitionDir EQU $A786     ; cursor walk dir during screen transitions (1=R 2=L 4=U 8=D)
DEF sMapPatchDrawX EQU $A787        ; scratch X of the current $A7D0 record while drawing
DEF sMapPatchDrawY EQU $A788        ; scratch Y of the current $A7D0 record while drawing
DEF sMapRockAnimTimer EQU $A789     ; rock/gate animation counter (hub k14; $3C4E7 sets 1 at
                                    ; nodes $0C/$1E; $3CF16 walks it to $58)
DEF sMapBandScroll0 EQU $A78A       ; rSCX band 0 (scanlines < $0F); Turtle wobble
DEF sMapBandScroll1 EQU $A78B       ; rSCX band 1 (scanlines $0F-$16; wraps at $18)
DEF sMapBandScroll2 EQU $A78C       ; rSCX band 2 (scanlines $17-$1E)
; Castle/ending scene animation state ($A795-$A79C is zeroed on entry by
; $3F307/$3F4B1/$3F5A4; also used by the zone walk handlers for sprite anims).
DEF sCastleWalkPhase EQU $A795      ; 0-2 walk animation phase (offsets sprite frames)
DEF sMapSprite1AnimCount EQU $A796  ; sprite-1 anim counter (castle: 0-$7F page oscillation;
                                    ; Turtle: 0-2 phase)
DEF sMapAnimStep EQU $A797          ; anim step 0-3 (castle) / palette-flash state 0-2 (Turtle)
DEF sMapAnimAccum EQU $A798         ; accumulator (+= table value mod 3) / free-run counter
DEF sTurtleAnimPhase EQU $A799      ; 0-3 phase counter (Turtle random-anim sprite)
DEF sCastleWalkScriptIdx EQU $A79A  ; index into the $4FA8 Y-offset walk script ($80 = end)
DEF sCastleUnused1 EQU $A79B        ; zeroed on entry; no other refs (census)
DEF sCastleUnused2 EQU $A79C        ; zeroed on entry; no other refs (census)
DEF sMapTransitionState EQU $A79D   ; 1 = walk-out ($3E3BA), 2 = walk-in ($3E2F7), 0 = idle;
                                    ; nonzero gates per-screen logic during the transition
DEF sTurtleMoveState EQU $A79E      ; Turtle decoration movement (0=blink 1=L 2=R 3=U 4=D)
DEF sTurtleBlinkTimer EQU $A79F     ; frames before the next direction pick (30)
DEF sMapScrollOnlyLatch EQU $A7A0   ; $FF while B is held on the hub (camera scrolls, cursor
                                    ; stays, node activation blocked); cleared on release
DEF sCastleRevealProgress EQU $A7A5 ; castle reveal progress: index = (byte & $7C) >> 2,
                                    ; clamped at 29; decremented 2/frame by the walk states
DEF sCastleState EQU $A7A6          ; castle/ending screen state 0-$0B (jp-table index for the
                                    ; bank-$18 machines $60037/$60521/$60A81 and $3C0DF/$3C10E)
DEF sCastleStateTimer EQU $A7A7     ; per-state countdown (walk/jump/pickup timers)
DEF sCastleItemIndex EQU $A7A8      ; item/decoration index at Mario's position (0 = none;
                                    ; -> $4F6A/$4C51/$4C4D tables; pickup grants lives etc.)
DEF sMapSparkleTimer EQU $A7A9      ; sparkle re-arm countdown (4 -> 0; re-arm when rDIV&$72==0)
DEF sCastleMarkerCol EQU $A7AA      ; castle marker tile byte (bit 7 set = draw; low nibble =
                                    ; column); drawn by the $3EBD5 castle IRQ at $988C
DEF sCastleSavedPowerup EQU $A7AB   ; saved sCurPowerup (item-preview fallback)
DEF sCastleItemPreview EQU $A7AC    ; powerup/item id being previewed (-> $4C4D lookup);
                                    ; committed to sCurPowerup on pickup
DEF sCastleRevealTick EQU $A7AD     ; reveal frame counter (bits 2-3 select the sprite-3 frame)
DEF sCastleScriptPtrLo EQU $A7AE    ; item-script pointer lo ($3F4B1 picks by sTimerHigh & $0F)
DEF sCastleScriptPtrHi EQU $A7AF    ; item-script pointer hi
DEF sCastleDecorSlotA EQU $A7B0     ; random active decoration slot index A (0-8, $6046A)
DEF sCastleDecorSlotB EQU $A7B1     ; random active decoration slot index B (0-8, $6046A)
DEF sCastleItemReached EQU $A7B2    ; set when the walk reaches an item slot (gates pickup sfx)
DEF sCastleSpriteAnimState EQU $A7B3 ; sprite-10/11 animation state (1/2/3)
DEF sCastleSpriteAnimTimer EQU $A7B4 ; countdown for sCastleSpriteAnimState
DEF sCastleScriptPtrLoCopy EQU $A7B5 ; loop-back copy of sCastleScriptPtrLo
DEF sCastleScriptPtrHiCopy EQU $A7B6 ; loop-back copy of sCastleScriptPtrHi
DEF sMapRandAccum EQU $A7B7         ; rDIV/$FF97 shuffle accumulator (shared random state)
DEF sMapSpecialNodeLatch EQU $A7B8  ; set to 16 pressing A on a special node ($6E+); NO READER
                                    ; (census) - write-only
DEF sCastleShufflePhase EQU $A7B9   ; 0-2 phase rotating the three VRAM patches
                                    ; ($8D30/$8E70/$9550 via $3F0E)
DEF sMapGrowthActive EQU $A7BA      ; zone growth-animation active flag (0/$FF; gates $3DB12)
DEF sSpaceLaunchState EQU $A7BB     ; Space-zone UFO launch state (0=off 1=launch 2=return 3=scroll)
DEF sSpaceLaunchTimer EQU $A7BC     ; its countdown / scroll amount
DEF sSpaceBlinkTimer EQU $A7BD      ; Space blinker countdown (5 -> 0, re-randomized)
DEF sMapIRQDivider EQU $A7BE        ; per-scanline work divider 0-$0D (Pumpkin/Tree IRQ)
DEF sMapIRQPatchIndex EQU $A7BF     ; IRQ patch frame counter ($3EC7D & $3F / $3ECF5 & 7)
; Map tile-patch list ($A7D0-$A7FF, 48 bytes). Zone/castle screens: 16 x 3 [X, Y,
; patchId] records loaded by $3E2A2, drawn into the VRAM tilemap by $610DD/$61147
; (patchId indexes the $5213/$63EA descriptor lists; $FF = empty). The four
; $A7D2/$A7D5/$A7D8/$A7DB bytes are the records' patchId fields (the per-screen
; "pending tile" registers applied by $3F8E). Screen $0D reuses the same bytes as
; five parallel 5-byte slot arrays + a round-robin index ($A7D0/$A7D5/$A7DA/$A7DF/
; $A7E4 + $A7E9) - names below are the record (zone) view where both apply.
DEF sMapPatchList EQU $A7D0
DEF sMapPatch0Id EQU $A7D2
DEF sMapPatch1Id EQU $A7D5
DEF sMapPatch2Id EQU $A7D8
DEF sCastleSlotCounter EQU $A7DA    ; screen-$0D slot counters (5; increment to $68)
DEF sMapPatch3Id EQU $A7DB
DEF sCastleSlotDelay EQU $A7DF      ; screen-$0D slot respawn delays (5; init 2,26,50,74,98)
DEF sCastleSlotValue EQU $A7E4      ; screen-$0D slot values (5; sprite ids from the script)
DEF sCastleSlotIndex EQU $A7E9      ; screen-$0D round-robin slot index (0-4)
DEF sMapPatch9Id EQU $A7ED          ; record 9 patch id (records 9-12 set to 1 by $601BA)


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