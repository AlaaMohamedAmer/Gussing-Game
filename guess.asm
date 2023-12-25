.model small
.stack 100h
.data
 
    number      db  169d    
    newNumber1  db  123d 
    newNumber2  db  150d
    newNumber3  db  140d
    
    CR equ  13d
    LF equ  10d
 
    EnterNum    db  CR, LF,'Please enter a number : $'
    lessMsg     db  CR, LF,'Number if Less ','$'
    moreMsg     db  CR, LF,'Number is More ', '$'
    equalMsg    db  CR, LF,'Oh! You guessed right this time', '$'
    overflowMsg db  CR, LF,'Number out of range!', '$'
    new         db  CR, LF,'Do you want to guess a new number ? [y/n] ' ,'$'
    retry       db  CR, LF,'Retry ? [y/n] ' ,'$'
 
    guess       db  0d      
    errorChk    db  0d      
 
.code
    MAIN PROC FAR
        start:
            .STARTUP
            MOV ax, 0h
            MOV bx, 0h
            MOV cx, 0h
            MOV dx, 0h
         
            LEA BX, errorChk 
            MOV BYTE PTR [BX], 0d  
           
            LEA BX, guess    
            MOV BYTE PTR [BX], 0d  
         
            LEA dx, EnterNum   
            MOV ah, 9h              
            INT 21h                 
         
        while:
         
            CMP     cl, 4d          
            JG      endwhile     
         
            MOV     ah, 01h        
            INT     21h             
         
            CMP     al, 0Dh         
            JE      endwhile        
            
            SUB     al, 30h         
            MOV     dl, al          
            PUSH    dx              
            INC     cl              
         
            JMP while          
         
        endwhile:
         
            DEC cl                  
         
            CMP cl, 02h             
            JG  overflow            
         
            LEA BX, errorChk 
            MOV BYTE PTR [BX], cl   
         
            MOV cl, 0h            

        while2:
         
            CMP cl, errorChk
            JG endwhile2
         
            POP dx                  
         
            MOV ch, 0h              
            MOV al, 1d              
            MOV dh, 10d             
         
        while3:
         
            CMP ch, cl              
            JGE endwhile3           
         
            MUL dh                  
         
            INC ch                  
            JMP while3
         
         endwhile3:
         
            MUL dl                  
         
            JO  overflow            
         
            MOV dl, al              
            ADD dl, guess           
         
            JC  overflow            
            
            LEA BX, guess    
            MOV BYTE PTR [BX], dl   
         
            INC cl                 
         
            JMP while2            
         
        endwhile2:
            
            MOV al, number          
            MOV ah, guess           
         
            CMP ah, al              
         
            JC greater                        
            JG lower 
            JE equal     
         
        equal:
         
            LEA dx,equalMsg 
            MOV ah, 09h              
            INT 21h               
            JMP exit               
         
        greater:
         
            LEA dx, moreMsg  
            MOV ah, 09h              
            INT 21h                 
            JMP start               
         
        lower:
         
            LEA dx,lessMsg  
            MOV ah, 9h              
            INT 21h                
            JMP start              
         
        overflow:
         
            LEA dx, overflowMsg 
            MOV ah, 09h             
            INT 21h               
            JMP start             
         
        exit:
            
        retry_while:
         
            LEA dx, retry    
         
            MOV ah, 09h             
            INT 21h              
         
            MOV ah, 01h             
            INT 21h               
         
            CMP al, 6Eh           
            JE Close      
         
            CMP al, 79h            
            
            LEA dx, new      
         
            MOV ah, 09h              
            INT 21h                
         
            MOV ah, 01h             
            INT 21h            
         
            CMP al, 6Eh             
            JE restart           
         
            CMP al, 79h            
            
            JE restart2                               
         
            JMP retry_while        
         
        retry_endwhile:
            
        restart:
            JMP start     
            
        restart2:
            
            
            MOV dl, newNumber1   
            LEA BX, number   
            MOV BYTE PTR [BX], dl
            
            MOV dl, newNumber2
            LEA BX, newNumber1
            MOV BYTE PTR [BX], dl
            
            MOV dl, newNumber3
            LEA BX, newNumber2
            MOV BYTE PTR [BX], dl
            
            MOV dl, number
            LEA BX, newNumber3
            MOV BYTE PTR [BX], dl
            
            
            JMP start               
         Close:
            
          .EXIT      
     MAIN ENDP
END MAIN  