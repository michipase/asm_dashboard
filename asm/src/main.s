.section .data

# ////////////////////////////////
# per compilare
# as --32 -o nomefile.o nomefile.s;ld -m elf_i386 -o nomefile nomefile.o;./nomefile 2224
# 
# manca una funzione per controllare che nel primo argomento (2224) ci sia effettivamente un numero (va in segmentation altrimenti) 
# (si potrebbe anche non fare data la natura del progetto ma siccome mi sembra una scusa la faro )
# 
# P.S nelle scelte progettuali dovremmo dire che per l'uscita dal sottomenu noi abbiamo scielto di usare "<" e invio invece che solo invio 
# 
# /////////////////////////////////
# serie di stinghe da stampare

settings:       .asciz "1. Setting automobile: "
date:           .asciz "2. Data: "
hours:          .asciz "3. Ora: "
doorlock:       .asciz "4. Blocco automatico porte: "
backhome:       .asciz "5. Back-home: "
oilcheck:       .asciz "6. Check olio "
blinkingarrow:  .asciz "7. Frecce direzione "
pressurereset:  .asciz "8. Reset pressione gomme "

# serie di valori 

dateVAL:            .asciz "15/06/2014"
hoursVAL:           .asciz "15:32"
doorlockVAL:        .byte 1
backhomeVAL:        .long 1
oilcheckOK:         .asciz "ok "
NumberOfBlink:      .asciz "3"
pressureresetOK:    .asciz "pressione gomme resettata"

Max:    .long 8

# costanti fi vario tipo  
SUP_code:   .asciz "2224"
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
    jl setmax

    movl (%ecx), %eax
    cmpl SUP_code, %eax     # Comparo con 2224
    je Printmenu            # se sono uguali lascio normali
    
    setmax:
    movl $6, Max            # altrimenti setto max a 6

    Printmenu:              # analogo alla funzione Printmenu

    movl CURSORE, %eax      # analogo allo switch case le varie etichette Print_stuff ==> Print("stuff");

    cmp $1, %eax
    je Print_settings

    cmp $2, %eax
    je Print_date

    cmp $3, %eax
    je Print_hours

    cmp $4, %eax
    je Print_doorlock

    cmp $5, %eax
    je Print_backhome

    cmp $6, %eax
    je Print_oilcheck

    cmp $7, %eax
    je Print_blinkingarrow

    cmp $8, %eax
    je Print_pressurereset

    jmp CURSORUPGRADE

CURSORUPGRADE:              # analogo alla sezione di codice dopo il Printmenu

    call GetArrowKey

    cmp $1, %eax            # ^ aumenta il CURSORE
    je Prev

    cmp $2, %eax            # v diminuisce il CURSORE
    je Next

    cmp $3, %eax
    je OpenMenu             # >  si avvia veso il sottomenu

    jmp Printmenu           # se non ha ricevuto una freccia ritorna a CURSOREUPGRADE analogo al while

# fine del main


# etichette analoghi a printf("....")#

Print_settings:
    mov $4, %eax
    mov $1, %ebx
    leal settings, %ecx
    mov $23,%edx
    int $0x80

    call print_newline  
    jmp CURSORUPGRADE

Print_date:
    mov $4, %eax
    mov $1, %ebx
    leal date, %ecx
    mov $9,%edx
    int $0x80

    mov $4, %eax
    mov $1, %ebx
    leal dateVAL, %ecx
    mov $10,%edx
    int $0x80

    call print_newline
    jmp CURSORUPGRADE

Print_hours:
    mov $4, %eax
    mov $1, %ebx
    leal hours, %ecx
    mov $8,%edx
    int $0x80

    mov $4, %eax
    mov $1, %ebx
    leal hoursVAL, %ecx
    mov $5,%edx
    int $0x80

    call print_newline
    jmp CURSORUPGRADE

Print_doorlock:
    mov $4, %eax
    mov $1, %ebx
    leal doorlock, %ecx
    mov $28,%edx
    int $0x80

    call print_newline
    jmp CURSORUPGRADE

Print_backhome:
    mov $4, %eax
    mov $1, %ebx
    leal backhome, %ecx
    mov $14,%edx
    int $0x80

    call print_newline
    jmp CURSORUPGRADE

Print_oilcheck:
    mov $4, %eax
    mov $1, %ebx
    leal oilcheck, %ecx
    mov $14,%edx
    int $0x80

    call print_newline
    jmp CURSORUPGRADE

