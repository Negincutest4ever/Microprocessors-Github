/*
 *  C to assembler menu hook
 *
 *  Modified by nkarimi0397
 * 
 */

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"

int nkarimi0397_lab6(int x, int y);

void Lab6_nkarimi0397(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Lab 6\n\n"
	   "This command tests new lab 6 function by nkarimi0397\n"
	   );

    return;
  }
  printf("nkarimi0397_lab6 returned: %d\n", nkarimi0397_lab6(99, 87) );
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
