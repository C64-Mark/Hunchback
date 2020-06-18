;-------------------------------------------------------------------------------
; MAIN SCREEN BUILDING ROUTINE
;-------------------------------------------------------------------------------
Screen_BuildScreen
        ldx #0
.ClearTempScreenLoop
        lda #BLACK
        sta scn_TemporaryColour,X
        sta scn_TemporaryColour+$0100,X
        sta scn_TemporaryColour+$0200,X
        sta scn_TemporaryColour+$0300,X
        lda #CHAR_SPACE
        sta scn_TemporaryScreen,X
        sta scn_TemporaryScreen+$0100,X
        sta scn_TemporaryScreen+$0200,X
        sta scn_TemporaryScreen+$0300,X
        inx
        bne .ClearTempScreenLoop
        ldy #5
.CheckNextLevelType
        sty zpTemp
        ldx currentLevel
        lda tbl_LevelType,X
        and tbl_LevelTypeBitMask,Y
        beq .NextLevelTypeMatch
        lda tbl_LevelCharBlockLo,Y
        sta zpLow
        lda tbl_LevelCharBlockHi,Y
        sta zpHigh
        jmp (zpLow)
.NextLevelTypeMatch
        ldy zpTemp
        dey
        bpl .CheckNextLevelType
        rts


;-------------------------------------------------------------------------------
; CHAR BLOCK BUILDING ROUTINE
;-------------------------------------------------------------------------------
Screen_DrawCharBlocks
        stx zpScnTmpLo
        sty zpScnTmpHi
        ldy charWidth
        iny
        sty rowOffset
        ldx charRows
.DrawNextCharRow
        ldy charWidth
.DrawNextChar
        lda (zpScnTmpLo),Y
        sta (zpScnPtrLo),Y
        lda zpScnPtrHi                  ;switch from screen ram to colour ram
        eor #4
        sta zpScnPtrHi
        lda zpScnTmpLo
        clc
        adc colourOffset
        sta zpScnTmpLo
        bcc .FetchCharColour
        inc zpScnTmpHi
.FetchCharColour
        lda (zpScnTmpLo),Y
        sta (zpScnPtrLo),Y
        lda zpScnTmpLo
        sec
        sbc colourOffset
        sta zpScnTmpLo
        bcs .SwitchBackToChars
        dec zpScnTmpHi
.SwitchBackToChars
        lda zpScnPtrHi                  ;switch from colour ram to screen ram
        eor #4
        sta zpScnPtrHi
        dey
        bpl .DrawNextChar
        lda zpScnTmpLo
        clc
        adc rowOffset                   ;next row of chars/colours
        sta zpScnTmpLo
        bcc .ChangeScreenPtr
        inc zpScnTmpHi
.ChangeScreenPtr
        lda zpScnPtrLo
        clc
        adc #40                         ;next row of screen
        sta zpScnPtrLo
        bcc .NextRow
        inc zpScnPtrHi
.NextRow
        dex
        bpl .DrawNextCharRow
        rts


;-------------------------------------------------------------------------------
; BUILD PIT KNIGHTS CHAR BLOCKS
;-------------------------------------------------------------------------------
Screen_BuildKnights
        ldx #4
        ldy #3
        lda #20
        stx charRows
        sty charWidth
        sta colourOffset
        ldx #<tbl_KnightChars 
        ldy #>tbl_KnightChars 
        lda #<scn_TemporaryScreen+$0199
        sta zpScnPtrLo
        lda #>scn_TemporaryScreen+$0199
        sta zpScnPtrHi
        jsr Screen_DrawCharBlocks
        ldx #<tbl_KnightChars 
        ldy #>tbl_KnightChars 
        lda #<scn_TemporaryScreen+$01A2
        sta zpScnPtrLo
        lda #>scn_TemporaryScreen+$01A2
        sta zpScnPtrHi
        jsr Screen_DrawCharBlocks
        ldx #<tbl_KnightChars 
        ldy #>tbl_KnightChars 
        lda #<scn_TemporaryScreen+$01AB
        sta zpScnPtrLo
        lda #>scn_TemporaryScreen+$01AB
        sta zpScnPtrHi
        jsr Screen_DrawCharBlocks
        jmp .NextLevelTypeMatch


