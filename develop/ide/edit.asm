
  ;#-------------------------------------------------ü
  ;|          x64lab  MPL 2.0 License                |
  ;|   Copyright (c) 2009-2012, Marc Rainer Kranz.   |
  ;|            All rights reserved.                 |
  ;|-------------------------------------------------|
  ;|      Dienstag] - 19.Juni.2012 - 10:51:19        |
	;| edit.asm                                        |
	;ä-------------------------------------------------ö

edit:
	virtual at rbx
		.labf LABFILE
	end virtual

	virtual at rsi
		.pEdit EDIT
	end virtual

	;#---------------------------------------------------ö
	;|             EDIT.open                             |
	;ö---------------------------------------------------ü

.open:
	;--- in RCX labf
	;--- RET EAX = 0 error,labf
	push rbp
	push rbx
	push rdi
	push rsi
	push r12
	push r13

	mov rbp,rsp
	and rsp,-16
	xor r12,r12
	xor r13,r13

	sub rsp,\
		FILE_BUFLEN

	xor eax,eax
	test rcx,rcx
	jz	.openE

	mov rdi,rsp
	mov rbx,rcx

	;--- 1) check file existence
	xor eax,eax
	mov r8,[.labf.dir]
	lea rdx,[rbx+\
		sizeof.LABFILE]

	lea rcx,[r8+DIR.dir]
	test [r8+DIR.type],\
		DIR_HASREF
	jz .openA
	mov r8,[r8+DIR.rdir]
	lea rcx,[r8+DIR.dir]

.openA:	
	push rax
	push rdx
	push uzSlash
	push rcx
	push rdi
	push rax
	call art.catstrw	

	mov rcx,rdi
	call art.is_file
	jz .openE
	
	;--- 2) TODO: check type
	test [.labf.type],\
		LF_TXT

	;----TODO: review ---------------
	or [.labf.type],\
		LF_TXT
	;----------------------- 
;@break
	mov rsi,[pEdit]
	mov rcx,rdi
	call art.fload

	mov r13,rcx
	mov r12,rax

	test rax,rax
	jnz	.openB

	xor r12,r12
	xor r13,r13
	cmp edx,-3	;--- zero size
	jnz .openE

.openB:
	;--- in RCX labfile
	mov rcx,[.pEdit.hwnd]
	call sci.create
	mov [.labf.hSci],rax

	mov rcx,[.labf.hSci]
	call sci.set_defprop

	;--- eventual unicode conversion
	;--- RET RAX pmem,0,-err
	;--- RET RCX original file size
	;--- RET RDX pextension / flag error
	test r12,r12
	jz	.openB1

	mov r9,r12
	mov r8,r13
	mov rcx,[.labf.hSci]
	call sci.add_txt

	mov rcx,r12
	call art.vfree

.openB1:
	mov rcx,[.labf.hSci]
	call sci.def_flags
	mov r12,rbx

	or [.labf.type],\
		LF_OPENED

.openE:
	xchg rax,r12
	mov rsp,rbp
	pop r13
	pop r12
	pop rsi
	pop rdi
	pop rbx
	pop rbp
	ret 0


;.openA:
;	mov r9,[.labf.pDir]
;	add r9,sizeof.DIR
;	call cons.set_dir

;	;--- update EDITOR -----------
;	mov r9,[.labf.pDir]
;	add r9,sizeof.DIR
;	mov rcx,[.pEdit.hStaDir]
;	call win.set_text

;	;--- in RCX hCb
;	;--- in RDX string
;	;--- in R8 imgindex
;	;--- in R9 param
;	;--- in R10 (indent r10b,index overlay rest R10)
;	;--- in R11 selimage


	;#---------------------------------------------------ö
	;|             EDIT.save                             |
	;ö---------------------------------------------------ü

;.save:
;	;--- in RCX labf
;	;--- in RDX path+fname
;	;--- in R8 how

;	;--- RET EAX = -1 errror
;	;--- RET EAX = 0 cannot close/abort operation
;	;--- RET EAX = 1 no need to save/saved ok
;	;-----------------------------------------
;	xor eax,eax
;	test r8,ASK_SAVE
;	jnz	.saveA
;	inc eax
;	ret 0

;.saveA:
;	push rbx
;	push rsi
;	test rcx,rcx
;	jz .err_save
;	mov rbx,rcx
;	test rdx,rdx
;	jz .err_save
;;@break
;	

;.err_save:
;	or eax,-1
;	
;.saveE:
;	pop rsi
;	pop rbx
;	ret 0



	;#---------------------------------------------------ö
	;|             EDIT.close                            |
	;ö---------------------------------------------------ü

