INCLUDE C:\masm32\include\masm32rt.inc
INCLUDELIB C:\masm32\lib\msvcrt.lib

INCLUDE common.inc

.DATA
no_arg_tip BYTE "You can run",10, "  'BFVM.exe \PATH\TO\YOUR\FILE' to inteprete your brainfuck source code;", 10,
		"Or run", 10, "  'BFVM.exe -h' for help.",0
help_tip BYTE "This is a BrainFuck intepreter implemented with masm.", 10,
		"You can run",10, "  'BFVM.exe \PATH\TO\YOUR\FILE' to inteprete your brainfuck source code.", 0
help_flag BYTE "-h", 0
h_flag BYTE "h", 0
h_tip BYTE "Failed to recognize the argument 'h', do you mean '-h'?", 0
open_file_emsg BYTE "Failed to access file '%s'.", 0

Argsc DWORD ?    ; number of command line arguments
ArgsvList DWORD 0
argument BYTE 512 DUP(0)	; tmp
s_format BYTE "%s", 10, 0	; TODO: to delete
d_format BYTE "%d", 10, 0	; TODO: to delete

FileHandle DWORD ?	; file handle
FileBuffer BYTE 20480 DUP(0)
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
	;INVOKE crt_printf, OFFSET s_format, ADDR argument
	; TODO
	INVOKE str_cmp, OFFSET argument, OFFSET help_flag
	je HelpTips
	INVOKE str_cmp, OFFSET argument, OFFSET h_flag
	je HTips

	; try to open the file and give the handle
	INVOKE CreateFile, OFFSET argument, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	cmp eax, INVALID_HANDLE_VALUE
	je OpenFileError
	mov FileHandle, eax

	; free the memory occupied by CommandLineToArgvW
	INVOKE LocalFree, DWORD PTR [ArgsvList]
	ret

	NoArg:
		INVOKE crt_printf, OFFSET no_arg_tip
		ret
		
	HelpTips:
		INVOKE crt_printf, OFFSET help_tip
		ret

	HTips:
		INVOKE crt_printf, OFFSET h_tip
		ret

	OpenFileError:
		INVOKE crt_printf, OFFSET open_file_emsg, ADDR argument
		INVOKE ExitProcess, 0

HandleCommands ENDP

;----------------------------------------------------
ReadToBuffer PROC USES ebx ecx edx esi
;
; 
;----------------------------------------------------
	LOCAL readCount: DWORD
	mov esi, OFFSET FileBuffer
	mov ebx, 0

	ReadToBuffer_LOOP:
	INVOKE ReadFile, FileHandle, esi, 1, ADDR readCount, 0

	;reach the end or a newline
	cmp readCount, 1
	jl ReadToBuffer_END
	mov al, [esi]
	cmp al, 13
	je ReadToBuffer_LOOP
	.IF al != 10
		inc esi
		inc ebx
	.ENDIF
	jmp ReadToBuffer_LOOP

	ReadToBuffer_END:
	mov FileEndFlag, 1
	mov al, 0
	mov [esi], al
	mov eax, ebx
	ret
ReadToBuffer ENDP
END