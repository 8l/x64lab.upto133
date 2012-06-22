
  ;#-------------------------------------------------ü
  ;|          x64lab  MPL 2.0 License                |
  ;|   Copyright (c) 2009-2012, Marc Rainer Kranz.   |
  ;|            All rights reserved.                 |
  ;|-------------------------------------------------|
  ;|      Dienstag] - 19.Juni.2012 - 10:51:19        |
	;| menu.asm                                        |
	;ä-------------------------------------------------ö

mnu:

	;#---------------------------------------------------ö
	;|                   SETUP                           |
	;ö---------------------------------------------------ü
	virtual at rbx
		.mii MENUITEMINFOW
	end virtual

	
.setup:
;@break
	push rbp
	push rbx
	push rdi
	push rsi
	push r12
	push r13

	mov rbp,rsp
	and rsp,-16

	;--- create main menu
	call apiw.mnu_create
	mov [hMnuMain],rax

;@break
;	sub rsp,sizeof.MENUINFO
;	mov rdx,rsp
;	mov [rdx+MENUINFO.cbSize],\
;		sizeof.MENUINFO
;	mov [rdx+MENUINFO.fMask],\
;		MIM_MAXHEIGHT
;	mov [rdx+MENUINFO.cyMax],48
;	mov rcx,rax
;	call apiw.mnu_setinfo
;	mov rax,[hMnuMain]

;@break
	xor r9,r9
	mov r8,[omni]
	mov rdx,tMP_WSPACE
	mov rcx,rax
	call .mp_add

	mov r9,1
	mov r8,rax
	mov rdx,tMP_FILE
	mov rcx,[hMnuMain]
	call .mp_add

	mov r9,2
	mov r8,rax
	mov rdx,tMP_PATH
	mov rcx,[hMnuMain]
	call .mp_add

;-----ok	
;	sub rsp,sizeof.MENUINFO
;	mov rdx,rsp
;	mov [rdx+MENUINFO.cbSize],\
;		sizeof.MENUINFO
;	mov [rdx+MENUINFO.fMask],\
;		MIM_MAXHEIGHT
;	mov [rdx+MENUINFO.cyMax],148
;	mov rcx,[tMP_WSPACE]
;	call apiw.mnu_setinfo

	mov rcx,[hMain]
	call apiw.mnu_draw

.setupE:
	mov rsp,rbp
	pop r13
	pop r12
	pop rsi
	pop rdi
	pop rbx
	pop rbp
	ret 0


.mp_add:
	;--- in RCX hParent
	;--- in RDX sequence
	;--- in R8 ptr to OMNI
	;--- in R9 position
	;--- ret RAX ptr to OMNI
	push rbp
	push rbx
	push rdi
	push rsi
	push r12
	push r13
	push r14
	push r15

	mov rbp,rsp
	and rsp,-16

	sub rsp,\
		sizea16.MENUITEMINFOW
		
	mov r15,r9	;--- pos
	mov rsi,rdx
	mov r12,rcx
	mov rbx,rsp
	mov rdi,r8
	mov r14,rdx

	call apiw.mnp_create
	mov r13,rax
	mov [.mii.hSubMenu],rax

.mp_addN:
	xor eax,eax
	mov [.mii.dwItemData],rdi
	lodsw
	test eax,eax
	jnz	.mp_addB
	mov rax,rdi
	jmp	.mp_addE

.mp_addB:
	inc ax
	jnz	.mp_addB1
	;--- separator
	mov [.mii.wID],eax
	mov [.mii.fType],\
		MFT_SEPARATOR
	mov eax,MIIM_ID
	xor edx,edx
	jmp	.mp_addD