Print_blinkingarrow:
    mov $4, %eax
    mov $1, %ebx
    leal blinkingarrow, %ecx
    mov $20,%edx
    int $0x80

    call print_newline
    jmp CURSORUPGRADE

Print_pressurereset:
    mov $4, %eax
    mov $1, %ebx
    leal pressurereset, %ecx
    mov $25,%edx
    int $0x80

    call print_newline
    jmp CURSORUPGRADE


# analoghi alle funzioni Prev e Next
Prev:           # riduce di uno se uguale a 1 lo porta al massimo  
    mov CURSORE, %eax
    cmp $1,%eax
    je CURSOREmin
    sub $1,%eax
    movl  %eax, CURSORE
    jmp Prevfin

  CURSOREmin:
    movl Max,%eax
    movl %eax,CURSORE
    jmp Prevfin

  Prevfin:
    jmp CURSORUPGRADE


Next:           # aumenta di uno se uguale al massimo lo mette a 1
    mov CURSORE,%eax
    cmp Max, %eax
    je CURSOREmax
    addl $1, CURSORE
    jmp Nextfin

  CURSOREmax:
    movl $1,CURSORE
    jmp Nextfin

  Nextfin:
    jmp CURSORUPGRADE


# funzioni

print_newline: # analogo a printf("\n")#
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
    jne not_arrow

    mov $'[', %eax           # Secondo carattere: '['
    cmpb %al, 1(%ecx)
    jne not_arrow

    mov $'D', %eax            # Terzo carattere: 'D' (freccia sinistra)
    cmpb %al, 2(%ecx)
    je left_arrow

    mov $'C', %eax            # Terzo carattere: 'C' (freccia destra)
    cmpb %al, 2(%ecx)
    je right_arrow

    mov $'A', %eax            # Terzo carattere: 'A' (freccia su)
    cmpb %al, 2(%ecx)
    je up_arrow

    mov $'B', %eax            # Terzo carattere: 'B' (freccia giù)
    cmpb %al, 2(%ecx)
    je down_arrow

  fine:             # torna dove è stata richiamata
    ret

  not_arrow:        
    mov $0, %eax
    jmp fine

  left_arrow:       
    mov $4, %eax
    jmp fine

  right_arrow:      
    mov $3, %eax
    jmp fine

  up_arrow:
    mov $1, %eax
    jmp fine

  down_arrow:
    mov $2, %eax
    jmp fine


OpenMenu:     # stampa  i sottomenu analogo a OpenMenu
    movl CURSORE, %eax

    cmp $1, %eax
    je OpenMenuFine

    cmp $2, %eax
    je Print_dateVAL

    cmp $3, %eax
    je Print_hoursVAL

    cmp $4, %eax
    je Print_doorlockVAL

    cmp $5, %eax
    je Print_backhomeVAL

    cmp $6, %eax
    je Print_oilcheckOK

    cmp $7, %eax
    je Print_blinkingarrowVAL

    cmp $8, %eax
    je Print_pressureresetOK

  OpenMenuFine:             # se non trova una freccia su/giu/sx resta in loop

    call GetArrowKey

    cmp $1, %eax
    je HandleSubmenuUP      # sotto menu +  analogo a HandleSubmenuUP

    cmp $2, %eax
    je HandleSubmenuDOWN    # sotto menu - analogo a HandleSubmenuDOWN

    cmp $4, %eax
    je CURSORUPGRADE        # esce dal sottomenu

    jmp OpenMenuFine


Print_dateVAL:

    mov $4, %eax
    mov $1, %ebx
    leal dateVAL, %ecx
    mov $10,%edx
    int $0x80

    call print_newline
    jmp OpenMenuFine

Print_hoursVAL:

    mov $4, %eax
    mov $1, %ebx
    leal hoursVAL, %ecx
    mov $5,%edx
    int $0x80

    call print_newline
    jmp OpenMenuFine

Print_doorlockVAL:  # potrebbe essere ottimizata (non di velocita ma di righe di testo) 

    cmpb $1, doorlockVAL    # controlla che il valore di dorlock sia 1 (0=OFF) 
    je printdoorlockVAL_ON
   
    mov  $4, %eax
    mov  $1, %ebx
    leal OFF, %ecx # stampa OFF
    mov  $3,%edx
    int  $0x80
   
    jmp  doorlockVALfin

    printdoorlockVAL_ON:    # altrimenti 

    mov $4, %eax
    mov $1, %ebx
    leal ON, %ecx # stampa ON
    mov $3,%edx
    int $0x80

