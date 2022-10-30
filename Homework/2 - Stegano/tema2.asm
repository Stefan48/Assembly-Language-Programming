%include "include/io.inc"

extern atoi
extern printf
extern exit

; Functions to read/free/print the image.
; The image is passed in argv[1].
extern read_image
extern free_image
; void print_image(int* image, int width, int height);
extern print_image

; Get image's width and height.
; Store them in img_[width, height] variables.
extern get_image_width
extern get_image_height

section .data
	use_str db "Use with ./tema2 <task_num> [opt_arg1] [opt_arg2]", 10, 0

section .bss
    task:       resd 1
    img:        resd 1
    img_width:  resd 1 ; number of lines
    img_height: resd 1 ; number of columns

section .text
global main

calculate_pixels:
    ; takes no argument
    ; returns total number of pixels in eax
    ; uses register edi
    push ebp
    mov ebp, esp
    
    mov eax, dword [img_width]
    mov edi, dword [img_height]
    mul edi
    
    leave
    ret
    

xor_image:
    ; takes 2 arguments - total number of pixels and the key
    ; no return value
    ; uses registers ebx, ecx, esi, edi
    push ebp
    mov ebp, esp
    
    mov esi, dword [img] ; image pointer
    mov edi, dword [ebp + 8] ; total number of pixels
    mov ebx, dword [ebp + 12] ; key
    xor ecx, ecx ; pixel counter

xor_next_pixel:
    mov bh, byte [esi + 4 * ecx]
    xor bh, bl
    mov [esi + 4 * ecx], byte bh
    inc ecx
    cmp ecx, edi
    jne xor_next_pixel
    
    leave
    ret
    

check_revient:
    ; takes one argument - address at which the string begins
    ; return value in eax (true if matches, false otherwise)
    ; uses registers ebx, edx
    push ebp
    mov ebp, esp
    
    xor eax, eax
    mov ebx, [ebp + 8]
    mov dh, byte [ebx]
    cmp dh, 'r'
    jne end_check_revient
    mov dh, byte [ebx + 4]
    cmp dh, 'e'
    jne end_check_revient
    mov dh, byte [ebx + 8]
    cmp dh, 'v'
    jne end_check_revient
    mov dh, byte [ebx + 12]
    cmp dh, 'i'
    jne end_check_revient
    mov dh, byte [ebx + 16]
    cmp dh, 'e'
    jne end_check_revient
    mov dh, byte [ebx + 20]
    cmp dh, 'n'
    jne end_check_revient
    mov dh, byte [ebx + 24]
    cmp dh, 't'
    jne end_check_revient
    inc eax
    
end_check_revient:
    leave
    ret
    
    
get_key_and_line:
    ; takes one argument - total number of pixels
    ; returns key in ebx, line in eax, starting address for the message string in edx
    ; uses registers ecx, esi, edi
    push ebp
    mov ebp, esp

    mov esi, dword [img] ; image pointer
    mov edi, dword [ebp + 8] ; total number of pixels
    xor ebx, ebx ; key counter
    
next_key:
    push ebx
    push ebx
    push edi
    call xor_image
    add esp, 8
    
search_revient:
    xor ecx, ecx ; pixel counter
    mov edx, esi
    
test_next_pixel:
    push edx
    push edx
    call check_revient
    add esp, 4
    pop edx
    test eax, eax
    jnz found_revient
    add edx, 4
    inc ecx
    cmp ecx, edi
    jne test_next_pixel
    jmp not_found_revient
    
found_revient:
    xor edx, edx
    mov eax, ecx
	; divide current pixel by number of columns
    mov ebx, [img_width]
    div ebx
    push eax
    xor eax, eax
    mov eax, dword [img_width]
    shl ax, 2
    mov edx, dword [esp]
    mul dx
    shl edx, 16
    add edx, eax
    pop eax
    pop ebx
    jmp end_get_key_and_line
    
not_found_revient:
    mov ebx, dword [esp]
    push ebx
    push edi
    call xor_image
    add esp, 8
    pop ebx
    inc bl
    jnz next_key
    xor eax, eax
    xor ebx, ebx
    xor edx, edx

end_get_key_and_line:
    leave
    ret
    
    
