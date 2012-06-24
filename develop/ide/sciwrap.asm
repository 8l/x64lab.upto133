
	;#-------------------------------------------------ü
	;|          x64lab  MPL 2.0 License                |
	;|   Copyright (c) 2009-2012, Marc Rainer Kranz.   |
	;|            All rights reserved.                 |
	;|-------------------------------------------------|
	;|      Dienstag] - 19.Juni.2012 - 10:51:19        |
	;ä-------------------------------------------------ö


sci:

@szhash lexer,\
	multisel,\
	stylebits,\
	tabwidth,\
	selback,\
	keyword,\
	style,\
	back,\
	fore,\
	font,\
	fontsize,\
	clearall

	;#---------------------------------------------------ö
	;|                CREATE                             |
	;ö---------------------------------------------------ü
.create:
	;--- in RCX parent
	push rbp
	mov rbp,rsp
	and rsp,-16
	xor eax,eax
	sub rsp,60h
	lea rdx,[rsp+20h]

	mov r8,[hInst]
	mov [rdx+38h],rax
	mov [rdx+30h],r8
	mov [rdx+28h],rax
	mov [rdx+20h],rcx
	mov [rdx+18h],rax
	mov [rdx+10h],rax
	mov [rdx+8h],rax
	mov [rdx],rax
	mov r9,WS_CHILD or \
		WS_TABSTOP or \
		WS_VISIBLE
	xor r8,r8
	mov rdx,uzSciClass
	mov ecx,WS_EX_STATICEDGE
	call [CreateWindowExW]
	mov rsp,rbp
	pop rbp
	ret 0

;display_hex 32,WS_EX_STATICEDGE or WS_CHILD or \
;		WS_TABSTOP or \
;		WS_VISIBLE
;		WS_CLIPCHILDREN or \

	;#---------------------------------------------------ö
	;|                  SET_DEFPROP                      |
	;ö---------------------------------------------------ü

.set_defprop:
	;--- in rcx hText
	push rbx
	mov rbx,rcx

	mov r9,SC_MARGIN_SYMBOL
	mov r8,0
	mov rcx,rbx
	call .set_margtype

	mov r9,SC_MARGIN_NUMBER
	mov r8,1
	mov rcx,rbx
	call .set_margtype

	mov r9,SC_MARGIN_SYMBOL
	mov r8,2
	mov rcx,rbx
	call .set_margtype

	mov r9,16
	mov r8,2
	mov rcx,rbx
	call .set_margwi

	mov r9,szCharExt
	mov r8,STYLE_LINENUMBER
	mov rcx,rbx
	call .set_txtwi

	mov r9,rax
	mov r8,SC_MARGIN_NUMBER
	mov rcx,rbx
	call .set_margwi

	mov r9,8
	mov rcx,rbx
	call .set_marglx

	mov r9,8
	mov rcx,rbx
	call .set_margrx

	mov r9,00AABBCCh
	mov r8,STYLE_LINENUMBER
	mov rcx,rbx
	call .set_backcolor

;	mov r9,0FFFFFFh
;	mov r8,STYLE_LINENUMBER
;	mov rcx,rbx
;	call .set_forecolor

	mov r9,uzCourierN
	mov r8,STYLE_LINENUMBER
	mov rcx,rbx
	call .set_font

	mov r9,9
	mov r8,STYLE_LINENUMBER
	mov rcx,rbx
	call .set_fontsize

	mov r8,SC_CP_UTF8
	mov rcx,rbx
	call .set_cp

	mov r9,uzCourierN
	mov r8,STYLE_DEFAULT
	mov rcx,rbx
	call .set_font

	mov r9,12
	mov r8,STYLE_DEFAULT
	mov rcx,rbx
	call .set_fontsize

	pop rbx
	ret 0


	;#---------------------------------------------------ö
	;|                WRAPS                              |
	;ö---------------------------------------------------ü
.goto_pos:
	xor r9,r9
	mov edx,SCI_GOTOPOS
	jmp	apiw.sms

.set_savepoint:
	xor r8,r8
	xor r9,r9
	mov edx,SCI_SETSAVEPOINT
	jmp	apiw.sms

.set_emptyundobuf:
	xor r9,r9
	xor r8,r8
	mov edx,SCI_EMPTYUNDOBUFFER
	jmp	apiw.sms

.set_undocoll:
	xor r9,r9
	mov edx,SCI_SETUNDOCOLLECTION
	jmp	apiw.sms

