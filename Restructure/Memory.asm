;-------------------------------------------------------------------------------
; ZERO PAGE VARIABLES
;-------------------------------------------------------------------------------
zpDelayCounter          = $02
zpTemp                  = $03
zpLow                   = $04
zpHigh                  = $05
currentLevel            = $06
zpScnPtrLo              = $07
zpScnPtrHi              = $08
zpColPtrLo              = $09
zpColPtrHi              = $0A
zpScnTmpLo              = $0B
zpScnTmpHi              = $0C
zpColTmpLo              = $0D
zpColTmpHi              = $0E
charWidth               = $0F
charRows                = $10
rowOffset               = $11
colourOffset            = $12
hiScorePtrLo            = $13
hiScorePtrHi            = $14
rand                    = $15 ;to $19

introTuneNoteDuration   = $40
introTuneNoteIndex      = $41
introCounter            = $42
quasiJumpFrameCounter   = $43
quasiIntroStage         = $44
quasiX                  = $45
quasiXMSB               = $46
inputSelect             = $47
quasiStats              = $48 ;used for intialisation only
quasiDirection          = $48
quasiBonus              = $49
quasiScore              = $4A ;to $50
quasiExtraLifeFlag      = $51
quasiJumpActive         = $52
quasiOnRopeFlag         = $53
quasiOnBellFlag         = $54
quasiLives              = $55
knightX                 = $56
knightXMSB              = $57
knightY                 = $58
knightMoveRate          = $59
knightCounter           = $5A
knightFrame             = $5B
inputJoy                = $5C
pitKnight               = $5D
lifeLost                = $5E
levelTransitionCounter  = $5F
scoreMultiplier         = $60
scoreTemp               = $61 ;and $62
colourFlashCounter      = $63
enemyStats              = $64 ;used for initialisation only
pitKnight1Frame         = $64
pitKnight2Frame         = $65
pitKnight3Frame         = $66
pitKnight1Counter       = $67
pitKnight2Counter       = $68
pitKnight3Counter       = $69
ropeFrame               = $6A
ropeSpeedCounter        = $6B
missileY                = $6C
missileX                = $6D
missileXMSB             = $6E
missile2Y               = $6F
missile2X               = $70
missile2XMSB            = $71
missile2Delay           = $72
missileDx               = $73
missile2Dx              = $74
heartCounter            = $75
hiScoreFlag             = $76
hiScoreCursorPosition   = $77
hiScoreCharCount        = $78


;-------------------------------------------------------------------------------
; TEMP VARIABLES
;-------------------------------------------------------------------------------
tbl_tmpScreenPointers   = $02B0
tmpScreenChars          = $02C0
tmpScreenColours        = $02D0
inputKeyMatrixCol       = $02E0


*=$2A00
;-------------------------------------------------------------------------------
; GAME TEXT 
;-------------------------------------------------------------------------------
txt_F1Instructions      text 'press {105}{107} for instructions'
txt_SpaceToStart        text '    or space to start    '
txt_TitleScreen
                        incbin "hbtitles.bin"
txt_OceanSoftware       text 'ocean software'
txt_Presents            text '   presents   '
txt_ByJSteele           text '   by j.steele'
txt_HiScore             text 'hiscore'
txt_League              text 'league '
txt_Order               text 'order  '
txt_Score               text ' score '
txt_Name                text 'name.  '
txt_No                  text 'no.'
txt_BonusMan            text 'bonus man at 10000'
txt_Instructions        text '   player  instructions   '
                        text '   {126}left{125} right {124} jump{127}   '
                        text ' score points each phase. '
                        text ' hero wins a    each time '
                        text '   he completes a wall.   '
                        text 'five    gives super bonus.'
txt_InstructionsJoyKeys text 'joystick or keyboard controls hero'
txt_PlayerStats         text ' {68*10} super  score        0       '
                        text '            bonus  lives                '
