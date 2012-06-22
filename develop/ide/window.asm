
  ;#-------------------------------------------------ü
  ;|          x64lab  MPL 2.0 License                |
  ;|   Copyright (c) 2009-2012, Marc Rainer Kranz.   |
  ;|            All rights reserved.                 |
  ;|-------------------------------------------------|
  ;|      Dienstag] - 19.Juni.2012 - 10:51:19        |
	;| window.asm                                      |
	;ä-------------------------------------------------ö

win:

.controls:
	;--- in RCX hMain
	push rbp
	push r12
	push r13
	mov rbp,rsp
	and rsp,-16

	mov rbx,rcx
	sub rsp,\
		FILE_BUFLEN

	mov rsi,[hInst]
	mov rdi,rsp
	mov r12,[CreateWindowExW]

	mov rdx,hsmSysList
	mov rcx,hlaSysList
	call [Shell_GetImageLists]
	mov rax,[hsmSysList]

	mov rdx,CLR_NONE
	mov rcx,rax
	call iml.set_bkcol

;@break
	xor eax,eax
	mov [rdi+58h],rax
	mov [rdi+50h],rsi
	mov [rdi+48h],rax
	mov [rdi+40h],rbx

	mov [rdi+38h],rax
	mov [rdi+30h],rax
	mov [rdi+28h],rax
	mov [rdi+20h],rax
	mov r9,WS_CHILD\
		or WS_VISIBLE\
		or TVS_HASLINES\
		or TVS_LINESATROOT\
		or TVS_EDITLABELS\
		or TVS_HASBUTTONS
	;	or TVS_SHOWSELALWAYS
	xor r8,r8
	mov rdx,uzTreeClass
	mov rcx,WS_EX_WINDOWEDGE
	call r12
	test rax,rax
	jz .controlsE
	mov [hTree],rax

	xor eax,eax
	mov [rdi+58h],rax
	mov [rdi+50h],rsi
	mov [rdi+48h],rax
	mov [rdi+40h],rbx

	mov [rdi+38h],rax
	mov [rdi+30h],rax
	mov [rdi+28h],rax
	mov [rdi+20h],rax
	mov r9,WS_CHILD\
		or WS_VISIBLE\
		or LVS_REPORT
	xor r8,r8
	mov rdx,uzLViewClass
	mov rcx,WS_EX_WINDOWEDGE
	call r12
	test rax,rax
	jz .controlsE
	mov [hDocs],rax

	xor r8,r8
	mov rdx,rsi
	mov rcx,rbx
	call [dock64.init]
	test rax,rax
	jz	.controlsE
	mov [hDocker],rax

	;------------ properties ---------------------
	mov r8,rdi
	mov edx,U16
	mov ecx,UZ_CPWIN
	call [lang.get_uz]

	mov r10,0
	mov r9,prop.proc
	mov r8,rbx
	mov rdx,PROP_DLG
	mov rcx,rsi
	call apiw.cdlgp

	xor r11,r11	
	mov r10,rdi	;--- caption
	mov r9,200	;--- ratio/rect/cx or cy
	mov r8,\		;--- flags
		ALIGN_LEFT or \
		HAS_CONTROL or \
		EXCLUDE_TOP or \
		EXCLUDE_BOTTOM or\ 
		EXCLUDE_CLIENT
	mov rdx,rax
	mov rcx,[hDocker]					;--- hDocker/hShare
	call [dock64.panel]

	;------------ workspace -----------------------
	mov r8,rdi
	mov edx,U16
	mov ecx,UZ_WSPACE
	call [lang.get_uz]

	xor r11,r11
	mov r10,rdi		;--- caption
	mov r9,200		;--- ratio/rect/cx or cy
	mov r8,\			;--- flags
		ALIGN_RIGHT or \
		HAS_CONTROL or\
		EXCLUDE_TOP or \
		EXCLUDE_BOTTOM or\ 
		EXCLUDE_CLIENT
	mov rdx,[hTree]
	mov rcx,[hDocker]			;--- hDocker/hShare
	call [dock64.panel]

	;----------console -------------------------
	mov r8,rdi
	mov edx,U16
	mov ecx,UZ_CONS_WIN
	call [lang.get_uz]

	mov r10,0
	mov r9,console.proc
	mov r8,rbx
	mov rdx,CONS_DLG
	mov rcx,rsi
	call apiw.cdlgp

	xor r11,r11	
	mov r10,rdi	;--- caption
	mov r9,200	;--- ratio/rect/cx or cy
	mov r8,\		;--- flags
		ALIGN_BOTTOM or \
		HAS_CONTROL or \
		EXCLUDE_LEFT or \
		EXCLUDE_RIGHT
	mov rdx,rax
	mov rcx,[hDocker]	;--- hDocker/hShare
	call [dock64.panel]

	;------------open documents--------------------
	mov r8,rdi
	mov edx,U16
	mov ecx,MI_FI_OPEN
	call [lang.get_uz]

	xor r11,r11
	mov r10,rdi		;--- caption
	mov r9,150		;--- ratio/rect/cx or cy
	mov r8,\			;--- flags
		ALIGN_RIGHT or \
		HAS_CONTROL or \
		EXCLUDE_TOP or \
		EXCLUDE_BOTTOM or\ 
		EXCLUDE_CLIENT
	mov rdx,[hDocs]
	mov rcx,[hDocker]					;--- hDocker/hShare
	call [dock64.panel]

	;--------------- editor dialog ---------------
	mov r10,0
	mov r9,edit.proc
	mov r8,rbx
	mov rdx,EDIT_DLG
	mov rcx,rsi
	call apiw.cdlgp

	xor r11,r11				;--- menu
	mov r10,uzDefault	;--- caption
	mov r9,200				;--- ratio/rect/cx or cy
	mov r8,\					;--- flags
		ALIGN_CLIENT or \
		HAS_CONTROL
	mov rdx,rax
	mov rcx,[hDocker]					;--- hDocker/hShare
	call [dock64.panel]
	mov rdx,[pEdit]
	mov [rdx+EDIT.pPanel],rax

	call wspace.setup

