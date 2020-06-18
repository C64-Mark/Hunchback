; 10 SYS16384

*=$0801
                byte $0B, $08, $0A, $00, $9E, $31 
                byte $36, $33, $38, $34, $00, $00, $00

*=$3C00
Sound_PlayRowOfBellsSound_3C00
        LDX #0
.CheckNextBell
        LDA tbl_RowOfBellsXPosition,X
        CMP quasiX
        BCS .BellSoundSelected
        INX 
        JMP .CheckNextBell
.BellSoundSelected
        LDA #SND_TRIANGLE_GATE_OFF
        STA VCREG3
        LDA #0
        STA FREL3
        STA SUREL3
        LDA #10
        STA ATDCY3
        LDA tbl_RowOfBellsFreqHi,X
        STA FREH3
        LDA #SND_TRIANGLE_GATE_ON
        STA VCREG3
        RTS

*=$3C2C
Sound_PlayQuasiDeathSound_3C2C
        LDA #SND_DISABLE_VOICE
        STA VCREG1
        STA VCREG2
        STA VCREG3
        LDX #6
.DeathSoundPart1Loop
        LDA tbl_DeathSoundP1FreqLo,X
        STA FREL1,X
        DEX 
        BPL .DeathSoundPart1Loop
        LDX #17
.DeathSoundPart2Loop
        LDA tbl_DeathSoundP2FreqLo,X
        STA FREL1
        TXA 
        LDX #30
.DeathSoundOuterLoop
        LDY #0
.DeathSoundInnerLoop
        DEY 
        BNE .DeathSoundInnerLoop
        DEX 
        BNE .DeathSoundOuterLoop
        TAX 
        DEX 
        BPL .DeathSoundPart2Loop
        LDA #SND_DISABLE_VOICE
        STA VCREG1
        RTS 

*=$3C5F
Screen_SetFlashBGColourIRQ_3C5F
        SEI 
        LDA #1
        STA flashBGColour1Flag
        LDA #<IRQ_FlashBGColour1_3C73
        STA sysIntVectorLo
        LDA #>IRQ_FlashBGColour1_3C73
        STA sysIntVectorHi
        CLI 
        JMP Sound_PlayQuasiDeathSound2_3C8B

*=$3C73
IRQ_FlashBGColour1_3C73
        DEC flashBGColour1Flag
        BEQ .FlashBGColour1
        JMP krnINTERRUPT
.FlashBGColour1
        LDA BGCOL1
        EOR #7
        STA BGCOL1
        LDA #1
        STA flashBGColour1Flag
        JMP krnINTERRUPT


*=$3C8B
Sound_PlayQuasiDeathSound2_3C8B
        LDA #%11110001
        STA FLTCON
        LDA #31
        STA SIDVOL
        LDA #0
        STA FLTCUTLO
        LDX #6
.DeathSoundPart3Loop
        LDA tbl_DeathSoundP3FreqLo,X
        STA FREL1,X
        DEX 
        BPL .DeathSoundPart3Loop
        LDX #40
.DeathSoundP3MajorLoop
        STX FREH1
        STX FLTCUTHI
        TXA 
        LDX #8
.DeathSoundP3OuterLoop
        LDY #0
.DeathSoundP3InnerLoop
        DEY 
        BNE .DeathSoundP3InnerLoop
        DEX 
        BNE .DeathSoundP3OuterLoop
        CLC 
        ADC #10
        TAX 
        CPX #200
        BNE .DeathSoundP3MajorLoop
        LDA #SND_DISABLE_VOICE
        STA VCREG1
        LDA #15
        STA SIDVOL
        LDA #0
        STA FLTCON
        SEI 
        LDA #<krnINTERRUPT
        STA sysIntVectorLo
        LDA #>krnINTERRUPT
        STA sysIntVectorHi
        CLI 
        LDA #GRAY1
        STA BGCOL1
        RTS 


*=$3CE1
Sound_DisableVoices_3CE1
        LDA #SND_DISABLE_VOICE
        STA VCREG1
        STA VCREG2
        STA VCREG3
        JMP Initialise_QuasiClimbWall_458D


*=$3CEF
Sound_IntroTune_3CEF
        DEC introTuneNoteDuration
        BEQ .PlayIntroTuneNote
.ExitSoundIntroTune
        JMP krnINTERRUPT
.PlayIntroTuneNote
        LDX introTuneNoteIndex
        JSR Sound_IntroTuneDuration_3D42
        STA introTuneNoteDuration
        LDA #SND_SAW_GATE_OFF
        STA VCREG1
        LDA tbl_IntroTuneFreqHi,X
        STA FREH1
        LDA tbl_IntroTuneFreqLo,X
        STA FREL1
        LDA #0
        STA SUREL1
        LDA #9
        STA ATDCY1
        INX 
        TXA 
        AND #63
        STA introTuneNoteIndex
        LDA #SND_SAW_GATE_ON
        STA VCREG1
        JMP .ExitSoundIntroTune


*=$3D2A
Initialise_InitIntroTune_3D2A
        LDA #SND_DISABLE_VOICE
        STA VCREG1
        STA VCREG2
        STA VCREG3
        LDA #1
        STA introTuneNoteDuration
        LDA #0
        STA introTuneNoteIndex
        JMP Initialise_ClearScreen_4039


*=$3D42
Sound_IntroTuneDuration_3D42
        LDA tbl_IntroTuneDuration,X
        CLC 
        ADC #3
        RTS 


*=$3E00
Game_HiScoreDelay_3E00
        LDX #12
.HiScoreDelayMajorLoop
        TXA 
        LDX #0
.HiScoreDelayOuterLoop
        LDY #0
.HiScoreDelayInnerLoop
        DEY 
        BNE .HiScoreDelayInnerLoop
        DEX 
        BNE .HiScoreDelayOuterLoop
        TAX 
        DEX 
        BNE .HiScoreDelayMajorLoop
        LDA #0
        STA SPREN
        RTS


*=$3E17
Screen_SetWallColours_3E17
        STA scn_TemporaryColour+$02B8,X
        STA scn_TemporaryColour+$0300,X
        RTS 


*=$3E1E
Screen_DrawWallBase_3E1E
        LDX #200
.DrawWallBaseLoop
        LDA tbl_WallBaseChars-1,X
        STA scn_TemporaryScreen+$031F,X
        DEX 
        BNE .DrawWallBaseLoop
        RTS


*=$3E2A
Sound_PlayMissileSound_3E2A
        LDA #SND_NOISE_GATE_OFF
        STA VCREG1
        LDA #44
        STA FREH1
        LDA #100
        STA FREL1
        LDA #128
        STA ATDCY1
        LDA #0
        STA SUREL1
        LDA #SND_NOISE_GATE_ON
        STA VCREG1
        RTS


*=$3E49
Sound_PlayRopeSound_3E49
        LDA #SND_NOISE_GATE_OFF
        STA VCREG1
        LDA #15
        STA FREH1
        LDA #100
        STA FREL1
        LDA #176
        STA ATDCY1
        LDA #0
        STA SUREL1
        LDA #SND_NOISE_GATE_ON
        STA VCREG1
        RTS 
        

*=$3E68
Sound_MissileFired_3E68
        JSR Sound_PlayMissileSound_3E2A
        JMP Game_Randomise_4F34


*=$3E6E
Initialise_ResetVolume_3E6E
        LDA #15 ;is 0 in original
        STA SIDVOL
        JMP Initialise_ClearScreen_4039


*=$3E76
Sound_BellBonusCashIn_3E76
        DEC quasiBonus
        LDA #SND_TRIANGLE_GATE_OFF
        STA VCREG3
        LDA #100
        STA FREL3
        LDA #122
        STA FREH3
        LDA #10
        STA ATDCY3
        LDA #0
        STA SUREL3
        LDA #SND_TRIANGLE_GATE_ON
        STA VCREG3
        RTS


*=$3E98
Score_IncrementBellBonus_3E98
        INC quasiBonus
        LDA #SND_DISABLE_VOICE
        STA VCREG1
        STA VCREG2
        STA VCREG3
        RTS
        

*=$3EA7
Sound_PlayBellSound_3EA7
        LDX #6
.PlayBellHiSoundLoop
        LDA tbl_BellHiFreqLo,X
        STA FREL3,X
        DEX
        BPL .PlayBellHiSoundLoop
        LDA #SND_TRIANGLE_GATE_ON
        STA VCREG3
        LDX #1
.BellSoundMajorLoop
        TXA
        LDX #192
.BellSoundOuterLoop
        LDY #0
.BellSoundInnerLoop
        DEY
        BNE .BellSoundInnerLoop
        DEX
        BNE .BellSoundOuterLoop
        TAX
        DEX
        BNE .BellSoundMajorLoop
        LDX #6
.PlayBellLoSoundLoop
        LDA tbl_BellLoFreqLo,X
        STA FREL3,X
        DEX
        BPL .PlayBellLoSoundLoop
        LDA #SND_TRIANGLE_GATE_ON
        STA VCREG3
        LDA SPREN
        JSR Game_LevelComplete_54DC
        LDA #SND_DISABLE_VOICE
        STA VCREG1
        STA VCREG2
        STA VCREG3
        RTS


*=$3EEA
IRQ_AnimatePitKnightsP2_3EEA
        STA sysIntVectorHi
        JMP Sound_CheckPlaySound_3F09


*=$3EF0
Sound_PlayQuasiJumpSound_3EF0
        STX quasiJumpFrameCounter
        LDX #6
.PlayQuasiJumpSoundLoop
        LDA tbl_QuasiJumpFreqLo,X
        STA FREL1,X
        DEX
        BPL .PlayQuasiJumpSoundLoop
        LDA #SND_SAW_RECTANGLE_ON
        STA VCREG1
        LDA #SND_SAW_RECTANGLE_OFF
        STA VCREG1
.ExitPlayQuasiJumpSound
        RTS


*=$3F09
Sound_CheckPlaySound_3F09
        LDX currentLevel
        LDA tbl_LevelEnemyType,X
        AND #254
        BEQ .ExitPlayQuasiJumpSound
        JMP Sound_PlayMissileSound_3E2A


*=$4000
Initialise    
        LDA #8
        JSR krnCHROUT     
        LDA #%00111111
        STA DDRA
        LDA #%11000110
        STA VICBANK  
        LDA #%11011110
        STA VMCR 
        LDA #%11011000
        STA VCR2   
        LDA #BLACK
        STA BDCOL
        STA BGCOL0     
        LDA #GRAY1
        STA BGCOL1  
        LDA #WHITE
        JSR Initialise_SetBackgroundColours_4572
        LDX #49
.CopyHiScoresLoop
        LDA tbl_HiScoreInit,X
        STA tbl_HiScores,X   
        DEX
        BPL .CopyHiScoresLoop
        JMP Initialise_DisplayTitleScreen_406C


*=$4039
Initialise_ClearScreen_4039
        LDX #0
.InitClearScreenLoop
        LDA #CHAR_SPACE
        STA SCREENRAM,X
        STA SCREENRAM+$0100,X
        STA SCREENRAM+$0200,X
        STA SCREENRAM+$02F0,X
        LDA #WHITE
        STA COLOURRAM,X
        STA COLOURRAM+$0100,X
        STA COLOURRAM+$0200,X
        STA COLOURRAM+$02F0,X 
        INX
        BNE .InitClearScreenLoop
        LDX #24
.InstructionsOrStartLoop
        LDA txt_F1Instructions,X
        STA SCREENRAM+$039F,X  
        LDA txt_SpaceToStart,X
        STA SCREENRAM+$03C7,X 
        DEX
        BPL .InstructionsOrStartLoop
        RTS


*=$406C
Initialise_DisplayTitleScreen_406C
        JSR Initialise_ResetVolume_3E6E
        SEI
        LDA #<IRQ_TitleScreen_46AD
        STA sysIntVectorLo
        LDA #>IRQ_TitleScreen_46AD
        STA sysIntVectorHi
        CLI
        LDX #0
.DisplayTitleScreenLoop
        LDA txt_TitleScreen,X 
        STA SCREENRAM+$00CD,X
        LDA txt_TitleScreen+$0100,X
        STA SCREENRAM+$01CD,X
        LDA txt_TitleScreen+$014E,X
        STA SCREENRAM+$021B,X
        DEX
        BNE .DisplayTitleScreenLoop
        LDX #13
.DisplayTitleScreenTextLoop
        LDA txt_OceanSoftware,X
        STA SCREENRAM+$0035,X
        LDA txt_Presents,X
        STA SCREENRAM+$0085,X
        LDA txt_ByJSteele,X
        STA SCREENRAM+$0361,X
        LDA #GREEN
        STA COLOURRAM+$0035,X
        STA COLOURRAM+$0361,X
        DEX
        BPL .DisplayTitleScreenTextLoop

        LDA #17
        STA zpTemp
.TitleFlashMajorLoop
        JSR Initialise_TitleScreenColourFlash_44A7
        INX
        TXA
        AND #7
        LDX #0
.SetTitlesColourLoop
        STA COLOURRAM+$021B,X
        STA COLOURRAM+$01CD,X
        STA COLOURRAM+$00CD,X
        INX
        BNE .SetTitlesColourLoop
        LDX #0
.TitleFlashOuterLoop
        LDY #0
.TitleFlashInnerLoop
        DEY
        BNE .TitleFlashInnerLoop
        DEX
        BNE .TitleFlashOuterLoop
        DEC zpTemp
        BNE .TitleFlashMajorLoop

        LDA #16
        STA zpTemp
.TitleDelayMajorLoop
        LDX #0
.TitleDelayOuterLoop
        LDY #0
.TitleDelayInnerLoop
        DEY
        BNE .TitleDelayInnerLoop
        DEX
        BNE .TitleDelayOuterLoop
        DEC zpTemp
        BNE .TitleDelayMajorLoop

        JSR Initialise_ClearScreen_4039
        JSR Initialise_DisplayHiScoreScreen_4103

        LDX #17
.DisplayBonusManTextLoop
        LDA txt_BonusMan,X 
        STA SCREENRAM+$028B,X
        LDA #RED
        STA COLOURRAM+$028B,X
        DEX
        BPL .DisplayBonusManTextLoop
        JMP Initialise_SetUpInitScreen_4695



*=$4103
Initialise_DisplayHiScoreScreen_4103
        LDX #6
