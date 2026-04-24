.section .text.init
    .global _start

_start:
    li sp, 1024 

    call main

halt:
    j halt