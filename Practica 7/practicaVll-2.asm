MODEL small
   .STACK 100h

   ;----- Insert INCLUDE "filename" directives here
   ;----- Insert EQU and = equates here

 INCLUDE procs.inc

       LOCALS

   .DATA


   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

        call clrscr

        ;call printPattern
        ;call newLine
        call printPattern2

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



printPattern PROC
          push ax;salvar registros
          push cx

          mov cx,9 ;contador externo
          mov al,1


@@l1:

          mov ah,0 ;contador
@@l2:     push ax
          add al,30h ;convertir dec a ascii
          call putchar
          pop ax
          inc ah
          cmp ah,al
          jb @@l2

          call newLine

          inc al
          loop @@L1

          pop cx ;recuperar registro
          pop ax
          ret
ENDP

;version con una linea de codigo menos
printPattern2 PROC
        push ax ;salvar registros
        push cx

        xor ax,ax ;pone en 0 el registro
        mov al,'1'
        mov cx,1

    l1:
        call putchar
        loop l1

        call newLine
        inc al
        mov cx,ax
        sub cl,30h
        cmp al,'9'
        jbe l1

        pop cx ;recuperar registros
        pop ax
    ret
ENDP


;imprime salto de linea.
newLine PROC
  push ax
  mov al,13
  call putchar
  mov al,10
  call putchar
  pop ax
  ret
ENDP

         END
