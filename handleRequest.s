
.intel_syntax noprefix
.section .bss
	.lcomm default_webpage,10000
.section .ro
.section .data
standard_response:
.ascii "this server is written raw assembly"
default_webpage_filename:
.ascii "index.html\0"
.section .text
.global readRequest

readRequest:
# write to stdout
mov rax, 1
mov rdi, 1
lea rsi, [rip + read_content]
mov rdx, 4000 # 4 kb
syscall
jmp analyzeAndProcessRequest
# analyze and process request

analyzeAndProcessRequest:
# GET / POST / HEAD

# short break, i will try to read index.html and give it back
mov rax,0x2
lea rdi,[rip + default_webpage_filename]
mov rsi, 0
mov rdx, 0
syscall

mov r8, rax
mov rdi,rax
mov rax,0
lea rsi,[rip + default_webpage]
mov rdx, 10000 # 10 KB
syscall

mov rax,0x3
mov rdi,r8
syscall


jmp answerRequest


answerRequest:
# answer the request
mov rax, 1
mov rdi, [rip + client_sock_fd]
lea rsi, [rip + default_webpage]
mov rdx, 10000
syscall

# Done answering, closing client_socket
jmp close_client_socket
