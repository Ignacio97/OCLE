MODEL small
   .STACK 100h




 INCLUDE procs.inc

       LOCALS

   .DATA


   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

				call clrscr

        xor ah,ah ;ah=0

        base = 2
        numero = 080h
        bit = 7

        mov bx,base
        mov cx,bit
        mov al,numero
			  call getBit
        call printNumBase





				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP




;Devuelve en Al el valor del bit dado por cx.
;Ejemplo Al= 80h cx=7 daria como resultado al=1.
getBit PROC
  push cx
  inc cl
  ror al,cl
  jnc @@nohaycarry
  mov al,1
  jmp @@fiiin
  @@nohaycarry: mov al,0
  @@fiiin:
  pop cx
  ret
ENDP





;Imprime el numero dado en ax en la base solicitada dada en bx.
;Ejemplo : Ax = 80h Bx=2 imprimiria "1000 0000"
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