.DisplayHiScoresLoop
        LDA txt_HiScore,X    
        STA SCREENRAM+$0010,X
        LDA tbl_HiScores,X    
        STA SCREENRAM+$0038,X
        LDA txt_League,X
        STA SCREENRAM+$0081,X
        LDA txt_Order,X
        STA SCREENRAM+$00A9,X
        LDA txt_Score,X   
        STA SCREENRAM+$0089,X
        LDA txt_Name,X    
        STA SCREENRAM+$0092,X
        LDA tbl_HiScores,X    
        STA SCREENRAM+$00D9,X
        LDA tbl_HiScores+10,X    
        STA SCREENRAM+$0129,X
        LDA tbl_HiScores+20,X  
        STA SCREENRAM+$0179,X
        LDA tbl_HiScores+30,X    
        STA SCREENRAM+$01C9,X
        LDA tbl_HiScores+40,X    
        STA SCREENRAM+$0219,X
        DEX
        BPL .DisplayHiScoresLoop
        LDX #2
.DisplayHiScoreNamesLoop
        LDA txt_No,X
        STA SCREENRAM+$00D2,X
        STA SCREENRAM+$0122,X
        STA SCREENRAM+$0172,X
        STA SCREENRAM+$01C2,X
        STA SCREENRAM+$0212,X
        LDA tbl_HiScores+7,X    
        STA SCREENRAM+$00E3,X
        LDA tbl_HiScores+17,X     
        STA SCREENRAM+$0133,X
        LDA tbl_HiScores+27,X    
        STA SCREENRAM+$0183,X
        LDA tbl_HiScores+37,X     
        STA SCREENRAM+$01D3,X
        LDA tbl_HiScores+47,X    
        STA SCREENRAM+$0223,X
        DEX
        BPL .DisplayHiScoreNamesLoop
        LDA #<COLOURRAM+$0078
        STA zpLo
        LDA #>COLOURRAM+$0078
        STA zpHi
        LDX #5
.SetHiScoreColoursOuterLoop
        LDY #79
        LDA tbl_HiScoreColours,X 
.SetHiScoreColoursInnerLoop
        STA (zpLo),Y
        DEY
        BPL .SetHiScoreColoursInnerLoop
        LDA zpLo
        CLC
        ADC #80
        STA zpLo
        BCC .DisplayHiScoreSkipHiByte
        INC zpHi
.DisplayHiScoreSkipHiByte
        DEX
        BPL .SetHiScoreColoursOuterLoop
        LDX #CHAR_1
        STX SCREENRAM+$00D5
        INX
        STX SCREENRAM+$0125
        INX
        STX SCREENRAM+$0175
        INX
        STX SCREENRAM+$01C5
        INX
        STX SCREENRAM+$0215
        RTS


*=$41B7
Intro_DisplayInitialScreen_41B7
        LDA #15
        STA zpTemp
.InitScreenMajorLoop
        LDX #0
.InitScreenOuterLoop
        LDY #$00
.InitScreenInnerLoop
        DEY
        BNE .InitScreenInnerLoop
        DEX
        BNE .InitScreenOuterLoop
        DEC zpTemp
        BNE .InitScreenMajorLoop
.DisplayInitScreen
        LDX #15
        JSR Screen_BuildScreen_4219
        JSR Initialise_InitIntroTune_3D2A
        LDX #79
.DisplayPlayerStatsLoop
        LDA txt_PlayerStats,X
        STA SCREENRAM,X
        LDA tbl_PlayerStatsColours,X             
        JSR Screen_StorePlayerStatsColour_4419
        BPL .DisplayPlayerStatsLoop
        LDX #0
.DisplayInitScreenLoop
        LDA scn_TemporaryScreen+$0050,X
        STA SCREENRAM+$0050,X
        LDA scn_TemporaryColour+$0050,X
        STA COLOURRAM+$0050,X
        LDA scn_TemporaryScreen+$0150,X
        STA SCREENRAM+$0150,X
        LDA scn_TemporaryColour+$0150,X
        STA COLOURRAM+$0150,X
        LDA scn_TemporaryScreen+$0250,X
        STA SCREENRAM+$0250,X
        LDA scn_TemporaryColour+$0250,X
        STA COLOURRAM+$0250,X
        LDA scn_TemporaryScreen+$02F0,X
        STA SCREENRAM+$02F0,X
        LDA scn_TemporaryColour+$02F0,X
        STA COLOURRAM+$02F0,X
        INX
        BNE .DisplayInitScreenLoop
        JMP Initialise_InitQuasiIntroStage_44B1


*=$4219
Screen_BuildScreen_4219
        STX zpTemp
        LDX #0
.ClearTempScreenSpaceLoop
        LDA #BLACK
        STA scn_TemporaryColour,X
        STA scn_TemporaryColour+$0100,X
        STA scn_TemporaryColour+$0200,X
        STA scn_TemporaryColour+$0300,X
        LDA #CHAR_SPACE
        STA scn_TemporaryScreen,X
        STA scn_TemporaryScreen+$0100,X
        STA scn_TemporaryScreen+$0200,X
        STA scn_TemporaryScreen+$0300,X
        INX
        BNE .ClearTempScreenSpaceLoop
        LDA zpTemp
        AND #15
        CMP #15
        BNE .FindLevelType
        BIT $A474       ;possible self-mod code?
.FindLevelType
        LDY #5
.CheckNextLevelType
        STY zpTemp2
        LDX zpTemp
        LDA tbl_LevelType,X
        AND tbl_BitMask,Y
        BEQ .NextLevelTypeMatch
        LDA tbl_CharBlockRoutineLo,Y
        STA zpScnPtrLo
        LDA tbl_CharBlockRoutineHi,Y
        STA zpScnPtrHi
        JMP ($0062) ;zpScnPtrLo
.NextLevelTypeMatch
        LDY zpTemp2
        DEY
        BPL .CheckNextLevelType
        RTS


*=$4268
Screen_DrawWall_4268
        LDX #0
.DrawWallLoop
        LDA #CHAR_WALL
        STA scn_TemporaryScreen+$01B8,X
        STA scn_TemporaryScreen+$02B8,X
        STA scn_TemporaryScreen+$0300,X
        LDY zpTemp
        LDA tbl_WallCharColours,Y
        STA scn_TemporaryColour+$01B8,X
        JSR Screen_SetWallColours_3E17
        INX
        BNE .DrawWallLoop
        JSR Screen_DrawWallBase_3E1E
        RTS


*=$4287
Screen_DrawStandardLevel_4287
        JSR Screen_DrawEndOfLevelBell_43DA
        JMP .NextLevelTypeMatch


*=$428D
Screen_DrawRopePit_428D
        JSR Screen_DrawEndOfLevelBell_43DA
        LDA #<scn_TemporaryScreen+$01C3
        STA zpScnPtrLo
        LDA #>scn_TemporaryScreen+$01C3
        STA zpScnPtrHi
        LDX #9
.DrawRopePit
        LDY #17
        LDA #CHAR_SPACE
.ClearRopePitLoop
        STA (zpScnPtrLo),Y
        DEY
        BPL .ClearRopePitLoop
        INY
        LDA #CHAR_WALL3D
        CPX #9
        BNE .NotTopOfWall
        LDA #CHAR_WALL3DTOP
.NotTopOfWall
        STA (zpScnPtrLo),Y
        JMP Screen_DrawPitFire_42B8


*=$42B1
Screen_ScreenColourSwitcher_42B1
        LDA zpScnPtrHi
        EOR #12
        STA zpScnPtrHi
        RTS


*=$42B8
Screen_DrawPitFire_42B8
        JSR Screen_ScreenColourSwitcher_42B1
        LDA #RED
        STA (zpScnPtrLo),Y
        JSR Screen_ScreenColourSwitcher_42B1
        LDA zpScnPtrLo
        CLC
        ADC #40
        STA zpScnPtrLo
        BCC .SkipPitFireHighByte
        INC zpScnPtrHi
.SkipPitFireHighByte
        DEX
        BPL .DrawRopePit
        LDX #17
.DrawPitFireLoop
        LDA #RED
        STA scn_TemporaryColour+$0353,X
        LDA #CHAR_FIRE
        STA scn_TemporaryScreen+$0353,X
        DEX
        BPL .DrawPitFireLoop
        JMP .NextLevelTypeMatch


*=$42E2
Screen_DrawKnights_42E2
        LDA #<scn_TemporaryScreen+$0199
        JSR Screen_DrawBackground_42F4
        LDA #<scn_TemporaryScreen+$01A2
        JSR Screen_DrawBackground_42F4
        LDA #<scn_TemporaryScreen+$01AB
        JSR Screen_DrawBackground_42F4
        JMP .NextLevelTypeMatch


*=$42F4
Screen_DrawBackground_42F4
        LDX #<tbl_KnightChars 
Screen_DrawBackground_42F6
        LDY #>tbl_KnightChars 
        STX zpScnSrcLo
        STY zpScnSrcHi
        STA zpScnPtrLo
        LDA #>scn_TemporaryScreen+$0100
        STA zpScnPtrHi
        LDX #4
.DrawScreenOuterLoop
        LDY #3
.DrawScreenInnerLoop
        LDA (zpScnSrcLo),Y
        STA (zpScnPtrLo),Y
        JSR Screen_ScreenColourSwitcher_42B1
        LDA zpScnSrcLo
        PHA
        CLC
        ADC #20
        STA zpScnSrcLo
        LDA (zpScnSrcLo),Y
        STA (zpScnPtrLo),Y
        PLA
        STA zpScnSrcLo
        JSR Screen_ScreenColourSwitcher_42B1
        DEY
        BPL .DrawScreenInnerLoop
        LDA zpScnSrcLo
        CLC
        ADC #4
        STA zpScnSrcLo
        LDA zpScnPtrLo
        CLC
        ADC #40
        STA zpScnPtrLo
        BCC .SkipScreenHiByte
        INC zpScnPtrHi
.SkipScreenHiByte
        DEX
        BPL .DrawScreenOuterLoop
        RTS


*=$4338
Screen_DrawEmptyPit_4338
        LDA #<scn_TemporaryScreen+$0199
        LDX #<tbl_EmptyPitChars 
        JSR Screen_DrawBackground_42F6
        LDA #<scn_TemporaryScreen+$01A2
        LDX #<tbl_EmptyPitChars
        JSR Screen_DrawBackground_42F6
        LDA #<scn_TemporaryScreen+$01AB
        LDX #<tbl_EmptyPitChars
        JSR Screen_DrawBackground_42F6
        JMP .NextLevelTypeMatch


*=$4350
Screen_DrawEsmereldaTower_4350
        LDA #<scn_TemporaryScreen+$0070
        STA zpScnPtrLo
        LDA #>scn_TemporaryScreen+$0070
        STA zpScnPtrHi
        LDA #<tbl_EsmereldaTowerChars
        STA zpScnSrcLo
        LDA #>tbl_EsmereldaTowerChars
        STA zpScnSrcHi
        LDX #8
.DrawNextTowerRow
        LDY #7
.DrawEsmeTowerLoop
        LDA (zpScnSrcLo),Y
        STA (zpScnPtrLo),Y
        JSR Screen_ScreenColourSwitcher_42B1
        TYA
        CLC
        ADC #72
        TAY
        LDA (zpScnSrcLo),Y
        PHA
        TYA
        SEC
        SBC #72
        TAY
        PLA
        STA (zpScnPtrLo),Y
        JSR Screen_ScreenColourSwitcher_42B1
        DEY
        BPL .DrawEsmeTowerLoop
        LDA zpScnPtrLo
        CLC
        ADC #40
        STA zpScnPtrLo
        BCC .SkipTowerHiByte
        INC zpScnPtrHi
.SkipTowerHiByte
        LDA zpScnSrcLo
        CLC
        ADC #8
        STA zpScnSrcLo
        DEX
        BPL .DrawNextTowerRow
        JMP .NextLevelTypeMatch


*=$4399
Screen_DrawRowOfBells_4399
        LDA #<scn_TemporaryScreen+$0085
        STA zpScnPtrLo
        LDA #>scn_TemporaryScreen+$0085
        STA zpScnPtrHi
        LDA #<tbl_RowOfBellsChars
        STA zpScnSrcLo
        LDA #>tbl_RowOfBellsChars
        STA zpScnSrcHi
        LDX #7
.DrawNextRowOfBells
        LDY #13
.DrawRowOfBellsLoop
        LDA (zpScnSrcLo),Y
        STA (zpScnPtrLo),Y
        JSR Screen_ScreenColourSwitcher_42B1
        LDA #GRAY2
        STA (zpScnPtrLo),Y
        JSR Screen_ScreenColourSwitcher_42B1
        DEY
        BPL .DrawRowOfBellsLoop
        LDA zpScnPtrLo
        CLC
        ADC #40
        STA zpScnPtrLo
        BCC .SkipRowOfBellsHiByte
        INC zpScnPtrHi
.SkipRowOfBellsHiByte
        LDA zpScnSrcLo
        CLC
        ADC #14
        STA zpScnSrcLo
        BCC .SkipRowOfBellsHiByte2
        INC zpScnSrcHi
.SkipRowOfBellsHiByte2
        DEX
        BPL .DrawNextRowOfBells
        JMP .NextLevelTypeMatch



*=$43DA
Screen_DrawEndOfLevelBell_43DA
        JSR Screen_DrawWall_4268
        LDA #<scn_TemporaryScreen+$009D
        STA zpScnPtrLo
        LDA #>scn_TemporaryScreen+$009D
        STA zpScnPtrHi
        LDA #<tbl_LevelEndBellChars
        STA zpScnSrcLo
        LDA #>tbl_LevelEndBellChars
        STA zpScnSrcHi         
        LDX #7
.DrawNextRowOfEndBell
        LDY #2
.DrawEndOfLevelBellLoop
        LDA (zpScnSrcLo),Y
        STA (zpScnPtrLo),Y
        JSR Screen_ScreenColourSwitcher_42B1
        LDA #GRAY2
        STA (zpScnPtrLo),Y
        JSR Screen_ScreenColourSwitcher_42B1
        DEY
        BPL .DrawEndOfLevelBellLoop
        INC zpScnSrcLo
        INC zpScnSrcLo
        INC zpScnSrcLo
        LDA zpScnPtrLo
        CLC
        ADC #40
        STA zpScnPtrLo
        BCC .SkipEndOfLevelBellHiByte
        INC zpScnPtrHi
.SkipEndOfLevelBellHiByte
        DEX
        BPL .DrawNextRowOfEndBell
        JMP .NextLevelTypeMatch


*=$4419
Screen_StorePlayerStatsColour_4419
        STA COLOURRAM,X
        DEX
        RTS


*=$441E
Initialise_LevelScroll_441E
        LDX #9
        JSR Screen_BuildScreen_4219
        JSR Screen_ScrollInitialise_4439
        LDX #8
        JSR Screen_BuildScreen_4219
        JSR Screen_ScrollInitialise_4439
        LDX #0
        JSR Screen_BuildScreen_4219
        JSR Screen_ScrollInitialise_4439
        JMP Initialise_EndQuasiIntroStage_4557


