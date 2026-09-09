;========================================================================
; 
; Titulo: Main_Loop 0.1
; Autor: Brayan Ariel Vargas Rojas
;
;========================================================================
.model small

;========================================================================
.stack 100h

;========================================================================
.data
    ; Datos de los arreglos
    N           DB  5, 5, 5
    T           DW  30, 35, 200

    ; Arreglos definidos (con signo)
    arreglo1    DW  10, 20, 30, 40, 50
    arreglo2    DW  15, 25, 35, 45, 55
    arreglo3    DW  100, 200, 300, 400, 500

    ; Matriz de arreglos
    Cantidad    DB  3
    Matriz      DW OFFSET arreglo1, OFFSET arreglo2, OFFSET arreglo3

    ; Dimensiones de la matriz de resultados
    CALC_FILAS    EQU 3     ; Una fila por cada arreglo origen
    CALC_COLUMNAS EQU 4     ; 4 cálculos por arreglo (Suma, Min, Max, Mayores a T)

    ; Matriz de cálculos: 3 filas x 4 columnas de 16 bits (DW)
    Calculos      DW CALC_FILAS * CALC_COLUMNAS dup (?)

;========================================================================
.code

main proc
    ;Inicio de programa
    call start

    ;Inicio del Loop Principal
    mov BX, OFFSET Matriz; <---------Asignar Matriz de arreglos
    call Main_loop

    call endprogram
main endp

;========================================================================
;               Funciones de uso general
;========================================================================
; Funcion de inicio
start proc
    ; Inicializacion
    mov AX,@data
    mov DS,AX

    ret
start endp

; Funcion de imprimir
print proc
    mov AH,09h
    int 21h
    ret
print endp

; Cierre de Programa
endprogram proc
    mov AH,4Ch
    int 21h
    ret
endprogram endp

; Loop_principal: De entrada recibe un matriz de arreglos (BX), de salida guarda los datos en Calculos
Main_loop PROC
    MOV CL, Cantidad        ; Cargar el número de filas en CL
    XOR CH, CH              ; Asegurar CX para el control de LOOP
    
    XOR SI, SI              ; SI: Índice para recorrer la Matriz de punteros
    XOR DI, DI              ; DI: Índice para recorrer la matriz de Calculos

    bucle_filas:
        PUSH CX ; Se guarda el contador del bucle en pila, en caso de utilizarse en bucles internos

        ; 1. Extracción del tamaño N correspondiente al arreglo actual
        PUSH BX                 ; Resguardar el puntero base de la Matriz
        MOV BX, SI              
        SHR BX, 1               ; BX = SI / 2 (Índice del arreglo: 0, 1, 2)
        MOV AL, N[BX]           ; AL = Dimensión N del arreglo actual
        POP BX                  ; Restaurar el puntero base de la Matriz

        ; 2. Evaluación condición: 1 =< N =< 64
        CMP AL, 1
        JBE arreglo_invalido    ; Salta si N <= 1
        CMP AL, 64
        JAE arreglo_invalido    ; Salta si N >= 64

        ; 3. Obtener la dirección base del arreglo actual desde la Matriz
        MOV BP, [BX + SI]       ; BP apunta al inicio del arreglo en la fila actual

        ; 4. Procesamiento por fila (Proximamente se añadiran las funciones de suma, min, max y mayor_a_T) 
        ; Almacenamiento en la fila correspondiente de Calculos (4 columnas de 16 bits = 8 bytes por fila)
        ; call sum_arreglo  
        MOV WORD PTR [Calculos + DI + 0], 150  ; Suma del arreglo actual
        ; call Min_arreglo
        MOV WORD PTR [Calculos + DI + 2], 200  ; Mínimo del arreglo actual
        ; call Max_arreglo  
        MOV WORD PTR [Calculos + DI + 4], 300  ; Máximo del arreglo actual
        ; call Mayor_a_T
        MOV WORD PTR [Calculos + DI + 6], 400  ; Conteo mayores a T del arreglo actual

        ; 5. Actualización de índices para la siguiente iteración
        ADD SI, 2               ; Avanzar al siguiente puntero de la Matriz
        ADD DI, 8               ; Avanzar a la siguiente fila de Calculos

        POP CX                  ; Se restaura el contador del bucle
        LOOP bucle_filas        ; Decrementar CX; si CX != 0, repetir el ciclo

        JMP continuar_bucle     ; Omitir la escritura de la señal de error

    arreglo_invalido:
        ; 6. Inserción de señal indicadora (FFFFh) para arreglos descartados
        MOV WORD PTR [Calculos + DI + 0], 0FFFFh
        MOV WORD PTR [Calculos + DI + 2], 0FFFFh
        MOV WORD PTR [Calculos + DI + 4], 0FFFFh
        MOV WORD PTR [Calculos + DI + 6], 0FFFFh

    continuar_bucle:
        ; 7. Actualización de índices para la iteración subsecuente
        ADD SI, 2               ; Avanzar al siguiente puntero de la Matriz
        ADD DI, 8               ; Avanzar a la siguiente fila de Calculos

        POP CX                  ; Se restaura el contador del bucle
        LOOP bucle_filas        ; Decrementar CX; si CX != 0, repetir el ciclo
    
        RET
Main_loop ENDP

end main