section .text
global maximo
global minimo
global sumatoria

; Macro WHILE: se divide en inicio y fin
; WHILE_INICIO indice, limite, etiqueta  -> mientras indice < limite
; WHILE_FIN etiqueta                     -> regresa a evaluar la condicion
%macro WHILE_INICIO 3
%1_%3:
    cmp %1, %2
    jge %1_%3_fin
%endmacro

%macro WHILE_FIN 2
    jmp %1_%2
%1_%2_fin:
%endmacro

; int maximo(int *arr, int len)
maximo:
    push ebp
    mov ebp, esp
    push ebx
    push esi

    mov ebx, [ebp+8]        ; direccion del arreglo
    mov ecx, [ebp+12]       ; len
    xor eax, eax
    cmp ecx, 0
    jle fin_max                ; arreglo vacio, regresa 0

    mov eax, [ebx]          ; max = arr[0]
    mov esi, 1              ; i = 1
    WHILE_INICIO esi, ecx, wmax
        mov edx, [ebx+esi*4]
        cmp edx, eax
        jle sigue_max
        mov eax, edx        ; nuevo maximo
sigue_max:
        inc esi
    WHILE_FIN esi, wmax
fin_max:
    pop esi
    pop ebx
    pop ebp
    ret

; int minimo(int *arr, int len)
minimo:
    push ebp
    mov ebp, esp
    push ebx
    push esi

    mov ebx, [ebp+8]
    mov ecx, [ebp+12]
    xor eax, eax
    cmp ecx, 0
    jle fin_min

    mov eax, [ebx]          ; min = arr[0]
    mov esi, 1
    WHILE_INICIO esi, ecx, wmin
        mov edx, [ebx+esi*4]
        cmp edx, eax
        jge sigue_min
        mov eax, edx        ; nuevo minimo
sigue_min:
        inc esi
    WHILE_FIN esi, wmin
fin_min:
    pop esi
    pop ebx
    pop ebp
    ret

; int sumatoria(int *arr, int len)
sumatoria:
    push ebp
    mov ebp, esp
    push ebx
    push esi

    mov ebx, [ebp+8]
    mov ecx, [ebp+12]
    xor eax, eax            ; suma = 0
    xor esi, esi            ; i = 0
    WHILE_INICIO esi, ecx, wsum
        add eax, [ebx+esi*4]
        inc esi
    WHILE_FIN esi, wsum

    pop esi
    pop ebx
    pop ebp
    ret