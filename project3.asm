    .MODEL SMALL
    .STACK 100H
    .DATA
        ; Arrays for storing encrypted/decrypted messages
        CAESAR_ENC      DB 100 DUP('$')
        CAESAR_DEC      DB 100 DUP('$')
        REVERSE_ENC     DB 100 DUP('$')
        REVERSE_DEC     DB 100 DUP('$')
        ATBASH_ENC      DB 100 DUP('$')
        ATBASH_DEC      DB 100 DUP('$')
        D_ERR           DB 'Decryption Error! Check your input$'
         
         
        ; Caesar Cipher History 
        CAESAR_ENC_INP_HISTORY DB 100 DUP('$')
        CAESAR_ENC_OUT_HISTORY DB 100 DUP('$')
        CAESAR_DEC_INP_HISTORY DB 100 DUP('$')
        CAESAR_DEC_OUT_HISTORY DB 100 DUP('$') 
        
        ; Reverse Cipher History 
        REVERSE_ENC_INP_HISTORY DB 100 DUP('$') 
        REVERSE_ENC_OUT_HISTORY DB 100 DUP('$')
        REVERSE_DEC_INP_HISTORY DB 100 DUP('$') 
        REVERSE_DEC_OUT_HISTORY DB 100 DUP('$') 
        
        ; Atbash Cipher History 
        ATBASH_ENC_INP_HISTORY DB 100 DUP('$')
        ATBASH_ENC_OUT_HISTORY DB 100 DUP('$')
        ATBASH_DEC_INP_HISTORY DB 100 DUP('$') 
        ATBASH_DEC_OUT_HISTORY DB 100 DUP('$')   
        
        ;History Text Printers
        CAESAR  DB 10,13,'Caesar Cipher History$',10,13   
        REVERSE DB 10,13,'Reverse Cipher History$',10,13
        ATBASH  DB 10,13,'Atbash Cipher History$',10,13
  
        HISTORY_PROMPT  DB 10,13,'Choose history to display:',10,13
                        DB '1. Caesar Cipher History', 10,13
                        DB '2. Reverse Cipher History',10,13
                        DB '3. Atbash Cipher History$',10,13
        
        CAESAR_ENC_INP_MSG DB 10,13,'Caesar Encryption Input History:', 10,13, '$'
        CAESAR_ENC_OUT_MSG DB 10,13,'Caesar Encryption Output History:', 10,13, '$'
        CAESAR_DEC_INP_MSG DB 10,13,'Caesar Decryption Input History:', 10,13, '$'
        CAESAR_DEC_OUT_MSG DB 10,13,'Caesar Decryption Output History:', 10,13, '$'
        
        REVERSE_ENC_INP_MSG DB 10,13,'Reverse Encryption Input History:', 10,13, '$'
        REVERSE_ENC_OUT_MSG DB 10,13,'Reverse Encryption Output History:', 10,13, '$'
        REVERSE_DEC_INP_MSG DB 10,13,'Reverse Decryption Input History:', 10,13, '$'
        REVERSE_DEC_OUT_MSG DB 10,13,'Reverse Decryption Output History:', 10,13, '$'
        
        ATBASH_ENC_INP_MSG DB 10,13,'Atbash Encryption Input History:', 10,13, '$'
        ATBASH_ENC_OUT_MSG DB 10,13,'Atbash Encryption Output History:', 10,13, '$'
        ATBASH_DEC_INP_MSG DB 10,13,'Atbash Decryption Input History:', 10,13, '$'
        ATBASH_DEC_OUT_MSG DB 10,13,'Atbash Decryption Output History:', 10,13, '$'
        
        
        
        
        
        
        ; Caesar Cipher Pointers
        CAESAR_ENC_INP_TRACKER     DW 0H  
        CAESAR_ENC_OUT_TRACKER     DW 0H  
        CAESAR_DEC_INP_TRACKER     Dw 0h  
        CAESAR_DEC_OUT_TRACKER     Dw 0h  
        
        ; Reverse Cipher Trackers
        REVERSE_ENC_INP_TRACKER    Dw 0h  
        REVERSE_ENC_OUT_TRACKER    Dw 0h  
        REVERSE_DEC_INP_TRACKER    Dw 0h  
        REVERSE_DEC_OUT_TRACKER    Dw 0h  
        
        ; Atbash Cipher Trackers
        ATBASH_ENC_INP_TRACKER     Dw 0h  
        ATBASH_ENC_OUT_TRACKER     Dw 0h  
        ATBASH_DEC_INP_TRACKER     Dw 0h  
        ATBASH_DEC_OUT_TRACKER     Dw 0h  
     
     
         
        ; Input buffer
        INPUT_BUFFER    DB 21 DUP('$')
        PASSWORD        DB 'admin$'        ; Default password
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
        
        ENTER_MSG           DB 10,13,'Enter your input: $'
        RESULT_MSG          DB 10,13,'Result: $'
        PASS_PROMPT         DB 10,13,'Enter password: $'
        INVALID_MSG         DB 10,13,'Invalid option!$'
        INVALID_MSG1        DB 10,13,'Invalid option!$'
        WRONG_PASS_MSG      DB 10,13,'Wrong password!$'
        NEW_PASS_MSG        DB 10,13,'Enter new password (5 chars): $'
        PASS_CHANGED_MSG    DB 10,13,'Password changed successfully!$',10,13
            
    .CODE
    MAIN PROC
        MOV AX, @DATA
        MOV DS, AX
    NEWPASSSTATE:     
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
                MOV AH, 1       
                INT 21H
                MOV [SI], AL    ; Store in pass_buffer
                INC SI
                LOOP GET_PASS
                
                ; Compare password
                MOV CX, 5       ; Reset counter for comparison
                LEA SI, PASSWORD
                LEA DI, PASS_BUFFER
                
            COMPARE_PASS:
                MOV AL, [SI]    
                MOV BL, [DI]   
                CMP AL, BL      
                JNE WRONG_PASS  
                INC SI          
                INC DI
                LOOP COMPARE_PASS
                
                
                POP DX
                POP CX
                POP BX
                POP AX
                RET
                
            WRONG_PASS:
                LEA DX, WRONG_PASS_MSG
                MOV AH, 9
                INT 21H
                JMP NEWPASSSTATE   
                
            CHECK_PASSWORD ENDP
    
        CAESAR_ENCRYPT PROC
            
            LEA DX, ENTER_MSG
            MOV AH, 9
            INT 21H
            
            LEA SI, CAESAR_ENC
            LEA DI, CAESAR_ENC_INP_HISTORY  ; For input history     
            ADD DI ,CAESAR_ENC_INP_TRACKER  ; Save input history pointer                       
        CE_INPUT_LOOP:
            MOV AH, 1
            INT 21H
            
            CMP AL, 13      
            JE CE_DONE_INPUT
            
            MOV [DI], AL
            INC DI            
            
            ADD AL, 3
            MOV [SI], AL
            INC SI
            JMP CE_INPUT_LOOP
            
        CE_DONE_INPUT:
        
     
       
        MOV [DI], '|'   ; Line feed
        INC DI

    
        ; Update input offset for next time
        MOV AX, DI
        SUB AX, OFFSET CAESAR_ENC_INP_HISTORY
        MOV CAESAR_ENC_INP_TRACKER, AX
           
            MOV  [SI], 'c'    ; Add identifier
            INC SI
            MOV  [SI], '$'   
        ;copy encrypted text to output history
        LEA SI, CAESAR_ENC             
        LEA DI, CAESAR_ENC_OUT_HISTORY 
        ADD DI, CAESAR_ENC_OUT_TRACKER
        
        COPY_TO_HISTORY_CE:
        MOV AL, [SI]
        MOV [DI], AL
        CMP AL, '$'
        JE SHOW_RESULT_CE
        INC SI
        INC DI
        JMP COPY_TO_HISTORY_CE 
        SHOW_RESULT_CE: 
        MOV [DI], '|'
        INC DI

    
        ; Update output offset for next time
        MOV AX, DI
        SUB AX, OFFSET CAESAR_ENC_OUT_HISTORY
        MOV CAESAR_ENC_OUT_TRACKER, AX
        

            LEA DX, RESULT_MSG
            MOV AH, 9
            INT 21H
            
            LEA DX, CAESAR_ENC
            MOV AH, 9
            INT 21H  
            
         
            JMP MENU
        CAESAR_ENCRYPT ENDP
    
    
    
    
    
        CAESAR_DECRYPT PROC
            
            LEA DX, ENTER_MSG
            MOV AH, 9
            INT 21H
            
            LEA SI, CAESAR_DEC
            LEA DI, CAESAR_DEC_INP_HISTORY  ; For input history     
            ADD DI ,CAESAR_DEC_INP_TRACKER   ; Save input history pointer       
            
        CD_INPUT_LOOP:
            MOV AH, 1
            INT 21H
            
            
            
            CMP AL, 13  
            JE CD_DONE_INPUT
            
            MOV [DI], AL
            INC DI   

            
            SUB AL, 3
            MOV [SI], AL
            INC SI
            JMP CD_INPUT_LOOP
                
            CD_DONE_INPUT:
                   
            MOV [DI], '|' 
            INC DI
            ; Update input offset for next time
            MOV AX, DI
            SUB AX, OFFSET CAESAR_DEC_INP_HISTORY 
            MOV CAESAR_DEC_INP_TRACKER , AX
            MOV BL,'c'
            DEC SI
            ADD [SI],3
            CMP [SI],BL
         
            JNE CD_ERR
            MOV [SI], '$'

              
            LEA SI, CAESAR_DEC              
            LEA DI, CAESAR_DEC_OUT_HISTORY
            ADD DI, CAESAR_DEC_OUT_TRACKER
            
        COPY_TO_HISTORY_CD:
            MOV AL, [SI]
            MOV [DI], AL
            CMP AL, '$'
            JE SHOW_RESULT_CD
            INC SI
            INC DI
            JMP COPY_TO_HISTORY_CD 
        SHOW_RESULT_CD: 
            MOV [DI], '|'
            INC DI
        
            
            ; Update output offset for next time
            MOV AX, DI
            SUB AX, OFFSET CAESAR_DEC_OUT_HISTORY
            MOV CAESAR_DEC_OUT_TRACKER, AX

            
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
    
    LEA DX, ENTER_MSG
    MOV AH, 9
    INT 21H
    
    MOV CX, 0      
    
   
    LEA DI, REVERSE_ENC_INP_HISTORY
    ADD DI, REVERSE_ENC_INP_TRACKER   
    
