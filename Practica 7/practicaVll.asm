MODEL small
   .STACK 100h

 INCLUDE procs.inc

   LOCALS

    ;du   EQU 50
    ;ca	EQU 7
    ;ma 	EQU	56
    CR	EQU 13
	  LF 	EQU	10

   .DATA
      g10      db 'GRADO 10',CR,LF,0
      g9       db  'GRADO 9',CR,LF,0
      g8       db  'GRADO 8',CR,LF,0
      g7       db  'GRADO 7',CR,LF,0
      g6       db  'GRADO 6',CR,LF,0
      g5       db  'GRADO 5',CR,LF,0

    a		 db (0) ;dureza
    b		 db (1) ;carbon
    c		 db (0) ;maneabilidad

   .CODE
    ;-----   Insert program, subrutine call, etc., here

    Principal  	PROC
        mov ax,@data 	;Inicializar DS al la direccion
        mov ds,ax     	; del segmento de datos (.DATA)

        call clrscr

        call gradoMetal

        mov ah,04ch	     ; fin de programa
        mov al,0          ;
        int 21h            ;

                ENDP

; incluir procedimientos
; ejemplo:
; funcionX PROC ; < -- Indica a TASM el inicio del un procedimiento
;               ;
;               ; < --- contenido del procedimiento
;           ret
;           ENDP; < -- Indica a TASM el fin del procedimiento

gradoMetal PROC
  push dx
du   = 50
ca	= 7
ma 	=	56
  @@if1:    cmp byte ptr[a],du   ;dureza>50 ?
          jbe else1
  @@if2:    cmp byte ptr[b],ca  ;carbon<7 ?
          jae else2
  if3:    cmp byte ptr[c],ma ;maneabilidad>56 ?
          jbe else3
          mov dx,offset g10
          jmp continue
  else3:  mov dx, offset g9
          jmp continue
  else2:  cmp byte ptr[c],ma ;condicion 1 y 3
          jbe solo1
          mov dx,offset g7
          jmp continue
  solo1:  mov dx,offset g6
          jmp continue
  else1:  cmp byte ptr[b],ca
          jae if4
          cmp byte ptr[c],ma
          jbe solo1
          mov dx,offset g8
          jmp continue
  if4:    cmp byte ptr[c],ma
          jbe ninguna
          jmp solo1
ninguna:  mov dx,offset g5
continue: call puts
pop dx
ret
ENDP


         END
