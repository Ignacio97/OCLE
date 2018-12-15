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
      cad1    db  'Hola Mundo',0
      cad2    db 30  dup(?)

   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

				call clrscr



				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP

                ; recibe si = cadena fuente
                ;di = cadena destino
                ;al = Comienzo
                ;cl cantidad de carac. a copiar.
                subStr PROC
                      push cx   ;backup registers
                      push ax
                      push si

                      xor ch,ch ;registers to 0

                      push si
          count:      cmp byte [si],0
                      je next
                      inc si        ;si++
                      inc ch       ;ch++
                      jmp endcount
          endcount:   pop si

                      cmp al,ch

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
