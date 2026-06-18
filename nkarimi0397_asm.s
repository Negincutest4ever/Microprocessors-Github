@ Test code for my own new function called from C
@ nkarimi0937_asm.s Data section - initialized values
.data

.align 3    @ This alignment is critical - to access our "huge" value, it must
            @ be 64 bit aligned

huge:   .octa 0xAABBCCDDDDCCBBFF
big:    .word 0xAAEEBBFF
num:    .byte 0xAB


str2:   .asciz "Guten Tag!"
count:  .word 12345                     @ This is an initialized 32 bit value

@ End of new data section

@ This is a comment. Anything after an @ symbol is ignored.
@@ This is also a comment. Some people use double @@ symbols. 


    .code   16              @ This directive selects the instruction set being generated. 
                            @ The value 16 selects Thumb, with the value 32 selecting ARM.

    .text                   @ Tell the assembler that the upcoming section is to be considered
                            @ assembly language instructions - Code section (text -> ROM)

@@ Function Header Block
    .align  2               @ Code alignment is 2^n alignment (n=2)
    .syntax unified         @ Sets the instruction set to the unified ARM + THUMB
    .global nkarimi0397_a2   @ Make the symbol name for the function visible to the linker
    .code   16              @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func             @ Specifies that the following symbol is the name of a THUMB
    .type   nkarimi0397_a2, %function   @ Declares that the symbol is a function (not strictly required)

@ Function Declaration : int nkarimi0397_a2 (int num, int wait)
@
@ Input: Document This
@ Returns: Document This
@ 

nkarimi0397_a2:

    mov r4, r0      
    mov r5, r1     
    mov r6, #0      

BigLoop:
    cmp r4, #0
    ble Done

    mov r7, #0      

LightLoop:
    cmp r7, #8
    bge NextCycle

    mov r0, r5
    bl busy_delay

    mov r0, r7
    bl BSP_LED_Toggle

    add r6, r6, #1  
    add r7, r7, #1  

    b LightLoop

NextCycle:
    sub r4, r4, #1
    b BigLoop

Done:
    mov r0, r6      @ return count
    bx lr


@@ Function Header Block
    .align  2               @ Code alignment - 2^n alignment (n=2)
                            @ This causes the assembler to use 4 byte alignment

    .syntax unified         @ Sets the instruction set to the new unified ARM + THUMB
                            @ instructions. The default is divided (separate instruction sets)

    .global nkarimi0397_add_test        @ Make the symbol name for the function visible to the linker

    .code   16              @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func             @ Specifies that the following symbol is the name of a THUMB
                            @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type   nkarimi0397_add_test, %function   @ Declares that the symbol is a function (not strictly required)

@ Function Declaration : int nkarimi0397_add_test (int x, int y)
@
@ Input: r0, r1 (i.e. r0 holds x, r1 holds y)
@ Returns: r0
@ 

@ Here is the actual nkarimi0397_add_test function
nkarimi0397_add_test:

        @ Load the addresses of each of our items
    ldr r0, =num
    ldr r0, =big
    ldr r0, =huge
    ldr r0, =str2

    ldr r2, =str2			@ Load the address of str2 and store it in r2
    ldrb r0, [r2]			@ Load the value stored at the address str2 as a byte

    ldr r2, =str2			@ Load the address of str2 and store it in r2
    ldr r0, [r2]			@ Load the value stored at the address str2 as a word

    ldr r2, =num			@ Load the address of num and store it in r2
    ldrb r0, [r2]			@ Load the value stored at the address num

    ldr r2, =big			@ Load the address of big
    ldr r0, [r2]			@ Load the value of big

    ldr r2, =huge			@ Load the address of huge
    ldrd r0, r1, [r2]		@ Load the value of huge

    add r0, r0, r1      @ compute x + y

    push {r0, lr}       @ save result and return address

    mov r0, r2          @ pass delay to busy_delay
    bl busy_delay

    pop {r0, lr}        @ restore result and return address

    bx lr
    .size   nkarimi0397_add_test, .- nkarimi0397_add_test @@ - symbol size (makes the debugger happy)

.global nkarimi0397_string_test

@ Function Declaration : int nkarimi0397_string_test(char *p)
@
@ Input: r0 (i.e. r0 a pointer to a byte array)
@ Returns: r0
@ 

@ Here is the actual function
nkarimi0397_string_test:

    StringLoop:

    ldrb r1, [r0]    @ Load the value pointed to by R0 into R1 as shown above
    cmp r1, #0       @ Check if that value is zero – if it is, branch out
    beq OutLabel
    add r0, r0, #1  @ Add one to R0
    b StringLoop    @ Branch back to string loop

    OutLabel:

    bx lr                @Return the value of R0

    .size   nkarimi0397_string_test, .-nkarimi0397_string_test

@ Function Declaration : int busy_delay(int cycles)
@
@ Input: r0 (i.e. r0 holds number of cycles to delay)
@ Returns: r0
@ 

@ Here is the actual function. DO NOT MODIFY THIS FUNCTION.
busy_delay:

    push {r6}

    mov r6, r0

delay_label:
    subs r6, r6, #1

    bge delay_label

    mov r0, #0                      @ Always return zero (success)

    pop {r6}

    bx lr                           @ Return (Branch eXchange) to the address in the link register (lr)

@ Assembly file ended by single .end directive on its own line
.end

Things past the end directive are not processed, as you can see here.
***** DO NOT PUT ANYTHING BELOW THE .end DIRECTIVE, IT WILL BE IGNORED! *****