.set_cp:
	;--- in r8 codepage
	xor r9,r9
	mov edx,SCI_SETCODEPAGE
	jmp	apiw.sms

.set_margrx:
	;--- in r9 size
	;--- in R8 idx margin
	mov edx,SCI_SETMARGINRIGHT
	jmp	apiw.sms

.set_marglx:
	;--- in r9 size
	;--- in R8 idx margin
	mov edx,SCI_SETMARGINLEFT
	jmp	apiw.sms

.set_margwi:
	;--- in R9 size
	;--- in R8 idx margin
	mov edx,SCI_SETMARGINWIDTHN
	jmp	apiw.sms

.set_txtwi:
	;--- in R9 sample
	;--- in R8 style
	mov edx,SCI_TEXTWIDTH
	jmp	apiw.sms

.set_margtype:
	;--- in RCX hwnd
	;--- in R8 type
	;--- in R9 id
	mov edx,SCI_SETMARGINTYPEN
	jmp	apiw.sms

.add_txt:
	;--- in R8 len
	;--- in R9 text
	mov edx,SCI_ADDTEXT
	jmp	apiw.sms


;.get_docp:
;	mov edx,SCI_GETDOCPOINTER
;	jmp	apiw.sms

;.set_docp:
;	;--- in R9 pDoc
;	mov edx,SCI_SETDOCPOINTER
;	jmp	apiw.sms

;.add_refdoc:
;	;--- in R9 pDoc
;	mov edx,SCI_ADDREFDOCUMENT
;	jmp	apiw.sms

;.create_doc:
;	mov edx,SCI_CREATEDOCUMENT
;	jmp	apiw.sms

;.rel_doc:
;	;--- in R9 pDoc
;	mov edx,SCI_RELEASEDOCUMENT
;	jmp	apiw.sms
	

.get_txtl:
	xor r8,r8
	xor r9,r9
	mov edx,SCI_GETLENGTH
	jmp	apiw.sms

.get_txtr:
	xor r8,r8
	mov edx,SCI_GETTEXTRANGE
	jmp	apiw.sms

	;#---------------------------------------------------ö
	;|                DISCARD                            |
	;ö---------------------------------------------------ü

.discard:
	mov rcx,[hSciDll]
 	jmp apiw.freelib

	;#---------------------------------------------------ö
	;|                SETUP                              |
	;ö---------------------------------------------------ü

.setup:
	;--- in RCX plugdir
	lea rcx,[rcx+DIR.dir]

.setupA:
	sub rsp,FILE_BUFLEN
	xor eax,eax
	mov rdx,rsp
	
	push rax
	push uzSciDll
	push uzSlash
	push rcx
	push rdx
	push rax
	call art.catstrw

	mov rdx,\
		LOAD_WITH_ALTERED_SEARCH_PATH
	mov rcx,rsp
 	call apiw.loadlib
	add rsp,FILE_BUFLEN
	ret 0
	
	;#---------------------------------------------------ö
	;|               .DEF_FLAGS                          |
	;ö---------------------------------------------------ü

.def_flags:
	;--- in RCX hSci
	push rbx
	mov rbx,rcx
	xor r8,r8
	inc r8
	call .set_undocoll

	mov rcx,rbx
	call .set_emptyundobuf

	mov rcx,rbx
	call apiw.set_focus

	mov rcx,rbx
	call .set_savepoint

	mov rcx,rbx
	xor r8,r8
	call .goto_pos

	pop rbx
	ret 0

	;#---------------------------------------------------ö
	;|                  SAVE                             |
	;ö---------------------------------------------------ü

.save:
	;--- in RCX hSci
	;--- in RDX path+file
	;--- in R8 encoding
	;--- RET RAX 0/1
	push rbp
	push rbx
	push rdi
	push rsi
	push r12
	push r13
	push r14

	xor r12,r12
	xor r14,r14
	sub rsp,\
		sizeof.TEXTRANGEW

	;--- zero textrange = 16
	mov [rsp],r12
	mov [rsp+8],r12

	mov rbx,rcx
	mov rsi,rdx
	mov r13,r8

	;--- get text len
	mov rcx,rbx
	call .get_txtl

	;--- TODO: warning on zero len
	test rax,rax
	jz	.saveA

	;--- allocate buffer
	mov rcx,rax
	inc rcx
	inc rcx
	call art.valloc
	test rax,rax
	jz	.saveE
	mov rdi,rax
	
	;--- read buffer
	or ecx,-1
	mov [rsp+\
		TEXTRANGEW.chrg.cpMax],ecx
	inc ecx
	mov [rsp+\
		TEXTRANGEW.lpstrText],rax
	mov [rsp+\
		TEXTRANGEW.chrg.cpMin],ecx
	mov r9,rsp
	mov rcx,rbx
	call .get_txtr
	test rax,rax
	jz	.saveE
	mov r14,rax
	
