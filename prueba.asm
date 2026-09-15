;=========================================================
; PRUEBA DE MAX_
;=========================================================

.model small
.stack 100h

.data

    arreglo DB 100,-50,120,-10,5

    mensaje DB 13,10,"Maximo = $"

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
    CALL Max_

    ; Guardar resultado
    MOV resultado,AX

    ; Mostrar mensaje
    MOV DX,OFFSET mensaje
    MOV AH,09h
    INT 21h

    ; Recuperar resultado
    MOV AX,resultado

    ; Mostrar AX
    CALL PrintAX

    ; Terminar programa
    MOV AH,4Ch
    INT 21h

main ENDP


;=========================================================
; TU FUNCION MAX_
;=========================================================

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

        JG nuevo_maximo   ; SOOLO ES CAMBIAR ESTO POR QUE DE JL A JG

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


;=========================================================
; IMPRIMIR AX CON SIGNO
;=========================================================

PrintAX PROC

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    ; Revisar si AX es negativo
    CMP AX,0
    JGE positivo

    ; Imprimir signo -
    PUSH AX
    MOV DL,'-'
    MOV AH,02h
    INT 21h
    POP AX

    ; Convertir a positivo
    NEG AX

positivo:

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