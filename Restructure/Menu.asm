;-------------------------------------------------------------------------------
; TITLE SCREEN
;-------------------------------------------------------------------------------
Menu_DisplayTitleScreen
        LIBSCREEN_CLEARSCREEN_VV CHAR_SPACE, WHITE
        jsr Menu_DisplayInstructionsText
        sei
        lda #<IRQ_MenuOptionSelect
        sta sysIntVectorLo
        lda #>IRQ_MenuOptionSelect
        sta sysIntVectorHi
        cli
        ldx #0
.DisplayTitleScreenLoop
        lda txt_TitleScreen,X 
        sta SCREENRAM+$00CD,X
        lda txt_TitleScreen+$0100,X
        sta SCREENRAM+$01CD,X
        lda txt_TitleScreen+$014E,X
        sta SCREENRAM+$021B,X
        dex
        bne .DisplayTitleScreenLoop
        ldx #13
.DisplayTitleScreenTextLoop
        lda txt_OceanSoftware,X
        sta SCREENRAM+$0035,X
        lda txt_Presents,X
        sta SCREENRAM+$0085,X
        lda txt_ByJSteele,X
        sta SCREENRAM+$0361,X
        lda #GREEN
        sta COLOURRAM+$0035,X
        sta COLOURRAM+$0361,X
        dex
        bpl .DisplayTitleScreenTextLoop
        lda #17
        sta zpDelayCounter
.TitleFlashLoop
        ldx COLOURRAM+$00CD
        inx
        txa
        and #7
        ldx #0
.SetTitlesColourLoop
        sta COLOURRAM+$021B,X
        sta COLOURRAM+$01CD,X
        sta COLOURRAM+$00CD,X
        inx
        bne .SetTitlesColourLoop
        LIBUTILS_DELAY_VV 0, 0
        dec zpDelayCounter
        bne .TitleFlashLoop
        LIBUTILS_DELAY_VVV 16, 0, 0
        lda #0
        sta hiScoreFlag
        jmp Menu_DisplayHiScores


;-------------------------------------------------------------------------------
; HI-SCORE SCREEN
;-------------------------------------------------------------------------------
Menu_DisplayHiScores
        LIBSCREEN_CLEARSCREEN_VV CHAR_SPACE, WHITE
        ldx #6
.DisplayHiScoresLoop
        lda txt_HiScore,X    
        sta SCREENRAM+$0010,X
        lda tbl_HiScores,X    
        sta SCREENRAM+$0038,X
        lda txt_League,X
        sta SCREENRAM+$0081,X
        lda txt_Order,X
        sta SCREENRAM+$00A9,X
        lda txt_Score,X   
        sta SCREENRAM+$0089,X
        lda txt_Name,X    
        sta SCREENRAM+$0092,X
        lda tbl_HiScores,X    
        sta SCREENRAM+$00D9,X
        lda tbl_HiScores+10,X    
        sta SCREENRAM+$0129,X
        lda tbl_HiScores+20,X  
        sta SCREENRAM+$0179,X
        lda tbl_HiScores+30,X    
        sta SCREENRAM+$01C9,X
        lda tbl_HiScores+40,X    
        sta SCREENRAM+$0219,X
        dex
        bpl .DisplayHiScoresLoop
        ldx #2
.DisplayHiScoreNamesLoop
        lda txt_No,X
        sta SCREENRAM+$00D2,X
        sta SCREENRAM+$0122,X
        sta SCREENRAM+$0172,X
        sta SCREENRAM+$01C2,X
        sta SCREENRAM+$0212,X
        lda tbl_HiScores+7,X    
        sta SCREENRAM+$00E3,X
        lda tbl_HiScores+17,X     
        sta SCREENRAM+$0133,X
        lda tbl_HiScores+27,X    
        sta SCREENRAM+$0183,X
        lda tbl_HiScores+37,X     
        sta SCREENRAM+$01D3,X
        lda tbl_HiScores+47,X    
        sta SCREENRAM+$0223,X
        dex
        bpl .DisplayHiScoreNamesLoop
        lda #<COLOURRAM+$0078
        sta zpColPtrLo
        lda #>COLOURRAM+$0078
        sta zpColPtrHi
        ldx #5