doorlockVALfin:
    call print_newline
    jmp OpenMenuFine

Print_backhomeVAL:

    cmpb $1, backhomeVAL    # controlla che il valore di backhome sia 0 (0=OFF) 
    je printbackhomeVAL_ON
    mov  $4, %eax
    mov  $1, %ebx
    leal OFF, %ecx # stampa OFF
    mov  $3,%edx
    int  $0x80

    jmp  backhomeVALfin
printbackhomeVAL_ON:    # altrimenti 

    mov $4, %eax
    mov $1, %ebx
    leal ON, %ecx # stampa ON
    mov $3,%edx
    int $0x80

backhomeVALfin:
    call print_newline
    jmp OpenMenuFine

Print_oilcheckOK:

    mov $4, %eax
    mov $1, %ebx
    leal oilcheckOK, %ecx
    mov $3,%edx
    int $0x80

    call print_newline
    jmp OpenMenuFine

Print_blinkingarrowVAL:

    mov $4, %eax
    mov $1, %ebx
    leal NumberOfBlink, %ecx
    mov $1,%edx
    int $0x80

    call print_newline
    jmp OpenMenuFine

Print_pressureresetOK:

    mov $4, %eax
    mov $1, %ebx
    leal pressureresetOK, %ecx
    mov $25,%edx
    int $0x80

    call print_newline
    jmp OpenMenuFine

HandleSubmenuUP: 

    movl CURSORE, %eax
    
    cmp $4, %eax    # un semplice scambio della variabile dorlockVAL
    je DoorlockVAL_flip
    
    cmp $5, %eax     # un semplice scambio della variabile backhomeVAL
    je BackhomeVAL_flip
    
    cmp $7, %eax
    je more_arrow    # aggiunge uno al numero di freccie fino ad un massimo di 5 (le freccie sono considerate come un ascii)
    
    jmp OpenMenu    # defoult break

more_arrow: 
    movl $NumberOfBlink, %edi     # Carica l'indirizzo della stringa NumberOfBlink in %edi
    movb (%edi), %al              # Carica il carattere ASCII corrispondente al primo elemento della stringa in %al

    cmpb $'5', %al                # Confronta il valore con '5'
    jge SkipIncrement             # Salta all'etichetta SkipIncrement se è maggiore o uguale a '5'
    addb $1, %al                  # Incrementa il valore del carattere
    movb %al, (%edi)              # Salva il nuovo valore nella stringa NumberOfBlink
    
    SkipIncrement:
    jmp OpenMenu                 # Torna a OpenMenu

HandleSubmenuDOWN:

    movl CURSORE, %eax
    
    cmp $4, %eax    # un semplice scambio della variabile dorlockVAL
    je DoorlockVAL_flip
    
    cmp $5, %eax     # un semplice scambio della variabile backhomeVAL
    je BackhomeVAL_flip
    
    cmp $7, %eax
    je less_arrow    # sottrae uno al numero di freccie fino ad un minimo di due (le freccie sono considerate come un ascii)
    
    jmp OpenMenu    # defoult break
 

  less_arrow: 
    movl $NumberOfBlink, %edi     # Carica l'indirizzo della stringa NumberOfBlink in %edi
    movb (%edi), %al              # Carica il carattere ASCII corrispondente al primo elemento della stringa in %al

    cmpb $'2', %al                # Confronta il valore con '5'
    jle SkipDecrement             # Salta all'etichetta SkipIncrement se è minore o uguale a '2'

    subb $1, %al                  # Decrementa il valore del carattere
    movb %al, (%edi)              # Salva il nuovo valore nella stringa NumberOfBlink

    SkipDecrement:
    jmp OpenMenu                 # Torna a OpenMenu


DoorlockVAL_flip:                         
    movl doorlockVAL, %eax
    xorl $1, %eax               # lo xor con 1 permette di scambiare il valore di una variabile binaria
    movl %eax, doorlockVAL       
    jmp OpenMenu

BackhomeVAL_flip:
    movl backhomeVAL, %eax
    xorl $1, %eax   
    movl %eax, backhomeVAL
    jmp OpenMenu
