  
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



config:
	virtual at rbx
		.dir DIR
	end virtual

	virtual at rdi
		.conf CONFIG
	end virtual


.setup_dirs:
	;--- in RCX curdir
	push rbp
	push rbx
	push rdi
	mov rbx,rcx

	;--- may be X64LABD or X64LAB ----
	lea rdx,[.dir.dir]
	mov rcx,uzClass
	call apiw.set_env

	mov rdi,appDir
	mov rbp,-DEF_DIRS

	xor r8,r8
	push uzToolName
	push uzTmpName
	push uzTemplName
	push uzProjName
	push uzPlugName
	;push uzMountName
	;push uzLogName
	push uzConfName
	push uzBackName
	push r8

.setup_dirsB:
	lea rcx,[.dir.dir]
	pop rdx
	call wspace.set_dir
	mov [rdi],rax
	mov [rax+\
		DIR.type],DIR_DEFDIR

	or r8,1
	add rdi,8
	inc rbp
	jnz .setup_dirsB

	pop rdi
	pop rbx
	pop rbp
	ret 0

	;ü-----------------------------------------ö
	;|     setup_gui                           |
	;#-----------------------------------------ä
.setup_gui:
	push rbx

	mov rax,[lfMnuSize]
	movzx ecx,al
	shr rax,32
	mov ch,al
	xor edx,edx
	mov r8,uzCourierN
	call apiw.cfonti
	mov [hMnuFont],rax

	mov r10,60
	mov r9,30
	mov r8,\
		ILC_MASK or \
		ILC_COLOR16
	mov edx,16
	mov ecx,16
	call iml.create	
	mov [hBmpIml],rax

	mov rdx,BMP_X64LAB
	mov rcx,[hInst]
	call apiw.loadbmp
	mov rbx,rax

	mov r8,0FF00FFh
	mov rdx,rax
	mov rcx,[hBmpIml]
	call iml.add_masked

	mov rcx,rbx
	call apiw.delobj

	pop rbx
	ret 0


	;ü-----------------------------------------ö
	;|     setup_files                         |
	;#-----------------------------------------ä
.setup_files:
	;--- ret RCX datalen
	;--- ret RDX numitems
	sub rsp,\
		FILE_BUFLEN
	xor edx,edx
	mov rax,rsp

;	;--- check for config\menu.utf8 file 
;	push rdx
;	push uzUtf8Ext
;	push uzMenuName
;	push uzSlash
;	push uzConfName
;	push rax
;	push rdx
;	call art.catstrw

;	mov rcx,rsp
;	call [top64.parse]
;	test rax,rax
;	jz	.setup_filesE
;	mov [pTopMnu],rax

.setup_filesE:
	add rsp,\
		FILE_BUFLEN
	ret 0

.unset_files:
	ret 0

	;ü-----------------------------------------ö
	;|     setup_libs                          |
	;#-----------------------------------------ä

.setup_libs:
	push rdi
	push rsi

	mov rdi,\
		bridge.attach
	mov rsi,\
		uzPlugName

	mov rcx,\
		top64_bridge
	mov rdx,rsi
	call rdi
	test rax,rax
	jz	.setup_libsE

	mov rcx,\
		bk64_bridge
	mov rdx,rsi
	call rdi
	test rax,rax
	jz	.setup_libsE

	mov rcx,\
		dock64_bridge
	mov rdx,rsi
	call rdi	
	test rax,rax
	jz	.setup_libsE

	mov rdx,rsi
	mov rcx,\
		lang_bridge
	call rdi
	test rax,rax
	jz	.setup_libsE

	mov rcx,rsi
	call sci.setupA
	mov [hSciDll],rax

.setup_libsE:
	pop rsi
	pop rdi
	ret 0

.setup_lib:
;	xor rcx,rcx
;	mov rbx,[curDir]
;	lea rdx,[.dir.dir]
;	call art.get_appdir
;	mov [.dir.cpts],ax