.saveA:
	;--- create always dest file
	mov rcx,rsi
	call art.fcreate_rw
	test rax,rax
	jz	.saveE
	mov rbp,rax

	;--- write to dest file
	mov r8,r14
	mov rdx,[rsp+\
		TEXTRANGEW.lpstrText]
	mov rcx,rax
	call art.fwrite

	mov rcx,rbp
	call art.fend

	mov rcx,rbp
	call art.fclose

	mov rcx,rdi
	call art.vfree

	mov rcx,rbx
	call .set_savepoint
	
	inc r12

.saveE:
	add rsp,\
		sizeof.TEXTRANGEW
	xchg rax,r12
	pop r14
	pop r13
	pop r12
	pop rsi
	pop rdi
	pop rbx
	pop rbp
	ret 0

.set_selbackF:
	mov r9d,[rdx+1]
	movzx r8,byte[rdx]

.set_selback:
	mov edx,SCI_SETSELBACK
	jmp	apiw.sms

.set_fontsizeF:
	movzx r9,byte[rdx+1]
	movzx r8,byte[rdx]

.set_fontsize:
	mov edx,SCI_STYLESETSIZE
	jmp	apiw.sms

.set_fontF:
	lea r9,[rdx+1]
	movzx r8,byte[rdx]

.set_font:
	mov edx,SCI_STYLESETFONT
	jmp	apiw.sms

.set_keywordF:
	lea r9,[rdx+1]
	movzx r8,byte[rdx]
.set_keyword:
	mov edx,SCI_SETKEYWORDS
	jmp	apiw.sms

.set_backcolorF:
	mov r9d,[rdx+1]
	movzx r8,byte[rdx]

.set_backcolor:
	mov edx,SCI_STYLESETBACK
	jmp	apiw.sms

.set_forecolorF:
	mov r9d,[rdx+1]
	movzx r8,byte[rdx]

.set_forecolor:
	mov edx,SCI_STYLESETFORE
	jmp	apiw.sms

.set_tabwidthF:
	movzx r8,byte[rdx]
.set_tabwidth:
	mov edx,SCI_SETTABWIDTH
	jmp	apiw.sms

.set_multiselF:
	movzx r8,byte[rdx]
.set_multisel:
	mov edx,SCI_SETMULTIPLESELECTION
	jmp	apiw.sms

.set_stylebitsF:
	movzx r8,byte[rdx]

.set_stylebits:
	mov edx,SCI_SETSTYLEBITS
	jmp	apiw.sms


.set_lexerF:
	movzx r8,byte[rdx]
.set_lexer:
	;--- in R8 lexer
	mov edx,SCI_SETLEXER
	jmp	apiw.sms

.get_lexer:
	mov edx,SCI_GETLEXER
	jmp	apiw.sms

.style_clearall:
	mov edx,SCI_STYLECLEARALL
	jmp	apiw.sms

;	push 00F2F2F7h
;	push back.hash
;	push edi
;	call esi

;	push 0h
;	push fore.hash
;	push edi
;	call esi

;	push szCourier
;	push font.hash
;	push edi
;	call esi

;	push 12
;	push fontsize.hash
;	push edi
;	call esi

;	push 1
;	push clearall.hash
;	push edi
;	call esi

;	mov edi,STYLE_LINENUMBER
;	push 00AABBCCh
;	push back.hash
;	push edi
;	call esi

;	push 8
;	push fontsize.hash
;	push edi
;	call esi	

;	push 1
;	push bold.hash
;	push edi
;	call esi	

;.exit_hili:
;	pop esi
;	pop edi
;	pop ebx
;	ret
;endp



;	;#---------------------------------------------------ö
;	;|                helper wraps                       |
;	;ö---------------------------------------------------ü

;.get_selstart:
;	mov eax,SCI_GETSELECTIONSTART
;	jmp	.sci_param2

