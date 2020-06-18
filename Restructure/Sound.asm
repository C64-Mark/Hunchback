;-------------------------------------------------------------------------------
; PLAY NOTES FOR INTRO TUNE
;-------------------------------------------------------------------------------
Sound_PlayIntroTune
        dec introTuneNoteDuration
        bne .ExitPlayIntroTune
        ldx introTuneNoteIndex
        lda tbl_IntroTuneDuration,X
        sta introTuneNoteDuration
        lda #SND_SAW_GATE_OFF
        sta VCREG1
        lda tbl_IntroTuneFreqHi,X
        sta FREH1
        lda tbl_IntroTuneFreqLo,X
        sta FREL1
        lda #0
        sta SUREL1
        lda #9
        sta ATDCY1
        inx 
        txa 
        and #63
        sta introTuneNoteIndex
        lda #SND_SAW_GATE_ON
        sta VCREG1
.ExitPlayIntroTune
        jmp krnINTERRUPT


;-------------------------------------------------------------------------------
; QUASI JUMP SOUND
;-------------------------------------------------------------------------------
Sound_QuasiJump
        ldx #6
.QuasiJumpSoundLoop
        lda tbl_QuasiJumpFreqLo,X
        sta FREL1,X
        dex
        bpl .QuasiJumpSoundLoop
        lda #SND_PULSE_GATE_ON
        sta VCREG1
        lda #SND_PULSE_GATE_OFF
        sta VCREG1
        rts


;-------------------------------------------------------------------------------
; PLAY SOUND AS QUASI JUMPS ACROSS ROW OF BELLS
;-------------------------------------------------------------------------------
Sound_RowOfBells
        ldx #0
.CheckNextBell
        lda tbl_RowOfBellsXPosition,X
        cmp quasiX
        bcs .BellSoundSelected
        inx 
        jmp .CheckNextBell
.BellSoundSelected
        lda #SND_TRIANGLE_GATE_OFF
        sta VCREG3
        lda #0
        sta FREL3
        sta SUREL3
        lda #10
        sta ATDCY3
        lda tbl_RowOfBellsFreqHi,X
        sta FREH3
        lda #SND_TRIANGLE_GATE_ON
        sta VCREG3
        rts


;-------------------------------------------------------------------------------
; SOUND FOR BELL BONUS CASH IN
;-------------------------------------------------------------------------------
Sound_BellBonus
        lda #SND_TRIANGLE_GATE_OFF
        sta VCREG3
        lda #100
        sta FREL3
        lda #122
        sta FREH3
        lda #10
        sta ATDCY3
        lda #0
        sta SUREL3
        lda #SND_TRIANGLE_GATE_ON
        sta VCREG3
        rts


;-------------------------------------------------------------------------------
; END OF LEVEL BELL SOUND
;-------------------------------------------------------------------------------
Sound_EndOfLevelBell
        ldx #6
.PlayBellHiSoundLoop
        lda tbl_BellHiFreqLo,X
        sta FREL3,X
        dex
        bpl .PlayBellHiSoundLoop
        lda #SND_TRIANGLE_GATE_ON
        sta VCREG3
        LIBUTILS_DELAY_VVV 1, 192, 0
        ldx #6
.PlayBellLoSoundLoop
        lda tbl_BellLoFreqLo,X
        sta FREL3,X
        dex
        bpl .PlayBellLoSoundLoop
        lda #SND_TRIANGLE_GATE_ON
        sta VCREG3
        rts


;-------------------------------------------------------------------------------
; QUASI DYING SOUND
;-------------------------------------------------------------------------------
Sound_QuasiDying
        ldx #6
.DeathSoundPart1Loop
        lda tbl_DeathSoundP1FreqLo,X
        sta FREL1,X
        dex 
        bpl .DeathSoundPart1Loop
        ldx #17
.DeathSoundPart2Loop
        lda tbl_DeathSoundP2FreqLo,X
        sta FREL1
        txa
        LIBUTILS_DELAY_VV 30, 0
        tax 
        dex 
        bpl .DeathSoundPart2Loop
        lda #SND_DISABLE_VOICE
        sta VCREG1
        rts 


;-------------------------------------------------------------------------------
; QUASI DEAD SOUND 
;-------------------------------------------------------------------------------
Sound_QuasiDead
        lda #%11110001
        sta FLTCON
        lda SIDVOL
        ora #SND_LOW_PASS_FILTER_MASK_ON
        sta SIDVOL
        lda #0
        sta FLTCUTLO
        ldx #6
.DeathSoundPart3Loop
        lda tbl_DeathSoundP3FreqLo,X
        sta FREL1,X
        dex 
        bpl .DeathSoundPart3Loop
        ldx #40
.DeathSoundPart3Loop2
        stx FREH1
        stx FLTCUTHI
        txa
        LIBUTILS_DELAY_VV 8, 0
        clc 
        adc #10
        tax 
        cpx #200
        bne .DeathSoundPart3Loop2
        lda #SND_DISABLE_VOICE
        sta VCREG1
        lda #15
        sta SIDVOL
        lda #0
        sta FLTCON
        rts


;-------------------------------------------------------------------------------
; MISSILE SOUND
;-------------------------------------------------------------------------------
Sound_FireMissile
        lda #SND_NOISE_GATE_OFF
        sta VCREG2
        lda #44
        sta FREH2
        lda #100
        sta FREL2
        lda #128
        sta ATDCY2
        lda #0
        sta SUREL2
        lda #SND_NOISE_GATE_ON
        sta VCREG2
        rts


;-------------------------------------------------------------------------------
; ROPE SWINGING SOUND
;-------------------------------------------------------------------------------
Sound_Rope
        lda #SND_NOISE_GATE_OFF
        sta VCREG2
        lda #15
        sta FREH2
        lda #100
        sta FREL2
        lda #176
        sta ATDCY2
        lda #0
        sta SUREL2
        lda #SND_NOISE_GATE_ON
        sta VCREG2
        rts 
