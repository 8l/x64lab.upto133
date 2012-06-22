
  ;#-------------------------------------------------ü
  ;|          x64lab  MPL 2.0 License                |
  ;|   Copyright (c) 2009-2012, Marc Rainer Kranz.   |
  ;|            All rights reserved.                 |
  ;|-------------------------------------------------|
  ;|      Dienstag] - 19.Juni.2012 - 10:51:19        |
	;| tree.asm                                        |
	;ä-------------------------------------------------ö

tree:
	virtual at rdi
		.tvis TVINSERTSTRUCTW
	end virtual

	virtual at rbx
		.labf LABFILE
	end virtual


.get_paraft:
	;--- get parent item and after
	;--- in RCX labf
	;--- RET RDX parent
	;--- RET R8 insafter (as TVI_FIRST or item)
	xor eax,eax
	test ecx,ecx
	jnz	.get_paraftA
	ret 0

.get_paraftA:
	movzx eax,[rcx+\
		LABFILE.type]

	mov r9,[rcx+\
		LABFILE.hItem]

	test eax,LF_FILE
	jnz	.get_paraftF

	mov rdx,[hRootWsp]
	mov r8,TVI_FIRST

	test eax,LF_WSP
	jnz .get_paraftE

	mov rdx,[rcx+\
		LABFILE.hItem]

.get_paraftE:
	ret 0

.get_paraftF:
	push r9
	mov rcx,[hTree]
	call tree.get_parent
	mov rdx,rax
	pop r8
	ret 0


	;#---------------------------------------------------ö
	;|          INSI insert item in treeview
	;ö---------------------------------------------------ü
.insert:
	;--- in RCX labf
	;--- in RDX parent
	;--- in R8 insafter

	;--- RET RAX hItem
	;--- RET RCX dir
	;--- RET RDX labf
	push rbx
	push rdi

	xor eax,eax
	sub rsp,\
		sizea16.TVINSERTSTRUCTW
	test rcx,rcx
	jz	.insertE

	mov rdi,rsp
	mov rbx,rcx

	mov [.tvis.item.pszText],\
		LPSTR_TEXTCALLBACK
	mov [.tvis.hParent],rdx
	mov [.tvis.hInsertAfter],r8
	mov [.tvis.item.lParam],rbx

  mov [.tvis.item.mask],\
		TVIF_TEXT or \
		TVIF_PARAM or \
		TVIF_IMAGE or \
		TVIF_SELECTEDIMAGE

	mov eax,[.labf.iIcon]
	mov [.tvis.item.iImage],eax
	mov [.tvis.item.iSelectedImage],eax

	mov r9,rdi
	mov rcx,[hTree]
	call .ins_item
	test rax,rax
	jz	.insertE

	mov [.labf.hItem],rax
	mov rdx,rbx
	mov rcx,[.labf.dir]

.insertE:
	add rsp,\
		sizea16.TVINSERTSTRUCTW
	pop rdi
	pop rbx
	ret 0

	;#---------------------------------------------------ö
	;|                   SETBOLD                         |
	;ö---------------------------------------------------ü
	
.set_bold:
	;--- in RCX hTree
	;--- in RDX hItem
	;--- in R8 bold TRUE/FALSE
	xor eax,eax
	sub rsp,sizeof.TVITEMW
	shl r8,4
	or eax,TVIF_STATE
	mov [rsp+TVITEMW.stateMask],TVIS_BOLD
	mov [rsp+TVITEMW.state],r8d
	jmp	.set_itemA
	
.set_itemA:	
	mov [rsp+TVITEMW.hItem],rdx
	mov [rsp+TVITEMW.mask],eax
	mov r9,rsp
	call .set_item
	mov rcx,[rsp+TVITEMW.hItem]
	add rsp,sizeof.TVITEMW
	ret 0

.set_olay:
	;--- in RCX hTree
	;--- in RDX hItem
	;--- in R8 index
	xor eax,eax
	sub rsp,sizeof.TVITEMW
	shl r8,8
	or eax,TVIF_STATE
	mov [rsp+\
		TVITEMW.stateMask],\
		TVIS_OVERLAYMASK
	mov [rsp+\
		TVITEMW.state],r8d
	jmp	.set_itemA

	;#---------------------------------------------------ö
	;|          helper TREEVIEW                          |
	;ö---------------------------------------------------ü

.get_param:
	;--- in RCX hTree
	;--- in RDX hItem
	;--- in R9 TVITEM
	mov eax,\
		TVIF_PARAM or \
		TVIF_HANDLE or \
		TVIF_CHILDREN
	xor r8,r8
	jmp	.get_itemA	