.close:
	;--- in RCX labf
	push rbx
	push rsi

	mov rsi,[pEdit]
	mov rbx,rcx
	mov rdx,\
		[.pEdit.blanks]
	movzx eax,\
		[.labf.type]
	test eax,\
		LF_BLANK
	jz	.closeV

.closeB:
	;--- close a BLANK
	movzx rcx,\
		[.labf.iBlank]
	btr rdx,rcx
	mov [.pEdit.blanks],rdx

.closeV:
	;--- 1) destroy view
	mov rcx,\
		[.labf.hView]
	xor eax,eax
	mov [.labf.hView],rax
	call apiw.destroy

	and [.labf.type],\
		not LF_OPENED

.closeE:
	pop rsi
	pop rbx
	ret 0

	;#---------------------------------------------------ö
	;|             EDIT.new                              |
	;ö---------------------------------------------------ü

.new:
	;--- in RCX 0,labf info
	;--- in RDX type
	;--- RET RAX 0/labf
	xor eax,eax
	test edx,\
		LF_FILE or\
		LF_BLANK
	jnz	.new_btxt
	ret 0

.new_btxt:
	push rbp
	push rbx
	push rdi
	push rsi
	push r12
	mov rbp,rsp

	xor ebx,ebx
	mov rsi,[pEdit]
	xor r12,r12
	xor edi,edi
	test rcx,rcx
	cmovnz rbx,rcx

	xor rax,rax
	mov rcx,[.pEdit.blanks]
	not rcx
	bsf rax,rcx
	mov r12,rax
	jnz	.new_btxtA

	;---TODO: ask to close or save same blanks
	jmp	.new_btxtE

.new_btxtA:
	sub rsp,\
		FILE_BUFLEN

	test ebx,ebx
	mov r9,[projDir]
	jz	.new_btxtB
	mov r9,[.labf.dir]

.new_btxtB:
	mov r8,LF_BLANK\
		or LF_FILE
	xor edx,edx
	lea rcx,[r9+\
		DIR.dir]
	call wspace.new_labf
	test rax,rax
	jz	.new_btxtE
	mov rdi,rax

	or [rax+\
		LABFILE.type],\
		LF_TXT or \
		LF_BLANK or \
		LF_FILE
	
	bts [.pEdit.blanks],r12
	mov [rax+\
		LABFILE.iBlank],r12l

	movzx eax,r12l
	call art.b2a
	lea rdx,[rdi+\
		sizeof.LABFILE]
	mov [rdx],al
	mov [rdx+2],ah

	mov rcx,[.pEdit.hwnd]
	call sci.create
	mov [rdi+\
		LABFILE.hSci],rax

	mov rcx,rax
	call sci.set_defprop

	mov rcx,[rdi+\
		LABFILE.hSci]
	call sci.def_flags

.new_btxtE:
	mov rax,rdi
	mov rsp,rbp
	pop r12
	pop rsi
	pop rdi
	pop rbx
	pop rbp
	ret 0
	
;	push rbp
;	push rbx
;	push rdi
;	push rsi
;	push r12
;	mov rbp,rsp

;	xor eax,eax
;	and rsp,-16
;	sub rsp,\
;		FILE_BUFLEN

;	mov rsi,[pEdit]
;	mov rbx,rcx
;	mov rdi,rdx
;	xor r12,r12

;	test r8w,LF_TXT
;	jz	.newA
;	test r8w,LF_BLANK
;	jz	.newT

;	mov rcx,[.pEdit.blanks]
;	not rcx
;	xor rax,rax
;	bsf rax,rcx
;	mov r12,rax
;	jnz	.newT
;	;--- ask to close or save
;	jmp	.newE
;	
;.newT:
;	mov rdx,rdi
;	mov rcx,rbx
;	call wspace.new_labf
;	test rax,rax
;	jz	.newE
;	mov rbx,rax
;	or [.labf.type],\
;		LF_TXT

;	test rdi,rdi
;	jnz	.newT1
;	
;	;--- file is new blank autoname
;	sub rsp,30h
;	mov rdx,rsp
;	mov rcx,r12
;	call art.qword2a

;	pxor xmm1,xmm1
;	movdqa xmm0,dqword[rsp]
;	punpckhbw xmm0,xmm1
;	movdqa [rsp],xmm0

;	mov rax,[rsp+8]
;	lea rcx,[rbx+\
;		sizeof.LABFILE]
;	mov [rcx],rax

