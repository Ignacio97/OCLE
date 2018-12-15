MODEL small
   .STACK 100h


 INCLUDE procs.inc

       LOCALS

   .DATA
    newline db 13,10,0
    cad db "anita lava la tin",0
    no db "Noo palindoroma",0
    sii db "Es palindoromaa",0

   .CODE


    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

				call clrscr
        mov dx,offset cad

       call pali

        cmp ah,1
        jne aqui

        mov dx,offset sii
        call puts
        jmp endd

aqui:  mov dx,offset no
        call puts


endd:	mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP





;Recibe en dx apuntador a cadena
;devuelve ah = 1 si es palindoroma, caso contrario 0.
pali PROC
                  push bx   ;salvar registro
                  push cx
                  push si
                  push di

                  mov bx,dx
                  mov si,dx
                  mov di,dx

         dooo:    cmp ds:byte ptr[si],0
                  je @@finwh



                  mov al,[si]
                  mov ds:[di],al
                  call putchar
                  inc si

                  cmp ds:byte ptr[di],32
                  je dooo
                  inc di
                  jmp dooo



@@finwh:
                  xor ax,ax    ;al=0
                  mov ds:[di],al  ;cad[si]=0



                                  xor cx,cx


                  cuenta:         cmp ds:byte ptr[bx],0
                                  je stop
                                  mov al,[bx]
                                  push ax
                                  inc cx
                                  inc bx
                                  jmp cuenta

                  stop:

                                    mov si,dx

                  looop:          pop ax
                                  cmp ds:byte ptr[si],al
                                  jne noopalindrome
                                  inc si
                                  loop looop

                  ispalindromee: mov ah,1
                                  jmp fin

                  noopalindrome:  pop ax                 ;vaciar la pila.
                                  loop noopalindrome

                                  mov ah,0




         fin:     pop di  ;recuperar registros
                  pop si
                  pop cx
                  pop bx
ret
ENDP

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
