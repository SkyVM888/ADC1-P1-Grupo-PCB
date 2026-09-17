;Carlos Hurtado


;ENTRADA BP=DIRECCION ARREGLO
;AL=N

;SALIDA AX=maximo


Max_ PROC
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
    

    max_bug: 

        MOV DL, [BX + SI]
        CMP DL,AL ;COMPARAR ELEMENTOS CON EL MAXIMO ACTUAL

        JG nuevo_maximo   ; SOOLO ES CAMBIAR ESTO POR QUE  DE JL A JG

    continuar:
        add SI,1 ;avanzar 1 byte
        loop max_bug

        CBW   ; EXTERDER EL SIGNO. 

        POP DX
        POP SI
        POP CX
        POP BX
        RET
 
    nuevo_maximo:
        mov AL,DL ; guardaer el nuevo MAX
        JMP continuar

Max_ ENDP 