RE_INPUT_LOOP:
    MOV AH, 1
    INT 21H
    
    CMP AL, 13     
    JE RE_START_REVERSE
    
   
    MOV [DI], AL
    INC DI
    
    
    PUSH AX
    INC CX         
    JMP RE_INPUT_LOOP
    
RE_START_REVERSE:
  
    MOV [DI], '|' 
    INC DI

    
    
    MOV AX, DI
    SUB AX, OFFSET REVERSE_ENC_INP_HISTORY
    MOV REVERSE_ENC_INP_TRACKER, AX
    
    LEA SI, REVERSE_ENC
    MOV [SI], 'r'   ; Add identifier
    INC SI
    
RE_REVERSE_LOOP:
    CMP CX, 0      
    JE RE_DONE_REVERSE
    
    POP AX         
    MOV [SI], AL    
    INC SI
    DEC CX
    JMP RE_REVERSE_LOOP
    
RE_DONE_REVERSE:
    INC SI
    MOV [SI], '$'            

   
    LEA SI, REVERSE_ENC     
    LEA DI, REVERSE_ENC_OUT_HISTORY
    ADD DI, REVERSE_ENC_OUT_TRACKER
    
COPY_TO_HISTORY:
    MOV AL, [SI]
    MOV [DI], AL
    CMP AL, '$'
    JE ADD_NEWLINE
    INC SI
    INC DI
    JMP COPY_TO_HISTORY
    
