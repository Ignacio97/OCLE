MODEL small
   .STACK 100h

 INCLUDE procs.inc

       LOCALS

   .DATA

   .CODE


    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

        mov ah,62h
        int 21h

        mov es,bx
        mov di,80h

        xor ch,ch
        mov cl,es:[di]

          @@doo: inc di
                  mov dl,es:[di]
                  mov ah,2h
                  int 21h

                  loop @@doo



				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP






         END
