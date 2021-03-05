#define CATCH_CONFIG_MAIN

#include <catch.hpp>

extern "C" {
#include <fib.h>
}

TEST_CASE( "Factorial of 0 is 1 (fail)", "[single-file]" ) {
    REQUIRE( fib(0) == 1 );
}

TEST_CASE( "Factorials of 1 and higher are computed (pass)", "[single-file]" ) {
    REQUIRE( fib(1) == 1 );
    REQUIRE( fib(2) == 2 );
    REQUIRE( fib(3) == 6 );
    REQUIRE( fib(10) == 3628800 );
}
