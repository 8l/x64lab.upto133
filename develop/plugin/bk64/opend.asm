opend:
.open:
	ret 0


;	buf512	du 512 dup (0)
;	align 16
;		
;	pCookie	dq 0
;					dq 0

;	struct COMOBJ
;		pVtable	dq 0
;		count		dd 0
;		flags		db 0
;						db 0
;						dw 0
;	ends
;	;@comsta pFod,iFileOpenDialog

;	dwOptions	dq 0
;	pPath			dq 0
;	numItems	dq 0
;	pShia			dq 0

;	pName du "All files",0
;	pSpec du "*.*",0

;	align 8
;	virtual at 0
;	struc iMyFde{
;		.iFDE iFileDialogEvents
;		.pShia dq 0
;	}	iMyFde iMyFde
;	end virtual


;	myFde iMyFde
;	pMyFdeVtable	dq myFde

;	fspec COMDLG_FILTERSPEC pName,pSpec 

;section '.code' code readable executable
;	include "%x64devdir%\shared\art.asm"
;	include "%x64devdir%\shared\api.asm"
;	include "%x64devdir%\shared\bridge.asm"
;	include "%x64devdir%\shared\unicode.asm"

;start:
;	push rbp
;	push rdi
;	mov rbp,rsp
;	and rsp,-16

;	sub rsp,16
;	mov rdi,rsp

;	@comptr .pFod,rdi,\
;	iFileOpenDialog

;	xor rcx,rcx
;	sub rsp,20h
;	call [CoInitialize]
;	add rsp,20h

;	lea rcx,[.pFod]
;	push 0
;	push rcx ;---	push rdi/push .pFod_ptr
;	mov r9,iid_FileOD
;	mov r8,1
;	mov rdx,0
;	mov rcx,clsid_FileOD
;	sub rsp,20h
;	call [CoCreateInstance]
;	test eax,eax
;	jnz	.exit

;	call FDE_handler.create

;	;--- it will "Advise" from
;	;--- FileOpenDialog to FileDialog
;	mov r8,pCookie
;	mov rdx,pMyFdeVtable
;	@comcall .pFod->Advise

;	mov rdx,dwOptions
;	@comcall .pFod->GetOptions

;;OFN_HIDEREADONLY | OFN_NOVALIDATE | OFN_PATHMUSTEXIST | OFN_READONLY
;	mov dword[dwOptions],\
;		 FOS_ALLOWMULTISELECT\
;		or FOS_NODEREFERENCELINKS\
;		or FOS_ALLNONSTORAGEITEMS\
;		or FOS_NOVALIDATE or FOS_PATHMUSTEXIST ;or (not FOS_FILEMUSTEXIST)
;	mov rdx,[dwOptions]
;	@comcall .pFod->SetOptions

;	mov r8,fspec
;	mov rdx,1
;	@comcall .pFod->SetFileTypes

;	xor rdx,rdx
;	@comcall .pFod->Show
;;@break
;;;	mov rdx,pShia
;;;	mov rcx,[pFod]
;;;	iFileOpenDialog.GetResults
;;;	test eax,eax
;;;	jl	.exit

;.exitB:
;	mov rdx,[pCookie]
;	@comcall .pFod->Unadvise
;	@comcall .pFod->iUnknown.Release

;	;call myhandler.destroy

;.exit:
;	call [CoUninitialize]
;	xor ecx,ecx
;	call apiw.exitp

;	mov rsp,rbp
;	pop rdi
;	pop rbp
;	ret 0


;FDE_handler:
;.create:
;	
;	;--- create base object
;;	push rbp
;;	push rbx
;;	mov rbp,rsp
;;	and rsp,-16

;;	mov rcx,sizeof.COMOBJ
;;	call art.a16malloc
;;	mov [pMyh],rax
;;	mov rbx,rax

;;	@comptr .iFde,rax,\
;;		iFileDialogEvents

;;	mov rcx,sizeof.iFileDialogEvents
;;	call art.a16malloc
;;	mov [rbx+COMOBJ.pVtable],rax
;	xor eax,eax
;	mov [myFde.pShia],rax
;	mov rcx,.OnFolderChanging
;	mov [myFde.iFDE.iUnknown.AddRef],rcx
;	mov [myFde.iFDE.iUnknown.QueryInterface],rcx
;	mov [myFde.iFDE.iUnknown.Release],rcx
;	mov [myFde.iFDE.OnFileOk],.OnFileOk	
;	mov [myFde.iFDE.OnSelectionChange],rcx
;;		.OnSelectionChange
;	mov [myFde.iFDE.OnFolderChanging],rcx
;	mov [myFde.iFDE.OnFolderChange],rcx
;	mov [myFde.iFDE.OnShareViolation],rcx
;	mov [myFde.iFDE.OnTypeChange],rcx
;	mov [myFde.iFDE.OnOverwrite],rcx
;	ret 0

