@ Assembly File - Lab 8 Version
@
@ NOTE THERE IS A DATA SECTION AT THE END OF THIS FILE FOR ASSIGNMENT 4.
@ USE THAT DATA SECTION FOR ANY DATA YOU NEED, DO NOT ADD ANOTHER.

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

    .global nkarimi0397_lab8        @ Make the symbol name for the function visible to the linker

    .code   16              @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func             @ Specifies that the following symbol is the name of a THUMB
                            @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type   nkarimi0397_lab8, %function   @ Declares that the symbol is a function (not strictly required)

@ Function Declaration : void nkarimi0397_lab8(void)
@Input: none
@ Returns: nothing
@

@ Here is the actual nkarimi0397_lab8 function
nkarimi0397_lab8:
    push {lr}

    @ For now, this function just toggles, delays, and toggles again.
    mov r0, #3
    bl BSP_LED_Toggle

    ldr r0, =0xFFFFFFF
    bl busy_delay

    mov r0, #3@
    bl BSP_LED_Toggle

    pop {lr}
    bx lr                           @ Return (Branch eXchange) to the address in the link register (lr)
    .size   nkarimi0397_lab8, .-nkarimi0397_lab8    @@ - symbol size (not strictly required, but makes the debugger happy)




.global nkarimi0397_a4
.type   nkarimi0397_a4, %function
@ Function Declaration : int nkarimi0397_a4(int status, int num_to_skip, int direction)
@
@ Input:
@   r0 = status      -> greater than zero means "run", zero or negative means "stop"
@   r1 = num_to_skip -> number of tick calls to skip between taking an action
@   r2 = direction   -> +1 to count up through LEDs, -1 to count down,
@                        0 means "leave the direction unchanged"
@ Returns: r0 = 0 (always succeeds)
@
@ This function is called from the menu each time the user runs the A4 command.
@ It stores the parameters supplied by the user into memory so that the tick
@ function (called from the timer interrupt) can use them later. If the
@ status indicates the game should start running, all 8 LEDs are cleared
@ so we start from a known, consistent state.

@ Here is the actual function
nkarimi0397_a4:
    push {r4, r5, r6, r7, lr}       @ Save callee-saved regs we use, and lr for our bl calls

    mov r4, r0                      @ r4 = status (keep across the BSP_LED_Off calls below)
    mov r5, r1                      @ r5 = num_to_skip
    mov r6, r2                      @ r6 = direction

    @ Store the value we received indicating the running state
    ldr r1, =a4_is_running
    str r4, [r1]

    @ Store how many ticks to skip between actions
    ldr r1, =a4_num_to_skip
    str r5, [r1]

    @ Only overwrite the stored direction if the user passed a non-zero value
    cmp     r6, #0
    beq     a4_skip_direction_update
        ldr r1, =a4_direction
        str r6, [r1]
    a4_skip_direction_update:

    @ Reset the skip counter so the new settings start "fresh"
    ldr r1, =a4_skip_count
    mov r0, #0
    str r0, [r1]

    @ Reset the current LED index back to LED 0
    ldr r1, =a4_current_led
    mov r0, #0
    str r0, [r1]

    @ If we are starting the game (status > 0), turn off all 8 LEDs first
    cmp     r4, #0
    ble     a4_init_done

        mov r7, #0                  @ r7 = LED index for the clear loop
        a4_led_off_loop:
            mov r0, r7
            bl  BSP_LED_Off
            add r7, r7, #1
            cmp r7, #8
            blt a4_led_off_loop

    a4_init_done:

    mov r0, #0                      @ Return success
    pop {r4, r5, r6, r7, lr}
    bx lr
    .size   nkarimi0397_a4, .-nkarimi0397_a4