txt_Featuring           text 'featuring'
txt_KeysOrJoy           text ' select {122}eyboard   or   {123}oystick'
txt_JoyInPort2          text 'place joystick in port 2 '
txt_KeyboardControls    text 'keyboard  controls  {119} {118} jump          '
                        text '{120} {118} move left     {121} {118} move right  '
txt_GetReady            text 'get ready'
txt_MyHero              text 'my hero{151}'
txt_GameOver            text 'game over'
txt_NameRegistration    text ' name registration      '
txt_LettersTopRow       text 'a b c d e f g h i  space'
txt_LettersMiddleRow    text 'j k l m n o p q r  rub  '
txt_LettersBottomRow    text 's t u v w x y z .  end  '


;-------------------------------------------------------------------------------
; LEVEL DATA
;
; Level Types:
; $01 = Knight Pit, $02 = Empty Pit, $04 = Row of Bells
; $08 = Rope Pit, $20 = Esmerelda's Tower, $40 = Wall
;
; Obstacle Types:
; $01 = Rope, $02 = Hi Fireball R-L, $04 = Lo Fireball L-R
; $08 = Lo Fireball R-L, $10 = Double Arrow HiLo R-L
; $20 = Double Arrow HiLo L-R, $40 = Double Fireball Lo L+R
; $80 = Double Arrow HiLo L+r
;-------------------------------------------------------------------------------
tbl_LevelType           byte $20, $28, $22, $21, $21, $22, $28, $21
                        byte $21, $2c, $22, $22, $21, $21, $2c, $31
                        byte $21, $21, $2c, $28, $22, $21, $21, $22
                        byte $21, $22, $21, $2c, $22, $28, $21, $31
                        byte $21, $22, 208, $21, $21, $21, $21, $2c
                        byte $2c, $22, $21, $22, $28, $2c, $21, $31

tbl_LevelTypeBitMask    byte $01, $02, $04, $08, $10, $20

tbl_LevelObstacleType   byte $08, $01, $00, $00, $02, $04, $01, $08
                        byte $10, $08, $20, $40, $20, $40, $80, $40
                        byte $20, $10, $08, $01, $20, $20, $40, $40
                        byte $20, $20, $40, $80, $40, $01, $40, $40
                        byte $20, $40, $01, $10, $20, $08, $10, $08
                        byte $80, $20, $10, $40, $01, $80, $40, $40


;-------------------------------------------------------------------------------
; SOUND DATA
;-------------------------------------------------------------------------------
tbl_IntroTuneDuration   byte $0b, $13, $0b, $0b, $0b, $0b, $13, $0b
                        byte $13, $0b, $0b, $0b, $0b, $13, $0b, $23
                        byte $0b, $0b, $13, $0b, $0b, $0b, $0b, $13
                        byte $0b, $13, $0b, $0b, $0b, $0b, $13, $0b
                        byte $23, $0b, $0b, $13, $0b, $13, $0b, $0b
                        byte $0b, $0b, $13, $0b, $13, $0b, $13, $0b
                        byte $0b, $0b, $0b, $13, $0b, $13, $0b, $13
                        byte $0b, $0b, $0b, $0b, $13, $0b, $26, $33

tbl_IntroTuneFreqHi     byte $0C, $11, $14, $13, $14, $13, $11, $14
                        byte $13, $14, $11, $13, $14, $13, $14, $11
                        byte $00, $0F, $14, $19, $16, $19, $16, $14
                        byte $19, $16, $19, $14, $16, $19, $16, $19
                        byte $14, $00, $1E, $22, $1E, $22, $1E, $16
                        byte $19, $1E, $19, $16, $16, $14, $16, $14
                        byte $0F, $11, $14, $11, $0F, $11, $14, $0F
                        byte $14, $0D, $0F, $11, $0F, $19, $16, $14

