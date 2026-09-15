.model small
.stack 100h

.data

    arreglo DB 10,20,30,40,50

.code

main PROC

    MOV AX,@data
    MOV DS,AX

    MOV BP,OFFSET arreglo
    MOV AL,5

    CALL Suma_arreglo

    ; AQUI AX DEBE SER 150

    MOV AH,4Ch
    INT 21h

main ENDP


Suma_arreglo PROC

    PUSH BX
    PUSH CX
    PUSH SI
    PUSH DX

    MOV CL,AL
    MOV CH,0

    MOV AX,0
    MOV DX,0
    MOV SI,0

    MOV BX,BP

suma_bucle:

    MOV AL,[BX+SI]
    CBW

    ADD DX,AX

    ADD SI,1

    LOOP suma_bucle

    MOV AX,DX

    POP DX
    POP SI
    POP CX
    POP BX
    RET

Suma_arreglo ENDP

END main