;;	mov [.iFde+\
;;		iUnknown.AddRef],\
;;		.AddRef
;;	mov [.iFde+\
;;		iUnknown.QueryInterface],\
;;		.QueryInterface
;;	mov [.iFde+\
;;		iUnknown.Release],\
;;		.Release
;;	mov [.iFde+\
;;		iFileDialogEvents.OnFileOk],\
;;		.OnFileOk
;;	mov [.iFde+\
;;		iFileDialogEvents.OnSelectionChange],\
;;		.OnSelectionChange
;;	mov [.iFde+\
;;		iFileDialogEvents.OnFolderChanging],rcx
;;	mov [.iFde+\
;;		iFileDialogEvents.OnFolderChange],rcx
;;	mov [.iFde+\
;;		iFileDialogEvents.OnShareViolation],rcx
;;	mov [.iFde+\
;;		iFileDialogEvents.OnTypeChange],rcx
;;	mov [.iFde+\
;;		iFileDialogEvents.OnOverwrite],rcx

;;	mov rsp,rbp
;;	pop rbx
;;	pop rbp
;;	ret 0


;;.destroy:
;;	mov rcx,[pMyh]
;;	push [rcx+COMOBJ.pVtable]
;;	call art.a16free
;;	pop rcx
;;	call art.a16free
;;	ret 0


;.AddRef:
;	xor eax,eax
;	ret 0

;.Release:
;	xor eax,eax
;	ret 0

;.QueryInterface:
;	;--- in RCX this
;	;--- in RDX refid
;	;--- in R8 pObj
;nop
;nop
;	xor eax,eax
;	ret 0

;.OnFolderChanging:
;.OnFolderChange:
;.OnShareViolation:
;.OnTypeChange:
;.OnOverwrite:
;	xor eax,eax
;	ret 0


;;.OnSelectionChange:
;;	push rbp
;;	push rbx
;;	push rdi
;;	mov rbp,rsp
;;	mov rdi,rsp
;;	sub rsp,50h

;;	@comptr\
;;		.pFde,rbx,iMyFde,\
;;		.pFod,rbp-8,iFileOpenDialog,\
;;		.pShia,rbp-10h,iShellItemArray,\
;;		.pShi,rbp-18h,iShellItem,\
;;		.nItems,rbp-20h,dq ?,\
;;		.pFV2,rbp-28h,iFolderView2

;;;@break
;;	mov rbx,rcx
;;	mov [.pFod],rdx
;;	mov rax,[.pFde+iMyFde.pShia]
;;	test rax,rax
;;	jz	.OnSelChA
;;	mov [.pShia],rax
;;	@comcall .pShia->\
;;		iUnknown.Release
;;	xor eax,eax

;;.OnSelChA:
;;	mov [.pShia],rax
;;	lea r8,[.pFod]
;;	mov rdx,iid_FileOD
;;	@comcall .pFod->\
;;		iUnknown.QueryInterface
;;	test eax,eax
;;	jl	.exit_OnFileOk

;;	lea r9,[.pFV2]
;;	mov r8,iid_FolderView2
;;	mov rdx,clsid_FolderView
;;	mov rcx,[.pFod]
;;	call [IUnknown_QueryService]
;;	test eax,eax
;;	jl	.exit_OnSelChOk

;;	lea r8,[.pShia]
;;	xor eax,eax
;;	mov [r8],rax
;;	mov edx,1
;;	@comcall .pFV2->\
;;		GetSelection
;;	test eax,eax
;;	jl .OnSelChB
;;	mov rax,[.pShia]
;;	mov [.pFde+iMyFde.pShia],rax

;;.OnSelChB:	
;;	@comcall .pFV2->\
;;	iFV.iUnk.Release

;;.exit_OnSelChOk:
;;	xor eax,eax
;;	mov rsp,rdi
;;	pop rdi
;;	pop rbx
;;	pop rbp
;;	ret 0
;	

;.OnFileOk:
;	;--- in RCX this
;	;--- in RDX pFod
;	push rbp
;	push rbx
;	push rdi
;	push rsi
;	push r12
;	mov rbp,rsp
;	mov r12,rsp
;	sub rsp,50h

;	@comptr \
;		.pFde,rbx,iMyFde,\
;		.pFod,rbp-8,iFileOpenDialog,\
;		.pShia,rbp-10h,iShellItemArray,\
;		.pShi,rbp-18h,iShellItem,\
;		.nItems,rbp-20h,dq ?

;	xor rax,rax
;	mov rbx,rcx
;	mov [.pFod],rdx
;	mov [.pShia],rax
;	mov [.nItems],rax