tbl_IntroTuneFreqLo     byte $D8, $25, $64, $3F, $64, $3F, $25, $64
                        byte $3F, $64, $25, $3F, $64, $3F, $64, $25
                        byte $00, $46, $64, $B1, $E3, $B1, $E3, $64
                        byte $B1, $E3, $B1, $64, $E3, $B1, $E3, $B1
                        byte $64, $00, $8D, $4B, $8D, $4B, $8D, $E3
                        byte $B1, $8D, $B1, $E3, $E3, $64, $E3, $64
                        byte $46, $25, $64, $25, $46, $25, $64, $46
                        byte $64, $9C, $46, $25, $46, $B1, $E3, $64

tbl_BellHiFreqLo        byte $64, $48, $00, $00, $10, $0a, $00

tbl_BellLoFreqLo        byte $64, $12, $00, $00, $10, $0a, $00

tbl_QuasiJumpFreqLo     byte $00, $04, $28, $00, $40, $00, $09

tbl_RowOfBellsFreqHi    byte $14, $1e, $28, $32

tbl_DeathSoundP1FreqLo  byte $00, $02, $00, $00, $31, $00, $f0

tbl_DeathSoundP2FreqLo  byte $50, $1e, $00, $fa, $be, $50, $28, $a0
                        byte $de, $5a, $1e, $82, $64, $aa, $f0, $1e
                        byte $32, $00

tbl_DeathSoundP3FreqLo  byte $00, $c0, $00, $00, $81, $00, $f0


;-------------------------------------------------------------------------------
; ANIMATION FRAME DATA
;-------------------------------------------------------------------------------
tbl_QuasiLeftJumpFrame  byte $54, $54, $54, $54, $54, $54, $55, $55
                        byte $55, $55, $56, $56, $56, $56, $56, $56

tbl_QuasiWalkRightFrame byte $43, $46, $44, $45

tbl_QuasiWalkFrame      byte $43, $46, $44, $45, $51, $54, $52, $53

tbl_QuasiJumpFrames     byte $46, $46, $46, $46, $46, $46, $47, $47
                        byte $47, $47, $48, $48, $48, $48, $48, $48
                        byte $54, $54, $54, $54, $54, $54, $55, $55
                        byte $55, $55, $56, $56, $56, $56, $56, $56

tbl_RopeUpperFrame      byte $28, $26, $24, $22, $20, $1E, $1C, $1A
                        byte $2A, $2C, $2E, $30, $32, $34, $36, $38
                        byte $38, $36, $34, $32, $30, $2E, $2C, $2A
                        byte $1A, $1C, $1E, $20, $22, $24, $26, $28

tbl_RopeLowerFrame      byte $29, $27, $25, $23, $21, $1F, $1D, $1B
                        byte $2B, $2D, $2F, $31, $33, $35, $37, $39
                        byte $39, $37, $35, $33, $31, $2F, $2D, $2B
                        byte $1B, $1D, $1F, $21, $23, $25, $27, $29

tbl_PitKnightFrame1     byte $20, $20, $20, $20, $20, $20, $45, $20
                        byte $20, $47, $48, $20, $4F, $4A, $49, $50
                        byte $4B, $4C, $51, $4E, $4D

tbl_PitKnightFrame2     byte $20, $20, $20, $45, $20, $20, $46, $20
                        byte $20, $47, $48, $20, $52, $4A, $49, $53
                        byte $4B, $4C, $54, $4E, $4D

tbl_PitKnightFrame3     byte $45, $20, $20, $46, $20, $20, $46, $20
                        byte $20, $56, $48, $20, $55, $4A, $49, $57
                        byte $4B, $4C, $58, $59, $4D

tbl_HeartAnimFrames     byte $3d, $3c, $3d, $3a

;-------------------------------------------------------------------------------
; HI-SCORE DATA
;-------------------------------------------------------------------------------
tbl_HiScoreInit         byte $30, $30, $35, $30, $30, $30, $30, $0A
                        byte $0F, $0E, $30, $30, $35, $30, $30, $30
                        byte $30, $0A, $0F, $0E, $30, $30, $35, $30
                        byte $30, $30, $30, $0A, $0F, $0E, $30, $30
                        byte $35, $30, $30, $30, $30, $0A, $0F, $0E
                        byte $30, $30, $30, $30, $35, $30, $30, $0A
                        byte $0F, $0E