*=$4439
Screen_ScrollInitialise_4439
        LDX #7
.CopyScreenPointersLoop
        LDA tbl_ScreenPointers,X
        STA tbl_tmpScreenPointers,X
        DEX
        BPL .CopyScreenPointersLoop
        LDX #39
.ScreenScrollLoop
        TXA
        PHA
        JSR Screen_ScrollDelay_449A
        PLA
        TAX
        DEX
        BPL .ScreenScrollLoop
        RTS


*=$4451
Screen_Scroll_4451
        LDX #2
.DecScreenPointersLoop
        DEC tbl_tmpScreenPointers+4,X
        DEX
        DEX
        BPL .DecScreenPointersLoop
        LDX #7
.CopyScreenPtrsLoop
        LDA tbl_tmpScreenPointers,X
        STA zpScnPtrLo,X
        DEX
        BPL .CopyScreenPtrsLoop
        LDX #22
.MoveToNextRow
        LDY #38
.CopyNextCharLoop
        LDA (zpScnPtrLo),Y 
        PHA
        LDA (zpColPtrLo),Y
        INY
        STA (zpColPtrLo),Y
        PLA
        STA (zpScnPtrLo),Y
        DEY
        DEY
        BPL .CopyNextCharLoop
        LDY #0
        LDA (zpScnPtrLo+4),Y  
        STA (zpScnPtrLo),Y
        LDA (zpColPtrLo+4),Y
        STA (zpColPtrLo),Y
        TXA
        PHA
        LDX #6
.AddRowToScnPtrsLoop
        LDA zpScnPtrLo,X
        CLC
        ADC #40
        STA zpScnPtrLo,X
        BCC .SkipScnPtrHiByte
        INC zpScnPtrHi,X
.SkipScnPtrHiByte
        DEX
        DEX
        BPL .AddRowToScnPtrsLoop
        PLA
        TAX
        DEX
        BPL .MoveToNextRow
        RTS


*=$449A
Screen_ScrollDelay_449A
        LDX #32
.ScrollDelayOuterLoop
        LDY #0
.ScrollDelayInnerLoop
        DEY
        BNE .ScrollDelayInnerLoop
        DEX
        BNE .ScrollDelayOuterLoop
        JMP Screen_Scroll_4451


*=$44A7
Initialise_TitleScreenColourFlash_44A7
        LDX COLOURRAM+$00CD
        CPX #7
        BNE .ExitTitleScreenColourFlash
        LDX #0
.ExitTitleScreenColourFlash
        RTS


*=$44B1
Initialise_InitQuasiIntroStage_44B1
        LDA #0
        STA quasiIntroStage
        STA currentLevel
        LDA #1
        JSR Initialise_SetQuasiIntroXMSB_463B
        LDA #56
        STA quasiIntroX
        SEI
        LDA #<IRQ_IntroQuasiMove_4580
        STA sysIntVectorLo
        LDA #>IRQ_IntroQuasiMove_4580         
        STA sysIntVectorHi
        CLI
.CheckQuasiIntroStageLoop
        LDA quasiIntroStage
        BEQ .CheckQuasiIntroStageLoop
        JMP Initialise_LevelScroll_441E


*=$44D7
Quasi_SetIntroJumpFrame_44D7
        LDX quasiIntroJumpFrame
        LDA #216
        SEC
        SBC tbl_QuasiJumpYOffset,X
        STA SPRY0
        LDA tbl_QuasiLeftJumpFrame,X
        STA SPRPTR0
        LDA #0
        STA SPRYEX
        STA SPRXEX
        STA SPRDP
        LDA #GREEN
        STA SPRCOL0
        LDA #1
        STA SPRMCS
        STA SPREN
        LDA quasiIntroStage
        BEQ Initialise_QuasiIntroStage_4542
        CMP #1
        BNE .IntroStageMoveQuasi
.GotoNextJumpFrame
        JMP .NextIntroJumpFrame
.IntroStageMoveQuasi
        JSR Initialise_IntroMoveQuasi_4531
.UpdateQuasiX
        LDA quasiIntroX
        CLC
        ADC #24
        STA SPRX0
        LDA quasiIntroXMSB
        ADC #0
        STA SPRXMSB
        JMP .GotoNextJumpFrame
.NextIntroJumpFrame
        LDX quasiIntroJumpFrame
        INX
        TXA
        AND #15
        STA quasiIntroJumpFrame
.ExitSetIntroJumpFrame
        JMP Sound_IntroTune_3CEF


*=$4531
Initialise_IntroMoveQuasi_4531
        LDX #1
.MoveQuasiLoop
        LDA quasiIntroX
        BNE .IntroMoveQuasi
        DEC quasiIntroXMSB
.IntroMoveQuasi
        DEC quasiIntroX
        DEX
        BPL .MoveQuasiLoop
        RTS


*=$4542
Initialise_QuasiIntroStage_4542
        JSR Initialise_IntroMoveQuasi_4531
        LDA quasiIntroXMSB
        BNE .ExitQuasiIntroStage
        LDA quasiIntroX 
        CMP #144
        BNE .ExitQuasiIntroStage
        INC quasiIntroStage
.ExitQuasiIntroStage
        JMP .UpdateQuasiX



*=$4557
Initialise_EndQuasiIntroStage_4557
        LDA #2
        STA quasiIntroStage
.DecQuasiXLoop
        LDA quasiIntroX
        CMP #17
        BCS .DecQuasiXLoop
        SEI
        LDA #<krnINTERRUPT
        STA sysIntVectorLo
        LDA #>krnINTERRUPT
        STA sysIntVectorHi
        CLI
        JMP Sound_DisableVoices_3CE1


*=$4572
Initialise_SetBackgroundColours_4572
        STA BGCOL2   
        LDA #BROWN
        STA SPRMC0    
        LDA #GRAY3
        STA SPRMC1  
        RTS


*=$4580
IRQ_IntroQuasiMove_4580
        DEC quasiX
        BNE .ExitSetIntroJumpFrame
        LDA #2
        STA quasiX
        JMP Quasi_SetIntroJumpFrame_44D7


*=$458D
Initialise_QuasiClimbWall_458D
        DEC SPRY0
        LDX #8
.QuasiClimbOuterLoop
        LDY #0
.QuasiClimbInnerLoop
        DEY
        BNE .QuasiClimbInnerLoop
        DEX
        BNE .QuasiClimbOuterLoop
        JSR Initialise_CheckQuasiY_46A7
        BNE Initialise_QuasiClimbWall_458D
        RTS
        NOP


*=$45A1
Initialise_QuasiIntroWalkRight_45A1
        LDX #1
.MoveQuasiRightLoop
        INC quasiIntroX
        BNE .SkipQuasiIntroMSB
        INC quasiIntroXMSB
.SkipQuasiIntroMSB
        DEX
        BPL .MoveQuasiRightLoop
        LDA quasiIntroX 
        CLC
        ADC #24
        STA SPRX0
        LDA quasiIntroXMSB
        ADC #0
        STA SPRXMSB
        LDA quasiIntroX 
        LSR
        AND #3
        JSR Quasi_SelectWalkRightFrame_45E4
        STA SPRPTR0
        LDX #48
.QuasiWalkRightOuterLoop
        LDY #0
.QuasiWalkRightInnerLoop
        DEY
        BNE .QuasiWalkRightInnerLoop
        DEX
        BNE .QuasiWalkRightOuterLoop
        LDA quasiIntroXMSB
        BEQ Initialise_QuasiIntroWalkRight_45A1
        LDA quasiIntroX 
        CMP #32
        BCC Initialise_QuasiIntroWalkRight_45A1
        JMP Initialise_DisplayFeaturing_4682


*=$45E4
Quasi_SelectWalkRightFrame_45E4
        TAX
        LDA tbl_QuasiWalkRightFrame,X
        RTS


*=$45E9
Initialise_SetQuasiJumpFrame_45E9
        LDA #0
        STA quasiJumpFrame
.NextJumpFrame
        LDX quasiJumpFrame
        LDA #117
        SEC
        SBC tbl_QuasiJumpYOffset,X
        STA SPRY0
        LDA tbl_QuasiLeftJumpFrame,X
        STA SPRPTR0
        JSR Initialise_QuasiJump_461C
        LDX #32
.QuasiJumpFrameOuterLoop
        LDY #0
.QuasiJumpFrameInnerLoop
        DEY
        BNE .QuasiJumpFrameInnerLoop
        DEX
        BNE .QuasiJumpFrameOuterLoop
        LDA quasiIntroXMSB
        BNE .NextJumpFrame
        LDA quasiIntroX
        CMP #4
        BCS .NextJumpFrame
        JMP Initialise_TheBellsFlash_4755


*=$461C
Initialise_QuasiJump_461C
        JSR Initialise_DisplayTheBells_4642
        LDA quasiIntroX
        CLC
        ADC #24
        STA SPRX0
        LDA quasiIntroXMSB
        ADC #0
        STA SPRXMSB
        LDX quasiJumpFrame
        INX
        TXA
        AND #15
        STA quasiJumpFrame
        RTS


*=$463B
Initialise_SetQuasiIntroXMSB_463B
        STA quasiIntroXMSB 
        STA quasiX
.ExitSetQuasiMSB
        RTS


*=$4642
Initialise_DisplayTheBells_4642
        JSR Initialise_IntroMoveQuasi_4531
        LDA quasiIntroXMSB
        BNE .ExitSetQuasiMSB
        LDX #7
.CheckTheBellsXLoop
        LDA quasiIntroX
        CMP tbl_TheBellsQuasiX,X
        BEQ .SetTheBellsScreenPos
        DEX
        BPL .CheckTheBellsXLoop
        RTS
.SetTheBellsScreenPos
        LDA tbl_TheBellsScreenLo,X
        STA zpScnPtrLo
        STA zpColPtrLo
        LDA #>SCREENRAM+$0100
        STA zpScnPtrLo+1
        LDA #>COLOURRAM+$0100
        STA zpColPtrLo+1
        TXA
        ASL
        ASL
        STA zpTemp3
        LDX #3
.DiplayTheBellsCharsLoop
        LDY zpTemp3
        LDA tbl_TheBellsChars,Y
        LDY tbl_BellCharsXOffset,X
        STA (zpScnPtrLo),Y
        LDA #LIGHTBLUE
        STA (zpColPtrLo),Y
        INC zpTemp3
        DEX
        BPL .DiplayTheBellsCharsLoop
        RTS


*=$4682
Initialise_DisplayFeaturing_4682
        LDX #8
.DisplayFeaturingLoop
        LDA txt_Featuring,X
        STA SCREENRAM+$0100,X
        LDA #WHITE
        STA COLOURRAM+$0100,X
        DEX
        BPL .DisplayFeaturingLoop
        JMP Initialise_SetQuasiJumpFrame_45E9


*=$4695
Initialise_SetUpInitScreen_4695
        JSR Intro_DisplayInitialScreen_41B7
        SEI
        LDA #<IRQ_TitleScreen_46AD
        STA sysIntVectorLo
        LDA #>IRQ_TitleScreen_46AD
        STA sysIntVectorHi
        CLI
        JMP Initialise_QuasiIntroWalkRight_45A1


*=$46A7
Initialise_CheckQuasiY_46A7
        LDA SPRY0
        CMP #117
        RTS


*=$46AD
IRQ_TitleScreen_46AD
        LDA sysKeyPress
        CMP #KEY_F1
        BEQ Initialise_DisplayInstructions_46D0
        CMP #KEY_SPACE
        BEQ .StartGameSelected
        JMP krnINTERRUPT
.StartGameSelected
        JSR Initialise_InstructionsClearSprites_474D
        LDX #$F8        ;reset stack
        TXS
        JMP Initialise_SelectKeyboardOrJoystick_4782


*=$46C3
IRQ_ResetIRQ_46C3
        SEI
        LDA #<krnINTERRUPT
        STA sysIntVectorLo
        LDA #>krnINTERRUPT
        STA sysIntVectorHi
        CLI
        RTS


*=$46D0
Initialise_DisplayInstructions_46D0
        JSR Initialise_InstructionsClearSprites_474D
        LDX #$F8                ;reset stack
        TXS
        JSR Initialise_ClearScreen_4039
.InitWaitKey
        LDA sysKeyPress
        CMP #KEY_NONE
        BNE .InitWaitKey
        LDX #25
.DisplayInstructionsLoop
        LDA txt_Instructions,X    
        STA SCREENRAM+$002F,X
        LDA txt_Instructions+26,X
        STA SCREENRAM+$00CF,X
        LDA txt_Instructions+52,X
        STA SCREENRAM+$0147,X
        LDA txt_Instructions+78,X
        STA SCREENRAM+$01BF,X
        LDA txt_Instructions+104,X
        STA SCREENRAM+$0237,X
        LDA txt_Instructions+130,X
        STA SCREENRAM+$02AF,X
        DEX
        BPL .DisplayInstructionsLoop
        LDX #3
.DisplayBellCharsLoop
        LDA tbl_BellChars,X
        LDY tbl_BellCharsXOffset,X
        STA SCREENRAM+$01A4,Y
        STA SCREENRAM+$028C,Y
        LDA #GRAY2
        STA COLOURRAM+$01A4,Y
        STA COLOURRAM+$028C,Y
        DEX
        BPL .DisplayBellCharsLoop
        LDX #33
.DisplayJoyOrKeysLoop
        LDA txt_InstructionsJoyKeys,X
        STA SCREENRAM+$00A3,X
        DEX
        BPL .DisplayJoyOrKeysLoop
        SEI
        LDA #<IRQ_TitleScreen_46AD
        STA sysIntVectorLo
        LDA #>IRQ_TitleScreen_46AD
        STA sysIntVectorHi
        CLI
.PrepareTitleScreen
        LDA #31
        STA zpTemp              
.DisplayInstructionsMajorLoop
        LDX #$00
.DisplayInstructionsOuterLoop
        LDY #0
.DisplayInstructionsInnerLoop
        DEY
        BNE .DisplayInstructionsInnerLoop
        DEX
        BNE .DisplayInstructionsOuterLoop
        DEC zpTemp
        BNE .DisplayInstructionsMajorLoop
        JMP Initialise_TitleScreenClearSprites_477A



*=$474D
Initialise_InstructionsClearSprites_474D
        LDA #0
        STA SPREN
        JMP IRQ_ResetIRQ_46C3

 
*=$4755
Initialise_TheBellsFlash_4755
        LDA #64
        STA zpTemp
.TheBellsFlashMajorLoop
        LDA COLOURRAM+$0173
        EOR #4
        LDX #17
.FlashTheBellsLoop
        STA COLOURRAM+$0173,X
        STA COLOURRAM+$019B,X
        DEX
        BPL .FlashTheBellsLoop
        LDX #64
