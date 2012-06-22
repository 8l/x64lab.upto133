
  ;#-------------------------------------------------ü
  ;|          x64lab  MPL 2.0 License                |
  ;|   Copyright (c) 2009-2012, Marc Rainer Kranz.   |
  ;|            All rights reserved.                 |
  ;|-------------------------------------------------|
  ;|      Dienstag] - 19.Juni.2012 - 10:51:19        |


console:
	virtual at rbx
		.cons CONS
	end virtual

.proc:
@wpro rbp,\
		rbx rsi rdi

	cmp rdx,WM_INITDIALOG
	jz	.wm_initdialog
	cmp rdx,WM_WINDOWPOSCHANGED
	jz	.wm_poschged
	jmp	.ret0

.wm_poschged:
	mov rbx,[pCons]
	sub rsp,sizeof.RECT*3
	lea rdi,[rsp+sizeof.RECT*2]
	mov rdx,rdi
	mov rcx,[.hwnd]
	call apiw.get_clirect

	mov rdx,rsp
	mov rcx,[.cons.hCbx]
	call apiw.get_winrect

	mov rax,SWP_NOZORDER
	mov r11d,[rsp+RECT.bottom]
	sub r11d,[rsp+RECT.top]
	mov r10d,[rdi+RECT.right]
	sub r10d,[rdi+RECT.left]
	mov r9d,[rdi+RECT.top]
	add r9d,CY_GAP
	mov r8d,[rdi+RECT.left]
	mov rdx,HWND_TOP
	mov rcx,[.cons.hCbx]
	call apiw.set_wpos

	mov eax,SWP_NOZORDER or \
		SWP_NOSENDCHANGING or \
		SWP_NOCOPYBITS

	mov r11d,[rdi+RECT.bottom]
	sub r11d,[rdi+RECT.top]
	sub r11d,CY_GAP*3
	mov ecx,[rsp+RECT.bottom]
	sub ecx,[rsp+RECT.top]
	sub r11d,ecx

	mov r10d,[rdi+RECT.right]
	sub r10d,[rdi+RECT.left]

	mov r9d,[rdi+RECT.top]
	add r9d,[rsp+RECT.bottom]
	sub r9d,[rsp+RECT.top]
	add r9d,CY_GAP*2

	mov r8d,[rdi+RECT.left]
	mov rdx,HWND_TOP
	mov rcx,[.cons.hSci]
	call apiw.set_wpos
	jmp	.ret1


.wm_initdialog:
;@break
	mov rbx,[pCons]
	mov rdi,apiw.get_dlgitem

	mov rdx,CONS_CBX
	mov rcx,[.hwnd]
	call rdi
	mov [.cons.hCbx],rax

	mov rdx,CONS_SCI
	mov rcx,[.hwnd]
	call rdi
	mov [.cons.hSci],rax

;@break
	mov rcx,rax
	call sci.set_defprop

	mov rcx,[.cons.hSci]
	call sci.def_flags

.ret1:				;message processed
	xor rax,rax
	inc rax
	jmp	.exit

.ret0:
	xor rax,rax
	jmp	.exit

.exit:
	@wepi


;.setup:
;	;--- in RCX parent
;	push rbp
;	push rbx

;	mov rbp,rcx
;	call cbex.create_dd
;	mov [pCons.hIn],rax

;;	mov r8,WS_EX_COMPOSITED
;;	mov rcx,rbp
;;	call apiw.set_wlxstyle

;	mov rcx,rbp
;	call statb.create
;	mov [pCons.hStb],rax

;	mov rcx,rbp
;	call sci.create
;	mov rbp,rax
;	mov [pCons.hOut],rax

;	mov rcx,rax
;	call sci.set_defprop
;	mov rcx,rbp
;	call sci.def_flags

;	mov rax,rbp
;	pop rbx
;	pop rbp
;	ret 0


;.resize:
;	;--- in RCX display rect
;	push rbp
;	mov rbp,rcx
;	sub rsp,sizeof.RECT*2

;	mov rdx,rsp
;	mov rcx,[pCons.hIn]
;	call apiw.get_winrect

;	lea rdx,[rsp+16]
;	mov rcx,[pCons.hStb]
;	call apiw.get_winrect

;	mov rax,SWP_NOZORDER
;	mov r11d,[rsp+RECT.bottom]
;	sub r11d,[rsp+RECT.top]
;	mov r10d,[rbp+RECT.right]
;	sub r10d,[rbp+RECT.left]
;	mov r9d,[rbp+RECT.top]
;	add r9d,CY_GAP
;	mov r8d,[rbp+RECT.left]
;	mov rdx,HWND_TOP
;	mov rcx,[pCons.hIn]
;	call apiw.set_wpos

;	mov eax,SWP_NOZORDER or \
;		SWP_NOSENDCHANGING or \
;		SWP_NOCOPYBITS

;	mov r11d,[rbp+RECT.bottom]
;	sub r11d,[rbp+RECT.top]
;	sub r11d,CY_GAP*3
;	mov ecx,[rsp+RECT.bottom]
;	sub ecx,[rsp+RECT.top]
;	sub r11d,ecx

