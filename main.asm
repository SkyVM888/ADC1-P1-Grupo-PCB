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
    N           DW  8, 1, 4, 4, 64, 64, 0, 65       ; Dimensiones de 16 bits (DW)
    T           DB  5, -7, -5, 5, 126, -128, 1, 1   ; Umbrales de 8 bits con signo (DB)
    Cantidad    EQU  8                              ; Cantidad de arreglos a evaluar

    ; Arreglos definidos
    arreglo1    DB  -12, 0, 18, -5, 127, -128, 18, 5
    arreglo2    DB  -7
    arreglo3    DB  -8, -3, -12, -1
    arreglo4    DB  5, 5, 5, 5
    arreglo5    DB  64 dup (127)
    arreglo6    DB  64 dup (-128)
    arreglo7    DB  64 dup (1)
    arreglo8    DB  64 dup (1)

    ; Matriz de arreglos
    
    Matriz      DW OFFSET arreglo1, OFFSET arreglo2, OFFSET arreglo3 
                DW OFFSET arreglo4, OFFSET arreglo5, OFFSET arreglo6
                DW OFFSET arreglo7, OFFSET arreglo8

    ; //// Matrices de cálculos ////

    ; Suma: 16 bits con signo
    suma        DW Cantidad dup (?)

    ; Mínimo: 8 bits con signo
    minimo      DB Cantidad dup (?)

    ; Máximo: 8 bits con signo
    maximo      DB Cantidad dup (?)

    ; Contador Conteo_C (Muestras > T): 16 bits sin signo
    Conteo_C    DW Cantidad dup (?)

    ; //// Mensajes de impresión ////

    msg_arreglo     DB  'Arreglos$'
    msg_N           DB  'N$'
    msg_T           DB  'T$'
    msg_minimo      DB  'Min$'
    msg_maximo      DB  'Max$'
    msg_suma        DB  'Suma$'
    msg_conteo      DB  'Conteo_C$'
    msg_error       DB  'ERROR$'

    salto_linea     DB  13, 10, '$'
    linea_tabla     DB  '------------------------------------------------------------------',13,10,'$'

;========================================================================
.code

main PROC
    ; Inicio de programa
    CALL start

    ; Inicio del Loop Principal
    MOV BX, OFFSET Matriz   ; <---------Asignar Matriz de arreglos
    CALL Main_loop

    ; Imprimir resultados
    CALL Print_results

    ; Imprimir 2 saltos de línea para empujar el cursos hacia abajo
    MOV DX, OFFSET salto_linea
    CALL print
    MOV DX, OFFSET salto_linea
    CALL print

    CALL endprogram
main ENDP

;========================================================================
;                   Funciones de uso general
;========================================================================

; Funcion de inicio
start PROC
    ; Inicializacion
    MOV AX, @data
    MOV DS, AX

    ;limpiar pantalla
    MOV AH,00h
    MOV AL,03h
    INT 10h
    
    ret
start ENDP

; Funcion de imprimir una cadena completa de texto terminada en $
print PROC
    MOV AH, 09h
    INT 21h
    ret
print ENDP

; Funcion de imprimir un solo caracter
print_char PROC
    MOV AH, 02h
    INT 21h
    ret
print_char ENDP

; Funcion de imprimir TAB
print_tab PROC
    MOV DL, 09h
    MOV AH, 02h
    INT 21h
    ret
print_tab ENDP

; Funcion de imprimir texto + TAB
print_tabla PROC
    CALL print
    CALL print_tab
    ret
print_tabla ENDP

; Funcion de imprimir numero
Print_num PROC

    ; Preservar el estado de los registros en la pila
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    ; Verificar si el número es negativo
    CMP AX, 0               ; Comparar el valor en AX con 0
    JGE numero_positivo     ; Salta si es mayor o igual a 0 (positivo)

    ; Imprimir signo negativo
    PUSH AX                 ; Guardar temporalmente AX mientras se imprime el signo
    MOV DL, '-'             ; Carácter '-' para la salida
    CALL print_char
    POP AX                  ; Restaurar el valor original de AX

    ; Convertir el número a positivo
    NEG AX                  ; Convertir el número a positivo (Complemento a 2)

    numero_positivo:

        ; Caso especial: AX = 0
        CMP AX, 0
        JNE convertir       ; Si AX != 0, proceder con la división

        MOV DL, '0'         ; Imprimir directamente el carácter '0'
        CALL print_char
        JMP fin_num         ; Salir de la función

    convertir:

        XOR CX, CX          ; CX = 0 (Contador para llevar la cantidad de dígitos)
        MOV BX, 10          ; BX = 10 (Divisor para extraer dígitos en base 10)

    dividir:

        XOR DX, DX          ; Limpiar DX
        DIV BX              ; División DX = AX / BX -> Cociente queda en AX, Residuo en DX
                            ; El residuo (DX) representa el dígito actual (0-9)

        PUSH DX             ; Guardar el dígito en la pila (para invertir el orden al imprimir)
        INC CX              ; Incrementar el contador de dígitos en CX

        CMP AX, 0           ; Verifica si quedan más dígitos
        JNE dividir         ; Si AX != 0, continuar dividiendo

    imprimir_digitos:

        POP DX                  ; Obtener el dígito almacenado más reciente
        ADD DL, '0'             ; Convertir el valor numérico a su equivalente en ASCII (DL + 48)
        CALL print_char
        LOOP imprimir_digitos   ; Decrementar CX e iterar hasta imprimir todos los dígitos

    fin_num:

        ; Restaurar el estado previo de los registros
        POP DX
        POP CX
        POP BX
        POP AX

        ret

