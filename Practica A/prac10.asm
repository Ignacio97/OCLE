MODEL small
   .STACK 100h

 INCLUDE procs.inc

       LOCALS
       ;imprime salto de linea.
       printNewLine  MACRO

        push ax
        mov al,13
        call putchar
        mov al,10
        call putchar
        pop ax

         ENDM
   .DATA
      mens_directo       db  13,10,'-----Caracter en forma directa-------',0
      mens_dos      db  '-----Caracter usando DOS-------',13,10,0
      mens_bios   db  '----Caracter usando BIOS-----',13,10,0
      mensaje db '-----hola mundo cruel------',0
      TamanioMensaje = ($-mensaje)
      captura db 'captura un caracter:',0
      capturado db 13,10,'caracter capurado:',0
      cad db 'cadena prueba$'

   .CODE


    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

				call clrscr
;---------------int DOS ----------------------
        mov dx, offset mens_dos
        call puts

        mov dx,offset captura
        call puts
        mov ah,1
        int 21h
        mov dx,offset capturado
        call puts
        call putchar
        printNewLine

        mov dx,offset cad
        mov ah,9
        int 21h
        printNewLine

;------------------- int bios---------------------
        mov dx, offset mens_bios
        call puts

        mov dx,offset captura
        call puts
        mov ah,10
        int 16h                     ;error, buffer sucio.
        mov dx,offset capturado
        call puts
        call putchar


        mov ax,ds
        mov es,ax  ;es=ds
        mov ah,013h  ;atributo (color fondo-letraaa)
        mov bl,00ch
        mov al,0     ;modo escritura
        mov bh,0    ;pagina de video
        mov cx,TamanioMensaje
        mov dh,18  ;fila
        mov dl,18   ;columna
        mov bp,offset mensaje
        int 10h
;-----------------------directo-------------
				mov  dx,offset mens_directo
				call puts
        mov dx,offset mensaje
        mov bh,76
        mov bl,20
        call putsxy



				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP

;Nota: No esta validado el desplazamiento vertical, solo el horizontal.
;recibe dx = apuntado a cadena terminada en 0
;bh = coordenada x
;bl = coordenada y
putsxy PROC
            push ax
            push bx
            push cx
            push dx
            push si
            push ds

            mov si,dx

            color = 00001100b ;bh=fondo=negro,bl=letra=roja
            mov dh,color



            mov cl,160

     wh:    push bx

            cmp bh,80  ;validacion para que se imprima en la sig linea si se llega
            jne @@l1    ;al final de la linea
            mov bh,0
            inc bl

    @@l1:   mov al,bl     ;ax=x
            mul cl
            mov bl,bh     ;x
            xor bh,bh     ;bh=0
            shl bx,1
            add bx,ax


            cmp byte ptr[si],0
            je endW
            mov dl,ds:[si]
            push ds   ;salvar Ds "datos"

            mov ax,0b800h  ;poner Ds en "video"
            mov ds,ax
            mov [bx],dx

            pop ds      ;recuperar Ds "datos"
            inc si
            pop bx
            inc bh  ;x+=1

            jmp wh

    endW:   pop bx

            pop ds
            pop si
            pop dx
            pop cx
            pop bx
            pop ax
            ret
ENDP


         END
