MODEL small
   .STACK 100h

   ;----- Insert INCLUDE "filename" directives here
   ;----- Insert EQU and = equates here

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
      cad1       db  'Hola Mundo cruel',0

      cad2 db 32 dup(?)
   .CODE


    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

				call clrscr

        base = 16
        start = 1
        cant = 5

        mov si,offset cad1
        mov di,offset cad2
        mov al,start
        mov cl,cant

        mov dx,offset cad1
        call puts            ; before suubstr
        printNewLine

        call suubstr

        mov dx,offset cad2   ; after
        call puts
        printNewLine

        xor al,al
        mov bx,base
        call printNumBase

				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP

;di = cadena cadena destino
;si = cadena fuente
;al = comienzo
;cl = cantidad
;ah = 0 si copiado exitoso, ah = -1 si comienzot > str.len
suubstr PROC
                push si
                push di
                push cx



                xor ch,ch   ;ch = 0


              push si

  @@count:      cmp byte ptr[si],0 ;while str[si]!=0: ch++
              je @@stopCont
              inc si
              inc ch
              jmp @@count

@@stopCont:     pop si

              cmp al,ch       ;al >= str.len
              jae @@error        ;si then ah=-1 and ret

              xor ah,ah
              add si,ax ;si+=al

      @@wh:     cmp cl,0        ;while str[si]!=0 and cl > 0
              je @@Ewh
              cmp byte ptr[si],0
              je @@Ewh

              mov ah,[si]
              mov [di],ah
              inc si
              inc di
              dec cl

              jmp @@wh

      @@Ewh:   mov byte ptr[di],0  ;appends end of line to destiny str

              val = 0
              mov ah,val
              jmp @@fin
    @@error:  val = -1
              mov ah,val


    @@fin:    pop cx  ;get back registers
              pop di
              pop si
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
