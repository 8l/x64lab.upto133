  ;#-------------------------------------------------ü
  ;|          x64lab  MPL 2.0 License                |
  ;|   Copyright (c) 2009-2012, Marc Rainer Kranz.   |
  ;|            All rights reserved.                 |
  ;|-------------------------------------------------|
  ;|      Dienstag] - 19.Juni.2012 - 10:51:19        |
	;ä-------------------------------------------------ö

	IDC_ALLSIZE = 32646

	ALIGN 2
	patt_bmp dw\
		00aah, 0055h,\
		00aah, 0055h,\ 
		00aah, 0055h,\
		00aah, 0055h
	uzPanelClass	du "bk64.panel",0
		