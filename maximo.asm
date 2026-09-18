;Carlos Hurtado


;ENTRADA BP=DIRECCION ARREGLO
;AL=N

;SALIDA AX=Maximo 

max_ PROC
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    mov CX,AX ; GUARDAR EL N completo 
    cmp CX,0   
    JE max_cero   ; N==0 preguntar 

    XOR SI,SI ; HACERLO 0 QUE ES LO MISMO QUE USAR EL MOV,0
    MOV BX,BP   ; direc del array 
    MOV AL,[BX + SI] ; PRIMER ELEMENTO  como minimo incial. 

    inc SI ; avanzar al siguiente elemento
    dec CX  ; decrementar n tras procesar el elememento   
    jz fin_max ; si n=1 no entrar al ciclo por que es un solo elemento

    max_bug: 

        MOV DL, [BX + SI]
        CMP DL,AL ;COMPARAR ELEMENTOS CON EL MINIMO ACTUAL

        jle nomayor   ; si DL mayor o igual a  AL, nuevo minimo ; aca cambiar el de maximo. ##
        mov AL,DL  ; actualización 

    nomayor:
        inc SI
        LOOP max_bug
        JMP fin_max

    max_cero:
        mov AL,80h 
   ;//////////////////////////////////////////////////////////////////////////
    fin_max: ; aca; 
        CBW   ; EXTERDER EL SIGNO. 

        POP SI
        POP DX
        POP CX
        POP BX
        RET
 
max_ ENDP 

