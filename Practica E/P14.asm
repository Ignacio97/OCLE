MODEL small
   .STACK 100h

   ;----- Insert INCLUDE "filename" directives here
   ;----- Insert EQU and = equates here

 INCLUDE procs.inc
		LF EQU 10
        CR EQU 13

       LOCALS
       printNewLine  MACRO

        push ax
        push dx
        mov ah,2

        mov dl,13
        int 21h

        mov dl,10
        int 21h
        pop dx
        pop ax

         ENDM

   .DATA
      mens          db  32 dup(0)
	  archivo         db  32 dup(0)
 	  manejador       dw   ?
	  datos           db   32 dup (0)
	  error_abrir     db   LF,CR,'Error abriendo el archivo: ',0
	  error_leer      db   LF,CR,'Error leyendo el archivo: ',0
	  error_cerrar    db   LF,CR,'Error cerrando el archivo: ',0
	  error_escribir  db   LF,CR,'Error escribiendo al archivo: ',0
    error_crear     db   LF,CR,'Error creando el archivo: ',0

   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

				;call clrscr

        mov bx, offset archivo
        mov dx, offset mens
        call cargaDatos
        printNewLine
        printNewLine
        mov dx,offset mens
        call puts

        mov dx, offset archivo
        call CrearArchivo


				;call AbreArchivo
				;jc @@fin
        ;printNewLine
				;mov dx, offset mens
				;call puts
                call AbreArchivo
                mov bx,[manejador]
                mov dx,offset mens
                call EscribeArchivo
@@cerrar:       call CierraArchivo
@@fin:			call getchar

				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP


;recibe bx apuntado a cadena "nombre de archivo"
;recibe dx apuntador a cadena "mensaje"
cargaDatos PROC
        push es
        push si
        push ax
        push bx


        push bx
        mov ah,62h
        int 21h
        mov es,bx
        pop bx

        mov si,82h
        xor cx,cx

l1:      cmp es:byte ptr[si],' '
                  je el1
                  mov al,es:[si]
                  mov [bx],al
                  inc bx
                  inc si
                  jmp l1

el1:      mov byte ptr[bx],0
          mov bx,dx
          inc si

l2:      cmp es:byte ptr[si],0Dh
                    je el2
                    mov al,es:[si]
                    mov [bx],al
                    inc bx
                    inc si
                    jmp l2

  el2:      mov byte ptr[bx],0


            pop bx
            pop ax
            pop si
            pop es

ret
ENDP

;recibe apuntador en dx a cadena con nombre del archivo(asciiz).
CrearArchivo PROC
        push cx
        push bx
        clc
        mov ah,3ch        ;crea nuevo archivo
        attributes = 0
        mov cx,attributes
        int 21h
        mov bx,ax
        mov ah,03Eh ;Cierra el archivo
        pop bx
        pop cx
ret
ENDP


;recibe bx manejador de archivo
;recibe dx cadena a escribir
;Devuelve cf = 0 y ax byte escritos, caso contrario cf = 1 y ax = codigo de error.
EscribeArchivo PROC
    push cx
    mov ah,40h
    call CuentaCadena
    int 21h
    pop cx
ret
ENDP

;recibe dx apuntador a cadena
;Devuelve en cx la cantidad de caracteres sin contar fin de linea
CuentaCadena PROC
      push bx
      xor cx,cx
      mov bx,dx
      cuenta:  cmp byte ptr[bx],0
                je para
                inc bx
                inc cx
                jmp cuenta
      para:


      pop bx
ret
ENDP


AbreArchivo PROC
         mov dx,offset archivo     ; nombre del archivo
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

LeeArchivo PROC
         mov bx,[manejador]        ; manejador del archivo
		 mov ah,3Fh                ; servicio para leer un archivo
         mov cx,10                 ; se van a leer 10 bytes
         mov dx, offset datos      ; dirección inicial donde se van a almacenar los bytes leídos
         int 21h
         jc @@error                ; la int. activa la bandera de acarreo si ocurre un error
         ret
@@error: mov dx, offset error_leer
         call puts
		 mov dx, offset archivo
         call puts
         stc
         ret
         ENDP



CierraArchivo PROC
          mov bx,[manejador]        ; manejador del archivo
          mov ah,3Eh                ; servicio para cerrar un archivo
          int 21h
          jc @@error               ; la int. activa la bandera de acarreo si ocurre un error
          ret
@@error:  mov dx, offset error_cerrar
          call puts
		  mov dx, offset archivo
          call puts
          stc
          ret
          ENDP




 END
