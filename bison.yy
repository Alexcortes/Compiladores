%{
	#include <cstdio>
	#include <cstdlib>
	#include <cstring>

	#include <iostream>
	#include <string>
	#include <vector>

	#include "Symbol.h"
	#include "SymbolTable.h"

	using namespace std;

	int yylex(void);
	void yyerror(const char *);

	SymbolTable table;
%}

%{
	string check_variable_type( string variable_type )
	{
		string checked_type = "";

		if( variable_type == "int" )
		{
			checked_type = "%d";

		} else if( variable_type == "float" )
		{
			checked_type = "%f";

		} else if( variable_type == "char" )
		{
			checked_type = "%c";

		} else if( variable_type == "char*" )
		{
			checked_type = "%s";
		}

		return checked_type;
	}
%}

%union{
	int   integer;
	float real;
	char *text;
}

%token<text> COLON
%token<text> VARIABLE

%token<text> STRING
%token<text> INT
%token<text> FLOAT

%token TYPE_STRING
%token TYPE_INT
%token TYPE_CHAR
%token TYPE_FLOAT
%token TYPE_BOOLEAN

%token PRINTF
%token SCANF

%token ATTRIBUTION

%token NEWLINE
%token START
%token END

%start program

%%

Type:
	TYPE_INT {
		char Int[] = "int";
		$<text>$ = Int;

	} | TYPE_FLOAT {
		char Float[] = "float";
		$<text>$ = Float;

	} | TYPE_CHAR {
		char Char[] = "char";
		$<text>$ = Char;

	} | TYPE_STRING {
		char String[] = "char*";
		$<text>$ = String;

	};

number:
	INT {
		$<text>$ = $<text>1;

	} | FLOAT {
		$<text>$ = $<text>1;

	};

text:
	STRING {
		$<text>$ = $<text>1;
	};

value:
	VARIABLE {
	} | number
	| text
	;

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
		Symbol comma( "," );
		Symbol semi_colon( ";" );
		Symbol blank( " " );
		Symbol equal( "=" );

		table.insert_symbol( comma );
		table.insert_symbol( semi_colon );
		table.insert_symbol( blank );
		table.insert_symbol( equal );

		cout << "#include <stdio.h>"  << endl
			  << "#include <stdlib.h>" << endl
			  << "#include <string.h>" << endl
			  << "#include <math.h>"   << endl
			  << endl;

		cout << "int main(int argc, char *argv[])" << endl
			  << "{";

	};

end_of_program:
	END {
		cout << "return 0;" << endl
		     << "}"			  << endl;

	};

declaration:
	VARIABLE COLON Type {
		const string variable_token( $<text>1 );
		const string type_token( $<text>3 );

		if( !table.exist_symbol( variable_token ) )
		{
			Symbol variable( variable_token, type_token );

			table.insert_symbol( variable );

			const string semi_colon = table.find_symbol_by_name( ";" ).get_symbol_name();
			const string blank      = table.find_symbol_by_name( " " ).get_symbol_name();
		
			cout << variable.get_symbol_type() << blank
				  << variable.get_symbol_name() << semi_colon;

		} else
		{
			cout << "Variável já declarada!" << endl;
			return VARIABLE_ALREADY_DECLARED;
		}
	};

attribution:
	VARIABLE ATTRIBUTION value {
		const string variable_token( $<text>1 );
		const string value_token( $<text>3 );
		
		if( table.exist_symbol( variable_token ) )
		{
			const string type = table.find_symbol_by_name( variable_token ).get_symbol_type();

			// TODO: Verificação de correspondência entre o tipo da variável e o valor a atribuir-se
			if( true )
			{
				Symbol variable = table.find_symbol_by_name( variable_token );
				variable.set_symbol_value( value_token );

				table.delete_symbol( variable_token );
				table.insert_symbol( variable );
		
				const string equal      = table.find_symbol_by_name( "=" ).get_symbol_name();
				const string semi_colon = table.find_symbol_by_name( ";" ).get_symbol_name();
				const string blank      = table.find_symbol_by_name( " " ).get_symbol_name();

				string built_string = "";

				built_string.append( variable_token );
				built_string.append( blank );
				built_string.append( equal );
				built_string.append( blank );
				built_string.append( value_token );
				built_string.append( semi_colon );

				cout << built_string;

				strcpy( $<text>$, built_string.c_str() );

			} else
			{
				cout << "Não é possível atribuir! O tipo da variável e do valor não " 
					  << "correspondem." << endl;
				return IMPOSSIBLE_TO_ASSIGN;
			}

		} else
		{
			cout << "Variável não declarada!" << endl;
			return UNDECLARED_VARIABLE;
		}
	};

output:
	 PRINTF text {
		const string text_token( $<text>2 );
		const string begin_printf = "printf(";
		const string end_printf   = ");";
		
		string built_string = "";
		
		built_string.append( begin_printf );
		built_string.append( text_token );
		built_string.append( end_printf );
		
		cout << built_string;

		strcpy( $<text>$, built_string.c_str() );

	} | PRINTF VARIABLE {
		const string variable_token( $<text>2 );
		
		if( table.exist_symbol( variable_token ) )
		{
			string variable_type = table.find_symbol_by_name( variable_token )
											.get_symbol_type();

			const string reference_type = check_variable_type( variable_type );
			const string begin_printf = "printf(";
			const string end_printf   = ");";
			const string blank = " ";
			const string comma = ",";
			const string marks = "\"";
		
			string built_string = "";		

			built_string.append( begin_printf );
			built_string.append( marks );
			built_string.append( reference_type );
			built_string.append( marks );
			built_string.append( comma );
			built_string.append( blank );
			built_string.append( variable_token );
			built_string.append( end_printf );
		
			cout << built_string << endl;

			strcpy( $<text>$, built_string.c_str() );

		} else
		{
			cout << "Variável não declarada!" << endl;
			return UNDECLARED_VARIABLE;
		}
	};

input:
	SCANF VARIABLE {
		const string variable_token( $<text>2 );
		const string begin_scanf = "scanf(";
		const string end_scanf   = ");";
		
		string built_string = "";
		
		built_string.append( begin_scanf );
		built_string.append( variable_token );
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
