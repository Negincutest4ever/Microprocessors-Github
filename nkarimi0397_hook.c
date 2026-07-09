/*
 *  C to assembler menu hook
 *
 *  Modified by jsmith1234
 * 
 */

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"

int jsmith1234_lab6(int x, int y);

void Lab6_jsmith1234(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Lab 6\n\n"
	   "This command tests new lab 6 function by jsmith1234\n"
	   );

    return;
  }
  printf("jsmith1234_lab6 returned: %d\n", jsmith1234_lab6(99, 87) );
}

ADD_CMD("jsmith1234_lab6", Lab6_jsmith1234,"Test the new lab 6 function")

int jsmith1234_a3(char *pattern_ptr);

void A3_jsmith1234(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Assignment 3 Test\n\n"
	   "This is the A3 function by jsmith1234\n"
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

  printf("jsmith1234_a3 returned: %d\n", jsmith1234_a3(pattern) );
}

ADD_CMD("jsmith1234_a3", A3_jsmith1234,"Run A3 for jsmith1234")
