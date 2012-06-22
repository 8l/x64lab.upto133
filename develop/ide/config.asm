
  ;#-------------------------------------------------ü
  ;|          x64lab  MPL 2.0 License                |
  ;|   Copyright (c) 2009-2012, Marc Rainer Kranz.   |
  ;|            All rights reserved.                 |
  ;|-------------------------------------------------|
  ;|      Dienstag] - 19.Juni.2012 - 10:51:19        |


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
	mov r8,ILC_MASK or ILC_COLOR16
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
	lea rcx,[rsp+FILE_BUFLEN]
	call art.is_file
	jz	.openB

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


;	;#---------------------------------------------------ö
;	;|                   WRITE CONFIG FASMLAB            |
;	;ö---------------------------------------------------ü
;proc .write
;	local .buffer512[512]:BYTE
;	local .buffer4096[4096]:BYTE

;	push ebx
;	push edi
;	push esi

;	lea eax,[.buffer512]
;	call .cat_config
;	call shared.open_AfileRW
;	test eax,eax
;	jz	.err_write
;	mov ebx,eax
;	lea edi,[.buffer4096]
;	
;	;1) --- version 
;	@do_indent 1
;	@do_name lab,lab.version
;	@do_num [lab.version.param]
;	@do_endl

;	;2) --- session
;	@do_indent 1
;	@do_name lab,lab.session
;	@do_num [lab.session.param]
;	@do_endl

;	;3) --- create
;	@do_indent 1
;	@do_name lab,lab.create

;;@break
;	mov eax,[lab.create.param]
;	test eax,eax
;	jnz	@f
;	mov eax,[lab.access.param]
;@@:
;	@do_quote eax
;	@do_endl

;	;4) --- access
;	@do_indent 1
;	@do_name lab,lab.access
;	@do_quote [lab.access.param]
;	@do_endl
;	@do_endl

;	;3) --- descript
;	@do_indent 1
;	@do_name lab,lab.descript
;	@do_quote [lab.descript.param]
;	@do_endl

;	;4) --- copyright
;	@do_indent 1
;	@do_name lab,lab.copyright
;	@do_quote [lab.copyright.param]
;	@do_endl
;	
;	;5) --- note
;	@do_indent 1
;	@do_name lab,lab.note
;	@do_quote [lab.note.param]
;	@do_endl
;	@do_endl

;	;6) --- commenting
;	@do_indent 1
;	@do_name lab,lab.commenting
;	@do_num [lab.commenting.param]
;	@do_comment szNotYet
;	@do_endl

;	;10) --- showsplash
;	@do_indent 1
;	@do_name lab,lab.showsplash
;	@do_num [lab.showsplash.param]
;	@do_comment szNotYet
;	@do_endl

;	;10) --- reop_lastproj
;	@do_indent 1
;	@do_name lab,lab.reop_lastproj
;	@do_num [lab.reop_lastproj.param]
;	@do_endl

;	;7) --- dir
;	@do_indent 1
;	@do_name lab,lab.dir
;	mov edx,[pDirTable]
;	@do_quote [edx+DEF_DIRS.pLabDir.pdir]
;	@do_endl

;	;8) --- host
;	@do_indent 1
;	@do_name lab,lab.host
;	@do_quote [lab.host.param]
;	@do_comment szNotYet
;	@do_endl

;	;9) --- port
;	@do_indent 1
;	@do_name lab,lab.port
;	@do_num [lab.port.param]
;	@do_comment szNotYet
;	@do_endl
;;@break
;	mov eax,[lab.lastproj.param]
;	test eax,eax
;	jz .skip_writeA

;	mov edx,[eax]		;temporary patch: to review no security!!!
;	test edx,edx
;	jz	.skip_writeA

;	;8) --- lastproj
;	@do_indent 1
;	@do_name lab,lab.lastproj
;	@do_quote [lab.lastproj.param]
;	@do_endl

