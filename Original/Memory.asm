;Zeropage Variable Space

bcdValue                = $02
bcdTemp                 = $04

zpTemp                  = $60
zpLo                    = $60
zpHi                    = $61
zpTemp2                 = $61

zpScnPtrLo              = $62
zpScnPtrHi              = $63
zpScnSrcLo              = $64
zpScnSrcHi              = $65
zpColPtrLo              = $64
zpColPtrHi              = $65
hiScorePtrLo            = $63
hiScorePtrHi            = $64

zpTemp3                 = $66

zpBridgeScnPtrLo        = $FB
zpBridgeScnPtrHi        = $FC
zpBridgeColPtrLo        = $FD
zpBridgeColPtrHi        = $FE

;Game variables

tbl_tmpScreenPointers   = $02C0

tmpScreenChars          = $02D0
tmpScreenColours        = $02E0

quasiJumpFrame          = $033C
quasiIntroStage         = $033C 
currentLevel            = $033D
quasiIntroJumpFrame     = $033D
quasiJumpActive         = $033E 
quasiIntroX             = $033E
quasiIntroXMSB          = $033F
quasiJumpFrameCounter   = $033F
quasiX                  = $0340
quasiXMSB               = $0341
unused0342              = $0342
unused0343              = $0343
unused0344              = $0344
quasiStats              = $0345
quasiDirection          = $0346
quasiBonus              = $0348
quasiScore              = $0349 ;to $034F
quasiExtraLifeFlag      = $0350
quasiLives              = $0351
pitKnight1Frame         = $0360
pitKnight1Counter       = $0361
pitKnight2Frame         = $0362
pitKnight2Counter       = $0363
pitKnight3Frame         = $0364
pitKnight3Counter       = $0365
ropeFrame               = $0366
ropeSpeedCounter        = $0367
missileY                = $0368
missileX                = $0369
missileXMSB             = $036A
missile2Y               = $036B
missile2X               = $036C
missile2XMSB            = $036D
missile2Delay           = $036E
missileDx               = $036F
missile2Dx              = $0370
heartCounter            = $0371
knightY                 = $0372
knightX                 = $0373
knightXMSB              = $0374
knightMoveRate          = $0375
knightFrame             = $0376
knightCounter           = $0377
QuasiOnRopeFlag         = $0378
QuasiOnBellFlag         = $0379
scoreMultiplier         = $0391
scoreLevel              = $0392
;scoreLevel+1           = $0393
hiScoreCursorPosition   = $03A0
hiScoreCharCount        = $03A1
flashBGColour1Flag      = $03C0
introTuneNoteDuration   = $03D0
introTuneNoteIndex      = $03D1
quasiLevelStartFrame    = $03E0
rand                    = $03E2 ;to $03E7
inputKeyMatrixCol       = $03F0
inputSelect             = $03FC
inputJoy                = $03FF

;Memory
*=$3F1F
tbl_RowOfBellsFreqHi    byte $14, $1e, $28, $32

*=$3F23
tbl_QuasiJumpFreqLo     byte $00, $04, $28, $00, $40, $00, $09

*=$3F2A
tbl_BellHiFreqLo        byte $64, $48, $00, $00, $10, $0a, $00

*=$3F31
tbl_BellLoFreqLo        byte $64, $12, $00, $00, $10, $0a, $00

