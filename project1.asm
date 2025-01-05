.MODEL SMALL
.STACK 100H
.DATA
    ; Arrays for storing encrypted/decrypted messages (20 chars each, 5 messages max)
    CAESAR_ENC      DB 100 DUP('$')
    CAESAR_DEC      DB 100 DUP('$')
    REVERSE_ENC     DB 100 DUP('$')
    REVERSE_DEC     DB 100 DUP('$')
    ATBASH_ENC      DB 100 DUP('$')
    ATBASH_DEC      DB 100 DUP('$')
    D_ERR DB 'Decryption Error! Check your input$'
    
    ; Input buffer
    INPUT_BUFFER    DB 21 DUP('$')
    PASSWORD        DB 'ADMIN$'        ; Default password
    PASS_BUFFER     DB 6 DUP('$')
    
    ; Menu strings
    MENU_MSG        DB 10,13,'=== Encryption/Decryption Program ===',10,13
                    DB '1. Caesar Cipher Encryption',10,13
                    DB '2. Caesar Cipher Decryption',10,13
                    DB '3. Reverse Cipher Encryption',10,13
                    DB '4. Reverse Cipher Decryption',10,13
                    DB '5. Atbash Cipher Encryption',10,13
                    DB '6. Atbash Cipher Decryption',10,13
                    DB '7. Message History',10,13
                    DB '8. Change Password',10,13
                    DB '9. Exit',10,13
                    DB 'Choose option: $'
    
    ENTER_MSG       DB 10,13,'Enter text: $'
    RESULT_MSG      DB 10,13,'Result: $'
    PASS_PROMPT     DB 10,13,'Enter password: $'
    INVALID_MSG     DB 10,13,'Invalid option!$'
    WRONG_PASS_MSG  DB 10,13,'Wrong password!$'
    
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; First check password
    CALL CHECK_PASSWORD
    
MENU:
    ; Display menu
    LEA DX, MENU_MSG
    MOV AH, 9
    INT 21H
    
    ; Get choice
    MOV AH, 1
    INT 21H
    SUB AL, '0'
    
    ; Compare with valid options
    CMP AL, 1
    JB INVALID
    CMP AL, 9
    JA INVALID
    
    ; Jump to appropriate procedure
    CMP AL, 1
    JE CAESAR_ENCRYPT
    CMP AL, 2
    JE CAESAR_DECRYPT
    CMP AL, 3
    JE REVERSE_ENCRYPT
    CMP AL, 4
    JE REVERSE_DECRYPT
    CMP AL, 5
    JE ATBASH_ENCRYPT
    CMP AL, 6
    JE ATBASH_DECRYPT
    CMP AL, 7
    JE SHOW_HISTORY
    CMP AL, 8
    JE CHANGE_PASS
    CMP AL, 9
    JE EXIT_PROG
    
