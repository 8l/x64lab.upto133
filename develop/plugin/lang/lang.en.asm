
  ;#-------------------------------------------------ü
  ;|          lang  MPL 2.0 License                  |
  ;|   Copyright (c) 2009-2012, Marc Rainer Kranz.   |
  ;|            All rights reserved.                 |
  ;|-------------------------------------------------|
  ;|      Dienstag] - 19.Juni.2012 - 10:51:19        |
	;ä-------------------------------------------------ö

define RAWMOD lang
define MODULE "lang"
define LANG	"en"

define VERBOSE TRUE
define WORKDIR "%x64devdir%\plugin"
define SHAREDDIR "%x64devdir%\shared"
define RELOCATION TRUE
define ATTACH_CODE lang.attach
define DETACH_CODE lang.detach

INC_RC		equ
INC_SDATA equ

	;---  our en\lang.inc
	INC_DATA	equ	WORKDIR#'\'#MODULE#'\lang.'#LANG#'.inc'

	;--- 	our base plugin\lang\code.asm
	INC_CODE	equ WORKDIR#'\'#MODULE#'\code.asm'

INC_RES		equ 
APIIMPORT	equ 

INC_IMP		equ 
		;SHAREDDIR#'\importw.inc'
INC_STR		equ

INC_EQU equ \
	WORKDIR#'\lang\lang.inc',\		;--- our base plugin\lang\code.inc
	SHAREDDIR#'\art.equ',\
	"%x64devdir%\version.inc",\
	"%x64devdir%\ide\x64lab.equ"	;--- ids from here

INC_INC equ SHAREDDIR#'\unicode.inc'
INC_ASM equ SHAREDDIR#'\unicode.asm'
INC_FIX equ TRUE

APIEXPORT equ

APIBRIDGE equ \
	lang.get_uz,\
	lang.info_uz
	


include '%x64devdir%\shared\common.asm'