;.skip_writeA:
;	@do_endl

;	;6) --- cons.bkcol
;	@do_indent 1
;	@do_name lab,lab.cons.bkcol
;	@do_num [lab.cons.bkcol.param]
;	@do_endl

;	;6) --- tree.bkcol
;	@do_indent 1
;	@do_name lab,lab.tree.bkcol
;	call tree.getbkcolor
;	@do_num eax
;	@do_endl

;	;6) --- splitH1
;	@do_indent 1
;	@do_name lab,lab.splith1
;	push [hSplitH1]
;	call [split.getpos]
;	@do_num eax
;	@do_endl

;	;6) --- splitV1
;	@do_indent 1
;	@do_name lab,lab.splitv1
;	push [hSplitV1]
;	call [split.getpos]
;	@do_num eax
;	@do_endl

;	;6) --- splitV2
;	@do_indent 1
;	@do_name lab,lab.splitv2
;	push [hSplitV2]
;	call [split.getpos]
;	@do_num eax
;	@do_endl

;;@break
;	@do_indent 1
;	@do_name lab,lab.position
;	movzx eax,[def_show]
;	@do_num eax
;	@do_comma
;;@break
;	@do_num [def_pos.left]
;	@do_comma

;	@do_num [def_pos.top]
;	@do_comma

;	@do_num [def_pos.right]
;	@do_comma

;	@do_num [def_pos.bottom]
;	@do_endl

;	lea eax,[.buffer4096]
;	@do_write eax

;	;6) --- lab.devtool
;	lea edi,[.buffer4096]
;	@do_endl
;	@do_indent 1
;	@do_name lab,lab.devtool
;	@do_openobj
;	@do_endl

;		mov edx,[lab.devtool.param]
;		test edx,edx
;		jz	.skip_writeB
;		
;	.next_devtool:
;		push [edx+DEVTOOL.pnexttool]
;		push edx

;		push eax
;		push edx
;		push ecx
;		mov eax,[edx+DEVTOOL.hIcon]
;		test eax,eax
;		jz	@f
;		push eax
;		DestroyIcon
;	@@:
;		pop ecx
;		pop edx
;		pop eax

;		push edx
;		push edx
;		@do_indent 2
;		@do_anon
;		pop edx
;		@do_num [edx+DEVTOOL.flags]
;		mov al,","
;		stosb
;		pop eax
;		add eax,sizeof.DEVTOOL
;		@do_quote eax
;		@do_endl
;		lea eax,[.buffer4096]
;		@do_write eax

;		pop eax
;		call shared.free
;		lea edi,[.buffer4096]
;		pop edx
;		test edx,edx
;		jnz	.next_devtool

;.skip_writeB:
;	@do_indent 1
;	@do_closeobj
;	lea eax,[.buffer4096]
;	@do_write eax

;	
;;	logo,0,0,\
;;	logaction,0,0,\
;;	logfile,0,0,\
;;	reop_files,0,0,\
;;	reop_multi,0,0,\
;;	exit_autosave,0,0,\
;;	zip_onstart,0,0,\
;;	back_onstart,0,0,\
;;	maxim,0,1,\
;;	rect,0,0,\
;;	numtools,0,MAX_NUMTOOLS

;	call shared.fend
;	mov eax,ebx
;	call shared.fclose
;	clc
;	jmp	.ok_write

;.err_write:
;	stc
;.ok_write:
;	pop esi
;	pop edi
;	pop ebx
;	ret
;endp

;proc .read
;	local .buffer512[512]:BYTE

;	push ebx
;	push edi
;	push esi

;	mov eax,128
;	call shared.malloc
;	mov [lab.access.param],eax	;set access datetime
;	push eax
;	call shared.get_datetime

;	lea eax,[.buffer512]
;	call .cat_config
;	lea eax,[.buffer512]
;	push eax
;	call [top.parse]	
;	mov [pConfig],eax
;	test eax,eax
;	jz	.err_open
;	mov ebx,eax

