;Carlos Hurtado


;ENTRADA BP=DIRECCION ARREGLO
;AL=N

;SALIDA AX=MINIMO


Min_ PROC
    PUSH BX
    PUSH CX
    PUSH SI
    PUSH DX

    mov CL,AL ; GUARDAR EL N
    XOR SI,SI ; HACERLO 0 QUE ES LO MISMO QUE USAR EL MOV,0
    XOR CH,CH

    MOV BX,BP
    MOV AL,[BX + SI] ; PRIMER ELEMENTO 

    ADD SI,1
    DEC CX  ; TIENE QUE IR DECRECIENDO

    jz fin_min ; si n=1 no entrar al ciclo por que es un solo elemento
    

    min_bug: 

        MOV DL, [BX + SI]
        CMP DL,AL ;COMPARAR ELEMENTOS CON EL MINIMO ACTUAL

        JL nuevo_minimo   ; si DL< AL, nuevo minimo 

    continuar:
        add SI,1 ;avanzar 1 byte
        loop min_bug

    fin_min: 
        CBW   ; EXTERDER EL SIGNO. 

        POP DX
        POP SI
        POP CX
        POP BX
        RET
 
    nuevo_minimo:
        mov AL,DL ; guardaer el nuevo minimo 
        JMP continuar

Min_ ENDP 

