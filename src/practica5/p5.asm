section .data
    msg db "abcdefghijklmnopqrstuvwxyz0123456789", 0

section .text
    global main
    extern puts

main:
    ; --- INCISO A: Direccionamiento Directo / Inmediato ---
    ; Reemplazar 'a' por 'Z'
    push msg
    call puts
    add esp, 4

    mov byte [msg], 'Z'

    push msg
    call puts
    add esp, 4


    ; --- INCISO B: Direccionamiento Base ---
    ; Reemplazar 'x' por 'X' (posicion 23)
    push msg
    call puts
    add esp, 4

    mov ebx, msg + 23
    mov byte [ebx], 'X'

    push msg
    call puts
    add esp, 4


    ; --- INCISO C: Base + Desplazamiento ---
    ; Reemplazar '0' por '@' (posicion 26)
    push msg
    call puts
    add esp, 4

    mov ebx, msg
    mov byte [ebx + 26], '@'

    push msg
    call puts
    add esp, 4


    ; --- INCISO D: Base + Indice ---
    ; Reemplazar 'z' por 'Z' (posicion 25)
    push msg
    call puts
    add esp, 4

    mov ebx, msg
    mov esi, 25
    mov byte [ebx + esi], 'Z'

    push msg
    call puts
    add esp, 4


    ; --- INCISO E: Base + Indice + Desplazamiento ---
    ; Reemplazar 'p' por 'P' (posicion 15 = 10 + 5)
    push msg
    call puts
    add esp, 4

    mov ebx, msg
    mov esi, 5
    mov byte [ebx + esi + 10], 'P'

    push msg
    call puts
    add esp, 4


    ; --- INCISO F: Base + Indice con Indice Escalado ---
    ; Reemplazar 't' por '%' (posicion 19 = 19 * 1)
    push msg
    call puts
    add esp, 4

    mov ebx, msg
    mov esi, 19
    mov byte [ebx + esi * 1], '%'

    push msg
    call puts
    add esp, 4

    ret