tbl_HiScoreColours      byte BLUE, CYAN, YELLOW, RED, PURPLE, BLUE

tbl_HiScoreCursorScnPos byte $00, $02, $04, $06, $08, $0A, $0C, $0E
                        byte $10, $13, $50, $52, $54, $56, $58, $5A
                        byte $5C, $5E, $60, $63, $A0, $A2, $A4, $A6
                        byte $A8, $AA, $AC, $AE, $B0, $B3, $AA, $AA

tbl_HiScoreChars        text 'abcdefghi jklmnopqr@'
                        text 'stuvwxyz.@'


;-------------------------------------------------------------------------------
; CHARACTER BLOCK & COLOUR DATA
;-------------------------------------------------------------------------------
tbl_LevelCharBlockLo    byte <Screen_BuildKnights, <Screen_BuildPits, <Screen_BuildRowOfBells
                        byte <Screen_BuildRopePit, <Screen_BuildEsmereldaTower, <Screen_BuildWall

tbl_LevelCharBlockHi    byte >Screen_BuildKnights, >Screen_BuildPits, >Screen_BuildRowOfBells
                        byte >Screen_BuildRopePit, >Screen_BuildEsmereldaTower, >Screen_BuildWall

tbl_BellChars           byte CHAR_BELL_LR, CHAR_BELL_LL, CHAR_BELL_UR, CHAR_BELL_UL

tbl_BellCharsXOffset    byte $29, $28, $01, $00

tbl_KnightChars         byte $20, $45, $20, $20, $3B, $47, $48, $20
                        byte $3C, $4F, $4A, $49, $3C, $50, $4B, $4C
                        byte $3C, $51, $4E, $4D
        
tbl_KnightCharsColours  byte $00, $0A, $00, $00, $02, $0A, $0B, $00
                        byte $02, $0A, $0A, $0A, $02, $0A, $0A, $0A
                        byte $02, $0A, $0A, $0A

tbl_EmptyPitChars       byte $20, $20, $20, $20, $3b, $20, $20, $20
                        byte $3c, $20, $20, $20, $3c, $20, $20, $20
                        byte $3c, $20, $20, $20
        
tbl_EmptyPitCharColours byte $00, $00, $00, $00, $02, $00, $00, $00
                        byte $02, $00, $00, $00, $02, $00, $00, $00
                        byte $02, $00, $00, $00

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

tbl_RowOfBellsCharCols  byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c

tbl_EsmereldaTowerChars byte $20, $20, $6f, $6e, $20, $20, $20, $20
                        byte $20, $6F, $6C, $6C, $6E, $3F, $40, $43
                        byte $6F, $6C, $A0, $A1, $6C, $41, $42, $43
                        byte $6C, $6C, $A2, $A3, $6C, $6D, $20, $43
                        byte $6C, $6C, $A4, $A5, $6C, $6D, $20, $43
                        byte $6C, $6C, $A6, $A7, $6C, $6D, $20, $43
                        byte $6C, $6C, $6C, $6C, $6C, $6D, $20, $43
                        byte $6C, $6C, $6C, $6C, $6C, $6D, $20, $43
                        byte $6C, $6C, $6C, $6C, $6C, $6C, $20, $43

tbl_EsmeTowerCharColour byte $08, $08, $08, $08, $08, $08, $08, $08
                        byte $08, $08, $08, $08, $08, $0C, $0C, $0C
                        byte $08, $08, $0F, $0F, $08, $0C, $0C, $0C
                        byte $08, $08, $0A, $0F, $08, $0C, $0C, $0C
                        byte $08, $08, $0A, $0A, $08, $0C, $0C, $0C
                        byte $08, $08, $0A, $0A, $08, $0C, $0C, $0C
                        byte $08, $08, $08, $08, $08, $0C, $0C, $0C
                        byte $08, $08, $08, $08, $08, $0C, $0C, $0C
                        byte $08, $08, $08, $08, $08, $0C, $0C, $0C

