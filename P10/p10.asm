global set_bit
global get_bit

section .text

; set_bit: pone en 1 el bit indicado, los demas no cambian
;   [ebp+8]  = apuntador al byte
;   [ebp+12] = posicion del bit (0 a 7)

set_bit:
    push ebp
    mov ebp, esp

    mov edx, [ebp+8]          ; edx = direccion del byte
    movzx ecx, byte [ebp+12]  ; cl = posicion
    and cl, 7                 ; solo posiciones 0 a 7
    mov eax, 1
    shl eax, cl               ; eax = mascara con un solo 1 en el bit
    or [edx], al              

    pop ebp
    ret

; get_bit: regresa en al el estado del bit (0 o 1)
;   [ebp+8]  = byte (unsigned char)
;   [ebp+12] = posicion del bit (0 a 7)

get_bit:
    push ebp
    mov ebp, esp

    movzx eax, byte [ebp+8]   ;  valor
    movzx ecx, byte [ebp+12]  ; cl = posicion del bit
    and cl, 7
    shr eax, cl               ; el bit queda en la posicion 0
    and eax, 1                ; se limpian los demas bits

    pop ebp
    ret