;	mov ecx,[rsp+16+RECT.bottom]
;	sub ecx,[rsp+16+RECT.top]
;	sub r11d,ecx

;	mov r10d,[rbp+RECT.right]
;	sub r10d,[rbp+RECT.left]

;	mov r9d,[rbp+RECT.top]
;	add r9d,[rsp+RECT.bottom]
;	sub r9d,[rsp+RECT.top]
;	add r9d,CY_GAP*2

;	mov r8d,[rbp+RECT.left]
;	mov rdx,HWND_TOP
;	mov rcx,[pCons.hOut]
;	call apiw.set_wpos

;	mov eax,SWP_NOZORDER \
;		or SWP_NOSENDCHANGING \
;		or SWP_NOCOPYBITS \
;		or SWP_NOMOVE
;	xor r11,r11
;	xor r10,r10
;	xor r9,r9
;	xor r8,r8
;	mov rdx,HWND_TOP
;	mov rcx,[pCons.hStb]
;	call apiw.set_wpos

;	add rsp,sizeof.RECT*2
;	pop rbp
;	ret 0

;	mov eax,SWP_NOZORDER or \
;		SWP_NOSENDCHANGING or \
;		SWP_NOCOPYBITS

;	mov r11d,[rbp+RECT.bottom]
;	sub r11d,[rbp+RECT.top]
;	sub r11d,CY_GAP

;	mov r10d,[rbp+RECT.right]
;	sub r10d,[rbp+RECT.left]

;	mov r9d,[rbp+RECT.top]
;	add r9d,CY_GAP
;	mov r8d,[rbp+RECT.left]
;	mov rdx,HWND_TOP
;	mov rcx,[.cons.hOut]
;	call apiw.set_wpos


;	virtual at rbx
;		.cons CONS
;	end virtual

;.dlgproc:
;	@wpro rbp,\
;		rbx rsi rdi

;	cmp rdx,WM_INITDIALOG
;	jz	.wm_initdialog
;;	cmp rdx,WM_CTLCOLORDLG
;;	jz	.wm_ctlcolordlg
;;	cmp rdx,WM_CTLCOLORSTATIC
;;	jz	.wm_ctlcolordlg
;	cmp rdx,WM_SIZE
;	jz	.wm_size
;	jmp	.ret0

;.wm_initdialog:
;	mov rbx,[pCons]
;	mov [.cons.hDlg],rcx

;;	mov r8,[pConfig]
;;	mov ecx,[r8+CFG.cons.bkcol]
;;	call apiw.create_sbrush
;;;	mov [lab.cons.bkcol],eax

;	mov rdx,CONS_TAB
;	mov rcx,[.hwnd]
;	call apiw.get_dlgitem
;	mov [.cons.hTab],rax

;	sub rsp,100h
;	mov r9,7Fh
;	mov r8,rsp
;	mov rdx,UZ_CONS_WIN
;	mov rcx,[hInst]
;	call apiw.loadstr

;	or r10,-1
;	xor r9,r9
;	or r8,r10
;	mov rdx,rsp
;	mov rcx,[.cons.hTab]
;	call tab.add_tab

;	mov rdx,CONS_OUT
;	mov rcx,[.hwnd]
;	call apiw.get_dlgitem
;	mov [.cons.hOut],rax

;	mov rcx,rax
;	call sci.set_defprop

;	mov rcx,[.cons.hOut]
;	call sci.def_flags

;;	mov r9d,0C8CDB9h;0AABBCCh
;;	mov rcx,rax
;;	call rich.set_bkcol

;;	mov r9d,00100010h
;;	mov rcx,[.pCons.hRichOut]
;;	call rich.set_marg

;	mov rdx,CONS_IN
;	mov rcx,[.hwnd]
;	call apiw.get_dlgitem
;	mov [.cons.hIn],rax

;	mov rdx,CONS_INFO
;	mov rcx,[.hwnd]
;	call apiw.get_dlgitem
;	mov [.cons.hInfo],rax

;;	call apiw.get_dlgbu
;;	mov [.pCons.cx_bu],ax

;;	ror eax,16
;;	xor ecx,ecx
;;	mov [.pCons.cy_bu],ax
;;	rol eax,16
;;	and eax,0FFFFh

;;	lea rdx,[.pCons.part0]
;;	
;;;	shr eax,1
;;;	mov [rdx+STATB_DIRPART*4],eax
;;;	mov [rdx+STATB_ENCPART*4],eax
;;;	shr eax,1
;;;	add [rdx+STATB_ENCPART*4],eax
;;;	shr eax,1
;;;	dec ecx
;;;	mov [rdx],eax
;;;	mov [rdx+STATB_EOLPART*4],ecx
;;	
;;;	shl eax,3
;;;	mov [rdx],eax			;--- part 0
;;;	mov [rdx+4],eax		;--- part dir
;;;	mov [rdx+8],eax		;--- part enc
;;;	shl eax,3
;;;	add [rdx+4],eax
;;;	add [rdx+8],eax
;;;	shr eax,3
;;;	add [rdx+8],eax
;;;	dec ecx
;;;	mov [rdx+12],ecx	;--- part dir