.mp_addB1:
	dec eax
	stosw
	mov ecx,eax
	mov [.mii.wID],eax

	lodsw	
	stosw	;--- store icon
	mov [.mii.dwTypeData],rdi

	mov r8,rdi
	mov edx,U16
	call [lang.get_uz]
	add rdi,rax
	xor eax,eax
	stosw

	lodsw
	mov ecx,eax
	and eax,MFT_STRING\
		or MFT_BITMAP\
		or MFT_MENUBARBREAK\
		or MFT_MENUBREAK\
		or MFT_OWNERDRAW\   
		or MFT_RADIOCHECK\   
		or MFT_SEPARATOR\  
		or MFT_RIGHTORDER\   
		or MFT_RIGHTJUSTIFY
	mov [.mii.fType],eax

	and ecx,MFS_DISABLED\
		or MFS_GRAYED\
		or MFS_CHECKED\  
		or MFS_HILITE\ 
		or MFS_DEFAULT  
	mov [.mii.fState],ecx

	lodsw
	and eax,MIIM_ID \
		or MIIM_SUBMENU\
		or MIIM_STRING\
		or MIIM_FTYPE\
		or MIIM_STATE\
		or MIIM_CHECKMARKS\
		or MIIM_TYPE\
		or MIIM_DATA\
		or MIIM_BITMAP

.mp_addD:
	mov [.mii.fMask],eax
	mov r9,rbx
	mov rdx,r15
	mov rcx,r12
	call apiw.mni_ins_bypos
	inc r15

	test [.mii.fMask],\
		MIIM_SUBMENU
	jz	.mp_addN
	xor r15,r15
	mov r12,r13
	mov [r14],r13		;--- store tMP
	jmp	.mp_addN
	
.mp_addE:
	mov rsp,rbp
	pop r15
	pop r14
	pop r13
	pop r12
	pop rsi
	pop rdi
	pop rbx
	pop rbp
	ret 0


;.setupM:
;	;--- in RBX .mii
;	;--- in RCX parent hMenu
;	;--- in RSI sequel
;	;--- in RDI table
;	push rbx
;	push r12
;	push r13
;	sub rsp,\
;		sizeof.MENUITEMINFOW+100h

;	mov rbx,rsp
;	mov r12,rcx
;	xor r13,r13	
;	mov [.mii.hSubMenu],r13

;.setupM1:
;	xor eax,eax
;	lodsb
;	inc al
;	jnz	.setupM3

;.setupM2:
;	add rsp,\
;	sizeof.MENUITEMINFOW+100h
;	pop r13
;	pop r12
;	pop rbx
;	ret 0

;.setupM3:
;	dec al
;	;--- id --------------
;	mov [.mii.wID],eax
;	shl eax,4
;	mov rdx,[rax+rdi]
;	lea r9,[rax+rdi+OMNI.param]	;--- OMNI.param

;	;--- mask --------------
;	movzx ecx,dx
;	mov [.mii.fMask],ecx
;	mov r8,rcx


;	;--- type --------------
;	shr rdx,16
;	movzx ecx,dx
;	and cx,MFT_STRING\
;		or MFT_BITMAP\
;		or MFT_MENUBARBREAK\
;		or MFT_MENUBREAK\
;		or MFT_OWNERDRAW\
;		or MFT_RADIOCHECK\
;		or MFT_SEPARATOR\
;		or MFT_RIGHTORDER\
;		or MFT_RIGHTJUSTIFY
;	mov	[.mii.fType],ecx

;	mov rax,r8
;	test cx,MFT_SEPARATOR
;	jnz	.setupM5

;	add [.mii.wID],MNU_X64LAB

;	;--- subitem ------------------
;	test ax,MIIM_SUBMENU
;	jz	.setupM4

;	push rdx
;	push r9
;	call apiw.mnp_create
;	pop r9
;	pop rdx
;	mov [.mii.hSubMenu],rax
;	mov [r9],rax	;--- save hMenu

;.setupM4:	
;	;--- state --------------
;	movzx ecx,dx
;	and cx,MFS_DISABLED\
;		or MFS_CHECKED\
;		or MFS_HILITE\
;		or MFS_DEFAULT
;	mov	[.mii.fState],ecx

;	;--- convert name --------
;	push rdi
;	push rsi
;	shr rdx,16
;	movzx ecx,dx
;	lea rcx,[rdi+rcx]		;--- text
;	shr rdx,16
;	mov rsi,rcx
;	mov rdi,rcx
;	movzx eax,dh
;	push rax							;--- save len

;	lea rdx,[rbx+\
;		sizea16.MENUITEMINFOW]
;	call utf8.to16
;	mov rcx,rax

