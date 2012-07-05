  
  ;#-------------------------------------------------ß
  ;|          x64lab  MPL 2.0 License                |
  ;|   Copyright (c) 2009-2012, Marc Rainer Kranz.   |
  ;|            All rights reserved.                 |
  ;ö-------------------------------------------------ä

  ;#-------------------------------------------------ß
  ;| uft-8 encoded üäöß
  ;| update:
  ;| filename:
  ;ö-------------------------------------------------ä

accel:

	;ü-----------------------------------------ö
	;|     .setup                              |
	;#-----------------------------------------ä

.setup:
	;--- ret RAX 0,hAccel
	push rbp
	push rbx
	push rdi
	push rsi
	push r12
	push r13
	push r14

	mov rbp,rsp
	and rsp,-16

	xor edx,edx
	sub rsp,\
		FILE_BUFLEN
	xor r12,r12
	mov rax,rsp
	mov r13,[pKeya]

	;--- check for config\accels.utf8
	push rdx
	push uzUtf8Ext
	push uzAccelName
	push uzSlash
	push uzConfName
	push rax
	push rdx
	call art.catstrw

	mov rcx,rsp
	call [top64.parse]

	test rax,rax
	jz	.setupE
	dec edx			;--- no/1 items
	jle	.setupE
	mov r12,rdx
	inc edx
	shl edx,3
	sub rsp,rdx
	mov rdi,rsp

	mov rbx,rax
	mov rsi,rax
	mov r14,rsp	;--- stack start of table

	cmp [rbx+\
		TITEM.type],TLABEL
	jnz	.setupF
	
.setupA:
	mov rdx,1FFF'00FF'001Fh
	;---    -ID-  KEY  FLAG

	mov esi,[rsi+\
		TITEM.attrib]
	add rsi,rbx
	cmp rbx,rsi
	jz	.setupG

	cmp [rsi+\
		TITEM.type],TNUMBER
	jnz	.setupA
	mov rax,qword[rsi+\
		TITEM.qword_val]

	;--- check if > MI_OTHER or MI_USER
	and rax,rdx
	mov r8,rax
	stosw
	shr rax,16
	movzx ecx,ax
	stosd

	shr rax,16
	cmp ax,MI_OTHER
	jae .setupA

	sub ax,MNU_X64LAB
	shl eax,5			;--- x 8 sizeof.KEYA
	add rax,r13

	mov [rax+KEYA.fVirt],r8l
	mov [rax+KEYA.cmd],cx
	lea rdx,[rax+KEYA.name]

;@break
	test r8l,FCONTROL
	jz	@f
	mov word[rdx],24D2h	; small enclosed c
	add rdx,2
@@:	
	test r8l,FALT
	jz	@f
	mov word[rdx],24D0h	; small enclosed a
	add rdx,2
@@:	
	test r8l,FSHIFT
	jz	@f
	mov word[rdx],24E2h	; small enclosed s
	add rdx,2
@@:	
	call .get_vkname

	jmp	.setupA

.setupG:
	mov rdx,r12
	mov rcx,r14
	call apiw.create_acct
	mov r12,rax

.setupF:
	mov rcx,rbx
	call [top64.free]
	
.setupE:
	mov rax,r12
	mov rsp,rbp
	pop r14
	pop r13
	pop r12
	pop rsi
	pop rdi
	pop rbx
	pop rbp
	ret 0


.get_vkname:
	;--- in RCX virtual key
	push rdx
	mov rdx,MAPVK_VK_TO_VSC
	call apiw.map_vk
	shl rax,16
	mov r8,11
	pop rdx
	mov rcx,rax
	call apiw.get_keynt
	ret 0
