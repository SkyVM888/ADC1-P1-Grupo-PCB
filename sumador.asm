;sumador 
;Creador Carlos Hurtado Villalobos


;Entrada : BP=es el arreglo, AL=N
;SALIDA TIENE QUE SER LA SUMA = AX

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
