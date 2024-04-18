ORG 000BH
    MOV TH0, #00H    
    MOV TL0, #00H
    DEC R0            
    RETI              

ORG 0100h
start:
    MOV TMOD, #01H   
    MOV TH0, #00H    
    MOV TL0, #00H    
    SETB TR0         
    MOV IE, #82H    
    MOV A, #00H      
    MOV P1, A        
    MOV R1, #0x01    

T1_ODCINKI:
    CALL MIERZ_CZAS   
    MOV A, R1         
    MOV R0, A         
    MOV A, P1         
    CPL               
    MOV P1, A         
    SJMP T2_ODCINKI   

T2_ODCINKI:
    CALL MIERZ_CZAS   
    MOV A, R1         
    MOV R0, A         
    MOV A, P1         
    CPL               
    MOV P1, A         
    SJMP T1_ODCINKI   

MIERZ_CZAS:
    MOV R0, #0HHH     
CZEKAM:
    DJNZ R0, CZEKAM  
    RET               

END START; dziala, do sprawka
