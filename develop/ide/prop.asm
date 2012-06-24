
	;#-------------------------------------------------ü
	;|          x64lab  MPL 2.0 License                |
	;|   Copyright (c) 2009-2012, Marc Rainer Kranz.   |
	;|            All rights reserved.                 |
	;|-------------------------------------------------|
	;|      Dienstag] - 19.Juni.2012 - 10:51:19        |
	;ä-------------------------------------------------ö


prop:
	virtual at rbx
		.cp CPROP
	end virtual

.proc:
@wpro rbp,\
		rbx rsi rdi

	cmp rdx,WM_INITDIALOG
	jz	.wm_initdialog
	cmp rdx,WM_WINDOWPOSCHANGED;WM_SIZE;
	jz	.wm_poschged
	jmp	.ret0

.wm_poschged:
;@break
	mov rbx,[pCp]
	sub rsp,sizeof.RECT*2
	lea rdx,[rsp]
	mov rcx,[.hwnd]
	call apiw.get_clirect

	lea rdx,[rsp+16]
	mov rcx,[.cp.hCbxCat]
	call apiw.get_winrect
	;----------------------------------
	mov eax,SWP_NOZORDER
	mov r11d,[rsp+16+RECT.bottom]
	sub r11d,[rsp+16+RECT.top]
	mov rdi,r11

	mov r10d,[rsp+RECT.right]
	mov rsi,r10

	mov r9,CY_GAP
	mov r8d,0;CX_GAP
	mov rdx,HWND_TOP
	mov rcx,[.cp.hCbxCat]
	call apiw.set_wpos

	;----------------------------------
	mov eax,SWP_NOZORDER
	mov r11,rdi
	
	mov r10,rsi
	mov r9,rdi
	add r9,CY_GAP*2

	mov r8d,0;CX_GAP
	mov rdx,HWND_TOP
	mov rcx,[.cp.hCbxFilt]
	call apiw.set_wpos

	;----------------------------------
	mov eax,SWP_NOZORDER ;or SWP_NOSENDCHANGING ;or SWP_NOREDRAW
	mov r11,rdi
	shr r11,1
	mov r10,rsi
	mov r9,rdi
	add r9,rdi
	add r9,CY_GAP*3
	mov r8d,0;CX_GAP
	mov rdx,HWND_TOP
	mov rcx,[.cp.hPrg]
	call apiw.set_wpos

	;--------------------------------------------
	mov eax,SWP_NOZORDER ;or SWP_DRAWFRAME
	mov r10,rsi
	mov r9,rdi
	shr r9,1
	add r9,rdi
	add r9,rdi
	add r9,CY_GAP*4
	mov r11d,[rsp+RECT.bottom]
	sub r11,r9
	sub r11,CY_GAP
	mov r8d,0;CX_GAP
	mov rdx,HWND_TOP
	mov rcx,[.cp.hLview]
	call apiw.set_wpos
	jmp	.ret0

.wm_initdialog:
;	@break
	mov rbx,[pCp]
	mov rdx,PROP_CBX_CAT
	mov rcx,[.hwnd]
	call apiw.get_dlgitem
	mov [.cp.hCbxCat],rax

	mov rdx,PROP_CBX_FILT
	mov rcx,[.hwnd]
	call apiw.get_dlgitem
	mov [.cp.hCbxFilt],rax

	mov rdx,PROP_PRG
	mov rcx,[.hwnd]
	call apiw.get_dlgitem
	mov [.cp.hPrg],rax

	mov rdx,PROP_LVIEW
	mov rcx,[.hwnd]
	call apiw.get_dlgitem
	mov [.cp.hLview],rax

.ret1:				;message processed
	xor rax,rax
	inc rax
	jmp	.exit

.ret0:
	xor rax,rax
	jmp	.exit

.exit:
	@wepi

