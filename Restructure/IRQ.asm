;-------------------------------------------------------------------------------
; IRQ FOR KEYPRESS ON TITLE SCREENS & DEMO
;-------------------------------------------------------------------------------
IRQ_MenuOptionSelect
        lda sysKeyPress
        cmp #KEY_F1
        beq .DisplayInstructionsSelected
        cmp #KEY_SPACE
        beq .StartGameSelected
        jmp krnINTERRUPT
.DisplayInstructionsSelected
        jmp Menu_DisplayInstructions
.StartGameSelected
        jmp Menu_SelectControls


;-------------------------------------------------------------------------------
; IRQ TO UPDATE QUASI MOVEMENT DURING INTRO SEQUENCE
;-------------------------------------------------------------------------------
IRQ_IntroMoveQuasi
        dec introCounter
        bne .ExitIntroMoveQuasi
        lda #QUASI_MOVE_RATE
        sta introCounter
        jsr Quasi_IntroMovement
.ExitIntroMoveQuasi
        jmp Sound_PlayIntroTune


;-------------------------------------------------------------------------------
; IRQ TO MOVE QUASI DURING LEVEL TRANSITIONS
;-------------------------------------------------------------------------------
IRQ_LevelTransitionQuasiMove
        dec levelTransitionCounter
        bne .ExitIRQLevelTansitionMove
        jsr Quasi_LevelTransitionMove
.ExitIRQLevelTansitionMove
        jmp krnINTERRUPT


;-------------------------------------------------------------------------------
; IRQ TO FLASH BACKGROUND DURING DEATH SEQUENCE
;-------------------------------------------------------------------------------
IRQ_FlashBackground
        dec colourFlashCounter
        beq .FlashBackground
        jmp krnINTERRUPT
.FlashBackground
        lda BGCOL1
        eor #7
        sta BGCOL1
        lda #1
        sta colourFlashCounter
        jmp krnINTERRUPT


;-------------------------------------------------------------------------------
; IRQ TO UPDATE ENEMY AND OBSTACLES DURING GAME
;-------------------------------------------------------------------------------
IRQ_EnemyUpdate
        jsr Enemy_Select
        jsr Level_DisplayHeart
        jsr Enemy_MoveKnight
        jsr Level_UpdateRope
        jmp krnINTERRUPT