;	sub rsp,\
;		FILE_BUFLEN
;	xor edx,edx
;	mov rax,rsp

;	;--- check for config\menu.utf8 file 
;	push rdx
;	push uzUtf8Ext
;	push uzMenuName
;	push uzSlash
;	push uzConfName
;	push rax
;	push rdx
;	call art.catstrw

;	mov rcx,rsp


	;ü-----------------------------------------ö
	;|     unset_libs                          |
	;#-----------------------------------------ä

.unset_libs:
	push rdi
	mov rdi,\
		bridge.detach

	mov rcx,\
		top64_bridge
	call rdi

	mov rcx,\
		dock64_bridge
	call rdi
	
	mov rcx,\
		bk64_bridge
	call rdi

	mov rcx,\
		lang_bridge
	call rdi

	call sci.discard
	pop rdi
	ret 0

	;#---------------------------------------------------ö
	;|                   OPEN CONFIG config.utf8         |
	;ö---------------------------------------------------ü
.open:
	push rbp
	push rbx
	push rsi
	push rdi
	push r12

	mov rbp,rsp
	and rsp,-16

	sub rsp,\
		FILE_BUFLEN*2

	;--- set default value ------

	mov rdi,[pConf]
;	mov eax,VERSION
;	mov [.conf.version],ax
	mov [.conf.cdate],%t
	mov [.conf.adate],%t

	mov rax,CFG_POS_RB
	mov [.conf.pos+8],rax

	mov [.conf.fshow],\
		CFG_FSHOW

	mov [.conf.flog],\
		CFG_FLOG

	mov [.conf.fsplash],\
		CFG_FSPLASH

	mov [.conf.update],\
		CFG_UPDATE

	mov [.conf.cons.bkcol],\
		CFG_CONS_BKCOL

	mov [.conf.tree.bkcol],\
		CFG_TREE_BKCOL

	mov [.conf.docs.bkcol],\
		CFG_DOCS_BKCOL

	mov [.conf.prop.bkcol],\
		CFG_PROP_BKCOL

	xor eax,eax
	mov edx,uzConfName
	mov rcx,rsp

	;--- open config/config.utf8 ----
	push rax
	push uzUtf8Ext
	push rdx
	push uzSlash
	push rdx
	push rcx
	push rax
	call art.catstrw

	mov rcx,rsp
	call [top64.parse]
	test rax,rax
	jz	.openE

	mov rbx,rax
	mov rsi,rax

.openA:
	mov eax,[rsi+\
		TITEM.hash]
	mov ecx,[rsi+\
		TITEM.attrib]
	mov rdx,rbx
	test ecx,ecx
	jz	.openB

	add rdx,rcx
	cmp eax,hash_version
;	jz	.openV
	cmp eax,hash_pos
	jz	.openP
	cmp eax,hash_wspace
	jz	.openW
	jmp	.openB

.openW:
	lea rcx,[rdx+TITEM.value]
	lea rdx,[rsp+FILE_BUFLEN]
	call utf8.to16
	mov r12,rax
	;--- CF error

;	lea rcx,[rsp+FILE_BUFLEN]
;	call art.is_file
;	jz	.openB

	mov r8,r12
	lea rcx,[rsp+FILE_BUFLEN]
	lea rdx,[.conf.wsp]
	call art.xmmcopy
	jmp	.openB

.openP:
;@break
	;--- pos ------
	mov rax,qword[rdx+\
		TITEM.lo_dword]
	pxor xmm1,xmm1
	movq xmm0,rax
	punpcklwd xmm0,xmm1
	pshufd xmm0,xmm0,\
		00011011b
	movdqa dqword \
		[.conf.pos],xmm0
	jmp	.openB

.openB:
	mov ecx,[rsi+\
		TITEM.next]
	test ecx,ecx
	jz	.openF
	mov rsi,rcx
	add rsi,rbx
	jmp	.openA

