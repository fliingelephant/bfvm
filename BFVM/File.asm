INCLUDE C:\masm32\include\masm32rt.inc


.DATA
no_arg_tip BYTE "TODO: no_arg_tip", 10, 0
help_tip BYTE "TODO: help_tip", 10, 0
help_flag BYTE "-h", 10, 0
open_file_emsg BYTE "TODO: open_file_emsg"

Argsc DWORD ?    ; number of command line arguments
ArgsvList DWORD 0
argument BYTE 512 DUP(0)	; tmp
s_format BYTE "%s", 10, 0	; TODO: to delete
d_format BYTE "%d", 10, 0	; TODO: to delete

FileHandle DWORD ?	; file handle
FileLine DWORD ?
FileEndFlag BYTE 0

.CODE
; ---------------------------------------------------
str_cmp PROC USES eax edx esi edi,
	string1: PTR BYTE,
	string2: PTR BYTE
;
; cmp two strings
;----------------------------------------------------
	mov esi, string1
	mov edi, string2
	str_cmp_L1:
	mov al, [esi]
	mov dl, [edi]
	cmp al, 0
	jne str_cmp_L2
	cmp dl, 0
	jne str_cmp_L2
	jmp str_cmp_L3

	str_cmp_L2:
	inc esi
	inc edi
	cmp al,dl
	je str_cmp_L1

	str_cmp_L3:
	ret
str_cmp ENDP

;---------------------------------
HandleCommands PROC USES eax ebx ecx edx esi
;
; handle commands and open the file
;---------------------------------
	INVOKE GetCommandLineW
	INVOKE CommandLineToArgvW, eax, OFFSET Argsc
	mov ArgsvList, eax
	mov esi, eax; esi: **Argsv, [esi]->*Argsv

    ; only one argument
	cmp Argsc, 1
	jle NoArg

	; the second argument
	add esi, 4
	INVOKE WideCharToMultiByte, 0, 0, [esi], -1, OFFSET argument, SIZEOF argument, 0, 0
	INVOKE crt_printf, OFFSET s_format, ADDR argument
	; TODO
	INVOKE str_cmp, ADDR argument, ADDR help_flag
	je HelpTips

	; try to open the file and give the handle
	INVOKE CreateFile, OFFSET argument, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	cmp eax, INVALID_HANDLE_VALUE
	;je OpenFileError
	;mov FileHandle, eax

	; free the memory occupied by CommandLineToArgvW
	INVOKE LocalFree, DWORD PTR [ArgsvList]
	ret

	NoArg:
		INVOKE crt_printf, OFFSET no_arg_tip
		ret
		
	HelpTips:
		INVOKE crt_printf, OFFSET help_tip
		ret

	OpenFileError:
		INVOKE StdOut, OFFSET open_file_emsg
		INVOKE ExitProcess, 0

HandleCommands ENDP

;----------------------------------------------------
ReadLine PROC USES ebx ecx edx esi
;
; read a line from file, put it to FileLine, return the length
;----------------------------------------------------
	LOCAL readCount: DWORD
	mov esi, OFFSET FileLine
	mov ebx, 0

	ReadLine_LOOP:
	INVOKE ReadFile, FileHandle, esi, 1, ADDR readCount, 0

	;reach the end or a newline
	cmp readCount, 1
	jl ReadLine_END
	mov al, [esi]
	cmp al, 13
	je ReadLine_LOOP
	cmp al, 10
	je ReadLine_ENDLine

	inc esi
	inc ebx
	jmp ReadLine_LOOP

	ReadLine_END:
	mov FileEndFlag, 1
	mov al, 0
	mov [esi], al
	mov eax, ebx
	ret
	ReadLine_ENDLine:
	mov al, 0
	mov [esi], al
	mov eax, ebx
	ret
ReadLine ENDP

END