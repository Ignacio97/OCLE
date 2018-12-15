;Procedimiento que captura solo numeros en formato ascii y los guardad en una cadena.
;Recibe en dx apuntador a cadena donde se guardará los datos capturados.


MODEL small
   .STACK 100h

   ;----- Insert INCLUDE "filename" directives here
   ;----- Insert EQU and = equates here

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

        call getNumber
        call puts

				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP

                getNumber PROC
                    push ax
                    push bx

                    mov bx,dx

                    @@again:  call getchar
                              cmp al,13
                              je @@rtKey    ;si es 13(enter)

                              cmp al,8
                              je isNumber

                              cmp al,'0'
                              jb notNumber
                              cmp al,'9'
                              jbe isNumber

                notNumber:    mov al,8
                              call putchar
                              mov al,32
                              call putchar
                              mov al,8
                              call putchar
                              jmp @@again

                isNumber:
                              cmp al,8  ; al == BS ?
                              jne l1     ;no, then almacenalo
                              cmp bx,dx   ;si then hay algo almacenado ya?
                              jbe @@again  ;no, then pìde otro caracter

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
