%include "io.mac"

section .text
    global my_strstr
    extern printf

section .data
    needle_len dd 0
    haystack_len dd 0
    correct_chars dd 0
    index dd  0    

my_strstr:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; substr_index
    mov     esi, [ebp + 12]     ; haystack
    mov     ebx, [ebp + 16]     ; needle
    mov     ecx, [ebp + 20]     ; haystack_len
    mov     edx, [ebp + 24]     ; needle_len


    mov dword[haystack_len], ecx
    mov dword[needle_len], edx
    mov dword[correct_chars], 0 ;; retine pozitia caracterului pe care ma aflu in needle
    mov dword[index], 0 ;; retine numarul de caractere parcuse din text


iterate:
    mov al, [esi]
    mov cl, [ebx]
    cmp eax, ecx
    je go_on_needle  ;; daca caracterul din needle este la fel cu cel din haystack inaintez in ambele  
    sub ebx, dword[correct_chars]
    mov dword[correct_chars], 0
    cmp [esi], byte 0
    je stop 
    inc esi
    inc dword[index]
    jmp iterate

go_on_needle:
    inc dword[correct_chars]
    mov eax, dword[correct_chars]
    cmp eax, dword[needle_len] 
    je found ;; daca s-a ajuns la sfarsitul needle-lui inseamna ca acesta s-a gasit in haystack
    cmp [esi], byte 0
    je stop
    inc esi
    cmp [ebx], byte 0 
    je stop  
    inc ebx
    inc dword[index]
    jmp iterate    

found:
    mov eax, dword[index]
    sub eax, dword[correct_chars] ;; obtin pozitia aparitiei primului caracter din needle 
    add eax, 1
    mov edx, [ebp + 8]
    mov [edx], eax
    popa
    leave
    ret
      
stop:
    mov eax, dword[needle_len] 
    cmp dword[correct_chars], eax ;; s-a ajuns la finalul haystack-ului, dar needle se regaseste 
    je found
    cmp dword[correct_chars], 0
    je not_found ;; nu s-a gasit nicio aparitia a lui needle in haystack
    popa
    leave
    ret

not_found:
    mov edx, [ebp + 8]
    mov eax, dword[haystack_len] ;; se returneaza lungimea haystack-ului + 1
    inc eax
    mov [edx], eax
    popa
    leave
    ret
