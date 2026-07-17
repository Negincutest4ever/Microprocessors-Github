@ Test code for my own new function called from C

@ This is a comment. Anything after an @ symbol is ignored.
@@ This is also a comment. Some people use double @@ symbols. 


    .code   16              @ This directive selects the instruction set being generated. 
                            @ The value 16 selects Thumb, with the value 32 selecting ARM.

    .text                   @ Tell the assembler that the upcoming section is to be considered
                            @ assembly language instructions - Code section (text -> ROM)

@@ Function Header Block
    .align  2               @ Code alignment - 2^n alignment (n=2)
                            @ This causes the assembler to use 4 byte alignment

    .syntax unified         @ Sets the instruction set to the new unified ARM + THUMB
                            @ instructions. The default is divided (separate instruction sets)

    .global nkarimi0397_lab6        @ Make the symbol name for the function visible to the linker

    .code   16              @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func             @ Specifies that the following symbol is the name of a THUMB
                            @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type   nkarimi0397_lab6, %function   @ Declares that the symbol is a function (not strictly required)

@ Function Declaration : int nkarimi0397_lab6(int x, int y)
@
@ Input: r0, r1 (i.e. r0 holds x, r1 holds y)
@ Returns: r0
@ 

@ Here is the actual nkarimi0397_lab6 function
nkarimi0397_lab6:
        push {r4, r5, r6, lr}    @ save callee-saved regs + lr

        mov  r5, r0              @ r5 = delay value from caller
        mov  r4, #7              @ r4 = loop index, start at 7
        mov  r6, #0              @ r6 = toggle counter, start at 0

    loop_top:
        cmp  r4, #0
        bge  no_reset            @ if index >= 0, skip reset
        mov  r4, #7              @ else reset index to 7

    no_reset:
        mov  r0, r4
        bl   BSP_LED_Toggle      @ toggle LED at current index

        add  r6, r6, #1          @ toggle counter++

        sub  r4, r4, #1          @ decrement loop index

        mov  r0, r5
        bl   busy_delay          @ delay for user-specified amount

        bl   BSP_PB_GetState     @ check button state -> r0
        cmp  r0, #1              @ 1 = pressed (adjust if your BSP is inverted)
        beq  loop_done

        b    loop_top

    loop_done:
        mov  r0, r6              @ return toggle counter
        pop  {r4, r5, r6, lr}
        bx   lr

    .size   nkarimi0397_lab6, .-nkarimi0397_lab6    @@ - symbol size (not strictly required, but makes the debugger happy)


@@ Function Header Block

.global nkarimi0397_lab7
 
@ Make the symbol name for the function visible to the linker

.type nkarimi0397_lab7, %function
 
@ Declares that the symbol is a function (not strictly required)

@ Function Declaration : int nkarimi0397_lab7(int delay)
@
@ Input: r0 (r0 holds the delay value)
@ Returns: r0
@

nkarimi0397_lab7:

    push {lr}

    @ r0 already contains the delay value passed by the caller,
    @ so we can call busy_delay directly with it
    bl   busy_delay

    @ Get the state of the user button here.
    @ Return the result to the calling C function

    pop {lr}

    bx lr
    @ Return (Branch eXchange) to the address in the link register (lr)

    .size nkarimi0397_lab7, .-nkarimi0397_lab7
 
@@ - symbol size (not strictly required)

.global nkarimi0397_a3
.type   nkarimi0397_a3, %function

@ Function Declaration: int nkarimi0397_a3(char *pattern_ptr)
@
@ Input: r0 (i.e. r0 is a pointer to the first character of the pattern)
@ Returns: r0
@ 

@ Function Declaration: int nkarimi0397_a3(int delay, char *pattern_ptr, int num)
@
@ Input:   r0 = delay value, passed unscaled directly to busy_delay
@          r1 = pointer to first character of the pattern string (null-terminated)
@          r2 = maximum number of full pattern repeats before stopping
@ Returns: r0 = total number of times BSP_LED_Toggle was called
@

nkarimi0397_a3:
    push {r4, r5, r6, r7, r8, lr}

    mov  r5, r0
    mov  r4, r1
    mov  r6, r2
    mov  r8, #0

repeat_loop:
    cmp  r6, #0
    beq  a3_done

    mov  r7, r4

char_loop:
    ldrb r0, [r7]
    cmp  r0, #0
    beq  repeat_finished

    sub  r0, r0, #'0'
    and  r0, r0, #7
    bl   BSP_LED_Toggle

    add  r8, r8, #1

    mov  r0, r5
    bl   busy_delay

    bl   BSP_PB_GetState
    cmp  r0, #1
    beq  a3_done

    add  r7, r7, #1
    b    char_loop

repeat_finished:
    sub  r6, r6, #1
    b    repeat_loop

a3_done:
    mov  r0, r8
    pop  {r4, r5, r6, r7, r8, lr}
    bx   lr

.size nkarimi0397_a3, .-nkarimi0397_a3

@ Here is the actual function. DO NOT MODIFY THIS FUNCTION
busy_delay:
    push {r6}
    mov r6, r0

    d3lay_loop:
        subs r6, r6, #1
        bge d3lay_loop

        mov r0, #0      @ Return zero (success)

    pop {r6}
    bx lr               @ Return to calling function


@ Assembly file ended by single .end directive on its own line
.end

Things past the end directive are not processed, as you can see here.
