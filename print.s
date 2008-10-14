.segment "CODE"

PRSTRING:
        jsr     STRPRT
L297E:
        jsr     CHRGOT

; ----------------------------------------------------------------------------
; "PRINT" STATEMENT
; ----------------------------------------------------------------------------
PRINT:
        beq     CRDO
PRINT2:
        beq     L29DD
        cmp     #TOKEN_TAB
        beq     L29F5
        cmp     #TOKEN_SPC
.ifdef CONFIG_2
        clc	; also AppleSoft II
.endif
        beq     L29F5
        cmp     #','
; Pre-KIM had no CLC. KIM added the CLC
; here. Post-KIM moved the CLC up...
.ifdef KIM
        clc
.endif
        beq     L29DE
        cmp     #$3B
        beq     L2A0D
        jsr     FRMEVL
        bit     VALTYP
        bmi     PRSTRING
        jsr     FOUT
        jsr     STRLIT
.ifndef CONFIG_NO_CR
        ldy     #$00
        lda     (FAC_LAST-1),y
        clc
        adc     POSX
  .ifdef KBD
        cmp     #$28
  .else
        cmp     Z17
  .endif
        bcc     L29B1
        jsr     CRDO
L29B1:
.endif
        jsr     STRPRT
.ifdef KBD
        jmp     L297E
.else
        jsr     OUTSP
        bne     L297E ; branch always
.endif

.ifdef KBD
; PATCHES
LE86C:
        pla
        jmp     CONTROL_C_TYPED
LE870:
        jsr     GETBYT
        txa
LE874:
        beq     LE878
        bpl     LE8F2
LE878:
        jmp     IQERR
; PATCHES
.endif



.ifndef KBD
L29B9:
  .ifdef CBM2
        lda     #$00
        sta     INPUTBUFFER,x
        ldx     #<(INPUTBUFFER-1)
        ldy     #>(INPUTBUFFER-1)
  .else
    .ifndef APPLE
        ldy     #$00
        sty     INPUTBUFFER,x
        ldx     #LINNUM+1
    .endif
    .ifdef MICROTAN
        bne     LE882
	.endif
  .endif
  .ifdef CONFIG_FILE
        lda     Z03
        bne     L29DD
  .endif
.endif


CRDO:
.if .def(CONFIG_PRINTNULLS) && .def(CONFIG_FILE)
        lda     Z03
        bne     LC9D8
        sta     $05
LC9D8:
.endif
        lda     #CRLF_1
.ifndef CONFIG_CBM_ALL
        sta     POSX
.endif
        jsr     OUTDO
LE882:
        lda     #CRLF_2
        jsr     OUTDO

PRINTNULLS:
.ifdef KBD
        lda     #$00
        sta     $10
        eor     #$FF
.else
  .if .def(CONFIG_NULL) || .def(CONFIG_PRINTNULLS)
    .ifdef CONFIG_FILE
    ; Although there is no statement for it,
    ; CBM1 had NULL support and ignores
    ; it when not targeting the screem,
    ; CBM2 dropped it completely.
        lda     Z03
        bne     L29DD
    .endif
        txa
        pha
        ldx     Z15
        beq     L29D9
        lda     #$00
L29D3:
        jsr     OUTDO
        dex
        bne     L29D3
L29D9:
        stx     POSX
        pla
        tax
  .else
    .ifdef APPLE
        lda     #$00
        sta     $50
    .endif
        eor     #$FF
  .endif
.endif
L29DD:
        rts
L29DE:
        lda     POSX
.ifndef CONFIG_NO_CR
  .ifdef KBD
        cmp     #$1A
  .else
        cmp     Z18
  .endif
        bcc     L29EA
        jsr     CRDO
        jmp     L2A0D
L29EA:
.endif
        sec
L29EB:
.ifdef CONFIG_CBM_ALL
        sbc     #$0A
.else
  .ifdef KBD
        sbc     #$0D
  .else
        sbc     #$0E
  .endif
.endif
        bcs     L29EB
        eor     #$FF
        adc     #$01
        bne     L2A08
L29F5:
.ifdef CONFIG_11A
        php
.else
        pha
.endif
        jsr     GTBYTC
        cmp     #')'
