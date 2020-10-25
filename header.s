		.segment "HEADER"
.ifdef KBD
        jmp     LE68C
        .byte   $00,$13,$56
.endif
.ifdef AIM65
        jmp     COLD_START
        jmp     RESTART
        .word   AYINT,GIVAYF
.endif
.ifdef SYM1
        jmp     PR_WRITTEN_BY
.endif
.ifdef BBCMICRO
        jmp     COLD_START
        jmp     serv
        .byte   $C2
        .byte   <copyw  ; copyright offset pointer
        .byte   1       ; binary version number.
        .byte   "Microsoft BASIC",$00
copyw:  .byte   $00,"(C) Microsoft",$00
msbas:  .byte   "MSBASIC",$00
serv:   cmp     #$04
        beq     chkcmd
        rts
chkcmd: ldx     #$00
        beq     cmdst
cmdlp:  inx
        iny
cmdst:  lda     ($f2),y
        cmp     #$0d
        beq     gotcr
        and     #$5f
        cmp     msbas,x
        beq     cmdlp
notus:  lda     #$04
        rts
gotcr:  lda     msbas,x
        bne     notus
        lda     #$8e
        ldx     $f4
        jmp     OSBYTE
GETIN:  jsr     OSRDCH
        jmp     OSWRCH
ISCNTC: bit     $FF
        bmi     escape
        rts
escape: lda     #$7e
        jsr     OSBYTE
        jmp     RESTART
.endif
