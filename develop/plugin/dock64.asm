  ;#-------------------------------------------------ü
  ;|          dock64  MPL 2.0 License                |
  ;|   Copyright (c) 2009-2012, Marc Rainer Kranz.   |
  ;|            All rights reserved.                 |
  ;|-------------------------------------------------|
  ;|      Dienstag] - 19.Juni.2012 - 10:51:19        |
	;ä-------------------------------------------------ö

;define OUTEXT bin
define RAWMOD dock64
define MODULE "dock64"
define VERBOSE TRUE
define WORKDIR "%x64devdir%\plugin"
define SHAREDDIR "%x64devdir%\shared"
define RELOCATION TRUE
define ATTACH_CODE dock64.attach
define DETACH_CODE dock64.detach

INC_RC		equ 
	;WORKDIR#'\'#MODULE#'\rc.inc'
INC_SDATA equ 
INC_DATA	equ \
	WORKDIR#'\'#MODULE#'\data.inc',\
	SHAREDDIR#'\art.inc'

INC_CODE	equ WORKDIR#'\'#MODULE#'\code.asm'
INC_RES		equ 

APIIMPORT equ

INC_IMP	equ SHAREDDIR#'\importw.inc' 

INC_EQU equ  \
	WORKDIR#'\'#MODULE#'\equates.inc',\
	SHAREDDIR#'\art.equ',\
	"%x64devdir%\version.inc"

INC_INC equ

INC_ASM equ \
	WORKDIR#'\'#MODULE#'\shadow.asm',\
	WORKDIR#'\'#MODULE#'\panel.asm'

INC_FIX	equ TRUE

APIEXPORT equ ;\
;	dockman.init,"dockman.init",\
;	dockman.resize,"dockman.resize",\
;	dockman.layout,"dockman.layout",\
;	dockman.panel,"dockman.panel",\
;	dockman.text,"dockman.text"

APIBRIDGE equ \
	dock64.init,\
	dock64.panel,\
	dock64.layout,\
	dock64.discard


include '%x64devdir%\shared\common.asm'