;.get_selend:
;	mov eax,SCI_GETSELECTIONEND
;	jmp	.sci_param2

;.get_mainsel:
;	mov eax,SCI_GETMAINSELECTION
;	jmp	.sci_param2

;.get_sels:
;	mov eax,SCI_GETSELECTIONS
;	jmp	.sci_param2


;.is_selrect:
;	mov eax,SCI_SELECTIONISRECTANGLE
;	jmp	.sci_param2

;	;------------------------
;.sci_param2:
;	xor ecx,ecx
;	xor edx,edx
;	jmp .sci_message0
;	;------------------------

;.get_selnstart:
;	xor edx,edx
;	mov eax,SCI_GETSELECTIONNSTART
;	jmp .sci_message0

;.linelen:
;	xor edx,edx
;	mov eax,SCI_LINELENGTH
;	jmp .sci_message0


;.get_selnend:
;	xor edx,edx
;	mov eax,SCI_GETSELECTIONNEND
;	jmp .sci_message0

;.setsel:
;	mov eax,SCI_SETSEL
;	jmp .sci_message0


;.set_charset:
;	mov eax,SCI_STYLESETCHARACTERSET
;	jmp	.sci_message0

;.set_bold:
;	mov eax,SCI_STYLESETBOLD
;	jmp	.sci_message0

;.set_italic:
;	mov eax,SCI_STYLESETITALIC
;	jmp	.sci_message0

;.replsel:
;	xor ecx,ecx
;	mov eax,SCI_REPLACESEL
;	jmp	.sci_message0

;.inserttxt:
;	mov eax,SCI_INSERTTEXT
;	jmp	.sci_message0

;.linefrompos:
;	xor edx,edx
;	mov eax,SCI_LINEFROMPOSITION
;	jmp	.sci_message0

;.posfromline:
;	xor edx,edx
;	mov eax,SCI_POSITIONFROMLINE
;	jmp	.sci_message0

;.get_lineendpos:
;	xor edx,edx
;	mov eax,SCI_GETLINEENDPOSITION
;	jmp	.sci_message0

;	;#---------------------------------------------------ö
;	;|                  COMMENT                          |
;	;ö---------------------------------------------------ü

;proc .comment\
;	_hsci,\
;	_flags
;	local .num_chars:DWORD
;	local .line_beg:DWORD
;	local	.line_end:DWORD
;	local .sel_beg:DWORD
;	local .sel_end:DWORD
;	local .len_line:DWORD
;	local .len_block:DWORD
;	local .esp_stack:DWORD
;	local .beg_last:DWORD
;	local .end_last:DWORD
;	local .tr:TEXTRANGE

;	push ebx
;	push edi
;	push esi

;	mov ebx,[_hsci]
;	call .is_selrect
;	test eax,eax
;	jnz	.vert_comment

;	;#---------------------------------------------------ö
;	;|                  HORZ_COMMENT                     |
;	;ö---------------------------------------------------ü

;.horz_comment:
;	call .get_sels
;	mov edi,eax
;	test eax,eax
;	jz .exit_c
;	dec eax
;	jz .next_hcA
;	mov edi,eax

;	xor eax,eax
;	call .get_selstartend
;	mov [.beg_last],eax
;	mov [.end_last],edx

;.next_hc:
;	mov eax,edi
;	call .commblock
;	dec edi
;	jnz	.next_hc

;	mov ecx,[.beg_last]
;	mov edx,[.end_last]
;	call .setsel
;	call .get_mainsel

;.next_hcA:
;	call .commblock
;	jmp	.exit_c


;	;#---------------------------------------------------ö
;	;|                  VERT_COMMENT                     |
;	;ö---------------------------------------------------ü
;.vert_comment:
;;@break
;	xor edi,edi
;	call sci.get_sels
;	test eax,eax
;	jz .exit_c
;	dec eax
;	jz .next_vcA
;	mov edi,eax

;	xor eax,eax
;	call .get_selstartend
;	mov [.sel_beg],eax
;	mov [.len_line],ecx
;	mov [.sel_end],edx

;.next_vc:
;;	xor eax,eax
;;	sub eax,edi
;;	neg eax
;	mov eax,edi
;	call .commline
;	dec edi
;	jns	.next_vc

;	mov ecx,[.sel_beg]
;	mov edx,ecx
;	add edx,[.len_line]
;	call .setsel

