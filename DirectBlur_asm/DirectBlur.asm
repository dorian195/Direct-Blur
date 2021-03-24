.code

; Procedure saves address of a Pixel in R8 register, consumes R8-R12 registers content.
; @returns R8: pointer + y * stride + x * bitsPerPixel / 8;
; @params              R8       R9      R10           R11        R12
pobierz_piksel proc; qword pointer, dword x, dword y, dword stride, dword BPP [can corrupt R8-R12]

	imul r10, r11   ; stride * y -> R10
	add r8, r10     ; (stride * y) + pointer -> R8
	imul r9, r12    ; x * BPP -> R9
	shr r9, 3       ; (x * BPP) / 8 -> R9
	add r8, r9      ; ((x * BPP) / 8) + ((stride * y) + pointer) -> R8 = RETURNING REGISTER

	ret
pobierz_piksel endp


CutoffColors proc ; [can corrupt R9-R10]
	mov R9W, 0
	mov R10W, 255
	cmp R13W, R9W
	jge RedTop
	mov R13, 0
RedTop:
	cmp R13W, R10W
	jle RedOk
	mov R13, 255
RedOk:
	cmp R14W, R9W
	jge GreenTop
	mov R14, 0
GreenTop:
	cmp R14W, R10W
	jle GreenOk
	mov R14, 255
GreenOk:
	cmp R15W, R9W
	jge BlueTop
	mov R15, 0
BlueTop:
	cmp R15W, R10W
	jle BlueOk
	mov R15, 255
BlueOk:
	ret
CutoffColors endp



; Procedude transforms single image by given pattern
; @returns nothing
; @params          [rbp-72]      [rbp-80]      [rbp-88]      [rbp-96]        [rbp+48]         [rbp+56]        [rbp+64]         [rbp+72]       [rbp+80],        [rbp+88],      [rbp+96]
TransformHoriz proc; QWORD input, QWORD output, DWORD picHei, DWORD picWid, DWORD inputStr, DWORD outputStr, DWORD inputBPP, DWORD outputBPP, QWORD pattern, DWORD beginLine, DWORD endLine
	
	;RBX, RBP, RDI, RSI, RSP, R12, R13, R14, R15

	push RBP      ; saving stack pointer
	mov RBP, RSP  ;
	push RBX      ;
	push RDI      ;
	push RSI      ;
	push RSP      ;
	push R12      ;
	push R13      ;
	push R14      ;
	push R15      ;
	
	push RCX      ;
	push RDX      ;
	push R8       ;
	push R9       ;

	mov rcx, [rbp+88] ; inicjalizacja licznika zewnetrznego
	add rcx, 3
loopOut:
	add rcx, 1        ; dodanie zapasu na obwodzie

	mov rdx, 0   ; inicjalizacja licznika wewnetrznego
	add rdx, 3
loopInn:
	add rdx, 1    ; dodanie zapasu na obwodzie
	
	mov R13D, 0   ; czerwony = 0;
	mov R14D, 0   ; zielony = 0;
	mov R15D, 0   ; niebieski = 0;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j - 4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	sub r9d, 4         ; odejmij 4
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w, r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j - 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	sub r9d, 3         ; odejmij 3
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w, r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j - 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	sub r9d, 2         ; odejmij 2
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w,r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j - 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	sub r9d, 1         ; odejmij 1
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w,r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w, r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j + 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	add r9d, 1         ; dodaj 1
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w, r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j + 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	add r9d, 2         ; dodaj 2
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w, r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j + 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	add r9d, 3         ; dodaj 3
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w, r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j + 4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	add r9d, 4         ; dodaj 4
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w, r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; WRITING TO OUTPUT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;;DIVISING COLORS BY 9
	push rdx;
	xor rdx, rdx
	xor rax, rax
	mov rax, r13
	mov rbx, 9
	div rbx
	mov r13, rax

	xor rdx, rdx
	xor rax, rax
	mov rax, r14
	mov rbx, 9
	div rbx
	mov r14, rax

	xor rdx, rdx
	xor rax, rax
	mov rax, r15
	mov rbx, 9
	div rbx
	mov r15, rax
	   	  
	pop rdx
	
	call CutoffColors ; capping R13-R15 registers values to fin in 0-255 range

	mov r8, [rbp-80]   ; output                             setting parameters
	mov r9d, edx       ; inner counter - j (width/x)
	mov r10d, ecx      ; outer counter - i (height/y)
	mov r11d, [rbp+56] ; outputStr
	mov r12d, [rbp+72] ; outputBPP

	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	xor R12, R12
	mov R12B, R15B ; moving first color to R12
	shl R12, 8
	mov R12B, R14B ; moving second color to R12
	shl R12, 8
	mov R12B, R13B ; moving third byte of pixel to R12
	mov [R8], R12D ;

	;;;;;;;;;;;;loops;;;;;;;;;;;;;;

	mov rax, [rbp-96] ; picWid
	sub rax, 4
	cmp rdx, rax
	jl loopInn

	mov rax, [rbp+96] ; endLine
	sub rax, 4
	cmp rcx, rax
	jl loopOut

	pop rax
	pop rax
	pop rax
	pop rax

	pop R15
	pop R14
	pop R13
	pop R12
	pop RSP
	pop RSI
	pop RDI
	pop RBX
	pop RBP

	ret