.global nkarimi0397_a5
.type   nkarimi0397_a5, %function
@ Function Declaration : int nkarimi0397_a5(int status, int num_to_skip)
@
@ Input:
@   r0 = status      -> greater than zero means "run", zero or negative means "stop"
@   r1 = num_to_skip -> number of tick calls to skip between taking an action
@ Returns: r0 = 0 (always succeeds)
@
@ This function is called from the menu each time the user runs the A5 command.
@ It stores the parameters supplied by the user into memory so that the tick
@ function (called from the timer interrupt) can use them later. If the
@ status indicates the game should start running (status > 0), the watchdog
@ is (re)initialized with a reload of 8000 and started right here, so A5 is
@ fully self-contained and does not depend on any other command having been
@ run first.
@
@ NOTE: there is no "direction" parameter for A5. Unlike A4, A5 always
@ toggles the same fixed group of 4 corner LEDs together (see
@ nkarimi0397_a5_tick) rather than walking a single LED around a ring, so
@ there is nothing for a direction to control.

@ Here is the actual function
nkarimi0397_a5:
    push {r4, r5, lr}                @ Save callee-saved regs we use, and lr for our bl calls

    mov r4, r0                       @ r4 = status (keep across the mes_IWDGStart call below)
    mov r5, r1                       @ r5 = num_to_skip

    @ Store the value we received indicating the running state
    ldr r1, =a5_running
    str r4, [r1]

    @ Store how many ticks to skip between actions
    ldr r1, =a5_num_to_skip
    str r5, [r1]

    @ Reset the skip counter so the new settings start "fresh"
    ldr r1, =a5_skip_count
    mov r0, #0
    str r0, [r1]

    @ If we are starting (status > 0), initialize and start the watchdog
    @ ourselves - this is what makes A5 usable without running any other
    @ command first.
    cmp     r4, #0
    ble     a5_watchdog_done

        mov r0, #8000
        bl mes_InitIWDG
        bl mes_IWDGStart

    a5_watchdog_done:

    mov r0, #0                      @ Return success
    pop {r4, r5, lr}
    bx lr
    .size   nkarimi0397_a5, .-nkarimi0397_a5


.global nkarimi0397_a5_btn
.type   nkarimi0397_a5_btn, %function

@ Function Declaration : void nkarimi0397_a5_btn(void)
@
@ Input: None
@ Returns: Nothing
@
@ Reminder - this requires the button has been initialized as an interrupt
@ in main.c using BSP_PB_Init(BUTTON_USER, BUTTON_MODE_EXTI)
@ as well as requires a new function set up void EXTI0_IRQHandler(void)
@
@ Unlike A4's button handler, A5's button handler does exactly one thing:
@ record that the button was pressed by setting a5_btn_pressed to 1. The
@ A5 tick function checks this flag to decide whether to keep refreshing
@ the watchdog.

@ Here is the actual function
nkarimi0397_a5_btn:
    push {lr}

    ldr r1, =a5_btn_pressed          @ Get the address of the flag
    mov r0, #1                       @ We only ever set it to 1
    str r0, [r1]                     @ Record that the button was pressed

    pop {lr}
    bx lr
    .size   nkarimi0397_a5_btn, .-nkarimi0397_a5_btn
.global nkarimi0397_a4_tick
.type   nkarimi0397_a4_tick, %function

@ Function Declaration : void nkarimi0397_a4_tick(void)
@
@ Input: None
@ Returns: Nothing
@
@ Called repeatedly from the timer interrupt. Each call represents one
@ "tick". If A4 is running, we count ticks until we reach num_to_skip,
@ then we take a single action (toggle the current LED and move to the
@ next one according to the stored direction) and start counting again.
@ If A4 is not running, this function does nothing.

