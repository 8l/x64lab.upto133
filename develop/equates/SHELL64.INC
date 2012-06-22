	SHGFI_ICON = $100
	SHGFI_DISPLAYNAME  = $200
	SHGFI_TYPENAME = $400
	SHGFI_ATTRIBUTES = $800
	SHGFI_ICONLOCATION = $1000
	SHGFI_EXETYPE = $2000
	SHGFI_SYSICONINDEX = $4000
	SHGFI_LINKOVERLAY = $8000
	SHGFI_SELECTED = $10000
	SHGFI_ATTR_SPECIFIED = $20000
	SHGFI_LARGEICON = 0
	SHGFI_SMALLICON = 1
	SHGFI_OPENICON = 2
	SHGFI_SHELLICONSIZE = 4
	SHGFI_PIDL = 8
	SHGFI_USEFILEATTRIBUTES = $10
	SHGFI_ADDOVERLAYS = $20
	SHGFI_OVERLAYINDEX = $40

	struct SHFILEINFOW
		hIcon dq ?
		iIcon dd ?
		dwAttributes dd ?
		szDisplayName du MAX_PATH dup(?)
		szTypeName 		du 80 dup(?)
	ends
	@sizea16 SHFILEINFOW



;---------------------------------------
; SHELL32.DLL structures and constants

struct NOTIFYICONDATA
  cbSize	   dd ?
		   dd ?
  hWnd		   dq ?
  uID		   dd ?
  uFlags	   dd ?
  uCallbackMessage dd ?
		   dd ?
  hIcon 	   dq ?
  szTip 	   TCHAR 64 dup (?)
ends

struct NOTIFYICONDATAA
  cbSize	   dd ?
		   dd ?
  hWnd		   dq ?
  uID		   dd ?
  uFlags	   dd ?
  uCallbackMessage dd ?
		   dd ?
  hIcon 	   dq ?
  szTip 	   db 64 dup (?)
ends

struct NOTIFYICONDATAW
  cbSize	   dd ?
		   dd ?
  hWnd		   dq ?
  uID		   dd ?
  uFlags	   dd ?
  uCallbackMessage dd ?
		   dd ?
  hIcon 	   dq ?
  szTip 	   du 64 dup (?)
ends

; Taskbar icon messages

NIM_ADD        = 0
NIM_MODIFY     = 1
NIM_DELETE     = 2
NIM_SETFOCUS   = 3
NIM_SETVERSION = 4

; Taskbar icon flags

NIF_MESSAGE    = 01h
NIF_ICON       = 02h
NIF_TIP        = 04h
NIF_STATE      = 08h
NIF_INFO       = 10h
NIF_GUID       = 20h
