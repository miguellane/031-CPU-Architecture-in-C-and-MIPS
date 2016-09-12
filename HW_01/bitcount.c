/*
	Miguel Lane
	Thursday: 7:30am
*/

#include <stdio.h>

int bitCount(unsigned int n);

int main (int argc, char* args[]) {
	if(argc > 2)
		printf("Too many arguments!\n");
	else if(argc == 2){
		char* endptr;
		unsigned int arg =(unsigned int) strtoul(args[1],&endptr,10);
		printf ("# 1-bits in base 2 representation of %u = %d\n",
			arg, bitCount(arg));		
	}
	else{
		printf ("# 1-bits in base 2 representation of %u = %d, should be 0\n",
			0, bitCount (0));
		printf ("# 1-bits in base 2 representation of %u = %d, should be 1\n",
			1, bitCount (1));
		printf ("# 1-bits in base 2 representation of %u = %d, should be 16\n",
			2863311530u, bitCount (2863311530u));
		printf ("# 1-bits in base 2 representation of %u = %d, should be 1\n",
			536870912, bitCount (536870912));
		printf ("# 1-bits in base 2 representation of %u = %d, should be 32\n",
			4294967295u, bitCount (4294967295u));
		return 0;
	}
}
int bitCount (unsigned int n) {
	int bits = 0;
	while(n != 0){
		if(n & 1)
			bits++;
		n >>= 1;
	}
	return bits;
}