;	lea rsi,[rbx+\
;		sizea16.MENUITEMINFOW]

;	pop r8
;	mov [.mii.dwTypeData],rdi
;	;--- check if r8 > cl len of converted string
;	rep movsb
;	xor eax,eax
;	stosw

;	pop rsi
;	pop rdi

;	cmp rax,[.mii.hSubMenu]
;	jz	.setupM5
;;@break
;	mov rcx,[.mii.hSubMenu]
;	call .setupM

;.setupM5:
;	;--- is separator ------
;	;--- (in RBX mii)
;	;--- (in R13 hMnuparent)
;	;--- (in r12 position)
;	mov r9,rbx
;	mov rdx,r13
;	mov rcx,r12
;	call apiw.mni_ins_bypos
;	inc r13
;	jmp	.setupM1

	
;;	mov rcx,[hMain]
;;	call apiw.mnu_draw

	;#---------------------------------------------------ö
	;|                SET_DIR                            |
	;ö---------------------------------------------------ü

.set_dir:
	;--- in RCX DIRslot
;@break
	push rbp
	push rbx

	mov rbp,rsp
	and rsp,-16
	mov rbx,rcx

	sub rsp,\
		sizeof.MENUITEMINFOW+\
		FILE_BUFLEN
	mov rbx,rsp
	lea rax,[rsp+\
		sizeof.MENUITEMINFOW]

	mov [.mii.fMask],\
		MIIM_STRING or \
		MIIM_FTYPE or \
		MIIM_DATA

	mov [.mii.fType],\
		MFT_STRING or\
		MFT_RIGHTJUSTIFY

	mov [.mii.dwItemData],rcx
	lea rcx,[rcx+DIR.dir]
	push rax

	push 0
	push uzBlackLxPTri
	push uzSpace
	push uzCPar
	push rcx
	push uzOPar
	push rax
	push 0
	call art.catstrw

	pop [.mii.dwTypeData]
	
	mov r9,rbx
	mov edx,MP_PATH
	mov rcx,[hMnuMain]
	call apiw.mni_set_byid

	mov rcx,[hMain]
	call apiw.mnu_draw

	mov rsp,rbp
	pop rbx
	pop rbp
	ret 0


;	;#---------------------------------------------------ö
;	;|                   GET                             |
;	;ö---------------------------------------------------ü

;.geti_bypos:
;	push rbx
;	xor r8,r8
;	inc r8
;	jmp	.geti

;.geti_byid:
;	push rbx
;	xor r8,r8
;	jmp	.geti
;	
;.geti:
;	mov rbx,[mnuInfo]
;	mov rax,[GetMenuItemInfoW]
;	mov [.mii.fMask],\
;		MIIM_CHECKMARKS or \
;		MIIM_DATA or \
;		MIIM_ID or \
;		MIIM_STATE or \
;		MIIM_SUBMENU or \
;		MIIM_FTYPE or \
;		MIIM_STRING
;	;mov [rax+MENUITEMINFOW.fType],MFT_STRING	
; 	jmp	.execi

;.execi:
;	;--- in RCX hTree
;	;--- in RDX uItem
;	mov r9,rbx
;	push rbp
;	mov rbp,rsp
;	and rsp,-16
;	sub rsp,20h
;	mov [r9+MENUITEMINFOW.cbSize],\
;		sizeof.MENUITEMINFOW
;	call rax
;	mov rsp,rbp
;	pop rbp
;	pop rbx
;	ret 0


	;#---------------------------------------------------ö
	;|                   SET                             |
	;ö---------------------------------------------------ü

;.seti_bypos:


;.seti_byid:	
;	push rbx
;	xor r8,r8
;	mov rax,[SetMenuItemInfoW]
;	mov rbx,[mnuInfo]
;	jmp	.execi


	;#---------------------------------------------------ö
	;|                   INSERT                          |
	;ö---------------------------------------------------ü
;.ins_mi_bypos:
;	;--- in RCX hMenu
;	;--- in RDX pos
;	;--- in R8 id
;	;--- in R9 string
;	push rbx
;	mov rbx,[mnuInfo]
;	mov [.mii.fMask],\
;		MIIM_STRING or \
;		MIIM_ID or \
;		MIIM_FTYPE
;	
;		jmp	.ins_mp_byposA