;.next_vcA:
;	call .commline
;	jmp	.exit_c
;	

;.exit_c:
;	pop esi
;	pop edi
;	pop ebx
;	ret

;.get_selstartend:
;	;IN EAX=line/block
;	;RET ECX= len of line
;	;RET EAX,start
;	;RET EDX,end
;	mov ecx,eax
;	push ecx
;	call .get_selnend
;	pop ecx
;	push eax
;	call .get_selnstart
;	pop edx
;	mov ecx,edx
;	sub ecx,eax
;	ret 0

;	;#---------------------------------------------------ö
;	;|                  BLOCK COMMENT (horz)             |
;	;ö---------------------------------------------------ü

;.commblock:
;;@break
;	push edi
;	push esi
;	;IN EAX=block
;	;IN ECX=len
;	call .get_selstartend
;	mov [.sel_beg],eax
;	mov [.len_block],ecx
;	mov [.sel_end],edx
;	mov [.line_beg],eax

;.comm_blA:
;	mov ecx,[.line_beg]
;	call .linefrompos
;	mov esi,eax

;.comm_blE:
;	mov ecx,esi
;	call .get_lineendpos
;	mov [.line_end],eax

;	mov eax,[.line_beg]
;	mov edx,[.line_end]
;	mov ecx,edx
;	sub ecx,eax			
;	jge @f				;---- patched: to review
;	xor ecx,ecx
;@@:
;	call .comm_glC
;	push eax

;	mov ecx,esi
;	call .linelen
;	pop ecx

;.comm_blC:
;	mov edx,[_flags]
;	test dl,LINE_COMMENT
;	jnz	.comm_blD
;	sub [.sel_end],ecx
;	jmp	.comm_blF

;.comm_blD:
;	add [.sel_end],ecx

;.comm_blF:
;	add eax,[.line_beg]
;	cmp eax,[.sel_end]
;	jae .comm_bl
;	mov [.line_beg],eax
;	jmp	.comm_blA

;.comm_bl:
;	pop esi
;	pop edi
;	ret 0

;	;#---------------------------------------------------ö
;	;|                  LINE COMMENT  (vert)             |
;	;ö---------------------------------------------------ü
;.commline:
;	;IN EAX=line
;	;IN ECX=len
;	;RET EAX=+/-numchars
;	push edi
;	push esi
;	
;	call .get_selstartend
;	test ecx,ecx
;	jz	.comm_glA
;	jmp	.comm_glB

;.comm_glC:
;	push edi
;	push esi

;.comm_glB:
;	test ecx,ecx
;	jz	.comm_glA		;jle
;	
;	mov [.line_beg],eax
;	mov [.line_end],edx
;	mov [.tr.chrg.cpMin],eax
;	mov [.tr.chrg.cpMax],edx

;	mov eax,[_flags]
;	test al,LINE_COMMENT
;	jnz	.comm_comm
;	test al,LINE_DECOMMENT
;	jnz	.comm_decomm
;	; example Alt+X cat first char
;	; test al LINE_CATCOLUMN
;	jz	.comm_glA

;.comm_decomm:
;	mov eax,ecx						;<----num chars
;	add eax,2Fh
;	and eax,not 0Fh
;	mov [.esp_stack],eax	;<---------------------
;	sub esp,eax
;	mov edi,esp
;	xor eax,eax
;	mov edx,esp
;	shr ecx,2
;	mov [.tr.lpstrText],edx
;	rep stosd

;	lea edx,[.tr]
;	call .get_txtrange
;	mov eax,[.tr.lpstrText]
;;@break
;	xor ecx,ecx
;	mov dl,byte[eax]
;	cmp dl,";"
;	jnz	.comm_decommA
;	
;	mov ecx,[.line_beg]
;	mov edx,ecx
;	inc edx
;	call .setsel

;	mov edx,szNull
;	call .replsel
;	xor ecx,ecx
;	inc ecx

;.comm_decommA:
;	add esp,[.esp_stack]
;	jmp .comm_gl

;.comm_comm:
;	mov ecx,[.line_beg]
;	mov edx,szComment
;	call .inserttxt
;	xor ecx,ecx
;	inc ecx
;	jmp	.comm_gl

;.comm_glA:		;len is zero
;	xor ecx,ecx

;.comm_gl:
;	xchg eax,ecx
;	pop esi
;	pop edi
;	ret 0
;endp




