;-------------------------------------------------------------------------------
; INITIALISE THE CLIMBING WALL KNIGHT
;-------------------------------------------------------------------------------
Enemy_InitialiseKnight
        lda #197
        sta knightY
        lda #16
        sta knightX
        sta knightMoveRate
        lda #$FF
        sta knightCounter
        lda #SPRITE_KNIGHT_CLIMB_FRAME1
        sta knightFrame
        lda #0
        sta knightXMSB
        jmp Enemy_AnimateKnight


;-------------------------------------------------------------------------------
; MOVE THE CLIMBING WALL KNIGHT
;-------------------------------------------------------------------------------
Enemy_MoveKnight
        dec knightMoveRate
        beq .MoveKnight
        rts
.MoveKnight
        lda currentLevel
        lsr
        lsr
        lsr
        lsr
        tax
        lda tbl_KnightMoveRates,X
        sta knightMoveRate
        lda knightY
        cmp #117
        beq .MoveKnightX
        lda knightFrame
        eor #1
        sta knightFrame
        and #1
        bne .UpdateKnight
        lda knightY
        sec
        sbc #8
        sta knightY
.UpdateKnight
        jsr Enemy_AnimateKnight
        rts
.MoveKnightX
        lda knightFrame
        ora #64
        and #65
        eor #1
        sta knightFrame
        and #1
        bne .UpdateKnight
        LIBMATHS_ADD16BIT_AV knightX, 8
        jmp .UpdateKnight


;-------------------------------------------------------------------------------
; ANIMATE THE CLIMBING WALL KNIGHT
;-------------------------------------------------------------------------------
Enemy_AnimateKnight
        inc knightCounter
        lda knightFrame
        sta SPRPTR1
        lda #GRAY1
        sta SPRCOL1
        lda knightY
        sta SPRY1
        lda knightX
        clc
        adc #24
        sta SPRX1
        lda knightXMSB
        adc #0
        tax
        lda SPRXMSB
        and #SPRITE1_MASK_OFF
        cpx #0
        beq .ClearKnightXMSB
        ora #SPRITE1_MASK_ON
.ClearKnightXMSB
        sta SPRXMSB
        lda SPREN
        ora #SPRITE1_MASK_ON
        sta SPREN
        lda knightY
        cmp #117
        beq .DrawKnightBridge
        rts
.DrawKnightBridge
        lda knightX
        lsr
        lsr
        lsr
        clc
        adc #63
        ldx knightXMSB
        beq .KnightMSBNotSet
        clc
        adc #32
.KnightMSBNotSet
        sta zpScnPtrLo
        sta zpColPtrLo
        lda #>SCREENRAM+$0100
        sta zpScnPtrHi
        lda #>COLOURRAM+$0100
        sta zpColPtrHi
        ldx #11
.DrawKnightBridgeLoop
        lda tbl_BridgeChars,X
        ldy tbl_BridgeCharsXOffset,X
        sta (zpScnPtrLo),Y
        lda COLOURRAM+$022F
        sta (zpColPtrLo),Y
        dex
        bpl .DrawKnightBridgeLoop
        rts


;-------------------------------------------------------------------------------
; SELECT LEVEL OBSTACLE TYPE
;-------------------------------------------------------------------------------
Enemy_Select
        ldx currentLevel
        lda tbl_LevelType,x
        and #LEVEL_KNIGHTPIT
        beq .FireballHiFront
        jsr Enemy_AnimatePitKnights
.FireballHiFront
        ldx currentLevel
        lda tbl_LevelObstacleType,x
        and #OBSTACLE_FIREBALL_HI_FRONT
        beq .ArrowLoRear
        jsr Enemy_FireballHiFront
.ArrowLoRear
        ldx currentLevel
        lda tbl_LevelObstacleType,x
        and #OBSTACLE_ARROW_LO_REAR
        beq .FireballLoFront
        jsr Enemy_ArrowLoRear
.FireballLoFront
        ldx currentLevel
        lda tbl_LevelObstacleType,x
        and #OBSTACLE_FIREBALL_LO_FRONT
        beq .DuoArrowHiLoFront
        jsr Enemy_FireballLoFront
.DuoArrowHiLoFront
        ldx currentLevel
        lda tbl_LevelObstacleType,x
        and #OBSTACLE_DUO_ARROW_HILO_FRONT 
        beq .DuoArrowHiLoRear
        jsr Enemy_DuoArrowHiLoFront