;.ins_mp_bypos:
;	;--- in RCX hMenu
;	;--- in RDX pos
;	;--- in R8 id
;	;--- in R9 string
;	;--- in r10 hSubmenu
;	push rbx
;	mov rbx,[mnuInfo]
;	mov [.mii.fMask],\
;		MIIM_BITMAP or \
;		MIIM_ID or \
;		MIIM_SUBMENU or \
;		MIIM_FTYPE 

;	mov [.mii.hSubMenu],r10

;.ins_mp_byposA:	
;	mov [.mii.wID],r8d
;	mov [.mii.dwTypeData],r9

;	mov [.mii.fType],\
;		MFT_STRING or \
;		MFT_OWNERDRAW
;		;MFT_MENUBREAK ;or \
;		;MF_POPUP
;		;MFT_RIGHTJUSTIFY
;;	xor eax,eax
;;;	mov [r9+\
;;;		MENUITEMINFOW.fState],MFS_GRAYED
;;	mov [r9+\
;;		MENUITEMINFOW.dwItemData],rcx
;;	add rcx,DIR.size
;;	mov [r9+\
;;		MENUITEMINFOW.dwTypeData],rcx
;	jmp	.ins_bypos



;.ins_bypos:
;	xor r8,r8
;	inc r8

;.ins_insi:
;	mov rax,[InsertMenuItemW]
;	jmp	.execi


	;--- insert a menu item UNB/REC/NEW etc
;	sub rsp,\
;		sizeof.MENUITEMINFOW
;	mov rdi,rsp

;	mov [.mii.cbSize],\
;		sizeof.MENUITEMINFOW
;	mov [.mii.fMask],\
;		MIIM_TYPE or \
;		MIIM_DATA or \
;		MIIM_ID;or \
;;		MIIM_STATE

;	mov [.mii.fType],\
;		MFT_STRING
;;	mov [.mii.fState],\
;;		MFS_CHECKED
;	push [rsi+MDICREATESTRUCTW.szTitle]
;	pop [.mii.dwTypeData]
;	mov [.mii.dwItemData],rbx

;	mov rcx,[gpt.hMnuUnb]
;	call apiw.get_mnuicount
;	mov [.mii.wID],eax

;	mov r9,rdi
;	xor r8,r8
;	mov rdx,rax
;	mov rcx,[gpt.hMnuUnb]
;	sub rsp,20h
;	call [InsertMenuItemW]

;	mov rcx,[gpt.hMnuUnb]
;	call apiw.mnu_draw

;	virtual at rdi
;		.mii MENUITEMINFOW
;	end virtual

;.ins_byid:
;	xor r8,r8

;.iget:
;	push rbx
;	mov rbx,[GetMenuItemInfoW]
;	jmp	.iexec
;	
;.iset:
;	push rbx
;	mov rbx,[SetMenuItemInfoW]
;	jmp	.iexec

;.iins:
;	;--- in RAX flags
;	push rbx
;	mov rbx,[InsertMenuItemW]

;.iexec:
;	push rbp
;	push rdi
;	mov rbp,rsp

;	sub rsp,\
;		sizeof.MENUITEMINFOW
;	mov rdi,rsp
;	mov [.mii.cbSize],\
;		sizeof.MENUITEMINFOW

;	;--- in R9 param1
;	;--- in R10 param2
;	;--- in r11 param3
;	mov [.mii.fMask],eax
;	
;;	or [.mii.fMask],\
;;		MIIM_ID
;;	mov [.mii.wID],edx

;	;MIIM_STATE 0x00000001
;	;MIIM_ID 0x00000002
;	;MIIM_SUBMENU 0x00000004
;	;MIIM_DATA 0x00000020
;	;MIIM_STRING 0x00000040 or 	
;	;MIIM_BITMAP 0x00000080

;	;MIIM_CHECKMARKS 0x00000008
;	;MIIM_TYPE 0x00000010 
;	;MIIM_FTYPE 0x00000100
;	
;	and rsp,-16
;	call rbx
;	mov rsp,rbp
;	pop rdi
;	pop rbp
;	pop rbx
;	ret 0