;-------------------------------------------------------------------------------
; BUILD EMPTY PITS CHAR BLOCKS
;-------------------------------------------------------------------------------
Screen_BuildPits
        ldx #4
        ldy #3
        lda #20
        stx charRows
        sty charWidth
        sta colourOffset
        ldx #<tbl_EmptyPitChars
        ldy #>tbl_EmptyPitChars
        lda #<scn_TemporaryScreen+$0199
        sta zpScnPtrLo
        lda #>scn_TemporaryScreen+$0199
        sta zpScnPtrHi
        jsr Screen_DrawCharBlocks
        ldx #<tbl_EmptyPitChars
        ldy #>tbl_EmptyPitChars
        lda #<scn_TemporaryScreen+$01A2
        sta zpScnPtrLo
        lda #>scn_TemporaryScreen+$01A2
        sta zpScnPtrHi
        jsr Screen_DrawCharBlocks
        ldx #<tbl_EmptyPitChars
        ldy #>tbl_EmptyPitChars
        lda #<scn_TemporaryScreen+$01AB
        sta zpScnPtrLo
        lda #>scn_TemporaryScreen+$01AB
        sta zpScnPtrHi
        jsr Screen_DrawCharBlocks
        jmp .NextLevelTypeMatch


;-------------------------------------------------------------------------------
; BUILD ROW OF BELLS CHAR BLOCKS
;-------------------------------------------------------------------------------
Screen_BuildRowOfBells
        ldx #7
        ldy #13
        lda #112
        stx charRows
        sty charWidth
        sta colourOffset
        ldx #<tbl_RowOfBellsChars
        ldy #>tbl_RowOfBellsChars
        lda #<scn_TemporaryScreen+$0085        
        sta zpScnPtrLo
        lda #>scn_TemporaryScreen+$0085
        sta zpScnPtrHi
        jsr Screen_DrawCharBlocks
        jmp .NextLevelTypeMatch


;-------------------------------------------------------------------------------
; BUILD ROPE PIT CHAR BLOCKS
;-------------------------------------------------------------------------------
Screen_BuildRopePit
        lda #<scn_TemporaryScreen+$01C3
        sta zpScnPtrLo
        lda #>scn_TemporaryScreen+$01C3
        sta zpScnPtrHi
        ldx #9
.DrawRopePitNextRow
        ldy #17
        lda #CHAR_SPACE
.ClearRopePitLoop
        sta (zpScnPtrLo),Y
        dey
        bpl .ClearRopePitLoop
        iny
        lda #CHAR_WALL3D
        cpx #9
        bne .NotTopOfWall
        lda #CHAR_WALL3DTOP
.NotTopOfWall
        sta (zpScnPtrLo),Y
        lda zpScnPtrHi                  ;switch from screen ram to colour ram
        eor #4
        sta zpScnPtrHi
        lda #RED
        sta (zpScnPtrLo),Y
        lda zpScnPtrHi                  ;switch from screen ram to colour ram
        eor #4
        sta zpScnPtrHi
        lda zpScnPtrLo
        clc
        adc #40
        sta zpScnPtrLo
        bcc .RopePitNextRow
        inc zpScnPtrHi
.RopePitNextRow
        dex
        bpl .DrawRopePitNextRow
        ldx #17
.DrawPitFireLoop
        lda #RED
        sta scn_TemporaryColour+$0353,X
        lda #CHAR_FIRE
        sta scn_TemporaryScreen+$0353,X
        dex
        bpl .DrawPitFireLoop
        jmp .NextLevelTypeMatch


;-------------------------------------------------------------------------------
; BUILD ESMERELDA TOWER CHAR BLOCKS
;-------------------------------------------------------------------------------
Screen_BuildEsmereldaTower
        ldx #8
        ldy #7
        lda #72
        stx charRows
        sty charWidth
        sta colourOffset
        ldx #<tbl_EsmereldaTowerChars
        ldy #>tbl_EsmereldaTowerChars
        lda #<scn_TemporaryScreen+$0070       
        sta zpScnPtrLo
        lda #>scn_TemporaryScreen+$0070
        sta zpScnPtrHi
        jsr Screen_DrawCharBlocks
        jmp .NextLevelTypeMatch


;-------------------------------------------------------------------------------
; BUILD MAIN WALL CHAR BLOCKS
;-------------------------------------------------------------------------------
Screen_BuildWall
        ldx #0
