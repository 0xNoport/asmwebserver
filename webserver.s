
.intel_syntax noprefix
.section .bss
	.lcomm sock_fd,8
	.lcomm sock_addr,16    # Reserve space for the sockaddr structure
.section .data
my_string:
	.ascii "hallo:)"
.section .text
.global _start
_start:
	jmp doItNow
.global doItNow
doItNow:
	mov rax,0x1
	mov rdi,0x1
	lea rsi,[rip+my_string]
	mov rdx,0x8
	syscall

	# create a new socket
	mov rax,0x29
	mov rdi,2
	mov rsi,1
	mov rdx,0
	syscall

	# clearing registers to be sure that they are empty
	xor r11, r11
	xor r12, r12

	lea r11, [rip + sock_fd]

	mov QWORD ptr [r11], rax     # Store the socket file descriptor

	lea r12, [rip + sock_addr]

	lea r8, [r12 + 0]
	mov word ptr [r8], 2

	lea r8, [r12 + 2]
	mov word ptr [r8], 8080

	lea r8, [r12 + 4]
	mov dword ptr [r8], 0

	# bind the socket
	mov rax,0x31
	mov rdi, [r11]
	mov rsi, [r12]
	mov rdx, 16
	xor r10, r10
	syscall

	mov rax,0x3C
	mov rdi,0x00
	syscall
