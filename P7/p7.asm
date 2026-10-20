; Practica 7 - ATOI e ITOA en ensamblador i386 (NASM, Linux)
; Captura una cadena numerica, la convierte a entero con signo
; y despues la vuelve a mostrar como cadena.
;
; Convencion: parametros por la pila (se meten de derecha a izquierda),
; el retorno va en EAX, y quien llama limpia la pila.

section .data
    msg_in   db "Escribe un numero: ", 0
    msg_out  db "El numero entero es: ", 0
    nl       db 10, 0

section .bss
    buffer   resb 64            ; cadena capturada (max 64 con el nulo)
    outbuf   resb 64            ; cadena resultado de ITOA

section .text
global _start

_start:
    push msg_in
    call print_str
    add  esp, 4

    push 64                     ; maximo de caracteres
    push buffer                 ; direccion del buffer
    call read_str
    add  esp, 8

    push buffer                 ; ATOI(direccion de cadena)
    call atoi
    add  esp, 4                 ; EAX = entero con signo

    push 64                     ; ITOA(numero, direccion, longitud)
    push outbuf
    push eax
    call itoa
    add  esp, 12

    push msg_out
    call print_str
    add  esp, 4
    push outbuf
    call print_str
    add  esp, 4
    push nl
    call print_str
    add  esp, 4

    mov  eax, 1                 ; sys_exit
    xor  ebx, ebx
    int  0x80

; ---------------------------------------------------------
; print_str(direccion): imprime una cadena terminada en nulo
; ---------------------------------------------------------
print_str:
    push ebp
    mov  ebp, esp
    push ebx
    mov  ecx, [ebp+8]
    xor  edx, edx               ; edx = longitud
.len:
    cmp  byte [ecx+edx], 0
    je   .out
    inc  edx
    jmp  .len
.out:
    mov  eax, 4                 ; sys_write
    mov  ebx, 1                 ; stdout
    int  0x80
    pop  ebx
    pop  ebp
    ret

; ---------------------------------------------------------
; read_str(direccion, maximo): lee del teclado, quita el
; salto de linea y deja el nulo al final. Retorna longitud.
; ---------------------------------------------------------
read_str:
    push ebp
    mov  ebp, esp
    push ebx
    mov  eax, 3                 ; sys_read
    mov  ebx, 0                 ; stdin
    mov  ecx, [ebp+8]
    mov  edx, [ebp+12]
    dec  edx                    ; dejar lugar para el nulo
    int  0x80
    mov  ecx, [ebp+8]
    test eax, eax
    jg   .ok
    xor  eax, eax
    jmp  .term
.ok:
    cmp  byte [ecx+eax-1], 10   ; quitar el Enter
    jne  .term
    dec  eax
.term:
    mov  byte [ecx+eax], 0
    pop  ebx
    pop  ebp
    ret

; ---------------------------------------------------------
; ATOI(direccion) -> EAX = entero con signo
; ---------------------------------------------------------
atoi:
    push ebp
    mov  ebp, esp
    push ebx
    push esi
    mov  esi, [ebp+8]           ; esi = inicio de la cadena
    xor  eax, eax               ; resultado = 0
    mov  ebx, 1                 ; signo = +1
.ws:                            ; ignorar espacios y tabulaciones
    mov  cl, [esi]
    cmp  cl, ' '
    je   .skip
    cmp  cl, 9
    je   .skip
    jmp  .sign
.skip:
    inc  esi
    jmp  .ws
.sign:                          ; un solo signo opcional
    cmp  cl, '-'
    jne  .plus
    mov  ebx, -1
    inc  esi
    jmp  .digits
.plus:
    cmp  cl, '+'
    jne  .digits
    inc  esi
.digits:
    movzx ecx, byte [esi]
    sub  ecx, '0'
    cmp  ecx, 9
    ja   .done                  ; no es digito (incluye nulo y punto)
    imul eax, eax, 10
    add  eax, ecx
    inc  esi
    jmp  .digits
.done:
    imul eax, ebx               ; aplicar el signo
    pop  esi
    pop  ebx
    pop  ebp
    ret

; ---------------------------------------------------------
; ITOA(numero, direccion, longitud) -> EAX = direccion
; Arma los digitos de derecha a izquierda al final del
; buffer y luego los recorre al inicio.
; ---------------------------------------------------------
itoa:
    push ebp
    mov  ebp, esp
    push ebx
    push esi
    push edi
    mov  eax, [ebp+8]           ; numero
    mov  edi, [ebp+12]          ; direccion
    mov  ecx, [ebp+16]          ; longitud
    lea  esi, [edi+ecx-1]       ; esi = ultima posicion
    mov  byte [esi], 0          ; nulo final
    mov  ebx, eax               ; guardar el signo original
    test eax, eax
    jns  .pos
    neg  eax                    ; trabajar con el valor positivo
.pos:
    mov  ecx, 10
.loop:
    xor  edx, edx
    div  ecx                    ; eax = cociente, edx = residuo
    add  dl, '0'
    dec  esi
    mov  [esi], dl
    test eax, eax
    jnz  .loop
    test ebx, ebx
    jns  .copy
    dec  esi
    mov  byte [esi], '-'
.copy:                          ; mover la cadena al inicio del buffer
    mov  al, [esi]
    mov  [edi], al
    inc  esi
    inc  edi
    test al, al
    jnz  .copy
    mov  eax, [ebp+12]          ; retorno: direccion de inicio
    pop  edi
    pop  esi
    pop  ebx
    pop  ebp
    ret