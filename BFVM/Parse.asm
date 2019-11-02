parse PROC

Loop:
	mov al, [eax]
	.IF al == 0
		jmp Return
	.ELSEIF al == '>'
		;TODO
	.ELSEIF al == '<'
		;TODO
	.ELSEIF al == '+'
		;TODO
	.ELSEIF al == '-'
		;TODO
	.ELSEIF al == '.'
		;TODO
	.ELSEIF al == ','
		;TODO
	.ELSEIF al == '['
		;TODO
	.ELSEIF al == ']'
		;TODO

Return:
	ret

parse ENDP