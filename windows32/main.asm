.586
.MODEL FLAT	; only 32 bit addresses, no segment:offset

INCLUDE io.h   ; header file for input/output

.STACK 4096	   ; allocate 4096 bytes for the stack

.DATA
	
	; We are using DWORD sizes, because the problem spec says to.
	
	; These prompts will be displayed when asking for numbers
	; They are null terminated because the input macro expects a C-string
	number1Prompt BYTE "Please input a positive integer", 0
	number2Prompt BYTE "Please input another positive integer", 0

	; inputString will be used to store the user's inputs in ASCII coded decimal form.
	; It is 11 characters + Null terminator, because the most characters you could need
	; to express a signed double word is 10 characters (4294967295d is the longest number
	; representable as a DWORD)
	inputString BYTE 10 DUP ("X"), 0

	; gcdString will be used with dtoa, which expects 11 characters + Null terminator
	gcdString BYTE 11 DUP ("X"), 0	; String to store gcd in decimal for output
	
	; gcdOutputLabel will be used to label the gcd when it is displayed
	gcdOutputLabel BYTE "Greatest Common Divisor"


.CODE
_MainProc PROC
	
	; gcd := number1
	; remainder := number2
	; loopStart
	;   dividend := gcd
	;   gcd := remainder
	;   remainder := dividend mod gcd
	; until(remainder = 0)

	; We are using DWORD sizes, because the problem spec says to.
	; ebx = gcd
	; ecx = remainder
	; eax = dividend

	input number1Prompt, inputString, 10	; get input from user (maximum 10 characters, as explained above at inputString)
	atod inputString						; convert input from ASCII coded decimal to binary integer (stored in EAX)
	mov ebx, eax							; gcd := user input

	input number2Prompt, inputString, 10	; get input from user
	atod inputString						; convert input from string to binary integer (stored in EAX)
	mov ecx, eax							; remainder := user input

loopStart:
	mov eax, ebx							; dividend := gcd
	mov ebx, ecx							; gcd := remainder
	
	mov edx, 0								; prepare for division
	div ebx									; divide dividend by gcd (to get dividend mod gcd)
	mov ecx, edx							; remainder := dividend mod gcd
	cmp ecx, 0								; remainder = 0?
	jnz loopStart							; if (remainder != 0) goto loopStart
loopEnd:
	
	dtoa gcdString, ebx						; convert gcd to string (for output)
	output gcdOutputLabel, gcdString		; output gcd


	mov eax, 0								; exit with return code 0
	
	ret
_MainProc ENDP

END   ; end of source code