;	add rsp,30h
;	or [.labf.type],\
;		LF_BLANK
;	bts [.pEdit.blanks],r12
;	mov [.labf.iBlank],r12l
;	
;.newT1:
;	mov rcx,[.pEdit.hwnd]
;	call sci.create
;	mov [.labf.hSci],rax

;	mov rcx,rax
;	call sci.set_defprop

;	mov rcx,[.labf.hSci]
;	call sci.def_flags
;	
;.newA:
;	mov rax,rbx

;.newE:
;	mov rsp,rbp
;	pop r12
;	pop rsi
;	pop rdi
;	pop rbx
;	pop rbp
;	ret 0

	;#---------------------------------------------------ö
	;|             EDIT.view                             |
	;ö---------------------------------------------------ü

.view:
	;--- in RCX 0, labf to set in view
	;--- RCX = 0 default view
	;--- RET RAX labf
	push rbx
	push rsi

	mov rbx,rcx
	mov rsi,[pEdit]
	
	test rcx,rcx
	cmovz rbx,\
		[.pEdit.deflabf]

	mov rax,[.pEdit.curlabf]
	cmp rax,rbx
	jz	@f

	mov edx,SW_HIDE
	mov rcx,\
		[rax+LABFILE.hView]
	call apiw.show

@@:
	lea r9,[rbx+\
		sizeof.LABFILE]
	mov rax,[.pEdit.pPanel]
	xor r8,r8
	mov rdx,WM_SETTEXT
	mov rcx,[rax+PNL.hwnd]
	call apiw.sms

	mov [.pEdit.curlabf],rbx

	xor r9,r9
	xor r8,r8
	mov rdx,WM_SIZE
	mov rcx,[.pEdit.hwnd]
	call apiw.sms

	mov edx,SW_RESTORE
	mov rcx,[.labf.hView]
	call apiw.show

	mov rax,[.labf.dir]
	xor r8,r8
	lea r9,[rax+DIR.dir]
	mov rcx,[.pEdit.hStb]
	call statb.set_text	

	mov r9,RDW_INVALIDATE	\
		or RDW_NOINTERNALPAINT
	xor r8,r8
	mov rax,[.pEdit.pPanel]
	xor edx,edx
	mov rcx,[rax+PNL.hwnd]
	call apiw.redraw_win

	mov rax,rbx
	pop rsi
	pop rbx
	ret 0


;.set_dir:
;	;--- in R9 text
;;	xor eax,eax
;;	test r9,r9
;;	jnz .set_dirA
;;	ret 0

;;.set_dirA:
;;	push rbx
;;	mov rcx,r9
;;	mov rbx,r9
;;	call art.is_file
;;	jnz	.set_dirB
;;;	mov rcx,rbx
;;;	call win.get_res
;;;	mov rbx,rdx

;;.set_dirB:
;;	xor r8,r8
;;	mov r9,rbx
;;	mov rcx,[pCons.hStb]
;;	call statb.set_text
;;	pop rbx
;	ret 0


	;#---------------------------------------------------ö
	;|             EDIT.proc                             |
	;ö---------------------------------------------------ü

.proc:
@wpro rbp,\
		rbx rsi rdi

	cmp edx,WM_INITDIALOG
	jz	.wm_initdialog
	cmp edx,WM_SIZE
	jz	.wm_size
	cmp edx,WM_NOTIFY
	jz	.wm_notify
	jmp	.ret0

.wm_notify:
	xor edx,edx
	mov rsi,[pEdit]
	mov rbx,[.pEdit.curlabf]
	cmp	rdx,[.pEdit.deflabf]
	jz	.ret0
	cmp	rbx,rdx
	jz	.ret0
	test rbx,rbx
	jz	.ret0

	mov rax,[r9+\
		NMHDR.hwndFrom]
	cmp rax,[.labf.hView]
	jnz	.ret0
	test [.labf.type],\
		LF_TXT
	jz	.ret0

.wm_notifyT:
	;--- view is text ---------
	mov edx,[r9+\
		NMHDR.code]

	cmp edx,\
		SCN_SAVEPOINTREACHED
	jnz	.wm_notifyT1
	and [.labf.type],\
		not LF_MODIF
	jmp	.ret1

.wm_notifyT1:
	cmp edx,\
		SCN_SAVEPOINTLEFT
	jnz	.ret0
	or [.labf.type],\
		LF_MODIF
	jmp	.ret1

	
;	mov edx,[r9+NMHDR.code]
;	cmp edx,NM_CLICK
;	jnz	.ret0
;	mov rax,[.pEdit.hTab]
;	cmp rax,[r9+NMHDR.hwndFrom]
;	jnz	.ret0
;	mov rcx,rax
;	call tab.get_cursel
;	test eax,eax
;	jnz	.ret0