Print_num ENDP

; Imprimir resultados en formato de tabla
Print_results PROC

    ; Preservar el contexto de los registros en la pila
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI

    XOR DI, DI                  ; DI = índice de arreglo
    MOV CX, Cantidad            ; CX = cantidad de arreglos

    ; ============================= Encabezado de la tabla =============================

    MOV DX, OFFSET msg_arreglo
    CALL print_tabla

    MOV DX, OFFSET msg_N
    CALL print_tabla

    MOV DX, OFFSET msg_T
    CALL print_tabla

    MOV DX, OFFSET msg_minimo
    CALL print_tabla

    MOV DX, OFFSET msg_maximo
    CALL print_tabla

    MOV DX, OFFSET msg_suma
    CALL print_tabla

    MOV DX, OFFSET msg_conteo
    CALL print

    MOV DX, OFFSET salto_linea
    CALL print

    ; Línea separadora
    MOV DX, OFFSET linea_tabla
    CALL print

    ; ============================= Imprimir filas =============================

    imprimir_arreglo:

    ; -----------------------------------------
    ; Arreglo
    ; -----------------------------------------

    MOV AX, DI          ; Cargamos el índice del arreglo en AX
    INC AX              ; Incrementamos para que la numeración comience desde 1
    CALL Print_num
    CALL print_tab
    CALL print_tab      ; Doble TAB para mantener la alineación

    ; -----------------------------------------
    ; N
    ; -----------------------------------------

    MOV SI, DI
    SHL SI, 1           ; SI = DI * 2 (Calcula el offset para arreglos DW)

    MOV AX, N[SI]       ; Cargar dimensión N correspondiente
    CALL Print_num
    CALL print_tab

    ; -----------------------------------------
    ; T
    ; -----------------------------------------

    XOR AX, AX
    MOV AL, T[DI]       ; Cargar umbral de 8 bits
    CBW                 ; Extender el signo de AL a AX para su correcta impresión
    CALL Print_num
    CALL print_tab

    ; -----------------------------------------
    ; Verificar si el arreglo es inválido
    ; -----------------------------------------

    CMP Conteo_C[SI], 0FFFFh    ; Evaluar si el contador almacena la bandera de error (-1)
    JE imprimir_error           ; Si es inválido, saltar a la sección de impresión de "ERROR"

    ; -----------------------------------------
    ; Minimo
    ; -----------------------------------------

    XOR AX, AX
    MOV AL, minimo[DI]
    CBW                         ; Extensión de signo de AL a AX
    CALL Print_num
    CALL print_tab

    ; -----------------------------------------
    ; Maximo
    ; -----------------------------------------

    XOR AX, AX
    MOV AL, maximo[DI]
    CBW                         ; Extensión de signo de AL a AX
    CALL Print_num
    CALL print_tab

    ; -----------------------------------------
    ; Suma
    ; -----------------------------------------

    MOV AX, suma[SI]            ; Cargar resultado de suma de 16 bits
    CALL Print_num
    CALL print_tab

    ; -----------------------------------------
    ; Conteo_C
    ; -----------------------------------------

    MOV AX, Conteo_C[SI]        ; Cargar la cantidad de elementos mayores a T
    CALL Print_num

    JMP siguiente_arreglo       ; Continuar con la siguiente fila

    ; -----------------------------------------
    ; Caso de error
    ; -----------------------------------------

    imprimir_error:             ; Imprime "ERROR" en las columnas de Min, Max, Suma y Conteo_C

    ; Minimo
    MOV DX, OFFSET msg_error
    CALL print
    CALL print_tab

    ; Maximo
    MOV DX, OFFSET msg_error
    CALL print
    CALL print_tab

    ; Suma
    MOV DX, OFFSET msg_error
    CALL print
    CALL print_tab

    ; Conteo_C
    MOV DX, OFFSET msg_error
    CALL print

    ; -----------------------------------------
    ; Siguiente arreglo
    ; -----------------------------------------

    siguiente_arreglo:

    MOV DX, OFFSET salto_linea
    CALL print

    INC DI                      ; Avanzar al siguiente índice de arreglo
    DEC CX                      ; Decrementar el contador de control de filas
    JZ fin_print_results        ; Si CX = 0, se procesaron todos los arreglos

    JMP imprimir_arreglo

    ; -----------------------------------------
    ; Final de resultados
    ; -----------------------------------------

    fin_print_results:

    ; Restaurar todos los registros previamente salvaguardados
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX

    ret