;	mov eax,[pConfig]
;	@cfg_locate lab.reop_lastproj
;	test eax,eax
;	jz	.read_lastproj
;	call .get_nextnum
;	mov [lab.reop_lastproj.param],eax
;	test eax,eax
;	jz .read_create

;.read_lastproj:
;	;3) --- locate lastproj ----------------------			
;;@break
;	xor eax,eax
;	mov [lab.lastproj.param],eax ;temporary patch: to review no security!!!see 368
;	mov eax,[pConfig]
;	@cfg_getnode lab.lastproj
;	test eax,eax
;	jz	.read_create
;	call .get_nextansi
;	test ecx,ecx
;	jz	.read_create
;	push eax						;--save pointer to filename only
;	mov edx,[pDirTable]
;	mov ebx,ecx					;--len of filename only --------

;	mov esi,[edx+DEF_DIRS.pProjDir.pdir]
;	lea edi,[.buffer512]
;	movzx edx,[edx+DEF_DIRS.pProjDir.nsize]
;	inc ebx			;zero char
;	push ebx		;save len
;	inc ebx			;slash
;	add ebx,edx

;	push 0
;	push eax
;	push szSlash		
;	push esi
;	push edi
;	push 0
;	call shared.catstr	
;		
;	mov eax,edi
;	call shared.is_file
;	pop ebx
;	pop esi									;--restore pointer to only filename
;	jc	.read_create

;	mov eax,ebx
;	call shared.malloc

;	dec ebx
;	mov [lab.lastproj.param],eax
;	mov ecx,ebx
;	mov edi,eax
;	rep movsb

;.read_create:
;	mov eax,[pConfig]
;	@cfg_getnode lab.create
;	test eax,eax
;	jz	.read_session

;	push eax
;	mov eax,128
;	call shared.malloc
;	mov [lab.create.param],eax
;	push eax
;	call shared.get_datetime
;	pop eax
;	call .get_nextansi
;	mov edi,[lab.create.param]
;	mov esi,eax
;	rep movsb

;.read_session:
;	mov eax,[pConfig]
;	@cfg_getnode lab.session
;	test eax,eax
;	jz	.read_splith1
;	call .get_nextnum
;	inc eax
;	mov [lab.session.param],eax

;.read_splith1:
;	mov eax,[pConfig]
;	@cfg_getnode lab.splith1
;	test eax,eax
;	jz	.read_splitv1
;	call .get_nextnum
;	mov [lab.splith1.param],eax

;.read_splitv1:
;	mov eax,[pConfig]
;	@cfg_getnode lab.splitv1
;	test eax,eax
;	jz	.read_splitv2
;	call .get_nextnum
;	mov [lab.splitv1.param],eax

;.read_splitv2:
;	mov eax,[pConfig]
;	@cfg_getnode lab.splitv2
;	test eax,eax
;	jz	.read_tree_bkcol
;	call .get_nextnum
;	mov [lab.splitv2.param],eax

;.read_tree_bkcol:
;	mov eax,[pConfig]
;	@cfg_getnode lab.tree.bkcol
;	test eax,eax
;	jz	.read_cons_bkcol
;	call .get_nextnum
;	mov [lab.tree.bkcol.param],eax

;.read_cons_bkcol:
;	mov eax,[pConfig]
;	@cfg_getnode lab.cons.bkcol
;	test eax,eax
;	jz	.read_position
;	call .get_nextnum
;	mov [lab.cons.bkcol.param],eax

;.read_position:
;	mov eax,[pConfig]
;	@cfg_locate lab.position
;	test eax,eax
;	jz	.read_devtool
;	push ebx
;	mov ebx,eax
;	call .get_nextnum
;	jc	.exit_rp

