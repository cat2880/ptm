ljmp start

LCDstatus EQU 0FF2eh
LCDcontrol EQU 0FF2Ch
LCDdataWR EQU 0FF2Dh
LCDmoveLEFT EQU 00010000b
LCDmoveRIGHT EQU 00010100b

#define HOME 0x80
#define INIDISP 0x38
#define LCDON 0x0e
#define CLEAR 0x01

org 0100h

start: 
call init_LCD
MOV a, #"A"
mov DPTR, #string
lcall LCDwriteSTR

lcall LCDmoveL
lcall LCDmoveR
lcall LCDmoveR
lcall LCDmoveL 

mov a, #03h
lcall LCDdelete

nop
jmp $

init_LCD:
mov a, #INIDISP
call LCDcntrl
mov a, #CLEAR
call LCDcntrl
mov a, #LCDON
call LCDcntrl
ret

LCDwriteSTR:
clr a
movc a, @A+DPTR
jz LCDwriteRESET
push dph
push dpl
lcall LCDcharWR
pop dpl
pop dph
inc DPTR
jmp LCDwriteSTR

LCDwriteRESET:
ret

LCDcntrl:
push ACC
call wait_busy
mov DPTR, #LCDcontrol
pop ACC
movx @DPTR, A
ret

LCDcharWR:
push ACC
call wait_busy
mov DPTR, #LCDdataWR
pop ACC
movx @dptr, a
ret

LCDmoveL:
call wait_busy
mov a, #LCDmoveLEFT
call LCDcntrl
ret

LCDmoveR:
call wait_busy
mov a, #LCDmoveRIGHT
call LCDcntrl
ret

LCDdelete:
lcall LCDmoveR
mov a ,#" "
lcall LCDcharWR
lcall LCDmoveL

/*
incDPTR:
pop ACC
mov DPTR, #string
jz cont
dec ACC
inc dptr

cont:
lcall LCDwriteSTR
*/

ret

wait_busy:
mov DPTR, #LCDstatus
 wait:
 movx A, @DPTR
 jb ACC.7, wait
 ret

string: DB 'qwerty', 00h

END