.DrawWallLoop
        lda #CHAR_WALL
        sta scn_TemporaryScreen+$01B8,X
        sta scn_TemporaryScreen+$02B8,X
        sta scn_TemporaryScreen+$0300,X
        ldy currentLevel
        lda tbl_WallCharColours,Y
        sta scn_TemporaryColour+$01B8,X
        sta scn_TemporaryColour+$02B8,X
        sta scn_TemporaryColour+$0300,X
        inx
        bne .DrawWallLoop
        ldx #200
.DrawWallBaseLoop
        lda tbl_WallBaseChars-1,X
        sta scn_TemporaryScreen+$031F,X
        dex 
        bne .DrawWallBaseLoop
        ldx #7
        ldy #2
        lda #24
        stx charRows
        sty charWidth
        sta colourOffset
        ldx #<tbl_LevelEndBellChars
        ldy #>tbl_LevelEndBellChars
        lda #<scn_TemporaryScreen+$009D     
        sta zpScnPtrLo
        lda #>scn_TemporaryScreen+$009D
        sta zpScnPtrHi
        jsr Screen_DrawCharBlocks
        jmp .NextLevelTypeMatch


;-------------------------------------------------------------------------------
; SET UP SCREEN FOR INTRO SEQUENCE
;-------------------------------------------------------------------------------
Screen_DisplayInitScreen
        ldx #79
.DisplayPlayerStatsLoop
        lda txt_PlayerStats,X
        sta SCREENRAM,X
        lda tbl_PlayerStatsColours,X             
        sta COLOURRAM,X
        dex
        bpl .DisplayPlayerStatsLoop
        ldx #0
.DisplayInitScreenLoop
        lda scn_TemporaryScreen+$0050,X
        sta SCREENRAM+$0050,X
        lda scn_TemporaryColour+$0050,X
        sta COLOURRAM+$0050,X
        lda scn_TemporaryScreen+$0150,X
        sta SCREENRAM+$0150,X
        lda scn_TemporaryColour+$0150,X
        sta COLOURRAM+$0150,X
        lda scn_TemporaryScreen+$0250,X
        sta SCREENRAM+$0250,X
        lda scn_TemporaryColour+$0250,X
        sta COLOURRAM+$0250,X
        lda scn_TemporaryScreen+$02F0,X
        sta SCREENRAM+$02F0,X
        lda scn_TemporaryColour+$02F0,X
        sta COLOURRAM+$02F0,X
        inx
        bne .DisplayInitScreenLoop
        rts


;-------------------------------------------------------------------------------
; SELECT SCREENS TO SHOW DURING INTRO SEQUENCE
;-------------------------------------------------------------------------------
Screen_IntroScrollSelect
        ldx #9
        stx currentLevel
        jsr Screen_BuildScreen
        jsr Screen_IntroScroll
        ldx #8
        stx currentLevel
        jsr Screen_BuildScreen
        jsr Screen_IntroScroll
        ldx #0
        stx currentLevel
        jsr Screen_BuildScreen
        jsr Screen_IntroScroll
        rts


;-------------------------------------------------------------------------------
; SCREEN SCROLL ROUTINE FOR INTRO SEQUENCE
;-------------------------------------------------------------------------------
Screen_IntroScroll
        ldx #7
.CopyScreenPointersLoop
        lda tbl_ScreenPointers,X
        sta tbl_tmpScreenPointers,X
        dex
        bpl .CopyScreenPointersLoop
        ldx #39
.ScreenScrollLoop
        txa
        pha
        LIBUTILS_DELAY_VV 32, 0
        ldx #2
.DecScreenPointersLoop
        dec tbl_tmpScreenPointers+4,X
        dex
        dex
        bpl .DecScreenPointersLoop
        ldx #7
.CopyScreenPtrsLoop
        lda tbl_tmpScreenPointers,X
        sta zpScnPtrLo,X
        dex
        bpl .CopyScreenPtrsLoop
        ldx #22
.MoveToNextRow
        ldy #38
.CopyNextCharLoop
        lda (zpScnPtrLo),Y 
        pha
        lda (zpColPtrLo),Y
        iny
        sta (zpColPtrLo),Y
        pla
        sta (zpScnPtrLo),Y
        dey
        dey
        bpl .CopyNextCharLoop
        ldy #0
        lda (zpScnTmpLo),Y  
        sta (zpScnPtrLo),Y
        lda (zpColTmpLo),Y
        sta (zpColPtrLo),Y
        txa
        pha
        ldx #6
