.section .data

# ////////////////////////////////
# per compilare
# as --32 -o nomefile.o nomefile.s;ld -m elf_i386 -o nomefile nomefile.o;./nomefile 2224
# oppure
# make build
# /////////////////////////////////
# serie di stinghe da stampare

settings:       .asciz "1. Setting automobile: "
date:           .asciz "2. Data: "
hours:          .asciz "3. Ora: "
doorLock:       .asciz "4. Blocco automatico porte: "
backHome:       .asciz "5. Back-home: "
oilCheck:       .asciz "6. Check olio "
ArrowBlinks:    .asciz "7. Frecce direzione "
pressureReset:  .asciz "8. Reset pressione gomme "

# serie di valori 

date_VAL:            .asciz "15/06/2014"
hours_VAL:           .asciz "15:32"
doorLock_VAL:        .byte 1
backHome_VAL:        .long 1
oilCheck_VAL:        .asciz "ok "
arrowBlinks_VAL:     .asciz "3"
pressureReset_VAL:   .asciz "pressione gomme resettata"

MAX:    .long 8

# costanti fi vario tipo  
ADMIN_CODE: .asciz "2224"
ON:         .asciz "ON "
OFF:        .asciz "OFF"
buffer:     .space 3
CURSORE:    .long 1
newline:    .asciz "\n "

.section .text
.global _start

_start:
    popl %ecx        # Prepara la chiamata di sistema per leggere gli argomenti della riga di comando (casto 3 volte perchè mi interessa il 3 elemento)
    popl %ecx            
    popl %ecx
    cmp $1, %ecx
    jl setMAX

    movl (%ecx), %eax
    cmpl ADMIN_CODE, %eax     # Comparo con 2224
    je PrintMenu            # se sono uguali lascio normali
    
    setMAX:
    movl $6, MAX            # altrimenti setto MAX a 6

    PrintMenu:              # analogo alla funzione PrintMenu

    movl CURSORE, %eax      # analogo allo switch case le varie etichette Print_stuff ==> Print("stuff");

    cmp $1, %eax
    je PrintSettings

    cmp $2, %eax
    je PrintDate

    cmp $3, %eax
    je PrintHours

    cmp $4, %eax
    je PrintDoorLock

    cmp $5, %eax
    je PrintBackHome

    cmp $6, %eax
    je PrintOilCheck

    cmp $7, %eax
    je PrintArrowBlinks

    cmp $8, %eax
    je PrintPressureReset

    jmp CURSOR_UPDATE

CURSOR_UPDATE:              # analogo alla sezione di codice dopo il PrintMenu

    call GetArrowKey

    cmp $1, %eax            # ^ aumenta il CURSORE
    je Prev

    cmp $2, %eax            # v diminuisce il CURSORE
    je Next

    cmp $3, %eax
    je OpenMenu             # >  si avvia veso il sottomenu

    jmp PrintMenu           # se non ha ricevuto una freccia ritorna a CURSOREUPGRADE analogo al while

# End del main


# etichette analoghi a printf("....")#

PrintSettings:
    mov $4, %eax
    mov $1, %ebx
    leal settings, %ecx
    mov $23,%edx
    int $0x80

    call PrintNewline  
    jmp CURSOR_UPDATE

PrintDate:
    mov $4, %eax
    mov $1, %ebx
    leal date, %ecx
    mov $9,%edx
    int $0x80

    mov $4, %eax
    mov $1, %ebx
    leal date_VAL, %ecx
    mov $10,%edx
    int $0x80

    call PrintNewline
    jmp CURSOR_UPDATE

PrintHours:
    mov $4, %eax
    mov $1, %ebx
    leal hours, %ecx
    mov $8,%edx
    int $0x80

    mov $4, %eax
    mov $1, %ebx
    leal hours_VAL, %ecx
    mov $5,%edx
    int $0x80

    call PrintNewline
    jmp CURSOR_UPDATE

PrintDoorLock:
    mov $4, %eax
    mov $1, %ebx
    leal doorLock, %ecx
    mov $28,%edx
    int $0x80

    call PrintNewline
    jmp CURSOR_UPDATE

PrintBackHome:
    mov $4, %eax
    mov $1, %ebx
    leal backHome, %ecx
    mov $14,%edx
    int $0x80

    call PrintNewline
    jmp CURSOR_UPDATE

PrintOilCheck:
    mov $4, %eax
    mov $1, %ebx
    leal oilCheck, %ecx
    mov $14,%edx
    int $0x80

    call PrintNewline
    jmp CURSOR_UPDATE