insert_message_morse:
    ; takes 2 arguments - message's starting address and pixel starting address
    ; no return value
    ; uses registers eax, ebx, edx
    push ebp
    mov ebp, esp
    
    mov eax, dword [ebp + 8]
    mov ebx, dword [ebp + 12]
    
insert_next_character:
    mov dl, byte [eax]
    ;PRINT_CHAR dl
    cmp dl, 'A'
    je insert_A
    cmp dl, 'B'
    je insert_B
    cmp dl, 'C'
    je insert_C
    cmp dl, 'D'
    je insert_D
    cmp dl, 'E'
    je insert_E
    cmp dl, 'F'
    je insert_F
    cmp dl, 'G'
    je insert_G
    cmp dl, 'H'
    je insert_H
    cmp dl, 'I'
    je insert_I
    cmp dl, 'J'
    je insert_J
    cmp dl, 'K'
    je insert_K
    cmp dl, 'L'
    je insert_L
    cmp dl, 'M'
    je insert_M
    cmp dl, 'N'
    je insert_N
    cmp dl, 'O'
    je insert_O
    cmp dl, 'P'
    je insert_P
    cmp dl, 'Q'
    je insert_Q
    cmp dl, 'R'
    je insert_R
    cmp dl, 'S'
    je insert_S
    cmp dl, 'T'
    je insert_T
    cmp dl, 'U'
    je insert_U
    cmp dl, 'V'
    je insert_V
    cmp dl, 'W'
    je insert_W
    cmp dl, 'X'
    je insert_X
    cmp dl, 'Y'
    je insert_Y
    cmp dl, 'Z'
    je insert_Z
    cmp dl, ','
    je insert_comma
    jmp insert_null
    
insert_A:
    mov [ebx], byte '.'
    mov [ebx + 4], byte '-'
    add ebx, 8
    jmp after_insert
    
insert_B:
    mov [ebx], byte '-'
    mov [ebx + 4], byte '.'
    mov [ebx + 8], byte '.'
    mov [ebx + 12], byte '.'
    add ebx, 16
    jmp after_insert
    
insert_C:
    mov [ebx], byte '-'
    mov [ebx + 4], byte '.'
    mov [ebx + 8], byte '-'
    mov [ebx + 12], byte '.'
    add ebx, 16
    jmp after_insert
    
insert_D:
    mov [ebx], byte '-'
    mov [ebx + 4], byte '.'
    mov [ebx + 8], byte '.'
    add ebx, 12
    jmp after_insert
    
insert_E:
    mov [ebx], byte '.'
    add ebx, 4
    jmp after_insert
    
insert_F:
    mov [ebx], byte '.'
    mov [ebx + 4], byte '.'
    mov [ebx + 8], byte '-'
    mov [ebx + 12], byte '.'
    add ebx, 16
    jmp after_insert
    
insert_G:
    mov [ebx], byte '-'
    mov [ebx + 4], byte '-'
    mov [ebx + 8], byte '.'
    add ebx, 12
    jmp after_insert
    
insert_H:
    mov [ebx], byte '.'
    mov [ebx + 4], byte '.'
    mov [ebx + 8], byte '.'
    mov [ebx + 12], byte '.'
    add ebx, 16
    jmp after_insert
    
insert_I:
    mov [ebx], byte '.'
    mov [ebx + 4], byte '.'
    add ebx, 8
    jmp after_insert
    
insert_J:
    mov [ebx], byte '.'
    mov [ebx + 4], byte '-'
    mov [ebx + 8], byte '-'
    mov [ebx + 12], byte '-'
    add ebx, 16
    jmp after_insert
    
insert_K:
    mov [ebx], byte '-'
    mov [ebx + 4], byte '.'
    mov [ebx + 8], byte '-'
    add ebx, 12
    jmp after_insert
    
insert_L:
    mov [ebx], byte '.'
    mov [ebx + 4], byte '-'
    mov [ebx + 8], byte '.'
    mov [ebx + 12], byte '.'
    add ebx, 16
    jmp after_insert
    
insert_M:
    mov [ebx], byte '-'
    mov [ebx + 4], byte '-'
    add ebx, 8
    jmp after_insert
    
insert_N:
    mov [ebx], byte '-'
    mov [ebx + 4], byte '.'
    add ebx, 8
    jmp after_insert
    