.get_item:
	;--- in RCX hTree
	;--- in RDX hItem
	;--- in R8 textbuf 100h cpts
	;--- in R9 TVITEM
	mov eax,TVIF_TEXT or \
		TVIF_PARAM or \
		TVIF_IMAGE or \
		TVIF_STATE or \
		TVIF_HANDLE	or \
		TVIF_CHILDREN

	mov [r9+\
		TVITEMW.pszText],r8
	mov [r9+\
		TVITEMW.cchTextMax],100h
	;--- in R9 TVITEM

.get_itemA:
	mov [r9+\
		TVITEMW.hItem],rdx
	mov [r9+\
		TVITEMW.mask],eax
	mov edx,TVM_GETITEMW
	jmp	apiw.sms

.sel_item:
	mov r8,TVGN_CARET
	mov rdx,TVM_SELECTITEM
	jmp apiw.sms

.exp_item:
	;--- in R9 hItem
	;--- in R8 TVE_COLLAPSE,TVE_EXPAND
	mov edx,TVM_EXPAND
	jmp	apiw.sms

.del_item:
	mov edx,TVM_DELETEITEM
	jmp	apiw.sms

.ins_item:
	;--- in R9 TVINSEERTSTRUCT
	mov edx,TVM_INSERTITEMW
	xor r8,r8
	jmp apiw.sms

.set_bkcol:
	;--- in R9 color
	mov edx,TVM_SETBKCOLOR
	xor r8,r8
	jmp apiw.sms

.set_item:
	;--- in R9 
	mov edx,TVM_SETITEMW
	xor r8,r8
	jmp apiw.sms

.set_iml:
	mov edx,TVM_SETIMAGELIST
	jmp apiw.sms

.countall:
	xor r8,r8
	xor r9,r9
	mov edx,TVM_GETCOUNT
	jmp apiw.sms

.get_parent:
	mov r8,TVGN_PARENT	
	jmp .get_next

.get_root:
	xor r9,r9
	mov r8,TVGN_ROOT	
	jmp .get_next

.get_next:
	mov edx,TVM_GETNEXTITEM
	jmp apiw.sms

.get_child:	
	mov r8,TVGN_CHILD
	jmp	.get_next

.get_sibl:
	mov r8,TVGN_NEXT	
	jmp .get_next

.get_sel:
	xor r9,r9
	mov r8,TVGN_CARET
	jmp	.get_next

	
;	;#---------------------------------------------------ö
;	;|                   HASCHILDREN                     |
;	;ö---------------------------------------------------ü

;proc .haschildren
;	local .tvi:TV_ITEM
;	mov [.tvi.mask],TVIF_CHILDREN or TVIF_HANDLE	
;	mov [.tvi.hItem],eax
;	lea eax,[.tvi]
;	call tree.getitem
;	test eax,eax
;	jz	.err_hc
;	mov eax,[.tvi.cChildren]
;	test eax,eax
;	jz	.err_hc
;	mov eax,[.tvi.hItem]
;	call tree.getchild
;.err_hc:
;	ret
;endp

	;#-----------------------------------------ö
	;|             LIST (item-params)          |
	;ä-----------------------------------------ü

.list:
	;--- uses RDX startitem
	;--- uses RBX level
	;--- uses RDI capable buffer nItems * 8
	;--- uses RSI datalen of text
	
	sub rsp,\
		sizeof.TVITEMW

.listD:
	mov r9,rsp
	mov rcx,[hTree]
	call .get_param
	test eax,eax
	jz	.listE

	mov rax,[rsp+\
		TVITEMW.lParam]
	
	mov ecx,[rsp+\
		TVITEMW.cChildren]

	mov rdx,[rsp+\
		TVITEMW.hItem]

	test rax,rax
	jz	.listE

	movzx r8,[rax+\
		LABFILE.alen]
	add rsi,r8

	mov [rax+\
		LABFILE.level],bl
	
	mov [rax+\
		LABFILE.flags],cl

	stosq
	dec ecx
	js .listA
	inc bl

.listC:
	push rdx
	mov r9,rdx
	mov rcx,[hTree]
	call .get_child
	mov rdx,rax
	call .list
	pop rdx

.listA:
	;--- check .sibling
	mov r9,rdx
	mov rcx,[hTree]
	call .get_sibl
	mov rdx,rax
	test eax,eax
	jnz	.listD

