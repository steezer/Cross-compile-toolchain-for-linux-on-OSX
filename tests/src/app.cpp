#include <iostream>
// #include <stcpp/basic.hpp>
#include <stdio.h>
#include <math.h>

extern "C" {
	int subup(int a, int b);
}

int main(int argc, char const *argv[])
{
	printf("sin(23): %lf\n", sin(23));
	printf("subup(2, 3): %d\n", subup(2, 3));
	std::cout << "Successfully!" << std::endl;
	//printf("%ld\n", Stcpp::getTime());
	return 0;
}