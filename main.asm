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
	mov sil, byte digits[rdi]
	ret

print_num: ; rax
	mov rax, rdi
	xor rdx, rdx
	sub rsp, 20			; Max length of u64
	mov r10, rsp

	mov r11, 10

	mov rcx, 0
	cmp rax, 0
	je exit_dl
digit_loop:
	div r11; 10

	mov rdi, rdx
	call digit_char
	mov r10[rcx], rsi
	inc rcx

	cmp rax, 0
	jne digit_loop
	
exit_dl:
	mov rdi, r10
	mov rsi, rcx
	call print

	add rsp, 20
	ret	



_start:
	mov rdi,hello        
	mov rsi,helloLen     
	                     
	call print


	mov rax, 2
	call print_num

	mov rax, 60            ; The system call for exit (sys_exit)
	mov rdi, 0            ; Exit with return code of 0 (no error)
	syscall