;	;1) --- acquire show status ----------------
;	cmp [edx+TOBJECT.type],VAL_NUMBER
;	jnz	.exit_rp
;	cmp [edx+TOBJECT.parent],ebx
;	jnz	.exit_rp
;	and al,SW_SHOWMAXIMIZED	;3=1+2
;	xor ecx,ecx
;	mov [def_show],al

;;@break
;	;2) --- acquire left pos ----------------
;	add edx,sizeof.TOBJECT
;	cmp [edx+TOBJECT.type],VAL_NUMBER
;	jnz	.exit_rp
;	cmp [edx+TOBJECT.parent],ebx
;	jnz	.exit_rp
;	mov eax,[edx+TOBJECT.dword1]
;	and eax,0FFFh
;	mov [def_pos.left],eax

;	;2) --- acquire top pos ----------------
;	add edx,sizeof.TOBJECT
;	cmp [edx+TOBJECT.type],VAL_NUMBER
;	jnz	.exit_rp
;	cmp [edx+TOBJECT.parent],ebx
;	jnz	.exit_rp
;	mov eax,[edx+TOBJECT.dword1]
;	and eax,0FFFh
;	mov [def_pos.top],eax

;	;3) --- acquire right pos ----------------
;	add edx,sizeof.TOBJECT
;	cmp [edx+TOBJECT.type],VAL_NUMBER
;	jnz	.exit_rp
;	cmp [edx+TOBJECT.parent],ebx
;	jnz	.exit_rp
;	mov eax,[edx+TOBJECT.dword1]
;	and eax,0FFFh
;	sub eax,[def_pos.left]
;	mov [def_pos.right],eax

;	;4) --- acquire bottom pos ----------------
;	add edx,sizeof.TOBJECT
;	cmp [edx+TOBJECT.type],VAL_NUMBER
;	jnz	.exit_rp
;	cmp [edx+TOBJECT.parent],ebx
;	jnz	.exit_rp
;	mov eax,[edx+TOBJECT.dword1]
;	and eax,0FFFh
;	sub eax,[def_pos.top]
;	mov [def_pos.bottom],eax

;.exit_rp:
;	pop ebx

;.read_devtool:
;	mov eax,[pConfig]
;	@cfg_locate lab.devtool
;	test eax,eax
;	jz	.ok_readA
;	call .load_devtool
;	
;.ok_readA:		
;	push pConfig
;	call shared.vfree
;	clc
;	jmp	.ok_read
;	
;.err_open:
;	stc
;.ok_read:
;	pop esi
;	pop edi
;	pop ebx
;	ret
;endp



;proc .load_devtool
;	;IN EAX=parent lab.devtool
;	local .flags:DWORD
;	local .filename:DWORD
;	local .pslot:DWORD
;	local .buffer512[512]:BYTE

;	push ebx
;	push edi
;	push esi
;	mov ebx,eax		;parent lab.devtool

;.next_ldt:
;	push TOP_ANON
;	push eax
;	call [top.next]
;	test eax,eax
;	jz	.exit_ldt

;	cmp [eax+TOBJECT.parent],ebx
;	jnz	.exit_ldt

;	mov edx,eax
;	push edx

;	;1) --- take flags of devtool -----------
;	add eax,sizeof.TOBJECT
;	cmp [eax+TOBJECT.type],VAL_NUMBER
;	jnz	.err_ldt
;	cmp [eax+TOBJECT.parent],edx
;	jnz	.err_ldt
;	m2m [.flags],[eax+TOBJECT.dword1]

;	;2) --- take path+filenames of devtool -----
;	add eax,sizeof.TOBJECT
;	cmp [eax+TOBJECT.type],VAL_ANSI
;	jnz	.err_ldt
;	cmp [eax+TOBJECT.parent],edx
;	jnz	.err_ldt
;	
;	push eax
;	call [top.getvalue]
;	test ecx,ecx
;	jz	.err_ldt