.SetHiScoreColoursRowLoop
        ldy #79
        lda tbl_HiScoreColours,x 
.SetHiScoreColoursCharsLoop
        sta (zpColPtrLo),Y
        dey
        bpl .SetHiScoreColoursCharsLoop
        lda zpColPtrLo
        clc
        adc #80
        sta zpColPtrLo
        bcc .NextHiScore
        inc zpColPtrHi
.NextHiScore
        dex
        bpl .SetHiScoreColoursRowLoop
        ldx #CHAR_1
        stx SCREENRAM+$00D5
        inx
        stx SCREENRAM+$0125
        inx
        stx SCREENRAM+$0175
        inx
        stx SCREENRAM+$01C5
        inx
        stx SCREENRAM+$0215
        ldx #17
.DisplayBonusManTextLoop
        lda txt_BonusMan,X 
        sta SCREENRAM+$028B,X
        lda #RED
        sta COLOURRAM+$028B,X
        dex
        bpl .DisplayBonusManTextLoop
        lda hiScoreFlag
        bne .ExitHiScoreRoutine
        jsr Menu_DisplayInstructionsText
        jmp Menu_DemoMode
.ExitHiScoreRoutine
        rts


;-------------------------------------------------------------------------------
; INSTRUCTION SCREEN
;-------------------------------------------------------------------------------
Menu_DisplayInstructions
        lda #0
        sta SPREN
        sei
        lda #<krnINTERRUPT
        sta sysIntVectorLo
        lda #>krnINTERRUPT
        sta sysIntVectorHi
        cli
        ldx #$F8
        txs
        LIBSCREEN_CLEARSCREEN_VV CHAR_SPACE, WHITE
.InstructionsWaitKey
        lda sysKeyPress
        cmp #KEY_NONE
        bne .InstructionsWaitKey
        ldx #25
.DisplayInstructionsLoop
        lda txt_Instructions,X    
        sta SCREENRAM+$002F,X
        lda txt_Instructions+26,X
        sta SCREENRAM+$00CF,X
        lda txt_Instructions+52,X
        sta SCREENRAM+$0147,X
        lda txt_Instructions+78,X
        sta SCREENRAM+$01BF,X
        lda txt_Instructions+104,X
        sta SCREENRAM+$0237,X
        lda txt_Instructions+130,X
        sta SCREENRAM+$02AF,X
        dex
        bpl .DisplayInstructionsLoop
        ldx #3
.DisplayBellCharsLoop
        lda tbl_BellChars,X
        ldy tbl_BellCharsXOffset,X
        sta SCREENRAM+$01A4,Y
        sta SCREENRAM+$028C,Y
        lda #GRAY2
        sta COLOURRAM+$01A4,Y
        sta COLOURRAM+$028C,Y
        dex
        bpl .DisplayBellCharsLoop
        ldx #33
.DisplayJoyOrKeysLoop
        lda txt_InstructionsJoyKeys,X
        sta SCREENRAM+$00A3,X
        dex
        bpl .DisplayJoyOrKeysLoop
        sei
        lda #<IRQ_MenuOptionSelect
        sta sysIntVectorLo
        lda #>IRQ_MenuOptionSelect
        sta sysIntVectorHi
        cli
        LIBUTILS_DELAY_VVV 31, 0, 0
        jmp Menu_DisplayTitleScreen


;-------------------------------------------------------------------------------
; START DEMO MODE
;-------------------------------------------------------------------------------
Menu_DemoMode
        LIBUTILS_DELAY_VVV 15, 0, 0
        jsr Menu_DisplayIntro
        jsr Screen_DisplayEndOfDemoMode
        jmp Menu_DisplayTitleScreen


