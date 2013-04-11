#include <stdio.h>
extern struct Node* root;
extern FILE* yyin;
//extern yylineno;

int main(int argc, char** argv){
	printf("-----------");
	printf("%s",argv[1]);
	if(argc < 1)
		return 1;
	FILE* file = fopen(argv[1],"r");
	
	if (!file){
		perror(argv[1]);
		return 1;
	}
	//yyrestart(file);
	yyin = file;
	yyparse();
	
	//print();
	return 0;
}
