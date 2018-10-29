MODEL small
   .STACK 100h

   ;----- Insert INCLUDE "filename" directives here
   ;----- Insert EQU and = equates here

   N EQU 10

 INCLUDE procs.inc

       LOCALS

   .DATA
      mayor       db  'numero mayor a 10',13,10,0
      menorigual    db 'numero menor igual a 10',13,10,0
   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

				call clrscr ;limpia pantalla

;imprime en pantalla si un numero positivo es mayor o menor a 10.
        numero = 9
        mov ax,numero
        cmp ax, N
			  jbe @@L1
        mov dx,offset mayor
        jmp @@L2
@@L1:   mov dx,offset menorigual
@@L2:   call puts

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



         END
