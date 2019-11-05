INCLUDE C:\masm32\include\Irvine32.inc
INCLUDE C:\masm32\include\msvcrt.inc
;INCLUDELIB C:\masm32\

INCLUDE File.inc
INCLUDE common.inc

.DATA
parse_msg BYTE "Start to parse..", 10, 0
s_format BYTE "%s", 0
c_format BYTE "%c", 0
after_check_msg BYTE "After checked", 10, 0
syntax_emsg BYTE "Syntax error: ']' missed.", 10, 0
dot BYTE ", ", 0
fullstop BYTE ".", 10, 0
check_flag BYTE ?

cur_pos DWORD ?
vmem BYTE 204800 DUP(0)
vmem_pos DWORD ?

.CODE
Interprete PROC
	INVOKE ReadToBuffer
	;INVOKE crt_printf, OFFSET s_format, ADDR FileBuffer
	mov cur_pos, OFFSET FileBuffer
	mov eax, OFFSET vmem
	mov vmem_pos, eax

Interprete_Loop:
    mov eax, cur_pos
	mov al, [eax]
	.IF al == 0
		ret
	.ELSEIF al == '>'
		mov ebx, [vmem_pos]
		inc ebx
		mov [vmem_pos], ebx
		jmp Exec_Loop
	.ELSEIF al == '<'
		mov ebx, [vmem_pos]
		dec ebx
		mov [vmem_pos], ebx
		jmp Exec_Loop
	.ELSEIF al == '+'
		mov eax, [vmem_pos]
          mov bl, [eax]
		inc bl
		mov [eax], bl
		jmp Exec_Loop
	.ELSEIF al == '-'
          mov eax, [vmem_pos]
          mov bl, [eax]
          dec bl
          mov[eax], bl
          jmp Exec_Loop
	.ELSEIF al == '.'
		mov ebx, vmem_pos
		mov al, [ebx]
		INVOKE crt_printf, OFFSET c_format, al
		jmp Exec_Loop
     .ELSEIF al == ','
          INVOKE crt_scanf, OFFSET c_format, al
          mov ebx, vmem_pos
          mov [ebx], al
          jmp Exec_Loop
	.ELSEIF al == '['
		mov ebx, [cur_pos]
		inc ebx
        mov [cur_pos], ebx
        mov al, [ebx]
		cmp al, ']'
		je Exec_Loop
		
        mov eax, [vmem_pos]
        mov bl, [eax]
        cmp bl, 0
        je Check_Valid_While

        mov ebx, [cur_pos]
        dec ebx
        push ebx
        mov [cur_pos], ebx
		jmp Exec_Loop
	.ELSEIF al == ']'
		mov ebx, [vmem_pos]
        mov al, [ebx]
		cmp al, 0
		je Pop_Cur
		
		pop ebx
		mov cur_pos, ebx
		push ebx
		jmp Exec_Loop
	.ELSE 
		jmp Exec_Loop
	.ENDIF

Check_Valid_While:           
	mov [check_flag], 1
	
	Check_Loop:
		mov ebx, [cur_pos]
        mov al, [ebx]
		.IF al == 0
			INVOKE crt_printf, OFFSET s_format, ADDR syntax_emsg
            ret
		.ELSEIF al == '['
            mov bl, [check_flag]
            inc bl
            mov [check_flag], bl
		.ELSEIF al == ']'
			mov bl, [check_flag]
			cmp bl, 1 
			je Exec_Loop
			dec bl
			mov [check_flag], bl
		.ENDIF
	Check_Loop_End:
		mov ebx, [cur_pos]
		inc ebx
		mov [cur_pos], ebx
		jmp Check_Loop
		
Pop_Cur:
	pop ebx
	jmp Exec_Loop
Exec_Loop:
	mov ebx, [cur_pos]
	inc ebx
	mov [cur_pos], ebx
	jmp Interprete_Loop
Interprete ENDP

END