@ Here is the actual function
nkarimi0397_a4_tick:
    push {r4, r5, lr}

    @ ***** Get something
    ldr r1, =a4_is_running
    ldr r0, [r1]

    @ ***** Check something
    cmp r0, #0
    ble a4_skip

        @ This part below is skipped if A4 is NOT running. You will want to
        @ keep all your A4 logic inside here.
        @ DO NOT PUT LOGIC FOR A4 ABOVE THIS LINE -----------------------------

        @ Even within this logic, you should still take a philosopy of check
        @ things, do things, and store things - do not use delays of any sort,
        @ and only use loops if they are bounded (that is, guaranteed to end)

        @ ***** Check if it is time to act, or if we should keep waiting
        ldr r1, =a4_skip_count
        ldr r0, [r1]                @ r0 = current skip count
        ldr r2, =a4_num_to_skip
        ldr r3, [r2]                 @ r3 = number of ticks we need to skip

        cmp r0, r3
        blt a4_tick_wait             @ Not yet time to act - just count this tick

            @ ***** Do something - it is time to act, reset the skip counter
            mov r0, #0
            str r0, [r1]

            @ Toggle the LED at our current index
            ldr r4, =a4_current_led
            ldr r0, [r4]
            bl  BSP_LED_Toggle

            @ ***** Store something - move to the next LED index
            ldr r5, =a4_direction
            ldr r1, [r5]             @ r1 = +1 or -1
            ldr r0, [r4]             @ r0 = current LED index
            add r0, r0, r1           @ Move index one step in the chosen direction
            and r0, r0, #7           @ Wrap the index so it stays between 0 and 7
            str r0, [r4]

            b a4_tick_done

        a4_tick_wait:
            @ Not time to act yet - just increment the skip counter and wait
            add r0, r0, #1
            str r0, [r1]

        a4_tick_done:

        @ DO NOT PUT LOGIC FOR A4 BELOW THIS LINE -----------------------------
        @ End of A4 skipped logic. Do not add logic below here.

    a4_skip:

    @ ***** End of our tick function
    pop {r4, r5, lr}
    bx lr
    .size   nkarimi0397_a4_tick, .-nkarimi0397_a4_tick


.global nkarimi0397_a5_tick
.type   nkarimi0397_a5_tick, %function

@ Function Declaration : void nkarimi0397_a5_tick(void)
@
@ Input: None
@ Returns: Nothing
@
@ Here is the actual function nkarimi0397_a5_tick:
nkarimi0397_a5_tick:
    push {lr}

    @ As a starting point, this function implements the basics needed
    @ to determine if our A5 logic should run or not.
    @
    @ You will have to add logic here for A5.
    @ Some useful notes
    @
    @ DO NOT REFRESH THE WATCHDOG WITH mes_IWDGRefresh UNLESS IT
    @ HAS PREVIOUSLY BEEN STARTED OR YOUR BOARD WILL CRASH

    @ ***** Get something
    ldr r1, =a5_running
    ldr r0, [r1]

    @ ***** Check something
    cmp r0, #0
    ble a5_skip

        @ This part below is skipped if A5 is NOT running. You will want to
        @ keep all your A5 logic inside here.
        @ DO NOT PUT LOGIC FOR A5 ABOVE THIS LINE -----------------------------

        @ Even within this logic, you should still take a philosophy of check
        @ things, do things, and store things - do not use delays of any sort,
        @ and only use loops if they are bounded (that is, guaranteed to end)

        @ ***** Check if it is time to act, or if we should keep waiting
        @ (this was missing before - without it, the LEDs toggled every
        @ single tick no matter what num_to_skip was set to)
        ldr r1, =a5_skip_count
        ldr r0, [r1]                @ r0 = current skip count
        ldr r2, =a5_num_to_skip
        ldr r3, [r2]                @ r3 = number of ticks we need to skip

        cmp r0, r3
        blt a5_tick_wait             @ Not yet time to act - just count this tick

            @ ***** Do something - it is time to act, reset the skip counter
            mov r0, #0
            str r0, [r1]

            @ ***** Direct memory addressing - toggle all 4 corner LEDs at once
            @ Upper Left, Upper Right, Lower Left, Lower Right are on GPIOE,
            @ same port/register used in nkarimi0397_lab9 for the cardinal LEDs.
            @ Cardinal LEDs (N/E/S/W) sit on PE9/PE11/PE13/PE15 (mask 0xAA00),
            @ so the four corner LEDs (UL/UR/LL/LR) sit on the other four pins
            @ in the ring: PE8/PE10/PE12/PE14 (mask 0x5500).
            ldr r1, =0x48001014      @ GPIOE_ODR address
            ldr r0, [r1]             @ Read current output state
            ldr r2, =0x5500          @ UL | UR | LL | LR bit mask
            eor r0, r0, r2           @ Toggle just those 4 bits
            str r0, [r1]             @ Write new output state back

            b a5_tick_toggle_done

        a5_tick_wait:
            @ Not time to act yet - just increment the skip counter and wait
            add r0, r0, #1
            str r0, [r1]

        a5_tick_toggle_done:

        @ ***** Keep the watchdog fed while A5 is running - unless the
        @ button has been pressed, in which case we deliberately stop
        @ refreshing so the watchdog eventually times out and reboots.
        @ NOTE: nkarimi0397_a5 initializes and starts the watchdog itself
        @ before this tick function is ever reached, so it is safe to
        @ refresh here.
        ldr r1, =a5_btn_pressed
        ldr r0, [r1]
        cmp r0, #0
        bne a5_skip_refresh
            bl mes_IWDGRefresh
        a5_skip_refresh:

        @ DO NOT PUT LOGIC FOR A5 BELOW THIS LINE -----------------------------
        @ End of A5 skipped logic. Do not add logic below here.

    a5_skip:

    @ ***** Exit
    pop {lr}
    bx lr
    .size   nkarimi0397_a5_tick, .-nkarimi0397_a5_tick

    @@ Function Header Block