.openF:
	mov rcx,rbx
	call [top64.free]	

.openE:
	mov rsp,rbp
	pop r12
	pop rsi
	pop rdi
	pop rbx
	pop rbp
	ret 0

;	mov rdi,rsp
;	mov rbx,rax
;	mov rsi,rax

;.openV:
;	;--- version ------
;	mov eax,[rdx+TITEM.lo_dword]
;	and eax,0FFFFh
;	mov [cfg.version],ax
;	jmp	.openB

;.err_openD:
;.err_openC:
;	;--- error bits or sum
;.err_openB:
;	;--- error size/read etc
;.err_openA:
;	;--- cannot find item
;.ok_open:
;	mov rcx,rbx
;	call [top64.free]

;.exit_open:
;	xchg rax,rbx
;	mov rsp,rbp
;	pop rsi
;	pop rdi
;	pop rbx
;	pop rbp
;	ret 0
	

;	;ü------------------------------------------ö
;	;|     DISCARD                              |
;	;#------------------------------------------ä

;.discard:
;	push rbp
;	push rbx
;	push rdi
;	push rsi
;	mov rbp,rsp
;	mov rsi,art.a16free

;.discardA:
;	mov r8,.discardA1
;	jmp	.list_dir

;.discardA1:
;	pop rcx
;	test rcx,rcx
;	jz .discardB
;	call rsi
;	jmp	.discardA1

;.discardB:
;	mov rcx,[wsp.src]
;	call rsi

;;	mov rcx,bk64_bridge
;;	call bridge.detach

;	mov rcx,top64_bridge
;	call bridge.detach

;	mov rcx,dock64_bridge
;	call bridge.detach

;	mov rcx,lang_bridge
;	call bridge.detach


;;@break
;	mov rcx,[hMnuFont]
;	call apiw.delobj

;	call sci.discard
;	mov rsp,rbp
;	pop rsi
;	pop rdi
;	pop rbx
;	pop rbp
;	ret 0

;.list_dir:
;	;--- in R8 ret address
;	;--- RET RCX stack pointer
;	xor eax,eax
;	mov rdx,[dirHash]
;	push rax			;--- 0 terminator
;	mov r10,400h

;.list_dirA:
;	cmp rax,[rdx]
;	jz	.list_dirB
;	mov r11,[rdx]

;.list_dirC:
;	push r11
;	cmp  rax,[r11+DIR.hnext]
;	jz	.list_dirB
;	mov  r11,[r11+DIR.hnext]
;	jmp	.list_dirC
;	
;.list_dirB:
;	add rdx,8
;	dec r10
;	jnz .list_dirA
;	jmp r8

;;.openA:
;;	mov r8,szLab
;;	mov rdx,rbx
;;	mov rcx,rbx
;;	call [top64.locate]
;;;	test rax,rax
;;;	jz	

;;	mov edx,[rax+TITEM.child]
;;	test edx,edx
;;	add rdx,rbx
;;	mov r8,szPos
;;	mov rcx,rbx
;;	call [top64.locate]
;;;	test rax,rax
;;;	jz	


;;	;--- parse VERSION etc
;;	movzx eax,[rsi+\
;;		CFG.version]

;;	;--- parse flags etc
;;	mov al,[rsi+CFG.fshow]
;;	and al,SW_SHOWNORMAL or \
;;		SW_SHOWMINIMIZED or \
;;		SW_SHOWMAXIMIZED
;;	test al,al
;;	jnz	@f
;;	mov al,CFG.FSHOW
;;@@:
;;	mov [rdi+CFG.fshow],al

;;	;--- parse .update seconds
;;	;--- parse .session
;;	mov eax,[rsi+CFG.session]
;;	inc eax
;;	mov [rdi+CFG.session],eax

;;	;--- parse .tcreate msecs
;;	mov eax,[rsi+CFG.cdate]
;;	test eax,eax
;;	jnz	@f
;;	mov eax,%t
;;@@:	
;;	mov [rdi+CFG.cdate],eax

