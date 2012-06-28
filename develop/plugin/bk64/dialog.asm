  
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
	;--- ret RAX membuf of textptrs: free art.a16free
	;--- DQ num items, DQ PATH ,DQ text pointers: free using CoTaskMemFree
	push rbp
	push rbx
	push rdi
	push rsi
	push r12

	mov rbp,rsp
	xor eax,eax
	and rsp,-16
	mov r12,r8
	sub rsp,40h
	mov rsi,rsp

	@comptr \
		.pFod,rsi,iFileOpenDialog,\
		.pShia,rsi+8,iShellItemArray,\
		.pShi,rsi+16,iShellItem,\
		.nItems,rsi+24,dq ?,\
		.options,rsi+32,dq ?,\
		.pPath,rsi+40,dq ?,\
		.title,rsi+48,dq ?,\
		.fspec,rsi+56,dq ?

	mov [.title],rcx
	mov [.fspec],rdx

	mov rdi,rsp
	mov ecx,6
	rep stosq
	xor edi,edi		;--- ret value
		
	call apiw.co_init

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
;		FOS_ALLOWMULTISELECT\
;		or FOS_NODEREFERENCELINKS\
;		or FOS_ALLNONSTORAGEITEMS\
;		or FOS_NOVALIDATE \
;		or FOS_PATHMUSTEXIST

	;mov rdx,[.options]
	@comcall .pFod->\
		SetOptions
	test eax,eax
	jl	.openE

	xor edx,edx
	@comcall .pFod->Show
	test eax,eax
	jl	.openE

;@break
	lea rdx,[.pShi]
	xor eax,eax
	mov [rdx],rax
	@comcall .pFod->GetFolder
	test eax,eax
	jl	.openB

	lea r8,[.pPath]
	mov rdx,SIGDN_FILESYSPATH
	@comcall .pShi->GetDisplayName
	mov rbx,rax

	@comcall .pShi->\
		iUnknown.Release

	test ebx,ebx
	jl	.openB

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

	mov rcx,rbx
	add ecx,4			;--- 1 ppath + 1 nitems 2zero
	shl ecx,3
	call art.a16malloc
	test rax,rax
	jz .openC

	mov rdi,rax
	mov [rdi],rbx
	add rdi,8
;@break
	neg rbx
	
	dec rbx
	mov [rsi+48],rax	
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
	mov rdi,[rsi+48]

.openC:
	@comcall .pShia->\
		iUnknown.Release

.openB:
	@comcall .pFod->\
		iUnknown.Release

.openE:
	call apiw.co_uninit
	mov rax,rdi
	mov rsp,rbp
	pop r12
	pop rsi
	pop rdi
	pop rbx
	pop rbp
	ret 0
