
.intel_syntax noprefix
.section .bss
.section .text
.global handleRequest
handleRequest:
	# write to stdout
	mov rax, 1
	mov rdi, 1
	lea rsi, [rip + read_content]
	mov rdx, 254
	syscall

	jmp close_client_socket

.section .ro
.section .data