;-------------------------------------------------------------------------------
; GAME/DEMO INTRO SEQUENCE
;-------------------------------------------------------------------------------
Menu_DisplayIntro
        ldx #15
        stx currentLevel
        jsr Screen_BuildScreen
        lda #1
        sta introTuneNoteDuration
        lda #0
        sta introTuneNoteIndex
        LIBSCREEN_CLEARSCREEN_VV CHAR_SPACE, WHITE
        jsr Screen_DisplayInitScreen
        lda #0
        sta quasiIntroStage
        lda #1
        sta quasiXMSB 
        sta introCounter
        sta SPREN
        lda #56
        sta quasiX
        sei
        lda #<IRQ_IntroMoveQuasi
        sta sysIntVectorLo
        lda #>IRQ_IntroMoveQuasi        
        sta sysIntVectorHi
        cli
.CheckQuasiIntroStageLoop
        lda quasiIntroStage
        beq .CheckQuasiIntroStageLoop
        jsr Screen_IntroScrollSelect
        lda #2
        sta quasiIntroStage
.DecQuasiXLoop
        lda quasiX
        cmp #17
        bcs .DecQuasiXLoop
        sei
        lda #<krnINTERRUPT
        sta sysIntVectorLo
        lda #>krnINTERRUPT
        sta sysIntVectorHi
        cli
        jsr Quasi_IntroClimbWall
        rts


;-------------------------------------------------------------------------------
; F1 INSTRUCTIONS / SPACE TO START TEXT 
;-------------------------------------------------------------------------------
Menu_DisplayInstructionsText
        ldx #24
.InstructionsOrStartLoop
        lda txt_F1Instructions,X
        sta SCREENRAM+$039F,X  
        lda txt_SpaceToStart,X
        sta SCREENRAM+$03C7,X 
        dex
        bpl .InstructionsOrStartLoop
        rts


;-------------------------------------------------------------------------------
; SELECT INPUT METHOD SCREEN
;-------------------------------------------------------------------------------
Menu_SelectControls
        lda #0
        sta SPREN
        sei
        lda #<krnINTERRUPT
        sta sysIntVectorLo
        lda #>krnINTERRUPT
        sta sysIntVectorHi
        cli
        ldx #$F8  
        txs
        LIBSCREEN_CLEARSCREEN_VV CHAR_SPACE, WHITE
        ldx #7
.DisplayKeyOrJoyTextLoop
        lda txt_KeysOrJoy,X
        sta SCREENRAM+$0088,X
        lda txt_KeysOrJoy+8,X
        sta SCREENRAM+$0100,X
        lda txt_KeysOrJoy+16,X
        sta SCREENRAM+$0150,X
        lda txt_KeysOrJoy+24,X
        sta SCREENRAM+$01A0,X
        dex
        bpl .DisplayKeyOrJoyTextLoop
.GetJoyOrKeyLoop
        jsr krnGETIN
        cmp #KEY_J
        beq .JoystickSelected
        cmp #KEY_K
        bne .GetJoyOrKeyLoop
.JoystickSelected
        sec
        sbc #KEY_J
        sta inputSelect
        cmp #1
        beq .KeyboardSelected
        ldx #23
.DisplayJoyInPort2Loop
        lda txt_JoyInPort2,X
        sta SCREENRAM+$0260,X
        dex
        bpl .DisplayJoyInPort2Loop
        jmp Level_InitialiseGame
.KeyboardSelected
        ldx #17
.DisplayKeyControlsLoop
        lda txt_KeyboardControls,X
        sta SCREENRAM+$0263,X
        lda txt_KeyboardControls+18,X
        sta SCREENRAM+$02DB,X
        lda txt_KeyboardControls+36,X
        sta SCREENRAM+$032B,X
        lda txt_KeyboardControls+54,X
        sta SCREENRAM+$037B,X
        dex
        bpl .DisplayKeyControlsLoop
        jmp Level_InitialiseGame


