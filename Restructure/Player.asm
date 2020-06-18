;-------------------------------------------------------------------------------
; READ KEYBOARD OR JOYSTICK
;-------------------------------------------------------------------------------
Player_GetInput
        lda inputSelect
        bne .CheckKeyboardMatrix
        lda CIAPRA
        eor #%00011111
        and #%00011100
        sta inputJoy
        rts
.CheckKeyboardMatrix
        ldx #7
.GetKeyMatrixColumnLoop
        lda tbl_KeyboardMatrixCol,X
        sta CIAPRA
        lda CIAPRB
        sta inputKeyMatrixCol,X
        dex
        bpl .GetKeyMatrixColumnLoop
        lda #%01111111
        sta CIAPRA
        lda #0
        sta inputJoy
        ldx #2
.KeyboardMatrixLoop
        ldy tbl_KeyMatrixColOffset,X
        lda inputKeyMatrixCol,Y
        and tbl_KeyboardMatrixRow,X
        bne .CheckNextMatrixCol
        lda inputJoy
        ora tbl_KeyToJoyMap,X
        sta inputJoy
.CheckNextMatrixCol
        dex
        bpl .KeyboardMatrixLoop
        rts


;-------------------------------------------------------------------------------
; UPDATE SCORE. X=DIGIT TO UPDATE
;-------------------------------------------------------------------------------
Player_UpdateScore
        inc quasiScore,x
        lda quasiScore,x
        cmp #10
        bne .ExitUpdateScore
        lda #0
        sta quasiScore,x
        dex
        bpl Player_UpdateScore
.ExitUpdateScore
        rts


;-------------------------------------------------------------------------------
; LOSE A LIFE ROUTINE
;-------------------------------------------------------------------------------
Player_LifeLost
        sei
        lda #<krnINTERRUPT
        sta sysIntVectorLo
        lda #>krnINTERRUPT
        sta sysIntVectorHi
        cli
        jsr Quasi_Dying
        lda quasiLives
        bne .QuasiLivesLeft
        jmp Player_GameOver
.QuasiLivesLeft
        lda #16
        sta quasiX
        lda #0
        sta quasiJumpActive
        sta quasiXMSB
        sta quasiBonus
        sta quasiDirection
        lda #1
        sta SPREN
        jsr Screen_CopyGameScreen
        jsr Screen_DisplayStats
        jmp Level_GetReady


;-------------------------------------------------------------------------------
; CALCULATE SCORE FOR COMPLETING LEVEL BASED ON KNIGHT POSITION
;-------------------------------------------------------------------------------
Player_LevelCompleteScore
        lda knightX
        lsr
        lsr
        lsr
        ldx knightXMSB
        beq .SkipMSBOffset
        clc
        adc #32
.SkipMSBOffset
        sta zpScnPtrLo
        lda #>SCREENRAM
        sta zpScnPtrHi
        dec zpScnPtrLo
        dec zpScnPtrLo
        lda knightY
        sec
        sbc #53
        lsr
        lsr
        lsr
        tay
        beq .SetScoreBoxColPtr
.SetScoreBoxScreenPosLoop
        LIBMATHS_ADD16BIT_AV zpScnPtrLo, 40
        dey
        bne .SetScoreBoxScreenPosLoop
.SetScoreBoxColPtr
        lda zpScnPtrLo
        sta zpColPtrLo
        lda zpScnPtrHi
        clc
        adc #100
        sta zpColPtrHi
        ldx #27
.DisplayScoreBoxLoop
        ldy tbl_ScoreBoxCharX,X
        lda tbl_ScoreBoxChars,X
        sta (zpScnPtrLo),Y
        lda tbl_ScoreBoxCharColours,X
        sta (zpColPtrLo),Y
        dex
        bpl .DisplayScoreBoxLoop
        ldx #1
.FindMultiplierLoop
        lda knightCounter
        cmp tbl_ScoreMultiplier,X
        bcs .MultiplierSelected
        inx
        jmp .FindMultiplierLoop
.MultiplierSelected
        stx scoreMultiplier
        lda #0
        sta scoreTemp
        sta scoreTemp+1
        ldx currentLevel
.AddScoreMultiplierLoop
        sed
        lda scoreTemp+1
        clc
        adc scoreMultiplier
        sta scoreTemp+1
        lda scoreTemp
        adc #0
        sta scoreTemp
        cld
        dex
        bpl .AddScoreMultiplierLoop
        ldy #81
        lda scoreTemp
        and #15
        ora #48
        sta (zpScnPtrLo),Y
        iny
        lda scoreTemp+1
        pha
        lsr
        lsr
        lsr
        lsr
        ora #48
        sta (zpScnPtrLo),Y
        iny
        pla
        and #15
        ora #48
        sta (zpScnPtrLo),Y
        lda scoreTemp
        and #15
        tay
        beq .SkipZeroScore
.ScoreDigit1Loop
        ldx #2
        jsr Player_UpdateScore
        dey
        bne .ScoreDigit1Loop
.SkipZeroScore
        lda scoreTemp+1
        lsr
        lsr
        lsr
        lsr
        tay
        beq .SkipZeroScore2
.ScoreDigit2Loop
        ldx #3
        jsr Player_UpdateScore
        dey
        bne .ScoreDigit2Loop
.SkipZeroScore2
        lda scoreTemp+1
        and #15
        tay
        beq .SkipZeroScore3
.ScoreDigit3Loop
        ldx #4
        jsr Player_UpdateScore
        dey
        bne .ScoreDigit3Loop
