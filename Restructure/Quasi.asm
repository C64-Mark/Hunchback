;-------------------------------------------------------------------------------
; MOVE QUASI FOR INTRO SEQUENCE
;-------------------------------------------------------------------------------
Quasi_IntroMovement
        ldx quasiJumpFrameCounter
        lda #216
        sec
        sbc tbl_QuasiJumpYOffset,X
        sta SPRY0
        lda tbl_QuasiLeftJumpFrame,X
        sta SPRPTR0
        lda quasiIntroStage
        cmp #1
        beq .IntroStage1
        LIBMATHS_SUBTRACT16BIT_AV quasiX, 2
        lda quasiIntroStage
        bne .UpdateQuasiIntroSprite
        lda quasiXMSB
        bne .UpdateQuasiIntroSprite
        lda quasiX 
        cmp #144
        bne .UpdateQuasiIntroSprite
        inc quasiIntroStage
.UpdateQuasiIntroSprite
        lda quasiX
        clc
        adc #24
        sta SPRX0
        lda quasiXMSB
        adc #0
        sta SPRXMSB
.IntroStage1
        ldx quasiJumpFrameCounter
        inx
        txa
        and #15
        sta quasiJumpFrameCounter
        rts


;-------------------------------------------------------------------------------
; QUASI WALL CLIMB INTRO SEQUENCE
;-------------------------------------------------------------------------------
Quasi_IntroClimbWall
        dec SPRY0
        LIBUTILS_DELAY_VV 8, 0
        lda SPRY0
        cmp #117
        bne Quasi_IntroClimbWall
        rts


;-------------------------------------------------------------------------------
; QUASI INTRO SEQUENCE WALKING RIGHT
;-------------------------------------------------------------------------------
Quasi_IntroMovementRight
        LIBMATHS_ADD16BIT_AV quasiX, 2
        lda quasiX 
        clc
        adc #24
        sta SPRX0
        lda quasiXMSB
        adc #0
        sta SPRXMSB
        lda quasiX 
        lsr
        and #3
        tax
        lda tbl_QuasiWalkRightFrame,X
        sta SPRPTR0
        LIBUTILS_DELAY_VV 48, 0
        lda quasiXMSB
        beq Quasi_IntroMovementRight
        lda quasiX 
        cmp #32
        bcc Quasi_IntroMovementRight
        rts


;-------------------------------------------------------------------------------
; QUASI INTRO SEQUENCE THE BELLS JUMPING LEFT
;-------------------------------------------------------------------------------
Quasi_IntroJumpLeft
        lda #0
        sta quasiJumpFrameCounter
.NextJumpFrame
        ldx quasiJumpFrameCounter
        lda #117
        sec
        sbc tbl_QuasiJumpYOffset,X
        sta SPRY0
        lda tbl_QuasiLeftJumpFrame,X
        sta SPRPTR0
        LIBMATHS_SUBTRACT16BIT_AV quasiX, 2
        lda quasiXMSB
        bne .TheBellsFinished
        jsr Screen_DisplayTheBells
.TheBellsFinished
        lda quasiX
        clc
        adc #24
        sta SPRX0
        lda quasiXMSB
        adc #0
        sta SPRXMSB
        ldx quasiJumpFrameCounter
        inx
        txa
        and #15
        sta quasiJumpFrameCounter
        LIBUTILS_DELAY_VV 32, 0
        lda quasiXMSB
        bne .NextJumpFrame
        lda quasiX
        cmp #4
        bcs .NextJumpFrame
        rts


;-------------------------------------------------------------------------------
; ANIMATE QUASI
;-------------------------------------------------------------------------------
Quasi_Animate
        lda quasiX
        clc
        adc #24
        sta SPRX0
        lda quasiXMSB
        adc #0
        tax
        lda SPRXMSB
        and #SPRITE0_MASK_OFF
        cpx #0
        beq .ClearQuasiXMSB
        ora #SPRITE0_MASK_ON
.ClearQuasiXMSB 
        sta SPRXMSB
        lda #117
        ldx quasiJumpActive
        bne .QuasiJumping
        sta SPRY0
        lda quasiX
        lsr
        and #3
        ldx quasiDirection
        beq .WalkingRight
        clc
        adc #4