;	cmp [.pEdit.docs],ax
;	jnz	.wm_notifyA

;	;--- 1) enable scintilla
;	mov rdx,TRUE
;	mov rcx,[.pEdit.hSci]
;	call apiw.en_win

;	;--- 2) enable cbx
;	mov rdx,TRUE
;	mov rcx,[.pEdit.hCbx]
;	call apiw.en_win

;	mov r8,\
;		UZ_EDIT_VIEW_BLANKS -\
;		UZ_EDIT_VIEW_ALL
;	mov rcx,[.pEdit.hCbx]
;	call cbex.sel_item
;	
;	;--- set view
;	mov rcx,[.pEdit.hSci]
;	call .set_view

;.wm_notifyA:
;	inc [.pEdit.docs]
;	jmp	.ret1

	;#---------------------------------------------------ö
	;|             EDIT.size                             |
	;ö---------------------------------------------------ü

.wm_size:
;@break
	mov rsi,[pEdit]
	sub rsp,\
		sizeof.RECT*2
	;--- rsp clirect
	;--- rsp+16 status
	;--- rsp+32 tab
	;--- rsp+48 xcb
	mov rdi,rsp
	.cli_rc equ rdi
	.stb_rc equ rdi+16

	mov rdx,rsp
	mov rcx,[.hwnd]
	call apiw.get_clirect

	lea rdx,[.stb_rc]
	mov rcx,[.pEdit.hStb]
	call apiw.get_winrect

	;--- view handle
	mov eax,SWP_NOZORDER
	mov r11d,[.cli_rc+\
		RECT.bottom]
	mov ecx,[.stb_rc+\
		RECT.bottom]
	sub ecx,[.stb_rc+\
		RECT.top]
	sub r11d,ecx
	mov r10d,[.cli_rc+\
		RECT.right]

	xor r9,r9
	xor r8,r8
	mov rdx,[.pEdit.curlabf]
	mov rcx,[rdx+\
		LABFILE.hView]
	mov rdx,HWND_TOP
	call apiw.set_wpos

	;--- status bar
	mov eax,SWP_NOZORDER \
		or SWP_NOSENDCHANGING \
		or SWP_NOCOPYBITS \
		or SWP_NOMOVE
	mov rdx,HWND_TOP
	mov rcx,[.pEdit.hStb]
	call apiw.set_wpos
	jmp	.ret0

	;#---------------------------------------------------ö
	;|             EDIT.initdialog                       |
	;ö---------------------------------------------------ü

.wm_initdialog:
	mov rsi,[pEdit]
	mov [.pEdit.hwnd],rcx
	mov rbx,rcx
	mov rdi,apiw.get_dlgitem
	
;	mov r8,uzCourierN
;	mov r9,FIXED_PITCH
;	xor edx,edx
;	mov ecx,0A10h
;	call apiw.cfonti
;	mov [.pEdit.hFont],rax

;	mov r9,TRUE
;	mov r8,rax
;	mov rdx,WM_SETFONT
;	mov rcx,rbx
;	call apiw.sms

	xor r8,r8
	call wspace.new_labf
	mov rbx,rax

	mov [.pEdit.curlabf],rax
	mov [.pEdit.deflabf],rax

	mov rdx,EDIT_STC
	mov rcx,[.pEdit.hwnd]
	call rdi
	mov [.labf.hView],rax

	mov rdx,EDIT_STB
	mov rcx,[.pEdit.hwnd]
	call rdi
	mov [.pEdit.hStb],rax

;	mov rcx,[.pEdit.hwnd]
;	call apiw.get_dc
;	mov rdi,rax

;	mov rdx,[.pEdit.hFont]
;	mov rcx,rax
;	call apiw.selobj
;	mov rbx,rax

;	sub rsp,\
;		sizea16.TEXTMETRIC
;	mov rdx,rsp
;	mov rcx,rdi
;	call apiw.get_txtmetr

;	mov eax,[rsp+\
;		TEXTMETRIC.tmHeight]
;	mov [.pEdit.cy_font],ax

;	mov eax,[rsp+\
;		TEXTMETRIC.tmMaxCharWidth]
;	mov [.pEdit.cx_font],ax

;	mov rdx,[.pEdit.hwnd]
;	mov rcx,rdi
;	call apiw.selobj

;	mov rdx,rdi
;	mov rcx,[.pEdit.hwnd]
;	call apiw.rel_dc

