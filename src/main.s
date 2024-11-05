.equ    STDIN,      0
.equ    STDOUT,     1
.equ    SYS_READ,   63
.equ    SYS_WRITE,  64

.section .rodata
prompt_a:   .asciz  "Input a: "
prompt_b:   .asciz  "Input b: "
prompt_c:   .asciz  "Input c: "
label_f:    .asciz  "The result of f = a + b - c is "
end:        .asciz  ".\n"

.text
.global main

main:
    j exit

# int inputWord : Prompt user for an integer
# a0 <string *prompt> : the prompt address
inputWord:
    nop

# int print : Print the given string
# a0 <string *value> : the string address
print:
    mv      s0, ra                          # s0: saved return address
    mv      a1, a0                          # a1: string address

    jal     measureString
    mv      a2, a0                          # a2: length of string

    li      a7, SYS_WRITE                   # a7: syscall
    li      a0, STDOUT                      # a0: file descriptor

    ecall

    mv      ra, s0                          # ra: restored return address
    ret

# int measureString : Get length of given string
# a0 <string *value> : the string address
measureString:
    li      t0, 0                           # t0: counter
    measureStringLoop:
        lb      t1, 0(a0)                   # t1: character in string
        beqz    t1, measureStringExit
        addi    t0, t0, 1
        addi    a0, a0, 1
        j       measureStringLoop
    measureStringExit:
        mv      a0, t0                      # a0 (return): length of string
        ret

exit:
    li      a0, 0
    li      a7, 93
    ecall