.TheBellsFlashOuterLoop
        LDY #0
.TheBellsFlashInnerLoop
        DEY
        BNE .TheBellsFlashInnerLoop
        DEX
        BNE .TheBellsFlashOuterLoop
        DEC zpTemp
        BNE .TheBellsFlashMajorLoop
        JMP .PrepareTitleScreen


*=$477A
Initialise_TitleScreenClearSprites_477A
        LDA #0
        STA SPREN
        JMP Initialise_DisplayTitleScreen_406C


*=$4782
Initialise_SelectKeyboardOrJoystick_4782
        LDX #0
.ClearScreenLoop
        LDA #CHAR_SPACE
        STA SCREENRAM,X
        STA SCREENRAM+$0100,X
        STA SCREENRAM+$0200,X
        STA SCREENRAM+$02F0,X
        LDA #WHITE
        STA COLOURRAM,X
        STA COLOURRAM+$0100,X
        STA COLOURRAM+$0200,X
        STA COLOURRAM+$02F0,X
        INX
        BNE .ClearScreenLoop
        LDX #7
.DisplayKeyOrJoyTextLoop
        LDA txt_KeysOrJoy,X
        STA SCREENRAM+$0088,X
        LDA txt_KeysOrJoy+8,X
        STA SCREENRAM+$0100,X
        LDA txt_KeysOrJoy+16,X
        STA SCREENRAM+$0150,X
        LDA txt_KeysOrJoy+24,X
        STA SCREENRAM+$01A0,X
        DEX
        BPL .DisplayKeyOrJoyTextLoop
.GetJoyOrKeyLoop
        JSR krnGETIN
        CMP #KEY_J
        BEQ .JoystickSelected
        CMP #KEY_K
        BNE .GetJoyOrKeyLoop
.JoystickSelected
        SEC
        SBC #KEY_J
        STA inputSelect
        CMP #1
        BEQ .KeyboardSelected
        LDX #23
.DisplayJoyInPort2Loop
        LDA txt_JoyInPort2,X
        STA SCREENRAM+$0260,X
        DEX
        BPL .DisplayJoyInPort2Loop
        JMP Initialise_InputSelect_4800
.KeyboardSelected
        LDX #17
.DisplayKeyControlsLoop
        LDA txt_KeyboardControls,X
        STA SCREENRAM+$0263,X
        LDA txt_KeyboardControls+18,X
        STA SCREENRAM+$02DB,X
        LDA txt_KeyboardControls+36,X
        STA SCREENRAM+$032B,X
        LDA txt_KeyboardControls+54,X
        STA SCREENRAM+$037B,X
        DEX
        BPL .DisplayKeyControlsLoop

*=$4800
Initialise_InputSelect_4800
        LDA #22
        STA zpTemp
.InputSelectMajorLoop
        LDX #$00
.InputSelectOuterLoop
        LDY #0
.InputSelectInnerLoop
        DEY
        BNE .InputSelectInnerLoop
        DEX
        BNE .InputSelectOuterLoop
        DEC zpTemp
        BNE .InputSelectMajorLoop
        LDA #15
        STA SIDVOL
        JSR Initialise_ClearOnRopeFlag_545D
        LDA #0
        STA currentLevel
        STA quasiJumpActive
        STA quasiXMSB
        LDX #11
.ResetQuasiStatsLoop
        STA quasiStats,X
        DEX
        BPL .ResetQuasiStatsLoop
        LDA #16
        STA quasiX
        STA unused0344
        LDA #1
        STA unused0342
        LDA #128
        STA unused0343
        LDA #FALSE
        STA SPREN
        JMP Initialise_SetQuasiLives_490F


*=$4847
Screen_CopyGameScreenBridging_4847
        LDX currentLevel
        JSR Screen_CopyGameScreen_56A7

*=$484D
Initialise_DisplayGetReady_484D
        JSR Game_ResetCollisionRegisters_5745
        JSR Initialise_InitKnight_537C
        LDX #8
.DisplayGetReadyLoop
        JSR Screen_DisplayGetReady_4BC7
        STA SCREENRAM+$0100,X
        LDA #WHITE
        STA COLOURRAM+$0100,X
        DEX
        BPL .DisplayGetReadyLoop
        LDA #9
        STA zpTemp
.GetReadyMajorLoop
        LDX #0
.GetReadyOuterLoop
        LDY #0
.GetReadyInnerLoop
        DEY
        BNE .GetReadyInnerLoop
        DEX
        BNE .GetReadyOuterLoop
        DEC zpTemp
        BNE .GetReadyMajorLoop
        LDX #8
.ClearGetReadyLoop
        LDA #CHAR_SPACE
        JSR Screen_ClearGetReady_4BD7
        DEX
        BPL .ClearGetReadyLoop
        JMP Level_InitLevel_4917


*=$4882
Screen_DrawGameScreen_4882
        LDX #0
.FetchScoreDigitsLoop
        LDA quasiScore,X
        BNE .DisplayScoreLoop
        INX
        CPX #6
        BNE .FetchScoreDigitsLoop
.DisplayScoreLoop
        LDA quasiScore,X
        ORA #48
        STA SCREENRAM+$001A,X
        INX
        CPX #7
        BNE .DisplayScoreLoop
        LDX quasiLives
        BEQ .DisplayBonusBells
        LDA #CHAR_SPACE
        STA SCREENRAM+$0041,X
        DEX
        BEQ .DisplayBonusBells
.DisplayLivesLoop
        LDA #CHAR_LIVESMARKER
        STA SCREENRAM+$0041,X
        DEX
        BNE .DisplayLivesLoop
.DisplayBonusBells
        JSR Screen_DrawPlayerStats_4BB2
        BEQ .DisplayLevelMarker
        STA zpTemp
        LDA #>SCREENRAM+$0001
        STA zpScnPtrHi
        LDA #<SCREENRAM+$0001
        STA zpScnPtrLo
.DrawNextBonusBellRow
        LDX #3
.DrawBonusBellsLoop
        LDA tbl_BellChars,X
        LDY tbl_BellCharsXOffset,X
        STA (zpScnPtrLo),Y
        DEX
        BPL .DrawBonusBellsLoop
        INC zpScnPtrLo
        INC zpScnPtrLo
        DEC zpTemp
        BNE .DrawNextBonusBellRow
.DisplayLevelMarker
        LDX #27
.DrawLevelMarkerLoop
        LDY tbl_LevelMarkerXOffset,X
        LDA tbl_LevelMarkerChars,X
        STA SCREENRAM+$0348,Y
        LDA tbl_LevelMarkerCharCol,X
        STA COLOURRAM+$0348,Y
        DEX
        BPL .DrawLevelMarkerLoop
        LDX #7
        LDA #0
.ClearLevelMarkerCharLoop
        STA chr_Marker,X 
        DEX
        BPL .ClearLevelMarkerCharLoop
        LDA currentLevel
        AND #3
        TAX
        LDA tbl_LevelMarkerPixel,X
        STA chr_Marker+6
        STA chr_Marker+5
        LDA currentLevel
        LSR
        LSR
        AND #3
        TAX
        LDA #CHAR_LEVELMARKER
        STA SCREENRAM+$0371,X
        RTS


*=$490F
Initialise_SetQuasiLives_490F
        LDA #5
        STA quasiLives
        JMP Initialise_DisplayGetReady_484D

*=$4917
Level_InitLevel_4917
        JSR Enemy_InitData_4D4B
.GetPlayerInput
        JSR Input_GetInput_4920
        JMP Input_PlayerMove_4965


*=$4920
Input_GetInput_4920
        LDA inputSelect
        BNE .CheckKeyboardMatrix
        LDA CIAPRA
        EOR #%00011111
        AND #%00011100
        STA inputJoy
        RTS
.CheckKeyboardMatrix
        LDX #7
.GetKeyMatrixColumnLoop
        LDA tbl_KeyboardMatrixCol,X
        STA CIAPRA
        LDA CIAPRB
        STA inputKeyMatrixCol,X
        DEX
        BPL .GetKeyMatrixColumnLoop
        LDA #%01111111
        STA CIAPRA
        LDA #0
        STA inputJoy
        LDX #2
.KeyboardMatrixLoop
        LDY tbl_KeyMatrixColOffset,X
        LDA inputKeyMatrixCol,Y
        AND tbl_KeyboardMatrixRow,X
        BNE .CheckNextMatrixCol
        LDA inputJoy
        ORA tbl_KeyToJoyMap,X
        STA inputJoy
.CheckNextMatrixCol
        DEX
        BPL .KeyboardMatrixLoop
        RTS


*=$4965
Input_PlayerMove_4965
        LDA inputJoy
        AND #JOY_FIRE
        BEQ .TestJoyRight
        LDA quasiJumpActive
        BNE .TestJoyRight
        LDX #1
        STX quasiJumpActive
        DEX
        JSR Sound_PlayQuasiJumpSound_3EF0
.TestJoyRight
        LDA inputJoy
        AND #JOY_RIGHT
        BEQ .TestJoyLeft
        LDA quasiX
        CLC
        ADC #2
        STA quasiX
        BCC .SkipSetQuasiMSB
        INC quasiXMSB
.SkipSetQuasiMSB
        LDA #QUASI_DIR_RIGHT
        STA quasiDirection
.TestJoyLeft
        LDA inputJoy
        AND #JOY_LEFT 
        BEQ .CheckRopeCollision
        LDA quasiXMSB
        BNE .QuasiInMSBZone
        LDA quasiX
        CMP #18
        BCC .CheckRopeCollision
.QuasiInMSBZone
        LDA quasiX
        SEC
        SBC #2
        STA quasiX
        BCS .SkipClearQuasiMSB
        DEC quasiXMSB
.SkipClearQuasiMSB
        LDA #QUASI_DIR_LEFT
        STA quasiDirection
.CheckRopeCollision
        JSR Game_CheckRopeCollision_5406
        LDX #32
.QuasiMoveOuterLoop
        LDY #0
.QuasiMoveInnerLoop
        DEY
        BNE .QuasiMoveInnerLoop
        DEX
        BNE .QuasiMoveOuterLoop
        LDA quasiXMSB
        BEQ .ExitQuasiMove
        LDA quasiX
        CMP #30
        BCC .ExitQuasiMove
        JMP Game_LevelEndBonus_4A6A
.ExitQuasiMove
        JMP Game_CheckCollision_56F3


*=$49D9
Input_GetInputBridgingSub_49D9
        JMP .GetPlayerInput


*=$49DC
Quasi_Animate_49DC
        LDA quasiX
        CLC
        ADC #24
        STA SPRX0
        LDA quasiXMSB
        ADC #0
        TAX
        LDA SPRXMSB
        AND #SPRITE0_MASK_OFF
        CPX #0
        BEQ .ClearQuasiXMSB
        ORA #SPRITE0_MASK_ON
.ClearQuasiXMSB 
        STA SPRXMSB
        LDA #117
        LDX quasiJumpActive
        BEQ .QuasiNotJumping
        LDX quasiJumpFrameCounter
        SEC
        SBC tbl_QuasiJumpYOffset,X
.QuasiNotJumping
        STA SPRY0
        LDA #GREEN
        STA SPRCOL0
        LDA #0
        STA SPRDP
        LDA #15
        STA SPRMCS
        LDA #SPRITE4_6_MASK_ON
        STA SPRXEX
        STA SPRYEX
        LDA quasiJumpActive
        BNE .QuasiJumping
        LDA quasiX
        LSR
        AND #3
        LDX quasiDirection
        BEQ .WalkingRight
        CLC
        ADC #4
.WalkingRight
        TAX
        LDA tbl_QuasiWalkFrame,X
        JSR Quasi_SetSwingFrame_544C
.ExitAnimateQuasi
        RTS
.QuasiJumping
        LDA quasiJumpFrameCounter
        LDX quasiDirection
        BEQ .QuasiJumpRight
        CLC
        ADC #16
.QuasiJumpRight
        TAX
        LDA tbl_QuasiJumpFrames,X
        JSR Quasi_UpdateFrame_4A5E
        INC quasiJumpFrameCounter
        LDA quasiJumpFrameCounter
        CMP #16
        BNE .ExitAnimateQuasi
        LDA #0
        STA quasiJumpActive
        RTS


*=$4A5E
Quasi_UpdateFrame_4A5E
        STA SPRPTR0
        LDA SPREN
        ORA #1
        STA SPREN
        RTS


*=$4A6A
Game_LevelEndBonus_4A6A
        SEI
        LDA #<krnINTERRUPT 
        STA sysIntVectorLo
        LDA #>krnINTERRUPT 
        STA sysIntVectorHi
        CLI
        NOP
        JSR Score_IncrementBellBonus_3E98
        JSR Screen_DrawGameScreen_4882
        LDA quasiBonus
        CMP #5
        BNE .ExitLevelEndBonus
.AddNextBellBonus
        LDY #4
.LevelBonusAddScoreLoop
        LDX #3
        JSR Score_UpdateQuasiScore_4AAE
        DEY
        BPL .LevelBonusAddScoreLoop
        JSR Sound_BellBonusCashIn_3E76
        JSR Screen_DrawGameScreen_4882
        LDA #2
        STA zpTemp
.LevelBonusMajorLoop
        LDX #0
.LevelBonusOuterLoop
        LDY #0
.LevelBonusInnerLoop
        DEY
        BNE .LevelBonusInnerLoop
        DEX
        BNE .LevelBonusOuterLoop
        DEC zpTemp
        BNE .LevelBonusMajorLoop
        LDA quasiBonus
        BNE .AddNextBellBonus
.ExitLevelEndBonus
        JMP Screen_DisplayNextLevel_4AC1


*=$4AAE
Score_UpdateQuasiScore_4AAE
        INC quasiScore,X
        LDA quasiScore,X
        CMP #10
        BNE .ExitUpdateQuasiScore
        LDA #0
        STA quasiScore,X
        DEX
        BPL Score_UpdateQuasiScore_4AAE
.ExitUpdateQuasiScore
        RTS


*=$4AC1
Screen_DisplayNextLevel_4AC1
        LDA #1
        LDA SPREN
        JSR Sound_PlayBellSound_3EA7
        LDA quasiScore+2
        BEQ .NoExtraLife
        LDA quasiExtraLifeFlag
        BNE .NoExtraLife
        INC quasiExtraLifeFlag
        INC quasiLives
        JSR Screen_DrawGameScreen_4882
.NoExtraLife
        LDA currentLevel
        AND #15
        CMP #15
        BNE .SelectNextLevel
        JMP Screen_DisplayWinningScreen_55D3
.SelectNextLevel
        LDX currentLevel
        INX
        CPX #48
        BNE .SkipLevelReset
        LDX #0
