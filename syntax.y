%{
		
	#include <stdio.h>
	#include "lex.yy.c"
	#include <string.h>
	#include <stdlib.h>
	#include <stdarg.h>
	struct Node * root;
	struct Node *createTree(char *type,int sum,...);
	//int iError = 0;
	void print(struct Node *temp_root,int height);
%}

%union {struct Node * kinds_nodes;}
%token <kinds_nodes> INT FLOAT ID TYPE SEMI COMMA    
%right <kinds_nodes> ASSIGNOP NOT 
%left  <kinds_nodes> STAR DIV PLUS MINUS RELOP AND OR
%left  <kinds_nodes> DOT LP RP LB RB LC RC
%nonassoc <kinds_nodes> IF ELSE WHILE RETURN STRUCT
 
%type <kinds_nodes> Program ExtDefList ExtDef ExtDecList Specifier StructSpecifier OptTag Tag VarDec FunDec 
%type <kinds_nodes> VarList ParamDec CompSt StmtList Stmt DefList Def DecList Dec Exp Args

%%

Program		:	ExtDefList			{ $$ = createTree("Program", 1, $1); root = $$;}
		;
		
ExtDefList	: 	ExtDef ExtDefList		{ $$ = createTree("ExtDefList", 2, $1, $2); }
		|					{ $$ = NULL; }
		;
	
ExtDef		:	Specifier ExtDecList SEMI	{ $$ = createTree("ExtDef", 3, $1, $2, $3); }
		|	Specifier SEMI			{ $$ = createTree("ExtDef", 2, $1, $2); }
		|	Specifier FunDec CompSt		{ $$ = createTree("ExtDef", 3, $1, $2, $3); }
		;

ExtDecList	:	VarDec				{ $$ = createTree("VarDec", 1, $1); }
		|	VarDec COMMA ExtDecList		{ $$ = createTree("VarDec", 3, $1, $2, $3); }
		;
		
Specifier	:	TYPE				{ $$ = createTree("Specifier", 1, $1); }
		|	StructSpecifier			{ $$ = createTree("Specifier", 1, $1); }
		;

StructSpecifier	:	STRUCT OptTag LC DefList RC	{ $$ = createTree("StructSpecifier", 5, $1, $2, $3, $4, $5); }
		|	STRUCT Tag			{ $$ = createTree("StructSpecifier", 2, $1, $2); }
		;
		
OptTag		:	ID				{ $$ = createTree("OptTag", 1, $1); }
		|					{ $$ = NULL; }
		;

Tag		:	ID				{ $$ = createTree("Tag", 1, $1); }
		;
		
VarDec		:	ID				{ $$ = createTree("VarDec", 1, $1); }
		|	VarDec LB INT RB		{ $$ = createTree("VarDec", 4, $1, $2, $3, $4); }
		;
		
FunDec		:	ID LP VarList RP		{ $$ = createTree("FunDec", 4, $1, $2, $3, $4); }
		|	ID LP RP			{ $$ = createTree("FunDec", 3, $1, $2, $3); }
		;
		
VarList		:	ParamDec COMMA VarList		{ $$ = createTree("VarList", 3, $1, $2, $3); }
		|	ParamDec			{ $$ = createTree("VarList", 1, $1); }
		;
		
ParamDec	:	Specifier VarDec		{ $$ = createTree("ParamDec", 2, $1, $2); }
		;
		
CompSt		:	LC DefList StmtList RC		{ $$ = createTree("CompSt", 4, $1, $2, $3, $4); }
		;
		
StmtList 	:	Stmt StmtList			{ $$ = createTree("StmtList", 2, $1, $2); }
		|					{ $$ = NULL; }
		;
		