tbl_WallCharColours     byte $0b, $0b, $0b, $0f, $0f, $0f, $09, $09
                        byte $09, $0c, $0c, $0d, $0d, $0d, $08, $08

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

tbl_LevelEndBellChars   byte $3f, $40, $43, $41, $42, $43, $5a, $20
                        byte $43, $5a, $20, $43, $5a, $20, $43, $5a
                        byte $20, $43, $5a, $20, $43, $20, $20, $43

tbl_LevelEndBellCols    byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
                        byte $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c

tbl_TheBellsChars       byte $80, $81, $82, $83, $84, $85, $86, $87
                        byte $88, $89, $8A, $8B, $8C, $8D, $8E, $8F
                        byte $88, $89, $8A, $8B, $90, $20, $91, $92
                        byte $90, $20, $91, $92, $93, $94, $95, $96

tbl_LevelMarkerChars    byte $5B, $5F, $5F, $5F, $5F, $5F, $5C, $62
                        byte $20, $20, $20, $20, $66, $61, $62, $64
                        byte $64, $64, $64, $65, $61, $5D, $60, $60
                        byte $60, $60, $60, $5E

tbl_LevelMarkerCharCol  byte $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
                        byte $0D, $0D, $0D, $0D, $0A, $0A, $0A, $0A
                        byte $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
                        byte $0A, $0A, $0A, $0A

tbl_LevelMarkerPixel    byte $80, $20, $08, $02

tbl_BridgeChars         byte $20, $20, $20, $20, $20, $20, $20, $20
                        byte $20, $3E, $3E, $3E

tbl_ScoreBoxChars       byte $5B, $5F, $5F, $5F, $5F, $5F, $5C, $62
                        byte $13, $03, $0F, $12, $05, $61, $62, $30
                        byte $30, $30, $30, $30, $61, $5D, $60, $60
                        byte $60, $60, $60, $5E

tbl_ScoreBoxCharColours byte $0a, $0a, $0a, $0a, $0a, $0a, $0a, $0a
                        byte $01, $01, $01, $01, $01, $0a, $0a, $01
                        byte $01, $01, $01, $01, $0a, $0a, $0a, $0a
                        byte $0a, $0a, $0a, $0a


;-------------------------------------------------------------------------------
; SCREEN DATA
;-------------------------------------------------------------------------------
tbl_BridgeCharsXOffset  byte $00, $01, $02, $28, $29, $2A, $50, $51
                        byte $52, $78, $79, $7A

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

tbl_ScreenPointers      byte $50, $74, $50, $d8, $78, $38, $78, $3C

tbl_TheBellsScreenLo    byte $73, $75, $77, $7b, $7d, $7f, $81, $83

tbl_LevelMarkerXOffset  byte $00, $01, $02, $03, $04, $05, $06, $28
                        byte $29, $2A, $2B, $2C, $2D, $2E, $50, $51
                        byte $52, $53, $54, $55, $56, $78, $79, $7A
                        byte $7B, $7C, $7D, $7E

tbl_ScreenScrollPtrs    byte $50, $74, $50, $d8, $50, $38, $50, $3C

tbl_ScoreBoxCharX       byte $00, $01, $02, $03, $04, $05, $06, $28
                        byte $29, $2A, $2B, $2C, $2D, $2E, $50, $51
                        byte $52, $53, $54, $55, $56, $78, $79, $7A
                        byte $7B, $7C, $7D, $7E

tbl_PitCharsX           byte $00, $01, $02, $28, $29, $2A, $50, $51
                        byte $52, $78, $79, $7A, $A0, $A1, $A2, $C8
                        byte $C9, $CA, $F0, $F1, $F2