Print_results ENDP

; Cierre de Programa
endprogram PROC
    MOV AH, 4Ch
    INT 21h
    ret
endprogram ENDP

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

    MOV CL,AL  ; Copiar el valor de N a CL  CL=N
    MOV CH,0   ; poner el 0 la parte alta 
    
    MOV AX,0  
    MOV DX,0 
    MOV SI,0  ;SI=0 INDICE
    
    MOV BX,BP     ;BX tiene la direccion del arreglo 
;------------------------------------------------------Parte del bulce------------------------------------------------------

    suma_bucle:

        MOV AL,[BX+SI] ;leer el elemento del arreglo
        CBW   ; convertir al con signo a AX

        ADD DX,AX  

        ADD SI,1     ; debiera de avanzar 1bytes. 
        LOOP suma_bucle ; repetir mientas cx sea diferente de 0. 

        MOV AX,DX  ; pasar a la suma final de ax

        POP DX
        POP SI
        POP CX
        POP BX
        ret

Suma_arreglo ENDP

Max_arreglo PROC
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV CX,AX ; GUARDAR EL N completo 
    CMP CX,0   
    JE max_cero   ; N==0 preguntar 

    XOR SI,SI ; HACERLO 0 QUE ES LO MISMO QUE USAR EL MOV,0
    MOV BX,BP   ; direc del array 
    MOV AL,[BX + SI] ; PRIMER ELEMENTO  como minimo incial. 

    INC SI ; avanzar al siguiente elemento
    DEC CX  ; decrementar n tras procesar el elememento   
    JZ fin_max ; si n=1 no entrar al ciclo por que es un solo elemento

    max_bug: 

        MOV DL, [BX + SI]
        CMP DL,AL ;COMPARAR ELEMENTOS CON EL MINIMO ACTUAL

        JLE nomayor   ; si DL mayor o igual a  AL, nuevo minimo ; aca cambiar el de maximo. ##
        MOV AL,DL  ; actualización 

    nomayor:
        INC SI
        LOOP max_bug
        JMP fin_max

    max_cero:
        MOV AL,80h 
   ;//////////////////////////////////////////////////////////////////////////
    fin_max: ; aca; 
        CBW   ; EXTERDER EL SIGNO. 

        POP SI
        POP DX
        POP CX
        POP BX
        ret
Max_arreglo ENDP

Min_arreglo PROC
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI

    MOV CX,AX ; GUARDAR EL N completo 
    CMP CX,0   
    JE min_cero   ; N==0 preguntar 

    XOR SI,SI ; HACERLO 0 QUE ES LO MISMO QUE USAR EL MOV,0
    MOV BX,BP   ; direc del array 
    MOV AL,[BX + SI] ; PRIMER ELEMENTO  como minimo incial. 

    INC SI ; avanzar al siguiente elemento
    DEC CX  ; decrementar n tras procesar el elememento   
    JZ fin_min ; si n=1 no entrar al ciclo por que es un solo elemento

    min_bug: 

        MOV DL, [BX + SI]
        CMP DL,AL ;COMPARAR ELEMENTOS CON EL MINIMO ACTUAL

        JGE nomenor   ; si DL mayor o igual a  AL, nuevo minimo ; aca cambiar el de maximo. ##
        MOV AL,DL  ; actualización 

    nomenor:
        INC SI
        LOOP min_bug
        JMP fin_min

    min_cero:
        MOV AL,7Fh 
   ;//////////////////////////////////////////////////////////////////////////
    fin_min: ; aca; 
        CBW   ; EXTERDER EL SIGNO. 

        POP SI
        POP DX
        POP CX
        POP BX
        ret

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
        ADD SI,1 ; avanza 1  byte 
        LOOP bucle
        POP DX
        POP SI
        POP CX
        POP BX

        ret
    esmayor:
            ADD AX,1 ; aumenta el contador 

            JMP mayor_continuar 
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
    
        ret
Main_loop ENDP

end main
