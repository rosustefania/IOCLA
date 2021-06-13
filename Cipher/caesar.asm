%include "io.mac"

section .text
    global caesar
    extern printf

caesar:
    
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length


    xor eax, eax
    xor ebx, ebx

iterate:
    mov bl, [esi + eax * 1]
    cmp ebx, 'Z'      ;; cazul in care caracterul curent este probabil litera mare
    jle maybe_uppercase
    cmp ebx, 'z'      ;; cazul in care caracterul curent este probabil litera mica
    jle maybe_lowercase
    mov [edx + eax * 1], bl ;; caracterul curent nu este litera, il mut direct in ciphertext
    inc eax
    cmp eax, ecx
    jl iterate 


maybe_uppercase:
    cmp ebx, 'A'
    jge modify_uppercase ;; cazul in care este cu siguranta litera mare
    mov [edx + eax * 1] , bl
    inc eax
    cmp eax, ecx
    jl iterate 

modify_uppercase:
    add ebx, edi
    cmp ebx, 'Z'
    jg problem_uppercase ;; cazul in care dupa deplasare se depaseste alfabetul
    mov [edx + eax * 1], bl
    inc eax
    cmp eax, ecx
    jl iterate 


problem_uppercase:  ;; deplasez circular intorcandu-ma pe la inceputul alfabetului
    sub bl, 'Z'
    add bl, ('A' - 1)
    cmp ebx, 'z'
    jg problem_uppercase 
    mov [edx + eax * 1], bl
    inc eax
    cmp eax, ecx
    jl iterate      

maybe_lowercase:
    cmp ebx, 'a'
    jge modify_lowercase ;; cazul in care este cu siguranta litera mare
    mov [edx + eax * 1], bl
    inc eax
    cmp eax, ecx
    jl iterate 

modify_lowercase:
    add ebx, edi
    cmp ebx, 'z'
    jg problem_lowercase ;; cazul in care dupa deplasare se depaseste alfabetul
    mov [edx + eax * 1], bl
    inc eax
    cmp eax, ecx
    jl iterate 


problem_lowercase:  ;; deplasez circular intorcandu-ma pe la inceputul alfabetului
    sub bl, 'z'
    add bl, ('a' - 1)
    cmp ebx, 'z'
    jg problem_lowercase
    mov [edx + eax * 1], bl
    inc eax
    cmp eax, ecx
    jl iterate        


    popa
    leave
    ret

