/*
 * nkarimi0397_hook.c)
 */

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"

int nkarimi0397_add_test(int x, int y, int delay);

int nkarimi0397_string_test(char *p);

int nkarimi0397_a2(int num, int wait);

int nkarimi0397_a4(int status, int num_to_skip, int direction);

void _nkarimi0397_Assignment2(int action)
{
  if(action == CMD_SHORT_HELP) return;
  if(action == CMD_LONG_HELP) {
    printf("Assignment 2\n\n"
           "Usage: nkarimi0397_a2 <num> <wait>\n"
           "  num  = number of loop cycles (loops through all 8 LEDs)\n"
           "  wait = delay value passed to busy_delay\n");
    return;
  }uint32_t user_num;
  uint32_t user_wait;
  int fetch_status;

  fetch_status = fetch_uint32_arg(&user_num);
  if(fetch_status) {
    // Default fallback if the user didn't provide a first argument
    user_num = 3; 
  }

  fetch_status = fetch_uint32_arg(&user_wait);
  if(fetch_status) {
    // Default fallback if the user didn't provide a second argument
    user_wait = 0xFFFFEF; 
  }

  int total_toggles = nkarimi0397_a2(user_num, user_wait);

  printf("nkarimi0397_a2 returned: %d\n", total_toggles);
}

ADD_CMD("nkarimi0397_a2", _nkarimi0397_Assignment2, "Assignment 2")


void nkarimi0397_StringTest(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("String Test\n\n"
  "This command tests new string function by nkarimi0397\n"
  );

    return;
  }

  int fetch_status;
  char *destptr;

  fetch_status = fetch_string_arg(&destptr);

  if (fetch_status) {
    // Default logic goes here
  }

  printf("string_test returned: %d\n", nkarimi0397_string_test(destptr) );
}

ADD_CMD("nkarimi0397_string", nkarimi0397_StringTest,"Test the new string function")

void AddTest(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Addition Test\n\n"
  "This command tests new addition function by jsmith1234\n"
  );

    return;
  }

  uint32_t delay;

  int fetch_status;

  fetch_status = fetch_uint32_arg(&delay);

  if(fetch_status) {
  // Use a default delay value
  delay = 0xFFFFFF;
  }

  // When we call our function, pass the delay value.
  // printf(“<<< here is where we call add_test – can you add a third parameter? >>>”);

  printf("nkarimi0397_add_test returned: %d\n", nkarimi0397_add_test(99, 87, delay) );
}

ADD_CMD("nkarimi0397_add", AddTest,"Test the new add function")


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

void mes_InitIWDG(int reload);
void mes_IWDGStart(void);
void mes_IWDGRefresh(void);
void Lab10_jsmith1234(int action)
{
if(action==CMD_SHORT_HELP) return;
if(action==CMD_LONG_HELP) {
printf("Lab 10\n\n"
"This command tests new lab 8 function by jsmith1234\n"
);
return;
}
printf("Initializing Watchdog\n");
mes_InitIWDG(9999);
printf("Starting Watchdog\n");
mes_IWDGStart();
}
ADD_CMD("jsmith1234_lab10", Lab10_jsmith1234,"Test the new lab 10 function")