;-------------------------------------------------------------------------------
; SPRITE XY DATA
;-------------------------------------------------------------------------------
tbl_TheBellsQuasiX      byte $60, $70, $80, $a0, $b0, $c0, $d0, $e0

tbl_QuasiJumpYOffset    byte $00, $06, $0B, $0E, $10, $12, $13, $14
                        byte $14, $13, $12, $10, $0E, $0B, $06, $00

tbl_QuasiRopeXPosition  byte $C6, $C2, $BA, $B2, $AC, $A6, $9E, $98
                        byte $94, $8A, $82, $7C, $76, $6E, $66, $62
                        byte $62, $66, $6E, $76, $7C, $82, $8A, $94
                        byte $98, $9E, $A6, $AC, $B2, $BA, $C2, $C6

tbl_RowOfBellsXPosition byte $78, $98, $b8, $d8

tbl_BellRopeXOffset     byte $5e, $7e, $9e, $be

tbl_RopeXPositions      byte $BC, $B8, $B0, $A8, $A2, $9C, $94, $8E
                        byte $8A, $80, $78, $72, $6C, $64, $5C, $58
                        byte $58, $5C, $64, $6C, $72, $78, $80, $8A
                        byte $8E, $94, $9C, $A2, $A8, $B0, $B8, $BC

tbl_QuasiBellXPosition  byte $62, $82, $a2, $c2

tbl_PitLocationStartX   byte $42, $8A, $D2

tbl_PitLocationEndX     byte $5A, $A2, $EA

tbl_RopeUpperX          byte $B8, $B8, $B8, $B8, $B8, $B8, $B8, $B8
                        byte $8A, $8A, $8A, $8A, $8A, $8A, $8A, $8A
                        byte $8A, $8A, $8A, $8A, $8A, $8A, $8A, $8A
                        byte $B8, $B8, $B8, $B8, $B8, $B8, $B8, $B8

tbl_RopeLowerX          byte $C0, $BA, $B8, $B8, $B8, $B8, $B8, $B8
                        byte $8A, $8A, $8A, $8A, $8A, $8A, $88, $82
                        byte $82, $88, $8A, $8A, $8A, $8A, $8A, $8A
                        byte $B8, $B8, $B8, $B8, $B8, $B8, $BA, $C0

tbl_HeartSpritesXY      byte $48, $72, $38, $b6, $94, $d0, $f8, $c3
                        byte $24, $86, $eb, $60, $88, $46, $20


;-------------------------------------------------------------------------------
; INPUT DATA
;-------------------------------------------------------------------------------
tbl_KeyboardMatrixCol   byte $7f, $bf, $df, $ef, $f7, $fb, $fd, $fe

tbl_KeyMatrixColOffset  byte $06, $02, $02

tbl_KeyboardMatrixRow   byte $04, $80, $10

tbl_KeyToJoyMap         byte $10, $04, $08


;-------------------------------------------------------------------------------
; OTHER DATA
;-------------------------------------------------------------------------------
tbl_ScoreMultiplier     byte $90, $50, $46, $3c, $32, $28, $1e, $14

tbl_EnemyInit           byte $00, $00, $00, $41, $21, $01, $0f, $01
                        byte $75, $56, $01, $75, $56, $01, $60, $02
                        byte $FE

tbl_KnightMoveRates     byte $30, $20, $10


tbl_HiScores            = $3700
scn_TemporaryScreen     = $3800
scn_TemporaryColour     = $3C00

;-------------------------------------------------------------------------------
; CHARS
;-------------------------------------------------------------------------------
*=$4000
                        incbin "chrHunchback.cst", 0, 204

chr_Marker              = $4318
chr_Block1              = $4390
chr_Block2              = $4398

;-------------------------------------------------------------------------------
; SPRITES
;-------------------------------------------------------------------------------
*=$4680
                        incbin "sprHunchback.spt", 1, 62, true