.controlsE:
	mov rsp,rbp
	pop r13
	pop r12
	pop rbp
	ret 0


.set_text:
	xor r8,r8
	mov edx,WM_SETTEXT
	jmp	apiw.sms

.get_text:
	;--- in R9 buf512
	mov r8,100h
	mov edx,WM_GETTEXT
	jmp	apiw.sms

   ;ü------------------------------------------ö
   ;|   IMAGELIST                              |
   ;#------------------------------------------ä
iml:

.set_bkcol:
	;--- in RCX hImagelist
	;--- in RDX color
	mov rax,[ImageList_SetBkColor]
	jmp	apiw.prolog0

.create:
	mov rax,[ImageList_Create]
	jmp	apiw.prologP
	
.add_masked:
	mov rax,[ImageList_AddMasked]
	jmp	apiw.prolog0

.get_count:
	mov rax,[ImageList_GetImageCount]
	jmp	apiw.prolog0

.load_img:
	push rbp
	mov rbp,rsp
	and rsp,-16
	push 0			;--- hold align 16
	push r11
	mov rax,[ImageList_LoadImageW]
	xor r11,r11	;--- uType IMAGE_BITMAP
	jmp	apiw.prologQ

.draw:
	mov rax,[ImageList_Draw]
	jmp	apiw.prologP
	
   ;ü------------------------------------------ö
   ;|   STATUSBAR                              |
   ;#------------------------------------------ä

statb:
;.create:
;	;--- in RCX parent
;	push rbp
;	mov rbp,rsp
;	and rsp,-16
;	sub rsp,60h
;	lea rdx,[rsp+20h]
;	xor eax,eax

;	mov r8,[hInst]
;	mov [rdx+38h],rax
;	mov [rdx+30h],r8
;	mov [rdx+28h],rax
;	mov [rdx+20h],rcx
;	mov [rdx+18h],rax
;	mov [rdx+10h],rax
;	mov [rdx+8h],rax
;	mov [rdx],rax
;	mov rdx,uzStbClass
;	mov r9,WS_CHILD \
;		or WS_VISIBLE
;	xor r8,r8
;	xor ecx,ecx
;	call [CreateWindowExW]
;	mov rsp,rbp
;	pop rbp
;	ret 0

.set_parts:
	;--- in R8 parts
	;--- in R9 array edges
	mov edx,SB_SETPARTS
	jmp	apiw.sms

.set_text:
	;--- in R8 part/flags
	;--- in R9 text
	mov edx,SB_SETTEXTW
	jmp	apiw.sms

   ;ü------------------------------------------ö
   ;|   TAB                                    |
   ;#------------------------------------------ä