.DuoArrowHiLoRear
        ldx currentLevel
        lda tbl_LevelObstacleType,x
        and #OBSTACLE_DUO_ARROW_HILO_REAR
        beq .DuoFireballLoBoth
        jsr Enemy_DuoArrowHiLoRear
.DuoFireballLoBoth
        ldx currentLevel
        lda tbl_LevelObstacleType,x
        and #OBSTACLE_DUO_FIREBALL_LO_BOTH
        beq .DuoArrowHiLoBoth
        jsr Enemy_DuoFireballLoBoth
.DuoArrowHiLoBoth
        ldx currentLevel
        lda tbl_LevelObstacleType,x
        and #OBSTACLE_DUO_ARROW_HILO_BOTH
        beq .ExitEnemySelect
        jsr Enemy_DuoArrowHiLoBoth
.ExitEnemySelect
        rts


;-------------------------------------------------------------------------------
; ANIMATION SEQUENCE FOR 3 KNIGHTS IN PITS
;-------------------------------------------------------------------------------
Enemy_AnimatePitKnights
        ldx #<SCREENRAM+$014A
        ldy #>SCREENRAM+$014A
        stx zpScnPtrLo
        sty zpScnPtrHi
        ldx #<COLOURRAM+$014A
        ldy #>COLOURRAM+$014A
        stx zpColPtrLo
        sty zpColPtrHi
        ldx #0
        stx pitKnight
.AnimatePitKnightLoop
        ldx pitKnight
        ldy #119
        lda (zpScnPtrLo),y
        cmp #CHAR_WALL
        beq .NextPit
        dec pitKnight1Counter,x
        bne .NextPit
        ldy #10
        lda pitKnight1Frame,x
        cmp #3
        bne .AnimatePitKnight1
        ldy #128
.AnimatePitKnight1
        sty pitKnight1Counter,x
        tay
        iny
        tya
        and #3
        sta pitKnight1Frame,x
        beq .PitKnight1Frame1Chars
        cmp #2
        beq .PitKnight1Frame3Chars
        ldx #20
.Pit1Frame2Loop
        ldy tbl_PitCharsX,X
        lda tbl_PitKnightFrame2,X
        sta (zpScnPtrLo),Y
        lda #LIGHTRED
        sta (zpColPtrLo),Y
        dex
        bpl .Pit1Frame2Loop
.Pit1AnimateEnd
        lda #GRAY1
        ldy #121
        sta (zpColPtrLo),y
        jmp .NextPit
.PitKnight1Frame3Chars
        ldx #20
.Pit1Frame3Loop
        ldy tbl_PitCharsX,X
        lda tbl_PitKnightFrame3,X
        sta (zpScnPtrLo),Y
        lda #LIGHTRED
        sta (zpColPtrLo),Y
        dex
        bpl .Pit1Frame3Loop
        bmi .Pit1AnimateEnd
.PitKnight1Frame1Chars
        ldx #20
.Pit1Frame1Loop
        ldy tbl_PitCharsX,X
        lda tbl_PitKnightFrame1,X
        sta (zpScnPtrLo),Y
        lda #LIGHTRED
        sta (zpColPtrLo),Y
        dex
        bpl .Pit1Frame1Loop
        bmi .Pit1AnimateEnd
.NextPit
        ldx pitKnight
        inx
        cpx #3
        beq .ExitAnimatePitKnights
        stx pitKnight
        LIBMATHS_ADD16BIT_AV zpScnPtrLo, 9
        LIBMATHS_ADD16BIT_AV zpColPtrLo, 9
        jmp .AnimatePitKnightLoop
.ExitAnimatePitKnights
        rts


;-------------------------------------------------------------------------------
; HIGH FIREBALL RIGHT TO LEFT
;-------------------------------------------------------------------------------
Enemy_FireballHiFront
        LIBMATHS_SUBTRACT16BIT_AV missileX, 2
        lda #MISSILE_HIGH_Y
        sta missileY
        jsr Enemy_UpdateMissile
        lda missileX
        lsr
        lsr
        and #3
        clc
        adc #SPRITE_FIREBALL_FRAME1
        sta SPRPTR2
        lda missileXMSB
        ora missileX
        bne .ExitFireballHiFront
        jsr Sound_FireMissile
        lda #1
        sta missileXMSB
        lda #88
        sta missileX
