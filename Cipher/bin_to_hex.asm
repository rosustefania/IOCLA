%include "io.mac"

section .text
    global bin_to_hex
    extern printf

section .data
    hex_len dd 0
    bin_len dd 0
    value dd 0
    count_bits dd 0 ;; ma folosesc de ea pt ca parcurge cate 4 "biti" din bin_sequence

bin_to_hex:
  
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; hexa_value
    mov     esi, [ebp + 12]     ; bin_sequence
    mov     ecx, [ebp + 16]     ; length


    ;; impart numarul de caractere din bin_sequence pt a vedea de cate 
    ;; caractere am nevoie in haxa_value
    mov dword[value], 0
    mov dword[bin_len], ecx
    mov al, cl
    mov bl, 4
    div bl 
    xor ebx, ebx
    mov cl, ah
    mov bl, al      
    xor eax, eax
    cmp ecx, 0
    je rest_zero ;; daca restul e mai mare decat 0 mai am nevoie de un caracter in plus in hexa_value
    inc bl
    mov dword[hex_len], ebx
    dec ebx
    mov ecx, dword[bin_len]
    dec ecx
    jmp iterate

rest_zero:
    mov dword[hex_len], ebx
    dec ebx
    mov ecx, dword[bin_len]
    dec ecx
    jmp iterate

iterate:
    inc dword[count_bits] ;; tratez ca si cum as avea "seturi de cate 4 biti/caractere"
    cmp dword[count_bits], 1 ;; cazul in care ma aflu pe primul bit/ caracter din set
    je first_bit
    cmp dword[count_bits], 2 ;; cazul in care ma aflu pe al doilea bit/ caracter din set
    je second_bit
    cmp dword[count_bits], 3 ;; cazul in care ma aflu pe al treilea bit/ caracter din set
    je third_bit
    cmp dword[count_bits], 4 ;; cazul in care ma aflu pe al patrulea bit/ caracter din set
    je fourth_bit
    jmp put_value ;; daca am parcus tot setul pun valoarea corespunzatoare in hexa_value

first_bit:  
    mov eax, [esi + ecx]
    cmp al, 49  ;; verific daca bitul este 1 sau 0
    jz add_first  
    dec ecx
    cmp ecx, 0
    jge iterate
    jmp put_value

add_first: ;; daca primul bit din set este 1, in valoarea setului se adauga 1
    mov eax, dword[value]
    add eax, 1 ;; 2 ^ 0 = 1 
    mov dword[value], eax
    dec ecx
    cmp ecx, 0
    jge iterate
    jmp put_value

second_bit:
    mov eax, [esi + ecx]
    cmp al, 49 ;; verific daca bitul este 1 sau 0
    jz add_second 
    dec ecx
    cmp ecx, 0
    jge iterate
    jmp put_value


add_second: ;; daca al doilea bit din set este 1, in valoarea setului se adauga 2
    mov eax, dword[value]
    add eax, 2 ;; 2 ^ 1 = 2
    mov dword[value], eax
    dec ecx
    cmp ecx, 0
    jge iterate
    jmp put_value


third_bit:
    mov eax, [esi + ecx]
    cmp al, 49 ;; verific daca bitul este 1 sau 0
    jz add_third
    dec ecx
    cmp ecx, 0
    jge iterate
    jmp put_value


add_third: ;; daca al treilea bit din set este 1, in valoarea setului se adauga 4
    mov eax, dword[value]
    add eax, 4 ;; 2 ^ 2 = 4
    mov dword[value], eax
    dec ecx
    cmp ecx, 0
    jge iterate
    jmp put_value


fourth_bit:
    mov eax, [esi + ecx]
    cmp al, 49 ;; verific daca bitul este 1 sau 0
    jz add_fourth
    jmp put_value


add_fourth: ;; daca al patrulea bit din set este 1, in valoarea setului se adauga 8
    mov eax, dword[value]
    add eax, 8 ;; 2 ^ 3 = 8
    mov dword[value], eax
    jmp put_value


put_value: ;; converteste valoarea setului in caracterul ce este adaugat in hexa_value
    mov eax, dword[value]
    cmp eax, 10
    jge after_ten ;; daca valoarea este mai mare sau egala cu 10, in hexa va fi o litera
    add al, '0'
    mov [edx + ebx], al
    mov eax, [edx + ebx]
    mov dword[count_bits], 0
    mov dword[value], 0
    dec ebx
    dec ecx
    cmp ecx, 0
    jge iterate 
    jmp final

after_ten:
    sub al, 10
    add al, 'A'
    mov [edx + ebx], al
    mov dword[count_bits], 0
    mov dword[value], 0
    dec ebx
    dec ecx
    cmp ecx, 0
    jge iterate 
    jmp final

final: ;; adauga newline la finalul fiecarui string hexa obtinut
    mov al, 10
    mov ebx, dword[hex_len] 
    mov [edx + ebx], al
    popa
    leave
    ret
  