tab:
.add_tab:
	;--- in RCX hTab
	;--- in RDX string
	;--- in R8 imgindex -1,index
	;--- in R9 param
	;--- in R10 index		-1,index
	push rbp
	mov rbp,rsp
	and rsp,-16

	sub rsp,\
		sizea16.TCITEMW
	xor r11,r11
	test rdx,rdx
	jz	@f
	mov [rsp+\
		TCITEMW.pszText],rdx
	or r11,TCIF_TEXT
@@:
	test r9,r9
	jz	@f
	or ecx,TCIF_PARAM
	mov [rsp+\
		TCITEMW.lParam],r9
@@:
	inc r8
	jz	@f
	dec r8
	mov [rsp+\
		TCITEMW.iImage],r8d
	or r11,TCIF_IMAGE
@@:		
	mov r8,r10
	mov [rsp+\
		TCITEMW.mask],r11d
	inc r10
	jnz	@f

	push rcx
	call .get_numtabs
	pop rcx
	mov r8,rax
@@:		
	mov r9,rsp
	call .ins_item
	mov rsp,rbp
	pop rbp
	ret 0

.get_cursel:
	mov rdx,\
		TCM_GETCURSEL
	jmp	apiw.sms

.set_cursel:
	mov rdx,\
		TCM_SETCURSEL
	jmp	apiw.sms

.ins_item:
	mov rdx,\
		TCM_INSERTITEMW
	jmp	apiw.sms

.get_numtabs:
	mov rdx,\
		TCM_GETITEMCOUNT
	xor r8,r8
	xor r9,r9
	jmp apiw.sms

.adj_rect:
	mov rdx,\
		TCM_ADJUSTRECT
	jmp apiw.sms

.set_iml:
	xor r8,r8
	mov edx,\
		TCM_SETIMAGELIST
  jmp apiw.sms

.get_irect:
	mov edx,\
		TCM_GETITEMRECT
	jmp	apiw.sms

;.get_numtabs:
;	push 0
;	push 0
;	push TCM_GETITEMCOUNT

;.tab_sendmessage:
;	push eax
;	SendMessage
;	ret 0

;.setilist:
;	push edx
;	push 0
;	push TCM_SETIMAGELIST
;	jmp .tab_sendmessage

;.del_item:
;	push 0
;	push edx
;	push TCM_DELETEITEM
;	jmp .tab_sendmessage
;	
;.get_item:
;	push edx
;	push ecx
;	push TCM_GETITEM
;	jmp .tab_sendmessage

;.get_rows:
;	push 0
;	push 0
;	push TCM_GETROWCOUNT
;	jmp .tab_sendmessage

;proc .getlparam
;	;RET EDX=pflfile
;	; IN EAX=htab
;	; IN ECX=item
;	local .tci:TC_ITEM
;	lea edx,[.tci]	
;	mov [edx+TC_ITEM.mask],TCIF_PARAM	
;	call .get_item
;	mov eax,[.tci.lParam]
;	ret
;endp

   ;ü------------------------------------------ö
   ;|   LISTVIEW                               |
   ;#------------------------------------------ä

lvw:
.ins_col:
	mov edx,LVM_INSERTCOLUMNW
	jmp	apiw.sms

.set_xstyle:
	mov edx,\
	LVM_SETEXTENDEDLISTVIEWSTYLE
	jmp	apiw.sms

.set_iml:
	mov edx,LVM_SETIMAGELIST
	jmp	apiw.sms

.ins_item:
	xor r8,r8
	mov edx,LVM_INSERTITEMW
	jmp	apiw.sms

.del_item:
	;--- in R8 item -----
	xor r9,r9
	mov edx,LVM_DELETEITEM
	jmp	apiw.sms

.get_next:
	;--- in r8 iItem/-1
	;--- in r9 flags
	mov edx, LVM_GETNEXTITEM
	jmp	apiw.sms
	
.get_count:
	xor r8,r8
	xor r9,r9
	mov edx,LVM_GETITEMCOUNT
	jmp	apiw.sms

.get_param:
	;--- in RCX hLvw
	;--- in R9 TVITEM
	mov [r9+LVITEMW.mask],\
		LVIF_PARAM
	jmp	.get_item

.get_item:
	;--- in R9 TVITEM
	;--- in RCX hLvw
	mov edx,LVM_GETITEMW
	jmp	apiw.sms

.set_itext:
	;--- in R9 TVITEM
	;--- in R8 idx item
	mov edx,LVM_SETITEMTEXTW
	jmp	apiw.sms