ADD_NEWLINE:
    MOV [DI],'|'
    INC DI

    
   
    MOV AX, DI
    SUB AX, OFFSET REVERSE_ENC_OUT_HISTORY
    MOV REVERSE_ENC_OUT_TRACKER, AX

   
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
               
                LEA DX, ENTER_MSG
                MOV AH, 9
                INT 21H
                
                MOV CX,0      
              
                LEA DI, REVERSE_DEC_INP_HISTORY
                ADD DI, REVERSE_DEC_INP_TRACKER  
    
            RD_INPUT_LOOP:
                MOV AH, 1
                INT 21H
                
                CMP AL, 13    
                JE RD_START_REVERSE

                MOV [DI], AL
                INC DI
                            
               
                PUSH AX
                INC CX          
                JMP RD_INPUT_LOOP
                
            RD_START_REVERSE: 
               
                MOV [DI], '|'  
                INC DI
                   
                MOV AX, DI
                SUB AX, OFFSET REVERSE_DEC_INP_HISTORY
                MOV REVERSE_DEC_INP_TRACKER, AX
                                       
                                       
                LEA SI, REVERSE_DEC
 
            RD_REVERSE_LOOP:
                CMP CX, 0     
                JE RD_DONE_REVERSE
                
                POP AX 
                MOV [SI], AL  
                INC SI
                DEC CX
                JMP RD_REVERSE_LOOP
                
            RD_DONE_REVERSE:
                CMP AL,'r'
                JNE RD_ERR 
                DEC SI
                MOV [SI], '$'
                  
                LEA SI, REVERSE_DEC    
                LEA DI, REVERSE_DEC_OUT_HISTORY
                ADD DI, REVERSE_DEC_OUT_TRACKER
                
            COPY_TO_HISTORY_RD:
                MOV AL, [SI]
                MOV [DI], AL
                CMP AL, '$'
                JE ADD_NEWLINE_RD
                INC SI
                INC DI
                JMP COPY_TO_HISTORY_RD
                
            ADD_NEWLINE_RD:
             
                MOV [DI], '|'  
                INC DI
            
                
     
                MOV AX, DI
                SUB AX, OFFSET REVERSE_DEC_OUT_HISTORY
                MOV REVERSE_DEC_OUT_TRACKER, AX

     
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

    LEA DX, ENTER_MSG
    MOV AH, 9
    INT 21H
    
    LEA SI, ATBASH_ENC
    LEA DI, ATBASH_ENC_INP_HISTORY
    ADD DI, ATBASH_ENC_INP_TRACKER   
    