; push MIIM_BITMAP \
;		or MIIM_STRING
; 
; mov rdx,id_mnu
;	mov rcx,[gpt.hMnuUnb]

; mov rax,MFS_ENABLED	shl 16	;--- state
; or rax,MFT_STRING \					;--- type
;   or MFT_BITMAP \
;   or MFT_RIGHTJUSTIFY
; 
;	call mnu.insert


;.insert:
;	;--- in RAX flags
;	;--- in RCX hMenu
;	;--- in RDX uItem
;	;--- in R8 0=byPosition or 1=by Id
;	;--- in R9 string
;	;--- in R10 
;;@break
;	push rbp
;	push rbx
;	mov rbp,rsp

;	sub rsp,\
;		sizeof.MENUITEMINFOW
;	and rsp,-16

;	mov rbx,rsp

;	;MFT_STRING        0x00000000L
;	;MFT_BITMAP        0x00000004L
;	;MFT_MENUBARBREAK  0x00000020L
;	;MFT_MENUBREAK     0x00000040L
;	;MFT_OWNERDRAW     0x00000100L
;	;MFT_RADIOCHECK    0x00000200L
;	;MFT_SEPARATOR     0x00000800L
;	;MFT_RIGHTORDER    0x00002000L
;	;MFT_RIGHTJUSTIFY  0x00004000L

;	;MFS_ENABLED   0x00000000L
;	;MFS_UNCHECKED 0x00000000L
;	;MFS_UNHILITE  0x00000000L
;	;MFS_DISABLED  0x00000003L
;	;MFS_GRAYED    0x00000003L
;	;MFS_CHECKED   0x00000008L
;	;MFS_HILITE    0x00000080L
;	;MFS_DEFAULT   0x00001000L

;	xor r9,r9
;	mov [rbx+MENUITEMINFOW.hSubMenu],r9

;	mov [rbx+MENUITEMINFOW.cbSize],\
;		sizeof.MENUITEMINFOW

;	movzx r9,dx
;	shl r9,2

;	mov [rbx+MENUITEMINFOW.fType],\
;		r9d
;	
;	mov r9,MIIM_TYPE	or \
;		MIIM_ID

;	test eax,eax
;	jz	.insertA
;	or r9d,MIIM_SUBMENU
;	mov [rbx+MENUITEMINFOW.hSubMenu],rcx

;.insertA:	
;	mov [rbx+MENUITEMINFOW.fMask],r9d
;	mov [rbx+MENUITEMINFOW.dwTypeData],rdi

;	rol rdx,16
;	mov [rbx+MENUITEMINFOW.wID],edx


;	sub rsp,20h
;	mov r9,rbx
;	movzx rdx,dx
;	call [InsertMenuItemW]

;	mov rsp,rbp
;	pop rbx
;	pop rbp
;	ret 0

	

;.insert:
;	;--- in RAX type 0=MI 1=MP
;	;--- in RCX hMenu
;	;--- in RDX flags
;	;--- in R8 0=byPosition or 1=by Id
;	;--- in RDI string
;;@break
;	push rbp
;	push rbx
;	mov rbp,rsp
;	sub rsp,sizeof.MENUITEMINFOW
;	and rsp,-16
;	mov rbx,rsp

;	;MFT_STRING        0x00000000L 0x00000000L ;00 s
;	;MFT_BITMAP        0x00000004L 0x00000001L ;01 b
;	;MFT_MENUBARBREAK  0x00000020L 0x00000008L ;02 
;	;MFT_MENUBREAK     0x00000040L 0x00000010L ;04 
;	;MFT_OWNERDRAW     0x00000100L 0x00000040L ;08 o
;	;MFT_RADIOCHECK    0x00000200L 0x00000080L ;10 r
;	;MFT_SEPARATOR     0x00000800L 0x00000200L ;20 -
;	;MFT_RIGHTORDER    0x00002000L 0x00000800L ;40 <
;	;MFT_RIGHTJUSTIFY  0x00004000L 0x00001000L ;80 j