.SkipLevelReset
        STX currentLevel
        JSR Screen_BuildScreen_4219
        SEI
        LDA #<IRQ_IntroQuasiAnimate_4B74
        STA sysIntVectorLo
        LDA #>IRQ_IntroQuasiAnimate_4B74
        STA sysIntVectorHi
        LDA #1
        STA quasiLevelStartFrame
        CLI
        LDX #39
.NewLevelScrollDelayLoop
        STX zpTemp2
        JSR Screen_ScrollNewLevel_4B18
        LDX zpTemp2
        DEX
        BPL .NewLevelScrollDelayLoop
        JMP Initialise_DisplayGetReady_484D


*=$4B18
Screen_ScrollNewLevel_4B18 
        LDX #7
.CopyScreenPtrs
        LDA tbl_ScreenScrollPts,X
        STA zpScnPtrLo,X
        DEX
        BPL .CopyScreenPtrs
        LDX #22
.ScrollLoop
        LDY #1
        CPX #4
        BCS .CopyNextChar
        LDY #8
.CopyNextChar
        LDA (zpScnPtrLo),Y
        PHA
        LDA (zpColPtrLo),Y
        DEY
        STA (zpColPtrLo),Y
        PLA
        STA (zpScnPtrLo),Y
        INY
        INY
        CPY #40
        BNE .CopyNextChar
        LDA #39
        SEC
        SBC zpTemp2
        TAY
        LDA (zpScnPtrLo+4),Y
        PHA
        LDA (zpColPtrLo+4),Y
        LDY #39
        STA (zpColPtrLo),Y
        PLA
        STA (zpScnPtrLo),Y
        LDY #6
.NextRow
        LDA $0062,Y ;zpScnPtrLo
        CLC
        ADC #40
        STA $0062,Y ;zpScnPtrLo
        LDA $0063,Y ;zpScnPtrHi
        ADC #0
        STA $0063,Y ;zpScnPtrHi
        DEY
        DEY
        BPL .NextRow
        DEX
        BPL .ScrollLoop
        LDX #49
.ScrollOuterLoop
        LDY #0
.ScrollInnerLoop
        DEY
        BNE .ScrollInnerLoop
        DEX
        BNE .ScrollOuterLoop
        RTS


*=$4B74
IRQ_IntroQuasiAnimate_4B74
        DEC quasiLevelStartFrame
        BEQ .IntroQuasiAnimate
        JMP krnINTERRUPT
.IntroQuasiAnimate
        LDA #3
        STA quasiLevelStartFrame
        LDA quasiX
        SEC
        SBC #2
        STA quasiX
        BCS .SkipMSB
        DEC quasiXMSB
.SkipMSB
        LDA #0
        STA quasiIntroX
        JSR Quasi_Animate_49DC
        LDA quasiXMSB
        BNE IRQ_IntroQuasiAnimate_4B74
        LDA quasiX
        CMP #18
        BCS IRQ_IntroQuasiAnimate_4B74
        SEI
        LDA #<krnINTERRUPT
        STA sysIntVectorLo
        LDA #>krnINTERRUPT
        STA sysIntVectorHi
        CLI
        JMP krnINTERRUPT


*=$4BB2
Screen_DrawPlayerStats_4BB2
        LDX #10
.DrawPlayerStatsLoop
        LDA txt_PlayerStats,X
        STA SCREENRAM,X
        LDA txt_PlayerStats+$0028,X
        STA SCREENRAM+$0028,X
        DEX
        BPL .DrawPlayerStatsLoop
        LDA quasiBonus
        RTS


*=$4BC7
Screen_DisplayGetReady_4BC7
        LDA SCREENRAM+$0100,X
        STA tmpScreenChars,X
        LDA COLOURRAM+$0100,X
        STA tmpScreenColours,X
        LDA txt_GetReady,X
        RTS

*=$4BD7
Screen_ClearGetReady_4BD7
        LDA tmpScreenColours,X
        STA COLOURRAM+$0100,X
        LDA tmpScreenChars,X
        STA SCREENRAM+$0100,X
        RTS

*=$4BE4
IRQ_AnimatePitKnights_4BE4
        SEI
        LDA #<Enemy_AnimatePitKnights_4BF1
        STA sysIntVectorLo
        LDA #>Enemy_AnimatePitKnights_4BF1
        JSR IRQ_AnimatePitKnightsP2_3EEA
        CLI
        RTS


*=$4BF1
Enemy_AnimatePitKnights_4BF1
        LDX currentLevel
        LDA tbl_LevelType,X
        AND #1 ;pit knights
        BNE .AnimatePitKnights
.ExitAnimatePitKnights
        JMP Enemy_UpdateFireball_4D59
.AnimatePitKnights
        LDA SCREENRAM+$01C1
        CMP #CHAR_WALL
        BNE .PitKnight1
.Pit1Done
        JMP .Pit2Test
.PitKnight1
        DEC pitKnight1Counter
        BNE .Pit1Done
        LDA #10
        LDX pitKnight1Frame
        CPX #3
        BNE .AnimatePitKnight1
        LDA #128
.AnimatePitKnight1
        STA pitKnight1Counter
        INX
        TXA
        AND #3
        STA pitKnight1Frame
        BEQ .PitKnight1Frame1Chars
        CMP #2
        BEQ .PitKnight1Frame3Chars
        LDX #20
.Pit1Frame2Loop
        LDY tbl_PitCharsX,X
        LDA tbl_KnightFrame2Chars,X
        STA SCREENRAM+$014A,Y
        LDA #LIGHTRED
        STA COLOURRAM+$014A,Y
        DEX
        BPL .Pit1Frame2Loop
.Pit1AnimateEnd
        LDA #GRAY1
        STA COLOURRAM+$01C3
        JMP .Pit1Done
.PitKnight1Frame3Chars
        LDX #20
.Pit1Frame3Loop
        LDY tbl_PitCharsX,X
        LDA tbl_KnightFrame3Chars,X
        STA SCREENRAM+$014A,Y
        LDA #LIGHTRED
        STA COLOURRAM+$014A,Y
        DEX
        BPL .Pit1Frame3Loop
        BMI .Pit1AnimateEnd
.PitKnight1Frame1Chars
        LDX #20
.Pit1Frame1Loop
        LDY tbl_PitCharsX,X
        LDA tbl_KnightFrame1Chars,X
        STA SCREENRAM+$014A,Y
        LDA #LIGHTRED
        STA COLOURRAM+$014A,Y
        DEX
        BPL .Pit1Frame1Loop
        BMI .Pit1AnimateEnd
.Pit2Test
        LDA SCREENRAM+$01CA
        CMP #CHAR_WALL
        BNE .PitKnight2
.Pit2Done
        JMP .Pit3Test
.PitKnight2
        DEC pitKnight2Counter
        BNE .Pit2Done
        LDA #10
        LDX pitKnight2Frame
        CPX #3
        BNE .AnimatePitKnight2
        LDA #128
.AnimatePitKnight2
        STA pitKnight2Counter
        INX
        TXA
        AND #3
        STA pitKnight2Frame
        BEQ .Pit2Frame1
        CMP #2
        BEQ .Pit2Frame3
        LDX #20
.Pit2Frame2Loop
        LDY tbl_PitCharsX,X
        LDA tbl_KnightFrame2Chars,X
        STA SCREENRAM+$0153,Y
        LDA #LIGHTRED
        STA COLOURRAM+$0153,Y
        DEX
        BPL .Pit2Frame2Loop
.Pit2AnimateEnd
        LDA #GRAY1
        STA COLOURRAM+$01CC
        JMP .Pit2Done
.Pit2Frame3
        LDX #20
.Pit2Frame3Loop
        LDY tbl_PitCharsX,X
        LDA tbl_KnightFrame3Chars,X
        STA SCREENRAM+$0153,Y
        LDA #LIGHTRED
        STA COLOURRAM+$0153,Y
        DEX
        BPL .Pit2Frame3Loop
        BMI .Pit2AnimateEnd
.Pit2Frame1
        LDX #20
.Pit2Frame1Loop
        LDY tbl_PitCharsX,X
        LDA tbl_KnightFrame1Chars,X
        STA SCREENRAM+$0153,Y
        LDA #LIGHTRED
        STA COLOURRAM+$0153,Y
        DEX
        BPL .Pit2Frame1Loop
        BMI .Pit2AnimateEnd
.Pit3Test
        LDA SCREENRAM+$01D3
        CMP #CHAR_WALL
        BNE .PitKnight3
.Pit3Done
        JMP .ExitAnimatePitKnights
.PitKnight3
        DEC pitKnight3Counter
        BNE .Pit3Done
        LDA #10
        LDX pitKnight3Frame
        CPX #3
        BNE .AnimatePitKnight3
        LDA #128
.AnimatePitKnight3
        STA pitKnight3Counter
        INX
        TXA
        AND #3
        STA pitKnight3Frame
        BEQ .Pit3Frame1
        CMP #2
        BEQ .Pit3Frame3
        LDX #20
.Pit3Frame2Loop
        LDY tbl_PitCharsX,X
        LDA tbl_KnightFrame2Chars,X
        STA SCREENRAM+$015C,Y
        LDA #LIGHTRED
        STA COLOURRAM+$015C,Y
        DEX
        BPL .Pit3Frame2Loop
.Pit3AnimateEnd
        LDA #GRAY1
        STA COLOURRAM+$01D5
        JMP .Pit3Done
.Pit3Frame3
        LDX #20
.Pit3Frame3Loop
        LDY tbl_PitCharsX,X
        LDA tbl_KnightFrame3Chars,X
        STA SCREENRAM+$015C,Y
        LDA #LIGHTRED
        STA COLOURRAM+$015C,Y
        DEX
        BPL .Pit3Frame3Loop
        BMI .Pit3AnimateEnd
.Pit3Frame1
        LDX #20
.Pit3Frame1Loop
        LDY tbl_PitCharsX,X
        LDA tbl_KnightFrame1Chars,X
        STA SCREENRAM+$015C,Y
        LDA #LIGHTRED
        STA COLOURRAM+$015C,Y
        DEX
        BPL .Pit3Frame1Loop
        BMI .Pit3AnimateEnd


*=$4D4B
Enemy_InitData_4D4B
        LDX #16
.InitEnemyLoop
        LDA tbl_EnemyInit,X
        STA pitKnight1Frame,X
        DEX
        BPL .InitEnemyLoop
        JMP IRQ_AnimatePitKnights_4BE4


*=$4D59
Enemy_UpdateFireball_4D59
        LDX currentLevel
        LDA tbl_LevelEnemyType,X
        AND #2 ;high fireball
        BNE .CheckFireball
.ExitCheckFireball
        JMP Enemy_UpdateRearArrow_4DCF
.CheckFireball
        LDX #2
.MoveFireballLoop
        LDA missileX
        BNE .SkipClearFireballMSB
        DEC missileXMSB
.SkipClearFireballMSB
        DEC missileX
        DEX
        BNE .MoveFireballLoop
        JSR Enemy_SetFireballHighY_4DC7
        LDA missileXMSB
        ORA missileX
        BNE .ExitCheckFireball
        JSR Sound_PlayMissileSound_3E2A
        LDA #1
        STA missileXMSB
        LDA #88
        STA missileX
        JMP .ExitCheckFireball


*=$4D91
Enemy_UpdateFireballSprite_4D91
        LDA #PURPLE
        STA SPRCOL2
        LDA missileY
        STA SPRY2
        LDA missileX
        STA SPRX2
        LDA SPRXMSB
        AND #SPRITE2_MASK_OFF
        LDX missileXMSB
        BEQ .ClearFireballMSB
        ORA #SPRITE2_MASK_ON
.ClearFireballMSB
        STA SPRXMSB
        LDA missileX
        LSR
        LSR
        AND #3
        CLC
        ADC #SPRITE_FIREBALL_FRAME1
        STA SPRPTR2
        LDA SPREN
        ORA #SPRITE2_MASK_ON
        STA SPREN
        RTS

*=$4DC7
Enemy_SetFireballHighY_4DC7
        LDA #88
        STA missileY
        JMP Enemy_UpdateFireballSprite_4D91


*=$4DCF
Enemy_UpdateRearArrow_4DCF
        LDX currentLevel
        LDA tbl_LevelEnemyType,X
        AND #4 ;rear arrow
        BNE .UpdateRearArrow
.ExitUpdateRearArrow
        JMP Enemy_UpdateLowFireball_4E39
.UpdateRearArrow
        LDX #2
.MoveRearArrowLoop
        INC missileX
        BNE .SkipRearArrowMSB
        INC missileXMSB
.SkipRearArrowMSB
        DEX
        BNE .MoveRearArrowLoop
        LDA #117
        STA missileY
        JSR Enemy_UpdateRearArrowSprite_4E0B
        LDA missileXMSB
        BEQ .ExitUpdateRearArrow
        LDA missileX
        CMP #88
        BCC .ExitUpdateRearArrow
        JSR Sound_PlayMissileSound_3E2A
        LDA #0
        STA missileX
        STA missileXMSB
        JMP .ExitUpdateRearArrow


*=$4E0B
Enemy_UpdateRearArrowSprite_4E0B
        LDA #PURPLE
        STA SPRCOL2
        LDA missileY
        STA SPRY2
        LDA missileX
        STA SPRX2
        LDA SPRXMSB
        AND #SPRITE2_MASK_OFF
        LDX missileXMSB
        BEQ .ClearRearArrowMSB
        ORA #SPRITE2_MASK_ON
.ClearRearArrowMSB
        STA SPRXMSB
        LDA #SPRITE_ARROW_RIGHT_FRAME
        STA SPRPTR2
        LDA SPREN
        ORA #SPRITE2_MASK_ON
        STA SPREN
        RTS


*=$4E39
Enemy_UpdateLowFireball_4E39
        LDX currentLevel
        LDA tbl_LevelEnemyType,X
        AND #8 ;low fireball
        BNE .UpdateLowFireball
.ExitUpdateLowFireball
        JMP Enemy_UpdateFrontDoubleArrow_4E76
.UpdateLowFireball
        LDX #2
.MoveLowFireballLoop
        LDA missileX
        BNE .SkipLowFireballMSB
        DEC missileXMSB
.SkipLowFireballMSB
        DEC missileX
        DEX
        BNE .MoveLowFireballLoop
        LDA #117
        STA missileY
        JSR Enemy_UpdateFireballSprite_4D91
        LDA missileXMSB
        ORA missileX
        BNE .ExitUpdateLowFireball
        JSR Sound_PlayMissileSound_3E2A
        LDA #88
        STA missileX
        LDA #1
        STA missileXMSB
        JMP .ExitUpdateLowFireball