AE_INPUT_LOOP:
    MOV AH, 1
    INT 21H
    
    CMP AL, 13     
    JE AE_DONE_INPUT
    

    MOV [DI], AL
    INC DI
    
    ; Check if uppercase A-Z
    CMP AL, 'A'
    JB AE_CHECK_LOWERCASE
    CMP AL, 'Z'
    JA AE_CHECK_LOWERCASE
    
    ; Handle uppercase
    SUB AL, 'A'         
    NEG AL              
    ADD AL, 25          
    ADD AL, 'A'         
    JMP AE_STORE_CHAR
    
AE_CHECK_LOWERCASE:
    ; Check if lowercase a-z
    CMP AL, 'a'
    JB AE_STORE_CHAR    
    CMP AL, 'z'
    JA AE_STORE_CHAR    
    
    ; Handle lowercase
    SUB AL, 'a'         
    NEG AL              
    ADD AL, 25          
    ADD AL, 'a'         
    
AE_STORE_CHAR:
    MOV [SI], AL
    INC SI
    JMP AE_INPUT_LOOP
    
AE_DONE_INPUT:
   
    MOV [DI], '|'  
    INC DI

    
    ; Update input offset
    MOV AX, DI
    SUB AX, OFFSET ATBASH_ENC_INP_HISTORY
    MOV ATBASH_ENC_INP_TRACKER, AX
    
    MOV [SI], 'a'    ; Add identifier
    INC SI
    MOV [SI], '$'    ; Add terminator
    

    LEA SI, ATBASH_ENC        
    LEA DI, ATBASH_ENC_OUT_HISTORY
    ADD DI, ATBASH_ENC_OUT_TRACKER 
    
COPY_TO_HISTORY_AE:
    MOV AL, [SI]
    MOV [DI], AL
    CMP AL, '$'
    JE ADD_NEWLINE_AE
    INC SI
    INC DI
    JMP COPY_TO_HISTORY_AE
    
ADD_NEWLINE_AE:
    MOV [DI], '|'   
    INC DI

    

    MOV AX, DI
    SUB AX, OFFSET ATBASH_ENC_OUT_HISTORY
    MOV ATBASH_ENC_OUT_TRACKER, AX
    

    LEA DX, RESULT_MSG
    MOV AH, 9
    INT 21H
    
    LEA DX, ATBASH_ENC
    MOV AH, 9
    INT 21H
    
    JMP MENU
    RET