.WalkingRight
        tax
        lda tbl_QuasiWalkFrame,X
        pha
        lda QuasiOnRopeFlag
        ora QuasiOnBellFlag
        tay
        pla
        cpy #0
        beq .SetQuasiFrame
        lda #SPRITE_QUASI_SWING_RIGHT_FRAME
        ldy quasiDirection
        beq .SetQuasiFrame
        lda #SPRITE_QUASI_SWING_LEFT_FRAME
.SetQuasiFrame
        sta SPRPTR0
        rts
.QuasiJumping
        ldx quasiJumpFrameCounter
        sec
        sbc tbl_QuasiJumpYOffset,X
        sta SPRY0
        lda quasiJumpFrameCounter
        ldx quasiDirection
        beq .QuasiJumpRight
        clc
        adc #16
.QuasiJumpRight
        tax
        lda tbl_QuasiJumpFrames,X
        sta SPRPTR0
        inc quasiJumpFrameCounter
        lda quasiJumpFrameCounter
        cmp #16
        bne .ExitAnimateQuasi
        lda #0
        sta quasiJumpActive
.ExitAnimateQuasi
        rts 


;-------------------------------------------------------------------------------
; MOVE QUASI BASED ON PLAYER INPUT
;-------------------------------------------------------------------------------
Quasi_Move
        lda inputJoy
        and #JOY_FIRE
        beq .TestJoyRight
        lda quasiJumpActive
        bne .TestJoyRight
        ldx #1
        stx quasiJumpActive
        dex
        stx quasiJumpFrameCounter
        jsr Sound_QuasiJump
.TestJoyRight
        lda inputJoy
        and #JOY_RIGHT
        beq .TestJoyLeft
        LIBMATHS_ADD16BIT_AV quasiX, 2
        lda #QUASI_DIR_RIGHT
        sta quasiDirection
.TestJoyLeft
        lda inputJoy
        and #JOY_LEFT 
        beq .ExitQuasiMove
        lda quasiXMSB
        bne .QuasiMoveLeft
        lda quasiX
        cmp #18
        bcc .ExitQuasiMove
.QuasiMoveLeft
        LIBMATHS_SUBTRACT16BIT_AV quasiX, 2
        lda #QUASI_DIR_LEFT
        sta quasiDirection
.ExitQuasiMove
        rts


;-------------------------------------------------------------------------------
; CHECK QUASI COLLISION WITH ROPE
;-------------------------------------------------------------------------------
Quasi_RopeCollisionCheck
        ldx currentLevel
        lda tbl_LevelObstacleType,x
        and #OBSTACLE_ROPE
        beq .QuasiNotOnRope
.CheckQuasiRopeCollision
        lda quasiXMSB
        bne .QuasiNotOnRope
        lda quasiX
        cmp #88
        bcc .QuasiNotOnRope
        cmp #224
        bcs .QuasiNotOnRope
        lda SPRCSP
        and #SPRITE0_MASK_ON + #SPRITE6_MASK_ON
        cmp #SPRITE0_MASK_ON + #SPRITE6_MASK_ON
        bne .CheckIfAlreadyOnRope
        jmp .QuasiOnRope
.CheckIfAlreadyOnRope
        lda quasiOnRopeFlag
        cmp #FAlSE
        beq .QuasiNotOnRope
.QuasiOnRope
        lda quasiJumpActive
        bne .QuasiNotOnRope
        ldx #0
        stx quasiXMSB
        inx
        stx QuasiOnRopeFlag
        ldx ropeFrame
        lda tbl_QuasiRopeXPosition,X
        sta quasiX
        jmp .ExitRopeCollisionCheck
.QuasiNotOnRope
        lda #FALSE
        sta QuasiOnRopeFlag
.ExitRopeCollisionCheck
        rts
        

;-------------------------------------------------------------------------------
; CHECK QUASI COLLISION WITH ROW OF BELLS
;-------------------------------------------------------------------------------
Quasi_RowOfBellsCollisionCheck
        ldx currentLevel
        lda tbl_LevelType,X
        and #LEVEL_ROWOFBELLS
        beq .QuasiNotOnBell
        lda SPRCBG
        and #SPRITE0_MASK_ON
        beq .QuasiNotOnBell
        lda quasiXMSB
        ora quasiJumpActive
        bne .QuasiNotOnBell
        lda quasiOnBellFlag
        bne .SelectBell
        lda quasiX
        cmp #88
        bcc .QuasiNotOnBell
        cmp #224
        bcs .QuasiNotOnBell
        lda #1
        sta quasiOnBellFlag
        jsr Sound_RowOfBells
