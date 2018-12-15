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

				call imprime

				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP

; incluir procedimientos
; ejemplo:
; funcionX PROC ; < -- Indica a TASM el inicio del un procedimiento
;               ;
;               ; < --- contenido del procedimiento
;           ret
;           ENDP; < -- Indica a TASM el fin del procedimiento

imprime PROC
  push cx ;backup
  push ax

  mov cx,9
  mov ax,8

  @@l1:

push cx
push ax
sub cx,ax
mov al,cl
add al,30h

  @@l2:
      call putchar
      mov al,13
      call putchar
      mov al,10
      call putchar
  loop @@l2
pop ax
pop cx
sub ax,2

loop @@l1

pop ax
pop cx
ret
ENDP

         END