;;	;--- parse .tacces msecs
;;	mov eax,[rsi+CFG.adate]
;;	test eax,eax
;;	jnz	@f
;;	mov eax,%t
;;@@:	
;;	mov [rdi+CFG.adate],eax

;;	;--- parse .cons.bkcol 0AABBCCh
;;	mov eax,[rsi+\
;;		CFG.cons.bkcol]
;;	and eax,00FFFFFFh
;;	test eax,eax
;;	jnz	@f
;;	mov eax,CFG.CONS.BKCOL
;;@@:	
;;	mov [rdi+\
;;		CFG.cons.bkcol],eax

;;;	;--- parse .tree.bkcol 0D9FFFFh
;;	mov eax,[rsi+\
;;		CFG.tree.bkcol]
;;	and eax,00FFFFFFh
;;	test eax,eax
;;	jnz	@f
;;	mov eax,CFG.TREE.BKCOL
;;@@:	
;;	mov [rdi+\
;;		CFG.tree.bkcol],eax

;;	;--- parse pos 
;;	mov rcx,000'01FF'0000'01FFh
;;	mov rax,qword[rsi+CFG.pos]
;;	and rax,rcx
;;	mov rdx,qword[rsi+CFG.pos+8]
;;	mov rcx,0000'07FF'0000'07FFh
;;	and rdx,rcx
;;	test rdx,rdx
;;	jnz	@f
;;	mov rdx,(CFG.POS.BOTTOM shl 32)\
;;		or CFG.POS.RIGHT
;;@@:
;;	mov qword[rdi+CFG.pos],rax
;;	mov qword[rdi+CFG.pos+8],rdx

;;	mov rcx,rax
;;	call [top64.getnum]
;;	jc	.openB

;;	pxor xmm1,xmm1
;;	movq xmm0,rax
;;	punpcklwd xmm0,xmm1
;;	pshufd xmm0,xmm0,00011011b
;;	movdqu dqword [lab.pos.param],xmm0

;;	mov rcx,LAB.size
;;	call art.a16malloc
;;	test eax,eax
;;	jz	.err_openB
;;	mov rdi,rax
;;	call .def_fill
;;	
;;	mov rcx,rsi
;;	call art.fcreate_rw
;;	test eax,eax
;;	jz	.err_openD

;;	mov r8,LAB.size
;;	mov rdx,rdi
;;	mov rcx,rbx
;;	call art.fwrite
;;	mov [gpt.pConfig],rdi
;;	jmp	.err_openB
;;	
;;.openB:
;;	;--- cannot create config.bin
;;	jmp	.err_openB
;;.openA:



;;	;--- in env X64LABD/R+0
;;;	sub rsp,32
;;;	mov rax,qword[uzClass]
;;;	mov [rsp],rax
;;;	mov rax,qword[uzClass+8]
;;;	mov [rsp+8],rax
;;;	mov rdx,rsi
;;;	mov rcx,rsp
;;;	call art.setenv
;;;	add rsp,32

;;;	xor eax,eax
;;;	inc eax
;;.setenv:
;;	;--- in RCX key
;;	;--- in RDX value
;;	push rsi
;;	call utf16.cpts
;;	mov rsi,rcx
;;	add rax,rax
;;	
;;	pop rsi
;;	ret 0

;;.err_setupB:
;;	;--- no bk64 plugin
;;	;--- in RSP buffer of FILE_BUFLEN

;;	;1)---  is tmp\dreck.exe ?
;;	mov rsi,rsp
;;	mov r9,uzExeExt
;;	mov r8,uzDreck
;;	mov rdx,TMPDIR
;;	call .cat_dir

;;	mov rcx,rsi
;;	call shared.is_file
;;	jz	.err_setupB1

;;	call win.ask_tar
;;	cmp eax,IDYES
;;	jnz	.err_setupB2

