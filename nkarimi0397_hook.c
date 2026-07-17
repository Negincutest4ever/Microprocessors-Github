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
int nkarimi0397_lab7(int delay);

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

int nkarimi0397_a3(int delay, char *pattern_ptr, int num);

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
  uint32_t wait;
  uint32_t num;
  char *pattern;

  fetch_status = fetch_uint32_arg(&wait);
  if(fetch_status) {
    // Default fallback if the user didn't provide a argument
    wait = 0xFFFFEF; 
  }

  fetch_status = fetch_string_arg(&pattern);
  if(fetch_status) {
    // Default fallback if the user didn't provide a argument
    pattern = "Negin"; 
  }

  fetch_status = fetch_uint32_arg(&num);
  if(fetch_status) {
    // Default fallback if the user didn't provide a argument
    num = 5; 
  }


  if (fetch_status) {
    // Default logic goes here
    pattern = "Test Pattern";
  }

  printf("nkarimi0397_a3 returned: %d\n", nkarimi0397_a3(wait, pattern, num) );
}

ADD_CMD("nkarimi0397_a3", A3_nkarimi0397,"Run A3 for nkarimi0397")

void Lab7_nkarimi0397(int action)
{
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Lab 7\n\n"
     "This command tests new lab 7 function by nkarimi0397\n"
     );
    return;
  }

  int fetch_status;
  uint32_t user_count;
  uint32_t user_delay;
  uint32_t user_mode;

  fetch_status = fetch_uint32_arg(&user_count);
  if (fetch_status) {
    user_count = 10;          // default loop count
  }

  fetch_status = fetch_uint32_arg(&user_delay);
  if (fetch_status) {
    user_delay = 0xFFFFFF;    // default delay
  }

  fetch_status = fetch_uint32_arg(&user_mode);
  if (fetch_status) {
    user_mode = 0;           // default: print all three axes
  }

  int i;
  for (i = 0; i < (int)user_count; i++) {

    float xyz[3] = {0};
    BSP_GYRO_GetXYZ(xyz);

    switch (user_mode) {
      case 1:
        printf("Gyroscope returns:\n"
               " X: %f\n",
               xyz[0] / 256);
        break;

      case 2:
        printf("Gyroscope returns:\n"
               " Y: %f\n",
               xyz[1] / 256);
        break;

      case 3:
        printf("Gyroscope returns:\n"
               " Z: %f\n",
               xyz[2] / 256);
        break;

      case 0:
      default:
        printf("Gyroscope returns:\n"
               " X: %f\n"
               " Y: %f\n"
               " Z: %f\n",
               xyz[0] / 256,
               xyz[1] / 256,
               xyz[2] / 256);
        break;
    }

    printf("nkarimi0397_lab7 returned: %d\n", nkarimi0397_lab7((int)user_delay) );
  }
}

ADD_CMD("nkarimi0397_lab7", Lab7_nkarimi0397,"Test the new lab 7 function")