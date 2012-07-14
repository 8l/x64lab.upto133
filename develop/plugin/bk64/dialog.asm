  
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


dlg:

.open:
	;--- in RCX title
	;--- in RDX filespec
	;--- in R8 flags
	;--- in R9 startdir

	;--- ret RAX membuf of textptrs: free art.a16free
	;--- DQ num items
	;--- DQ PATH,
	;--- DQ text pointers: free using CoTaskMemFree
	push rbp
	push rbx
	push rdi
	push rsi
	push r12

	mov rbp,rsp
	xor eax,eax
	and rsp,-16
	mov r12,r8
	sub rsp,60h
	mov rsi,rsp
	mov rbx,r9

	@comptr \
		.pFod,rsi,iFileOpenDialog,\
		.pShia,rsi+8,iShellItemArray,\
		.pShi,rsi+16,iShellItem,\
		.nItems,rsi+24,dq ?,\
		.options,rsi+32,dq ?,\
		.pPath,rsi+40,dq ?,\
		.pStartShi,rsi+48,iShellItem,\
		.pRet,rsi+56,dq ?,\
		.title,rsi+64,dq ?,\
		.fspec,rsi+72,dq ?,\
		.tmpShi,rsi+80,iShellItem,\
		.dummy,rsi+88,dq ?

	mov [.title],rcx
	mov [.fspec],rdx

	mov rdi,rsp
	mov ecx,8
	rep stosq
	xor edi,edi		;--- ret value
		
	call apiw.co_init

	test rbx,rbx
	jz	.openF

	mov rcx,rbx
	sub rsp,20h
	lea r9,[.pStartShi]
	lea r8,[iid_Shi]
	xor edx,edx
	call [SHCreateItemFromParsingName]
	add rsp,20h
	test eax,eax
	jnl	.openF

	xor eax,eax
	mov [.pStartShi],rax

.openF:
	lea r10,[.pFod]
	mov r9,iid_FileOD
	mov r8,1
	xor edx,edx
	mov rcx,clsid_FileOD
	call apiw.co_createi
	test eax,eax
	jnz	.openE

	xor eax,eax
	xchg rdx,[.title]
	test rdx,rdx
	mov [.title],rax
	jz	.openD

	@comcall .pFod->SetTitle
	test eax,eax
	jl	.openE

.openD:
	xor eax,eax
	xchg rcx,[.fspec]
	test rcx,rcx
	mov [.fspec],rax
	jz	.openD1

	mov rdx,[rcx]
	lea r8,[rcx+8]
	and edx,0FFh		
	@comcall .pFod->SetFileTypes
	test eax,eax
	jl	.openE
	
.openD1:
;	lea rdx,[.options]
;	@comcall .pFod->\
;		GetOptions
;	test eax,eax
;	jl	.open_fdE
	;mov dword[.options],\

	mov rdx,r12
	@comcall .pFod->SetOptions
	test eax,eax
	jl	.openE

	mov rdx,[.pStartShi]
	test rdx,rdx
	jz	.openD2
	;@comcall .pFod->SetDefaultFolder
	@comcall .pFod->SetFolder

.openD2:
	xor edx,edx
	@comcall .pFod->Show
	test eax,eax
	jl	.openE

	lea rdx,[.pShia]
	@comcall .pFod->GetResults
	test eax,eax
	jl	.openB

	lea rdx,[.nItems]
	@comcall .pShia->GetCount
	mov rbx,[.nItems]
	test eax,eax
	jl	.openC
	test ebx,ebx
	jz	.openC

	lea r8,[.tmpShi]
	xor edx,edx
	@comcall .pShia->GetItemAt
	test eax,eax
	jl	.openC

	lea rdx,[.pShi]
	@comcall .tmpShi->GetParent	
	test eax,eax
	jl	.openC

	lea r8,[.pPath]
	mov rdx,SIGDN_FILESYSPATH
	@comcall .pShi->GetDisplayName

	@comcall .tmpShi->\
		iUnknown.Release

	@comcall .pShi->\
		iUnknown.Release
	
	mov rcx,rbx
	add ecx,4			;--- 1 ppath + 1 nitems 2zero
	shl ecx,3
	call art.a16malloc
	test rax,rax
	jz .openC

	mov rdi,rax
	mov [rdi],rbx
	add rdi,8
	neg rbx
	
	dec rbx
	mov [.pRet],rax	
	jmp .openA2

.openA:
	lea r8,[.pShi]
	xor eax,eax
	mov rdx,rbx
	mov [r8],rax
	mov [rdi],rax
	mov [.pPath],rax
	add rdx,[.nItems]
	@comcall .pShia->\
		GetItemAt
	test eax,eax
	jl	.openC

	lea r8,[.pPath]
	mov rdx,SIGDN_NORMALDISPLAY
	@comcall .pShi->\
		GetDisplayName
	test eax,eax
	jl	.openC

	@comcall .pShi->\
		iUnknown.Release

.openA2:
	mov rax,[.pPath]
	mov [rdi],rax
	add rdi,8
	inc rbx
	jnz	.openA
	mov rdi,[.pRet]

.openC:
	@comcall .pShia->\
		iUnknown.Release

.openB:
	@comcall .pFod->\
		iUnknown.Release

.openE:
	mov rax,[.pStartShi]
	test rax,rax
	jz	.openE1
	
	@comcall .pStartShi->\
		iUnknown.Release

.openE1:
	call apiw.co_uninit
	mov rax,rdi
	mov rsp,rbp
	pop r12
	pop rsi
	pop rdi
	pop rbx
	pop rbp
	ret 0
