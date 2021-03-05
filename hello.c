#include <stdio.h>
#include <stdlib.h>

#include "fib.h"

int main(int argc, char* argv[])
{
	for (int i = 1; i < argc; i++)
	{
		int n = atoi(argv[i]);
		printf("fib(%d) = %d!\n", n, fib(n));
	}
}
