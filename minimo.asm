;Carlos Hurtado


;ENTRADA BP=DIRECCION ARREGLO
;AL=N

;SALIDA AX=MINIMO

Min_ PROC
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    mov CX,AX ; GUARDAR EL N completo 
    cmp CX,0   
    JE min_cero   ; N==0 preguntar 

    XOR SI,SI ; HACERLO 0 QUE ES LO MISMO QUE USAR EL MOV,0
    MOV BX,BP   ; direc del array 
    MOV AL,[BX + SI] ; PRIMER ELEMENTO  como minimo incial. 

    inc SI ; avanzar al siguiente elemento
    dec CX  ; decrementar n tras procesar el elememento   
    jz fin_min ; si n=1 no entrar al ciclo por que es un solo elemento

    min_bug: 

        MOV DL, [BX + SI]
        CMP DL,AL ;COMPARAR ELEMENTOS CON EL MINIMO ACTUAL

        jge nomenor   ; si DL mayor o igual a  AL, nuevo minimo ; aca cambiar el de maximo. ##
        mov AL,DL  ; actualización 

    nomenor:
        inc SI
        LOOP min_bug
        JMP fin_min

    min_cero:
        mov AL,7Fh 
   ;//////////////////////////////////////////////////////////////////////////
    fin_min: ; aca; 
        CBW   ; EXTERDER EL SIGNO. 

        POP SI
        POP DX
        POP CX
        POP BX
        RET
 
Min_ ENDP 

