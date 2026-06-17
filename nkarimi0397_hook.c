/*
 *	C to assembler menu hook
 * 
 */

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"

int nkarimi0397_add_test(int x, int y, int delay);

int nkarimi0397_string_test(char *p);

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