*=$4E76
Enemy_UpdateFrontDoubleArrow_4E76
        LDX currentLevel
        LDA tbl_LevelEnemyType,X
        AND #16
        BNE .UpdateFrontDoubleArrow
.ExitUpdateFrontDoubleArrow
        JMP Enemy_UpdateRearDoubleArrow_4F87
.UpdateFrontDoubleArrow
        LDA #PURPLE
        STA SPRCOL2
        STA SPRCOL3
        LDX #2
.UpdateDoubleArrowLoop
        LDA missileX
        BNE .SkipDoubleArrowMSB
        DEC missileXMSB
.SkipDoubleArrowMSB
        DEC missileX
        DEX
        BNE .UpdateDoubleArrowLoop
        DEC missile2Delay
        BNE .UpdateDoubleArrowSprites
        LDA #1
        STA missile2Delay
        LDX #2
.UpdateDoubleArrow2Loop
        LDA missile2X
        BNE .SkipDoubleArrow2MSB
        DEC missile2XMSB
.SkipDoubleArrow2MSB
        DEC missile2X
        DEX
        BNE .UpdateDoubleArrow2Loop
.UpdateDoubleArrowSprites
        LDA missileY
        STA SPRY2
        LDA missileX
        STA SPRX2
        LDA missile2Y
        STA SPRY3
        LDA missile2X
        STA SPRX3
        LDA SPRXMSB
        AND #SPRITE2_3_MASK_OFF
        LDX missileXMSB
        BEQ .ClearFirstArrowMSB
        ORA #SPRITE2_MASK_ON
.ClearFirstArrowMSB
        LDX missile2XMSB
        BEQ .ClearSecondArrowMSB
        ORA #SPRITE3_MASK_ON
.ClearSecondArrowMSB
        STA SPRXMSB
        LDA SPREN
        ORA #SPRITE2_3_MASK_ON
        STA SPREN
        LDA #SPRITE_ARROW_LEFT_FRAME
        STA SPRPTR2
        STA SPRPTR3
        LDA missileX
        ORA missileXMSB
        BNE .CheckArrow2
        JSR Sound_MissileFired_3E68
        LDX #88
        LSR
        BCC .LowArrow
        LDX #117
.LowArrow
        STX missileY
        LDA #86
        STA missileX
        LDA #1
        STA missileXMSB
.CheckArrow2
        LDA missile2XMSB
        ORA missile2X
        BNE .ExitArrowFire
        JSR Sound_MissileFired_3E68
        LDX #88
        LSR
        BCC .LowArrow2
        LDX #117
.LowArrow2
        STX missile2Y
        LDA #86
        STA missile2X
        LDA #1
        STA missile2XMSB
.ExitArrowFire
        JMP .ExitUpdateFrontDoubleArrow  


*=$4F34
Game_Randomise_4F34
        LDA #5
        STA rand+3
        LDA #229
        STA rand+2
        LDA #0
        STA rand+5
        STA rand+4
        LDX #16
.RandLoop
        LSR rand+3
        ROR rand+2
        BCC .NextRand
        LDA rand+4
        CLC
        ADC rand
        STA rand+4
        LDA rand+5
        ADC rand+1
        STA rand+5
.NextRand
        ASL rand
        ROL rand+1
        DEX
        BNE .RandLoop
        LDA rand+4
        CLC
        ADC #41
        STA rand+4
        BCC .SkipRandHi
        INC rand+5
.SkipRandHi
        LDA rand+4
        STA rand
        LDA rand+5
        STA rand+1
        RTS


*=$4F87
Enemy_UpdateRearDoubleArrow_4F87
        LDX currentLevel
        LDA tbl_LevelEnemyType,X
        AND #32
        BNE .UpdateRearDoubleArrow
.ExitUpdateRearDoubleArrow
        JMP Enemy_UpdateFrontRearFireball_5043
.UpdateRearDoubleArrow
        LDA #PURPLE
        STA SPRCOL2
        STA SPRCOL3
        LDX #2
.UpdateRearDoubleArrowLoop
        INC missileX
        BNE .SkipRearDoubleArrowMSB
        INC missileXMSB
.SkipRearDoubleArrowMSB
        DEX
        BNE .UpdateRearDoubleArrowLoop
        DEC missile2Delay
        BNE .UpdateRearDoubleArrowSprites
        LDA #1
        STA missile2Delay
        LDX #2
.UpdateRearDoubleArrow2Loop
        INC missile2X
        BNE .SkipRearDoubleArrow2MSB
        INC missile2XMSB
.SkipRearDoubleArrow2MSB
        DEX
        BNE .UpdateRearDoubleArrow2Loop
.UpdateRearDoubleArrowSprites
        LDA missileY
        STA SPRY2
        LDA missileX
        STA SPRX2
        LDA missile2Y
        STA SPRY3
        LDA missile2X
        STA SPRX3
        LDA SPRXMSB
        AND #SPRITE2_3_MASK_OFF
        LDX missileXMSB
        BEQ .ClearRearDoubleArrow1MSB
        ORA #SPRITE2_MASK_ON
.ClearRearDoubleArrow1MSB
        LDX missile2XMSB
        BEQ .ClearRearDoubleArrow2MSB
        ORA #SPRITE3_MASK_ON
.ClearRearDoubleArrow2MSB
        STA SPRXMSB
        LDA SPREN
        ORA #SPRITE2_3_MASK_ON
        STA SPREN
        LDA #SPRITE_ARROW_RIGHT_FRAME
        STA SPRPTR2
        STA SPRPTR3
        LDA missileXMSB
        BEQ .CheckRearArrow2
        LDA missileX
        CMP #88
        BCC .CheckRearArrow2
        JSR Sound_MissileFired_3E68
        LDX #88
        LSR
        BCC .LowRearArrow
        LDX #117
.LowRearArrow
        STX missileY
        LDA #0
        STA missileX
        STA missileXMSB
.CheckRearArrow2
        LDA missile2XMSB
        BEQ .RearArrowStillActive
        LDA missile2X
        CMP #88
        BCC .RearArrowStillActive
        JSR Sound_MissileFired_3E68
        LDX #88
        LSR
        BCC .LowRearArrow2
        LDX #117
.LowRearArrow2
        STX missile2Y
        LDA #0
        STA missile2X
        STA missile2XMSB
.RearArrowStillActive
        JMP .ExitUpdateRearDoubleArrow


*=$5043
Enemy_UpdateFrontRearFireball_5043
        LDX currentLevel
        LDA tbl_LevelEnemyType,X
        AND #64   
        BNE .UpdateFrontRearFireball
.ExitUpdateFrontRearFireball
        JMP Enemy_UpdateFrontRearArrow_514D
.UpdateFrontRearFireball
        LDA missileDx
        BMI .MoveFireballLeft
        LDA missileX
        CLC
        ADC #2
        STA missileX
        BCC .NoFireballMSB
        INC missileXMSB
.NoFireballMSB
        JMP .UpdateFireball2
.MoveFireballLeft
        LDA missileX
        SEC
        SBC #2
        STA missileX
        BCS .UpdateFireball2
        DEC missileXMSB
.UpdateFireball2
        DEC missile2Delay
        BNE .UpdateFireballSprites
        LDA #1
        STA missile2Delay
        LDA missile2Dx
        BMI .MoveFireball2Left
        LDA missile2X
        CLC
        ADC #2
        STA missile2X
        BCC .NoFireball2MSB
        INC missile2XMSB
.NoFireball2MSB
        JMP .UpdateFireballSprites
.MoveFireball2Left
        LDA missile2X
        SEC
        SBC #2
        STA missile2X
        BCS .UpdateFireballSprites
        DEC missile2XMSB
.UpdateFireballSprites
        LDA #PURPLE
        STA SPRCOL2
        STA SPRCOL3
        LDA missileX
        STA SPRX2
        LDA #117
        STA SPRY2
        STA SPRY3
        LDA missile2X
        STA SPRX3
        LDA SPRXMSB
        AND #SPRITE2_3_MASK_OFF
        LDX missileXMSB
        BEQ .CheckFireball2MSB
        ORA #SPRITE2_MASK_ON
.CheckFireball2MSB
        LDX missile2XMSB
        BEQ .SetBothFireballMSB
        ORA #SPRITE3_MASK_ON
.SetBothFireballMSB
        STA SPRXMSB
        LDA missileX
        LSR
        LSR
        AND #3
        CLC
        ADC #SPRITE_FIREBALL_FRAME1
        STA SPRPTR2
        LDA missile2X
        LSR
        LSR
        AND #3
        CLC
        ADC #SPRITE_FIREBALL_FRAME1
        STA SPRPTR3
        LDA SPREN
        ORA #SPRITE2_3_MASK_ON
        STA SPREN
        LDA missileX
        ORA missileXMSB
        BEQ .PrepareNextFireball
        LDA missileXMSB
        BEQ .CheckFireball2
        LDA missileX
        CMP #88
        BCC .CheckFireball2
.PrepareNextFireball
        JSR Enemy_SelectFireballDirection_5139
        STX missileX
        STY missileXMSB
        STA missileDx
.CheckFireball2
        LDA missile2X
        ORA missile2XMSB
        BEQ .PrepareNextFireball2
        LDA missile2XMSB
        BEQ .ExitFireballSelect
        LDA missile2X
        CMP #88
        BCC .ExitFireballSelect
.PrepareNextFireball2
        JSR Enemy_SelectFireballDirection_5139
        STX missile2X
        STY missile2XMSB
        STA missile2Dx
.ExitFireballSelect
        JMP .ExitUpdateFrontRearFireball


*=$5139
Enemy_SelectFireballDirection_5139
        JSR Sound_MissileFired_3E68
        LSR
        BCC .FireballDirectionLeft
        LDX #0
        LDY #0
        LDA #2
        RTS
.FireballDirectionLeft
        LDX #86
        LDY #1
        LDA #254
        RTS


*=$514D
Enemy_UpdateFrontRearArrow_514D
        LDX currentLevel
        LDA tbl_LevelEnemyType,X
        AND #128 ;double arrow front & rear
        BNE .UpdateFrontRearArrow
.ExitUpdateFrontRearArrow
        JMP Game_SetHeartSprite_525F
.UpdateFrontRearArrow
        LDA #PURPLE
        STA SPRCOL2
        STA SPRCOL3
        LDA missileY
        CMP #117
        BNE .MoveArrowRight
        LDA missileX
        SEC
        SBC #2
        STA missileX
        BCS .ArrowMSBNotCleared
        DEC missileXMSB
.ArrowMSBNotCleared
        JMP .MoveArrow2
.MoveArrowRight
        LDA missileX
        CLC
        ADC #2
        STA missileX
        BCC .MoveArrow2
        INC missileXMSB
.MoveArrow2
        DEC missile2Delay
        BNE .UpdateArrowSprites
        LDA #1
        STA missile2Delay
        LDA missile2Y
        CMP #117
        BNE .MoveArrow2Right
        LDA missile2X
        SEC
        SBC #2
        STA missile2X
        BCS .Arrow2MSBNotCleared
        DEC missile2XMSB
.Arrow2MSBNotCleared
        JMP .UpdateArrowSprites
.MoveArrow2Right
        LDA missile2X
        CLC
        ADC #2
        STA missile2X
        BCC .UpdateArrowSprites
        INC missile2XMSB
.UpdateArrowSprites
        LDA missileY
        STA SPRY2
        LDA missileX
        STA SPRX2
        LDA missile2X
        STA SPRX3
        LDA missile2Y
        STA SPRY3
        LDA SPRXMSB
        AND #SPRITE2_3_MASK_OFF
        LDX missileXMSB
        BEQ .CheckArrow2MSB
        ORA #SPRITE2_MASK_ON
.CheckArrow2MSB
        LDX missile2XMSB
        BEQ .SetBothArrowMSB
        ORA #SPRITE3_MASK_ON
.SetBothArrowMSB
        STA SPRXMSB
        LDX #SPRITE_ARROW_RIGHT_FRAME
        LDA missileY
        CMP #117
        BNE .ArrowRight
        INX
.ArrowRight
        STX SPRPTR2
        LDX #SPRITE_ARROW_RIGHT_FRAME
        LDA missile2Y
        CMP #117
        BNE .Arrow2Right
        INX
.Arrow2Right
        STX SPRPTR3
        LDA SPREN
        ORA #SPRITE2_3_MASK_ON
        STA SPREN
        LDA missileX
        ORA missileXMSB
        BEQ .PrepareNextArrow
        LDA missileXMSB
        BEQ .CheckArrow2Pos
        LDA missileX
        CMP #88
        BCC .CheckArrow2Pos
.PrepareNextArrow
        JSR Enemy_SelectArrowDirection_542B
        STX missileX
        STY missileXMSB
        STA missileY
.CheckArrow2Pos
        LDA missile2X
        ORA missile2XMSB
        BEQ .PrepareNextArrow2
        LDA missile2XMSB
        BEQ .ExitFrontRearArrow
        LDA missile2X
        CMP #88
        BCC .ExitFrontRearArrow
.PrepareNextArrow2
        JSR Enemy_SelectArrowDirection_542B
        STX missile2X
        STY missile2XMSB
        STA missile2Y
.ExitFrontRearArrow
        JMP .ExitUpdateFrontRearArrow


*=$524B
Enemy_SelectArrowDirection_542B
        JSR Sound_MissileFired_3E68
        LSR
        BCC .MissileMoveLeft
        LDX #0
        LDY #0
        LDA #88
        RTS
.MissileMoveLeft
        LDX #86
        LDY #1
        LDA #117
        RTS


*=$525F
Game_SetHeartSprite_525F
        LDA #RED
        STA SPRCOL7
        LDA #240
        STA SPRX7
        LDA #74
        STA SPRY7
        LDA SPRXMSB
        AND #SPRITE7_MASK_OFF
        STA SPRXMSB
        LDA currentLevel
        AND #15
        TAX
        LDA SPREN
        AND #SPRITE7_MASK_OFF
        CPX #15
        BNE .HeartNotDisplayed
        ORA #SPRITE7_MASK_ON
.HeartNotDisplayed
        STA SPREN
        DEC heartCounter
        BEQ .AnimateHeart
.ExitSetHeartSprite
        JMP Knight_MoveKnight_52B4
.AnimateHeart
        LDA #64
        STA heartCounter
        LDA SPRPTR7 
        EOR #1
        AND #1
        ORA #SPRITE_HEART_FRAME1
        STA SPRPTR7
        LDX #7
.FlashCharBlockLoop
        LDA chr_Block1,X
        EOR chr_Block2,X
        STA chr_Block1,X
        DEX
        BPL .FlashCharBlockLoop
        JMP .ExitSetHeartSprite

