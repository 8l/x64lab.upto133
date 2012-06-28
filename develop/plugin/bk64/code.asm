  
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


bk64:

.attach:
	mov rsi,rsp
	and rsp,-16

	xor rcx,rcx
	sub rsp,20h
	call [CoInitialize]
	add rsp,20h

	mov rdi,apiw.loadcurs
	mov rbx,rcx
	mov [g.hInst],rcx

	mov rdx,IDC_SIZENS
	xor ecx,ecx
	call rdi
	mov [g.hNSCurs],rax

	mov rdx,IDC_SIZEWE
	xor ecx,ecx
	call rdi
	mov [g.hWECurs],rax

	mov rdx,IDC_ARROW
	xor ecx,ecx
	call rdi
	mov [g.hDefCurs],rax

	mov rdi,apiw.get_sysmet
	mov ecx,SM_CXSIZEFRAME
	call rdi
	mov [g.cx_sframe],ax

	mov ecx,\
		SM_CYSIZEFRAME
	call rdi
	mov [g.cy_sframe],ax

	mov ecx,\
		SM_CYSMCAPTION	
	call rdi
	mov [g.cy_caption],ax

	mov ecx,\
		SM_CYBORDER	
	call rdi
	mov [g.cy_border],ax

	mov ecx,\
		SM_CXSMICON
	call rdi
	mov [g.cx_smicon],ax

	mov ecx,\
		SM_CYSMICON
	call rdi
	mov [g.cy_smicon],ax

	mov ecx,\
		SM_CXSMSIZE
	call rdi
	mov [g.cx_smsize],ax

	mov ecx,\
		SM_CXSMSIZE
	call rdi
	mov [g.cy_smsize],ax

	mov ecx,00B6C0CCh;;00D9E1B9h;;53EC1Eh;
	call apiw.create_sbrush
	mov [g.hBrush],rax

	mov r10,patt_bmp
	mov r9,1
	mov r8,1
	mov rdx,8
	mov rcx,8
	call apiw.create_bmp
	mov rdi,rax

	mov rcx,rax
	call apiw.create_pbrush
	mov [g.hPattern],rax

.attachA:
	mov rcx,rdi
	call apiw.delobj

.ok_attach:	
	xor eax,eax
	inc eax

.err_attach:
	mov rsp,rsi
	ret 0

.detach:
	mov rsi,rsp
	and rsp,-16
	xor ecx,ecx
	sub rsp,20h
	call [CoUninitialize]
	mov rcx,[g.hBrush]
	call apiw.delobj
	mov rdi,[g.hPattern]
	jmp	.attachA


;.opend:
	;--- in RCX parent
	;--- in RDX flags
	;--- in R8 title
	;--- in R9 

;proc openfile def_uses,\
;	_parent,\
;	_flags,\
;	_title,\
;	_filter
;	
;	local .curdir:[512]:BYTE
;	local .errmsg[1024]:BYTE

;.retry_openfile:
;	lea edi,[.curdir]

;	push 512
;	push edi
;	call shared.memzero
;	mov esi,edi

;	mov eax,edi
;	call shared.curdir

;	mov ebx,[pOpenBuffer]
;	push [sizeBuffer]
;	push ebx
;	call shared.memzero

;	mov edi,ofn
;	push sizeof.OPENFILENAME
;	push edi
;	call shared.memzero
;	
;	mov [edi+OPENFILENAME.lpstrInitialDir],esi
;	mov [edi+OPENFILENAME.lStructSize],sizeof.OPENFILENAME
;	m2m [edi+OPENFILENAME.lpstrFile],ebx

;	m2m	[edi+OPENFILENAME.hwndOwner],[_parent]
;	mov	[edi+OPENFILENAME.nFilterIndex],1
;	m2m	[edi+OPENFILENAME.hInstance],[wcx.hInstance]
;	m2m	[edi+OPENFILENAME.lpstrFilter],[_filter]
;	m2m	[edi+OPENFILENAME.lpstrTitle],[_title]

;	mov eax,OFN_EXPLORER or\
;		OFN_PATHMUSTEXIST or \
;		OFN_FILEMUSTEXIST or \
;		OFN_LONGNAMES or \
;		OFN_HIDEREADONLY or \
;		OFN_ENABLESIZING

;	or eax,[_flags]
;	mov	[edi+OPENFILENAME.Flags],eax
;	m2m	[edi+OPENFILENAME.nMaxFile],[sizeBuffer]

;	push edi
;	GetOpenFileName
;	test eax,eax
;	jz	.err_open
;	mov edx,[edi+OPENFILENAME.lpstrFile]
;	movzx ecx,[edi+OPENFILENAME.nFileOffset]
;	mov eax,[edx]

;	rol eax,16
;	test ax,ax
;	jz	.err_open1
;	mov eax,edx
;	ret

;.err_open:
;	xor eax,eax
;	ret

;.err_open1:
;	rol eax,16
;	test ax,ax
;	jz	.err_open
;	movzx ebx,ax
;	lea edx,[.errmsg]
;	push 0
;	push [hBkModule]
;	push USE_DLGERRSTR
;	push 1024
;	push edx
;	call shared.get_errstr
;	cmp edx,FNERR_BUFFERTOOSMALL
;	jz	.try_realloc

;.try_realloc:
;	lea edx,[.errmsg]
;	push pOpenBuffer
;	call shared.vfree
;	test eax,eax
;	jz	.err_open

;	shl ebx,1
;	add ebx,0FFFh
;	and ebx,not 0FFFh		;not necessary

;	mov eax,ebx				
;	call shared.valloc
;	test eax,eax
;	jz	.err_open

;	mov [pOpenBuffer],eax
;	mov [sizeBuffer],ebx
;	jmp	.retry_openfile	
;endp


