%option yylineno

%{
	#include <stdio.h>
	#include <string.h>
	#include "syntax.tab.h"
	struct Node{
		int kind;
		int count_of_line;
		char* type;
		char* word;
		struct Node* child;
		struct Node* brother;
	};
	int creatNode(char* type,char* word);	
	/* definitions of manifest constants
	LT, LE, EQ, NE, GT, GE,
	IF, THEN, ELSE, ID, NUMBER, RELOP */
%}

/*regular definations */
delim	[ \t\n]
ws	{delim}+
letter	[_A-Za-z]
digit	[0-9]
int	{digit}+
float	{digit}+(\.{digit}+)
type	int|float
id	{letter}({letter}|{digit})*
%%

{ws}		{/*no action and no return */}
{int}		{creatNode("INT", yytext); return INT;}
{float}		{creatNode("FLOAT", yytext); return FLOAT;}
{type}		{creatNode("TYPE", yytext); return TYPE;}
"<"		{creatNode("RELOP", yytext); return RELOP;}
"<="		{creatNode("RELOP", yytext); return RELOP;}
"=="		{creatNode("RELOP", yytext); return RELOP;}
"<>"		{creatNode("RELOP", yytext); return RELOP;}
">"		{creatNode("RELOP", yytext); return RELOP;}
">="		{creatNode("RELOP", yytext); return RELOP;}
";"		{creatNode("SEMI", yytext); return SEMI;}		
","		{creatNode("COMMA", yytext); return COMMA;}
"="		{creatNode("ASSIGNOP", yytext); return ASSIGNOP;}
"+"		{creatNode("PLUS", yytext); return PLUS;}
"-"		{creatNode("MINUS", yytext); return MINUS;}
"*"		{creatNode("STAR", yytext); return STAR;}
"/"		{creatNode("DIV", yytext); return DIV;}
"&&"		{creatNode("AND", yytext); return AND;}
"||"		{creatNode("OR", yytext); return OR;}
"."		{creatNode("DOT", yytext); return DOT;}
"!"		{creatNode("NOT", yytext); return NOT;}
"("		{creatNode("LP", yytext); return LP;}
")"		{creatNode("RP", yytext); return RP;}
"["		{creatNode("LB", yytext); return LB;}
"]"		{creatNode("RB", yytext); return RB;}
"{"		{creatNode("LC", yytext); return LC;}
"}"		{creatNode("RC", yytext); return RC;}
struct		{creatNode("STRUCT", yytext); return STRUCT;}
return		{creatNode("RETURN", yytext); return RETURN;}
if		{creatNode("IF", yytext); return IF;}
else		{creatNode("ELSE", yytext); return ELSE;}
while		{creatNode("WHILE", yytext); return WHILE;}
{id}		{creatNode("ID", yytext); return ID;}
.		{printf("Error type A at line %d: Mysterious character \'%s\'\n", yylineno, yytext);}


%%

int creatNode(char* type, char* word){
	printf("%s ",type);
	struct Node* temp_node = (struct Node*)malloc(sizeof(struct Node));
	temp_node->kind = 0;
	temp_node->count_of_line = yylineno;
	strcpy(temp_node->type, type);
	strcpy(temp_node->word, word);
	temp_node->child = NULL;
	temp_node->brother = NULL;
}