.global nkarimi0397_lab9
 
@ Make the symbol name for the function visible to the linker

.type nkarimi0397_lab9, %function

@ Function Declaration : int nkarimi0397_lab9(void)

@

@ Input: None

@ Returns: r0

@

@ Here is the actual nkarimi0397_lab9 function

nkarimi0397_lab9:
    nkarimi0397_lab9:
    push {lr}

    @ GPIOE_ODR address
    ldr r0, =0x48001014

    @ Read current output state
    ldr r1, [r0]

    @ Toggle North, East, South, West LEDs
    @ PE9 | PE11 | PE13 | PE15 = 0xAA00
    eor r1, r1, #0xAA00

    @ Write new output state
    str r1, [r0]

    mov r0, #0

    pop {lr}
    bx lr
 
@ Return (Branch eXchange) to the address in the link register (lr)

.size nkarimi0397_lab9, .-nkarimi0397_lab9
 
@@ - symbol size (not strictly required)


@ Function Declaration : int busy_delay(int cycles)
@
@ Input: r0 (i.e. r0 is how many cycles to delay)
@ Returns: r0
@

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


@ Here is another data section, we will use it for some key interrupt items
@ We will put all necessary data for A4 in this block
.data
a4_is_running: .word 0
a4_button_count: .word 0
a4_num_to_skip: .word 0        @ How many ticks to skip between actions
a4_direction: .word 1          @ +1 = count up, -1 = count down (default: up)
a4_current_led: .word 0        @ Index (0-7) of the LED we are currently on
a4_skip_count: .word 0         @ How many ticks have elapsed since our last action

a5_running: .word 0            @ 0 = A5 stopped, non-zero = A5 running (used by nkarimi0397_a5_tick)
a5_num_to_skip: .word 0        @ How many ticks to skip between actions
a5_skip_count: .word 0         @ How many ticks have elapsed since our last action
a5_btn_pressed: .word 0        @ 0 = button not yet pressed, 1 = pressed (set by nkarimi0397_a5_btn)


@ Assembly file ended by single .end directive on its own line
.end