;	; lab.devtool  (
;	;	. 0,'%SystemRoot%\system32\mspaint.exe'
;	;)
;	push ecx
;	push eax

;	add ecx,sizeof.DEVTOOL
;	mov eax,ecx
;	call shared.malloc
;	mov edi,eax
;	mov edx,eax

;	pop esi
;	pop ecx
;	mov [edx+DEVTOOL.lenfile],cx
;	add edi,sizeof.DEVTOOL
;	rep movsb
;	mov edi,edx
;	m2m [edi+DEVTOOL.flags],[.flags]

;	mov eax,[lab.devtool.param]
;	test eax,eax
;	jz	.set_mainldt

;.set_nextldt:
;	mov edx,[eax+DEVTOOL.pnexttool]
;	test edx,edx
;	jz	.set_thisldt
;	mov eax,edx
;	jmp	.set_nextldt

;.set_thisldt:
;	mov [eax+DEVTOOL.pnexttool],edi
;	jmp	.ok_ldt

;.set_mainldt:
;	mov [lab.devtool.param],edi

;.ok_ldt:	
;.err_ldt:
;	pop eax
;	jmp	.next_ldt

;.exit_ldt:
;	pop ebx
;	pop edi
;	pop esi
;	ret
;endp

;	;#---------------------------------------------------ö
;	;|                   SAVE PROJECT                    |
;	;ö---------------------------------------------------ü

;.save_project:
;	;IN ESP+4 _how save
;	mov edx,[esp+4]
;	
;	push ebp
;	push ebx
;	push edi
;	push esi
;	sub esp,1024
;	mov edi,esp
;	mov ebp,esp	

;	xor eax,eax
;	push eax
;	push edx
;	push eax
;	call tree.list

;	mov edx,[pDirTable]
;	mov eax,[edx+DEF_DIRS.pProjDir.pdir]

;	mov edx,[lab.lastproj.param]
;	test edx,edx
;	jnz	.spA
;	
;	push eax
;	push edi
;	push szProjFilt
;	push szAskSaveAll
;	push [wcx.hInstance]
;	push [hMain]
;	call [savefile]

;	test eax,eax
;	jz	.err_sp

;	add eax,ecx
;	mov esi,eax
;	call shared.lenz
;	inc eax
;	mov ebx,eax
;	call shared.malloc
;	mov [lab.lastproj.param],eax

;	push edi
;	mov edi,eax
;	mov ecx,ebx
;	rep movsb
;	pop edi

;	call tree.getroot
;	mov edx,[lab.lastproj.param]
;	call tree.setname

;	mov edx,[pDirTable]
;	mov eax,[edx+DEF_DIRS.pProjDir.pdir]
;	mov edx,[lab.lastproj.param]
;	
;.spA:
;	;--------------------------ok check this
;	push 0
;	push edx
;	push szSlash
;	push eax
;	push edi
;	push 0
;	call shared.catstr

;	mov eax,edi
;	call shared.open_AfileRW
;	test eax,eax
;	jle	.err_sp
;	mov ebx,eax

;	;1) ------------ save known dirs -------------------
;	@do_name proj,proj.kdirs			
;	@do_openobj
;	@do_endl
;	@do_write ebp
;	
;	mov esi,[pDirTable]
;	add esi,sizeof.DEF_DIRS

;.sp_kdirs:
;	xor edx,edx
;	cmp [esi+DIR_SLOT.hash],edx
;	jz	.ok_sp_kdirs
;	cmp [esi+DIR_SLOT.nused],dx
;	jz	.sp_kdirsA

;	push esi
;	@do_indent 1
;	@do_anon
;	@do_quote [esi+DIR_SLOT.pdir]
;	@do_endl
;	@do_write ebp
;	pop esi				

;.sp_kdirsA:	
;	add esi,sizeof.DIR_SLOT
;	jmp	.sp_kdirs

;.ok_sp_kdirs:
;	@do_closeobj
;	@do_endl
;	@do_write ebp

