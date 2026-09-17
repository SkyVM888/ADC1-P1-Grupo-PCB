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
    N           DW  8, 1, 4, 4, 64, 64            ; Dimensiones de 16 bits (DW)
    T           DB  5, -7, -5, 5, 126, -128       ; Umbrales de 8 bits con signo (DB)
    Cantidad    EQU  6                             ; Cantidad de arreglos a evaluar

    ; Arreglos definidos
    arreglo1    DB  -12, 0, 18, -5, 127, -128, 18, 5
    arreglo2    DB  -7
    arreglo3    DB  -8, -3, -12, -1
    arreglo4    DB  5, 5, 5, 5
    arreglo5    DB  64 dup (127)
    arreglo6    DB  64 dup (-128)

    ; Matriz de arreglos
    
    Matriz      DW OFFSET arreglo1, OFFSET arreglo2, OFFSET arreglo3 
                DW OFFSET arreglo4, OFFSET arreglo5, OFFSET arreglo6

    ; //// Matrices de cálculos ////

    ; Suma: 16 bits con signo
    suma        DW Cantidad dup (?)

    ; Mínimo: 8 bits con signo
    minimo      DB Cantidad dup (?)

    ; Máximo: 8 bits con signo
    maximo      DB Cantidad dup (?)

    ; Contador Conteo_C (Muestras > T): 16 bits sin signo
    Conteo_C    DW Cantidad dup (?)

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
;                   Funciones de uso general
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

;========================================================================
;               Funciones de calculos de arreglo
;========================================================================

Suma_arreglo PROC   

; -----------------------------------------------PARTE DE LA PILA---------------------------------------------------------
    PUSH BX  ;GUARDAR EN LA PILA 
    PUSH CX
    PUSH SI
    PUSH DX

;---------------------------------------------------------------------------------------------------------------------------

    mov CL,AL  ; Copiar el valor de N a CL  CL=N
    mov CH,0   ; poner el 0 la parte alta 
    
    mov AX,0  
    mov DX,0 
    mov SI,0  ;SI=0 INDICE
    
    MOV BX,BP     ;BX tiene la direccion del arreglo 
;------------------------------------------------------Parte del bulce------------------------------------------------------

    suma_bucle:

        mov AL,[BX+SI] ;leer el elemento del arreglo
        CBW   ; convertir al con signo a AX

        add DX,AX  

        add SI,1     ; debiera de avanzar 1bytes. 
        loop suma_bucle ; repetir mientas cx sea diferente de 0. 

        mov AX,DX  ; pasar a la suma final de ax

        POP DX
        POP SI
        POP CX
        POP BX
        RET

Suma_arreglo ENDP

Max_arreglo PROC
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
Max_arreglo ENDP

Min_arreglo PROC
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

Min_arreglo ENDP

Mayor_T_arreglo PROC
    PUSH BX
    PUSH CX
    PUSH SI
    PUSH DX

    MOV CL,AL       ; GUARDAR N
    MOV CH,0

    MOV SI,0        ; INDICE = 0

    MOV BX,BP       ; BX TIENE LA DIRECCION DEL ARREGLO

    MOV AX,0        ; AX VA A CONTAR LOS MAYORES

    bucle: 
         
         mov DH, [BX+SI] ; leer elemento 
         CMP DH,DL ; comparar el elemento con T 
         jg esmayor ; // el salto que tiene que dar si es mayo a la otra etiqueta; 

        mayor_continuar:
        add SI,1 ; avanza 1  byte 
        loop bucle
        POP DX
        POP SI
        POP CX
        POP BX

        RET
    esmayor:
            ADD AX,1 ; aumenta el contador 

            jmp mayor_continuar 
Mayor_T_arreglo ENDP


;========================================================================
;                 Loop Principal para recorrer los arreglos
;========================================================================


; Loop_principal: De entrada recibe un matriz de arreglos (BX), de salida guarda los datos en Calculos
Main_loop PROC
    MOV CL, Cantidad        ; Cargar el número de filas en CL
    XOR CH, CH              ; Asegurar CX para el control de LOOP
    
    XOR SI, SI              ; SI: Índice para recorrer punteros y N (2 bytes c/u)
    XOR DI, DI              ; DI: Índice para resultados (1 byte c/u)

    bucle_filas:
        PUSH CX                 ; Se guarda el contador del bucle en pila
        PUSH BX

        ; 1. Extracción del tamaño N correspondiente al arreglo actual
        MOV AX, N[SI]           ; AX = N_actual

        ; 2. Evaluación condición: 1 <= N <= 64 (con signo)
        CMP AX, 1
        JB arreglo_invalido     ; Salta si N < 1
        CMP AX, 64
        JA arreglo_invalido     ; Salta si N > 64

        ; 3. Obtener la dirección base del arreglo actual desde la Matriz
        MOV BP, [BX + SI]       ; BP apunta al inicio del arreglo (DB) en la fila actual

        ; 4. Calcular el offset para arreglos DW de 16 bits (BX_offset = DI * 2)
        MOV BX, DI
        SHL BX, 1               ; BX_offset = DI * 2

        ; 4. Procesamiento por arreglo   
        ; --- Suma
        PUSH AX             ; Preservar N en la pila
        CALL Suma_arreglo
        MOV suma[BX], AX
        POP AX              ; Restaurar N en AX

        ; --- Mínimo
        PUSH AX
        CALL Min_arreglo
        MOV minimo[DI], AL
        POP AX

        ; --- Máximo
        PUSH AX
        CALL Max_arreglo
        MOV maximo[DI], AL
        POP AX

        ; --- Conteo Mayor a T
        MOV DL, T[DI]       ; Cargar umbral T de la fila en DL
        CALL Mayor_T_arreglo
        MOV Conteo_C[BX], AX

        JMP continuar_bucle

    arreglo_invalido:
        ; 5. Inserción de error (FFFFh / FFh) para arreglos invalidados
        MOV BX, DI
        SHL BX, 1               ; Offset para arreglos DW (16 bits)
        
        MOV suma[BX], 0FFFFh
        MOV minimo[DI], 0FFh
        MOV maximo[DI], 0FFh
        MOV Conteo_C[BX], 0FFFFh

    continuar_bucle:
        ; 6. Actualización de índices para la siguiente iteración
        ADD SI, 2               ; Avanzar al siguiente elemento de N y puntero de Matriz (2 bytes)
        INC DI               ; Avanzar a la siguiente fila de Calculos (8 bytes)

        POP BX                  ; restaurar la matriz de arreglos
        POP CX                  ; Se restaura el contador del bucle
        LOOP bucle_filas        ; Decrementar CX; si CX != 0, repetir el ciclo
    
        RET
Main_loop ENDP

end main