.AddRowToScnPtrsLoop
        lda zpScnPtrLo,X
        clc
        adc #40
        sta zpScnPtrLo,X
        bcc .SkipScnPtrHiByte
        inc zpScnPtrHi,X
.SkipScnPtrHiByte
        dex
        dex
        bpl .AddRowToScnPtrsLoop
        pla
        tax
        dex
        bpl .MoveToNextRow
        pla
        tax
        dex
        bpl .ScreenScrollLoop
        rts


;-------------------------------------------------------------------------------
; END OF DEMO SEQUENCE SCREEN DISPLAY
;-------------------------------------------------------------------------------
Screen_DisplayEndOfDemoMode
        sei
        lda #<IRQ_MenuOptionSelect
        sta sysIntVectorLo
        lda #>IRQ_MenuOptionSelect
        sta sysIntVectorHi
        cli
        jsr Quasi_IntroMovementRight
        ldx #8
.DisplayFeaturingLoop
        lda txt_Featuring,X
        sta SCREENRAM+$0100,X
        lda #WHITE
        sta COLOURRAM+$0100,X
        dex
        bpl .DisplayFeaturingLoop
        jsr Quasi_IntroJumpLeft
        jsr Screen_FlashTheBells
        LIBUTILS_DELAY_VVV 31, 0, 0
        lda #0
        sta SPREN
        rts


;-------------------------------------------------------------------------------
; DISPLAY 'THE BELLS' DURING INTRO SEQUENCE
;-------------------------------------------------------------------------------
Screen_DisplayTheBells
        ldx #7
.CheckTheBellsXLoop
        lda quasiX
        cmp tbl_TheBellsQuasiX,X
        beq .SetTheBellsScreenPos
        dex
        bpl .CheckTheBellsXLoop
        rts
.SetTheBellsScreenPos
        lda tbl_TheBellsScreenLo,X
        sta zpScnPtrLo
        sta zpColPtrLo
        lda #>SCREENRAM+$0100
        sta zpScnPtrHi
        lda #>COLOURRAM+$0100
        sta zpColPtrHi
        txa
        asl
        asl
        sta zpTemp
        ldx #3
.DiplayTheBellsCharsLoop
        ldy zpTemp
        lda tbl_TheBellsChars,Y
        ldy tbl_BellCharsXOffset,X
        sta (zpScnPtrLo),Y
        lda #LIGHTBLUE
        sta (zpColPtrLo),Y
        inc zpTemp
        dex
        bpl .DiplayTheBellsCharsLoop
        rts


;-------------------------------------------------------------------------------
; FLASH 'THE BELLS' DURING INTRO SEQUENCE
;-------------------------------------------------------------------------------
Screen_FlashTheBells
        lda #64
        sta zpTemp
.TheBellsFlashLoop
        lda COLOURRAM+$0173
        eor #4
        ldx #17
.ChangeTheBellsColourLoop
        sta COLOURRAM+$0173,X
        sta COLOURRAM+$019B,X
        dex
        bpl .ChangeTheBellsColourLoop
        LIBUTILS_DELAY_VV 64, 0
        dec zpTemp
        bne .TheBellsFlashLoop
        rts
        

;-------------------------------------------------------------------------------
; DISPLAY PLAYER STATS AT TOP OF SCREEN
;-------------------------------------------------------------------------------
Screen_DisplayStats
        ldx #0
.FetchScoreDigitsLoop
        lda quasiScore,X
        bne .DisplayScoreLoop
        inx
        cpx #6
        bne .FetchScoreDigitsLoop
.DisplayScoreLoop
        lda quasiScore,X
        ora #48
        sta SCREENRAM+$001A,X
        inx
        cpx #7
        bne .DisplayScoreLoop
        ldx quasiLives
        beq .DisplayStatsHeader
        lda #CHAR_SPACE
        sta SCREENRAM+$0041,X
        dex
        beq .DisplayStatsHeader
.DisplayLivesLoop
        lda #CHAR_LIVESMARKER
        sta SCREENRAM+$0041,X
        dex
        bne .DisplayLivesLoop
.DisplayStatsHeader
        ldx #10
.DisplayStatsHeaderLoop
        lda txt_PlayerStats,X
        sta SCREENRAM,X
        lda txt_PlayerStats+$0028,X
        sta SCREENRAM+$0028,X
        dex
        bpl .DisplayStatsHeaderLoop
        lda quasiBonus
        beq .DisplayLevelMarker
        sta zpTemp
        lda #>SCREENRAM+$0001
        sta zpScnPtrHi
        lda #<SCREENRAM+$0001
        sta zpScnPtrLo
