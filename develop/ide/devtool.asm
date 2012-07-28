  
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

devtool:
	virtual at rsi
		.io	IODLG
	end virtual

	virtual at r12
		.hu	HU
	end virtual

.start:
	;--- in RCX pBufLen string set
	;--- in RDX param
	;--- ret RAX 0,IDOK
	xor r10,r10
	mov r9,.proc
	mov r8,[hMain]
	mov rdx,IO_DLG
	mov rcx,[hInst]
	call apiw.dlgbp
	ret 0

.proc:
@wpro rbp,\
		rbx rsi rdi

	cmp rdx,\
		WM_INITDIALOG
	jz	.wm_initd
	cmp rdx,\
		WM_COMMAND
	jz	.wm_command
	jmp	.ret0

.wm_command:
	mov rax,r8
	and eax,0FFFFh
	mov [.wparam],rax
	cmp ax,IDCANCEL
	jz	.id_cancel
	cmp ax,IDOK
	jz	.id_ok
	cmp ax,IO_BTN
	jz	.io_btn
	jmp	.ret0

.wm_initd:
	mov rcx,[.hwnd]
	call iodlg.set_pos

	mov rcx,[.hwnd]
	call iodlg.get_hwnds

	push 0            ;--- terminator
	push UZ_OK        ;--- IDOK
	push UZ_CANCEL    ;--- IDCANCEL 
	push UZ_IO_EXT    ;--- IO_EDI
	push UZ_TOOLCMD   ;--- IO_STC3
	push MI_PA_BROWSE ;--- IO_BTN
	push -1           ;--- IO_CBX
	push UZ_IO_KDIR   ;--- IO_STC2
	push UZ_TOOLDESCR ;--- IO_STC1
	push MI_DEVT_ADD  ;--- IO_DLG
	mov rcx,rsp

	call iodlg.set_strings
	jmp	.ret1

.io_btn:
	jmp	.ret0


.id_ok:
.id_cancel:	
	mov rcx,[.hwnd]
	call iodlg.store_pos

	mov rdx,[.wparam]
	mov rcx,[.hwnd]
	call apiw.enddlg
	jmp	.ret1

.ret1:				;message processed
	xor rax,rax
	inc rax
	jmp	.exit

.ret0:
	xor rax,rax
	jmp	.exit

.exit:
	@wepi



.load:
	push .loadA

.discard:
	xor eax,eax
	xor ecx,ecx
	cmp rax,[pDevT]
	jnz	.discardA
	ret 0

.discardA:
	xchg rcx,[pDevT]
	call [top64.free]
	ret 0

.loadA:
	sub rsp,\
	 FILE_BUFLEN

	xor edx,edx
	mov rax,rsp

	;--- check load for config\devtool.utf8
	push rdx
	push uzUtf8Ext
	push uzDevTName
	push uzSlash
	push uzConfName
	push rax
	push rdx
	call art.catstrw
	
	mov rcx,rsp
	call [top64.parse]

	test rax,rax
	jz	.loadE

	mov [pDevT],rax
	;--- RET RCX datasize
	;--- RET RDX numitems

.loadE:
	add rsp,\
		FILE_BUFLEN
	ret 0

