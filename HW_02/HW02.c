#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// Problem 2
//char** copyStrArray(int count, char **strArray){
//	char **copy;
//	int i;
//	copy = (char **) malloc(count*sizeof(char *));
//	for(i=0; i<count; i++){
//		copy[i] = (char *) malloc((strlen(*strArray)+1)*sizeof(char));
//		strcpy(copy[i],strArray[i]);
//	}
//	return copy;
//}
//Problem 3a
//char* upcase(char* str){
//	char* p;
//	char* result;
//	result = (char*) malloc(sizeof(char)*sizeof(str));
//	strcpy(result,str);
//	for(p=result; *p!='\0'; p++){
//		if(*p > 90)
//			*p = *p - 32;
//		else
//			*p = *p + 32;	
//	}
//	return result;
//}
//Problem 3b
void upcase_by_ref(char** n){	
}

void upcase_name(char* names[], int i){
	upcase_by_ref(&(names[i]));
}
main(){
	char** names;
	names[0] = "Turtle";
	names[1] = "Neko";
	names[2] = "Pig";
	names[3] = "Inu";
//	upcase_name(names,3);
	printf("%s\n",names[0]);

}