*=$3F38
tbl_WallBaseChars       byte $3e, $ab, $ac, $3e, $3E, $3E, $3E, $3E
                        byte $3E, $3E, $3E, $3E, $3E, $3E, $3E, $3E
                        byte $3E, $3E, $3E, $3E, $3E, $3E, $3E, $3E
                        byte $3E, $3E, $3E, $3E, $3E, $3E, $3E, $3E
                        byte $3E, $C8, $3E, $3E, $3E, $3E, $3E, $3E
                        byte $AA, $65, $65, $AD, $AE, $AF, $3E, $3E
                        byte $3E, $3E, $3E, $3E, $3E, $3E, $3E, $3E
                        byte $3E, $3E, $3E, $3E, $3E, $3E, $3E, $3E
                        byte $3E, $3E, $3E, $3E, $3E, $3E, $3E, $3E
                        byte $C7, $65, $C9, $CA, $C8, $C8, $CB, $CC
                        byte $65, $65, $65, $65, $65, $65, $B0, $B1
                        byte $B2, $B3, $B4, $3E, $3E, $3E, $3E, $3E
                        byte $3E, $3E, $B9, $BA, $BB, $BC, $BD, $3E
                        byte $3E, $3E, $3E, $3E, $3E, $C4, $C5, $C6
                        byte $65, $65, $65, $65, $65, $65, $65, $65
                        byte $65, $65, $65, $65, $65, $65, $65, $65
                        byte $65, $65, $65, $B5, $B6, $B7, $B8, $B5
                        byte $B6, $B8, $65, $65, $65, $65, $65, $BE
                        byte $BF, $C0, $C1, $C2, $C3, $65, $65, $65
                        byte $65, $65, $65, $65, $65, $65, $65, $65
                        byte $65, $65, $65, $65, $65, $65, $65, $65
                        byte $65, $65, $65, $65, $65, $65, $65, $65
                        byte $65, $65, $65, $65, $65, $65, $65, $65
                        byte $65, $65, $65, $65, $65, $65, $65, $65
                        byte $65, $65, $65, $65, $65, $65, $65, $65

*=$59E6
tbl_HiScoreChars        text 'abcdefghi jklmnopqr@'
                        text 'stuvwxyz.@'

*=$5A04
txt_LettersBottomRow    text 's t u v w x y z .  end  '

*=$5A1C
txt_LettersMiddleRow    text 'j k l m n o p q r  rub  '

*=$5A34
txt_LettersTopRow       text 'a b c d e f g h i  space'

*=$5A4C
txt_NameRegistration    text ' name registration      '

*=$5A64
tbl_HiScoreCursorScnPos byte $00, $02, $04, $06, $08, $0A, $0C, $0E
                        byte $10, $13, $50, $52, $54, $56, $58, $5A
                        byte $5C, $5E, $60, $63, $A0, $A2, $A4, $A6
                        byte $A8, $AA, $AC, $AE, $B0, $B3, $AA, $AA

*=$5A84
txt_GameOver            text 'game over'

*=$5A8D
tbl_PitLocationEndX     byte $5A, $A2, $EA

*=$5A90
tbl_PitLocationStartX   byte $42, $8A, $D2

*=$5A93
tbl_RopeXPositions      byte $BC, $B8, $B0, $A8, $A2, $9C, $94, $8E
                        byte $8A, $80, $78, $72, $6C, $64, $5C, $58
                        byte $58, $5C, $64, $6C, $72, $78, $80, $8A
                        byte $8E, $94, $9C, $A2, $A8, $B0, $B8, $BC

*=$5AB3
tbl_BellRopeXOffset     byte $5e, $7e, $9e, $be

*=$5AB7
tbl_KeyToJoyMap         byte $10, $04, $08

*=$5ABA
tbl_KeyboardMatrixRow   byte $04, $80, $10

*=$5ABD
tbl_KeyMatrixColOffset  byte $06, $02, $02

*=$5AC0
tbl_KeyboardMatrixCol   byte $7f, $bf, $df, $ef, $f7, $fb, $fd, $fe

*=$5AC8
tbl_HeartSpritesXY      byte $48, $72, $38, $b6, $94, $d0, $f8, $c3
                        byte $24, $86, $eb, $60, $88, $46, $20

*=$5AD7
tbl_HeartAnimFrames     byte $93, $92, $93, $90

*=$5ADB
tbl_ScoreMultiplier     byte $50, $46, $3c, $32, $28, $1e, $14

*=$5AE2
tbl_Unused_5AE2         byte $0a, $00

*=$5AE4
tbl_ScoreBoxCharColours byte $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a
                        byte $01, $01, $01, $01, $01, $0a, $0a, $01
                        byte $01, $01, $01, $01, $0a, $0a, $0a, $0a
                        byte $0a, $0a, $0a, $0a

*=$5B00 ;Rope Sprites
                        incbin "sprHunchback.spt", 1, 32, true

*=$6300
txt_MyHero              text 'my hero{151}'

*=$6308
tbl_ScoreBoxChars       byte $5B, $5F, $5F, $5F, $5F, $5F, $5C, $62
                        byte $13, $03, $0F, $12, $05, $61, $62, $30
                        byte $30, $30, $30, $30, $61, $5D, $60, $60
                        byte $60, $60, $60, $5E

*=$6324
tbl_ScoreBoxCharX       byte $00, $01, $02, $03, $04, $05, $06, $28
                        byte $29, $2A, $2B, $2C, $2D, $2E, $50, $51
                        byte $52, $53, $54, $55, $56, $78, $79, $7A
                        byte $7B, $7C, $7D, $7E

*=$6340
tbl_QuasiBellXPosition  byte $62, $82, $a2, $c2


*=$6344
tbl_RowOfBellsXPosition byte $78, $98, $b8, $d8

*=$6348
tbl_QuasiRopeXPosition  byte $C6, $C2, $BA, $B2, $AC, $A6, $9E, $98
                        byte $94, $8A, $82, $7C, $76, $6E, $66, $62
                        byte $62, $66, $6E, $76, $7C, $82, $8A, $94
                        byte $98, $9E, $A6, $AC, $B2, $BA, $C2, $C6

*=$6368
tbl_RopeUpperFrame      byte $7A, $78, $76, $74, $72, $70, $6E, $6C
                        byte $7C, $7E, $80, $82, $84, $86, $88, $8A
                        byte $8A, $88, $86, $84, $82, $80, $7E, $7C
                        byte $6C, $6E, $70, $72, $74, $76, $78, $7A

*=$6388
tbl_RopeLowerFrame      byte $7B, $79, $77, $75, $73, $71, $6F, $6D
                        byte $7D, $7F, $81, $83, $85, $87, $89, $8B
                        byte $8B, $89, $87, $85, $83, $81, $7F, $7D
                        byte $6D, $6F, $71, $73, $75, $77, $79, $7B

*=$63A8
tbl_RopeUpperX          byte $B8, $B8, $B8, $B8, $B8, $B8, $B8, $B8
                        byte $8A, $8A, $8A, $8A, $8A, $8A, $8A, $8A
                        byte $8A, $8A, $8A, $8A, $8A, $8A, $8A, $8A
                        byte $B8, $B8, $B8, $B8, $B8, $B8, $B8, $B8

*=$63C8
tbl_RopeLowerX          byte $C0, $BA, $B8, $B8, $B8, $B8, $B8, $B8
                        byte $8A, $8A, $8A, $8A, $8A, $8A, $88, $82
                        byte $82, $88, $8A, $8A, $8A, $8A, $8A, $8A
                        byte $B8, $B8, $B8, $B8, $B8, $B8, $BA, $C0

*=$63E8
tbl_BridgeChars         byte $20, $20, $20, $20, $20, $20, $20, $20
                        byte $20, $3E, $3E, $3E

*=$63F4
tbl_BridgeCharsXOffset  byte $00, $01, $02, $28, $29, $2A, $50, $51
                        byte $52, $78, $79, $7A

*=$6400 ;Heart and Knight Sprites
                        incbin "sprHunchback.spt", 33, 40, true

*=$6600
tbl_EnemyInit           byte $00, $41, $00, $21, $00, $01, $0f, $01
                        byte $75, $56, $01, $75, $56, $01, $60, $02
                        byte $FE

*=$6611
tbl_KnightFrame3Chars   byte $45, $20, $20, $46, $20, $20, $46, $20
                        byte $20, $56, $48, $20, $55, $4A, $49, $57
                        byte $4B, $4C, $58, $59, $4D

*=$6626 ;Unused data
                        byte $45, $20, $20, $20

*=$662A
tbl_KnightFrame2Chars   byte $20, $20, $20, $45, $20, $20, $46, $20
                        byte $20, $47, $48, $20, $52, $4A, $49, $53
                        byte $4B, $4C, $54, $4E, $4D

*=$663F
tbl_KnightFrame1Chars   byte $20, $20, $20, $20, $20, $20, $45, $20
                        byte $20, $47, $48, $20, $4F, $4A, $49, $50
                        byte $4B, $4C, $51, $4E, $4D

*=$6654
tbl_PitCharsX           byte $00, $01, $02, $28, $29, $2A, $50, $51
                        byte $52, $78, $79, $7A, $A0, $A1, $A2, $C8
                        byte $C9, $CA, $F0, $F1, $F2

*=$6669
tbl_ScreenScrollPts     byte $50, $74, $50, $d8, $50, $84, $50, $88

*=$6671
tbl_QuasiWalkFrame      byte $A0, $A3, $A1, $A2, $AE, $B1, $AF, $B0

*=$6679 ;Jump right x 16, jump left x 16
tbl_QuasiJumpFrames     byte $A4, $A4, $A4, $A4, $A4, $A4, $A5, $A5
                        byte $A5, $A5, $A6, $A6, $A6, $A6, $A6, $A6
                        byte $B2, $B2, $B2, $B2, $B2, $B2, $B3, $B3
                        byte $B3, $B3, $B4, $B4, $B4, $B4, $B4, $B4

*=$6699
tbl_LevelMarkerPixel    byte $80, $20, $08, $02

*=$669D
tbl_LevelMarkerXOffset  byte $00, $01, $02, $03, $04, $05, $06, $28
                        byte $29, $2A, $2B, $2C, $2D, $2E, $50, $51
                        byte $52, $53, $54, $55, $56, $78, $79, $7A
                        byte $7B, $7C, $7D, $7E

*=$66B9
tbl_LevelMarkerChars    byte $5B, $5F, $5F, $5F, $5F, $5F, $5C, $62
                        byte $20, $20, $20, $20, $66, $61, $62, $64
                        byte $64, $64, $64, $65, $61, $5D, $60, $60
                        byte $60, $60, $60, $5E

*=$66D5
tbl_LevelMarkerCharCol  byte $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
                        byte $0D, $0D, $0D, $0D, $0A, $0A, $0A, $0A
                        byte $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
                        byte $0A, $0A, $0A, $0A

*=$66F1
txt_GetReady            text 'get ready'

*=$66FA
txt_KeyboardControls    text 'keyboard  controls  {119} {118} jump          '
                        text '{120} {118} move left     {121} {118} move right  '

*=$6742
txt_InstructionsJoyKeys text 'joystick or keyboard controls hero'

*=$6764
txt_Instructions        text '   player  instructions   '
                        text '   {126}left{125} right {124} jump{127}   '
                        text ' score points each phase. '
                        text ' hero wins a    each time '
                        text '   he completes a wall.   '
                        text 'five    gives super bonus.'

*=$6800 ;Quasi, arrows and fireballs sprites
                        incbin "sprHunchback.spt", 41, 62, true

*=$6D80
txt_KeysOrJoy           text ' select {122}eyboard   or   {123}oystick'

*=$6DA0
txt_JoyInPort2          text 'place joystick in port 2 '

*=$6DC0
tbl_KnightMoveRates     byte $30, $20, $10

*=$6DC3
tbl_BellChars           byte CHAR_BELL_LR, CHAR_BELL_LL, CHAR_BELL_UR, CHAR_BELL_UL

*=$6DC7
txt_Featuring           text 'featuring'

*=$6DD0 ;to 6DEF
tbl_TheBellsChars       byte $80, $81, $82, $83, $84, $85, $86, $87
                        byte $88, $89, $8A, $8B, $8C, $8D, $8E, $8F
                        byte $88, $89, $8A, $8B, $90, $20, $91, $92
                        byte $90, $20, $91, $92, $93, $94, $95, $96

*=$6DF0
tbl_BellCharsXOffset    byte $29, $28, $01, $00

*=$6DF4
tbl_TheBellsScreenLo    byte $73, $75, $77, $7b, $7d, $7f, $81, $83

*=$6DFC
tbl_TheBellsQuasiX      byte $60, $70, $80, $a0, $b0, $c0, $d0, $e0

*=$6E04
tbl_QuasiWalkRightFrame byte $a0, $a3, $a1, $a2

*=$6E08
tbl_QuasiLeftJumpFrame  byte $B2, $B2, $B2, $B2, $B2, $B2, $B3, $B3
                        byte $B3, $B3, $B4, $B4, $B4, $B4, $B4, $B4

*=$6E18
tbl_QuasiJumpYOffset    byte $00, $06, $0B, $0E, $10, $12, $13, $14
                        byte $14, $13, $12, $10, $0E, $0B, $06, $00

*=$6E28
tbl_ScreenPointers      byte $50, $74, $50, $d8, $78, $84, $78, $88

*=$6E30
tbl_RowOfBellsChars     byte $3f, $40, $44, $44, $3f, $40, $44, $44
                        byte $3f, $40, $44, $44, $3f, $40, $41, $42
                        byte $20, $20, $41, $42, $20, $20, $41, $42
                        byte $20, $20, $41, $42, $5a, $20, $20, $20
                        byte $5a, $20, $20, $20, $5a, $20, $20, $20
                        byte $5a, $20, $5a, $20, $20, $20, $5a, $20
                        byte $20, $20, $5a, $20, $20, $20, $5a, $20
                        byte $5a, $20, $20, $20, $5a, $20, $20, $20
                        byte $5a, $20, $20, $20, $5a, $20, $5a, $20
                        byte $20, $20, $5a, $20, $20, $20, $5a, $20
                        byte $20, $20, $5a, $20, $5a, $20, $20, $20
                        byte $5a, $20, $20, $20, $5a, $20, $20, $20
                        byte $5a, $20, $5a, $20, $20, $20, $5a, $20
                        byte $20, $20, $5a, $20, $20, $20, $5a, $20

*=$6EA0
tbl_LevelEndBellChars   byte $3f, $40, $43, $41, $42, $43, $5a, $20
                        byte $43, $5a, $20, $43, $5a, $20, $43, $5a
                        byte $20, $43, $5a, $20, $43, $20, $20, $43

*=$6EB8
tbl_EsmereldaTowerChars byte $20, $20, $6f, $6e, $20, $20, $20, $20
                        byte $20, $6F, $6C, $6C, $6E, $3F, $40, $43
                        byte $6F, $6C, $A0, $A1, $6C, $41, $42, $43
                        byte $6C, $6C, $A2, $A3, $6C, $6D, $20, $43
                        byte $6C, $6C, $A4, $A5, $6C, $6D, $20, $43
                        byte $6C, $6C, $A6, $A7, $6C, $6D, $20, $43
                        byte $6C, $6C, $6C, $6C, $6C, $6D, $20, $43
                        byte $6C, $6C, $6C, $6C, $6C, $6D, $20, $43
                        byte $6C, $6C, $6C, $6C, $6C, $6C, $20, $43

*=$6F00
tbl_EsmeTowerCharColour byte $08, $08, $08, $08, $08, $08, $08, $08
                        byte $08, $08, $08, $08, $08, $0C, $0C, $0C
                        byte $08, $08, $0F, $0F, $08, $0C, $0C, $0C
                        byte $08, $08, $0A, $0F, $08, $0C, $0C, $0C
                        byte $08, $08, $0A, $0A, $08, $0C, $0C, $0C
                        byte $08, $08, $0A, $0A, $08, $0C, $0C, $0C
                        byte $08, $08, $08, $08, $08, $0C, $0C, $0C
                        byte $08, $08, $08, $08, $08, $0C, $0C, $0C
                        byte $08, $08, $08, $08, $08, $0C, $0C, $0C

*=$6F4F
tbl_KnightChars         byte $20, $45, $20, $20, $3B, $47, $48, $20
                        byte $3C, $4F, $4A, $49, $3C, $50, $4B, $4C
                        byte $3C, $51, $4E, $4D
        
*=$6F63
tbl_KnightCharsColours  byte $00, $0A, $00, $00, $02, $0A, $0B, $00
                        byte $02, $0A, $0A, $0A, $02, $0A, $0A, $0A
                        byte $02, $0A, $0A, $0A