;	mov rcx,rdi
;	call sci.get_docp
;	mov [.labf.doc],rax

	

.ret1:				;message processed
	xor rax,rax
	inc rax
	jmp	.exit

.ret0:
	xor rax,rax
	jmp	.exit

.exit:
	@wepi


;	mov rdx,EDIT_CBX
;	mov rcx,rbx
;	call rdi
;	mov [pEdit.hCbx],rax

;	mov r9,TRUE
;	mov r8,[pEdit.hFont]
;	mov rdx,WM_SETFONT
;	mov rcx,rax
;	call apiw.sms

;	mov rdx,EDIT_SCI
;	mov rcx,rbx
;	call rdi
;	mov [pEdit.hSci],rax


;	mov rdx,EDIT_BTN
;	mov rcx,rbx
;	call rdi
;	mov [pEdit.hBtn],rax

;	mov r9,TRUE
;	mov r8,[pEdit.hFont]
;	mov rdx,WM_SETFONT
;	mov rcx,rax
;	call apiw.sms

;	mov rdx,EDIT_TAB
;	mov rcx,rbx
;	call rdi
;	mov [pEdit.hTab],rax

;	mov r9,TRUE
;	mov r8,[pEdit.hFont]
;	mov rdx,WM_SETFONT
;	mov rcx,rax
;	call apiw.sms

;	sub rsp,FILE_BUFLEN
;	mov r9,100h
;	lea r8,[rsp+8]
;	mov rdx,UZ_SAMUZ
;	mov rcx,[hInst]
;	call apiw.loadstr	

;	mov r9,rsp
;	mov r8,16
;	mov rdx,rsp
;	mov rcx,rdi
;	call apiw.get_tep32

;	;--------------------------------
;	sub rsp,\
;		FILE_BUFLEN
;	mov r9,100h
;	mov r8,rsp
;	mov rdx,UZ_EDIT_VIEW_ALL
;	mov rcx,[hInst]
;	call apiw.loadstr

;	mov r11,0
;	mov r10,0
;	mov r9,0
;	mov r8,0
;	mov rdx,rsp
;	mov rcx,[pEdit.hCbx]
;	call cbex.ins_item

;	;--------------------------------
;	mov r9,100h
;	mov r8,rsp
;	mov rdx,UZ_EDIT_VIEW_UNB
;	mov rcx,[hInst]
;	call apiw.loadstr

;	mov r11,0
;	mov r10,0
;	mov r9,0
;	mov r8,0
;	mov rdx,rsp
;	mov rcx,[pEdit.hCbx]
;	call cbex.ins_item

;	;--------------------------------
;	mov r9,100h
;	mov r8,rsp
;	mov rdx,UZ_EDIT_VIEW_BLANKS
;	mov rcx,[hInst]
;	call apiw.loadstr

;	mov r11,0
;	mov r10,0
;	mov r9,0
;	mov r8,0
;	mov rdx,rsp
;	mov rcx,[pEdit.hCbx]
;	call cbex.ins_item

;	;--- in RCX hTab
;	;--- in RDX string
;	;--- in R8 imgindex -1,index
;	;--- in R9 param
;	;--- in R10 index		-1,index
;	or r10,-1
;	xor r9,r9
;	xor r8,r8
;	mov rdx,uzPlus;rsp
;	mov rcx,[pEdit.hTab]
;	call tab.add_tab

;	mov rax,[.cli_rc]
;	mov [.tab_rc],rax
;	mov rax,[.cli_rc+8]
;	mov [.tab_rc+8],rax

;	movzx r11d,\
;		[.pEdit.cy_font]

;	;--- cbx bar
;	mov eax,SWP_NOZORDER
;	movzx r10,\
;		[.pEdit.cx_font]
;	shl r10,4
;	mov [.tab_rc+RECT.left],r10d

;	mov r9,0
;	mov r8,0
;	mov rdx,HWND_TOP
;	mov rcx,[.pEdit.hCbx]
;	call apiw.set_wpos

;	lea rdx,[.adj_rc]
;	mov rcx,[.pEdit.hCbx]
;	call apiw.get_winrect

;	;--- button 3x3 ----------
;	mov eax,SWP_NOZORDER
;	
;	mov r11d,[.adj_rc+RECT.bottom]
;	sub r11d,[.adj_rc+RECT.top]
;	;mov r13,r11

;	movzx r10,\
;		[.pEdit.cx_font]
;	add r10d,r10d
;	mov rdi,r10