;	;1) ------------ save files -------------------
;		
;	@do_name proj,proj.files
;	@do_openobj
;	@do_endl
;	@do_write ebp

;	sub esp,512
;	mov eax,esp
;	push eax		;--- write buffer
;	push ebx		;--- filehandle
;	push 0			;--- level
;	push 0			;--- startitem
;	call tree.write_item
;	add esp,512

;	@do_closeobj
;	@do_endl
;	@do_write ebp

;	call shared.fend
;	mov eax,ebx
;	call shared.fclose

;.err_sp:
;	add esp,1024
;	pop esi
;	pop edi
;	pop ebx
;	pop ebp
;	ret 4

;	;#---------------------------------------------------ö
;	;|                   LOAD PROJECT                    |
;	;ö---------------------------------------------------ü

;.load_project:
;	push ebx
;	push edi
;	push esi

;	mov edx,[pDirTable]
;	mov eax,[edx+DEF_DIRS.pProjDir.pdir]

;	push eax
;	push szProjFilt
;	push szLoadProj

;	push 0
;	push [hMain]
;	call [openfile]
;	test eax,eax		;path+file
;	jz .exit_loadp
;	mov [pOpenBuffer],eax 

;	mov ebx,ecx			;offset filename
;	mov esi,edx			;hash of loaded path
;				
;	push 0
;	push IDM_PROJECT_CLOSE
;	push WM_COMMAND
;	push [hMain]
;	SendMessage
;	test eax,eax
;	jz	.exit_loadp

;	;1) --- if loaded path not pProj path
;;@break
;	mov edx,[pDirTable]
;	cmp esi,[edx+DEF_DIRS.pProjDir.hash]
;	jz	.lpA

;	;2) --- check if file in projdir exist
;	sub esp,512
;	mov edi,esp
;	mov esi,[edx+DEF_DIRS.pProjDir.pdir]
;	mov eax,[pOpenBuffer]
;	add eax,ebx

;	push 0
;	push eax
;	push szSlash
;	push esi
;	push edi
;	push 0
;	call shared.catstr

;	mov eax,edi
;	call shared.is_file
;	jc	.lpB

;	;5) --- create a copy of the  name in project dir
;	call shared.time2name
;	
;	mov edx,[pOpenBuffer]
;	add edx,ebx

;	push 0
;	push szFlpExt
;	push eax
;	push szScore
;	push edi
;	call shared.catstr

;.lpB:
;	;5) --- create and fix filename as existing in projdir
;	;----- on r-cd cannot copy ! -------------------
;	push FALSE
;	push edi
;	push [pOpenBuffer]
;	CopyFile
;	
;	mov esi,edi
;	mov edi,[pOpenBuffer]
;	call shared.copyz

;	mov edx,[pDirTable]
;	movzx ebx,[edx+DEF_DIRS.pProjDir.nsize]
;	inc ebx		;offset of the file after 1=slash
;	
;	mov eax,edi
;	add eax,ebx
;	mov edi,esp

;	push 0
;	push eax
;	push szImpFile
;	push edi
;	push 0
;	call shared.catstr
;	
;	push MB_OK or MB_ICONINFORMATION	
;	push szTitle
;	push edi
;	push 0
;	MessageBox

;	add esp,512

;.lpA:		
;	mov eax,[lab.lastproj.param]
;	mov esi,[pOpenBuffer]
;	test eax,eax
;	jz	@f
;	call shared.free
;@@:
;	push esi
;	add esi,ebx
;	mov ecx,esi
;@@:
;	lodsb
;	test al,al
;	jnz	@b
;	xchg esi,ecx
;	sub ecx,esi			
;	pop esi

;	mov eax,ecx
;	push eax
;	call shared.malloc
;	mov [lab.lastproj.param],eax
;	mov edi,eax
;	pop ecx

