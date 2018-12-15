MODEL small
   .STACK 100h

INCLUDE procs.inc

       LOCALS

   .DATA
      cadena  db 32 dup(?)
      cad  db 'Escriba algo:',0
   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)
				call clrscr

        mov dx,offset cad
        call puts

        mov dx,offset cadena
				call myGetch
        call puts

				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP



myGetch PROC
    push ax
    push bx

    mov bx,dx

    @@again:  call getchar
              cmp al,13
              je @@rtKey    ;si es 13(enter)

              cmp al,8  ; al == BS ?
              jne l1     ;no, then almacenalo
              cmp bx,dx   ;si then hay algo almacenado ya?
              jne l2   ;si hay algo

              push ax ;no hay algo
              mov al,00 ;14 = desplazamiento derecha
              call putchar
              pop ax

              jmp @@again  ;no, then pìde otro caracter

            l2:
              push ax       ;si, then borra el caracter anterior.
              char = 32     ;WS ascii
              mov ax,char
              call putchar
              char = 8      ;BS ascii
              mov ax,char
              call putchar
              dec bx        ;decrementa indice
              pop ax

              jmp @@again   ;empieza de nuevo


        l1:   mov [bx],al
              inc bx
              jmp @@again
@@rtKey:
              mov byte ptr[bx],0

              pop bx
              pop ax
ret
ENDP

         END