ATBASH_ENCRYPT ENDP

        
ATBASH_DECRYPT PROC
 
   LEA DX, ENTER_MSG
   MOV AH, 9
   INT 21H
   
   LEA SI, ATBASH_DEC
   LEA DI, ATBASH_DEC_INP_HISTORY
   ADD DI, ATBASH_DEC_INP_TRACKER   
   
AD_INPUT_LOOP:
   MOV AH, 1
   INT 21H
   
   CMP AL, 13      
   JE AD_DONE_INPUT
   

   MOV [DI], AL
   INC DI
   
   ; Check if uppercase A-Z
   CMP AL, 'A'
   JB AD_CHECK_LOWERCASE
   CMP AL, 'Z'
   JA AD_CHECK_LOWERCASE
   
   ; Handle uppercase
   SUB AL, 'A'         
   NEG AL              
   ADD AL, 25          
   ADD AL, 'A'         
   JMP AD_STORE_CHAR
   
AD_CHECK_LOWERCASE:
   ; Check if lowercase a-z
   CMP AL, 'a'
   JB AD_STORE_CHAR    
   CMP AL, 'z'
   JA AD_STORE_CHAR    
   
   ; Handle lowercase
   SUB AL, 'a'         
   NEG AL              
   ADD AL, 25          
   ADD AL, 'a'         
   
AD_STORE_CHAR:
   MOV [SI], AL
   INC SI
   JMP AD_INPUT_LOOP
   
AD_DONE_INPUT:

   MOV [DI], '|'
   INC DI

   

   MOV AX, DI
   SUB AX, OFFSET ATBASH_DEC_INP_HISTORY
   MOV ATBASH_DEC_INP_TRACKER, AX
   
   DEC SI
   CMP [SI], 'z'
   JNE AD_ERR
   MOV [SI], '$'   
   

   LEA SI, ATBASH_DEC        
   LEA DI, ATBASH_DEC_OUT_HISTORY
   ADD DI, ATBASH_DEC_OUT_TRACKER 
   
COPY_TO_HISTORY_AD:
   MOV AL, [SI]
   MOV [DI], AL
   CMP AL, '$'
   JE ADD_NEWLINE_AD
   INC SI
   INC DI
   JMP COPY_TO_HISTORY_AD
   
ADD_NEWLINE_AD:
   MOV [DI], '|'
   INC DI

   MOV AX, DI
   SUB AX, OFFSET ATBASH_DEC_OUT_HISTORY
   MOV ATBASH_DEC_OUT_TRACKER, AX
   

   LEA DX, RESULT_MSG
   MOV AH, 9
   INT 21H
   
   LEA DX, ATBASH_DEC
   MOV AH, 9
   INT 21H
   
   JMP MENU

AD_ERR:
   LEA DX, D_ERR
   MOV AH, 9
   INT 21H                            
   
   MOV [DI], 0AH   
   INC DI
   MOV [DI], 0DH   
   INC DI 
   
   MOV AX, DI
   SUB AX, OFFSET ATBASH_DEC_INP_HISTORY
   MOV ATBASH_DEC_INP_TRACKER, AX
   
   JMP MENU
   RET
ATBASH_DECRYPT ENDP


SHOW_HISTORY PROC
CALL CHECK_PASSWORD 


    LEA DX, HISTORY_PROMPT
    MOV AH, 9
    INT 21H

INVALIDMSG1:

    LEA DX, ENTER_MSG
    MOV AH, 9
    INT 21H

    MOV AH, 1
    INT 21H

    CMP AL, 31H
    JE SHOW_CAESAR
    CMP AL, 32H
    JE SHOW_REVERSE
    CMP AL, 33H
    JE SHOW_ATBASH 
 

    LEA DX, INVALID_MSG1   
    MOV AH, 9
    INT 21H
    JMP INVALIDMSG1
SHOW_CAESAR:

LEA DX, CAESAR
MOV AH,9
INT 21H




    LEA DX, CAESAR_ENC_INP_MSG
    MOV AH, 9
    INT 21H
    LEA DX, CAESAR_ENC_INP_HISTORY
    MOV AH, 9
    INT 21H
    

    LEA DX, CAESAR_ENC_OUT_MSG
    MOV AH, 9
    INT 21H
    LEA DX, CAESAR_ENC_OUT_HISTORY
    MOV AH, 9
    INT 21H
    

    LEA DX, CAESAR_DEC_INP_MSG
    MOV AH, 9
    INT 21H
    LEA DX, CAESAR_DEC_INP_HISTORY
    MOV AH, 9
    INT 21H
    

    LEA DX, CAESAR_DEC_OUT_MSG
    MOV AH, 9
    INT 21H
    LEA DX, CAESAR_DEC_OUT_HISTORY
    MOV AH, 9
    INT 21H
    JMP HISTORY_END

