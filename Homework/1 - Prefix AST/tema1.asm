%include "includes/io.inc"

extern getAST
extern freeAST

section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1
 

section .data
    input times 500 dd 0
    
section .text
 
process_tree: ; takes one argument - starting address
    push ebp
    mov ebp, esp
    
    mov eax, [ebp + 8]
    mov ebx, [eax]
    mov dl, byte [ebx]
    cmp dl, 48
    jge compute_number
    cmp dl, 45 ; '-'
    je test_negative_number
    jmp save_operator
    
test_negative_number:
    cmp byte [ebx + 1], 0
    je save_operator
    
compute_number: ; starting at address ebx, byte by byte
    mov esi, dword 10
    xor edi, edi ; will become 1 if negative number
    xor eax, eax
    cmp dl, 45 ; '-'
    jne next_digit
    
negative_number:
    inc edi
    inc ebx

next_digit:
    mul esi
    movzx edx, byte [ebx]
    sub edx, 48 ; turn ascii code into digit
    add eax, edx
    inc ebx
    cmp byte [ebx], 0
    jne next_digit
    
    test edi, edi
    jz save_number
    not eax
    inc eax
    
save_number:
    mov [input + 5 * ecx], byte 0 ; 0 to identify it as a number
    mov [input + 5 * ecx + 1], dword eax
    inc ecx
    jmp end_process_tree
    
save_operator: ; at address ebx
    
    mov [input + 5 * ecx], byte 1 ; 1 to identify it as an operator
    movzx edi, byte [ebx]
    mov dword [input + 5 * ecx + 1], edi
    
    inc ecx
    
    mov eax, [ebp + 8]
    add eax, 4
    push dword [eax]
    call process_tree ; left
    add esp, 4
    
    mov eax, [ebp + 8]
    add eax, 8
    push dword [eax]
    call process_tree ; right
    add esp, 4
    
end_process_tree:
    leave
    ret
 
 
global main

main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax
    ; Implementati rezolvarea aici:
    
    xor ebx, ebx
    xor ecx, ecx 
    xor edx, edx
     
    push dword [root]
    call process_tree
    add esp, 4
    
    ; ecx - total number of operands and operators
    dec ecx
    
evaluate_expression:    
    cmp byte [input + 5 * ecx], 0
    je push_number
    
apply_operator:
    mov edx, dword [input + 5 * ecx + 1]
    pop esi
    pop edi
    cmp edx, 43 ; '+'
    je sum
    cmp edx, 45 ; '-'
    je substract
    cmp edx, 42 ; '*'
    je multiply
    cmp edx, 47 ; '/'
    je divide
    jmp after_push
    
sum:
    add esi, edi
    push esi
    jmp after_push
    
substract:
    sub esi, edi
    push esi
    jmp after_push
    
multiply:
    mov eax, esi
    imul edi
    push eax
    jmp after_push
    
divide:
    mov eax, esi
    cdq
    idiv edi
    push eax
    jmp after_push

push_number:
    push dword [input + 5 * ecx + 1]
   
after_push:
    dec ecx
    test ecx, ecx
    jnl evaluate_expression
    
    pop eax
    PRINT_DEC 4, eax

    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret
    
