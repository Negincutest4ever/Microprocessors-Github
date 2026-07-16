/*
 *  C to assembler menu hook
 *
 *  Modified by nkarimi0397
 * 
 */

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>
#include "stm32f3_discovery_gyroscope.h"

#include "common.h"

int nkarimi0397_lab6(int delay);
int nkarimi0397_lab7();

void Lab6_nkarimi0397(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Lab 6\n\n"
	   "This command tests new lab 6 function by nkarimi0397\n"
	   );

    return;
  }

  int fetch_status;
  uint32_t user_wait;
  fetch_status = fetch_uint32_arg(&user_wait);
 if(fetch_status) {
    // Default fallback if the user didn't provide a argument
    user_wait = 0xFFFFEF; 
  }

  printf("nkarimi0397_lab6 returned: %d\n", nkarimi0397_lab6(user_wait) );
}

ADD_CMD("nkarimi0397_lab6", Lab6_nkarimi0397,"Test the new lab 6 function")

int nkarimi0397_a3(char *pattern_ptr);

void A3_nkarimi0397(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Assignment 3 Test\n\n"
	   "This is the A3 function by nkarimi0397\n"
	   );

    return;
  }

  int fetch_status;
  char *pattern;

  fetch_status = fetch_string_arg(&pattern);

  if (fetch_status) {
    // Default logic goes here
    pattern = "Test Pattern";
  }

  printf("nkarimi0397_a3 returned: %d\n", nkarimi0397_a3(pattern) );
}

ADD_CMD("nkarimi0397_a3", A3_nkarimi0397,"Run A3 for nkarimi0397")

void Lab7_nkarimi0397(int action)

{

if(action==CMD_SHORT_HELP) return;

if(action==CMD_LONG_HELP) {

printf("Lab 6\n\n"

"This command tests new lab 7 function by nkarimi0397\n"

);

return;

}

float xyz[3] = {0};

BSP_GYRO_GetXYZ(xyz);

printf("Gyroscope returns:\n"

" X: %f\n"

" Y: %f\n"

" Z: %f\n",

xyz[0] / 256,

xyz[1] / 256,

xyz[2] / 256);

printf("nkarimi0397_lab7 returned: %d\n", nkarimi0397_lab7() );

}

ADD_CMD("nkarimi0397_lab7", Lab7_nkarimi0397,"Test the new lab 7 function")