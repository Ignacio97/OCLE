;Programa que implementa la funcion atoi.


MODEL small
   .STACK 100h


 INCLUDE procs.inc

       LOCALS

   .DATA
   cad db '65535',0

   .CODE

    Principal  	PROC

				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

        call clrscr

        mov bx,offset cad
        call atoi

        base = 10
        mov bx,base
        call printNumBase

        mov ah,04ch	     ; fin de programa
        mov al,0             ;
        int 21h              ;



  ENDP

;Procedimiento que recibe en bx el offset de la cadena en formato decimal
;Pone en ax el valor numero correspondiente a dicha cadena.
;Numero minimo 0
;Numero maximo FFFFh (65535d)

  atoi PROC
      push bx
      push cx
      push dx

      xor ax,ax       ;poner registros en 0.
      xor cx,cx
      xor dx,dx

        base=10
        mov cx,base

  wh:   cmp byte ptr[bx],0  ;cadena vacia?
        je fin              ;si then fin.

        mov dl,[bx]           ;no then trae caracter de cad[bx]
        sub dl,'0'            ;convertir a decimal

        add ax,dx             ;sumarlo a ax


        cmp byte ptr[bx+1],0  ;cad[bx+1]  = 0 ?
        je fin                ;si then termina proc
                              ;no then multiplica ax por 10
        mul cx
        inc bx                ;incrementa indice


        jmp wh                 ;repite proceso

fin:    pop dx      ;recupera registros.
        pop cx
        pop bx

ret               ;termina proc
ENDP


;Imprime un numero dado en ax en la base solicitada dada en bx.
;ax = numero
;bx = base
printNumBase PROC
    push ax ;salvar registros
    push cx
    push dx

    xor dx,dx ;dx=0
    contador = 0
    mov cx,contador

doo:
    div bx      ;ax=ax/bx
    add dx,30h  ;dx=ax%bx + 30h
    cmp dx,39h  ;residuo mayor a 9?
    jbe l1      ;no then push
    add dx,7h   ;si, then add 7
l1:   push dx
    inc cx
    xor dx,dx ;dx=0
    cmp ax,0  ;cociente != 0 ?
    jne doo


print:  pop ax
    call putchar
    loop print

    pop dx  ;recuperar registros
    pop cx
    pop ax


    ret
ENDP


         END