.DrawNextBonusBellRow
        ldx #3
.DrawBonusBellsLoop
        lda tbl_BellChars,X
        ldy tbl_BellCharsXOffset,X
        sta (zpScnPtrLo),Y
        dex
        bpl .DrawBonusBellsLoop
        inc zpScnPtrLo
        inc zpScnPtrLo
        dec zpTemp
        bne .DrawNextBonusBellRow
.DisplayLevelMarker
        ldx #27
.DrawLevelMarkerLoop
        ldy tbl_LevelMarkerXOffset,X
        lda tbl_LevelMarkerChars,X
        sta SCREENRAM+$0348,Y
        lda tbl_LevelMarkerCharCol,X
        sta COLOURRAM+$0348,Y
        dex
        bpl .DrawLevelMarkerLoop
        ldx #7
        lda #0
.ClearLevelMarkerCharLoop
        sta chr_Marker,X 
        dex
        bpl .ClearLevelMarkerCharLoop
        lda currentLevel
        and #3
        tax
        lda tbl_LevelMarkerPixel,X
        sta chr_Marker+6
        sta chr_Marker+5
        lda currentLevel
        lsr
        lsr
        and #3
        tax
        lda #CHAR_LEVELMARKER
        sta SCREENRAM+$0371,X
        rts


;-------------------------------------------------------------------------------
; SCREEN SCROLL ROUTINE FOR TRANSITION BETWEEN LEVELS
;-------------------------------------------------------------------------------
Screen_LevelTransitionScroll
        ldx #7
.CopyScreenPtrs
        lda tbl_ScreenScrollPtrs,X
        sta zpScnPtrLo,X
        dex
        bpl .CopyScreenPtrs
        ldx #22
.ScrollLoop
        ldy #1
        cpx #4
        bcs .CopyNextChar
        ldy #8
.CopyNextChar
        lda (zpScnPtrLo),Y
        pha
        lda (zpColPtrLo),Y
        dey
        sta (zpColPtrLo),Y
        pla
        sta (zpScnPtrLo),Y
        iny
        iny
        cpy #40
        bne .CopyNextChar
        lda #39
        sec
        sbc zpTemp
        tay
        lda (zpScnTmpLo),Y
        pha
        lda (zpColTmpLo),Y
        ldy #39
        sta (zpColPtrLo),Y
        pla
        sta (zpScnPtrLo),Y
        ldy #6
.NextScreenRow
        lda zpScnPtrLo,y
        clc
        adc #40
        sta zpScnPtrLo,y
        lda zpScnPtrHi,y
        adc #0
        sta zpScnPtrHi,y
        dey
        dey
        bpl .NextScreenRow
        dex
        bpl .ScrollLoop
        LIBUTILS_DELAY_VV 49, 0
        rts


;-------------------------------------------------------------------------------
; COPY TEMPORARY SCREEN AND COLOUR TO SCREEN AND COLOUR RAM
;-------------------------------------------------------------------------------
Screen_CopyGameScreen
        ldx currentLevel
        jsr Screen_BuildScreen
        ldx #0
.CopyScreenLoop
        lda scn_TemporaryScreen,X
        sta SCREENRAM,X
        lda scn_TemporaryScreen+$0100,X
        sta SCREENRAM+$0100,X
        lda scn_TemporaryScreen+$0200,X
        sta SCREENRAM+$0200,X
        lda scn_TemporaryScreen+$02F0,X
        sta SCREENRAM+$02F0,X
        lda scn_TemporaryColour,X
        sta COLOURRAM,X
        lda scn_TemporaryColour+$0100,X
        sta COLOURRAM+$0100,X
        lda scn_TemporaryColour+$0200,X
        sta COLOURRAM+$0200,X
        lda scn_TemporaryColour+$02F0,X
        sta COLOURRAM+$02F0,X
        inx
        bne .CopyScreenLoop
        ldx #79
.CopyPlayerStatsLoop
        lda txt_PlayerStats,X
        sta SCREENRAM,X
        lda tbl_PlayerStatsColours,X
        sta COLOURRAM,X
        dex
        bpl .CopyPlayerStatsLoop
        rts

