/*
 *	C to assembler menu hook
 * 
 */

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"

int nkarimi0397_add_test(int x, int y);

void AddTest(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Addition Test\n\n"
	   "This command tests new addition function by jsmith1234\n"
	   );

    return;
  }
  printf("nkarimi0397_add_test returned: %d\n", nkarimi0397_add_test(99, 87) );
}

ADD_CMD("nkarimi0397_add", AddTest,"Test the new add function")