Stmt		:	Exp SEMI			{ $$ = createTree("Stmt", 2, $1, $2); }
		|	CompSt				{ $$ = createTree("Stmt", 1, $1); }
		|	RETURN Exp SEMI			{ $$ = createTree("Stmt", 3, $1, $2, $3); }
		|	IF LP Exp RP Stmt		{ $$ = createTree("Stmt", 5, $1, $2, $3, $4, $5); }
		|	IF LP Exp RP Stmt ELSE Stmt	{ $$ = createTree("Stmt", 7, $1, $2, $3, $4, $5, $6, $7); }
		|	WHILE LP Exp RP Stmt		{ $$ = createTree("Stmt", 5, $1, $2, $3, $4, $5); }
		;		
		
DefList 	:	Def DefList			{ $$ = createTree("DefList", 2, $1, $2); }
		|					{ $$ = NULL; }
		;
		
Def		:	Specifier DecList SEMI		{ $$ = createTree("Def", 3, $1, $2, $3); }
		;
		
DecList		:	Dec				{ $$ = createTree("DecList", 1, $1); }
		|	Dec COMMA DecList		{ $$ = createTree("DecList", 3, $1, $2, $3); }
		;
		
Dec		:	VarDec				{ $$ = createTree("Dec", 1, $1); }
		|	VarDec ASSIGNOP Exp		{ $$ = createTree("Dec", 3, $1, $2, $3); }
		;
		
Exp		:	Exp ASSIGNOP Exp		{ $$ = createTree("Exp", 3, $1, $2, $3); }
		|	Exp AND Exp			{ $$ = createTree("Exp", 3, $1, $2, $3); }
		|	Exp OR Exp			{ $$ = createTree("Exp", 3, $1, $2,$3); }					
		|	Exp RELOP Exp			{ $$ = createTree("Exp", 3, $1, $2, $3); }	
		|	Exp PLUS Exp			{ $$ = createTree("Exp", 3, $1, $2, $3); }
		|	Exp MINUS Exp			{ $$ = createTree("Exp", 3, $1, $2, $3); }
		|	Exp STAR Exp			{ $$ = createTree("Exp", 3, $1, $2, $3); }
		|	Exp DIV Exp			{ $$ = createTree("Exp", 3, $1, $2, $3); }
		|	LP Exp RP			{ $$ = createTree("Exp", 3, $1, $2, $3); }
		|	MINUS Exp			{ $$ = createTree("Exp", 2, $1, $2); }
		|	NOT Exp				{ $$ = createTree("Exp", 2, $1, $2); }
		|	ID LP Args RP			{ $$ = createTree("Exp", 4, $1, $2, $3, $4); }
		|	ID LP RP			{ $$ = createTree("Exp", 3, $1, $2, $3); }
		|	Exp LB Exp RB			{ $$ = createTree("Exp", 4, $1, $2, $3, $4); }
		|	ID				{ $$ = createTree("Exp", 1, $1); }
		|	INT				{ $$ = createTree("Exp", 1, $1); }
		| 	FLOAT				{ $$ = createTree("Exp", 1, $1); }
		;
		
Args		:	Exp COMMA Args			{ $$ = createTree("Args", 3, $1, $2, $3); }
		| 	Exp				{ $$ = createTree("Args", 1, $1); }
		;
		
		
		
%%


struct Node *createTree(char *type,int sum,...){
	struct Node* temp_root = (struct Node*)malloc(sizeof(struct Node));
	struct Node* temp1 = (struct Node*)malloc(sizeof(struct Node));
	struct Node* temp2 = (struct Node*)malloc(sizeof(struct Node));
	int i;
	
	temp_root->kind = 1;
	strcpy(temp_root->type, type);
	
	va_list vl;
	va_start (vl, sum);
	temp1 = va_arg(vl, struct Node*);
	temp_root->child = temp1;
	temp_root->count_of_line = temp1->count_of_line;
	
	for (i=0; i<sum-1; i++){
		temp2 = va_arg(vl, struct Node*);
		if (temp2 != NULL){
			temp1->brother = temp2;
			temp1 = temp2;
		}
	}
	temp1->brother = NULL;
	va_end(vl);
	
	return temp_root;
}



void print(struct Node *temp_root,int height){
	
}


yyerror(char* msg){
	printf("Error type B at line %d: %s \n", yylineno, msg);
}

