SHOW_REVERSE:       

LEA DX, REVERSE
MOV AH,9
INT 21H


    LEA DX, REVERSE_ENC_INP_MSG
    MOV AH, 9
    INT 21H
    LEA DX, REVERSE_ENC_INP_HISTORY
    MOV AH, 9
    INT 21H
    
    LEA DX, REVERSE_ENC_OUT_MSG
    MOV AH, 9
    INT 21H
    LEA DX, REVERSE_ENC_OUT_HISTORY
    MOV AH, 9
    INT 21H
    

    LEA DX, REVERSE_DEC_INP_MSG
    MOV AH, 9
    INT 21H
    LEA DX, REVERSE_DEC_INP_HISTORY
    MOV AH, 9
    INT 21H
    

    LEA DX, REVERSE_DEC_OUT_MSG
    MOV AH, 9
    INT 21H
    LEA DX, REVERSE_DEC_OUT_HISTORY
    MOV AH, 9
    INT 21H
    JMP HISTORY_END

SHOW_ATBASH:

LEA DX, ATBASH
MOV AH,9
INT 21H


    LEA DX, ATBASH_ENC_INP_MSG
    MOV AH, 9
    INT 21H
    LEA DX, ATBASH_ENC_INP_HISTORY
    MOV AH, 9
    INT 21H
    
    LEA DX, ATBASH_ENC_OUT_MSG
    MOV AH, 9
    INT 21H
    LEA DX, ATBASH_ENC_OUT_HISTORY
    MOV AH, 9
    INT 21H
    
   
    LEA DX, ATBASH_DEC_INP_MSG
    MOV AH, 9
    INT 21H
    LEA DX, ATBASH_DEC_INP_HISTORY
    MOV AH, 9
    INT 21H
    
   
    LEA DX, ATBASH_DEC_OUT_MSG
    MOV AH, 9
    INT 21H
    LEA DX, ATBASH_DEC_OUT_HISTORY
    MOV AH, 9
    INT 21H
    
    
HISTORY_END:
    JMP MENU
    
SHOW_HISTORY ENDP




            CHANGE_PASS PROC
               
                PUSH AX
                PUSH BX
                PUSH CX
                PUSH DX
                PUSH SI
                
                ; First verify old password
                LEA DX, PASS_PROMPT
                MOV AH, 9
                INT 21H
                
                
                MOV CX, 5          
                LEA SI, PASS_BUFFER
                
            GET_OLD_PASS:
                MOV AH, 1
                INT 21H
                MOV [SI], AL
                INC SI
                LOOP GET_OLD_PASS
                
                ; Compare with current password
                MOV CX, 5
                LEA SI, PASSWORD
                LEA DI, PASS_BUFFER
                
            VERIFY_OLD:
                MOV AL, [SI]
                MOV BL, [DI]
                CMP AL, BL
                JNE WRONG_OLD_PASS
                INC SI
                INC DI
                LOOP VERIFY_OLD
                
                ; If old password correct, get new password
                LEA DX, NEW_PASS_MSG
                MOV AH, 9
                INT 21H
                
               
                MOV CX, 5
                LEA SI, PASSWORD   
                
            GET_NEW_PASS:
                MOV AH, 1
                INT 21H
                MOV [SI], AL
                INC SI
                LOOP GET_NEW_PASS
                
                MOV [SI], '$'    
                
                LEA DX, PASS_CHANGED_MSG
                MOV AH, 9
                INT 21H
                
                
                POP SI
                POP DX
                POP CX
                POP BX
                POP AX
                JMP NEWPASSSTATE
            
            WRONG_OLD_PASS:
                LEA DX, WRONG_PASS_MSG
                MOV AH, 9
                INT 21H
                POP SI
                POP DX
                POP CX
                POP BX
                POP AX
                JMP MENU
                
            CHANGE_PASS ENDP
            
            EXIT_PROG:
                MOV AH, 4CH
                INT 21H
                
            
            END MAIN