%include "io.mac"

section .text
    global otp
    extern printf

otp:

    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length

    xor eax, eax

iterate:
   	mov bl, [esi + eax * 1]  	    	
   	xor bl, [edi + eax * 1]  ;; fac xor intre caracterul din plaintext si caracterul de pe aceeasi pozitie din cheie
   	mov [edx + eax * 1], bl  ;; mut caracterul obtinut in ciphertext
   	inc eax 
   	cmp ecx, eax
   	jg iterate

    popa
    leave
    ret
    
