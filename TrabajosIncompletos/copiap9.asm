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
   cad db "hola mundo",0

   .CODE


    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

				call clrscr ;limpia pantalla

        base = 16
        start = 9    ;inicio a eliminar
        len = 4       ;cant a eliminar

        mov al,start
        mov cl, len

        mov bx,offset cad
        mov dx,bx

        call puts   ;before
        call erase
        printNewLine
        call puts   ;after
        printNewLine
        mov bx,base
        xor al,al       ;al = 0
        call printNumBase


				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP
;Procedimiento que borra una porcion de una cadena
;bx = apuntador a una cadena terminada en 0.
;al = pos del primer caracter a borrar.
;cl = cantidad de caracteres a borrar.
;retorna 0 en ah si al < str.len caso contrario -1.
erase PROC
            push cx  ;backup registers
            push ax
            push di
            push si

            xor ch,ch ;poner en 0 registro
            xor ah,ah

            mov di,ax   ;init registros
            mov si,ax
            add si,cx

            push bx
    count: cmp byte ptr[bx],0  ;contar los caracteres de cad, fin de linea no cuenta.
            je continue
            inc ch        ;ch = str.len
            inc bx
            jmp count
continue:   pop bx

            cmp al,ch
            jae fin      ;if al >= str.len : ah = -1 and prog ends.


    while:  cmp byte ptr[bx+si],0    ;while  str[si] != 0 : str[al] = str[al+cl]
            je ESS

            mov al,[bx+si]
            mov [bx+di],al

            inc di
            inc si


            jmp while

    ESS:     mov al,[bx+si]   ;append new end of line
             mov [bx+di],al


      fin:   pop si   ;get back registers
             pop di
             pop ax

             cmp al,ch       ;al >= str.len
             jb n            ;no then ah = 0
             mov ah,-1       ;si then ah = -1
             jmp n2
        n:   mov ah,0

      n2:    pop cx



    ret
    ENDP


    ;Imprime un numero dado en ax en la base solicitada dada en bx.
    ;ax = numero
    ;bx = base
    printNumBase PROC
        push ax ;salvar registros
        push cx
        push dx

        xor dx,dx ;dx=0
        contador = 0
        mov cx,contador

    doo:
        div bx      ;ax=ax/bx
        add dx,30h  ;dx=ax%bx + 30h
        cmp dx,39h  ;residuo mayor a 9?
        jbe l1      ;no then push
        add dx,7h   ;si, then add 7
    l1:   push dx
        inc cx
        xor dx,dx ;dx=0
        cmp ax,0  ;cociente != 0 ?
        jne doo


    print:  pop ax
        call putchar
        loop print

        pop dx  ;recuperar registros
        pop cx
        pop ax


        ret
    ENDP


         END