;	;MFS_ENABLED   0x00000000L
;	;MFS_UNCHECKED 0x00000000L
;	;MFS_UNHILITE  0x00000000L
;	;MFS_DISABLED  0x00000003L 0x0003 0000L ;d
;	;MFS_GRAYED    0x00000003L 0x0003 0000L ;d
;	;MFS_CHECKED   0x00000008L 0x0008 0000L ;
;	;MFS_HILITE    0x00000080L 0x0080 0000L
;	;MFS_DEFAULT   0x00001000L 0x1000 0000L
;	xor r9,r9
;	mov [rbx+MENUITEMINFOW.hSubMenu],r9

;	mov [rbx+MENUITEMINFOW.cbSize],\
;		sizeof.MENUITEMINFOW

;	movzx r9,dx
;	shl r9,2

;	mov [rbx+MENUITEMINFOW.fType],\
;		r9d
;	
;	mov r9,MIIM_TYPE	or \
;		MIIM_ID

;	test eax,eax
;	jz	.insertA
;	or r9d,MIIM_SUBMENU
;	mov [rbx+MENUITEMINFOW.hSubMenu],rcx

;.insertA:	
;	mov [rbx+MENUITEMINFOW.fMask],r9d
;	mov [rbx+MENUITEMINFOW.dwTypeData],rdi

;	rol rdx,16
;	mov [rbx+MENUITEMINFOW.wID],edx


;	sub rsp,20h
;	mov r9,rbx
;	movzx rdx,dx
;	call [InsertMenuItemW]

;	mov rsp,rbp
;	pop rbx
;	pop rbp
;	ret 0

;.getcount:
;	push eax
;	GetMenuItemCount
;	ret 0

;.roxi_separate:
;	mov eax,[hRoXiMenu]
;	jmp	.separate

;.separate:
;	push 0
;	push 0
;	push 0
;	push MFT_SEPARATOR
;	push MIIM_TYPE 
;	push eax
;	call mnu.insert
;	ret 0

;.set_statebyid:
;	;IN EAX=hMenu
;	;IN ECX=item
;	;IN EDX=state
;	push esi
;	mov esi,MIIM_STATE
;	jmp .set_mii_id

;.get_stringbyid:
;	;IN EAX=hMenu
;	;IN ECX=item
;	;IN EDX=buffer
;	push esi
;	mov esi,MIIM_TYPE
;	jmp .get_mii_id

;.get_stringbypos:
;	;IN EAX=hMenu
;	;IN ECX=item
;	;IN EDX=buffer
;	push esi
;	mov esi,MIIM_TYPE
;	jmp .get_mii_pos

;.set_smenubyid:
;	;IN EAX=hMenu
;	;IN EDX=hSubmenu
;	;IN ECX=item
;	push esi
;	mov esi,MIIM_SUBMENU
;	jmp .set_mii_id
;	
;.set_databyid:
;	;IN EAX=hMenu
;	;IN ECX=item
;	;IN EDX=pdata
;	push esi
;	mov esi,MIIM_DATA
;	jmp .set_mii_id
;	
;.get_databyid:
;	;IN EAX=hMenu
;	;IN ECX=item
;	;IN EDX=not used
;	push esi
;	mov esi,MIIM_DATA
;	jmp .get_mii_id

;.set_mii_pos:
;	or esi,FLAG_SETMENUINFO
;	jmp	.get_mii_posA

;.get_mii_pos:
;	or esi,FLAG_GETMENUINFO

;.get_mii_posA:
;	push ebp
;	xor ebp,ebp
;	inc ebp
;	jmp .get_mii

;.set_mii_id:
;	or esi,FLAG_SETMENUINFO
;	jmp	.set_mii_idA

;.get_mii_id:
;	or esi,FLAG_GETMENUINFO

;.set_mii_idA:
;	push ebp
;	xor ebp,ebp

;.get_mii:
;	push ebx
;	push edi
;	xor ebx,ebx
;	add esp,-(sizeof.MENUITEMINFO)
;	mov edi,esp
;	
;	push edi
;	push ebp
;	push ecx
;	push eax