.ExitFireballHiFront
        rts


;-------------------------------------------------------------------------------
; UPDATE MISSILE SPRITE
;-------------------------------------------------------------------------------
Enemy_UpdateMissile
        lda missileY
        sta SPRY2
        lda missileX
        sta SPRX2
        lda SPRXMSB
        and #SPRITE2_MASK_OFF
        ldx missileXMSB
        beq .ClearMissileMSB
        ora #SPRITE2_MASK_ON
.ClearMissileMSB
        sta SPRXMSB
        lda SPREN
        ora #SPRITE2_MASK_ON
        sta SPREN
        rts


;-------------------------------------------------------------------------------
; UPDATE MISSILE SPRITE 2
;-------------------------------------------------------------------------------
Enemy_UpdateMissile2
        lda missile2Y
        sta SPRY3
        lda missile2X
        sta SPRX3
        lda SPRXMSB
        and #SPRITE3_MASK_OFF
        ldx missile2XMSB
        beq .ClearMissile2MSB
        ora #SPRITE3_MASK_ON
.ClearMissile2MSB
        sta SPRXMSB
        lda SPREN
        ora #SPRITE3_MASK_ON
        sta SPREN
        rts


;-------------------------------------------------------------------------------
; LOW ARROW LEFT TO RIGHT
;-------------------------------------------------------------------------------
Enemy_ArrowLoRear
        LIBMATHS_ADD16BIT_AV missileX, 2
        lda #MISSILE_LOW_Y
        sta missileY
        jsr Enemy_UpdateMissile
        lda #SPRITE_ARROW_RIGHT_FRAME
        sta SPRPTR2
        lda missileXMSB
        beq .ExitArrowLoRear
        lda missileX
        cmp #88
        bcc .ExitArrowLoRear
        jsr Sound_FireMissile
        lda #0
        sta missileX
        sta missileXMSB
.ExitArrowLoRear
        rts


;-------------------------------------------------------------------------------
; LOW FIREBALL RIGHT TO LEFT
;-------------------------------------------------------------------------------
Enemy_FireballLoFront
        LIBMATHS_SUBTRACT16BIT_AV missileX, 2
        lda #MISSILE_LOW_Y
        sta missileY
        jsr Enemy_UpdateMissile
        lda missileX
        lsr
        lsr
        and #3
        clc
        adc #SPRITE_FIREBALL_FRAME1
        sta SPRPTR2
        lda missileXMSB
        ora missileX
        bne .ExitFireballLoFront
        jsr Sound_FireMissile
        lda #88
        sta missileX
        lda #1
        sta missileXMSB
.ExitFireballLoFront
        rts


;-------------------------------------------------------------------------------
; DOUBLE ARROW HI & LO RIGHT TO LEFT
;-------------------------------------------------------------------------------
Enemy_DuoArrowHiLoFront
        LIBMATHS_SUBTRACT16BIT_AV missileX, 2
        dec missile2Delay
        bne .UpdateDoubleArrowSprites
        lda #1
        sta missile2Delay
        LIBMATHS_SUBTRACT16BIT_AV missile2X, 2
.UpdateDoubleArrowSprites
        jsr Enemy_UpdateMissile
        jsr Enemy_UpdateMissile2
        lda #SPRITE_ARROW_LEFT_FRAME
        sta SPRPTR2
        sta SPRPTR3
        lda SPREN
        ora #SPRITE2_MASK_ON + #SPRITE3_MASK_ON
        STA SPREN
        lda missileX
        ora missileXMSB
        bne .CheckArrow2
        jsr Sound_FireMissile
        jsr Enemy_Randomise
        ldx #MISSILE_HIGH_Y
        lsr
        bcc .LowArrow
        ldx #MISSILE_LOW_Y
.LowArrow
        stx missileY
        lda #86
        sta missileX
        lda #1
        sta missileXMSB
.CheckArrow2
        lda missile2XMSB
        ora missile2X
        bne .ExitDuoArrowHiLoFront
        jsr Sound_FireMissile
        jsr Enemy_Randomise
        ldx #MISSILE_HIGH_Y
        lsr
        bcc .LowArrow2
        ldx #MISSILE_LOW_Y
