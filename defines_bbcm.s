; configuration
CONFIG_2A := 1

CONFIG_CBM_ALL := 1

CONFIG_DATAFLG := 1
CONFIG_EASTER_EGG := 1
;CONFIG_FILE := 1; support PRINT#, INPUT#, GET#, CMD
CONFIG_NO_CR := 0; terminal doesn't need explicit CRs on line ends
CONFIG_NO_LINE_EDITING := 1; support for "@", "_", BEL etc.
CONFIG_NO_READ_Y_IS_ZERO_HACK := 1
CONFIG_PEEK_SAVE_LINNUM := 1
CONFIG_SCRTCH_ORDER := 2
CONFIG_INPUTBUFFER_0200 := 1

CBM2 := 1

; zero page
ZP_START1 = $00
ZP_START2 = $0D
ZP_START3 = $03
ZP_START4 = $13

; extra/override ZP variables
CURDVC			:= $008F
TISTR			:= $008E
Z96			    := $008C
;POSX			:= $00C6
;TXPSV			:= LASTOP
USR				:= GORESTART ; XXX

; inputbuffer
INPUTBUFFER     := $0500

; constants
SPACE_FOR_GOSUB := $3E
STACK_TOP		:= $FF
WIDTH			:= 40
WIDTH2			:= 30

RAMSTART2		:= $0E00

; magic memory locations
ENTROPY = $E844

; BBC MOS CALLS

OSCLI   := $fff7
OSBYTE  := $fff4
OSWORD  := $fff1
OSWRCH  := $ffee
OSNEWL  := $ffe7
OSASCI  := $ffe3
OSRDCH  := $ffe0
OSFILE  := $FFDD

BRKV    := $0202

; monitor functions
OPEN	:= $FFC0
CLOSE	:= $FFC3
CHKIN	:= $FFC6
CHKOUT	:= $FFC9
CLRCH	:= $FFCC
CHRIN	:= OSRDCH
CHROUT	:= OSWRCH
;LOAD	:= $FFD5
;SAVE	:= $FFD8
VERIFY	:= $FFDB
SYS		:= $FFDE
;ISCNTC	:= $FFE1
;GETIN	:= $ffe0
CLALL	:= $FFE7
LE7F3	:= $E7F3; for CBM1
MONCOUT	:= CHROUT
MONRDKEY := GETIN


