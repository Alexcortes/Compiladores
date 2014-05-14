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
%token<text> TYPE_BOOLEAN
%token<text> COLON
%token<text> VARIABLE
%token<text> STRING
%token PRINTF
%token SCANF
%token NEWLINE

%start program

%%

program:
	/* Regra Vazia */
	| program content_program
	;

content_program:
	NEWLINE { printf("\n"); }
	| declaration
	| output
	| input
	;

declaration:
	VARIABLE COLON TYPE_CHAR { 
		printf( "char %s;", $<text>1 );

	} | VARIABLE COLON TYPE_STRING { 
			printf( "char *%s[];", $<text>1 );

	} | VARIABLE COLON TYPE_INT { 
			printf( "int %s;", $<text>1 );

	} | VARIABLE COLON TYPE_FLOAT {
			printf( "float %s;", $<text>1 );

	} | VARIABLE COLON TYPE_BOOLEAN {
			printf( "bool %s;", $<text>1 );
	};

text:
	STRING {
		$<text>$ = $1;
	};

output:
	 PRINTF text {
		char beginPrintf[]	= "printf(";
		char endPrintf[]		= ");";
		
		char *stringPtr = ( char * )malloc(  strlen( beginPrintf )
			+ strlen( $<text>2 ) + strlen( endPrintf ) + 1);
		
		strcpy( stringPtr, beginPrintf );
		strcat( stringPtr, $<text>2 );
		strcat( stringPtr, endPrintf );
		
		printf( "%s", stringPtr );
		$<text>$ = stringPtr;
	};

input:
	SCANF VARIABLE {
		char beginScanf[]	= "scanf(";
		char endScanf[]	= ");";
		
		char *stringPtr = ( char * )malloc( strlen( beginScanf )
		+ strlen( $<text>2 ) + strlen( endScanf ) + 1 );
		
		strcpy( stringPtr, beginScanf );
		strcat( stringPtr, $<text>2 );
		strcat( stringPtr, endScanf );
		
		/* Deve-se capturar o tipo da variável para definir o tipo de leitura mais adequada.
			Proponho utilizar uma struct com dois elementos para definir uma VARIABLE. */
		printf( "%s", stringPtr );
		$<text>$ = stringPtr;
	};

%%

int yyerror(char *s) {
   printf( "%s\n",s );
}

int main(void) {
   yyparse();
}
