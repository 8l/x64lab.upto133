  
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

prop:
	virtual at rbx
		.cp CPROP
	end virtual

	virtual at rbx
		.conf CONFIG
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

	mov rsi,rax
	sub rsp,\
		FILE_BUFLEN
	mov rdi,rsp

	push 0
	push BB_SYS
	push BB_RET
	push BB_REG
	push BB_PROCESS
	push BB_PROC
	push BB_MACRO
	push BB_LABEL
	push BB_IMPORT
	push BB_IMM
	push BB_FLOW
	push BB_EXPORT
	push BB_DATA
	push BB_COMMENT
	push BB_CALL
	push BB_CODE
	push BB_AKEY
	push BB_FOLDER
	push BB_WSP
	mov ecx,BB_NULL

.wm_initdialogA:
	mov r8,rdi
	mov edx,U16
	call [lang.get_uz]
	
	;--- in RCX hCb
	;--- in RDX string
	;--- in R8 imgindex
	;--- in R9 param
	;--- in R10 indent r10b,index overlay rest R10)
	;--- in R11 selimage

	xor r11,r11
	xor r10,r10
	xor r9,r9
	xor r8,r8
	mov rdx,rdi
	mov rcx,rsi
	call cbex.ins_item

	pop rcx
	test rcx,rcx
	jnz .wm_initdialogA	

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

	mov rsi,rax
	mov rbx,[pConf]

	mov r9d,[.conf.prop.bkcol]
	mov rcx,rsi
	call lvw.set_bkcol

	mov r9d,[.conf.prop.bkcol]
	mov rcx,rsi
	call lvw.set_txtbkcol



.ret1:				;message processed
	xor rax,rax
	inc rax
	jmp	.exit

.ret0:
	xor rax,rax
	jmp	.exit

.exit:
	@wepi

