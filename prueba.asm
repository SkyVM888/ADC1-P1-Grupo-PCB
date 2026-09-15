;=========================================================
; PRUEBA SUMA_ARREGLO
;=========================================================

.model small
.stack 100h

.data

    arreglo DB -10,-20,-30,-40,-50

    mensaje DB 13,10,"Suma = $"

    resultado DW ?

.code

main PROC

    ; Inicializar segmento de datos
    MOV AX,@data
    MOV DS,AX

    ; BP = direccion del arreglo
    MOV BP,OFFSET arreglo

    ; AL = N
    MOV AL,5

    ; Llamar funcion
    CALL Suma_arreglo

    ; Guardar resultado ANTES de imprimir
    MOV resultado,AX

    ; Mostrar "Suma = "
    MOV DX,OFFSET mensaje
    MOV AH,09h
    INT 21h

    ; Recuperar resultado
    MOV AX,resultado

    ; Imprimir AX
    CALL PrintAX

    ; Terminar programa
    MOV AH,4Ch
    INT 21h

main ENDP


;=========================================================
; SUMA_ARREGLO
;=========================================================

;sumador
;Creador Carlos Hurtado Villalobos

;Entrada : BP=es el arreglo, AL=N
;SALIDA TIENE QUE SER LA SUMA = AX

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


;=========================================================
; PRINT AX EN DECIMAL
;=========================================================

PrintAX PROC

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BX,10
    MOV CX,0

    CMP AX,0
    JNE convertir

    MOV DL,'0'
    MOV AH,02h
    INT 21h
    JMP fin_print

convertir:

    MOV DX,0
    DIV BX

    PUSH DX
    ADD CX,1

    CMP AX,0
    JNE convertir

imprimir:

    POP DX
    ADD DL,'0'

    MOV AH,02h
    INT 21h

    LOOP imprimir

fin_print:

    POP DX
    POP CX
    POP BX
    POP AX

    RET

PrintAX ENDP


END main