.ifdef CONFIG_11A
  .ifdef CONFIG_2
        bne     SYNERR4
  .else
        jne     SYNERR
  .endif
        plp
        bcc     L2A09
.else
  .ifdef APPLE
        beq     L1185
        jmp     SYNERR
L1185:
  .else
        bne     SYNERR4
  .endif
        pla
        cmp     #TOKEN_TAB
  .ifdef APPLE
        bne     L2A09
  .else
        bne     L2A0A
  .endif
.endif
        txa
        sbc     POSX
        bcc     L2A0D
.ifndef CONFIG_11
        beq     L2A0D
.endif
L2A08:
        tax
.ifdef CONFIG_11
L2A09:
        inx
.endif
L2A0A:
.ifndef CONFIG_11
        jsr     OUTSP
.endif
        dex
.ifndef CONFIG_11
        bne     L2A0A
.else
        bne     L2A13
.endif
L2A0D:
        jsr     CHRGET
        jmp     PRINT2
.ifdef CONFIG_11
L2A13:
        jsr     OUTSP
        bne     L2A0A
.endif

; ----------------------------------------------------------------------------
; PRINT STRING AT (Y,A)
; ----------------------------------------------------------------------------
STROUT:
        jsr     STRLIT

; ----------------------------------------------------------------------------
; PRINT STRING AT (FACMO,FACLO)
; ----------------------------------------------------------------------------
STRPRT:
        jsr     FREFAC
        tax
        ldy     #$00
        inx
L2A22:
        dex
        beq     L29DD
        lda     (INDEX),y
        jsr     OUTDO
        iny
        cmp     #$0D
        bne     L2A22
        jsr     PRINTNULLS
        jmp     L2A22
; ----------------------------------------------------------------------------
OUTSP:
.ifdef CONFIG_FILE
  .ifndef CONFIG_SPC_IS_CRSR_RIGHT
        lda     Z03
        beq     LCA40
        lda     #$20
        .byte   $2C
LCA40:
  .endif
        lda     #$1D ; CRSR RIGHT
.else
        lda     #$20
.endif
        .byte   $2C
OUTQUES:
        lda     #$3F

; ----------------------------------------------------------------------------
; PRINT CHAR FROM (A)
; ----------------------------------------------------------------------------
OUTDO:
.ifndef KBD
        bit     Z14
        bmi     L2A56
.endif
.ifndef CBM2_KBD
        pha
.endif
.ifdef CBM1
        cmp     #$1D ; CRSR RIGHT
        beq     LCA6A
        cmp     #$9D ; CRSR LEFT
        beq     LCA5A
        cmp     #$14 ; DEL
        bne     LCA64
LCA5A:
        lda     POSX
        beq     L2A4E
        lda     Z03
        bne     L2A4E
        dec     POSX
LCA64:
        and     #$7F
.endif
.ifndef CBM2
        cmp     #$20
        bcc     L2A4E
.endif
LCA6A:
.ifdef CONFIG_CBM1_PATCHES
        lda     Z03
        jsr     PATCH6
        nop
.endif
.ifdef CONFIG_PRINT_CR
        lda     POSX
        cmp     Z17
        bne     L2A4C
  .ifdef APPLE
        nop ; PATCH!
        nop ; don't print CR
        nop
  .else
        jsr     CRDO
  .endif
L2A4C:
.endif
.ifndef CONFIG_CBM_ALL
        inc     POSX
.endif
L2A4E:
.ifndef CBM2_KBD
        pla
.endif
.ifdef KIM_MICROTAN
        sty     DIMFLG
.endif
.ifdef CONFIG_IO_MSB
        ora     #$80
.endif
        jsr     MONCOUT
.ifdef CONFIG_IO_MSB
        and     #$7F
.endif
.ifdef KIM_MICROTAN
        ldy     DIMFLG
.endif
.ifdef OSI
        nop
        nop
        nop
        nop
.endif
L2A56:
        and     #$FF
LE8F2:
        rts

; ----------------------------------------------------------------------------
; ???
; ----------------------------------------------------------------------------
.ifdef KBD
LE8F3:
        pha
        lda     $047F
        clc
        beq     LE900
        lda     #$00
        sta     $047F
        sec
LE900:
        pla
        rts
.endif