;	mov r9d,0
;	mov r8d,[.tab_rc+RECT.left]
;	add r8d,2
;	mov rdx,HWND_TOP
;	mov rcx,[.pEdit.hBtn]
;	call apiw.set_wpos

;	add [.tab_rc+RECT.left],edi

	;---- tab -----------------------
;	lea r9,[.tab_rc]
;	mov r8,FALSE
;	mov rcx,[.pEdit.hTab]
;	call tab.adj_rect

;	mov eax,SWP_NOZORDER
;	mov r11d,[rsi+RECT.bottom]
;	sub r11d,[rsi+RECT.top]

;	mov edx,[rsi+32+RECT.bottom]
;	sub edx,[rsp+32+RECT.top]
;	sub r11d,edx
;	;sub r11d,6
;	ror rdi,32
;	or rdi,r11
;	ror rdi,32

;	mov r10d,[.tab_rc+RECT.right]
;	sub r10d,[.tab_rc+RECT.left]

;	mov r9d,0
;	mov r8d,[.tab_rc+RECT.left]

;	mov rdx,HWND_BOTTOM
;	mov rcx,[.pEdit.hTab]
;	call apiw.set_wpos

;	
;.proc:
;	push rbp
;	push rbx
;	push rdi
;	push rsi
;	push r12
;	push r13
;	push r14
;	push r15
;	mov rbp,rsp
;	and rsp,-16

;	mov r12,rcx
;	mov r13,rdx
;	mov r14,r8
;	mov r15,r9

;	cmp r13,WM_INITDIALOG
;	jz	.wm_initdialog
;	cmp r13,WM_SIZE
;	jz	.wm_size
;	cmp r13,WM_COMMAND
;	jz	.wm_command
;;	cmp r13,WM_CTLCOLORSTATIC
;;	jz	.wm_ctlcolorstatic
;	jmp	.ret0

;;.wm_ctlcolorstatic:
;;	mov rbx,[gpt.pEdit]
;;	mov rax,[.pEdit.hStaBack]
;;	cmp rax,r15
;;	jnz	.ret0
;;;@break
;;	sub rsp,sizeof.RECT
;;	mov rdx,rsp
;;	mov rcx,r15
;;	call apiw.get_clirect

;;	mov rdx,gpt.phGraph
;;	mov rcx,r14
;;	mov rdi,rdx
;;	call [gdip.hdc2graph]

;;	mov r11d,[rsp+RECT.bottom]
;;	mov r10d,[rsp+RECT.right]
;;	xor r9,r9
;;	xor r8,r8
;;	mov rdx,[gpt.phBitmap]
;;	mov rcx,[rdi]
;;	call [gdip.drawimgri]

;;	mov rcx,[rdi]
;;	call [gdip.delgraph]
;;	jmp	.exit

;.wm_command:
;	mov rbx,[gpt.pEdit]
;	cmp [.pEdit.hCbxFile],r15
;	jz	.cbex_command
;;	mov ecx,[r9+NMHDR.code]
;;	cmp ecx,TCN_SELCHANGE
;;	jz	.tab_schange
;	jmp	.ret0

;.cbex_command:
;	mov rax,r14
;	shr eax,16
;	cmp eax,CBN_SELCHANGE
;	jz	.cbex_change
;	jmp	.ret0

;.cbex_change:
;;	mov rcx,r15
;;	call cbex.get_cursel
;;	mov r8,[gpt.buf512]
;;	mov rdx,rax
;;	mov rcx,r15
;;	call cbex.get_item
;;	call tree.schged
;	jmp	.ret0

;.wm_initdialog:
;	mov rbx,[gpt.pEdit]
;	mov [.pEdit.hDlg],rcx
;	mov [.pEdit.cx_bu],6
;	mov [.pEdit.cy_bu],16

;	@rsp 16,sizeof.LOGFONTW
;	mov rcx,rsp
;	mov [rcx+LOGFONTW.lfHeight],16
;	mov [rcx+LOGFONTW.lfWidth],6
;	mov [rcx+LOGFONTW.lfWeight],FW_NORMAL
;	mov [rcx+LOGFONTW.lfCharSet],DEFAULT_CHARSET
;	mov [rcx+LOGFONTW.lfPitchAndFamily],VARIABLE_PITCH
;	lea rdi,[rcx+LOGFONTW.lfFaceName]
;	mov rsi,uzCourierNew
;	mov ecx,uzCourierNew.size
;	rep movsb
;	mov rcx,rsp
;	sub rsp,20h
;	call [CreateFontIndirectW]
;	mov [.pEdit.hFont],rax