INVALID:
    LEA DX, INVALID_MSG
    MOV AH, 9
    INT 21H
    JMP MENU

        CHECK_PASSWORD PROC
            PUSH AX
            PUSH BX
            PUSH CX
            PUSH DX
            
            LEA DX, PASS_PROMPT
            MOV AH, 9
            INT 21H
            
            ; Get password input
            MOV CX, 5       ; Password length
            LEA SI, PASS_BUFFER
            
        GET_PASS:
            MOV AH, 1       ; Get character
            INT 21H
            MOV [SI], AL    ; Store in buffer
            INC SI
            LOOP GET_PASS
            
            ; Compare password
            MOV CX, 5       ; Reset counter for comparison
            LEA SI, PASSWORD
            LEA DI, PASS_BUFFER
            
        COMPARE_PASS:
            MOV AL, [SI]    ; Get character from stored password
            MOV BL, [DI]    ; Get character from input password
            CMP AL, BL      ; Compare them
            JNE WRONG_PASS  ; If not equal, password is wrong
            INC SI          ; Move to next character
            INC DI
            LOOP COMPARE_PASS
            
            ; If we get here, password is correct
            POP DX
            POP CX
            POP BX
            POP AX
            RET
            
        WRONG_PASS:
            LEA DX, WRONG_PASS_MSG
            MOV AH, 9
            INT 21H
            JMP EXIT_PROG   ; Exit if password is wrong
            
        CHECK_PASSWORD ENDP

    CAESAR_ENCRYPT PROC
        ; Get input
        LEA DX, ENTER_MSG
        MOV AH, 9
        INT 21H
        
        LEA SI, CAESAR_ENC
        
    CE_INPUT_LOOP:
        MOV AH, 1
        INT 21H
        
        CMP AL, 13      ; Check for Enter key
        JE CE_DONE_INPUT
        
        ; Encrypt (shift by 3)
        ADD AL, 3
        MOV [SI], AL
        INC SI
        JMP CE_INPUT_LOOP
        
    CE_DONE_INPUT:
        MOV  [SI], 'c'    ; Add identifier
        INC SI
        MOV  [SI], '$'   
        
        ; Show result
        LEA DX, RESULT_MSG
        MOV AH, 9
        INT 21H
        
        LEA DX, CAESAR_ENC
        MOV AH, 9
        INT 21H  
        
     
        JMP MENU
    CAESAR_ENCRYPT ENDP





    CAESAR_DECRYPT PROC
        ; Get input
        LEA DX, ENTER_MSG
        MOV AH, 9
        INT 21H
        
        LEA SI, CAESAR_DEC
        
    CD_INPUT_LOOP:
        MOV AH, 1
        INT 21H
        
        
        
        CMP AL, 13 ; Check for Enter key   
        JE CD_DONE_INPUT
        
        ; Decrypt (shift back by 3)
        SUB AL, 3
        MOV [SI], AL
        INC SI
        JMP CD_INPUT_LOOP
        
    CD_DONE_INPUT:  
        MOV BL,'c'
        DEC SI
        ADD [SI],3
        CMP [SI],BL
     
        JNE CD_ERR
        MOV [SI], '$'
        
        ; Show result
        LEA DX, RESULT_MSG
        MOV AH, 9
        INT 21H
        
        LEA DX, CAESAR_DEC
        MOV AH, 9
        INT 21H
        
        JMP MENU
        CD_ERR:
        LEA DX, D_ERR
        MOV AH, 9
        INT 21H
        JMP MENU
        RET
    CAESAR_DECRYPT ENDP



        REVERSE_ENCRYPT PROC
            ; Get input
            LEA DX, ENTER_MSG
            MOV AH, 9
            INT 21H
            
            MOV CX,0      ; Initialize counter
            
        RE_INPUT_LOOP:
            MOV AH, 1
            INT 21H
            
            CMP AL, 13      ; Check for Enter key
            JE RE_START_REVERSE
            
            ; Store character on stack
            PUSH AX
            INC CX          ; Increment counter
            JMP RE_INPUT_LOOP
            
        RE_START_REVERSE:
            LEA SI, REVERSE_ENC
            MOV [SI], 'r'   ; Add identifier
            INC SI
        RE_REVERSE_LOOP:
            CMP CX, 0       ; Check if we've processed all characters
            JE RE_DONE_REVERSE
            
            POP AX          ; Get character from stack
            MOV [SI], AL    ; Store in array
            INC SI
            DEC CX
            JMP RE_REVERSE_LOOP
            
        RE_DONE_REVERSE:

            INC SI
            MOV [SI], '$'   ; Add terminator            

            ; Show result
            LEA DX, RESULT_MSG
            MOV AH, 9
            INT 21H
            
            LEA DX, REVERSE_ENC
            MOV AH, 9
            INT 21H

            
            JMP MENU
            RET
        REVERSE_ENCRYPT ENDP





        
        REVERSE_DECRYPT PROC
            ; Get input
            LEA DX, ENTER_MSG
            MOV AH, 9
            INT 21H
            
            MOV CX,0      ; Initialize counter
            
        RD_INPUT_LOOP:
            MOV AH, 1
            INT 21H
            
            CMP AL, 13      ; Check for Enter key
            JE RD_START_REVERSE
            
            ; Store character on stack
            PUSH AX
            INC CX          ; Increment counter
            JMP RD_INPUT_LOOP
            
        RD_START_REVERSE:
            
            LEA SI, REVERSE_DEC
            
        RD_REVERSE_LOOP:
            CMP CX, 0       ; Check if we've processed all characters
            JE RD_DONE_REVERSE
            
            POP AX
         ; Get character from stack
            MOV [SI], AL    ; Store in array
            INC SI
            DEC CX
            JMP RD_REVERSE_LOOP
            
        RD_DONE_REVERSE:
            CMP AL,'r'
            JNE RD_ERR 
            DEC SI
            MOV [SI], '$'
            
            ; Show result
            LEA DX, RESULT_MSG
            MOV AH, 9
            INT 21H
            
            LEA DX, REVERSE_DEC
            MOV AH, 9
            INT 21H
            
            JMP MENU 
            RD_ERR:
            LEA DX, D_ERR
            MOV AH, 9
            INT 21H
            JMP MENU
            RET
        REVERSE_DECRYPT ENDP

ATBASH_ENCRYPT PROC
    ; Replace each letter with its complement (A->Z, B->Y, etc)
    ; [Implementation using 26-position from 'A']
    RET
ATBASH_ENCRYPT ENDP

ATBASH_DECRYPT PROC
    ; Same as ATBASH_ENCRYPT (Atbash is its own inverse)
    RET
ATBASH_DECRYPT ENDP

SHOW_HISTORY PROC
    ; Display all non-empty arrays with labels
    RET
SHOW_HISTORY ENDP

CHANGE_PASS PROC
    ; Get new password and store it
    RET
CHANGE_PASS ENDP

EXIT_PROG:
    MOV AH, 4CH
    INT 21H
    

END MAIN