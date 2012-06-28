  
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


iodlg:
	virtual at rsi
		.io	IODLG
	end virtual

	virtual at rbx
		.dir	DIR
	end virtual

	;#---------------------------------------------ö
	;|                IODLG                        |
	;ö---------------------------------------------ü
.start:
	;--- in RCX pBufLen string set
	;--- in RDX param
	;--- ret RAX 0,IDOK
	push rsi
	xor eax,eax
	mov rsi,[pIo]
	mov [.io.set],cl
	mov [.io.param],rdx

.startA:
	mov r10,rsi		;--- param
	mov r9,.proc
	mov r8,[hMain]
	mov rdx,IO_DLG
	mov rcx,[hInst]
	call apiw.dlgbp

.startE:
	pop rsi
	ret 0

.proc:
@wpro rbp,\
		rbx rsi rdi

	cmp rdx,WM_INITDIALOG
	jz	.wm_initdialog
	cmp rdx,WM_COMMAND
	jz	.wm_command
	jmp	.ret0

.wm_command:
	mov rax,r8
	and eax,0FFFFh
	cmp ax,IDCANCEL
	jz	.id_cancel
	cmp ax,IDOK
	jz	.id_ok
	jmp	.ret0
	
.id_ok:
.id_cancel:
	mov rbx,rax
	mov rdi,rcx

	sub rsp,\
		sizeof.RECT
	mov rdx,rsp
	call apiw.get_winrect

	mov rcx,rdi
	call apiw.get_wldata
	test rax,rax
	jz	.id_cancelA

	mov rsi,rax
	mov rax,[rsp]
	mov [.io.rc],rax
	mov rax,[rsp+8]
	mov [.io.rc+8],rax

;@break
	mov rcx,[.io.hCbx]
	call cbex.get_cursel
	mov r8,rax
	inc rax
	cmovz r8,rax

	sub rsp,\
		FILE_BUFLEN

	mov rdx,r8
	mov rcx,[.io.hCbx]
	mov r8,rsp
	call cbex.get_item
	inc rax
	cmovz rdx,rax
	mov [.io.ldir],rdx

	mov r9,rsp
	mov rcx,[.io.hEdi]
	call win.get_text
	test eax,eax
	jz	.id_cancelA
	lea rdx,[.io.buf]
	mov rcx,rsp
	call utf16.copyz
	mov [.io.buflen],ax
	
.id_cancelA:	
	mov rdx,rbx
	mov rcx,rdi
	call apiw.enddlg
	jmp	.ret1


.wm_initdialog:
	mov eax,IDCANCEL
	mov rsi,r9
	mov rbx,rcx
	test r9,r9
	jz	.id_cancel

;@break
	push r12
	push r13
	
	mov r12,\
		apiw.get_dlgitem
	mov r8,r9
	call apiw.set_wldata

	mov rax,rbx
	lea rdi,[.io.hDlg]
	stosq

	push 0
	push IDOK
	push IDCANCEL
	push IO_EDI
	push IO_STC3
	push IO_BTN
	push IO_CBX
	push IO_STC2
	mov edx,IO_STC1
	
.wm_initdialogA:
	mov rcx,rbx
	call r12
	pop rdx
	stosq
	test edx,edx
	jnz .wm_initdialogA

	movzx eax,[.io.set]
	mov r12,[lang.get_uz]
	mov r13,win.set_text

	sub rsp,\
		FILE_BUFLEN
	mov rdi,rsp

	cmp al,IO_SAVECURRENT
	jz	.wm_initdialogIOSC
	cmp al,IO_NEWNAME
	jz	.wm_initdialogIONN
	cmp al,IO_SAVEWSP
	jz	.wm_initdialogWSPS

	jmp .wm_initdialogF

.wm_initdialogWSPS:
	push 0
	push [.io.hStc1]
	push UZ_IO_SELDPF
	push [.io.hStc2]
	push UZ_IO_DPATH
	push [.io.hBtn]
	push MI_PA_BROWSE
	push [.io.hStc3]
	push UZ_IO_DFNAME
	push [.io.hEdi]
	push UZ_WSP_EXT
	push rbx
	push UZ_IO_SAVEWSP
	push [.io.hOk]
	push UZ_OK
	push [.io.hCanc]
	mov ecx,UZ_CANCEL
	jmp .wm_initdialogB
	
