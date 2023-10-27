
.intel_syntax noprefix
.section .bss
	.lcomm sock,24    # Reserve space for the sockaddr structure
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

	mov QWORD ptr [sock], rax     # Store the socket file descriptor

	mov word ptr [sock+8], 2
	mov word ptr [sock+10], 8080
	mov dword ptr [sock+12], 0

	# bind the socket
	mov rax,0x31
	mov rdi, QWORD [sock]
	mov rsi, qword [sock+8]
	mov rdx, 16
	xor r10, r10
	syscall

	mov rax,0x3C
	mov rdi,0x00
	syscall