*=$6F77
tbl_EmptyPitChars       byte $20, $20, $20, $20, $3b, $20, $20, $20
                        byte $3c, $20, $20, $20, $3c, $20, $20, $20
                        byte $3c, $20, $20, $20
        
*=$6F8B
tbl_EmptyPitCharColours byte $00, $00, $00, $00, $02, $00, $00, $00
                        byte $02, $00, $00, $00, $02, $00, $00, $00
                        byte $02, $00, $00, $00

*=$6F9F
tbl_CharBlockRoutineLo  byte <Screen_DrawKnights_42E2, <Screen_DrawEmptyPit_4338, <Screen_DrawRowOfBells_4399
                        byte <Screen_DrawRopePit_428D, <Screen_DrawEsmereldaTower_4350, <Screen_DrawStandardLevel_4287

*=$6FA5
tbl_CharBlockRoutineHi  byte >Screen_DrawKnights_42E2, >Screen_DrawEmptyPit_4338, >Screen_DrawRowOfBells_4399
                        byte >Screen_DrawRopePit_428D, >Screen_DrawEsmereldaTower_4350, >Screen_DrawStandardLevel_4287

*=$6FAB
tbl_BitMask             byte $01, $02, $04, $08, $10, $20

*=$6FB1
tbl_WallCharColours     byte $0b, $0b, $0b, $0f, $0f, $0f, $09, $09
                        byte $09, $0c, $0c, $0d, $0d, $0d, $08, $08

*=$6FC1
tbl_Unused_6FC1         byte $08, $08, $08, $0B, $0B, $0B, $0C, $0C
                        byte $0C, $0C, $0F, $0F, $0F, $0D, $0D, $08
                        byte $09, $09, $09, $0B, $0B, $0C, $0C, $0C
                        byte $08, $08, $0D, $0D, $0F, $09, $09, $08

*=$6FE1 ;1=rope, 2=high fireball, 4=arrow behind low, 8=fireball low, 16=arrow top/bottom
        ;32=arrow front, 64=fireball top/bottom, 128=arrow front/behind
tbl_LevelEnemyType      byte $08, $01, $00, $00, $02, $04, $01, $08 ;08 01 00 00 02 04 01 08
                        byte $10, $08, $20, $40, $20, $40, $80, $40
                        byte $20, $10, $08, $01, $20, $20, $40, $40
                        byte $20, $20, $40, $80, $40, $01, $40, $40
                        byte $20, $40, $01, $10, $20, $08, $10, $08
                        byte $80, $20, $10, $40, $01, $80, $40, $40

*=$7011 ;1=knight pit, 2=empty pit, 4=bells, 8=rope pit, 16=esmerelda, 32=wall 
tbl_LevelType           byte $20, $08, $22, $21, $21, $22, $08, $21 ;20 08 22 21 21 22 08 21
                        byte $21, $2c, $22, $22, $21, $21, $2c, $31
                        byte $21, $21, $2c, $08, $22, $21, $21, $22
                        byte $21, $22, $21, $2c, $22, $08, $21, $31
                        byte $21, $22, $08, $21, $21, $21, $21, $2c
                        byte $2c, $22, $21, $22, $08, $2c, $21, $31

*=$7041
txt_PlayerStats         text ' {68*10} super  score        0       '
                        text '            bonus  lives                '

*=$7091
tbl_PlayerStatsColours  byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $02, $02, $02, $02, $02
                        byte $02, $01, $01, $01, $01, $01, $01, $01
                        byte $01, $03, $03, $03, $03, $03, $03, $03
                        byte $03, $03, $03, $03, $03, $03, $03, $03
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $02, $02, $02, $02, $02
                        byte $02, $03, $03, $03, $03, $03, $03, $03
                        byte $00, $05, $05, $05, $05, $05, $05, $05
                        byte $00, $00, $00, $00, $00, $00, $00, $00

*=$70E1
tbl_HiScoreColours      byte BLUE, CYAN, YELLOW, RED, PURPLE, BLUE

*=$70E7
txt_No                  text 'no.'

*=$70EB
tbl_Unused_70EB         byte $28, $50, $78, $A0

*=$70EF
txt_Name                text 'name.  '

*=$70F6
txt_Score               text ' score '