;;	;2)--- SPAWN dreck.exe /TAR

;;.err_setupB3:

;;.err_setupB1:
;;	;--- err NO DRECK.exe -> exit
;;	call win.err_notar

;;.err_setupB2:
;;	xor rax,rax
;;	jmp .err_setup

;;;	mov rax,[pCmdline]
;;;	test rax,rax
;;;	jz	.err_setupB1
;;;	mov rdx,rsp
;;;	mov rcx,rax
;;;	push 0
;;;	call shared.cmdargs
;;;	pop rdx
;;;	test rax,rax
;;;	jz	.err_setupB1
;;;	test rdx,rdx
;;;	jz	.err_setupB2
;;;	mov rcx,uzUpdMark
;;;	dec rdx
;;;	jz	.err_setupB2
;;;	add rax,8
;;;	cmp [rax],rcx
;;;	jnz .err_setupB3


;	;#---------------------------------------------------ö
;	;|                   WRITE CONFIG x64lab             |
;	;ö---------------------------------------------------ü

;.write:
;	push rbp
;	push rbx
;	push rdi
;	push rsi
;	mov rbp,rsp

;	xor rax,rax
;	sub rsp,1000h+FILE_BUFLEN
;	mov rdi,rsp
;	lea rsi,[rsp+1000h]
;	mov [rdi],rax				;--- assure page access

;	mov r9,uzUtf8Ext
;	mov r8,uzConfName
;	mov rdx,CONFDIR
;;call .cat_dir

;;@break
;;	mov rcx,rsi
;;	call shared.fcreate_rw
;;	test rax,rax
;;	jle	.err_write
;;	mov rbx,rax
;;	

;;	mov rcx,rbx
;;	call shared.fclose

;.err_write:
;	;--- cannot create config.utf8

;.writeA:
;	mov rsp,rbp
;	pop rsi
;	pop rdi
;	pop rbx
;	pop rbp
;	ret 0



;	;ü------------------------------------------ö
;	;|     CREATEFONT                           |
;	;#------------------------------------------ä
;.createfont:
;	;--- in RCX bold-wi-hi
;	;--- in RDX st-un-it-ch
;	;--- in R8	font name
;	sub rsp,sizea16.LOGFONTW
;	movzx eax,cl
;	mov [rsp+LOGFONTW.lfHeight],eax
;	movzx eax,ch
;	mov [rsp+LOGFONTW.lfWidth],eax
;	xor eax,eax
;	shr rcx,16
;	mov [rsp+LOGFONTW.lfEscapement],eax
;	mov [rsp+LOGFONTW.lfOrientation],eax
;	mov [rsp+LOGFONTW.lfWeight],ecx

;	;-------------------------------------
;	mov [rsp+LOGFONTW.lfCharSet],dl
;	mov [rsp+LOGFONTW.lfItalic],dh
;	shr edx,16
;	mov [rsp+LOGFONTW.lfUnderline],dl
;	mov [rsp+LOGFONTW.lfStrikeOut],dh
;	;-------------------------------------
;	mov [rsp+LOGFONTW.lfOutPrecision],\
;		OUT_DEFAULT_PRECIS	

;	mov [rsp+LOGFONTW.lfClipPrecision],\
;		CLIP_DEFAULT_PRECIS	

;	mov [rsp+LOGFONTW.lfQuality],\
;		DEFAULT_QUALITY

;	mov [rsp+LOGFONTW.lfPitchAndFamily],\
;		DEFAULT_PITCH or FF_DONTCARE	

;	mov r9,rdi
;	xchg r8,rsi
;	lea rdi,[rsp+LOGFONTW.lfFaceName]
;@@:
;	lodsw
;	stosw
;	test ax,ax
;	jnz	@b
;	xchg r9,rdi
;	xchg r8,rsi
;	mov rcx,rsp
;	call apiw.cfonti
;	add rsp,sizea16.LOGFONTW
;	ret 0



