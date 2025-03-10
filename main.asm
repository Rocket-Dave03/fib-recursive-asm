section .data
	hello:     db 'Hello world!',10    ; 'Hello world!' plus a linefeed character
	helloLen:  equ $-hello             ; Length of the 'Hello world!' string
	digits: db '0123456789'

section .text
	global _start

						;                  rdi      rsi    
print:					; void print(char *str, int len);
	mov rdx, rsi		 
	mov rsi, rdi		; Move argumets to proper register from syscall

	mov rax, 1          ; The system call for write (sys_write)
	mov rdi, 1          ; File descriptor 1 - standard output
	                    ;  mov edx,[helloLen] to get it's actual value
	syscall             ; Call the kernel
	ret


digit_char: ; rdi -> rsi
	xor rsi, rsi
	mov sil, byte digits[rdi]
	ret

str_len_of_num: ; rax -> rsi
	push rax
	push rcx
	push r8

	cmp rax, 0
	je slon_exit

	xor rcx, rcx
	mov r8, 10
slon_loop:
	xor rdx, rdx
	div r8; rax/=10; rdx = rax % 10
	inc rcx

	cmp rax, 0
	jne slon_loop

	mov rsi, rcx; return value 
slon_exit:
	pop r8
	pop rcx
	pop rax

	ret

print_num: ; rax
	xor rdx, rdx
	sub rsp, 32			; Max length of u64 is 20 bytes
	mov r10, rsp

	call str_len_of_num
	mov r8, rsi
	xor rsi,rsi

	mov r11, 10

	mov rcx, 0
	cmp rax, 0
	je exit_dl
digit_loop:
	xor rdx, rdx
	div r11; 10

	mov rdi, rdx
	call digit_char
	mov r9, r8
	sub r9, 1
	sub r9, rcx
	mov byte r10[r9], sil
	inc rcx

	cmp rax, 0
	jne digit_loop
	
exit_dl:
	mov rdi, r10
	mov rsi, rcx
	call print

	add rsp, 32
	ret	



_start:
	mov rdi,hello        
	mov rsi,helloLen     
	                     
	call print


	mov rax, 18446744073709551615
	call print_num

	mov rax, 60            ; The system call for exit (sys_exit)
	mov rdi, 0            ; Exit with return code of 0 (no error)
	syscall
