MODEL small
   .STACK 100h

   ;----- Insert INCLUDE "filename" directives here
   ;----- Insert EQU and = equates here

 INCLUDE procs.inc
		LF EQU 10
        CR EQU 13

       LOCALS

   .DATA
      mens            db  'Hola Mundo',0
	  archivo         db  'ejemplo.txt',0
 	  manejador       dw   ?
	  datos           db   32 dup (0)
	  error_abrir     db   LF,CR,'Error abriendo el archivo: ',0
	  error_leer      db   LF,CR,'Error leyendo el archivo: ',0
	  error_cerrar    db   LF,CR,'Error cerrando el archivo: ',0
	  error_escribir  db   LF,CR,'Error escribiendo al archivo: ',0
	  error_crear	  db   LF,CR,'Error al crear el archivo: ',0
	  new_line		  db   13,10,0
	  nombre_archivo  db  32 Dup(?)
 	  txt			  db  ?

   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)
				mov ax,0

		   		mov ah,62h
		   		mov al,0
		   		int 21h

		   		mov es,bx
		   		mov si,82h
		   		mov di,0

				call clrscr
@@nombreArchivo:
				mov dl,es:[si]
				cmp dl,' '
				je @@texto
				mov nombre_archivo[di],dl
				inc si
				inc di
				jmp @@nombreArchivo

		@@texto:
				inc si
				mov nombre_archivo[di],0
				mov di,0
   @@copiaTexto:
   				mov dl,es:[si]
   				cmp dl, 13
   				je @@finParametros
   				mov txt[di],dl
   				inc si
   				inc di
   				jmp @@copiaTexto


@@finParametros:
				mov txt[di],0
				mov dx, offset nombre_archivo
				call puts
				mov dx, offset new_line
				call puts
				mov dx, offset txt
				call puts
				;call CrearArchivo
				;jc @@fin
				;call AbreArchivo
				;jc @@fin
				;call LeeArchivo
				;jc @@cerrar
				;mov dx, offset datos
				;call puts
                ;call EscribeArchivo
@@cerrar:
				;call CierraArchivo
@@fin:
			;	call getchar

				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP

;***************************************************

AbreArchivo PROC
         mov dx,offset nombre_archivo     ; nombre del archivo
		 mov ah,3Dh                ; servicio para abrir un archivo
         mov al,2h                 ; modo lectura/escritura
         int 21h
         jc @@error                ; la int. activa la bandera de acarreo si ocurre un error
         mov [manejador],ax        ; almacenar el manejador del archivo
         ret
@@error: mov dx,offset error_abrir
         call puts
         mov dx, offset archivo
         call puts
         stc
         ret
         ENDP

;***************************************************

LeeArchivo PROC
         mov bx,[manejador]        ; manejador del archivo
		 mov ah,3Fh                ; servicio para leer un archivo
         mov cx,10                 ; se van a leer 10 bytes
         mov dx, offset datos      ; dirección inicial donde se van a almacenar los bytes leídos
         int 21h
         jc @@error                ; la int. activa la bandera de acarreo si ocurre un error
         ret
@@error:
		 mov dx, offset error_leer
         call puts
		 mov dx, offset archivo
         call puts
         stc
         ret
         ENDP

;***************************************************

CierraArchivo PROC
          mov bx,[manejador]        ; manejador del archivo
          mov ah,3Eh                ; servicio para cerrar un archivo
          int 21h
          jc @@error               ; la int. activa la bandera de acarreo si ocurre un error
          ret
@@error:
		  mov dx, offset error_cerrar
          call puts
		  mov dx, offset archivo
          call puts
          stc
          ret
          ENDP

;***************************************************

EscribeArchivo PROC
			   mov bx,[manejador]		; manejador del archivo
			   mov ah,40h				; servicio para escribir en un archivo
			   mov cx,10				; se van a escribir 10 bytes
			   mov dx, offset txt		; dirección inicial donde se van a tomar los bytes a escribir en el archivo
			   int 21h
			   jc @@error
			   ret

	   @@error:
	   			mov dx, offset error_abrir
	   			call puts
	   			mov dx, offset archivo
	   			call puts
	   			stc
	   			ret
			   ENDP

;***************************************************
  CrearArchivo PROC
  				mov ax,3CH 					;servicio para crear archivo
  				mov cx,00H 					;atributos del archivo/ normal
  				mov dx,offset archivo 		;nombre del archivo
  				int 21h
  				jc @@error
  				ret

  		@@error:
  				mov dx, offset error_crear
  				call puts
  				mov dx, offset archivo
  				call puts
  				stc
  				ret

  				ENDP


 END
