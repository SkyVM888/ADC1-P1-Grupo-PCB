;sumador 
;Creador Carlos Hurtado Villalobos


;Entrada : BP=es el arreglo, AL=N
;SALIDA TIENE QUE SER LA SUMA = AX

Suma_arreglo PROC   

    PUSH BX  ;GUARDAR EN LA PILA 
    PUSH CX
    PUSH SI

    mov AX,0  ;Acomulador AX=0
    mov SI,0  ;SI=0 INDICE

    mov CL,AL  ; Copiar el valor de N a CL  CL=N
    mov CH,0   ; poner el 0 la parte alta 

    suma_bucle:

        mov BX,[BP+SI] ;leer el elemento del arreglo
        add AX,BX    ; AX=AX+BX
        add SI,2     ; debiera de avanzar 2 bytes pero si cambiamos el dato a DB debe de ser 1. 
        loop suma_bucle ; repetir mientas cx sea diferente de 0. 

    POP SI
    POP CX
    POP BX

    RET

Suma_arreglo ENDP