*=$52B4
Knight_MoveKnight_52B4
        DEC knightMoveRate
        BEQ .MoveKnight
.ExitMoveKnight
        JMP Enemy_UpdateRope_539E
.MoveKnight
        LDA currentLevel
        LSR
        LSR
        LSR
        LSR
        TAX
        LDA tbl_KnightMoveRates,X
        STA knightMoveRate
        LDA knightY
        CMP #117
        BEQ .MoveKnightX
        LDA knightFrame
        EOR #1
        STA knightFrame
        AND #1
        BNE .UpdateKnight
        LDA knightY
        SEC
        SBC #8
        STA knightY
.UpdateKnight
        JSR Knight_UpdateSprite_530B
        JMP .ExitMoveKnight
.MoveKnightX
        LDA knightFrame
        EOR #1
        ORA #2
        STA knightFrame
        AND #1
        BNE .SkipKnightXMSB
        LDA knightX
        CLC
        ADC #8
        STA knightX
        BCC .SkipKnightXMSB
        INC knightXMSB
.SkipKnightXMSB
        JMP .UpdateKnight


*=$530B
Knight_UpdateSprite_530B
        INC knightCounter
        LDA knightFrame
        STA SPRPTR1
        LDA #GRAY1
        STA SPRCOL1
        LDA knightY
        STA SPRY1
        LDA knightX
        CLC
        ADC #$18
        STA SPRX1
        LDA knightXMSB
        ADC #$00
        TAX
        LDA SPRXMSB
        AND #SPRITE1_MASK_OFF
        CPX #$00
        BEQ .ClearKnightXMSB
        ORA #SPRITE1_MASK_ON
.ClearKnightXMSB
        STA SPRXMSB
        LDA SPREN
        ORA #SPRITE1_MASK_ON
        STA SPREN
        LDA knightY
        CMP #117
        BEQ .DrawKnightBridge
        RTS
.DrawKnightBridge
        LDA knightX
        LSR
        LSR
        LSR
        CLC
        ADC #63
        LDX knightXMSB
        BEQ .KnightMSBNotSet
        CLC
        ADC #32
.KnightMSBNotSet
        STA zpBridgeScnPtrLo
        STA zpBridgeColPtrLo
        LDA #>SCREENRAM+$0100
        STA zpBridgeScnPtrHi
        LDA #>COLOURRAM+$0100
        STA zpBridgeColPtrHi
        LDX #11
.DrawKnightBridgeLoop
        LDA tbl_BridgeChars,X
        LDY tbl_BridgeCharsXOffset,X
        STA (zpBridgeScnPtrLo),Y
        LDA COLOURRAM+$022F
        STA (zpBridgeColPtrLo),Y
        DEX
        BPL .DrawKnightBridgeLoop
        RTS


*=$537C
Initialise_InitKnight_537C
        JSR Quasi_Animate_49DC
        LDA #197
        STA knightY
        LDA #16
        STA knightX
        STA knightMoveRate
        LDA #$FF
        STA knightCounter
        LDA #SPRITE_KNIGHT_CLIMB_FRAME1
        STA knightFrame
        LDA #0
        STA knightXMSB
        JMP Knight_UpdateSprite_530B


*=$539E
Enemy_UpdateRope_539E
        LDX currentLevel
        LDA tbl_LevelEnemyType,X
        AND #1
        BNE .UpdateRope
.ExitUpdateRope
        JMP krnINTERRUPT
.UpdateRope
        DEC ropeSpeedCounter
        BNE .ExitUpdateRope
        LDA #ROPE_SPEED
        STA ropeSpeedCounter
        INC ropeFrame
        LDA ropeFrame
        AND #31
        STA ropeFrame
        TAX
        LDA #WHITE
        STA SPRCOL4
        STA SPRCOL6
        LDA tbl_RopeUpperFrame,X
        STA SPRPTR4
        LDA tbl_RopeLowerFrame,X
        STA SPRPTR6   
        LDA SPRXMSB
        AND #$8F
        STA SPRXMSB
        LDA tbl_RopeUpperX,X
        STA SPRX4
        LDA #66
        STA SPRY4
        LDA tbl_RopeLowerX,X
        STA SPRX6
        LDA #108
        STA SPRY6
        TXA
        AND #7
        BNE .SkipPlayRopeSound
        JSR Sound_PlayRopeSound_3E49
.SkipPlayRopeSound
        LDA SPREN
        ORA #SPRITE4_6_MASK_ON
        STA SPREN
        JMP .ExitUpdateRope


*=$5406
Game_CheckRopeCollision_5406
        LDX currentLevel
        LDA tbl_LevelEnemyType,X
        AND #1 ;rope
        BNE .CheckQuasiRopeCollision
.ExitCheckRopeCollision
        JMP .QuasiNotOnRope
.CheckQuasiRopeCollision
        LDA quasiXMSB
        BNE .ExitCheckRopeCollision
        LDA quasiX
        CMP #88
        BCC .ExitCheckRopeCollision
        CMP #224
        BCS .ExitCheckRopeCollision
        JMP Game_CheckQuasiRopeCollision_5465


*=$5426
Game_QuasiOnRope_5426
        CMP #0
        BEQ .ExitCheckRopeCollision
.QuasiOnRope
        LDA quasiJumpActive
        BNE .ExitCheckRopeCollision
        LDX #0
        STX quasiXMSB
        INX
        STX QuasiOnRopeFlag
        LDX ropeFrame
        LDA tbl_QuasiRopeXPosition,X
        STA quasiX
        JMP .ExitQuasiOnRope
.QuasiNotOnRope
        LDA #0
        STA QuasiOnRopeFlag
.ExitQuasiOnRope
        JMP Enemy_RowOfBells_5477


*=$544C
Quasi_SetSwingFrame_544C
        JSR Game_TestQuasiOnRope_54C8
        BEQ .SkipChangeQuasiFrame
        LDA #SPRITE_QUASI_SWING_RIGHT_FRAME
        LDY quasiDirection
        BEQ .SkipChangeQuasiFrame
        LDA #SPRITE_QUASI_SWING_LEFT_FRAME
.SkipChangeQuasiFrame
        JMP Quasi_UpdateFrame_4A5E


*=$545D
Initialise_ClearOnRopeFlag_545D
        LDA #0
        STA QuasiOnRopeFlag
        JMP Initialise_ClearOnBellFlag_5484

*=$5465
Game_CheckQuasiRopeCollision_5465
        LDA SPRCSP
        AND #SPRITE0_6_MASK_ON
        CMP #SPRITE0_6_MASK_ON
        BNE .CheckIfAlreadyOnRope
        JMP .QuasiOnRope
.CheckIfAlreadyOnRope
        LDA QuasiOnRopeFlag
        JMP Game_QuasiOnRope_5426


*=$5477
Enemy_RowOfBells_5477
        LDX currentLevel
        LDA tbl_LevelType,X
        AND #4
        BNE Enemy_RowOfBellsTest_548A
.ExitRowOfBells
        JMP Enemy_ClearQuasiOnBellFlah_54D4


*=$5484
Initialise_ClearOnBellFlag_5484
        STA QuasiOnBellFlag
        JMP .DisplayInitScreen


*=$548A
Enemy_RowOfBellsTest_548A
        LDA SPRCBG
        AND #1
        BEQ .ExitRowOfBells
        LDA quasiXMSB
        ORA quasiJumpActive
        BNE .ExitRowOfBells
        LDA QuasiOnBellFlag
        BNE .SelectBell
        LDA quasiX
        CMP #88
        BCC .ExitRowOfBells
        CMP #224
        BCS .ExitRowOfBells
        LDA #1
        STA QuasiOnBellFlag
        JSR Sound_PlayRowOfBellsSound_3C00
.SelectBell
        LDX #0
.SelectBellLoop
        LDA tbl_RowOfBellsXPosition,X
        CMP quasiX
        BCS .BellFound
        INX
        JMP .SelectBellLoop
.BellFound
        LDA tbl_QuasiBellXPosition,X
        STA quasiX
        JMP .AnimateQuasi


*=$54C8
Game_TestQuasiOnRope_54C8
        PHA
        LDA QuasiOnRopeFlag
        ORA QuasiOnBellFlag
        TAY
        PLA
        CPY #0
        RTS


*=$54D4
Enemy_ClearQuasiOnBellFlah_54D4
        LDA #0
        STA QuasiOnBellFlag
.AnimateQuasi
        JMP Quasi_Animate_49DC


*=$54DC 
Game_LevelComplete_54DC
        AND #SPRITE1_MASK_OFF
        STA SPREN
        LDA knightX
        LSR
        LSR
        LSR
        LDX knightXMSB
        BEQ .SkipMSBOffset
        CLC
        ADC #32
.SkipMSBOffset
        STA zpScnPtrLo
        LDA #>SCREENRAM
        STA zpScnPtrHi
        DEC zpScnPtrLo
        DEC zpScnPtrLo
        LDA knightY
        SEC
        SBC #53
        LSR
        LSR
        LSR
        TAY
        BEQ .SetScoreBoxColPtr
.SetScoreBoxScreenPosLoop
        LDA zpScnPtrLo
        CLC
        ADC #40
        STA zpScnPtrLo
        BCC .SkipScoreBoxHiByte
        INC zpScnPtrHi
.SkipScoreBoxHiByte
        DEY
        BNE .SetScoreBoxScreenPosLoop
.SetScoreBoxColPtr
        LDA zpScnPtrLo
        STA zpColPtrLo
        LDA zpScnPtrHi
        CLC
        ADC #100
        STA zpColPtrHi
        LDX #27
.DisplayScoreBoxLoop
        LDY tbl_ScoreBoxCharX,X
        LDA tbl_ScoreBoxChars,X
        STA (zpScnPtrLo),Y
        LDA tbl_ScoreBoxCharColours,X
        STA (zpColPtrLo),Y
        DEX
        BPL .DisplayScoreBoxLoop
        LDX #1
.FindMultiplierLoop
        LDA knightCounter
        CMP tbl_ScoreMultiplier-1,X
        BCS .MultiplierSelected
        INX
        JMP .FindMultiplierLoop
.MultiplierSelected
        STX scoreMultiplier
        LDA #0
        STA scoreLevel
        STA scoreLevel+1
        LDX currentLevel
.AddScoreMultiplierLoop
        SED
        LDA scoreLevel+1
        CLC
        ADC scoreMultiplier
        STA scoreLevel+1
        LDA scoreLevel
        ADC #0
        STA scoreLevel
        CLD
        DEX
        BPL .AddScoreMultiplierLoop
        LDY #81
        LDA scoreLevel
        AND #15
        ORA #48
        STA (zpScnPtrLo),Y
        INY
        LDA scoreLevel+1
        PHA
        LSR
        LSR
        LSR
        LSR
        ORA #48
        STA (zpScnPtrLo),Y
        INY
        PLA
        AND #15
        ORA #48
        STA (zpScnPtrLo),Y
        LDA scoreLevel
        AND #15
        TAY
        BEQ .SkipZeroScore
.ScoreDigit1Loop
        LDX #2
        JSR Score_UpdateQuasiScore_4AAE
        DEY
        BNE .ScoreDigit1Loop
.SkipZeroScore
        LDA scoreLevel+1
        LSR
        LSR
        LSR
        LSR
        TAY
        BEQ .SkipZeroScore2
.ScoreDigit2Loop
        LDX #3
        JSR Score_UpdateQuasiScore_4AAE
        DEY
        BNE .ScoreDigit2Loop
.SkipZeroScore2
        LDA scoreLevel+1
        AND #15
        TAY
        BEQ .SkipZeroScore3
.ScoreDigit3Loop
        LDX #4
        JSR Score_UpdateQuasiScore_4AAE
        DEY
        BNE .ScoreDigit3Loop
.SkipZeroScore3
        JSR Screen_DrawGameScreen_4882
        byte $2C, $00, $00 ;BIT $0000
        LDA #8
        STA zpTemp
.ScoreBoxMajorLoop
        LDX #0
.ScoreBoxOuterLoop
        LDY #0
.ScoreBoxInnerLoop
        DEY
        BNE .ScoreBoxInnerLoop
        DEX
        BNE .ScoreBoxOuterLoop
        DEC zpTemp
        BNE .ScoreBoxMajorLoop
        LDA #SPRITE0_MASK_ON
        STA SPREN
        RTS


*=$55D3
Screen_DisplayWinningScreen_55D3
        LDA #170
        STA SPRX0
        LDA #152
        STA SPRY0
        LDA #0
        STA SPRXMSB
        LDA #SPRITE_QUASI_WALK_RIGHT_FRAME2
        STA SPRPTR0
        LDX #0
.EndGameClearScreenLoop
        LDA #CHAR_SPACE
        STA SCREENRAM,X
        STA SCREENRAM+$0100,X
        STA SCREENRAM+$0200,X
        STA SCREENRAM+$02F0,X
        INX
        BNE .EndGameClearScreenLoop
        LDX #7
.DisplayMyHeroLoop
        LDA txt_MyHero,X
        STA SCREENRAM+$01A0,X
        LDA #CYAN
        STA COLOURRAM+$01A0,X
        DEX
        BPL .DisplayMyHeroLoop
        LDX #14
.SetHeartsXYLoop
        LDA tbl_HeartSpritesXY,X 
        STA SPRX1,X
        DEX
        BPL .SetHeartsXYLoop
        LDX #6
.SetHeartFrameAndColourLoop
        LDA #RED
        STA SPRCOL1,X
        LDA #SPRITE_HEART_FRAME1
        STA SPRPTR1,X
        DEX
        BPL .SetHeartFrameAndColourLoop
        LDA #1
        STA SPRMCS
        LDA #0
        STA SPRYEX
        STA SPRXEX
        LDA #255
        STA SPREN
        LDA #27
        STA zpTemp
.NextHeartAnimFrame
        LDA zpTemp
        AND #3
        TAX
        LDA tbl_HeartAnimFrames,X
        LDX #6
.UpdateHeartFrameLoop
        STA SPRPTR1,X
        DEX
        BPL .UpdateHeartFrameLoop
        LDA #1
        STA zpTemp2
.HeartAnimMajorLoop
        LDX #0
.HeartAnimOuterLoop
        LDY #0
.HeartAnimInnerLoop
        DEY
        BNE .HeartAnimInnerLoop
        DEX
        BNE .HeartAnimOuterLoop
        DEC zpTemp2
        BNE .HeartAnimMajorLoop
        DEC zpTemp
        BNE .NextHeartAnimFrame
        LDX #6