PrintArrowBlinks:
    mov $4, %eax
    mov $1, %ebx
    leal ArrowBlinks, %ecx
    mov $20,%edx
    int $0x80

    call PrintNewline
    jmp CURSOR_UPDATE

PrintPressureReset:
    mov $4, %eax
    mov $1, %ebx
    leal pressureReset, %ecx
    mov $25,%edx
    int $0x80

    call PrintNewline
    jmp CURSOR_UPDATE


# analoghi alle funzioni Prev e Next
Prev:           # riduce di uno se uguale a 1 lo porta al massimo  
    mov CURSORE, %eax
    cmp $1,%eax
    je CURSORE_min
    sub $1,%eax
    movl  %eax, CURSORE
    jmp Prev_fin

  CURSORE_min:
    movl MAX,%eax
    movl %eax,CURSORE
    jmp Prev_fin

  Prev_fin:
    jmp CURSOR_UPDATE


Next:           # aumenta di uno se uguale al massimo lo mette a 1
    mov CURSORE,%eax
    cmp MAX, %eax
    je CURSOREMAX
    addl $1, CURSORE
    jmp Next_fin

  CURSOREMAX:
    movl $1,CURSORE
    jmp Next_fin

  Next_fin:
    jmp CURSOR_UPDATE


# funzioni

PrintNewline: # analogo a printf("\n")#
    mov $4, %eax
    mov $1, %ebx
    leal newline, %ecx
    mov $3,%edx

    int $0x80
    ret

GetArrowKey:        # analogo alla funzione GetArrowKey solo che invece di passare le frecce passo un numero nel registro eax 
    mov $3, %eax
    mov $0, %ebx
    mov $buffer, %ecx
    mov $3, %edx
    int $0x80

    mov $0x1b, %eax          # Primo carattere: 0x1B (^)
    cmpb %al, (%ecx)
    jne NotArrow

    mov $'[', %eax           # Secondo carattere: '['
    cmpb %al, 1(%ecx)
    jne NotArrow

    mov $'D', %eax            # Terzo carattere: 'D' (freccia sinistra)
    cmpb %al, 2(%ecx)
    je LeftArrow

    mov $'C', %eax            # Terzo carattere: 'C' (freccia destra)
    cmpb %al, 2(%ecx)
    je RightArrow

    mov $'A', %eax            # Terzo carattere: 'A' (freccia su)
    cmpb %al, 2(%ecx)
    je UpArrow

    mov $'B', %eax            # Terzo carattere: 'B' (freccia giù)
    cmpb %al, 2(%ecx)
    je DownArrow

  End:             # torna dove è stata richiamata
    ret

  NotArrow:        
    mov $0, %eax
    jmp End

  LeftArrow:       
    mov $4, %eax
    jmp End

  RightArrow:      
    mov $3, %eax
    jmp End

  UpArrow:
    mov $1, %eax
    jmp End

  DownArrow:
    mov $2, %eax
    jmp End


OpenMenu:     # stampa  i sottomenu analogo a OpenMenu
    movl CURSORE, %eax

    cmp $1, %eax
    je OpenMenuEnd

    cmp $2, %eax
    je PrintDate_VAL

    cmp $3, %eax
    je PrintHours_VAL

    cmp $4, %eax
    je PrintDoorLock_VAL

    cmp $5, %eax
    je PrintBackHome_VAL

    cmp $6, %eax
    je PrintOilCheck_VAL

    cmp $7, %eax
    je PrintArrowBlinks_VAL

    cmp $8, %eax
    je PrintPressureReset_VAL

  OpenMenuEnd:             # se non trova una freccia su/giu/sx resta in loop

    call GetArrowKey

    cmp $1, %eax
    je HandleSubmenuUP      # sotto menu +  analogo a HandleSubmenuUP

    cmp $2, %eax
    je HandleSubmenuDOWN    # sotto menu - analogo a HandleSubmenuDOWN

    cmp $4, %eax
    je CURSOR_UPDATE        # esce dal sottomenu

    jmp OpenMenuEnd


PrintDate_VAL:

    mov $4, %eax
    mov $1, %ebx
    leal date_VAL, %ecx
    mov $10,%edx
    int $0x80

    call PrintNewline
    jmp OpenMenuEnd

PrintHours_VAL:

    mov $4, %eax
    mov $1, %ebx
    leal hours_VAL, %ecx
    mov $5,%edx
    int $0x80

    call PrintNewline
    jmp OpenMenuEnd

