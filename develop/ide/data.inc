
  ;#-------------------------------------------------ü
  ;|          x64lab  MPL 2.0 License                |
  ;|   Copyright (c) 2009-2012, Marc Rainer Kranz.   |
  ;|            All rights reserved.                 |
  ;|-------------------------------------------------|
  ;|      Dienstag] - 19.Juni.2012 - 10:51:19        |


section '.data' data readable writeable
	curDir	dq sizeof.DIR
	dirHash	dq 400h*8
	envHash	dq 80h*8
	extHash dq 200h*8
	;idsHash	dq 800h*2
	
	pIo			dq sizeof.IODLG
	pCons 	dq sizeof.CONS
	pCp			dq sizeof.CPROP
	pEdit		dq sizeof.EDIT
	pConf		dq sizeof.CONFIG
	;steak		dq sizeof.XCOMP
	kdlg		dq sizeof.KEYDLG
	;---- OMNI spaces
	omni		dq 0
	NUM_ITEMS = ($-curDir)/8
;	omniTSize	dw 0
;	omniASize	dw 0
;						dd 0

	hSciDll	dq 0
	hDocker	dq 0

	hTree			dq 0
	hRootWsp	dq 0
	hDocs			dq 0
	pLabfWsp	dq 0

	hInst			dq 0
	hAccel		dq 0
	hMain			dq 0
	hMnuMain	dq 0
	hlaSysList	dq 0
	hsmSysList	dq 0
	hMnuFont		dq 0
	pTopStr	dq 0
	pTopExt	dq 0
	hBmpIml	dq 0

	appDir		dq 0
	backDir		dq 0
	confDir		dq 0
	;logDir		dq 0
	;mountDir	dq 0
	plugDir		dq 0
	projDir		dq 0
	templDir	dq 0
	tmpDir		dq 0
	toolDir		dq 0
  DEF_DIRS	= ($-appDir)/8


	match n,\`MAINCLASS {	uzClass	du n,0 }
	match =TRUE,DEBUG {
		uzTitle du TITLE," (DEBUG) ",0
	}
	match =FALSE,DEBUG {
		uzTitle du TITLE," v. "
		match v,VERSION \{
      szVersion du \`v,0 \}
	}

;		uzFname				du "testout.txt",0
		lfMnuSize		SIZE 18,16
		szCharExt 	db "_999999",0
		uzExtension	du "extension",0
		uzBackName	du "backup",0
		uzConfName	du "config",0
		uzLogName		du "log",0
		uzMountName	du "mount",0
		uzPlugName	du "plugin",0
		uzProjName	du "project",0
		uzTemplName du "template",0
		uzTmpName		du "tmp",0
		uzToolName 	du "tool",0
		uzMenuName	du "menu",0

		uzDefault		du "default"		;<--- follows
		uzLabExt		du "."
		uzAppName		du TITLE,0
		uzUtf8Ext		du ".utf8",0
		uzBinExt		du ".bin",0
		uzCfgExt		du ".cfg",0
		uzPngExt		du ".png",0
		uzEmfExt		du ".emf",0
		uzExeExt		du ".exe",0
		uzSciExt		du ".sci",0
		uzTreeClass	du "SysTreeView32",0
		uzLViewClass du "SysListView32",0
		uzCbexClass	du "ComboBoxEx32",0
		uzStbClass	du "msctls_statusbar32",0
		uzSciDll		du "Scilexer64.dll",0
		uzSciClass	du "Scintilla",0


		uzCourierN	db "Courier New",0
		
		;--- menu -----------------------------------------
		macro @mnp argname,argicon,argtysta,argflags,[args]{
			common
			align 8
				label t#argname
				label h#argname qword
				dw argname
				dw argicon
				dw argtysta
				dw argflags
			forward
				dw args
			common	
				dw 0
			}

		OWN equ MFT_OWNERDRAW
		DIF	equ MIIM_DATA or MIIM_ID or MIIM_FTYPE
		ISS equ MIIM_ID or MIIM_SUBMENU or MIIM_STRING
		RJU equ MFT_RIGHTJUSTIFY

		@mnp MP_WSPACE,	0,0,ISS,\
			MI_WS_LOAD,		1,OWN,DIF,\
			-1,\
			MI_WS_NEW,		0,OWN,DIF,\
			-1,\
			MI_WS_SAVE,		2,OWN,DIF,\
			-1,\
			MI_WS_EXIT,		24,OWN,DIF

		@mnp MP_FILE,		0,0,ISS,\
			MI_FI_OPEN,		1,OWN,DIF,\
			MI_FI_IMP,		20,OWN,DIF,\
			-1,\
			MI_FI_NEWB,		0,OWN,DIF,\
			MI_FI_NEWF,		0,OWN,DIF,\
			-1,\
			MI_FI_SAVE,		2,OWN,DIF,\
			-1,\
			MI_FI_CLOSE,	21,OWN,DIF

			
		@mnp MP_PATH,		26,RJU,ISS or MIIM_FTYPE,\
			MI_PA_CONS,		18,OWN,DIF,\
			MI_PA_BROWSE,	18,OWN,DIF,\
			MI_PA_FIND,		18,OWN,DIF,\
			MI_PA_COPY,		18,OWN,DIF,\
			MI_PA_SETPROP,18,OWN,DIF
		
;		uzStrNull		du "<#null>",0
;		uzAccelsName	du "accels",0

;		CPTS_MAXNAME	= 16
;		align 16

;	
;		uzKeyCol		du "Key name",0
;		uzAction		du "Action",0
;		uzNoC				du "NoConvert",0
;	align	2
;		uzUnb	du "Unbound files & folders",0
		;uzMyPath du "E:\x64lab",0
		;uzRec					du "Recent files",0
		;uzChildClass	du "x64lab_view",0
		;uzComctl			du "comctl32.dll",0
		;uzShellDll	du "Shell32.dll",0


;	align 8
;		taccels:
;			db FNOINVERT
;			db 0
;			dw 0
;			dw 0

;			db FNOINVERT
;			db 0
;			dw 0
;			dw 0

;			db FVIRTKEY
;			db 0
;			dw VK_F2
;			dw MI_FILE_SAVE

;			db FVIRTKEY
;			db 0
;			dw VK_F1
;			dw MI_WS_SAVE
		
;		dw 9090h
;		dw 9090h




;		pMenu 		dq 0
;		hMnuWsp		dq 0
;		hMnuFile	dq 0
;		hMnuEdit	dq 0
;		hMnuWin		dq 0
;		hMnuDir		dq 0
;		phGraph		dq 0
;		phBitmap	dq 0
;		hRedBrush	dq 0

;	;	hMnuUnb		dq 0

;			SLOT_EXT	equ 0
;			SLOT_CFG	equ 8
;			SLOT_HILI	equ 16

;		pSlot:
;			pExt			dq 0	;--- slot ext	offset +0
;			pCfg			dq 0	;--- slot cfg	offset +8
;			pHili			dq 0	;--- slot hili offset +16

;		labfMem	dq 0
;		dirMem	dq 0


	display "--- Size of data "
	display_decimal $-$$
	display 13,10



