;sumador 
;Creador Carlos Hurtado Villalobos


;Entrada : BP=es el arreglo, AL=N
;SALIDA TIENE QUE SER LA SUMA = AX

Suma_arreglo PROC   

    PUSH BX  ;GUARDAR EN LA PILA 
    PUSH CX
    PUSH SI
    PUSH DX



    mov DL,AL ; guardar N
    mov AX,0  ;Acomulador AX=0
    mov SI,0  ;SI=0 INDICE

    mov CL,DL  ; Copiar el valor de N a CL  CL=N
    mov CH,0   ; poner el 0 la parte alta 

    suma_bucle:

        mov BL,[BP+SI] ;leer el elemento del arreglo
        add AX,BX    ; AX=AX+B
        add SI,1     ; debiera de avanzar 1bytes. 
        loop suma_bucle ; repetir mientas cx sea diferente de 0. 

    POP SI
    POP CX
    POP BX
    POP DX

    RET

Suma_arreglo ENDP
