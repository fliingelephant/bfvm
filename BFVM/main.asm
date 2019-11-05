.386

.MODEL flat, stdcall
.STACK 4096

ExitProcess PROTO, dwExitCode: DWORD

.DATA
 msg BYTE "main test",10,0 ; TODO: to delete

INCLUDE File.inc
INCLUDE Parse.inc

.CODE
main PROC
	call HandleCommands
	call Interprete

	INVOKE ExitProcess, 0
main ENDP

END main