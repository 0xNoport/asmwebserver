
.include "handleRequest.s"
.intel_syntax noprefix
.section .bss
	.lcomm sock_fd,8
	.lcomm sock_addr,16    # Reserve space for the sockaddr structure
	.lcomm client_sock_fd,8
	.lcomm read_content, 4000 # 4KB space for request
.section .data
author_message:
	.ascii "\nCreated by 44h\n\___________________________________________________________________________\n\___________________________________________________________________________\n                   _____              _____                   \n                  /    /             /    /                   \n                 /    /             /    /        .           \n                /    /             /    /       .'|           \n               /    /             /    /       <  |           \n              /    /  __         /    /  __     | |           \n             /    /  |  |       /    /  |  |    | | .'''-.    \n            /    '   |  |      /    '   |  |    | |/.'''. \\   \n           /    '----|  |---. /    '----|  |---.|  /    | |   \n          /          |  |   |/          |  |   || |     | |   \n          '----------|  |---''----------|  |---'| |     | |   \n                     |  |               |  |    | '.    | '.  \n                    /____\\             /____\\   '---'   '---'\n\___________________________________________________________________________\n\___________________________________________________________________________\n\n\n"
intro_message:
	.ascii "[x] Webserver started on port 80...\n\n"
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
	
	# print authors signature
	mov rax,0x1
	mov rdi,0x1
	lea rsi,[rip + author_message]
	mov rdx,1140
	syscall

	# print Welcome message
	mov rax,0x1
	mov rdi,0x1
	lea rsi,[rip+intro_message]
	mov rdx,37
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

	# socket addr structure
	lea r12, [rip + sock_addr]

	# sin_family (= AF_INET)
	mov WORD ptr [r12], 2

	# sin_port (= 80)
	mov WORD ptr [r12+2], 20480

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

	# Accept syscall
	mov rax, 0x2B
	mov rdi, [rip + sock_fd]
	mov rsi, 0x00
	mov rdx, 0x00
	syscall

	# Store client's file descriptor
	lea r8, [rip + client_sock_fd]
	mov QWORD PTR [r8], rax

	# read in from the client and store in read_content
	mov rax, 0
	mov rdi, [rip + client_sock_fd]
	lea rsi, [rip + read_content]
	mov rdx, 4000 # read 4 kb 
	syscall

	# Analyze the request and answer (handleRequest.s)
	jmp readRequest

close_client_socket:
	# Close client sockets
	mov rdi, [rip + client_sock_fd]
	mov rax, 0x3
	syscall

	# Close server sockets
	mov rax, 0x3
	mov rdi, [rip + sock_fd]
	syscall

	# Exit with exit code 0
	mov rax,0x3C
	mov rdi,0x00
	syscall
