MODEL small
   .STACK 100h

   ;----- Insert INCLUDE "filename" directives here
   ;----- Insert EQU and = equates here

 INCLUDE procs.inc

       LOCALS

   .DATA
      mens       db  'Hola Mundo',0

   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

				call clrscr

        xor cx,cx
        mov al,5
        call fibonacci
        mov bx,10
        call printNumBase



				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP

reserva PROC
      push ax
      push bx
      push cx

      xor dx,dx
      xor cx,cx


      wh: cmp ax,0
        je endw

        mov bl,10
        div bl     ;al=ax/10 cociente
        mov cl,ah   ;guardar residuo
        mov ch,al
        mov ax,dx
        mul bl



        jmp wh
    endw:


    pop cx
    pop bx
    pop ax
ret
ENDP




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
