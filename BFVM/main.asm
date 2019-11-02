.386

.MODEL flat, stdcall
.STACK 4096

ExitProcess PROTO, dwExitCode: DWORD

.DATA
 msg BYTE "main test",10,0 ; TODO: to delete

INCLUDE C:\masm32\include\kernel32.inc
INCLUDELIB C:\masm32\lib\kernel32.lib
INCLUDE C:\masm32\include\msvcrt.inc
INCLUDELIB C:\masm32\lib\msvcrt.lib

INCLUDE File.inc

.CODE
main PROC
	call HandleCommands
	INVOKE crt_printf, OFFSET msg

	INVOKE ExitProcess, 0
main ENDP

END main