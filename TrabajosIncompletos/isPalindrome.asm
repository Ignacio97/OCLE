MODEL small
   .STACK 100h


 INCLUDE procs.inc

       LOCALS

   .DATA
    cad db 30 dup(?)
    no db 13,10,"Noo palindoroma",0
    sii db 13,10,"Es palindoromaa",0

   .CODE


    Principal  	PROC
				mov ax,@data 	;Inicializar DS al la direccion
				mov ds,ax     	; del segmento de datos (.DATA)

				call clrscr
        mov dx,offset cad
        mov dx,bx

        call myGets

        call isPalindrome  ;llamada a funcion
        call puts


        cmp ah,1
        jne aqui

        mov dx,offset sii
        call puts
        jmp endd

aqui:   mov dx,offset no
          call puts



endd:	mov ah,04ch	     ; fin de programa
				mov al,0             ;
				int 21h              ;

                ENDP

                ;recibe en bx apuntador a la cadena.
                myGets PROC
                    push ax
                    push bx

                    mov bx,dx

                    @@again:  call getchar
                              cmp al,13
                              je @@rtKey    ;si es 13(enter)

                              cmp al,8  ; al == BS ?
                              jne l1     ;no, then almacenalo
                              cmp bx,dx   ;si then hay algo almacenado ya?
                              jne l2   ;si hay algo

                              push ax ;no hay algo
                              mov al,00 ;14 = desplazamiento derecha
                              call putchar
                              pop ax

                              jmp @@again  ;no, then pìde otro caracter

                            l2:
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

isPalindrome PROC
                  push bx  ;salvar registros
                  push cx
                  push si
                  push di

                  mov bx,dx
                  mov si,dx
                  mov di,bx

          doo:    cmp ds:byte ptr[si],0
                  je @@finwh
                  mov ah,ds:byte ptr[si]

                  cmp ah,'A'
                  jb contine
                  cmp ah,'Z'
                  ja contine
                  add ah,32

      contine:

                  mov ds:byte ptr[di],ah
                  inc si

                  cmp ds:byte ptr[di],32
                  je doo



                  inc di
                  jmp doo
@@finwh:
                xor ax,ax

                mov ds:[di],al
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
noopalindrome:  mov ah,0



fin:
                  pop di
                  pop si
                  pop cx
                  pop bx
ret
ENDP



         END