.SelectBell
        ldx #0
.SelectBellLoop
        lda tbl_RowOfBellsXPosition,X
        cmp quasiX
        bcs .BellFound
        inx
        jmp .SelectBellLoop
.BellFound
        lda tbl_QuasiBellXPosition,X
        sta quasiX
        jmp .ExitRowOfBellsCollisionCheck
.QuasiNotOnBell
        lda #0
        sta quasiOnBellFlag
.ExitRowOfBellsCollisionCheck
        rts


;-------------------------------------------------------------------------------
; QUASI / ENEMY COLLISION DETECTION
;-------------------------------------------------------------------------------
Quasi_CheckCollision
        ldx currentLevel
        lda tbl_LevelType,X
        and #LEVEL_ROWOFBELLS
        bne .CheckBellPitFall
        lda tbl_LevelType,X
        and #LEVEL_ROPEPIT
        bne .CheckRopePitFall
        LDA tbl_LevelType,X
        AND #LEVEL_KNIGHTPIT + #LEVEL_EMPTYPIT
        beq .CheckCollision
        jmp .CheckPitFall
.CheckCollision
        lda SPRCSP
        and #SPRITE0_MASK_ON
        beq .CheckSpriteBackgroundCollision
.QuasiLifeLost
        lda #TRUE
        sta lifeLost
        rts
.CheckSpriteBackgroundCollision
        ldy #1
        lda quasiX
        cmp #232
        bcs .CheckQuasiXMSB
        dey
.CheckQuasiXMSB
        tya
        ora quasiXMSB
        bne .CheckForKnightCollision
        lda SPRCBG
        and #SPRITE0_MASK_ON
        bne .QuasiLifeLost
.CheckForKnightCollision
        lda knightY
        cmp #117
        bne .ExitCheckCollision
        lda knightX
        sec
        sbc quasiX
        lda knightXMSB
        sbc quasiXMSB
        bcs .QuasiLifeLost
.ExitCheckCollision
        rts
.CheckBellPitFall
        lda quasiJumpActive
        bne .CheckBellRopeCollision
        lda quasiXMSB
        bne .ExitCheckCollision
        lda quasiOnBellFlag
        bne .ExitCheckCollision
        lda quasiX
        cmp #80
        bcc .ExitCheckCollision
        cmp #219
        bcs .ExitCheckCollision
        ldx #3
.TestNextBellRopeLoop
        lda quasiX
        sec
        sbc tbl_BellRopeXOffset,X
        cmp #11
        bcc .ExitCheckCollision
        dex
        bpl .TestNextBellRopeLoop
        jmp .QuasiLifeLost
.CheckBellRopeCollision
        lda SPRCSP
        and #1
        bne .QuasiLifeLost
        jmp .CheckForKnightCollision
.CheckRopePitFall
        lda quasiJumpActive
        bne .CheckForKnightCollision
        lda quasiOnRopeFlag
        bne .CheckForKnightCollision
        lda quasiXMSB
        bne .CheckForKnightCollision
        lda quasiX
        cmp #80
        bcc .CheckForKnightCollision
        cmp #219
        bcs .CheckForKnightCollision
        ldx ropeFrame
        lda quasiX
        sec
        sbc tbl_RopeXPositions,X
        cmp #21
        bcc .CheckForKnightCollision
        jmp .QuasiLifeLost
.CheckPitFall
        lda quasiXMSB
        bne .NoPitFall
        lda quasiJumpActive
        bne .NoPitFall
        ldx #2
.CheckPitLoop
        lda quasiX
        cmp tbl_PitLocationStartX,X
        bcc .PitClear
        cmp tbl_PitLocationEndX,X
        bcs .PitClear
        jmp .QuasiLifeLost
.PitClear
        dex
        bpl .CheckPitLoop
.NoPitFall
        jmp .CheckCollision


;-------------------------------------------------------------------------------
; ANIMATE QUASI DURING LEVEL TRANSITION
;-------------------------------------------------------------------------------
Quasi_LevelTransitionMove
        lda #2
        sta levelTransitionCounter
        LIBMATHS_SUBTRACT16BIT_AV quasiX, 2
        jsr Quasi_Animate
        lda quasiXMSB
        bne .ExitLevelTransitionMove
        lda quasiX
        cmp #18
        bcs .ExitLevelTransitionMove
        sei
        lda #<krnINTERRUPT
        sta sysIntVectorLo
        lda #>krnINTERRUPT
        sta sysIntVectorHi
        cli