;	push edi
;	push esi
;	push esi			
;	add esi,ebx
;	rep movsb
;	pop esi
;	mov byte[esi+ebx-1],0
;	call config.read_project

;	xor ecx,ecx
;	mov [lab.lastproj.info],ecx

;	test eax,eax
;	jnz	.exit_loadp
;	mov eax,[lab.lastproj.param]
;	test eax,eax
;	jz	.exit_loadp
;	mov [lab.lastproj.param],ecx
;	call shared.free
;	xor eax,eax

;.exit_loadp:
;	pop esi
;	pop edi
;	pop ebx
;	ret 0


;	;ü------------------------------------------ö
;	;|     LOAD_FILES                           |
;	;#------------------------------------------ä
;	
;proc .load_files\
;	_ilast,\
;	_iparent,\
;	_flags

;	local .hashpath:DWORD
;	;RET EAX=ilast

;	push ebx
;	push edi
;	push esi

;	mov edi,[_ilast]
;	mov edx,[_flags]
;	test edx,edx
;	jnz	.l_fB

;	xor eax,eax
;	push eax
;	push szFileFilt
;	push szLoadFile
;	push OFN_ALLOWMULTISELECT 
;	push [hMain]
;	call [openfile]
;	test eax,eax		;path+file
;	jz .exit_loadf
;	mov [lab.lastproj.info],PROJ_MODIFIED	;--- PROJ_MODIFIED=1
;	mov [pOpenBuffer],eax 

;	;EAX=path+file/s
;	;ECX=offset filename

;.l_fB:
;	mov esi,eax
;	mov ebx,ecx

;	call shared.is_file
;	push eax

;	mov ecx,ebx
;	dec ecx
;	xor eax,eax
;	mov byte[esi+ecx],al

;	push ecx
;	push esi
;	call .is_hashdir
;	mov [.hashpath],eax
;	jc	.l_fA
;	
;	push FALSE
;	push 0
;	push 0
;	push esi
;	call .set_dir				
;	jc	.err_lf
;	m2m [.hashpath],[edx+DIR_SLOT.hash]	
;	
;.l_fA:
;	pop ecx
;	mov edx,[_flags]
;	test edx,edx
;	jnz	.single_file
;	test cl,cl
;	jz	.multi_file
;				
;.single_file:
;	mov edx,esi
;	add edx,ebx
;	movzx ecx,cl	
;	inc ecx				;FALGS_SECTION = 2
;	shl ecx,1			;FLAGS_FILE = 4
;	push ecx
;	push [_iparent]
;	push edi
;	push edx
;	push [.hashpath]
;	call .load_singlef
;	mov edi,eax
;	jmp	.exit_loadf
;	
;.multi_file:
;	add esi,ebx
;.multi_fileA:
;	lodsb
;	test al,al
;	jz	.exit_loadf
;	dec esi
;	push FLAGS_FILE
;	push [_iparent]
;	push edi
;	push esi
;	push [.hashpath]
;	call .load_singlef
;	mov edi,eax
;@@:
;	lodsb
;	test al,al
;	jz .multi_fileA
;	jmp	@b
;	
;.err_lf:		
;.exit_loadf:
;	xchg eax,edi
;	pop esi
;	pop edi
;	pop ebx
;	ret
;endp

;	;ü------------------------------------------ö
;	;|     LOAD_SINGLEFILE                      |
;	;#------------------------------------------ä

;proc .load_singlef\
;	_hashpath,\
;	_name,\
;	_ilast,\
;	_iparent,\
;	_type

;	push [_type]
;	push [_hashpath]
;	push 0
;	push [_name]
;	call .build_frame
;	jc	.err_sf
;	
;	;---- add item for project (root)
;	push [_type]
;	push [_iparent]
;	push [_ilast]
;	push eax
;	push [_name]
;	call tree.additem
;	clc
;	jmp	.exit_sf
;.err_sf:
;	stc
;.exit_sf:
;	ret
;endp