insert_O:
    mov [ebx], byte '-'
    mov [ebx + 4], byte '-'
    mov [ebx + 8], byte '-'
    add ebx, 12
    jmp after_insert
    
insert_P:
    mov [ebx], byte '.'
    mov [ebx + 4], byte '-'
    mov [ebx + 8], byte '-'
    mov [ebx + 12], byte '.'
    add ebx, 16
    jmp after_insert
    
insert_Q:
    mov [ebx], byte '-'
    mov [ebx + 4], byte '-'
    mov [ebx + 8], byte '.'
    mov [ebx + 12], byte '-'
    add ebx, 16
    jmp after_insert
    
insert_R:
    mov [ebx], byte '.'
    mov [ebx + 4], byte '-'
    mov [ebx + 8], byte '.'
    add ebx, 12
    jmp after_insert
    
insert_S:
    mov [ebx], byte '.'
    mov [ebx + 4], byte '.'
    mov [ebx + 8], byte '.'
    add ebx, 12
    jmp after_insert
    
insert_T:
    mov [ebx], byte '-'
    add ebx, 4
    jmp after_insert
    
insert_U:
    mov [ebx], byte '.'
    mov [ebx + 4], byte '.'
    mov [ebx + 8], byte '-'
    add ebx, 12
    jmp after_insert
  
insert_V:
    mov [ebx], byte '.'
    mov [ebx + 4], byte '.'
    mov [ebx + 8], byte '.'
    mov [ebx + 12], byte '-'
    add ebx, 16
    jmp after_insert
    
insert_W:
    mov [ebx], byte '.'
    mov [ebx + 4], byte '-'
    mov [ebx + 8], byte '-'
    add ebx, 12
    jmp after_insert
    
insert_X:
    mov [ebx], byte '-'
    mov [ebx + 4], byte '.'
    mov [ebx + 8], byte '.'
    mov [ebx + 12], byte '-'
    add ebx, 16
    jmp after_insert
    
insert_Y:
    mov [ebx], byte '-'
    mov [ebx + 4], byte '.'
    mov [ebx + 8], byte '-'
    mov [ebx + 12], byte '-'
    add ebx, 16
    jmp after_insert
    
insert_Z:
    mov [ebx], byte '-'
    mov [ebx + 4], byte '-'
    mov [ebx + 8], byte '.'
    mov [ebx + 12], byte '.'
    add ebx, 16
    jmp after_insert
    
insert_comma:
    mov [ebx], byte '-'
    mov [ebx + 4], byte '-'
    mov [ebx + 8], byte '.'
    mov [ebx + 12], byte '.'
    mov [ebx + 16], byte '-'
    mov [ebx + 20], byte '-'
    add ebx, 24
    jmp after_insert

insert_null:
    sub ebx, 4
    mov [ebx], byte 0
    jmp end_insert_message

after_insert:
    mov [ebx], byte ' '
    add ebx, 4
    inc eax
    jmp insert_next_character
    
end_insert_message:
    leave
    ret
    
insert_message_lsb:
    ; takes 2 arguments - message's starting address and pixel starting address
    ; no return value
    ; uses registers eax, ebx, ecx, edx
    push ebp
    mov ebp, esp
    
    mov eax, dword [ebp + 8]
    mov ebx, dword [ebp + 12]
    
insert_next_character_lsb:
    mov dl, byte [eax]
    mov ecx, dword 8
    
insert_next_bit:    
    push edx
    and dl, 128
    test dl, dl
    jnz set_bit

reset_bit:
    mov dh, byte [ebx]
    mov dl, 0xFF
    shl dl, 1
    and dh, dl
    mov [ebx], byte dh
    jmp after_insert_bit
    
set_bit:
    mov dh, byte [ebx]
    or dh, 0x1
    mov [ebx], byte dh
    
after_insert_bit:
    pop edx
    shl dl, 1
    add ebx, 4
    dec ecx
    test ecx, ecx
    jnz insert_next_bit

after_insert_character:
    mov dl, byte [eax]
    test dl, dl
    jz end_insert_message_lsb
    inc eax
    jmp insert_next_character_lsb
    
end_insert_message_lsb:
    leave
    ret
    
    
extract_message_lsb:
    ; takes 1 argument - address at which the extraction begins
    ; no return value, just prints the message
    ; uses registers eax, ebx, ecx, edx, edi
    push ebp
    mov ebp, esp
    
    mov eax, dword [ebp + 8] ; starting address
    xor ebx, ebx
    