.listE:
	dec bl
	add rsp,\
		sizeof.TVITEMW
	ret 0


	;--- in RCX hTree
	;--- in RDX hItem
	;--- in R8 textbuf 100h cpts
	;--- in R9 TVITEM

;	mov r9,r12
;	mov rdx,rax
;	lea r8,[r12+\
;		sizea16.TVITEMW]
;	mov rcx,[pWsp.hTree]
;	call .get_item
;@break
;	mov rax,[r12+TVITEMW.pszText]
;	push qword[rdi-8]
;	mov rax,qword[rdi-8]


;	case TVN_ITEMEXPANDED
;		mov [lab.lastproj.info],PROJ_MODIFIED
;		jmp	.ret0

;		;-----------------------  labeledit ------------------------
;	case TVN_ENDLABELEDIT
;		mov eax,[lparam]
;		mov esi,[eax+TV_DISPINFO.item+TV_ITEM.pszText]
;		test esi,esi
;		jz	.lab_exit
;		mov ebx,[eax+TV_DISPINFO.item+TV_ITEM.lParam]
;		test ebx,ebx
;		jz	.lab_exit

;	.lab_changed:
;		mov eax,[labfile.flags]
;		test al,FLAGS_SECTION
;		jnz	.lab_section				
;		test al,FLAGS_FILE
;		jnz	.lab_file

;	.lab_exit:
;		jmp .ret0

;	.lab_file:
;		mov eax,[labfile.hashdir]
;		test eax,eax
;		jz	.lab_exit
;		call config.is_hash
;		jnc	.lab_exit

;		mov eax,[edx+DIR_SLOT.pdir]
;		lea edi,[.buffer512]
;		mov [.pointer],eax

;		push 0
;		push esi
;		push szSlash
;		push eax
;		push edi			
;		push 0
;		call shared.catstr

;		mov eax,edi
;		call shared.is_file	
;		jc	.lab_fileA			;file doesent exist : copy it
;		jmp	.try_correct		;destfile exists: try if from error source

;	.try_correct:
;		mov eax,[labfile.flags]
;		test al,FLAGS_FILEISOPEN	;cannot rename while opened
;		jnz	.lab_exit	

;		movzx eax,ax							;turn off eventual err flags
;		mov [labfile.flags],eax
;		mov [lab.lastproj.info],PROJ_MODIFIED
;		jmp	.lab_fileD

;		;-----------update icon-----------------	
;	.lab_section:
;		mov [lab.lastproj.info],PROJ_MODIFIED
;		jmp .ret1
;	
;	.lab_fileE:
;		;--- doesent rename bad item to new (bad) item/file
;		mov edx,szAskCreateFile
;		mov ecx,szErrName
;		mov eax,[hMain]
;		call shared.message_err
;		jmp	.lab_exit

;	.lab_fileA:				
;		mov eax,[labfile.flags]
;		test eax,FLAGS_ERR
;		jnz	.lab_fileE
;		test al,FLAGS_FILEISOPEN
;		jz	.lab_fileB

;		mov eax,[labfile.hItem]
;		lea edx,[.sbuffer256]
;		call tree.gettext
;		push ITEM_ASKSAVE
;		call child.save
;		test eax,eax
;		jz	.lab_exit

;	.lab_fileB:
;		push FALSE
;		push EDI
;		mov eax,[labfile.hItem]
;		lea edx,[.sbuffer256]
;		call tree.gettext
;		
;		lea edx,[.sbuffer512]
;		push EDX

;		push 0
;		push eax
;		push szSlash
;		push [.pointer]
;		push edx
;		push 0
;		call shared.catstr
;		CopyFile				
;		mov [lab.lastproj.info],PROJ_MODIFIED
;		;---------- update cmd on extension type ----------
;	.lab_fileD:
;		push esi
;		push ebx
;		call ext.bind
;		jmp	.ret1

;		;#---------------------------------------------------ö
;		;|                 TVN_SELCHANGING                   |
;		;ö---------------------------------------------------ü
;		case TVN_SELCHANGING
;			mov ebx,[eax+NM_TREEVIEW.itemNew+TV_ITEM.lParam]
;			mov edx,[eax+NM_TREEVIEW.itemOld+TV_ITEM.lParam]
;			test ebx,ebx
;			jz	@f
;			cmp edx,ebx
;			jz	@f

;			mov eax,[labfile.hItem]
;			lea edx,[.buffer512]
;			call tree.gettext
;			call stat.showdir