.ExitLevelTransitionMove
        rts


;-------------------------------------------------------------------------------
; QUASI DYING ROUTINE
;-------------------------------------------------------------------------------
Quasi_Dying
        jsr Sound_QuasiDying
.QuasiStillFalling
        inc SPRY0
        LIBUTILS_DELAY_VV 2,0 
        lda SPRY0
        cmp #255
        bne .QuasiStillFalling
        dec quasiLives
        jsr Screen_DisplayStats
        sei
        lda #1
        sta colourFlashCounter
        lda #<IRQ_FlashBackground
        sta sysIntVectorLo
        lda #>IRQ_FlashBackground
        sta sysIntVectorHi
        cli 
        jsr Sound_QuasiDead
        sei
        lda #<krnINTERRUPT
        sta sysIntVectorLo
        lda #>krnINTERRUPT
        sta sysIntVectorHi
        cli 
        lda #GRAY1
        sta BGCOL1
        lda #0
        sta SPREN
        rts


;-------------------------------------------------------------------------------
; QUASI RESCUE ESMERELDA SEQUENCE
;-------------------------------------------------------------------------------
Quasi_RescueEsmerelda
        lda #170
        sta SPRX0
        lda #152
        sta SPRY0
        lda #0
        sta SPRXMSB
        lda #SPRITE_QUASI_WALK_RIGHT_FRAME2
        sta SPRPTR0
        ldx #0
.EndGameClearScreenLoop
        lda #CHAR_SPACE
        sta SCREENRAM,X
        sta SCREENRAM+$0100,X
        sta SCREENRAM+$0200,X
        sta SCREENRAM+$02F0,X
        inx
        bne .EndGameClearScreenLoop
        ldx #7
.DisplayMyHeroLoop
        lda txt_MyHero,X
        sta SCREENRAM+$01A0,X
        lda #CYAN
        sta COLOURRAM+$01A0,X
        dex
        bpl .DisplayMyHeroLoop
        ldx #14
.SetHeartsXYLoop
        lda tbl_HeartSpritesXY,X 
        sta SPRX1,X
        dex
        bpl .SetHeartsXYLoop
        ldx #6
.SetHeartFrameAndColourLoop
        lda #RED
        sta SPRCOL1,X
        lda #SPRITE_HEART_FRAME1
        sta SPRPTR1,X
        dex
        bpl .SetHeartFrameAndColourLoop
        lda #1
        sta SPRMCS
        lda #0
        sta SPRYEX
        sta SPRXEX
        lda #255
        sta SPREN
        lda #27
        sta heartCounter
.NextHeartAnimFrame
        lda heartCounter
        and #3
        tax
        lda tbl_HeartAnimFrames,X
        ldx #6
.UpdateHeartFrameLoop
        sta SPRPTR1,X
        dex
        bpl .UpdateHeartFrameLoop
        LIBUTILS_DELAY_VVV 1, 0, 0
        dec heartCounter
        bne .NextHeartAnimFrame
        ldx #6
.SetHeartFrameLoop
        lda #SPRITE_HEART_FRAME1
        sta SPRPTR1,X
        dex
        bpl .SetHeartFrameLoop
        ldx #2
        jsr Player_UpdateScore
        ldx #2
        jsr Player_UpdateScore
        ldx currentLevel
        inx
        cpx #48
        bne .SkipResetLevel
        ldx #0
.SkipResetLevel
        stx currentLevel
        LIBUTILS_DELAY_VVV 12, 0, 0
        lda #GREEN
        sta SPRCOL0
        lda #PURPLE
        sta SPRCOL2
        sta SPRCOL3
        lda #RED
        sta SPRCOL7
        lda #240
        sta SPRX7
        lda #74
        sta SPRY7
        lda #WHITE
        sta SPRCOL4
        sta SPRCOL6
        lda #15
        sta SPRMCS
        lda #SPRITE4_MASK_ON + #SPRITE6_MASK_ON
        sta SPRXEX
        sta SPRYEX
        jmp .QuasiLivesLeft

