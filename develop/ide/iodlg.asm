  
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

	virtual at r12
		.hu	HU
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
	push rdx

	mov rsi,[pIo]
	add rsi,rcx
	mov [.io.set],cx
	pop [.io.param]

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
		rbx rsi rdi r12 r13

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
	cmp ax,IDCANCEL
	jz	.id_cancel
	cmp ax,IDOK
	jz	.id_ok
	cmp ax,IO_BTN
	jz	.io_btn
	jmp	.ret0

.io_btn:
	 mov r8,FOS_PICKFOLDERS\
		or FOS_NODEREFERENCELINKS\
		or FOS_ALLNONSTORAGEITEMS\
		or FOS_NOVALIDATE \
		or FOS_PATHMUSTEXIST
	xor edx,edx
	xor ecx,ecx
	call [dlg.open]
	test rax,rax
	jz	.ret0

	mov rdi,rax					;--- pnum items
	xor r8,r8
	mov rdx,[rdi+16]		;--- files
	mov rcx,[rdi+8]			;--- ppath
	call wspace.set_dir
	test eax,eax
	jz	.ret0
	
	mov rbx,rax
	mov r12,[pHu]

	mov rdx,rax
	mov rcx,[.hu.hCbx]
	call cbex.is_param
	mov r8,rax
	inc rax
	jnz	.io_btnA

	mov rcx,rbx
	call .fill_kdirs
	mov r8,rcx

.io_btnA:
	mov rcx,[.hu.hCbx]
	call cbex.sel_item

	mov rcx,[rdi+8]
	call apiw.co_taskmf
	mov rcx,[rdi+16]
	call apiw.co_taskmf
	mov rcx,rdi
	call art.a16free
	jmp	.ret0

	sub rsp,\
		FILE_BUFLEN
	mov rsi,rsp

	push 0
	push rcx
	push uzSlash
	push rdx
	push rsi
	push 0
	call art.catstrw







	jmp	.ret0
	
.id_ok:
.id_cancel:
	mov r12,[pHu]
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
	mov [.hu.rc],rax
	mov rax,[rsp+8]
	mov [.hu.rc+8],rax

;@break
	mov rcx,[.hu.hCbx]
	call cbex.get_cursel
	mov r8,rax
	inc rax
	cmovz r8,rax

	sub rsp,\
		FILE_BUFLEN

	mov rdx,r8
	mov rcx,[.hu.hCbx]
	mov r8,rsp
	call cbex.get_item
	inc rax
	cmovz rdx,rax
	mov [.io.ldir],rdx

	mov r9,rsp
	mov rcx,[.hu.hEdi]
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

.wm_initd:
	mov r12,[pHu]
	mov eax,IDCANCEL
	mov rsi,r9
	mov rbx,rcx
	test r9,r9
	jz	.id_cancel

;@break
	mov r8,r9
	call apiw.set_wldata

	mov rax,rbx
	lea rdi,[.hu.hDlg]
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
	
.wm_initdA:
	mov rcx,rbx
	call apiw.get_dlgitem
	pop rdx
	stosq
	test edx,edx
	jnz .wm_initdA

	movzx eax,[.io.set]

	sub rsp,\
		FILE_BUFLEN
	mov rdi,rsp

	cmp ax,IO_SAVECUR
	jz	.wm_initdIOSC
	cmp ax,IO_NEWNAME
	jz	.wm_initdIONN
	cmp ax,IO_SAVEWSP
	jz	.wm_initdWSPS
	cmp ax,IO_NEWLNK
	jz	.wm_initdNL
	jmp .wm_initdF

.wm_initdNL:
	;--- IO_NEWLNK set ---
	push 0
	push [.hu.hStc1]
	push UZ_LNK_DESC
	push [.hu.hStc2]
	push UZ_IO_KDIR
	push [.hu.hBtn]
	push MI_PA_BROWSE
	push [.hu.hStc3]
	push UZ_LNK_MAP
	push [.hu.hEdi]
	push UZ_LNK_NAME
	push rbx
	push UZ_INFO_LNK
	push [.hu.hOk]
	push UZ_OK
	push [.hu.hCanc]
	mov ecx,UZ_CANCEL
	jmp .wm_initdB
	
