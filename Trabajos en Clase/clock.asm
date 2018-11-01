;Procedimiento que simula un cronometro.

MODEL small
   .STACK 100h

   ;----- Insert INCLUDE "filename" directives here
   ;----- Insert EQU and = equates here

 INCLUDE procs.inc

       LOCALS

   .DATA
    i dw 0 ;contador
    s dw 0    ;segundos
    m dw 0     ;min
    h dw 0      ;horas
    flag db 0   ;bandera

   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
        mov ax,0
        mov ds,ax

        mov ds:word ptr[70h],offset reloj
        mov ds:[72h],cs

        ;alternative----------
        ;mov bx,070h
        ;mov word ptr[bx],offset reloj
        ;mov bx,072h
        ;mov [bx],cs

				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

        base = 10
        mov bx,base

				call clrscr


  wh:
        cmp byte ptr[flag],1cd
        jne wh

        mov byte ptr[flag],0

        mov ax,[h]        ;horas
        call printNumBase
        mov al,':'
        call putchar


        mov ax,[m]          ;minutos
        call printNumBase
        mov al,':'
        call putchar

        mov ax,[s]          ;segundos
        call printNumBase

        mov al,13           ;nueva linea
        call putchar
        mov al,10
        call putchar

        jmp wh

				mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP
;--------------------------------------------------------------
  reloj PROC
        sec=60
        min=60

        inc word ptr[i]

        ;mov word ptr[flag],0

        cmp word ptr[i],18
        jne @@final             ;if contador!= 18
                                ;if contador==18
        mov byte ptr[flag],1    ;actualizar bandera
        mov word ptr[i],0 ;contador igual a 0

        inc  word ptr[s]

        cmp word ptr[s],sec
        jne @@final

        sec=0
        mov word ptr[s],sec

        inc word ptr[m]
        cmp word ptr[m],min
        jne @@final

        min=0
        mov word ptr[m],min
        inc word ptr[h]


  @@final:
        iret
        ENDP


;-------------------------------------------------------------
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