.is_param:
	;--- in RCX hLvw
	;--- in RDX lParam to match
	;--- ret RAX 0,our lparam
	;--- ret RCX prev lparam
	;--- ret RDX idx
	push rbx
	push rdi
	push rsi
	push r12
	push r13

	sub rsp,\
		sizeof.LVITEMW
	xor r13,r13
	xor r12,r12

	mov [rsp+\
		LVITEMW.lParam],r12

	mov [rsp+\
		LVITEMW.iItem],r12d

	mov rsi,rdx
	mov rbx,rcx
	call .get_count
	mov edi,eax
	test eax,eax
	jz	.is_paramE
	mov r13,rax

.is_paramA:
	mov eax,r13d
	neg eax
	add eax,edi
	xor edx,edx

	mov r9,rsp
	mov [rsp+\
		LVITEMW.lParam],rdx
	mov [rsp+\
		LVITEMW.iItem],eax
	mov [rsp+\
		LVITEMW.iSubItem],edx
	mov rcx,rbx
	call .get_param
	test eax,eax
	jz	.is_paramB	;--- skip int. err.

	cmp rsi,[rsp+\
		LVITEMW.lParam]
	jz	.is_paramE

.is_paramB:
	mov r12,[rsp+\
		LVITEMW.lParam]
	dec r13d
	jnz	.is_paramA
	mov [rsp+\
		LVITEMW.lParam],r13

.is_paramE:
	mov rcx,r12
	mov edx,[rsp+\
		LVITEMW.iItem]

	mov rax,[rsp+\
		LVITEMW.lParam]

	add rsp,\
		sizeof.LVITEMW
	pop r13
	pop r12
	pop rsi
	pop rdi
	pop rbx
	ret 0


   ;ü------------------------------------------ö
   ;|   COMBOBOXEXT                            |
   ;#------------------------------------------ä

cbex:
;.create_ddl:
;	mov r9,WS_CHILD \
;		or WS_VISIBLE\
;		or CBS_DROPDOWNLIST
;	jmp	.createA

;.create_dd:
;	;--- in RCX parent
;	mov r9,WS_CHILD \
;		or WS_VISIBLE\
;		or CBS_DROPDOWN

;.createA:
;	push rbp
;	mov rbp,rsp
;	and rsp,-16
;	sub rsp,60h
;	lea rdx,[rsp+20h]
;	xor eax,eax

;	mov r8,[hInst]
;	mov [rdx+38h],rax
;	mov [rdx+30h],r8
;	mov [rdx+28h],rax
;	mov [rdx+20h],rcx
;	mov [rdx+18h],rax
;	mov [rdx+10h],rax
;	mov [rdx+8h],rax
;	mov [rdx],rax
;	mov rdx,uzCbexClass
;	xor r8,r8
;	xor ecx,ecx
;	call [CreateWindowExW]
;	mov rsp,rbp
;	pop rbp
;	ret 0

.get_count:
	xor r8,r8
	xor r9,r9
	mov edx,CB_GETCOUNT
	jmp	apiw.sms

.sel_item:
	;--- in R8 index
	xor r9,r9
	mov edx,CB_SETCURSEL
	jmp	apiw.sms

.set_iml:
	xor r8,r8
	mov edx,CBEM_SETIMAGELIST
	jmp	apiw.sms

.get_cursel:
	xor r9,r9
	xor r8,r8
	mov edx,CB_GETCURSEL
	jmp	apiw.sms


.ins_item:
	;--- in RCX hCb
	;--- in RDX string
	;--- in R8 imgindex
	;--- in R9 param
	;--- in R10 indent r10b,index overlay rest R10)
	;--- in R11 selimage
	sub rsp,\
		sizeof.COMBOBOXEXITEMW
	mov [rsp+\
		COMBOBOXEXITEMW.pszText],rdx
	mov rax,r10
	mov edx,CBEIF_TEXT or \
		CBEIF_INDENT
	and r10,0Fh
	shr eax,8
	mov [rsp+\
		COMBOBOXEXITEMW.iIndent],r10d
	test eax,eax
	jz	@f
	or edx,CBEIF_OVERLAY
	mov [rsp+\
		COMBOBOXEXITEMW.iOverlay],eax
@@:
	test r9,r9
	jz @f
	or edx,CBEIF_LPARAM
	mov [rsp+\
		COMBOBOXEXITEMW.lParam],r9
