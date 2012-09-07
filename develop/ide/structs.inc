  
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

	MAX_MNUCPTS	 = 80h
	MAX_MNULEN	=  MAX_MNUCPTS*2 + 10h
	MAX_EXTLEN equ 78

	SLOT_CREATEDIR	equ 1
	SLOT_UPDATE			equ 2

	DIR_DEFDIR		equ 1
	DIR_HASREF		equ 2
	
	struct DIR
		hash	dq ?
		hnext	dq ?
		
		iIcon	dd ?
		len		dd ? 	;--- block len
		used	dd ?
		type	dw ?
		cpts	dw ?

		rdir	dq ?	;--- real dir SLOT
					dq ?
		dir		db FILE_BUFLEN dup (?)
	ends

	struct HU
		rc		RECT
					dq 0
		hDlg	dq 0

		hStc1	dq 0
		hStc2	dq 0

		hCbx	dq 0
		hBtn	dq 0

		hStc3	dq 0
		hEdi	dq 0

		hCanc	dq 0
		hOk		dq 0
	ends

	struct KEYDLG
		rc				RECT
		hDlg			dq ?
		hHot			dq ?
		hLvw			dq ?
		hChkCtrl	dq ?

		hChkAlt		dq ?
		hChkShift	dq ?
		hChkNoInv	dq ?
		hBtnSet		dq ?

		hOk			dq ?
		hCanc		dq ?	
		hStaId	dq ?
		last		dq ?
		oldKeya	dq ?
						dq ?
	ends

	
	struct IODLG
		param		dq 0  ;--- IN param	
		ldir		dq 0  ;--- last dir
						dq 0
		buflen	dw 0  ;--- buf len
		set			dw 0
						dd 0
		buf			db FILE_BUFLEN dup (?)
	ends

	IO_SAVECUR equ 0
	IO_NEWNAME equ sizeof.IODLG
	IO_SAVEWSP equ sizeof.IODLG * 2
	IO_NEWLNK  equ sizeof.IODLG * 3
	IO_DEVTOOL equ sizeof.IODLG * 4

	;--- Ownerdraw menuitem
	struct OMNI	
		id			dw 0
		iIcon		dw 0
		;--- follow menu text --
	ends
	
	;--- Accelerators wrapping struct
	struct KEYA
		fVirt	db 0
					db 0
		key		dw 0
		name	db 28 dup (0)
	ends


	struct EXT_CLASS
		top		dq ?	;--- TOP mem of [config\ext\name.utf8]
		next	dq ?	;--- next top class
		id		dq ?	;--- hash class ID

		dsize	dd ?	;--- top
		items	dd ?	;--- top
		name	db (128-32) dup (0)
	ends

	struct EXT_SLOT
		clsid	dq ?
		next	dq ?	;--- next extension slot
		hash	dq ?
					dq ?
	ends


	;-------- LABFILE -------------
	LF_NULL		equ 0
	LF_WSP		equ 1		;--- workspace marker
	LF_PRJ		equ 2		;--- project
	LF_FILE		equ 4		;--- file
	LF_LNK		equ 8	 	;--- smartlink for dir

	LF_TXT		equ 20h	 ;--- text file
	LF_BIN		equ 40h	 ;--- binary
	LW_OTH		equ 80h  ;--- other type
	LF_OPENED	equ 100h ;--- file is opened
	LF_MODIF	equ 200h ;--- modified
	LF_BLANK	equ 400h ;--- new item without disk-storage
	

	NOASK_SAVE 		= 1
	ASK_SAVE 			= 2
	

	struct LABFILE
		dq 0
		union
			hItem	dq 0	;--- treeitem
			hRoot	dq 0	;--- treeroot
		ends
		union
			hSci	dq 0	;--- scintilla win
			hBin	dq 0	;--- hex container
			hView	dq 0	;--- generic view window
		ends
		dir		dq 0	;--- slot dir

		alen	dw 0	;--- total available following len
		cpts	dw 0	;--- cpts, text following item
		idx		dw 0	;--- index slot
					db 0	;---
		state	db 0	;--- treitem state 
							;--- TVE_COLLAPSE	= 0001h
							;--- TVE_EXPAND  	= 0002h
		ext		dq 0	;--- extension slot
		type	dw 0	;--- LF_?
						db 0	;---
		iBlank	db 0 	;--- index blank
		iIcon		dd 0	;--- index icon
		hIcon		dq 0	;--- icon handle
ends

	struct EDIT
		pPanel	dq 0
		hwnd		dq 0

		cx_font	dw 0
		cy_font	dw 0
		type		dw 0
		docs		dw 0
		hStb		dq 0

		curlabf	dq 0
		blanks	dq 0 ;--- max 64 blank new file
		deflabf	dq 0
						dq 0
		hBtn	dq 0
		hFont	dq 0
	ends

	STATB_NOPART	equ 0
	STATB_ENCPART equ 1
	STATB_DIRPART	equ 2
	STATB_EOLPART	equ 3
	STATB_PARTS		equ 4

	struct CONS
		hCbx			dq 0
		hSci			dq 0
		cmd				db 512 dup (0)
		part0			dd 0
		part_enc	dd 0
		part_dir 	dd 0
		part_eol	dd 0
	ends

	struct MPURP
		hDlg			dq 0
		hCbxCat		dq 0

		hCbCat		dq 0	;--- child original ComboBox					
		hCbxFilt	dq 0
		hPrg			dq 0
		hLview		dq 0

		idCat			dw 0	;--- id category
		iFilt			dw 0	;--- item position
							dw 0	
							dw 0
							dq 0
	ends

	struct CONFIG
		version	dw 64h
		flags		db 0
						db 0
						dd ?
						dd ?
		fshow		db 1
		flog		db FALSE
		fsplash	db FALSE
						db 0
		;-------------------------
		lang8		db 8 dup (0)
						dd 0
						dd 0
		;-------------------------
		lang16  db 16 dup (?)
		;-------------------------
		update			dd FALSE
		session			dd 0
		tree.bkcol	dd 0D9FFFFh
		cons.bkcol	dd 0AABBCCh

		docs.bkcol	dd 0CCBBAAh
		prop.bkcol  dd	0DADADAh
						dd 0
						dd 0
		;-------------------------
		pos			 dq 0
		cons.pos dq 0
		tree.pos dq 0
						 dq 0
		;-------------------------
		owner	db FILE_BUFLEN dup (?)
		cdate db FILE_BUFLEN dup (?)
		ctime db 128 dup (0)
		adate db FILE_BUFLEN dup (?)
		atime db 128 dup (0)

		wsp		db FILE_BUFLEN*2 dup (?)
	ends

	;---------- scintilla related -------------
	LINE_COMMENT		= 1
	LINE_DECOMMENT	= 2
	LINE_INCEMPTY		= 4

	CX_GAP equ 3
	CY_GAP equ 3
