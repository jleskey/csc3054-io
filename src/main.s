.equ    STDIN,      0
.equ    STDOUT,     1
.equ    SYS_READ,   63
.equ    SYS_WRITE,  64
.equ    SYS_EXIT,   93

.section .rodata
prompt_a:   .asciz  "Input a: "
prompt_b:   .asciz  "Input b: "
prompt_c:   .asciz  "Input c: "
label_f:    .asciz  "The result of f = a + b - c is "
end:        .asciz  ".\n"

.data
buffer:     .space  11

.text
.global main

main:
    la      a0, prompt_a
    jal     inputInt

    mv      s2, a0

    la      a0, prompt_b
    jal     inputInt

    add     s2, s2, a0

    la      a0, prompt_c
    jal inputInt

    sub     s2, s2, a0

    j exit

# int inputInt : Prompt user for an integer
# a0 <string *prompt> : the prompt address
inputInt:
    mv      s1, ra                          # s0: saved return address
    jal print
    jal readInt
    mv      ra, s1                          # ra: restored return address
    ret


# int readInt : Read integer from user input
readInt:
    li      a7, SYS_READ                    # a7: system call
    li      a0, STDIN                       # a0: file descriptor
    la      a1, buffer                      # a1: buffer address
    li      a2, 11                          # Accept 11 characters.
    ecall

    li      a0, 0                           # a0 (return): entered integer
    la      t0, buffer                      # t0: buffer address
    la      t1, '\n'                        # t1: newline character
    la      t2, 10                          # t2: decimal place multiplier

    readIntLoop:
        lb      t3, 0(t0)                   # t3: current character code
        beq     t3, t1, readIntExit
        beqz    t3, readIntExit
        addi    t3, t3, -48                 # t3: current digit
        mul     a0, a0, t2
        add     a0, a0, t3
        addi    t0, t0, 1
        j       readIntLoop
    readIntExit:
        ret

# int print : Print the given string
# a0 <string *value> : the string address
print:
    mv      s0, ra                          # s1: saved return address
    mv      a1, a0                          # a1: string address

    jal     measureString
    mv      a2, a0                          # a2: length of string

    li      a7, SYS_WRITE                   # a7: system call
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
    li      a0, 0                           # a0: exit code
    li      a7, SYS_EXIT                    # a7: system call
    ecall
