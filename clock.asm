.MODEL SMALL
.STACK 100H

.DATA
;output strings  
MSGS DB "Enter number of seconds (0-9): $"
MSGM DB "Enter number of minutes(0-9): $"
MSGH DB "Enter number of hours(0-9): $"
  
;initialize seconds, minutes and hours variable
S  DB ?
M  DB ?
H  DB ?
D1 DB 60 ;to divide by 60
D2 DB 10 ;to divide by 10
Q  DB ?  ;quotient(tens place) to store and display
R  DB ?  ;remainder(ones place) to store and display

.CODE
MAIN PROC
    MOV AX, @DATA ;include data segment
    MOV DS, AX

;display string, store input, convert ASCII input to numeric value, add newline
    
	;Display string for seconds
    MOV AH,09h
    LEA DX, MSGS
    INT 21H
	;get seconds initial value
    MOV AH,01h
    INT 21H   
	SUB AL,48  ; Convert from ASCII to numeric value
    MOV S, AL  ; store seconds in s
	; newline
	MOV DL, 10   
	MOV AH, 02h
	INT 21h
	MOV DL, 13   
	INT 21h
	
	;display string for minutes input
	MOV AH,09h
    LEA DX, MSGM
    INT 21H
	;get minutes initial value
    MOV AH,01h
    INT 21H
	SUB AL,48  
    MOV M, AL    ;store minutes in m
	;newline	
	MOV DL, 10   
	MOV AH, 02h
	INT 21h
	MOV DL, 13   
	INT 21h
	
	;display string for hours input
	MOV AH,09h
    LEA DX, MSGH
    INT 21H
    ; get hours initial value
    MOV AH,01h
    INT 21H
    SUB AL,48     
    MOV H, AL    ; Store hours in h
	;newline
	MOV DL, 10   
	MOV AH, 02h
	INT 21h
	MOV DL, 13   
	INT 21h
	

;display inital user inputted clock values
	;Display hours
    MOV AL,H  	;move h into register al for arithmetic operations
	XOR AH,AH	 ;clear register ah
	DIV D2		; divide h(in al) with d2(10)
    MOV Q,AL	;moves quotient which is the tens place of h into variable q
    MOV R,AH	; moves remainder which is the ones place of h into variable r
	
	MOV AH,02H	
	MOV DL,Q	;holds character q to be displayed
	ADD DL,48	;converts to ascii
	INT 21H
	MOV DL,R	;holds character r to be displayed
	ADD DL,48	
	INT 21H

    MOV DL,':' ;to format time as hh:
    INT 21h

    ; Display minutes
    MOV AL,M	;same functionality as display hours
	XOR AH,AH	
	DIV D2
    MOV Q,AL
    MOV R,AH
	
	MOV AH,02H
	MOV DL,Q
	ADD DL,48
	INT 21H
	MOV DL,R
	ADD DL,48
	INT 21H

    MOV DL,':'
    INT 21h

    ; Display seconds
    MOV AL,S	;same functionality as display minutes
    XOR AH,AH
	DIV	D2
    MOV Q,AL
	MOV R,AH
    
	MOV AH,02h
	MOV DL,Q
	ADD DL,48
    INT 21h
	MOV DL,R
	ADD DL,48
	INT 21H
	
	MOV DL, 10
    INT 21H 
    MOV DL, 13
    INT 21H 

	
;time incrementation
	;seconds inc
	MOV CX,43199	;increment to the second before 12hours (43200-1)
	NEXT:			;label to begin loop
	INC S			;increment second
	MOV AL,S
	XOR AH,AH
	DIV D1			;divide s(stored in al) by d1(60).if 60 or greater itll reset to 0
	MOV S,AH		;remainder of s-> ah 
	
	CMP AL,1		
	JNZ skip		;jump if not zero to skip
	INC M			;increment minutes when seconds>59
	
	skip:			
	MOV AL,M		
	XOR AH,AH
	
	DIV D1		;div minutes(m) by 60
	MOV M,AH	;remainder in ah
	CMP AL,1	
	JNZ skip1
	INC H		;increment hour
	
	skip1:
	MOV AL, H	
	CMP AL,12	;compare hour and 12
	JNZ skip3	
	MOV AL,0	;reset if hour>12
	MOV H,AL
	
	skip3:	;continue program
	CALL displayhr		;display incremented hour value
	
	CALL displaymin
	
	CALL displaysec
	
	MOV DL,10	;newline
	INT 21H
	MOV DL,13
	INT 21H
	
	LOOP NEXT	;loop label next
	
	;exit program
    MOV AH, 4Ch     ; Return to operating system
    INT 21H
	
	displayhr PROC
;display hours
	MOV AL,H	
	XOR AH,AH
	DIV D2		
	
	MOV Q,AL	;tens place in al
	MOV R,AH	;ones place in ah
	
	MOV DL,Q
	ADD DL,48	;convert to ASCII
	MOV AH,02H
	INT 21H
	MOV DL,R
	ADD DL,48
	INT 21H
	MOV DL, ':'			;to format hh:mm:ss
    INT 21h
	RET
	displayhr ENDP

	displaymin PROC
;display minutesdo
	MOV AL,M
	XOR AH,AH
	DIV D2
	
	MOV Q,AL
	MOV R,AH
	
	MOV DL,Q
	ADD DL,48
	MOV AH,02H
	INT 21H
	MOV DL,R
	ADD DL,48
	INT 21H
	MOV DL, ':'			;to format hh:mm:ss
    INT 21h
	RET
	displaymin ENDP
	
	displaysec PROC
;display seconds
	MOV AL,S
	XOR AH,AH
	DIV D2
	
	MOV Q,AL
	MOV R,AH
	
	MOV DL,Q
	ADD DL,48
	MOV AH,02H
	INT 21H
	MOV DL,R
	ADD DL,48
	INT 21H
	RET
	displaysec ENDP

MAIN ENDP
END MAIN 