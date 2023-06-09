.section .data

.section .text
.global _start:

_start:
    # comparo la varibile CURSORE con 0->max 
    cmp CURSORE, $1 
    je Print_settings

    cmp CURSORE, $2 
    je Print_date

    cmp CURSORE, $3 
    je Print_hours

    cmp CURSORE, $4 
    je Print_doorlock

    cmp CURSORE, $5 
    je Print_Backhome

    cmp CURSORE, $6 
    je Print_oilcheck

    cmp CURSORE, $7 
    je Print_blinkingarrow

    cmp CURSORE, $8 
    je Print_pressurereset


# blocco di modifica del CURSORE
CURSOREupgrade:
# ...
# scanf 
# se == > entra nel sottomenu 
; sottomenu(cursore)

# se uguale a ^ 
; if CURSORE==0,movl max,CURSORE
; else CURSORE--,
jmp _start

# se uguale a v 
; if CURSORE==max,movl $0,CURSORE
; else c++
jmp _start


# sottomenu
# -  if CURSORE == numero utile 
# -  fai roba 
# -  tutti i sottomenu finiscono con 
# -  goto start
# -  altrimenti go to 
# -  CURSOREupgrade

Print_settings:
    movl $4, %eax           # sys write
    movl $1, %ebx           # unsigned_int
    leal settings, %ecx     # roba da stampare
    movl settingsl,%edx     # lunghezza della variabile

    int $0x80
    jmp CURSOREupgrade