.wm_initdWSPS:
	;--- IO_SAVEWSP set ---
	push 0
	push [.hu.hStc1]
	push UZ_IO_SELDPF
	push [.hu.hStc2]
	push UZ_IO_DPATH
	push [.hu.hBtn]
	push MI_PA_BROWSE
	push [.hu.hStc3]
	push UZ_IO_DFNAME
	push [.hu.hEdi]
	push UZ_WSP_EXT
	push rbx
	push UZ_IO_SAVEWSP
	push [.hu.hOk]
	push UZ_OK
	push [.hu.hCanc]
	mov ecx,UZ_CANCEL
	jmp .wm_initdB
	
.wm_initdIONN:
	;--- IO_NEWNAME set ---
	push 0
	push [.hu.hStc1]
	push UZ_IO_SELDPF
	push [.hu.hStc2]
	push UZ_IO_DPATH
	push [.hu.hBtn]
	push MI_PA_BROWSE
	push [.hu.hStc3]
	push UZ_IO_DFNAME
	push [.hu.hEdi]
	push UZ_IO_EXT
	push rbx
	push MI_FI_NEWF
	push [.hu.hOk]
	push UZ_OK
	push [.hu.hCanc]
	mov ecx,UZ_CANCEL
	jmp .wm_initdB

.wm_initdIOSC:
	;--- IO_SAVECUR set ---
	push 0
	push [.hu.hStc1]
	push UZ_IO_SELDPF
	push [.hu.hStc2]
	push UZ_IO_DPATH
	push [.hu.hBtn]
	push MI_PA_BROWSE
	push [.hu.hStc3]
	push UZ_IO_DFNAME
	push [.hu.hEdi]
	push UZ_IO_EXT
	push rbx
	push MI_FI_SAVE
	push [.hu.hOk]
	push UZ_OK
	push [.hu.hCanc]
	mov ecx,UZ_NO

.wm_initdB:
	;--- set strings and handles --------
	mov r8,rdi
	mov edx,U16
	call [lang.get_uz]

	mov r9,rdi
	pop rcx
	call win.set_text

	pop rcx
	test ecx,ecx
	jnz	.wm_initdB

;.wm_initdC:
	mov rsp,rdi

	;--- set last position -------------
	mov rdx,rsp
	mov rcx,rbx
	call apiw.get_winrect

	mov rax,[.hu.rc]
	mov rdx,[rsp]
	test rax,rax
	jnz	.wm_initdD
	mov [.hu.rc],rdx

	mov rax,[.hu.rc+8]
	mov rdx,[rsp+8]
	test rax,rax
	jnz	.wm_initdD
	mov [.hu.rc+8],rdx

.wm_initdD:
	mov eax,SWP_NOZORDER
	mov r11d,[.hu.rc.bottom]
	sub r11d,[.hu.rc.top]
	mov r10d,[.hu.rc.right]
	sub r10d,[.hu.rc.left]
	mov r9d,[.hu.rc.top]
	mov r8d,[.hu.rc.left]
	mov rdx,HWND_TOP
	mov rcx,rbx
	call apiw.set_wpos

	;--- set imagelists on known directories ----
	mov r9,[hsmSysList]
	mov rcx,[.hu.hCbx]
	call cbex.set_iml

	;--- set known dirs -------------
	xor edx,edx
	mov rcx,.fill_kdirs
	call wspace.list_dir

	;--- try set last dir -------------
	mov r8,[.io.ldir]
	test r8,r8
	jz	.wm_initdE

	mov rdx,r8
	mov rcx,[.hu.hCbx]
	call cbex.is_param
	mov r8,rax
	inc rax
	cmovz r8,rax

.wm_initdE:
	;--- select default kdir
	mov rcx,[.hu.hCbx]
	call cbex.sel_item

	;--- try set edit
	mov rax,qword[.io.buf]
	test rax,rax
	jz	.wm_initdE1

	lea r9,[.io.buf]
	mov rcx,[.hu.hEdi]
	call win.set_text

.wm_initdE1:
	;--- try set param
	mov rax,[.io.param]
	test rax,rax
	jz	.wm_initdF

	cmp [.io.set],\
		IO_SAVECUR
	jnz	.wm_initdF

	;--- param is LABFILE for IO_SAVECUR
	lea r9,[rax+\
		sizeof.LABFILE]
	mov rcx,[.hu.hStc1]
	call win.set_text
	
.wm_initdF:	

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
	;--- in RCX dir
	;--- in R12 pHu

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
	mov rcx,[.hu.hCbx]
	call cbex.ins_item
	mov ecx,eax
	xor eax,eax
	inc eax
	pop rbx
	ret 0

