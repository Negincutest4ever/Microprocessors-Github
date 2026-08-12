/*
 * nkarimi0397_hook.c)
 */

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"

int nkarimi0397_add_test(int x, int y, int delay);

int nkarimi0397_string_test(char *p);

int nkarimi0397_a4(int status, int num_to_skip, int direction);

int nkarimi0397_a5(int status, int num_to_skip, int direction);

void mes_InitIWDG(int reload);

void mes_IWDGStart(void);

void mes_IWDGRefresh(void);

// Declare assembly functions in C
extern void nkarimi0397_a4_btn(void);
extern void nkarimi0397_a4_tick(void);
extern void nkarimi0397_a5_tick(void);

// Provide the expected handlers that main.c calls
void nkarimi0397_btn(void) {
    nkarimi0397_a4_btn();
}

void nkarimi0397_tick(void) {
    nkarimi0397_a5_tick();
}


void _nkarimi0397_Assignment4(int action)
{
  if(action == CMD_SHORT_HELP) return;
  if(action == CMD_LONG_HELP) {
    printf("Assignment 4\n\n"
           "Usage: nkarimi0397_a4 <status> <num_to_skip> <direction>\n"
           "  status      = >0 starts the LED game, <=0 stops it\n"
           "  num_to_skip = number of tick calls to skip between actions\n"
           "  direction   = +1 to count up through the LEDs, -1 to count\n"
           "                down, 0 to leave the direction unchanged\n");
    return;
  }

  uint32_t user_status;
  uint32_t user_num_to_skip;
  uint32_t user_direction;
  int fetch_status;

  fetch_status = fetch_uint32_arg(&user_status);
  if(fetch_status) {
    // Default fallback if the user didn't provide a status - start running
    user_status = 1;
  }

  fetch_status = fetch_uint32_arg(&user_num_to_skip);
  if(fetch_status) {
    // Default fallback if the user didn't provide a skip count
    user_num_to_skip = 5;
  }

  fetch_status = fetch_uint32_arg(&user_direction);
  if(fetch_status) {
    // Default fallback if the user didn't provide a direction
    user_direction = 1;
  }

  int result = nkarimi0397_a4(user_status, user_num_to_skip, user_direction);

  printf("nkarimi0397_a4 returned: %d\n", result);
}

ADD_CMD("nkarimi0397_a4", _nkarimi0397_Assignment4, "Assignment 4")


void _nkarimi0397_Assignment5(int action)
{
  if(action == CMD_SHORT_HELP) return;
  if(action == CMD_LONG_HELP) {
    printf("Assignment 5\n\n"
           "Usage: nkarimi0397_a5 <status> <num_to_skip> <direction>\n"
           "  status      = >0 starts the LED game, <=0 stops it\n"
           "  num_to_skip = number of tick calls to skip between actions\n"
           "  direction   = +1 to count up through the LEDs, -1 to count\n"
           "                down, 0 to leave the direction unchanged\n");
    return;
  }

  uint32_t user_status;
  uint32_t user_num_to_skip;
  uint32_t user_direction;
  int fetch_status;

  fetch_status = fetch_uint32_arg(&user_status);
  if(fetch_status) {
    // Default fallback if the user didn't provide a status - start running
    user_status = 1;
  }

  fetch_status = fetch_uint32_arg(&user_num_to_skip);
  if(fetch_status) {
    // Default fallback if the user didn't provide a skip count
    user_num_to_skip = 5;
  }

  fetch_status = fetch_uint32_arg(&user_direction);
  if(fetch_status) {
    // Default fallback if the user didn't provide a direction
    user_direction = 1;
  }

  int result = nkarimi0397_a5(user_status, user_num_to_skip, user_direction);

  printf("nkarimi0397_a5 returned: %d\n", result);
}

ADD_CMD("nkarimi0397_a5", _nkarimi0397_Assignment5, "Assignment 5")


void Lab10_nkarimi0397(int action)
{
if(action==CMD_SHORT_HELP) return;
if(action==CMD_LONG_HELP) {
printf("Lab 10\n\n"
"This command tests new lab 8 function by nkarimi0397\n"
);
return;
}
printf("Initializing Watchdog\n");
mes_InitIWDG(9999);
printf("Starting Watchdog\n");
mes_IWDGStart();
}
ADD_CMD("nkarimi0397_lab10", Lab10_nkarimi0397,"Test the new lab 10 function")
