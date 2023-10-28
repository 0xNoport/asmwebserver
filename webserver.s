
.intel_syntax noprefix
.section .bss
	.lcomm sock_fd,8
	.lcomm sock_addr,16    # Reserve space for the sockaddr structure
.section .data
my_string:
	.ascii "hallo:)"
drei:
	.ascii "drei\n"
nichtdrei:
	.ascii "nichtdrei\n"
.section .text
.global _start
_start:
	jmp doItNow
.global doItNow
doItNow:
	# print hello, just because i like it
	mov rax,0x1
	mov rdi,0x1
	lea rsi,[rip+my_string]
	mov rdx,0x7
	syscall

	# create a new socket
	mov rax,0x29
	mov rdi,2
	mov rsi,1
	mov rdx,0
	syscall

	# Write into the .bss variable (store the fd)
	lea r11, [rip + sock_fd]
	mov QWORD ptr [r11], rax     # Store the socket file descriptor
	push rax

	# socket addr structure
	lea r12, [rip + sock_addr]

	# sin_family (= AF_INET)
	mov WORD ptr [r12], 2

	# sin_port (= 8080)
	mov WORD ptr [r12+2], 8080

	# sin_addr (ipv4, default address)
	mov QWORD ptr [r12+4], 0

	# bind the socket
	mov rax,0x31
	mov rdi, [rip + sock_fd]
	
	# rsi takes a pointer to a struct of type sock_addr (const struct sock_addr *addr)
	# r12 is holding [rip+sock_addr]
	mov rsi, r12
	mov rdx, 16
	xor r10, r10
	syscall

	# listen syscall
	mov rax, 0x32
	mov rdi, [rip + sock_fd]
	mov rsi, 2
	syscall

	# Exit with exit code 0
	mov rax,0x3C
	mov rdi,0x00
	syscall
