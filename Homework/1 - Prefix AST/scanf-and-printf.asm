%include "io.inc"

section .data
    format_in: db "%c", 0
    chars: times 30 db 0
  
section .text
    global CMAIN

CMAIN:
    mov ebp, esp; for correct debugging
    push ebp
    mov ebp, esp
    
    xor ecx, ecx
    mov ebx, chars
    sub ebx, 1
    
read_chars:
    add ebx, 1
    push ecx
    
    push ebx ; address to read at
    push format_in ; arguments are right to left (first  parameter)
    call scanf
    add esp, 8 ; remove the parameters
    
    pop ecx
    inc ecx
    cmp byte [ebx], 0
    jne read_chars
    
;    xor eax, eax
;    mov ebx, chars
;    sub ebx, 1
    
;print_chars:
;    add ebx, 1
;    PRINT_CHAR [ebx]
;    inc eax
;    cmp eax, ecx
;    jna print_chars
    
    sub ecx, 2
    mov ebx, chars
    
next:
    movzx eax, byte [ebx + ecx]
    cmp eax, 48
    jb found_operator
    
found_operand:
    sub eax, 48
    push eax
    jmp after_push
    
found_operator:
    pop esi
    pop edi
    cmp eax, 43
    je addition
    cmp eax, 45
    je substraction
    cmp eax, 42
    je multiplication
    cmp eax, 47
    je division
    jmp after_push
    
addition:
    add esi, edi
    push esi
    jmp after_push

substraction:
    sub esi, edi
    push esi
    jmp after_push
    
multiplication:
    mov eax, esi
    imul edi
    push eax
    jmp after_push
    
division:
    xor edx, edx
    mov eax, esi
    idiv edi
    push eax
    jmp after_push
    
after_push:
    sub ecx, 2
    cmp ecx, 0
    jnl next
    
    pop eax
    PRINT_DEC 4, eax
    
    xor eax, eax
    leave
    ret
    
    



