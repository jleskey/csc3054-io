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

.text
.global main
main:
