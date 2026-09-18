;Carlos Hurtado

;ENTRADA BP = DIRECCION ARREGLO
;AL = N
;DL = T

;SALIDA AX = CANTIDAD MAYORES A T


Mayor_ PROC

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
         jg esmayor ; // el salto que tiene que dar si es mayo a la otra etiqueta;  # aca 

    

    continuar:
        add SI,1 ; avanza 1  byte 
        loop bucle
        POP DX
        POP SI
        POP CX
        POP BX

        RET


    esmayor:
            ADD AX,1 ; aumenta el contador 

            jmp continuar 
Mayor_ ENDP




