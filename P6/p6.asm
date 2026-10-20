; Practica 6 - Organizacion de Computadoras
; captura tipo fgets, mayusculas y minusculas

%include "../lib/pc_io.inc"   ; incluir declaraciones de procedimiento externos

section .data
    bskey equ 0x7F
    lencadena equ 255
    ln equ 0x0A
    nline db ln,0
    msg1 db ln,'Captura: ', 0
    msg2 db ln,'Mayusculas: ', 0
    msg3 db ln,'Minusculas: ', 0

section .bss
    cadena resb lencadena

section .text
    global _start         ; referencia para inicio de programa

_start:
    ;capturar cadena
    mov edx, msg1
    call puts
    mov edx, cadena
    mov ax, lencadena - 1      ; maximo de caracteres, uno es para el nulo
    call captura

    ; mostrar mayusculas
    mov edx, cadena
    call mayusculas
    mov edx, msg2
    call puts
    mov edx, cadena
    call puts

    ;mostrar minusculas
    mov edx, cadena
    call minusculas
    mov edx, msg3
    call puts
    mov edx, cadena
    call puts

    ; fin del prog
    mov edx, nline
    call puts
    mov eax, 1                 ; Llamada sys_exit
    xor ebx, ebx               ; return 0
    int 0x80                   ; Fin de programa

; captura: edx = inicio de la cadena, ax = maximo de caracteres
captura:
    push ebx
    push ecx
    mov ebx, edx               ; inicio de la cadena
    movzx ecx, ax              ; espacios disponibles
.ciclo:
    call getch                 ; al = tecla
    cmp al, ln                 ; enter termina la captura
    je .fin
    cmp al, bskey
    jne .normal
    cmp edx, ebx               ; no borrar si no hay nada capturado
    je .ciclo
    call borrar
    sub edx, 1
    add ecx, 1
    jmp .ciclo
.normal:
    cmp ecx, 0                 ; cadena llena, ignorar tecla
    je .ciclo
    mov [edx], al
    call putchar
    add edx, 1
    sub ecx, 1
    jmp .ciclo
.fin:
    mov byte [edx], 0          ; caracter nulo
    pop ecx
    pop ebx
    ret

; borrar:make return retrocede el cursor, imprime un espacio y retrocede otra vez
borrar:
    push ax
    mov al, 0x8
    call putchar
    mov al, ' '
    call putchar
    mov al, 0x8
    call putchar
    pop ax
    ret

; mayusculas: a-z a A-Z
mayusculas:
.ciclo:
    mov al, [edx]
    cmp al, 0
    je .fin
    cmp al, 97
    jb .nocambiar
    cmp al, 122
    ja .nocambiar
    sub al, 32
.nocambiar:
    mov [edx], al
    add edx, 1
    jmp .ciclo
.fin:
    ret

; minusculas: A-Z a a-z
minusculas:
.ciclo:
    mov al, [edx]
    cmp al, 0
    je .fin
    cmp al, 65
    jb .nocambiar
    cmp al, 90
    ja .nocambiar
    add al, 32
.nocambiar:
    mov [edx], al
    add edx, 1
    jmp .ciclo
.fin:
    ret