extract_next_character:
    xor edx, edx ; stores current character
    mov ecx, dword 8
    
extract_next_bit:
    mov bl, byte [eax]
    and bl, 1
    mov edi, ecx
    dec edi
    test edi, edi
    jz mask_calculated
    
calculate_mask:
    shl bl, 1
    dec edi
    test edi, edi
    jnz calculate_mask
    
mask_calculated:
    add edx, ebx
    add eax, 4
    dec ecx
    test ecx, ecx
    jnz extract_next_bit
    test edx, edx
    jz end_extract_message_lsb
    PRINT_CHAR edx
    jmp extract_next_character
    
end_extract_message_lsb:
    NEWLINE
    leave
    ret
    

main:
    ; Prologue
    ; Do not modify!
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    cmp eax, 1
    jne not_zero_param

    push use_str
    call printf
    add esp, 4

    push -1
    call exit

not_zero_param:
    ; We read the image. You can thank us later! :)
    ; You have it stored at img variable's address.
    
    mov eax, [ebp + 12]
    push DWORD[eax + 4] ; PUSH ADRESA LA CARE INCEPE SIRUL DE CARACTERE CORESPUNZATOR ARGV[1]
    call read_image
    add esp, 4
    mov [img], eax

    ; We saved the image's dimensions in the variables below.
    call get_image_width
    mov [img_width], eax

    call get_image_height
    mov [img_height], eax

    ; Let's get the task number. It will be stored at task variable's address.
    mov eax, [ebp + 12]
    push DWORD[eax + 8]
    call atoi
    add esp, 4
    mov [task], eax

    ; There you go! Have fun! :D
    mov eax, [task]
    cmp eax, 1
    je solve_task1
    cmp eax, 2
    je solve_task2
    cmp eax, 3
    je solve_task3
    cmp eax, 4
    je solve_task4
    cmp eax, 5
    je solve_task5
    cmp eax, 6
    je solve_task6
    cmp eax, 7
    je solve_task7
    jmp done

solve_task1:
    ; TODO Task1
    
    call calculate_pixels
    push eax
    call get_key_and_line
    add esp, 4
    mov esi, dword [img] ; image pointer
    
print_message: ; starting at address esi + edx
    mov ecx, dword [esi + edx]
    test ecx, ecx
    jz end_print_message
    PRINT_CHAR [esi + edx]
    add edx, 4
    jmp print_message
    
end_print_message:
    NEWLINE
    PRINT_UDEC 1, bl ; print key
    NEWLINE
    PRINT_UDEC 4, eax ; print line
    NEWLINE    
    
    jmp done
    
solve_task2:
    ; TODO Task2
    
    call calculate_pixels
    mov edi, eax
    push eax
    call get_key_and_line
    add esp, 4
    mov esi, dword [img] ; image pointer
    
add_message: ; starting at address esi + edx + 4 * img_width
    mov ecx, dword [img_width]
    shl ecx, 2
    add edx, ecx
    mov [esi + edx], byte 'C'
    mov [esi + edx + 4], byte 39
    mov [esi + edx + 8], byte 'e'
    mov [esi + edx + 12], byte 's'
    mov [esi + edx + 16], byte 't'
    mov [esi + edx + 20], byte ' '
    mov [esi + edx + 24], byte 'u'
    mov [esi + edx + 28], byte 'n'
    mov [esi + edx + 32], byte ' '
    mov [esi + edx + 36], byte 'p'
    mov [esi + edx + 40], byte 'r'
    mov [esi + edx + 44], byte 'o'
    mov [esi + edx + 48], byte 'v'
    mov [esi + edx + 52], byte 'e'
    mov [esi + edx + 56], byte 'r'
    mov [esi + edx + 60], byte 'b'
    mov [esi + edx + 64], byte 'e'
    mov [esi + edx + 68], byte ' '
    mov [esi + edx + 72], byte 'f'
    mov [esi + edx + 76], byte 'r'
    mov [esi + edx + 80], byte 'a'
    mov [esi + edx + 84], byte 'n'
    mov [esi + edx + 88], byte 'c'
    mov [esi + edx + 92], byte 'a'
    mov [esi + edx + 96], byte 'i'
    mov [esi + edx + 100], byte 's'
    mov [esi + edx + 104], byte '.'
    mov [esi + edx + 108], byte 0
    
    shl bl, 1
    add bl, 3
    xor eax, eax
    mov al, bl
    mov cl, byte 5
    div cl
    sub al, 4
    push eax
    push edi
    call xor_image
    add esp, 8
    
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp, 12
    
    jmp done
    
