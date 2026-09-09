;========================================================================
; 
; Titulo: Main 0.2
; Autores:  Carlos Daniel Hurtado Villalobos
;           Luis Pablo Vargas Muñoz
;           Brayan Ariel Vargas Rojas
;           
;========================================================================
.model small

;========================================================================
.stack 100h

;========================================================================
.data
    ; Datos de los arreglos
    N           DW  5, 5, 5             ; Dimensiones de 16 bits (DW)
    T           DB  30, 35, 100         ; Umbrales de 8 bits con signo (DB)

    ; Arreglos definidos
    arreglo1    DB  10, 20, 30, 40, 50
    arreglo2    DB  15, 25, 35, 45, 55
    arreglo3    DB  100, -50, 120, -10, 5

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
    ; Inicio de programa
    call start

    ; Inicio del Loop Principal
    mov BX, OFFSET Matriz   ; <---------Asignar Matriz de arreglos
    call Main_loop

    call endprogram
main endp

;========================================================================
;               Funciones de uso general
;========================================================================
; Funcion de inicio
start proc
    ; Inicializacion
    mov AX, @data
    mov DS, AX

    ;limpiar pantalla
    mov AH,00h
    mov AL,03h
    int 10h
    
    ret
start endp

; Funcion de imprimir
print proc
    mov AH, 09h
    int 21h
    ret
print endp

; Cierre de Programa
endprogram proc
    mov AH, 4Ch
    int 21h
    ret
endprogram endp

; Loop_principal: De entrada recibe un matriz de arreglos (BX), de salida guarda los datos en Calculos
Main_loop PROC
    MOV CL, Cantidad        ; Cargar el número de filas en CL
    XOR CH, CH              ; Asegurar CX para el control de LOOP
    
    XOR SI, SI              ; SI: Índice para recorrer la Matriz de punteros y la tabla N (2 bytes c/u)
    XOR DI, DI              ; DI: Índice para recorrer la matriz de Calculos (8 bytes por fila)

bucle_filas:
    PUSH CX                 ; Se guarda el contador del bucle en pila

    ; 1. Extracción del tamaño N (16 bits) correspondiente al arreglo actual
    MOV AX, N[SI]           ; AX = Dimensión N de 16 bits del arreglo actual

    ; 2. Evaluación condición: 1 <= N <= 64 (con signo)
    CMP AX, 1
    JL arreglo_invalido     ; Salta si N < 1
    CMP AX, 64
    JG arreglo_invalido     ; Salta si N > 64

    ; 3. Obtener la dirección base del arreglo actual desde la Matriz (elementos DB)
    MOV BP, [BX + SI]       ; BP apunta al inicio del arreglo (DB) en la fila actual

    ; 4. Procesamiento por fila (Próximamente se añadirán las funciones de suma, min, max y mayor_a_T) 
    ; Almacenamiento en la fila correspondiente de Calculos (4 columnas de 16 bits = 8 bytes por fila)
    ; call sum_arreglo  
    MOV WORD PTR [Calculos + DI + 0], 20   ; Suma del arreglo actual
    ; call Min_arreglo
    MOV WORD PTR [Calculos + DI + 2], 30   ; Mínimo del arreglo actual
    ; call Max_arreglo  
    MOV WORD PTR [Calculos + DI + 4], -20  ; Máximo del arreglo actual
    ; call Mayor_a_T
    MOV WORD PTR [Calculos + DI + 6], -30  ; Conteo mayores a T del arreglo actual

    JMP continuar_bucle     ; Omitir la escritura de la señal de error

arreglo_invalido:
    ; 5. Inserción de señal indicadora (FFFFh) para arreglos descartados
    MOV WORD PTR [Calculos + DI + 0], 0FFFFh
    MOV WORD PTR [Calculos + DI + 2], 0FFFFh
    MOV WORD PTR [Calculos + DI + 4], 0FFFFh
    MOV WORD PTR [Calculos + DI + 6], 0FFFFh

continuar_bucle:
    ; 6. Actualización de índices para la siguiente iteración
    ADD SI, 2               ; Avanzar al siguiente elemento de N y puntero de Matriz (2 bytes)
    ADD DI, 8               ; Avanzar a la siguiente fila de Calculos (8 bytes)

    POP CX                  ; Se restaura el contador del bucle
    LOOP bucle_filas        ; Decrementar CX; si CX != 0, repetir el ciclo
    
    RET
Main_loop ENDP

end main