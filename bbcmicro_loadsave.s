.segment "CODE"

osfpb   :=  $0400

SAVE:   jsr     makepb
        lda     TXTTAB
        sta     osfpb+$02
        sta     osfpb+$0a
        lda     TXTTAB+1
        sta     osfpb+$03
        sta     osfpb+$0b
        lda     VARTAB
        sta     osfpb+$0e
        lda     VARTAB+1
        sta     osfpb+$0f
        lda     #$80
        sta     osfpb+$07
        lda     #$00
        ldx     #<osfpb
        ldy     #>osfpb
        jmp     OSFILE

LOAD:   jsr     makepb
        lda     TXTTAB
        sta     osfpb+$02
        lda     TXTTAB+1
        sta     osfpb+$03
        lda     #$ff
        ldx     #<osfpb
        ldy     #>osfpb
        jsr     OSFILE
        clc
        lda     TXTTAB
        adc     osfpb+$0a
        sta     VARTAB
        lda     TXTTAB+1
        adc     osfpb+$0b
        sta     VARTAB+1
        lda     VARTAB
        ldy     VARTAB+1
        jmp     FIX_LINKS

nofn:   ldx     #ERR_SYNTAX
        jmp     ERROR

makepb: ldx     #$12
        ldy     #$00
        lda     (TXTPTR),y
        beq     nofn
        cmp     #'"'
        bne     notqt
fnloop: iny
        lda     (TXTPTR),y
        beq     fndon1
        cmp     #'"'
        beq     fndon2
notqt:  sta     osfpb,x
        inx
        bne     fnloop
fndon2: iny
fndon1: clc
        tya
        adc     TXTPTR
        sta     TXTPTR
        bcc     fnoinc
        inc     TXTPTR+1
fnoinc: lda     #$0d
        sta     osfpb,x
        lda     #$00
        ldx     #$11
makplp: sta     osfpb,x
        dex
        bpl     makplp
        lda     #$12
        sta     osfpb
        lda     #>osfpb
        sta     osfpb+1
        rts