;	mov r9,1
;	mov r8,rax
;	mov rdx,WM_SETFONT
;	mov rcx,[.pEdit.hDlg]
;	call apiw.sms
;;	mov r8,[.pEdit.hFont]
;;	mov r9,TRUE
;;	mov rdx,WM_SETFONT
;	
;;	mov rdx,ID_EDIT_INFO
;;	mov rcx,[.hwnd]
;;	call art.get_dlgitem
;;	mov [.pEdit.hStbInfo],rax

;	mov rdx,EDIT_FILE
;	mov rcx,r12
;	call apiw.get_dlgitem
;	mov [.pEdit.hCbxFile],rax

;	mov r9,1
;	mov r8,[.pEdit.hFont]
;	mov rdx,WM_SETFONT
;	mov rcx,rax
;	call apiw.sms

;;	mov rcx,rax
;;	call cbex.get_cb
;;	mov [.pEdit.hCbCb],rax

;	mov r9,[gpt.hsmSysList]
;	mov rcx,[.pEdit.hCbxFile]
;	call cbex.set_iml

;	mov rdx,EDIT_DIR
;	mov rcx,r12
;	call apiw.get_dlgitem
;	mov [.pEdit.hStaDir],rax

;	mov r9,1
;	mov r8,[.pEdit.hFont]
;	mov rdx,WM_SETFONT
;	mov rcx,rax
;	call apiw.sms

;	mov rdx,EDIT_BACK
;	mov rcx,r12
;	call apiw.get_dlgitem
;	mov [.pEdit.hStaBack],rax


;;	sub rsp,FILE_BUFLEN
;;	mov rdx,[gpt.confDir]
;;	mov rcx,rsp
;;	add rdx,sizeof.DIR
;;	push 0
;;	push uzPngExt
;;	push uzClass
;;	push uzSlash
;;	push rdx
;;	push rcx
;;	push 0
;;	call art.catstrw 
;;	mov rdx,gpt.phBitmap
;;	mov rcx,rsp
;;	call [gdip.file2bmp]
;;	add rsp,FILE_BUFLEN



;;	mov rcx,r12
;;	call sci.create
;;	mov [gpt.hSci],rax
;	
;;	mov r9,rdi
;;	mov rcx,[.pEdit.hStDir]
;;	call win.set_text

;;	mov rcx,[.hwnd]
;;	call art.get_dlgbu
;;	mov [.pEdit.cx_bu],ax
;;	shr eax,16
;;	mov [.pEdit.cy_bu],ax

;;@break
;;	sub rsp,20h
;;	mov rcx,0x00bac7cc;0x00f4e5cc
;;	call [CreateSolidBrush]
;;	add rsp,20h
;;	mov [hTestA],rax

;	jmp	.ret1

;;.wm_windowsposchanged:
;;.wm_windowposchanging:
;	
;.wm_size:
;;@break
;	mov rbx,[gpt.pEdit]
;	sub rsp,sizeof.RECT
;	mov rdx,rsp
;	mov rcx,[.pEdit.hCbxFile]
;	call apiw.get_winrect
;	mov r12d,[rsp+RECT.bottom]
;	sub r12d,[rsp+RECT.top]

;;	mov r8,[.pEdit.hCbxFile]
;;	mov rcx,[.pEdit.hCbxFile]
;;	call cbex.get_itemh
;;	
;;	mov r8,rax
;;	mov edx,[rsp+RECT.bottom]
;;	sub edx,[rsp+RECT.top]
;;	mov rcx,uzFrmLL
;;	call config.print2
;	
;	mov rax,r15
;	mov r13,rax
;	and eax,0FFFFh
;	mov r10,rax
;	shr eax,2
;	
;	sub r10,rax
;	mov rdi,rax
;	mov rsi,r10
;	mov r11,r12
;	sub r10,CX_GAP*2

;;@break
;	mov eax,SWP_NOZORDER or \
;		SWP_NOSENDCHANGING or \
;		SWP_NOCOPYBITS
;	mov r9,CY_GAP
;	mov r8,CX_GAP
;	mov rdx,HWND_TOP
;	mov rcx,[.pEdit.hStaDir]
;	call apiw.set_wpos

;	mov eax,SWP_NOZORDER
;	mov r11,r12
;	mov r10,rdi
;	sub r10,CX_GAP
;	mov r9,CY_GAP
;	mov r8,rsi
;	mov rdx,HWND_TOP
;	mov rcx,[.pEdit.hCbxFile]
;	call apiw.set_wpos

;;	mov eax,SWP_NOZORDER or \
;;		SWP_NOSENDCHANGING or \
;;		SWP_NOCOPYBITS

