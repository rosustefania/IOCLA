%include "io.mac"

section .text
    global vigenere
    extern printf

section .data
    count_chars dd 0
    key_len dd 0
    text_len dd 0 

vigenere:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     ecx, [ebp + 16]     ; plaintext_len
    mov     edi, [ebp + 20]     ; key
    mov     ebx, [ebp + 24]     ; key_len
   
    xor eax, eax
    mov dword[key_len], ebx
    mov dword[text_len], ecx
    mov dword[count_chars], 0 ;; retin nr de litere parcurse in text, pt a sti pe ce caracter ma situez in cheie 
    
iterate:        
    mov cl, [esi + eax]
    cmp cl, 'Z'
    jle maybe_uppercase ;; cazul in care caracterul curent este probabil litera mare
    cmp ecx, 'z'
    jle maybe_lowercase ;; cazul in care caracterul curent este probabil litera mica
    mov [edx + eax], cl
    inc eax
    cmp eax, dword[text_len] ;; caracterul curent nu este litera, il mut direct in ciphertext
    jl iterate
    jmp stop


maybe_uppercase:
    cmp ecx, 'A'
    jge uppercase ;; cazul in care este cu siguranta litera mare
    mov [edx + eax], cl
    inc eax
    cmp eax, dword[text_len]
    jl iterate
    jmp stop

maybe_lowercase:
    cmp ecx, 'a'
    jge lowercase ;; cazul in care este cu siguranta litera mica
    mov [edx + eax], cl
    inc eax
    cmp eax, dword[text_len]
    jl iterate
    jmp stop

uppercase:
    mov ebx, dword[count_chars]
    cmp ebx, dword[key_len]
    jge modify_uppercase ;; daca s-a ajuns ma deplasez cicular pe carcterele cheii, obtinand caracterul corect
    add cl, [edi + ebx]
    sub cl, 'A'
    cmp ecx, 'Z'
    jg problem_uppercase ;; cazul in care dupa deplasare se depaseste alfabetul
    mov [edx + eax], cl
    inc dword[count_chars]
    inc eax
    cmp eax, dword[text_len]
    jl iterate
    jmp stop

lowercase:
    mov ebx, dword[count_chars]
    cmp ebx, dword[key_len]
    jge modify_lowercase ;; daca s-a ajuns ma deplasez cicular pe carcterele cheii, obtinand caracterul corect
    add cl, [edi + ebx]
    sub cl, 'A'
    cmp ecx, 'z'
    jg problem_lowercase ;; cazul in care dupa deplasare se depaseste alfabetul
    mov [edx + eax], cl
    inc dword[count_chars]
    inc eax
    cmp eax, dword[text_len]
    jl iterate
    jmp stop

problem_lowercase: ;; deplasez circular intorcandu-ma pe la inceputul alfabetului
    sub cl, 'z'
    add cl, ('a' - 1)
    cmp ecx, 'z'
    jg problem_lowercase 
    mov [edx + eax], cl
    inc dword[count_chars]
    inc eax
    cmp eax, dword[text_len]
    jl iterate
    jmp stop

problem_uppercase: ;; deplasez circular intorcandu-ma pe la inceputul alfabetului
    sub cl, 'Z'
    add cl, ('A' - 1)
    cmp ecx, 'Z'
    jg problem_uppercase
    mov [edx + eax], cl
    inc dword[count_chars]
    inc eax
    cmp eax, dword[text_len]
    jl iterate
    jmp stop

modify_uppercase: ;; ma deplasez circular pe cheie intorcandu-ma pe la inceputul ei
    sub ebx, dword[key_len]
    cmp ebx, dword[key_len]
    jge modify_uppercase
    add cl, [edi + ebx]
    sub cl, 'A'
    cmp ecx, 'Z'
    jg problem_uppercase ;; cazul in care dupa deplasare se depaseste alfabetul
    mov [edx + eax], cl
    inc dword[count_chars]
    inc eax
    cmp eax, dword[text_len]
    jl iterate
    jmp stop

modify_lowercase: ;; ma deplasez circular pe cheie intorcandu-ma pe la inceputul ei
    sub ebx, dword[key_len]
    cmp ebx, dword[key_len]
    jge modify_lowercase 
    sub ecx, 'A'
    add cl, [edi + ebx]        
    cmp ecx, 'z'
    jg problem_lowercase ;; cazul in care dupa deplasare se depaseste alfabetul
    mov [edx + eax], cl
    inc dword[count_chars]
    inc eax
    cmp eax, dword[text_len]
    jl iterate
    jmp stop


stop:
    popa
    leave
    ret