;;;	mov r8,STATB_PARTS
;;;	mov r9,rdx
;;;	mov rcx,[.pCons.hStbInfo]
;;;	call statb.set_parts
;;;	jmp	.ret1

;.wm_size:
;;@break
;	mov rbx,[pCons]
;	mov rdi,apiw.set_wpos
;	push r12
;	push r13
;	push r14
;	push r15

;;	mov r10,[.lparam]
;;	mov r11,r10
;;	and r10,0FFFFh
;;	shr r11,16
;	

;	sub rsp,sizeof.RECT*2
;	mov rdx,rsp
;	mov r14,rsp
;	lea r15,[rsp+16]
;	mov rcx,[.cons.hDlg]
;	call apiw.get_clirect



;	mov eax,SWP_NOZORDER or \
;		SWP_NOSENDCHANGING or \
;		SWP_NOCOPYBITS
;	mov r11d,30
;	mov r10d,[r14+RECT.right]
;	xor r9,r9
;	xor r8,r8
;	mov rdx,HWND_TOP
;	mov rcx,[.cons.hTab]
;	call rdi


;;	mov rdx,r14
;;	mov rcx,[.cons.hDlg]
;;	sub rsp,20h
;;	call [MapDialogRect]
;;	add rsp,20h

;	mov r9,r14
;	xor r8,r8
;	mov rcx,[.cons.hTab]
;	call tab.adj_rect

;	mov rdx,r15
;	mov rcx,[.cons.hInfo]
;	call apiw.get_winrect

;	mov eax,[r15+RECT.bottom]
;	sub eax,[r15+RECT.top]
;	mov r12,rax

;	mov rax,SWP_NOZORDER
;	mov r11,rax
;	mov r10d,[r14+RECT.right]
;	sub r10d,[r14+RECT.left]
;	mov r9d,[r14+RECT.top]
;	mov r8d,[r14+RECT.left]
;	mov rdx,HWND_TOP
;	mov rcx,[.cons.hIn]
;	call rdi

;	mov eax,SWP_NOZORDER or \
;		SWP_NOSENDCHANGING or \
;		SWP_NOCOPYBITS
;	mov r11d,[r14+RECT.bottom]
;	sub r11d,[r14+RECT.top]
;	sub r11,CY_GAP
;	sub r11,r12

;	mov r10d,[r14+RECT.right]
;	sub r10d,[r14+RECT.left]
;	mov r9d,[r14+RECT.top]
;	add r9,CY_GAP
;	add r9,r12
;	mov r8d,[r14+RECT.left]
;	mov rdx,HWND_TOP
;	mov rcx,[.cons.hOut]
;	call rdi

;;	mov eax,SWP_NOZORDER \
;;		or SWP_NOSENDCHANGING \
;;		or SWP_NOCOPYBITS \
;;		or SWP_NOMOVE
;;	xor r11,r11
;;	xor r10,r10
;;	xor r9,r9
;;	xor r8,r8
;;	mov rdx,HWND_TOP
;;	mov rcx,[.cons.hInfo]
;;	call rdi

;;	lea rdx,[.cons.part0]
;;	mov rax,[.lparam]
;;	and eax,0FFFFh
;;	xor ecx,ecx
;;	shr eax,3
;;	dec ecx
;;	mov [rdx],eax
;;	mov [rdx+4],eax		
;;	add [rdx+4],eax		
;;	mov [rdx+8],eax		
;;	mov [rdx+12],ecx
;;	shl eax,1
;;	add [rdx+8],eax
;;	add [rdx+8],eax
;;	add [rdx+8],eax

;;	mov r9,rdx
;;	mov r8,STATB_PARTS
;;	mov rcx,[.cons.hInfo]
;;	call statb.set_parts

;;	mov eax,SWP_NOZORDER \
;;		or SWP_NOSENDCHANGING \
;;		or SWP_NOCOPYBITS \
;;		or SWP_NOMOVE
;;	xor r11,r11
;;	xor r10,r10
;;	xor r9,r9
;;	xor r8,r8
;;	mov rdx,HWND_TOP
;;	mov rcx,[.cons.hInfo]
;;	call rdi

;	pop r15
;	pop r14
;	pop r13
;	pop r12
;	jmp	.ret1

;;.wm_ctlcolordlg:
;;;	xor eax,eax
;;;	jmp .exit
;;	mov eax,[lab.cons.bkcol.param]
;;	jmp	.exit

;;.wm_erasebkgnd:
;;;	jmp	.exit
;;;	jmp	.ret1			;--- draw the bck as in the dll
;;	jmp	.ret0			;--- draw the actual own bck

;.ret1:				;message processed
;	xor rax,rax
;	inc rax
;	jmp	.exit

;.ret0:
;	xor rax,rax
;	jmp	.exit

;.exit:
;	@wepi