;	xor ecx,ecx
;	mov cl,sizeof.MENUITEMINFO
;	xor eax,eax
;	push ecx
;	push edi
;	rep stosb
;	mov ecx,esi
;	pop edi

;	and ecx,MIIM_STATE	or \;= 001h
;		MIIM_ID or \  				;	= 002h
;		MIIM_SUBMENU	or \  	;= 004h
;		MIIM_CHECKMARKS or \  ;= 008h
;		MIIM_TYPE	or \  			;= 010h
;		MIIM_DATA	or \  			;= 020h
;		MIIM_STRING	or \  		;= 040h
;		MIIM_BITMAP	or \  		;= 080h
;		MIIM_FTYPE						;= 100h

;	pop dword[edi+MENUITEMINFO.cbSize]
;	mov [edi+MENUITEMINFO.fMask],ecx

;	test esi,MIIM_DATA
;	jnz	.get_miiB
;	test esi,MIIM_TYPE
;	jnz	.get_miiC
;	test esi,MIIM_SUBMENU	
;	jnz	.get_miiD
;	test esi,MIIM_STATE
;	jnz	.get_miiE
;	jmp	.err_mii

;.get_miiE:
;	lea ebx,[edi+MENUITEMINFO.fState]
;	jmp	.get_miiA

;.get_miiC:
;	;RET EAX=dwTypeData
;	mov [edi+MENUITEMINFO.dwTypeData],edx
;	mov [edi+MENUITEMINFO.cch],512		;fixed size
;	lea ebx,dword[edi+MENUITEMINFO.dwTypeData]
;	jmp	.get_miiA

;.get_miiB:
;	;RET EAX=dwItemData
;	lea ebx,[edi+MENUITEMINFO.dwItemData]
;	jmp	.get_miiA

;.get_miiD:
;	lea ebx,[edi+MENUITEMINFO.hSubMenu]
;	jmp	.get_miiA
;	

;.get_miiA:
;	test esi,FLAG_GETMENUINFO
;	jnz	.miiA1

;	mov [ebx],edx
;	SetMenuItemInfo
;	jmp	.miiA2

;.miiA1:
;	GetMenuItemInfo

;.miiA2:
;	test eax,eax
;	jz .exit_mii
;	mov eax,[ebx]
;	jmp	.exit_mii

;.err_mii:
;	pop eax
;	pop ecx
;	pop ebp
;	pop edi
;	xor eax,eax

;.exit_mii:
;	sub esp,-(sizeof.MENUITEMINFO)
;	pop edi
;	pop ebx
;	pop ebp
;	pop esi
;	ret 0

;proc .insert\
;	_hmenu,\
;	_mask,\
;	_type,\
;	_state,\
;	_string,\
;	_id
;	local .mii:MENUITEMINFO

;	push ebx
;	push edi
;	push esi

;	mov eax,[_hmenu]
;	call mnu.getcount

;	lea edi,[.mii]
;	mov [edi+MENUITEMINFO.cbSize],sizeof.MENUITEMINFO
;	m2m [edi+MENUITEMINFO.wID],[_id]
;	m2m [edi+MENUITEMINFO.fType],[_type]
;	mov ecx,[_mask]
;	;mov [edi+MENUITEMINFO.dwItemData],eax
;	mov [edi+MENUITEMINFO.fMask],ecx
;	m2m [edi+MENUITEMINFO.fState],[_state]
;	m2m [edi+MENUITEMINFO.dwTypeData],[_string] ;or bitmap or sep
;	inc eax
;	push edi
;	push FALSE
;	push eax
;	push [_hmenu]
;	InsertMenuItem

;.ok_mnui:
;	pop esi
;	pop edi
;	pop ebx
;	ret
;endp

;.reset:
;	;IN EAX=hMenu
;	push ebx
;	push esi
;	push edi
;	mov esi,eax
;	call mnu.getcount
;	test eax,eax
;	jz	.resetA
;	mov ebx,eax
;	mov edi,dword [DeleteMenu]
;	dec ebx	
;.resetB:
;	push MF_BYPOSITION
;	push ebx
;	push esi
;	call edi
;	dec ebx
;	jns	.resetB

;.resetA:
;	pop edi
;	pop esi
;	pop ebx
;	ret 0