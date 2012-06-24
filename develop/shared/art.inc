
	;#-------------------------------------------------ü
	;|          x64lab  MPL 2.0 License                |
	;|   Copyright (c) 2009-2012, Marc Rainer Kranz.   |
	;|            All rights reserved.                 |
	;|-------------------------------------------------|
	;|      Dienstag] - 19.Juni.2012 - 10:51:19        |
	;ä-------------------------------------------------ö



	align 2
	@using art.cout2XX, art.cout2XU
		uzFrm2XX	du "%llX %llX",13,10,0
		uzFrm2XU	du "%llX %ls",13,10,0
	@endusing


;-------------- function .get_pathpart
@using art.get_partpath
	PATH_NULL				equ 0
	PATH_PATH				equ 1
	PATH_REL 				equ 2
	PATH_SERVNAME 	equ 4
	PATH_LONG		 		equ 8
	PATH_DRIVE  		equ 10h
	PATH_FILE				equ 20h
@endusing
;------------------------------------


;struct PLUGINFO
;	dd_version	dd 0
;	db_pisize		db 0
;	db_ppisize	db 0
;	db_type 		db 0
;	reserved1 	db 0
;	reserved2 	dw 0
;	dw_procs 		dw 0
;	dd_flags		dd 0
;ends

; flags
; PLUG_THREADSAFE	= 1
; PLUG_FREE_ONEXIT	= 2
; PLUG_WAITING			= 4

;struct PLUGPROCINFO
;	db48_name db 48 dup (0)
;	dd_addr		dd 0
;	dd_hash		dd 0
;	db_params db 0
;	db 0
;	db 0
;	db 0	
;	dd_extra	dd 0
;ends

;struct BSTORE
;	pmem		dq 0
;	pfirst	dq 0
;	pfreed	dq 0
;	cpages	dw 0
;	rpages	dw 0
;	bsize		dw 0
;	flags		dw 0
;ends

	@using art.catstrw
		align 8
		uz2Greater	du ">> ",0
		uzMask			du "*.*",0
		uzUpDir			du "..\",0
		uzSpace			du " ",0
		uzColon			du ":",0
		uzOPar			du "[",0
		uzCPar			du "]",0
		uzFisheye		db 0C9h,25h,0,0
		uzBlackLxPTri	db 0C0h,25h,0,0
		uzTab				du 9,0
		uzNull			du 0,0
		uzSlash			du "\",0
		uzProtoSep	du ":/"
		uzIslash		du "/",0
		uzScore			du "_",0
		uzAsterisk	du "*",0
		uzMinus			du "-",0
		uzPlus			du "+",0
		uzPathSep		du ";",0
		uzSQuote    du "'",0
		uzNoPath		du 0,0
		uzDQuote		du '"',0
		uzDll				du ".dll",0
		uzHttpProto	du "http://",0
		uzComment 	equ szPathSep
	@endusing
;		if (used shared.loadfile) | (used shared.writefile) | (used shared.loadfileX)
;		if (used art.fread) | (used art.fwrite); | (used shared.loadfileX)
;			pReadBytes	dq 0
;		end if

;	@using shared.icex
;			
;	@endusing

;		if (used art.profiler_m1pro) |\
;			(used art.profiler_m1epi)|\
;			(used art.profiler_m2pro) |\
;			(used art.profiler_m2epi) | \
;			(used art.profiler_m1warmup)
;				dummy_dat dd 0
;				tsc_lo		dd 0
;				tsc_hi		dd 0
;				over_lo		dd 0
;				over_hi		dd 0
;		end if

;		szNumber:
;		szDecimal	db 16 dup (0)
;							db 4 dup (0)
;		szCharExt db "_999999",0
;		szHttp		db "http",0
;							db 3 dup (0)
;		szFtp			db "ftp",0



;	@using art.get_ext
;		szOutExt	db MAX_EXTLEN+2 dup (0)
;	@endusing

	@using art.get_localtime
		pSysTime			SYSTEMTIME	
		szDateFormat	db	"'['dddd'] - 'dd'.'MMMM'.'yyyy",0
		szRetDate			db 64 dup (0)
		szTimeFormat	db	"' - 'HH':'mm':'ss",0
		szRetTime			db 32 dup (0)
	@endusing

	@using art.time2name
		szTime2Name			db 32 dup (0)
		szFrmTime2Name	db "%.2d%.2d%.2d_%.2d%.2d%.2d_%.4d",0
	@endusing



