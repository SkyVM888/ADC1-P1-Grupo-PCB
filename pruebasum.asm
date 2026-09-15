;=========================================================
; PRUEBA SUMA_ARREGLO
; Creador: Carlos Hurtado Villalobos
;=========================================================

.model small
.stack 100h

.data

    arreglo DB 10, 20, 30, 40, 50

    mensaje DB 13,10,"Suma = $"

.code

main PROC

    ; Inicializar DS
    MOV AX, @data
    MOV DS, AX

    ; BP = direccion del arreglo
    MOV BP, OFFSET arreglo

    ; AL = cantidad de elementos
    MOV AL, 5

    ; Llamar funcion
    CALL Suma_arreglo

    ; Mostrar mensaje
    MOV DX, OFFSET mensaje
    MOV AH, 09h
    INT 21h

    ; Mostrar resultado
    CALL PrintAX

    ; Terminar
    MOV AH, 4Ch
    INT 21h

main ENDP


;=========================================================
; Entrada : BP = arreglo
;           AL = N
; Salida  : AX = suma
;=========================================================

Suma_arreglo PROC

    PUSH BX
    PUSH CX
    PUSH SI

    ; Guardar N ANTES de poner AX en 0
    MOV CL, AL
    MOV CH, 0

    ; Acumulador
    MOV AX, 0

    ; Indice
    MOV SI, 0

suma_bucle:

    ; Leer solamente 1 byte
    MOV BL, [BP+SI]

    ; Limpiar BH
    MOV BH, 0

    ; Sumar
    ADD AX, BX

    ; Siguiente elemento
    ADD SI, 1

    ; Repetir
    LOOP suma_bucle

    POP SI
    POP CX
    POP BX

    RET

Suma_arreglo ENDP


;=========================================================
; Imprimir AX en decimal
;=========================================================

PrintAX PROC

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BX, 10
    MOV CX, 0

    CMP AX, 0
    JNE convertir

    MOV DL, '0'
    MOV AH, 02h
    INT 21h
    JMP terminar_print

convertir:

    MOV DX, 0
    DIV BX

    PUSH DX
    ADD CX, 1

    CMP AX, 0
    JNE convertir

imprimir:

    POP DX

    ADD DL, '0'
    MOV AH, 02h
    INT 21h

    LOOP imprimir

terminar_print:

    POP DX
    POP CX
    POP BX
    POP AX

    RET

PrintAX ENDP

END main