;;	mov r11,r13
;;	shr r11,16
;;	sub r11,CY_GAP*3
;;	sub r11,r12
;;	mov r10,r13
;;	and r10,0FFFFh
;;	sub r10,CX_GAP*2
;;	mov r9,r12
;;	add r9,CY_GAP*2
;;	mov r8,CX_GAP
;;	mov rdx,HWND_TOP
;;	
;;	mov rcx,[gpt.hSci]
;;	test rcx,rcx
;;	jnz .wm_sizeA
;;	mov rcx,[.pEdit.hStaBack]

;;.wm_sizeA:
;;	call apiw.set_wpos
;	jmp	.ret0

;.ret1:				;message processed
;	xor rax,rax
;	inc rax
;	jmp	.exit

;.ret0:
;	xor rax,rax

;.exit:
;	mov rsp,rbp
;	pop r15
;	pop r14
;	pop r13
;	pop r12
;	pop rsi
;	pop rdi
;	pop rbx
;	pop rbp
;	ret 0


;.close:
;	;--- in RCX labfile
;	;--- in RDX filename
;	push rbx
;	push rdi
;	push rsi
;	mov rbx,[gpt.pEdit]
;	mov rsi,rcx

;;@break
;	mov rcx,[.pEdit.hCbxFile]
;	call cbex.get_cursel
;	mov rdi,rax

;	mov r9,[.labf.pDoc]
;	mov rcx,[gpt.hSci]
;	call sci.rel_doc
;	xor eax,eax
;	mov [.labf.pDoc],rax
;	
;	mov r8,rdi
;	mov rcx,[.pEdit.hCbxFile]
;	call cbex.del_item
;	xor r9,r9
;	test rax,rax
;	jle .closeB
;;	dec rax
;;	mov r8,[gpt.buf512]
;;	mov rdx,rax
;;	mov rcx,[.pEdit.hCbxFile]
;;	call cbex.get_item
;;	call tree.schged
;	jmp	.closeC

;;	mov rcx,[.pEdit.hCbxFile]
;;	call cbex.get_count
;;	cmp eax,edi
;;	ja .closeA
;;	xchg eax,edi

;;.closeA:	
;;	mov rcx,[.pEdit.hCbxFile]
;;	call cbex.get_count
;;	dec eax
;;	jl	.closeB
;;	
;.closeB:
;	mov rcx,[gpt.hSci]
;	call sci.set_docp
;	mov r8,TRUE
;	xor rdx,rdx
;	mov rcx,[.pEdit.hCbxFile]
;	call apiw.invrect

;.closeC:
;	pop rsi
;	pop rdi
;	pop rbx
;	ret 0




;.new_unbound:
;	push rdi
;	push rsi
;	;--- RET RAX labfile

;	mov rdx,UZ_EDIT_UNTL
;	call win.get_res
;	mov rcx,rdx
;	mov rdi,rdx

;;	xor r10,r10
;;	mov r9,TVI_LAST				;--- insafter
;;	mov r8,[gpt.hTreeIUnb]
;;	mov rdx,LF_FILE or \
;;		LF_OPENED or \
;;		LF_UNB		;--- type
;;	mov rax,[gpt.projDir]
;;	call tree.insi
;	mov rsi,rdx

;	;--- in RCX hCb
;	;--- in RDX string
;	;--- in R8 imgindex
;	;--- in R9 param
;	;--- in R10 (indent r10b,index overlay rest R10)
;	;--- in R11 selimage
;	mov rax,[gpt.pEdit]
;	mov rcx,[rax+EDIT.hCbxFile]
;	mov rdx,rdi
;	push rax
;	push rcx
;	mov r8d,[.labf.iIcon]
;	mov r9,rsi
;	xor r10,r10
;	mov r11,r8
;	call cbex.ins_item

;	mov r8,rax
;	pop rcx
;	call cbex.sel_item

;	mov rcx,[gpt.hSci]
;	call sci.get_docp
;	mov [.labf.pDoc],rax

;	mov r9,rax
;	mov rcx,[gpt.hSci]
;	call sci.add_refdoc

;	mov r9,[.labf.pDir]
;	add r9,sizeof.DIR
;	mov rdi,r9
;	call cons.set_dir

;	pop rax
;	mov r9,rdi
;	mov rcx,[rax+EDIT.hStaDir]
;	call win.set_text

;	mov rdx,TRUE
;	mov rcx,[.labf.hItem]
;	call tree.set_bold

;	mov rax,rsi
;	pop rsi
;	pop rdi
;	ret 0

