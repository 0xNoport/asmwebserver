
.intel_syntax noprefix
.section .ro
.section .bss
.lcomm test_string,100000
.section .data
filename:
	.ascii "test.txt\0"
.section .text
.global print_anything
print_anything:
	# print text without newline because i cant even print a newline, idk why, this is dumb
	mov rax,1
	mov rdi,1
	lea rsi, [rip + filename]
	mov rdx, 9
	syscall
	ret
.global _start
_start:
	call replace
	call print_anything
	jmp exit
.global replace
replace:
	pop rcx # contains the return address that is now on the top of the stack after calling this function
	mov rax, [rsp]
	mov rdx, [rsp + 8] # first argument # 8 => 8 bits, 1 byte = 1 arg
	push rcx # push the return address on the stack again

	mov rdi, rax # save fd
	mov rax, 0 # read
	lea rsi, QWORD PTR [rip + test_string]
	mov rdx, 100000
	syscall

	# save string in register
	lea rdi, QWORD PTR [rip+test_string]

	# Prepare phase

	# Emptying registers to compare
	xor rax, rax
	xor r8, r8
	xor r9, r9
	xor r10, r10
	xor r11, r11
	xor r12, r12
	xor r13, r13
	xor r14, r14
	xor r15, r15

	

	# RAX register
	# rax => all 64 bit
	# eax => lsb 32 bit
	# ax => lsb 16 bit
	# ah => left 8 bits of ax
	# al => lsb 8 bits (right) of ax

	lea r14, [rip + test_string]
	
my_loop:
	# mov rcx, [rip + test_string]
	

	mov rcx, [r14]

	mov al, cl
	# loop through every character
	test al, al
	jz ende
	add r14, 1 # iterate
	add r8, 1 # count characters
	# call print_anything
	jmp my_loop


ende:                                   #    => return address on stack
	pop rax # popping return address         => stack is empty
	push r8 # push the count of characters   => count of characters is on stack
	push rax # 								 => return address on the top of the stack => on the bottom: r8 & on the top: return address
	ret							 		# 	 => pop return address of the stack => r8 remaining on the stack
exit:
	# exit
	mov rax, 0x3C
	mov rdi, 0
	syscall