PrintDoorLock_VAL:  # potrebbe essere ottimizata (non di velocita ma di righe di testo) 

    cmpb $1, doorLock_VAL    # controlla che il valore di dorlock sia 1 (0=OFF) 
    je printdoorLock_VAL_ON
   
    mov  $4, %eax
    mov  $1, %ebx
    leal OFF, %ecx # stampa OFF
    mov  $3,%edx
    int  $0x80
   
    jmp  doorLock_VALfin

    printdoorLock_VAL_ON:    # altrimenti 

    mov $4, %eax
    mov $1, %ebx
    leal ON, %ecx # stampa ON
    mov $3,%edx
    int $0x80

doorLock_VALfin:
    call PrintNewline
    jmp OpenMenuEnd

PrintBackHome_VAL:

    cmpb $1, backHome_VAL    # controlla che il valore di backHome sia 0 (0=OFF) 
    je PrintBackHome_VAL_ON
    mov  $4, %eax
    mov  $1, %ebx
    leal OFF, %ecx # stampa OFF
    mov  $3,%edx
    int  $0x80

    jmp  backHome_VALfin
PrintBackHome_VAL_ON:    # altrimenti 

    mov $4, %eax
    mov $1, %ebx
    leal ON, %ecx # stampa ON
    mov $3,%edx
    int $0x80

backHome_VALfin:
    call PrintNewline
    jmp OpenMenuEnd

PrintOilCheck_VAL:

    mov $4, %eax
    mov $1, %ebx
    leal oilCheck_VAL, %ecx
    mov $3,%edx
    int $0x80

    call PrintNewline
    jmp OpenMenuEnd

PrintArrowBlinks_VAL:

    mov $4, %eax
    mov $1, %ebx
    leal arrowBlinks_VAL, %ecx
    mov $1,%edx
    int $0x80

    call PrintNewline
    jmp OpenMenuEnd

PrintPressureReset_VAL:

    mov $4, %eax
    mov $1, %ebx
    leal pressureReset_VAL, %ecx
    mov $25,%edx
    int $0x80

    call PrintNewline
    jmp OpenMenuEnd

HandleSubmenuUP: 

    movl CURSORE, %eax
    
    cmp $4, %eax    # un semplice scambio della variabile dorlockVAL
    je Flip_doorLock_VAL
    
    cmp $5, %eax     # un semplice scambio della variabile backHome_VAL
    je Flip_backHome_VAL
    
    cmp $7, %eax
    je ArrowBlink_Increment    # aggiunge uno al numero di freccie fino ad un massimo di 5 (le freccie sono considerate come un ascii)
    
    jmp OpenMenu    # defoult break

ArrowBlink_Increment: 
    movl $arrowBlinks_VAL, %edi     # Carica l'indirizzo della stringa arrowBlinks_VAL in %edi
    movb (%edi), %al              # Carica il carattere ASCII corrispondente al primo elemento della stringa in %al

    cmpb $'5', %al                # Confronta il valore con '5'
    jge SkipIncrement             # Salta all'etichetta SkipIncrement se è maggiore o uguale a '5'
    addb $1, %al                  # Incrementa il valore del carattere
    movb %al, (%edi)              # Salva il nuovo valore nella stringa arrowBlinks_VAL
    
    SkipIncrement:
    jmp OpenMenu                 # Torna a OpenMenu

HandleSubmenuDOWN:

    movl CURSORE, %eax
    
    cmp $4, %eax    # un semplice scambio della variabile dorlockVAL
    je Flip_doorLock_VAL
    
    cmp $5, %eax     # un semplice scambio della variabile backHome_VAL
    je Flip_backHome_VAL
    
    cmp $7, %eax
    je ArrowBlink_Decrement    # sottrae uno al numero di freccie fino ad un minimo di due (le freccie sono considerate come un ascii)
    
    jmp OpenMenu    # defoult break
 

  ArrowBlink_Decrement: 
    movl $arrowBlinks_VAL, %edi     # Carica l'indirizzo della stringa arrowBlinks_VAL in %edi
    movb (%edi), %al              # Carica il carattere ASCII corrispondente al primo elemento della stringa in %al

    cmpb $'2', %al                # Confronta il valore con '5'
    jle SkipDecrement             # Salta all'etichetta SkipIncrement se è minore o uguale a '2'

    subb $1, %al                  # Decrementa il valore del carattere
    movb %al, (%edi)              # Salva il nuovo valore nella stringa arrowBlinks_VAL

    SkipDecrement:
    jmp OpenMenu                 # Torna a OpenMenu


Flip_doorLock_VAL:                         
    movl doorLock_VAL, %eax
    xorl $1, %eax               # lo xor con 1 permette di scambiare il valore di una variabile binaria
    movl %eax, doorLock_VAL       
    jmp OpenMenu

Flip_backHome_VAL:
    movl backHome_VAL, %eax
    xorl $1, %eax   
    movl %eax, backHome_VAL
    jmp OpenMenu
