
.intel_syntax noprefix
.section .bss
.section .ro
.section .data
standard_response:
.ascii "this server is written raw assembly"
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
jmp answerRequest


answerRequest:
# answer the request
mov rax, 1
mov rdi, [rip + client_sock_fd]
lea rsi, [rip + standard_response]
mov rdx, 35
syscall

# Done answering, closing client_socket
jmp close_client_socket
