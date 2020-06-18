;-------------------------------------------------------------------------------
; SET SCREENRAM AND COLOURRAM FOR ENTIRE SCREEN
;-------------------------------------------------------------------------------
defm    LIBSCREEN_CLEARSCREEN_VV
        ldx #0
@loop
        lda #/1
        sta SCREENRAM,X
        sta SCREENRAM+$0100,X
        sta SCREENRAM+$0200,X
        sta SCREENRAM+$02F0,X
        lda #/2
        sta COLOURRAM,X
        sta COLOURRAM+$0100,X
        sta COLOURRAM+$0200,X
        sta COLOURRAM+$02F0,X
        inx
        bne @loop
        endm


;-------------------------------------------------------------------------------
; THREE BYTE DELAY LOOP
;-------------------------------------------------------------------------------
defm    LIBUTILS_DELAY_VVV
        lda #/1
        sta zpDelayCounter
@MajorLoop
        ldx #/2
@OuterLoop
        ldy #/3
@InnerLoop
        dey
        bne @InnerLoop
        dex
        bne @OuterLoop
        dec zpDelayCounter
        bne @MajorLoop
        endm


;-------------------------------------------------------------------------------
; TWO BYTE DELAY LOOP
;-------------------------------------------------------------------------------
defm    LIBUTILS_DELAY_VV
        ldx #/1
@OuterLoop
        ldy #/2
@InnerLoop
        dey
        bne @InnerLoop
        dex
        bne @OuterLoop
        endm


;-------------------------------------------------------------------------------
; ADD 8 BIT NUMBER TO 16 BIT ADDRESS
;-------------------------------------------------------------------------------
defm    LIBMATHS_ADD16BIT_AV
        lda /1
        clc
        adc #/2
        sta /1
        bcc @exit
        inc /1+1
@exit   
        endm


;-------------------------------------------------------------------------------
; SUBTRACT 8 BIT NUMBER FROM 16 BIT ADDRESS
;-------------------------------------------------------------------------------
defm    LIBMATHS_SUBTRACT16BIT_AV
        lda /1
        sec
        sbc #/2
        sta /1
        bcs @exit
        dec /1+1
@exit   
        endm