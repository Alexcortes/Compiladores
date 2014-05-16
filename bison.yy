%{
	#include <cstdio>
	#include <cstdlib>
	#include <cstring>

	#include <iostream>
	#include <string>

	using namespace std;

	int yylex(void);
	void yyerror(const char *);
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
%token START
%token END

%start program

%%

program:
	/* Regra Vazia */
	| program content_program
	;

content_program:
	NEWLINE { printf("\n"); }
	| begin_of_program
	| end_of_program
	| declaration
	| output
	| input
	;

begin_of_program:
	START {
		cout << "#include<stdio.h>"  << endl
			  << "#include<stdlib.h>" << endl
			  << "#include<string.h>" << endl
			  << "#include<math.h>"   << endl
			  << endl;

		cout << "int main(int argc, char *argv[])" << endl
			  << "{";

	};

end_of_program:
	END {
		cout << "}" << endl;

	};

declaration:
	VARIABLE COLON TYPE_CHAR { 
		cout << "char " << $<text>1 << ";";

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

int main(void) {
   yyparse();
}

	void yyerror (char const *s) {
   	printf ("%s\n", s);
	}
