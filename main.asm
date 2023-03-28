;dragon 32 brainfuck interpreter

;an unfinished old project picked up and
;finished on 27-28/03/2023
        
        org 0
        ;varzzzzzz

scrnpointer     rmb 2
jmpaddr         rmb 2
outputpointer   rmb 2
tmpvar          rmb 1

        org $1000
        ;coedzzzzz

start
        jsr blankscrn
        ldy #titlestring
        jsr printtitle

        ldx #$480
        stx scrnpointer
        stx outputpointer

        jmp main

startback
        jsr blankscrn
        ldy #titlestring
        jsr printtitle

        jsr copyback
        
        ldx scrnpointer

        lda #32
        sta $5FF

main
        lda #35         ;#
        sta ,x
        leax 1,x
        lda #32         ;space after to stop 0 char showing on copyback
        sta ,x
        leax -1,x

        jsr $8006       ;get char

        beq skipnone
        cmpa #32        ;space
        bne skipspace
        adda #64
skipspace
        cmpa #12        ;clear
        bne skipclear
        jmp helpscreen
skipclear
        cmpa #8         ;backspace
        bne skipback
        cmpx #$480
        beq skipnone    ;if on the first char then don't back up any more
        lda #32
        sta ,x
        leax -2,x
        jmp skipendinc
skipback
        cmpa #40        ;[
        bne skipleft
        ;suba #13
        lda #27
skipleft
        cmpa #41        ;]
        bne skipright
        ;suba #12
        lda #29
skipright
        cmpa #13        ;enter
        bne skipenter
        leax 1,x
        lda #0
        sta ,x
        leax -1,x
        jsr output
        jmp start
skipenter
        sta ,x
skipendinc
        leax 1,x
skipnone

        jmp main

helpscreen

        stx scrnpointer
        jsr copyprog

        jsr blankscrn
        ldy #helptitle
        jsr printtitle

        ldx #helpstring
        ldy #$480
helptextlp
        lda ,x+
        beq checkclear
        suba #64
        sta ,y+
        jmp helptextlp
checkclear
        jsr $8006
        cmpa #12
        bne checkclear
        jmp startback

output
        stx scrnpointer

        jsr copyprog

        jsr blankscrn
        ldy #outputscrnstring
        jsr printtitle

        jsr interpret

checkenter
        jsr $8006
        cmpa #13
        bne checkenter
        jmp startback
        rts

cleararray
        ldx #bfarray
        ldd #$0000
clearlp
        std ,x++
        cmpx #bfarrayend
        bne clearlp
        rts

interpret
        jsr cleararray
        ldu outputpointer
        ldx #progarray
        ldy #bfarray

interpretlp

        lda ,x

        cmpa #60        ;<
        bne skiplt
        leay -1,y
        jmp outputend
skiplt
        cmpa #62        ;>
        bne skipgt
        leay 1,y
        jmp outputend
skipgt
        cmpa #43        ;+
        bne skipinc
        inc ,y
        jmp outputend
skipinc
        cmpa #45        ;-
        bne skipdec
        dec ,y
        jmp outputend
skipdec
        cmpa #46        ;.
        bne skipoutput
        lda ,y
        sta ,u+
        jmp outputend
skipoutput
        cmpa #44        ;,
        bne skipinput
inputlp
        jsr $8006
        beq inputlp
        sta ,y
        jmp outputend
skipinput
        cmpa #27        ;[
        bne skiplb
        stx jmpaddr
        jmp outputend
skiplb
        cmpa #29        ;]
        bne skiprb
        lda ,y
        beq skiprb
        ldx jmpaddr
        jmp outputend
skiprb
        cmpa #32        ;space
        bne outputend
        jmp outputend

outputend

        leax 1,x

outputend2

        cmpx #progarrayend
        bne interpretlp

interpretend
        rts


;el cheapo copy by copying whatever is on the screen
;to an array to then be interpreted

;not ideal but who the fuck is going to write more
;than a whole screens worth its a novelty ;)

copyprog
        ldx #$480
        ldy #progarray
copyproglp
        lda ,x+
        cmpx #$600
        beq copydone
        sta ,y+
        bne copyproglp
copydone
        rts

copyback
        ldx #progarray
        ldy #$480
copyprogbacklp
        lda ,x+
        cmpy #$600
        beq copydone
        sta ,y+
        bne copyproglp
copybackdone
        rts


clrscrn
        ldx #$400
        ldd #$2020
clrscrnlp
        std ,x++
        cmpx #$800
        bne clrscrnlp
        rts

printtitle
        ldx #$400   
printtitlelp
        lda ,y+
        beq skipprint
        sta ,x+
        bra printtitlelp
skipprint
        rts

println
        ldx #$460
        lda #128
linelp
        sta ,x+
        cmpx #$480
        bne linelp
        rts

blankscrn
        jsr clrscrn
        jsr println
        rts


titlestring
        fcv "  DRAGON BRAINFUCK INTERPRETER         BY TOBACH/SLP+TUHB        enter TO RUN    clear FOR HELP ",0

outputscrnstring
        fcv "                                OUTPUT:                                                         ",0

helptitle
        fcv "          HELP SCREEN:                 WHAT IS BRAINFUCK             AND WHY SHOULD I CARE?     ",0

helpstring
        fcv "BRAINFUCK IS AN ESOTERIC        PROGRAMMING LANGUAGE CREATED IN 1993 BY URBAN MULLER.           "
        fcv "THE ONLY CHARACTERS ARE:"
        fcb 190,188,171,173,174,172,155,157
        ;fcv "                                "
        fcb 188
        fcv " AND "
        fcb 190
        fcv " ARE USED TO INC AND DEC THE POINTER, "
        fcb 171
        fcv " AND "
        fcb 173
        fcv " TO ADD OR  SUBRACT ONE FROM THE CURRENT    "
        fcv "POINTER LOCATION, "
        fcb 174
        fcv " TO OUTPUT A BYTE AND "
        fcb 172
        fcv " TO TAKE INPUT. "
        fcb 155
        fcv " AND "
        fcb 157
        fcv " ARE FOR LOOPING, WHICH IF THE CURRENT VALUE !=0 BY THE END "
        fcb 157
        fcv ", THEN JUMPS BACK TO THE START "
        fcb 155
        fcv ".",0


        org $2000

bfarray
        rzb 512
bfarrayend


        org $3000

progarray
        rzb 512
progarrayend

        end start