.SetHeartFrameLoop
        LDA #SPRITE_HEART_FRAME1
        STA SPRPTR1,X
        DEX
        BPL .SetHeartFrameLoop
        LDX #2
        JSR Score_UpdateQuasiScore_4AAE
        LDX #2
        JSR Score_UpdateQuasiScore_4AAE
        LDA #16
        STA quasiX
        LDA #0
        STA quasiXMSB
        STA quasiJumpActive
        LDX currentLevel
        INX
        CPX #48
        BNE .SkipResetLevel
        LDX #0
.SkipResetLevel
        STX currentLevel
        LDX #12
.WinningMajorLoop
        TXA
        LDX #0
.WinningOuterLoop
        LDY #0
.WinningInnerLoop
        DEY
        BNE .WinningInnerLoop
        DEX
        BNE .WinningOuterLoop
        TAX
        DEX
        BNE .WinningMajorLoop
        LDA #0
        STA SPREN
        JMP Screen_CopyGameScreenBridging_4847


*=$56A7
Screen_CopyGameScreen_56A7
        JSR Screen_BuildScreen_4219
        LDX #0
.CopyScreenLoop
        LDA scn_TemporaryScreen,X
        STA SCREENRAM,X
        LDA scn_TemporaryScreen+$0100,X
        STA SCREENRAM+$0100,X
        LDA scn_TemporaryScreen+$0200,X
        STA SCREENRAM+$0200,X
        LDA scn_TemporaryScreen+$02F0,X
        STA SCREENRAM+$02F0,X
        LDA scn_TemporaryColour,X
        STA COLOURRAM,X
        LDA scn_TemporaryColour+$0100,X
        STA COLOURRAM+$0100,X
        LDA scn_TemporaryColour+$0200,X
        STA COLOURRAM+$0200,X
        LDA scn_TemporaryColour+$02F0,X
        STA COLOURRAM+$02F0,X
        INX
        BNE .CopyScreenLoop
        LDX #79
.CopyPlayerStatsLoop
        LDA txt_PlayerStats,X
        STA SCREENRAM,X
        LDA tbl_PlayerStatsColours,X
        STA COLOURRAM,X
        DEX
        BPL .CopyPlayerStatsLoop
        JMP Screen_DrawGameScreen_4882

*=$56F3
Game_CheckCollision_56F3
        LDX currentLevel
        LDA tbl_LevelType,X
        AND #4 ;bells
        BEQ .CheckForRopeCollision
        JMP Game_TestQuasiOnBell_574E
.CheckForRopeCollision
        LDA tbl_LevelEnemyType,X
        AND #1 ;rope
        BEQ .CheckForObjectCollision
        JMP Game_CheckBellRopeCollision_5788
.CheckForObjectCollision
        LDA SPRCSP
        AND #1
        BEQ .CheckSpriteBackgroundCollision
.CollisionDetected
        SEI
        LDA #<krnINTERRUPT
        STA sysIntVectorLo
        LDA #>krnINTERRUPT
        STA sysIntVectorHi
        CLI
        JMP Game_QuasiLoseBonus_59AA
.CheckSpriteBackgroundCollision
        JSR Game_SetQuasiXMSB_587E    
        BNE .CheckForKnightCollision
        LDA SPRCBG
        AND #1
        BNE .CollisionDetected
.CheckForKnightCollision
        LDA knightY
        CMP #117
        BNE .ExitCheckCollision
        LDA knightX
        SEC
        SBC quasiX
        LDA knightXMSB
        SBC quasiXMSB
        BCS .CollisionDetected
.ExitCheckCollision
        JMP Player_CheckPitFall_57B3


*=$5745
Game_ResetCollisionRegisters_5745
        LDA SPRCSP
        LDA SPRCBG
        JMP Screen_DrawGameScreen_4882


*=$574E
Game_TestQuasiOnBell_574E
        LDA quasiJumpActive
        BEQ .TestQuasiOnBell
.ExitTestQuasiOnBell
        JMP .CheckBellRopeCollision
.TestQuasiOnBell
        LDA quasiXMSB
        BNE .ExitTestQuasiOnBell
        LDA QuasiOnBellFlag
        BNE .ExitTestQuasiOnBell
        LDA quasiX
        CMP #80
        BCC .ExitTestQuasiOnBell
        CMP #219
        BCS .ExitTestQuasiOnBell
        LDX #3
.TestNextBellRopeLoop
        LDA quasiX
        SEC
        SBC tbl_BellRopeXOffset,X
        CMP #11
        BCC .ExitTestQuasiOnBell
        DEX
        BPL .TestNextBellRopeLoop
        JMP .CollisionDetected
.CheckBellRopeCollision
        LDA SPRCSP
        AND #1
        BNE .CollisionDetected
.ExitQuasiBellRope
        JMP .CheckForKnightCollision


*=$5788
Game_CheckBellRopeCollision_5788
        LDA quasiJumpActive
        BNE .ExitQuasiBellRope
        LDA QuasiOnRopeFlag
        BNE .ExitQuasiBellRope
        LDA quasiXMSB
        BNE .ExitQuasiBellRope
        LDA quasiX
        CMP #80
        BCC .ExitQuasiBellRope
        CMP #219
        BCS .ExitQuasiBellRope
        LDX ropeFrame
        LDA quasiX
        SEC
        SBC tbl_RopeXPositions,X
        CMP #21
        BCC .ExitQuasiBellRope
        JMP .CollisionDetected

*=$57B3
Player_CheckPitFall_57B3
        LDX currentLevel
        LDA tbl_LevelType,X
        AND #3
        BNE .CheckPitFall
.ExitCheckPitFall
        JMP Input_GetInputBridgingSub_49D9
.CheckPitFall
        LDA quasiXMSB
        BNE .ExitCheckPitFall
        LDA quasiJumpActive
        BNE .ExitCheckPitFall
        LDX #2
.CheckPitLoop
        LDA quasiX
        CMP tbl_PitLocationStartX,X
        BCC .PitClear
        CMP tbl_PitLocationEndX,X
        BCS .PitClear
        JMP .CollisionDetected
.PitClear
        DEX
        BPL .CheckPitLoop
        JMP .ExitCheckPitFall


*=$57E2
Game_QuasiDeathFall_57E2
        JSR Sound_PlayQuasiDeathSound_3C2C
.QuasiStillFalling
        INC SPRY0
        LDX #2
.QuasiFallOuterLoop
        LDY #0
.QuasiFallInnerLoop
        DEY
        BNE .QuasiFallInnerLoop
        DEX
        BNE .QuasiFallOuterLoop
        LDA SPRY0
        CMP #255
        BNE .QuasiStillFalling
        DEC quasiLives
        JSR Screen_DrawGameScreen_4882
        JSR Screen_SetFlashBGColourIRQ_3C5F
        LDA quasiLives
        BNE .QuasiLivesLeft
        JMP Player_GameOver_581D
.QuasiLivesLeft
        LDA #16
        STA quasiX
        LDA #0
        STA quasiJumpActive
        STA quasiXMSB
        STA SPREN
        JMP Screen_CopyGameScreenBridging_4847


*=$581D
Player_GameOver_581D
        LDX #8
.DisplayGameOverLoop
        LDA txt_GameOver,X
        STA SCREENRAM+$0100,X
        LDA #WHITE
        STA COLOURRAM+$0100,X
        DEX
        BPL .DisplayGameOverLoop
        LDA #>tbl_HiScores
        STA hiScorePtrHi
        LDA #<tbl_HiScores
        STA hiScorePtrLo
        LDX #4
.CheckForHiScore
        LDY #0
.FetchNextScoreDigit
        JSR Game_GetScoreDigit_5878
        CMP (hiScorePtrLo),Y
        BEQ .CheckNextScoreDigit    
        BCS .HiScoreFound
        BCC .CheckNextHiScore
.CheckNextScoreDigit
        INY
        CPY #7
        BNE .FetchNextScoreDigit
.CheckNextHiScore
        LDA hiScorePtrLo
        CLC
        ADC #10
        STA hiScorePtrLo
        DEX
        BPL .CheckForHiScore
        LDA #12
        STA zpTemp
.HiScoreMajorLoop
        LDX #0
.HiScoreOuterLoop
        LDY #0
.HiScoreInnerLoop
        DEY
        BNE .HiScoreInnerLoop
        DEX
        BNE .HiScoreOuterLoop
        DEC zpTemp
        BNE .HiScoreMajorLoop
        JMP .ExitCheckHiScore
.HiScoreFound
        LDA #0
        JSR Game_HiScoreDelay_3E00
        JMP HiScore_EnterName_588E
.ExitCheckHiScore
        LDA #0
        STA SPREN
        JMP Initialise_DisplayTitleScreen_406C

*=$5878
Game_GetScoreDigit_5878
        LDA quasiScore,Y
        ORA #$30
        RTS

*=$587E
Game_SetQuasiXMSB_587E
        LDA quasiX
        CMP #232
        BCS .SetQuasiMSB
        LDA #0
        byte $2C
.SetQuasiMSB
        LDA #1
        ORA quasiXMSB
        RTS


*=$588E
HiScore_EnterName_588E
        LDX #0
.HiScoreClearScreenLoop
        LDA #CHAR_SPACE
        STA SCREENRAM,X
        STA SCREENRAM+$0100,X
        STA SCREENRAM+$0200,X
        STA SCREENRAM+$02F0,X
        LDA #WHITE
        STA COLOURRAM,X
        STA COLOURRAM+$0100,X
        STA COLOURRAM+$0200,X
        STA COLOURRAM+$02F0,X
        INX
        BNE .HiScoreClearScreenLoop
        JSR Initialise_DisplayHiScoreScreen_4103
        LDY #48
.HiScoreSortLoop
        LDA (hiScorePtrLo),Y
        TAX
        TYA
        CLC
        ADC #10
        TAY
        TXA
        STA (hiScorePtrLo),Y
        TYA
        SEC
        SBC #10
        TAY
        DEY
        BPL .HiScoreSortLoop
        LDX #23
.DisplayHiScoreTextLoop
        LDA txt_NameRegistration,X
        STA SCREENRAM+$0288,X
        LDA #RED
        STA COLOURRAM+$0288,X
        LDA txt_LettersTopRow,X
        STA SCREENRAM+$0300,X
        LDA txt_LettersMiddleRow,X
        STA SCREENRAM+$0350,X
        LDA txt_LettersBottomRow,X
        STA SCREENRAM+$03A0,X
        DEX
        BPL .DisplayHiScoreTextLoop
        LDA #0
        STA hiScoreCursorPosition
        STA hiScoreCharCount
.HighlightChar
        LDX hiScoreCursorPosition
        LDY tbl_HiScoreCursorScnPos,X
        LDA #RED
        JSR HiScore_SetCursorPostion_59D7
.GetHiScoreInput
        JSR Input_GetInput_4920
        JSR HiScore_CheckJoyFire_59C5
        BNE HiScore_SelectChar_5945
        JSR HiScore_CheckJoyLeft_59CB
        BNE .MoveCursorLeft
        JSR HiScore_CheckJoyRight_59D1
        BEQ .GetHiScoreInput
        JSR HiScore_ClearPreviousCursor_5939
        LDX hiScoreCursorPosition
        INX
        CPX #30
        BNE .SkipResetCursor
        LDX #0
.SkipResetCursor
        STX hiScoreCursorPosition
        LDX #1
.HiScoreCursorOuterLoop
        LDY #0
.HiScoreCursorInnerLoop
        DEY
        BNE .HiScoreCursorInnerLoop
        DEX
        BNE .HiScoreCursorOuterLoop
        JMP .HighlightChar
.MoveCursorLeft
        JSR HiScore_ClearPreviousCursor_5939
        LDX hiScoreCursorPosition
        DEX
        BPL .SetCursor
        LDX #29
.SetCursor
        JMP .SkipResetCursor


*=$5939
HiScore_ClearPreviousCursor_5939
        LDX hiScoreCursorPosition
        LDY tbl_HiScoreCursorScnPos,X
        LDA #WHITE
        STA COLOURRAM+$0300,Y
        RTS


*=$5945
HiScore_SelectChar_5945
        LDX hiScoreCursorPosition
        CPX #19
        BEQ .DeleteChar
        CPX #29
        BNE .SelectChar
        LDY #6
.FetchScoreDigitLoop
        LDA quasiScore,Y
        ORA #48
        STA (hiScorePtrLo),Y
        DEY
        BPL .FetchScoreDigitLoop
        LDY #7
        LDA SCREENRAM+$029C
        STA (hiScorePtrLo),Y
        INY
        LDA SCREENRAM+$029D
        STA (hiScorePtrLo),Y
        INY
        LDA SCREENRAM+$029E
        STA (hiScorePtrLo),Y
        JSR Initialise_DisplayHiScoreScreen_4103
        LDX #24
.SelectCharMajorLoop
        TXA
        LDX #0
.SelectCharOuterLoop
        LDY #0
.SelectCharInnerLoop
        DEY
        BNE .SelectCharInnerLoop
        DEX
        BNE .SelectCharOuterLoop
        TAX
        DEX
        BNE .SelectCharMajorLoop
        JMP Initialise_DisplayTitleScreen_406C
.DeleteChar
        LDX hiScoreCharCount
        LDA #CHAR_SPACE
        STA SCREENRAM+$029C,X
        CPX #0
        BEQ .AtFirstChar
        DEX
.AtFirstChar
        JMP HiScore_FireDebounce_5B95
.SelectChar
        LDY hiScoreCursorPosition
        LDX hiScoreCharCount
        LDA tbl_HiScoreChars,Y
        STA SCREENRAM+$029C,X
        CPX #2
        BEQ .ReachedCharLimit
        INX
.ReachedCharLimit
        JMP HiScore_FireDebounce_5B95

*=$59AA
Game_QuasiLoseBonus_59AA
        LDA #0
        STA quasiBonus
        STA quasiDirection
        JMP Game_QuasiDeathFall_57E2

*=$59B5
HiScore_FireDebounce_5B95
        STX hiScoreCharCount
.FireDebounceLoop
        JSR Input_GetInput_4920
        LDA inputJoy
        AND #JOY_FIRE
        BNE .FireDebounceLoop
        JMP .HighlightChar

*=$59C5
HiScore_CheckJoyFire_59C5
        LDA inputJoy
        AND #JOY_FIRE
        RTS

*=$59CB
HiScore_CheckJoyLeft_59CB
        LDA inputJoy
        AND #JOY_LEFT 
        RTS

*=$59D1
HiScore_CheckJoyRight_59D1
        LDA inputJoy
        AND #JOY_RIGHT
        RTS

*=$59D7
HiScore_SetCursorPostion_59D7
        STA COLOURRAM+$0300,Y
        LDX #160
.CursorDelayOuterLoop
        LDY #0
.CursorDelayInnerLoop
        DEY
        BNE .CursorDelayInnerLoop
        DEX
        BNE .CursorDelayOuterLoop
        RTS