.LowArrow2
        stx missile2Y
        lda #86
        sta missile2X
        lda #1
        sta missile2XMSB
.ExitDuoArrowHiLoFront
        rts


;-------------------------------------------------------------------------------
; DOUBLE ARROW HI & LO LEFT TO RIGHT
;-------------------------------------------------------------------------------
Enemy_DuoArrowHiLoRear
        LIBMATHS_ADD16BIT_AV missileX, 2
        dec missile2Delay
        BNE .UpdateRearDoubleArrowSprites
        lda #1
        sta missile2Delay
        LIBMATHS_ADD16BIT_AV missile2X, 2
.UpdateRearDoubleArrowSprites
        jsr Enemy_UpdateMissile
        jsr Enemy_UpdateMissile2
        lda #SPRITE_ARROW_RIGHT_FRAME
        sta SPRPTR2
        sta SPRPTR3
        lda SPREN
        ora #SPRITE2_MASK_ON + #SPRITE3_MASK_ON
        sta SPREN
        lda missileXMSB
        beq .CheckRearArrow2
        lda missileX
        cmp #88
        bcc .CheckRearArrow2
        jsr Sound_FireMissile
        jsr Enemy_Randomise
        ldx #MISSILE_HIGH_Y
        lsr
        bcc .LowRearArrow
        ldx #MISSILE_LOW_Y
.LowRearArrow
        stx missileY
        lda #0
        sta missileX
        sta missileXMSB
.CheckRearArrow2
        lda missile2XMSB
        beq .RearArrowStillActive
        lda missile2X
        cmp #88
        bcc .RearArrowStillActive
        jsr Sound_FireMissile
        jsr Enemy_Randomise
        ldx #MISSILE_HIGH_Y
        lsr
        bcc .LowRearArrow2
        ldx #MISSILE_LOW_Y
.LowRearArrow2
        stx missile2Y
        lda #0
        sta missile2X
        sta missile2XMSB
.RearArrowStillActive
        rts


;-------------------------------------------------------------------------------
; DOUBLE FIREBALL LO BOTH DIRECTIONS
;-------------------------------------------------------------------------------
Enemy_DuoFireballLoBoth
        lda missileDx
        bmi .MoveFireballLeft
        LIBMATHS_ADD16BIT_AV missileX, 2
        jmp .UpdateFireball2
.MoveFireballLeft
        LIBMATHS_SUBTRACT16BIT_AV missileX, 2
.UpdateFireball2
        dec missile2Delay
        bne .UpdateFireballSprites
        lda #1
        sta missile2Delay
        lda missile2Dx
        bmi .MoveFireball2Left
        LIBMATHS_ADD16BIT_AV missile2X, 2
        JMP .UpdateFireballSprites
.MoveFireball2Left
        LIBMATHS_SUBTRACT16BIT_AV missile2X, 2
.UpdateFireballSprites
        lda #MISSILE_LOW_Y
        sta missileY
        jsr Enemy_UpdateMissile
        jsr Enemy_UpdateMissile2
        lda missileX
        lsr
        lsr
        and #3
        clc
        adc #SPRITE_FIREBALL_FRAME1
        sta SPRPTR2
        lda missile2X
        lsr
        lsr
        and #3
        clc
        adc #SPRITE_FIREBALL_FRAME1
        sta SPRPTR3
        lda SPREN
        ora #SPRITE2_MASK_ON + #SPRITE3_MASK_ON
        sta SPREN
        lda missileX
        ora missileXMSB
        beq .PrepareNextFireball
        lda missileXMSB
        beq .CheckFireball2
        lda missileX
        cmp #88
        bcc .CheckFireball2
.PrepareNextFireball
        jsr Sound_FireMissile
        jsr Enemy_Randomise
        lsr
        bcc .FireballDirectionLeft
        ldx #0
        ldy #0
        lda #2
        jmp .SetFireballPosition
.FireballDirectionLeft
        ldx #86
        ldy #1
        lda #254
.SetFireballPosition
        stx missileX
        sty missileXMSB
        sta missileDx
.CheckFireball2
        lda missile2X
        ora missile2XMSB
        beq .PrepareNextFireball2
        lda missile2XMSB
        beq .ExitFireballSelect
        lda missile2X
        cmp #88
        bcc .ExitFireballSelect