@@:
	inc r8
	jz	@f
	dec r8
	or edx,CBEIF_IMAGE
	mov [rsp+\
		COMBOBOXEXITEMW.iImage],r8d
@@:
	inc r11
	jz	@f
	dec r11
	or edx,CBEIF_SELECTEDIMAGE
	mov [rsp+\
		COMBOBOXEXITEMW.iSelectedImage],r11d
@@:	
	or [rsp+\
		COMBOBOXEXITEMW.iItem],-1
	mov [rsp+\
		COMBOBOXEXITEMW.mask],edx
	xor r8,r8
	mov r9,rsp
	mov rdx,\
		CBEM_INSERTITEMW
	call apiw.sms
	add rsp,\
		sizeof.COMBOBOXEXITEMW
	ret 0

;.del_item:
;	xor r9,r9
;	mov edx,CBEM_DELETEITEM
;	jmp	apiw.sms
;	
;.get_itemh:
;	xor r9,r9
;	mov edx,CB_GETITEMHEIGHT
;	jmp	apiw.sms
;	

.is_param:
	;--- in RCX hCb
	;--- in RDX lParam to match
	;--- ret RAX index,-1
	;--- ret RDX LPARAM
	push rbp
	push rbx
	push rdi
	push rsi
	mov rbp,rsp
	sub rsp,\
		FILE_BUFLEN

	mov rsi,rdx
	mov rbx,rcx
	call .get_count
	mov rdi,rax
	test rax,rax
	jl	.is_paramC

.is_paramB:
	dec rdi
	mov rax,rdi
	js .is_paramC
	mov r8,rsp
	mov rdx,rdi
	mov rcx,rbx
	call .get_item
	test rax,rax
	jl .is_paramC
	cmp rdx,rsi
	jnz	.is_paramB

.is_paramC:
	mov rsp,rbp
	pop rsi
	pop rdi
	pop rbx
	pop rbp
	ret 0

;.get_cb:
;	xor r8,r8
;	xor r9,r9
;	mov edx,CBEM_GETCOMBOCONTROL
;	jmp	apiw.sms

.get_item:
	;--- in RCX hCb
	;--- in RDX iItem
	;--- in R8 buf512

	;--- RET RAX index,-1
	;--- RET RCX pText
	;--- RET RDX LPARAM
	;--- RET R9 index image
	sub rsp,\
		sizeof.COMBOBOXEXITEMW
	mov rax,rsp
	mov [rax+\
		COMBOBOXEXITEMW.iItem],rdx
	mov [rax+\
		COMBOBOXEXITEMW.cchTextMax],100h
	mov [rax+\
		COMBOBOXEXITEMW.pszText],r8
	mov [rax+\
		COMBOBOXEXITEMW.mask],\
		CBEIF_TEXT or \
		CBEIF_LPARAM or \
		CBEIF_IMAGE
	xor r8,r8
	mov r9,rax
	mov edx,CBEM_GETITEMW
	call apiw.sms
	test rax,rax
	jz	.get_itemA
	mov rax,[rsp+\
		COMBOBOXEXITEMW.iItem]
	mov rcx,[rsp+\
		COMBOBOXEXITEMW.pszText]
	inc rax
	mov rdx,[rsp+\
		COMBOBOXEXITEMW.lParam]
	mov r9d,[rsp+\
		COMBOBOXEXITEMW.iImage]

.get_itemA:
	dec rax
	add rsp,sizeof.COMBOBOXEXITEMW
	ret 0

;;	;1) --- create back color console panel
;;;	mov rcx,00AABBCCh
;;;	call shared.create_sbrush
;;;	mov [hBkColConsPanel],rax
;;@break

;;	xor r8,r8
;;	xor r9,r9
;;	or rax,-1
;;	mov rdx,uzTreeClass
;;	mov rcx,[hEditTab]
;;	call tab.addtab

;.setp1:
;	push eax
;	push SBT_POPOUT or STATUSLINEPART
;	jmp .msg1

;.setp3:
;	push eax
;	push SBT_POPOUT or STATUSDIRPART

;.msg1:
;	push SB_SETTEXT
;.msg:
;	push [hStatus]
;	SendMessage
;	ret 0

;.getrect:
;	;IN EAX=part
;	;IN EDX=pRect
;	push edx
;	push eax
;	push  SB_GETRECT
;	jmp	.msg

;.gettext:
;	;IN EAX=part
;	;IN EDX=pText
;	push edx
;	push eax
;	push SB_GETTEXT
;	jmp	.msg
