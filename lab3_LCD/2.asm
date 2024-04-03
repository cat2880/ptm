ljmp start

; LCD registers ----------------------------------
; Rejestry LCD umieszczone sa w przestrzeni XDATA pod wskazanymi adresami
LCDstatus equ 0FF2EH
LCDcontrol equ 0FF2CH
LCDdataWR equ 0FF2DH
LCDdataRD equ 0FF2FH

// LCD control bytes ----------------------------------
#define HOME 0x80 // put curcor to second line
#define INITDISP 0x38 // LCD init (8-bit mode)
#define HOME2 0xc0 // put curcor to second line
#define LCDON 0x0e // LCD nn, cursor off, blinking off
#define CLEAR 0x01 // LCD display clear

org 0100h
	text1: db "abcde",00
	text2: db "12345",00

LCDcntrlWR MACRO x
           LOCAL loop
		   
loop:MOV DPTR,#LCDstatus
     MOVX A,@DPTR
     JB ACC.7,loop ; check if LCD busy
     
     MOV DPTR,#LCDcontrol ; write to LCD control
     MOV A, x
     MOVX @DPTR,A
    ENDM
   
LCDcharWR MACRO
          LOCAL loop1,loop2
          PUSH ACC

loop1: MOV DPTR,#LCDstatus
       MOVX A,@DPTR
       JB ACC.7,loop1 ; check if LCD busy
loop2: MOV DPTR,#LCDdataWR ; write data to LCD
       POP ACC
       MOVX @DPTR,A
      ENDM

init_LCD MACRO
         LCDcntrlWR #INITDISP
         LCDcntrlWR #CLEAR
         LCDcntrlWR #LCDON
        ENDM  

; This routine outputs a single character to LCD.
; The character is given in A.
putcharLCD: LCDcharWR
            RET

; This routine outputs a string to LCD. String is terminated by 00H.
; The string in CODE memory is pointed by DPTR.
putstrLCD:
     CLR A
     MOVC A,@A+DPTR
     JZ koniec ; check if end of string
     push DPH
     push DPL
     CALL putcharLCD ; put char to LCD
     pop DPL
     pop DPH
     INC DPTR
     SJMP putstrLCD
     koniec: RET

start: init_LCD

   LCDcntrlWR #CLEAR
   LCDcntrlWR #HOME
   
   mov dptr,#text1
   acall putstrLCD
   LCDcntrlWR #CLEAR
   LCDcntrlWR #HOME
   
   mov dptr,#text1
   acall putstrLCD
  ;LCDcntrlWR #CLEAR
  ;LCDcntrlWR #HOME
  

end_prog:
nop
nop
nop
jmp $
end start