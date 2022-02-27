IDEAL
model small
STACK 100h

DATASEG
msgNoOption2 db 0Ah,0Dh,'There isnt any other option right now... sorry!',0Ah,0Dh,'$'
msgStart db	0Ah,0Dh,'Note: (0,0) at left bottom',0Ah,0Dh,'Choose 1-line, 2-there isnt any other option right now:',0Ah,0Dh,'$'
msgSlope db 0Ah,0Dh,'enter slope (You can put a minus sign, Integer only):',0Ah,0Dh,'$' 
msgLineB db 'enter height (Integer between 0-199):',0Ah,0Dh,'$'
msgTnk db 0Ah,0Dh,'bye!','$'
;msgEnd db 'Would you like to try again? (y/n)',0Ah,0Dh,'$'

finalS dw 0
finalB dw 0
isNeg db 0

CODESEG
start:
	mov ax,@data
	mov ds,ax
;newStart:    
;	mov [isNeg],0
	mov dx, OFFSET msgStart
	mov ah, 09H 
	int 21H
	
	mov ah, 1
    int 21h
	cmp al, 31h
	je line
	cmp al,32h
	je option2_1
	jmp exit
line:
	mov bx, 0
	mov dx, OFFSET msgSlope 
	mov ah, 09H 
	int 21H 
	
inputSlopeLabel:
	xor cx,cx
    mov ah, 1
    int 21h
    cmp al, 13 ;is enter key
    je enterPressedSlope
	cmp al, 2Dh ;is minus sign
    je minusSign
	sub al,30h
    mov cl, al
	mov ax,[finalS]
	mov dx,10
	mul dx
	add ax,cx
	mov [finalS],ax
    jmp inputSlopeLabel
minusSign:
	mov [isNeg],1
	jmp inputSlopeLabel
enterPressedSlope:
	mov bx, 0
	mov dx, OFFSET msgLineB 
	mov ah, 09H 
	int 21H 
	
inputBLabel:
	xor cx,cx
    mov ah, 1
    int 21h
    cmp al, 13 ; 13 is enter key
    je enterPressedB
	sub al,30h
    mov cl, al
	mov ax,[finalB]
	mov dx,10
	mul dx
	add ax,cx
	mov [finalB],ax
    jmp inputBLabel

;start1:
;	jmp start
option2_1:
	jmp option2

enterPressedB:
	
	mov ah,00h
    mov al,13h
    int 10h
	
	mov ah,0ch
	mov al,4
	mov cx,0
	mov dx,199
	sub dx,[finalB]
draw:
	int 10h
	inc cx
	cmp cx,320
	je exit
	cmp [isNeg],1
	je yNeg
	sub dx,[finalS]
	cmp dx,0
	js exit
	jmp draw
yNeg:
	add dx,[finalS]
	cmp dx,199
	jae exit
	jmp draw

jmp exit

option2:
	mov dx, OFFSET msgNoOption2
	mov ah, 09H 
	int 21H 

exit:
  
	mov ah,00h
    int 16h
	
    mov ah,00h
    mov al,03h
    int 10h  
	mov dx, OFFSET msgTnk
	mov ah, 09H 
	int 21H 
	
;   mov dx, OFFSET msgEnd
;	mov ah, 09H 
;	int 21H 
;	mov ah, 1
;   int 21h
;	cmp al, 79h
;	je start1
;	cmp al, 59h
;	je start1

	mov ax,4c00h
	int 21h
END start