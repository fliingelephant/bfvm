INCLUDE C:\masm32\include\masm32rt.inc
;INCLUDELIB C:\masm32\lib\msvcrt.lib

.DATA
s_format BYTE "%s", 10, 0	; TODO: to delete
parse_msg BYTE "parsing", 10, 0 ; TODO: to delete

.CODE
Parse PROC
	INVOKE crt_printf, OFFSET s_format, ADDR parse_msg
	
	ret
Parse ENDP
END