.wm_initdialogIONN:
	push 0
	push [.io.hStc1]
	push UZ_IO_SELDPF
	push [.io.hStc2]
	push UZ_IO_DPATH
	push [.io.hBtn]
	push MI_PA_BROWSE
	push [.io.hStc3]
	push UZ_IO_DFNAME
	push [.io.hEdi]
	push UZ_IO_EXT
	push rbx
	push MI_FI_NEWF
	push [.io.hOk]
	push UZ_OK
	push [.io.hCanc]
	mov ecx,UZ_CANCEL
	jmp .wm_initdialogB

.wm_initdialogIOSC:
	;--- IO_SAVECURRENT set
	push 0
	push [.io.hStc1]
	push UZ_IO_SELDPF
	push [.io.hStc2]
	push UZ_IO_DPATH
	push [.io.hBtn]
	push MI_PA_BROWSE
	push [.io.hStc3]
	push UZ_IO_DFNAME
	push [.io.hEdi]
	push UZ_IO_EXT
	push rbx
	push MI_FI_SAVE
	push [.io.hOk]
	push UZ_OK
	push [.io.hCanc]
	mov ecx,UZ_NO

.wm_initdialogB:
	;--- set strings and handles --------
	mov r8,rdi
	mov edx,U16
	call r12

	mov r9,rdi
	pop rcx
	call r13

	pop rcx
	test ecx,ecx
	jnz	.wm_initdialogB

;.wm_initdialogC:
	mov rsp,rdi
	;--- set last position -------------
	mov rdx,rsp
	mov rcx,rbx
	call apiw.get_winrect

	mov rax,[.io.rc]
	mov rdx,[rsp]
	test rax,rax
	jnz	.wm_initdialogD
	mov [.io.rc],rdx

	mov rax,[.io.rc+8]
	mov rdx,[rsp+8]
	test rax,rax
	jnz	.wm_initdialogD
	mov [.io.rc+8],rdx

.wm_initdialogD:
	mov eax,SWP_NOZORDER
	mov r11d,[.io.rc.bottom]
	sub r11d,[.io.rc.top]
	mov r10d,[.io.rc.right]
	sub r10d,[.io.rc.left]
	mov r9d,[.io.rc.top]
	mov r8d,[.io.rc.left]
	mov rdx,HWND_TOP
	mov rcx,rbx
	call apiw.set_wpos

	;--- set imagelists on known directories ----
	mov r9,[hsmSysList]
	mov rcx,[.io.hCbx]
	call cbex.set_iml

	;--- set known dirs -------------
	xor edx,edx
	mov rcx,.fill_kdirs
	call wspace.list_dir

	;--- try set last dir -------------
	mov r8,[.io.ldir]
	test r8,r8
	jz	.wm_initdialogE

	mov rdx,r8
	mov rcx,[.io.hCbx]
	call cbex.is_param
	mov r8,rax
	inc rax
	cmovz r8,rax

.wm_initdialogE:
	;--- select default kdir ------
	mov rcx,[.io.hCbx]
	call cbex.sel_item

	;--- try set edit -------------
	mov rax,qword[.io.buf]
	test rax,rax
	jz	.wm_initdialogE1

	lea r9,[.io.buf]
	mov rcx,[.io.hEdi]
	call win.set_text

.wm_initdialogE1:
	;--- try set param -----------
	mov rax,[.io.param]
	test rax,rax
	jz	.wm_initdialogF

	cmp [.io.set],\
		IO_SAVECURRENT
	jnz	.wm_initdialogF

	;--- param is LABFILE for IO_SAVECURRENT
	lea r9,[rax+\
		sizeof.LABFILE]
	mov rcx,[.io.hStc1]
	call win.set_text
	
.wm_initdialogF:	
	pop r13
	pop r12

.ret1:				;message processed
	xor rax,rax
	inc rax
	jmp	.exit

.ret0:
	xor rax,rax
	jmp	.exit

.exit:
	@wepi

.fill_kdirs:
	;--- in RSI iodlg
	;--- in RCX hCb
	;--- in RDX string
	;--- in R8 imgindex
	;--- in R9 param
	;--- in R10 indent r10b,index overlay rest R10)
	;--- in R11 selimage
	push rbx
	mov rbx,rcx
	lea rdx,[.dir.dir]
	mov r11d,[.dir.iIcon]
	xor r10,r10
	mov r9,rbx
	mov r8d,[.dir.iIcon]
	mov rcx,[.io.hCbx]
	call cbex.ins_item
	xor eax,eax
	inc eax
	pop rbx
	ret 0