*=$70FD
txt_Order               text 'order  '

*=$7104
txt_League              text 'league '

*=$710B
txt_HiScore             text 'hiscore'

*=$7112
txt_BonusMan            text 'bonus man at 10000'

*=$7124
txt_OceanSoftware       text 'ocean software'
txt_Presents            text '   presents   '
txt_ByJSteele           text '   by j.steele'

*=$714E
txt_F1Instructions      text 'press {105}{107} for instructions'

*=$7167
txt_SpaceToStart        text '    or space to start    '

*$=7180
tbl_HiScoreInit         byte $30, $30, $35, $30, $30, $30, $30, $0A
                        byte $0F, $0E, $30, $30, $35, $30, $30, $30
                        byte $30, $0A, $0F, $0E, $30, $30, $35, $30
                        byte $30, $30, $30, $0A, $0F, $0E, $30, $30
                        byte $35, $30, $30, $30, $30, $0A, $0F, $0E
                        byte $30, $30, $35, $30, $30, $30, $30, $0A
                        byte $0F, $0E

*=$71B2
txt_TitleScreen
                        incbin "hbtitles.bin"

*=$77F8
tbl_Unused_77F8         byte $B4, $95, $AD, $A8, $84, $90, $85, $91 


*=$7800 ;to 7CBF
                        incbin "chrHunchback.cst", 0, 151

chr_Marker              = $7B18
chr_Block1              = $7B90
chr_Block2              = $7B98

*=$7CC0
tbl_DeathSoundP1FreqLo  byte $00, $02, $00, $00, $31, $00, $f0

*=$7CC8
tbl_DeathSoundP2FreqLo  byte $50, $1e, $00, $fa, $be, $50, $28, $a0
                        byte $de, $5a, $1e, $82, $64, $aa, $f0, $1e
                        byte $32, $00

*=$7CE0
tbl_DeathSoundP3FreqLo  byte $00, $c0, $00, $00, $81, $00, $f0

*=$7D00
                        incbin "chrHunchback.cst", 160, 204

*=$7F00
tbl_IntroTuneFreqHi     byte $0C, $11, $14, $13, $14, $13, $11, $14
                        byte $13, $14, $11, $13, $14, $13, $14, $11
                        byte $00, $0F, $14, $19, $16, $19, $16, $14
                        byte $19, $16, $19, $14, $16, $19, $16, $19
                        byte $14, $00, $1E, $22, $1E, $22, $1E, $16
                        byte $19, $1E, $19, $16, $16, $14, $16, $14
                        byte $0F, $11, $14, $11, $0F, $11, $14, $0F
                        byte $14, $0D, $0F, $11, $0F, $19, $16, $14

*=$7F40
tbl_IntroTuneFreqLo     byte $D8, $25, $64, $3F, $64, $3F, $25, $64
                        byte $3F, $64, $25, $3F, $64, $3F, $64, $25
                        byte $00, $46, $64, $B1, $E3, $B1, $E3, $64
                        byte $B1, $E3, $B1, $64, $E3, $B1, $E3, $B1
                        byte $64, $00, $8D, $4B, $8D, $4B, $8D, $E3
                        byte $B1, $8D, $B1, $E3, $E3, $64, $E3, $64
                        byte $46, $25, $64, $25, $46, $25, $64, $46
                        byte $64, $9C, $46, $25, $46, $B1, $E3, $64

*=$7F80
tbl_IntroTuneDuration   byte $08, $10, $08, $08, $08, $08, $10, $08
                        byte $10, $08, $08, $08, $08, $10, $08, $20
                        byte $08, $08, $10, $08, $08, $08, $08, $10
                        byte $08, $10, $08, $08, $08, $08, $10, $08
                        byte $20, $08, $08, $10, $08, $10, $08, $08
                        byte $08, $08, $10, $08, $10, $08, $10, $08
                        byte $08, $08, $08, $10, $08, $10, $08, $10
                        byte $08, $08, $08, $08, $10, $08, $23, $30


tbl_HiScores            = $8100
scn_TemporaryScreen     = $8400
scn_TemporaryColour     = $8800
