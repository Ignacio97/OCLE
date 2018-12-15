MODEL small
   .STACK 100h

INCLUDE procs.inc

       LOCALS

   .DATA
      cadena  db 32 dup(?)
   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)
				call clrscr

        mov dx,offset cadena
				call myGetch
        call puts

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


myGetch PROC
    push ax
    push bx


    mov bx,dx

    @@again:  call getchar
              cmp al,13
              je @@rtKey ;si es 13(enter)
              mov [bx],al
              inc bx
              jmp @@again
@@rtKey:
              mov byte ptr[bx],0

              pop bx
              pop ax
ret
ENDP

         END
