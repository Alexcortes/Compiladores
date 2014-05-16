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
	float real;
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
%token<text> INT
%token<text> FLOAT
%token PRINTF
%token SCANF
%token ATTRIBUTION
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
	| attribution
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
		cout << "char *" << $<text>1 << ";";

	} | VARIABLE COLON TYPE_INT { 
		cout << "int " << $<text>1 << ";";

	} | VARIABLE COLON TYPE_FLOAT {
		cout << "float " << $<text>1 << ";";

	} | VARIABLE COLON TYPE_BOOLEAN {
		cout << "bool " << $<text>1 << ";";
	};

number:
	INT {
		$<text>$ = $1;

	} | FLOAT {
		$<text>$ = $1;

	};

text:
	STRING {
		$<text>$ = $1;
	};

value:
	VARIABLE {
	} | number
	| text
	;

attribution:
	VARIABLE ATTRIBUTION value {
		string equal = " = ";
		string semi_colon = ";";

		string built_string = "";

		built_string.append( $<text>1 );
		built_string.append( equal );
		built_string.append( $<text>3 );
		built_string.append( semi_colon );

		cout << built_string;

		strcpy( $<text>$, built_string.c_str() );
	};

output:
	 PRINTF text {
		string begin_printf = "printf(";
		string end_printf   = ");";
		
		string built_string = "";
		
		built_string.append( begin_printf );
		built_string.append( $<text>2 );
		built_string.append( end_printf );
		
		cout << built_string << endl;

		strcpy( $<text>$, built_string.c_str() );
	};

input:
	SCANF VARIABLE {
		string begin_scanf = "scanf(";
		string end_scanf     = ");";
		
		string built_string = "";
		
		built_string.append( begin_scanf );
		built_string.append( $<text>2 );
		built_string.append( end_scanf );
		
		/* TODO: Deve-se capturar o tipo da variável para definir o tipo de leitura mais adequada.
				   Proponho utilizar uma struct com dois elementos para definir uma VARIABLE. */
		cout << built_string << endl;

		strcpy( $<text>$, built_string.c_str() );
	};

%%

int main(void) {
   yyparse();
}

	void yyerror (char const *s) {
   	printf ("%s\n", s);
	}