TransformHoriz endp








; Procedude transforms single image by given pattern
; @returns nothing
; @params          [rbp-72]      [rbp-80]      [rbp-88]      [rbp-96]        [rbp+48]         [rbp+56]        [rbp+64]         [rbp+72]       [rbp+80],        [rbp+88],      [rbp+96]
TransformVertic proc; QWORD input, QWORD output, DWORD picHei, DWORD picWid, DWORD inputStr, DWORD outputStr, DWORD inputBPP, DWORD outputBPP, QWORD pattern, DWORD beginLine, DWORD endLine
	
	;RBX, RBP, RDI, RSI, RSP, R12, R13, R14, R15

	push RBP      ; saving stack pointer
	mov RBP, RSP  ;
	push RBX      ;
	push RDI      ;
	push RSI      ;
	push RSP      ;
	push R12      ;
	push R13      ;
	push R14      ;
	push R15      ;
	
	push RCX      ;
	push RDX      ;
	push R8       ;
	push R9       ;

	mov ecx, [rbp+88] ; inicjalizacja licznika zewnetrznego
	add rcx, 3
loopOut:
	add rcx, 1        ; dodanie zapasu na obwodzie

	mov rdx, 0   ; inicjalizacja licznika wewnetrznego
	add rdx, 3
loopInn:
	add rdx, 1    ; dodanie zapasu na obwodzie
	
	mov R13D, 0   ; czerwony = 0;
	mov R14D, 0   ; zielony = 0;
	mov R15D, 0   ; niebieski = 0;

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j - 4 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	sub r10d, 4         ; odejmij 4
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w, r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j - 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	sub r10d, 3         ; odejmij 3
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w, r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j - 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	sub r10d, 2         ; odejmij 2
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w,r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j - 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	sub r10d, 1         ; odejmij 1
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w,r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w, r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j + 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	add r9d, 1         ; dodaj 1
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	add r10d, 1         ; dodaj 1
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w, r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j + 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	add r10d, 2         ; dodaj 2
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w, r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; j + 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov r8, [rbp-72]   ; zaladuj wskaznik na obrazek
	mov r9d, edx       ; zaladuj wewnetrzny licznik
	mov r10d, ecx      ; zaladuj zewnetrzny licznik
	add r10d, 3         ; dodaj 3
	mov r11d, [rbp+48] ; zaladuj inputStr
	mov r12d, [rbp+64] ; zaladuj inputBPP
	
	;                      R8       R9      R10           R11        R12
	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	mov R10D, [R8]    ; pixel -> R10
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r13w, r9w    ; dodajemy czerwony piksela j-4 do sumatora czerwonego
	
	shr R10, 8      ;  wydobywamy kolor zielony
	xor r9, r9		  ;zerujemy r9
	mov r9b, r10b	  ; przepisujemy bajt do r9
	add r14w, r9w  ; dodajemy do sumatora zielonego
	
	shr R10, 8      ; wydobywamy kolor niebieski
	xor r9, r9		;zerujemy r9
	mov r9b, r10b   ;przepisujemy bajt koloru do r9
	add r15w, r9w  ; dodajemy do sumatora niebieskiego
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; WRITING TO OUTPUT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	;;DIVISING COLORS BY 9
	push rdx;
	xor rdx, rdx
	xor rax, rax
	mov rax, r13
	mov rbx, 8
	div rbx
	mov r13, rax

	xor rdx, rdx
	xor rax, rax
	mov rax, r14
	mov rbx, 8
	div rbx
	mov r14, rax

	xor rdx, rdx
	xor rax, rax
	mov rax, r15
	mov rbx, 8
	div rbx
	mov r15, rax
	   	  
	pop rdx
	
	call CutoffColors ; capping R13-R15 registers values to fin in 0-255 range

	mov r8, [rbp-80]   ; output                             setting parameters
	mov r9d, edx       ; inner counter - j (width/x)
	mov r10d, ecx      ; outer counter - i (height/y)
	mov r11d, [rbp+56] ; outputStr
	mov r12d, [rbp+72] ; outputBPP

	call pobierz_piksel; qword pointer, dword x, dword y, dword stride, dword BPP ; RETURNS TO R8

	xor R12, R12
	mov R12B, R15B ; moving first color to R12
	shl R12, 8
	mov R12B, R14B ; moving second color to R12
	shl R12, 8
	mov R12B, R13B ; moving third byte of pixel to R12
	mov [R8], R12D ;

	;;;;;;;;;;;;loops;;;;;;;;;;;;;;

	mov rax, [rbp-96] ; picWid
	sub rax, 4
	cmp edx, eax
	jl loopInn

	mov rax, [rbp+96] ; endLine
	sub rax, 4
	cmp ecx, eax
	jl loopOut

	pop rax
	pop rax
	pop rax
	pop rax

	pop R15
	pop R14
	pop R13
	pop R12
	pop RSP
	pop RSI
	pop RDI
	pop RBX
	pop RBP

	ret
TransformVertic endp

end




