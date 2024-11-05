.section .rodata
prompt_a:
    .asciz "Input a: "
prompt_b:
    .asciz "Input b: "
prompt_c:
    .asciz "Input c: "
label_f:
    .asciz "The result of f = a + b - c is "
newline:
    .asciz "\n"

.data
var_a:
    .word 0
var_b:
    .word 0
var_c:
    .word 0
var_f:
    .word 0

.text
.global main
main:
