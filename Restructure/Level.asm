;-------------------------------------------------------------------------------
; START OF GAME INITIALISATION
;-------------------------------------------------------------------------------
Level_InitialiseGame
        LIBUTILS_DELAY_VVV 22, 0, 0
        jsr Menu_DisplayIntro
        ldx #12
        lda #0
.ResetQuasiStatsLoop
        sta quasiStats,X
        dex
        bpl .ResetQuasiStatsLoop
        lda #16
        sta quasiX
        lda #0
        sta quasiXMSB
        lda #5
        sta quasiLives
        jmp Level_GetReady


;-------------------------------------------------------------------------------
; INITIALISE LEVEL 
;-------------------------------------------------------------------------------
Level_GetReady
        lda SPRCSP
        lda SPRCBG
        lda #FALSE
        sta lifeLost
        jsr Screen_DisplayStats
        jsr Enemy_InitialiseKnight
        jsr Quasi_Animate
        ldx #8
.DisplayGetReadyLoop
        lda SCREENRAM+$0100,X
        sta tmpScreenChars,X
        lda COLOURRAM+$0100,X
        sta tmpScreenColours,X
        lda txt_GetReady,X
        sta SCREENRAM+$0100,X
        lda #WHITE
        sta COLOURRAM+$0100,X
        dex
        bpl .DisplayGetReadyLoop
        LIBUTILS_DELAY_VVV 9, 0, 0
        ldx #8
.ClearGetReadyLoop
        lda #CHAR_SPACE
        lda tmpScreenColours,X
        sta COLOURRAM+$0100,X
        lda tmpScreenChars,X
        sta SCREENRAM+$0100,X
        dex
        bpl .ClearGetReadyLoop
        ldx #16
.InitEnemyLoop
        lda tbl_EnemyInit,x
        sta enemyStats,x
        dex
        bpl .InitEnemyLoop
        sei
        lda #<IRQ_EnemyUpdate
        sta sysIntVectorLo
        lda #>IRQ_EnemyUpdate
        sta sysIntVectorHi
        cli
        ldx currentLevel
        lda tbl_LevelObstacleType,x
        and #254
        beq .GameLoop
        jsr Sound_FireMissile
.GameLoop
        jmp Level_GameLoop


;-------------------------------------------------------------------------------
; MAIN GAME LOOP
;-------------------------------------------------------------------------------
Level_GameLoop
        jsr Player_GetInput
        jsr Quasi_Move
        jsr Quasi_RopeCollisionCheck
        jsr Quasi_RowOfBellsCollisionCheck
        jsr Quasi_Animate
        jsr Quasi_CheckCollision
        LIBUTILS_DELAY_VV 32, 0

        lda lifelost
        beq .CheckEndOfLevel
        jmp Player_LifeLost
.CheckEndOfLevel
        lda quasiXMSB
        beq Level_GameLoop
        lda quasiX
        cmp #30
        bcc Level_GameLoop
        jmp Level_Complete


;-------------------------------------------------------------------------------
; END OF LEVEL ROUTINE
;-------------------------------------------------------------------------------
Level_Complete
        sei
        lda #<krnINTERRUPT 
        sta sysIntVectorLo
        lda #>krnINTERRUPT 
        sta sysIntVectorHi
        cli
        inc quasiBonus
        jsr Screen_DisplayStats
        lda quasiBonus
        cmp #5
        bne .NoBellBonus
.AddNextBellBonus
        ldy #4
.LevelBonusAddScoreLoop
        ldx #3
        jsr Player_UpdateScore
        dey
        bpl .LevelBonusAddScoreLoop
        dec quasiBonus
        jsr Sound_BellBonus
        jsr Screen_DisplayStats
        LIBUTILS_DELAY_VVV 2, 0, 0
        lda quasiBonus
        bne .AddNextBellBonus
.NoBellBonus
        jsr Sound_EndOfLevelBell
        lda SPREN
        and #SPRITE1_MASK_OFF
        sta SPREN
        jsr Player_LevelCompleteScore
        lda quasiScore+2
        beq .NoExtraLife
        lda quasiExtraLifeFlag
        bne .NoExtraLife
        inc quasiExtraLifeFlag
        inc quasiLives
        jsr Screen_DisplayStats
.NoExtraLife
        lda currentLevel
        and #15
        cmp #15
        bne .SelectNextLevel
        jmp Quasi_RescueEsmerelda
.SelectNextLevel
        ldx currentLevel
        inx
        cpx #48
        bne .SkipLevelReset
        ldx #0
.SkipLevelReset
        stx currentLevel
        jsr Screen_BuildScreen
        sei
        lda #<IRQ_LevelTransitionQuasiMove
        sta sysIntVectorLo
        lda #>IRQ_LevelTransitionQuasiMove
        sta sysIntVectorHi
        lda #1
        sta levelTransitionCounter
        cli
        ldx #39
.NewLevelScrollDelayLoop
        stx zpTemp
        jsr Screen_LevelTransitionScroll
        ldx zpTemp
        dex
        bpl .NewLevelScrollDelayLoop
        jmp Level_GetReady


;-------------------------------------------------------------------------------
; DISPLAY HEART ANIM ON ESMERELDA LEVEL 
;-------------------------------------------------------------------------------
Level_DisplayHeart
        lda currentLevel
        and #15
        cmp #15
        beq .DisplayHeart
        rts
.DisplayHeart
        dec heartCounter
        beq .AnimateHeart
        rts
.AnimateHeart
        lda #HEART_ANIM_RATE
        sta heartCounter
        lda SPREN
        ora #SPRITE7_MASK_ON
        sta SPREN
        lda SPRPTR7 
        eor #1
        and #1
        ora #SPRITE_HEART_FRAME1
        sta SPRPTR7
        ldx #7
.FlashCharBlockLoop
        lda chr_Block1,X
        eor chr_Block2,X
        sta chr_Block1,X
        dex
        bpl .FlashCharBlockLoop
        rts


;-------------------------------------------------------------------------------
; ANIMATE ROPE
;-------------------------------------------------------------------------------
Level_UpdateRope
        ldx currentLevel
        lda tbl_LevelObstacleType,X
        and #OBSTACLE_ROPE
        bne .UpdateRope
.ExitUpdateRope
        rts
.UpdateRope
        dec ropeSpeedCounter
        bne .ExitUpdateRope
        lda #ROPE_SPEED
        sta ropeSpeedCounter
        inc ropeFrame
        lda ropeFrame
        and #31
        sta ropeFrame
        tax
        lda tbl_RopeUpperFrame,X
        sta SPRPTR4
        lda tbl_RopeLowerFrame,X
        sta SPRPTR6   
        lda tbl_RopeUpperX,X
        sta SPRX4
        lda #ROPE_UPPER_Y
        sta SPRY4
        lda tbl_RopeLowerX,X
        sta SPRX6
        lda #ROPE_LOWER_Y
        sta SPRY6
        txa
        and #7
        bne .SkipPlayRopeSound
        jsr Sound_Rope
.SkipPlayRopeSound
        lda SPREN
        ora #SPRITE4_MASK_ON + #SPRITE6_MASK_ON
        sta SPREN
        rts