;			test [labfile.flags],FLAGS_FILEISOPEN
;			jnz .tvn_sc
;			jmp @f

;		.tvn_sc:			
;			push [hMain]
;			LockWindowUpdate
;			push 0
;			push [labfile.hChild]
;			push WM_MDIACTIVATE
;			push [hClient]
;			SendMessage
;			push 0
;			LockWindowUpdate
;		@@:
;			jmp .ret0

;				
;		case NM_RCLICK
;			call tree.gethit
;			test eax,eax
;			jz	.ret0
;			mov ebx,edx		;in ebx labfile
;			mov esi,eax		;in esi hItem
;			call tree.selectitem
;			
;			lea edi,[.buffer512]
;			mov edx,edi
;			mov eax,esi
;			call tree.gettext

;			push edi
;			push ebx		
;			call win.build_menu
;			test eax,eax
;			jz	.ret0

;			call general.getxy

;			push NULL
;			push [hwnd]
;			push 0
;			push eax
;			push ecx
;			push  TPM_RIGHTBUTTON	or TPM_NONOTIFY or TPM_RETURNCMD
;			;or TPM_HORPOSANIMATION;TPM_LEFTBUTTON or
;			push [hRoXiMenu]
;			TrackPopupMenu
;			test eax,eax
;			jz	.ret0
;	
;			push eax
;			push eax

;			mov ecx,eax
;			mov edx,[pCmdIn]
;			mov eax,[hRoXiMenu]
;			call mnu.get_stringbypos


;			mov edx,[pCmdIn]
;			push [hRoXiMenu]	
;			GetMenuItemID		

;			push [pCmdIn]
;			push eax
;			push WM_COMMAND
;			push [hMain]		
;			SendMessage

;			pop eax

;			test ebx,ebx
;			jz	.ret0
;			cmp eax,10			;default previous menu items
;			jb	.ret0
;			sub eax,10
;			mov [labfile.xi_idx],ax
;			jmp .ret0




;;------------------------MISC---------------------
;align 4
;.getitemrect:
;	push eax
;	push FALSE
;	push TVM_GETITEMRECT
;	jmp	 .sendmessagetree

;.createdragimg:
;	push eax
;	push 0
;	push TVM_CREATEDRAGIMAGE
;	jmp	 .sendmessagetree

;.getbkcolor:
;	push 0
;	push 0
;	push TVM_GETBKCOLOR
;	jmp	 .sendmessagetree


;.settextcolor:
;	push eax
;	push 000000FFh
;	push TVM_SETTEXTCOLOR
;	jmp	 .sendmessagetree
;	

;.sortitem:
;	push eax
;	push 0
;	push TVM_SORTCHILDREN
;	jmp .sendmessagetree

;.getselected:
;	push 0
;	push TVGN_CARET
;	jmp .getnext
;		

;.getparent:
;	push eax
;	push TVGN_PARENT
;	jmp .getnext
;	
;.getprevvis:
;	push eax
;	push TVGN_PREVIOUSVISIBLE
;	jmp .getnext

;.getprev:
;	push eax
;	push TVGN_PREVIOUS
;	jmp .getnext
;	
;.getsibling:
;	push eax
;	push TVGN_NEXT	
;	jmp .getnext

;.getnextvisible:
;	push eax
;	push TVGN_NEXTVISIBLE
;	jmp .getnext


;.ensure_item:
;	push eax
;	push 0
;	push TVM_ENSUREVISIBLE
;	jmp .sendmessagetree

;.toggle_item:
;	push eax
;	push TVE_TOGGLE
;	jmp	.expandA

;.expand_item:
;	push eax
;	jmp .expand
;.expand:
;	push TVE_EXPAND
;.expandA:
;	push TVM_EXPAND
;	jmp .sendmessagetree
;	
;.countall:
;	push 0
;	push 0
;	push TVM_GETCOUNT
;	jmp .sendmessagetree	


;;---------------------------
;.setitem1:	
;	push eax
;	push 0
;	push ecx
;	jmp .sendmessagetree

;.setitem:
;	mov ecx,TVM_SETITEM
;	jmp .setitem1

;	
;.insertitem:
;	mov ecx,TVM_INSERTITEM
;	jmp .setitem1

;.getitem:	
;	mov ecx,TVM_GETITEM
;	jmp .setitem1

;.hittest:
;	mov ecx,TVM_HITTEST
;	jmp .setitem1

		
;.notify:
;	push eax
;	push ecx 		
;	push WM_NOTIFY
;	push [hMain]
;	jmp .sendmessage
