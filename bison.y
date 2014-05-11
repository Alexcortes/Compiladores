%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
%}

%union{
	int   integer;
	char *text;
}

%token<text> TYPE_STRING
%token<text> TYPE_INT
%token<text> TYPE_CHAR
%token<text> TYPE_FLOAT
%token<text> COLON
%token<text> VARIABLE
%token INT
%token CHAR

%%

attribution:
	VARIABLE COLON TYPE_CHAR { 
		printf("char %s;", $1);

	} | VARIABLE COLON TYPE_STRING { 
			printf("string %s;", $1);

	} | VARIABLE COLON TYPE_INT { 
			printf("int %s;", $1);

	} | VARIABLE COLON TYPE_FLOAT {
			printf("float %s;", $1);
	};

%%

int yyerror(char *s) {
   printf("%s\n",s);
}

int main(void) {
   yyparse();
}
