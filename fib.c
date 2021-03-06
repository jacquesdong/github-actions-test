#include "fib.h"

int fib(int number)
{
	return number <= 1 ? 1 : fib(number - 1) * number; // fail
}