;	;--- get FileOpenDialog from
;	;--- received FileDialog
;	lea r8,[.pFod]
;	mov rdx,iid_FileOD
;	@comcall .pFod->\
;		iUnknown.QueryInterface
;	test eax,eax
;	jl	.exit_OnFileOk ;--- TODO error
;	
;	lea rdx,[.pShia]
;	@comcall .pFod->\
;		GetSelectedItems
;	test eax,eax
;	jl .exit_OnFileOk
;;@break
;;	mov rax,[.pFde+iMyFde.pShia]
;;	test rax,rax
;;	jz	.exit_OnFileOk
;;	mov [.pShia],rax

;	lea rdx,[.nItems]
;	@comcall .pShia->GetCount

;	mov rax,[.nItems]
;	test rax,rax
;	jz	.exit_OnFileOkA
;	mov rsi,rax
;;	jnz	.output
;;	mov [.pFde+iMyFde.pShia],rax
;;	jmp .exit_OnFileOkA

;.output:
;;@break
;	mov rdx,rsi
;	xor r9,r9
;	lea r8,[.pShi]
;	neg rdx
;	add rdx,[.nItems]
;	mov [r8],r9
;	sub rsp,20h
;	@comcall .pShia->\
;		GetItemAt
;	test eax,eax
;	jl	.exit_OnFileOkA

;	mov r8,pPath
;	mov rdx,SIGDN_FILESYSPATH
;	@comcall .pShi->\
;		GetDisplayName
;	test eax,eax
;	jl	.exit_OnFileOkA

;;;nop
;	mov rdx,[pPath]
;	xor rcx,rcx
;	call apiw.msg_err

;	mov rcx,[pPath]
;	call [CoTaskMemFree]

;	@comcall .pShi->\
;		iUnknown.Release
;	add rsp,20h
;	xor rax,rax
;	mov [.pShi],rax

;	dec rsi
;	jnz	.output

;.exit_OnFileOkA:
;	@comcall .pShia->\
;		iUnknown.Release
;	
;.exit_OnFileOk:
;	xor eax,eax
;	mov rsp,r12
;	pop r12
;	pop rsi
;	pop rdi
;	pop rbx
;	pop rbp
;	ret 0

;	include "%x64devdir%\shared\importw.inc"
;;	ret 0
;;	
;;;	mov rax,[iMe]
;;;	mov rax,[iMe.iUnknown]
;;;	mov rax,[iMe.iUnknown.AddRef]
;;;	mov rax,[iMe.myMethod]
;;	mov rax,[iYou]
;;	mov rax,[iYou.myMethod]
;;	mov rax,[iYou.iMe.myMethod]
;;	mov rax,[iYou.iMe.myMethod]
;;	mov rax,[iYou.iUnknown]

;;	@comptr .pUnk,\
;;	at rsp+8,iUnknown
;;;	@comcall .pUnk->AddRef
;;	mov rax,[.pUnk]
;;	mov rax,[.pUnk+iUnknown.AddRef]

;;;	mov rax,[.pUnk]
;;;	mov rax,[.pUnk+iUnknown.AddRef]
;;	
;;	@comptr .pUnk,\
;;	at rbp,iUnknown
;;	mov rax,[.pUnk]
;;	mov rax,[.pUnk+iUnknown.AddRef]
;;	@comcall .pUnk->AddRef

;;	@comptr .pYou,\
;;	at rax,iYou

;;	@comcall .pYou->iMe.myMethod
;;	@comcall .pYou->myMethod

;;	ret 0

;;	macro @comptr name,atarg,arginter{
;;		local ..tmp
;;		virtual atarg
;;		..tmp arginter
;;		name equ ..tmp
;;		end virtual
;;	}	

;;	;--- set static com pointer 
;;	;--- @comsta pUnk,iUnknown
;;	macro @comsta argcall,arginter {
;;		virtual at $
;;			argcall arginter
;;		end virtual
;;		dq 0
;;	}


;;	
;;	virtual at 0
;;	struc iUnknown {
;;		.QueryInterface dq ?
;;		.AddRef dq ?
;;		.Release dq ?
;;	} iUnknown iUnknown
;;	sizeof.iUnknown = $-iUnknown
;;	end virtual

;	
;;	@using iMe
;;	virtual at 0
;;	struc iMe {
;;		.myMethod dq ?
;;	} iMe iMe	
;;	end virtual
;;	sizeof.iMe = $-iMe
;;	@endusing

;;	@using iYou
;;	virtual at 0
;;	struc iYou {
;;		.iUnknown iUnknown
;;		.iMe iMe
;;		.myMethod dq ?
;;	} iYou iYou
;;	end virtual
;;	@endusing

;;macro @comcall argmeth{
;;	match p->meth,argmeth\{
;;;		display \`p
;;;		display \`meth
;;;		display_decimal iFileOpenDialog\#.\#meth
;;;		display_decimal .ppIn.Unadvise
;;;	  display_decimal \.ppIn\#.\#meth
;;		mov rcx,[p]
;;		mov rax,[rcx]
;;		call [rax+p\#.\#meth-p]
;;	\} 
;;}
;	

