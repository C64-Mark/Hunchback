;-------------------------------------------------------------------------------
; SYS 4096
;-------------------------------------------------------------------------------
*=$0801
                        byte $0B, $08, $0A, $00, $9E, $34, $30, $39
                        byte $36, $00, $00, $00

*=$1000
;-------------------------------------------------------------------------------
; MAIN INITIALISATION ROUTINE
;-------------------------------------------------------------------------------
Initialise
        lda VICBANK             ; BANK 1: $4000
        and #%11111100
        ora #%00000010
        sta VICBANK
        lda VMCR                ; Chars: $4000, Screen: $7400
        and #%00000001
        ora #%11010000
        sta VMCR
        lda VCR2
        ora #%00010000          ; multi-colour mode on
        sta VCR2   
        lda #BLACK
        sta BDCOL
        sta BGCOL0     
        lda #GRAY1
        sta BGCOL1  
        lda #WHITE
        sta BGCOL2   
        lda #BROWN
        sta SPRMC0    
        lda #GRAY3
        sta SPRMC1  
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
        lda #%00001111
        sta SPRMCS
        lda #SPRITE4_MASK_ON + #SPRITE6_MASK_ON
        sta SPRXEX
        sta SPRYEX
        lda #15
        sta SIDVOL
        ldx #49
.CopyHiScoresLoop
        lda tbl_HiScoreInit,X
        sta tbl_HiScores,X   
        dex
        bpl .CopyHiScoresLoop
        jmp Menu_DisplayTitleScreen