.PrepareNextFireball2
        jsr Sound_FireMissile
        jsr Enemy_Randomise
        lsr
        bcc .Fireball2DirectionLeft
        ldx #0
        ldy #0
        lda #2
        jmp .SetFireball2Position
.Fireball2DirectionLeft
        ldx #86
        ldy #1
        lda #254
.SetFireball2Position
        stx missile2X
        sty missile2XMSB
        sta missile2Dx
.ExitFireballSelect
        rts


;-------------------------------------------------------------------------------
; DOUBLE ARROW HI & LO BOTH DIRECTIONS
;-------------------------------------------------------------------------------
Enemy_DuoArrowHiLoBoth
        lda missileY
        cmp #MISSILE_LOW_Y
        bne .MoveArrowRight
        LIBMATHS_SUBTRACT16BIT_AV missileX, 2
        jmp .MoveArrow2
.MoveArrowRight
        LIBMATHS_ADD16BIT_AV missileX, 2
.MoveArrow2
        dec missile2Delay
        bne .UpdateArrowSprites
        lda #1
        sta missile2Delay
        lda missile2Y
        cmp #MISSILE_LOW_Y
        bne .MoveArrow2Right
        LIBMATHS_SUBTRACT16BIT_AV missile2X, 2
        jmp .UpdateArrowSprites
.MoveArrow2Right
        LIBMATHS_ADD16BIT_AV missile2X, 2
.UpdateArrowSprites
        jsr Enemy_UpdateMissile
        jsr Enemy_UpdateMissile2
        ldx #SPRITE_ARROW_RIGHT_FRAME
        lda missileY
        cmp #MISSILE_LOW_Y
        bne .ArrowRight
        inx
.ArrowRight
        stx SPRPTR2
        ldx #SPRITE_ARROW_RIGHT_FRAME
        lda missile2Y
        cmp #MISSILE_LOW_Y
        bne .Arrow2Right
        inx
.Arrow2Right
        stx SPRPTR3
        lda SPREN
        ora #SPRITE2_MASK_ON + #SPRITE3_MASK_ON
        sta SPREN
        lda missileX
        ora missileXMSB
        beq .PrepareNextArrow
        lda missileXMSB
        beq .CheckArrow2Pos
        lda missileX
        cmp #88
        bcc .CheckArrow2Pos
.PrepareNextArrow
        jsr Sound_FireMissile
        jsr Enemy_Randomise
        lsr
        bcc .MissileMoveLeft
        ldx #0
        ldy #0
        lda #MISSILE_HIGH_Y
        jmp .SetMissilePosition
.MissileMoveLeft
        ldx #86
        ldy #1
        lda #MISSILE_LOW_Y
.SetMissilePosition
        stx missileX
        sty missileXMSB
        sta missileY
.CheckArrow2Pos
        lda missile2X
        ora missile2XMSB
        beq .PrepareNextArrow2
        lda missile2XMSB
        beq .ExitFrontRearArrow
        lda missile2X
        cmp #88
        bcc .ExitFrontRearArrow
.PrepareNextArrow2
        jsr Sound_FireMissile
        jsr Enemy_Randomise
        lsr
        bcc .Missile2MoveLeft
        ldx #0
        ldy #0
        lda #MISSILE_HIGH_Y
        jmp .SetMissile2Position
.Missile2MoveLeft
        ldx #86
        ldy #1
        lda #MISSILE_LOW_Y
.SetMissile2Position
        stx missile2X
        sty missile2XMSB
        sta missile2Y
.ExitFrontRearArrow
        rts


;-------------------------------------------------------------------------------
; GENERATE RANDOM NUMBER
;-------------------------------------------------------------------------------
Enemy_Randomise
        lda #5
        sta rand+3
        lda #229
        sta rand+2
        lda #0
        sta rand+5
        sta rand+4
        ldx #16
.RandLoop
        lsr rand+3
        ror rand+2
        bcc .NextRand
        lda rand+4
        clc
        adc rand
        sta rand+4
        lda rand+5
        adc rand+1
        sta rand+5
.NextRand
        asl rand
        rol rand+1
        dex
        bne .RandLoop
        lda rand+4
        clc
        adc #41
        sta rand+4
        bcc .SkipRandHi
        inc rand+5
.SkipRandHi
        lda rand+4
        sta rand
        lda rand+5
        sta rand+1
        rts