solve_task3:
    ; TODO Task3
    
    mov eax, [ebp + 12]
    mov eax, [eax + 16]
    push eax
    call atoi
    add esp, 4
    ; starting pixel in eax
    
    mov ebx, [ebp + 12]
    mov ebx, [ebx + 12] ; address at which our message starts
   
    mov esi, dword [img]
    shl eax, 2
    add esi, eax ; address at which inserting begins
    
    push esi
    push ebx
    call insert_message_morse
    add esp, 8
    
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp, 12
    
    jmp done
    
solve_task4:
    ; TODO Task4
    
    mov eax, [ebp + 12]
    mov eax, [eax + 16]
    push eax
    call atoi
    add esp, 4
    dec eax
    ; starting pixel in eax
    
    mov ebx, [ebp + 12]
    mov ebx, [ebx + 12] ; address at which our message starts
   
    mov esi, dword [img]
    shl eax, 2
    add esi, eax ; address at which inserting begins
    
    push esi
    push ebx
    call insert_message_lsb
    add esp, 8
    
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp, 12
    
    jmp done
    
solve_task5:
    ; TODO Task5
    
    mov eax, [ebp + 12]
    mov eax, [eax + 12]
    push eax
    call atoi
    add esp, 4
    dec eax
    ; starting pixel in eax
    
    mov esi, dword [img]
    shl eax, 2
    add esi, eax ; address at which extracting begins
    
    push esi
    call extract_message_lsb
    add esp, 4
    
    jmp done
    
solve_task6:
    ; TODO Task6
    
    call calculate_pixels
    mov edi, eax ; total number of pixels
    mov esi, dword [img] ; image pointer
    xor ecx, ecx ; pixel counter
    
next_pixel:
    mov ebx, dword [img_width]
    cmp ecx, ebx
    jb border1
    xor edx, edx
    mov eax, ecx
    div ebx
    test edx, edx
    jz border1
    xor edx, edx
    mov eax, ecx
    inc eax
    div ebx
    test edx, edx
    jz border1
    mov eax, edi
    sub eax, ebx
    cmp ecx, eax
    jae border1
    
push_neighbors_and_pixel:
    mov eax, ecx
    mov ebx, [img_width]
    sub eax, ebx
    push dword [esi + 4 * eax] ; up
    mov eax, ecx
    add eax, ebx
    push dword [esi + 4 * eax] ; down
    mov eax, ecx
    dec eax
    push dword [esi + 4 * eax] ; left
    add eax, 2
    push dword [esi + 4 * eax] ; right
    push dword [esi + 4 * ecx] ; pixel
    
border1:
    inc ecx
    cmp ecx, edi
    jne next_pixel
    
    mov ecx, edi
    dec ecx
    
blur_pixel:
    mov ebx, dword [img_width]
    cmp ecx, ebx
    jb border2
    xor edx, edx
    mov eax, ecx
    div ebx
    test edx, edx
    jz border2
    xor edx, edx
    mov eax, ecx
    inc eax
    div ebx
    test edx, edx
    jz border2
    mov eax, edi
    sub eax, ebx
    cmp ecx, eax
    jae border2
    
    pop eax
    mov edx, dword 4
    
pop_neighbor:
    pop ebx
    add eax, ebx
    dec edx
    jnz pop_neighbor
    
    xor edx, edx
    mov ebx, dword 5
    div ebx
    mov [esi + 4 * ecx], dword eax

border2:
    dec ecx
    cmp ecx, 0
    jnl blur_pixel
    
    push dword [img_height]
    push dword [img_width]
    push dword [img]
    call print_image
    add esp, 12
    
    jmp done
    
solve_task7:
    ; TODO Task7
    jmp done

    ; Free the memory allocated for the image.
done:
    push DWORD[img]
    call free_image
    add esp, 4

    ; Epilogue
    ; Do not modify!
    xor eax, eax
    leave
    ret
    