.SkipZeroScore3
        jsr Screen_DisplayStats
        LIBUTILS_DELAY_VVV 8, 0, 0
        lda #SPRITE0_MASK_ON
        sta SPREN
        rts


;-------------------------------------------------------------------------------
; GAME OVER SEQUENCE
;-------------------------------------------------------------------------------
Player_GameOver
        ldx #8
.DisplayGameOverLoop
        lda txt_GameOver,X
        sta SCREENRAM+$0100,X
        lda #WHITE
        sta COLOURRAM+$0100,X
        dex
        bpl .DisplayGameOverLoop
        lda #>tbl_HiScores
        sta hiScorePtrHi
        lda #<tbl_HiScores
        sta hiScorePtrLo
        ldx #4
.CheckForHiScore
        ldy #0
.FetchNextScoreDigit
        lda quasiScore,Y
        ora #48
        cmp (hiScorePtrLo),Y
        beq .CheckNextScoreDigit    
        bcs .HiScoreFound
        bcc .CheckNextHiScore
.CheckNextScoreDigit
        iny
        cpy #7
        bne .FetchNextScoreDigit
.CheckNextHiScore
        lda hiScorePtrLo
        clc
        adc #10
        sta hiScorePtrLo
        dex
        bpl .CheckForHiScore
        LIBUTILS_DELAY_VVV 12, 0, 0
        jmp .ExitCheckHiScore
.HiScoreFound
        LIBUTILS_DELAY_VVV 12, 0, 0
        lda #0
        sta SPREN
        jmp Player_EnterHiScoreName
.ExitCheckHiScore
        lda #0
        sta SPREN
        jmp Menu_DisplayTitleScreen


;-------------------------------------------------------------------------------
; HI-SCORE ROUTINE
;-------------------------------------------------------------------------------
Player_EnterHiScoreName
        inc hiScoreFlag
        jsr Menu_DisplayHiScores
        ldy #48
.HiScoreSortLoop
        lda (hiScorePtrLo),Y
        tax
        tya
        clc
        adc #10
        tay
        txa
        sta (hiScorePtrLo),Y
        tya
        sec
        sbc #10
        tay
        dey
        bpl .HiScoreSortLoop
        ldx #23
.DisplayHiScoreTextLoop
        lda txt_NameRegistration,X
        sta SCREENRAM+$0288,X
        lda #RED
        sta COLOURRAM+$0288,X
        lda txt_LettersTopRow,X
        sta SCREENRAM+$0300,X
        lda txt_LettersMiddleRow,X
        sta SCREENRAM+$0350,X
        lda txt_LettersBottomRow,X
        sta SCREENRAM+$03A0,X
        dex
        bpl .DisplayHiScoreTextLoop
        lda #0
        sta hiScoreCursorPosition
        sta hiScoreCharCount
.HighlightChar
        ldx hiScoreCursorPosition
        ldy tbl_HiScoreCursorScnPos,X
        lda #RED
        sta COLOURRAM+$0300,Y
        LIBUTILS_DELAY_VV 160, 0
.GetHiScoreInput
        jsr Player_GetInput
        lda inputJoy
        and #JOY_FIRE
        bne .SelectChar
        lda inputJoy
        and #JOY_LEFT 
        bne .MoveCursorLeft
        lda inputJoy
        and #JOY_RIGHT
        beq .GetHiScoreInput
        ldx hiScoreCursorPosition
        ldy tbl_HiScoreCursorScnPos,X
        lda #WHITE
        sta COLOURRAM+$0300,Y
        ldx hiScoreCursorPosition
        inx
        cpx #30
        bne .SkipResetCursor
        ldx #0
.SkipResetCursor
        stx hiScoreCursorPosition
        LIBUTILS_DELAY_VV 1, 0
        jmp .HighlightChar
.MoveCursorLeft
        ldx hiScoreCursorPosition
        ldy tbl_HiScoreCursorScnPos,X
        lda #WHITE
        sta COLOURRAM+$0300,Y
        ldx hiScoreCursorPosition
        dex
        bpl .SetCursor
        ldx #29
.SetCursor
        jmp .SkipResetCursor
.SelectChar
        ldx hiScoreCursorPosition
        cpx #19
        beq .DeleteChar
        cpx #29
        bne .SelectChar2
        ldy #6
.FetchScoreDigitLoop
        lda quasiScore,Y
        ora #48
        sta (hiScorePtrLo),Y
        dey
        bpl .FetchScoreDigitLoop
        ldy #7
        lda SCREENRAM+$029C
        sta (hiScorePtrLo),Y
        iny
        lda SCREENRAM+$029D
        sta (hiScorePtrLo),Y
        iny
        lda SCREENRAM+$029E
        sta (hiScorePtrLo),Y
        jsr Menu_DisplayHiScores
        LIBUTILS_DELAY_VVV 24, 0, 0
        jmp Menu_DisplayTitleScreen
.DeleteChar
        ldx hiScoreCharCount
        lda #CHAR_SPACE
        sta SCREENRAM+$029C,X
        cpx #0
        beq .AtFirstChar
        dex
.AtFirstChar
        jmp .HiScoreFireDebounce
.SelectChar2
        ldy hiScoreCursorPosition
        ldx hiScoreCharCount
        lda tbl_HiScoreChars,Y
        sta SCREENRAM+$029C,X
        cpx #2
        beq .HiScoreFireDebounce
        inx
.HiScoreFireDebounce
        stx hiScoreCharCount
.FireDebounceLoop
        jsr Player_GetInput
        lda inputJoy
        and #JOY_FIRE
        bne .FireDebounceLoop
        jmp .HighlightChar


