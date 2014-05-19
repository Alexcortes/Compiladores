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

	SymbolTable table;	// Declaration of the symbol table used throughout the program.
%}

%{
	/* This function is used to check the type of the variable captured for, thus, correctly 
		reference the variable in the action to print the variable value on the screen or 
		in your reading. */
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

%token PLUS
%token EQUAL

%start program

%%
/* Rule to capture the type of variables. */
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

/* Rule to capture the numeric value written. */
number:
	INT {
		$<text>$ = $<text>1;

	} | FLOAT {
		$<text>$ = $<text>1;

	};

/* Rule to capture lines of text (strings). */
text:
	STRING {
		$<text>$ = $<text>1;
	};

/* Rule to reference numerical values ​​and text in a single rule called. The motivation 
	comes from an effort to simplify the creation of rules involving the values ​​
	of a variable. */
value:
	VARIABLE {
	} | number
	| text
	;

/* Rule that starts the program. */
program:
	/* Regra Vazia */
	| program content_program
	;

/* Rule that defines what can be the content of a program. */
content_program:
	NEWLINE { printf("\n"); }
	| begin_of_program
	| end_of_program
	| declaration
	| attribution
	| output
	| input
	| math_expression
	;

/* Rule that starts the program. There are two essential things are set to the proper 
	functioning of the compiler and program to be generated: the symbols begins compiler) 
	and the inclusion of libraries and definition of the main function. */
begin_of_program:
	START {
		Symbol comma( "," );
		Symbol semi_colon( ";" );
		Symbol blank( " " );
		Symbol equal( "=" );
		Symbol open_parenthesis( "(" );
		Symbol close_parenthesis( ")" );
		Symbol printf( "printf" );
		Symbol scanf( "scanf" );

		table.insert_symbol( comma );
		table.insert_symbol( semi_colon );
		table.insert_symbol( blank );
		table.insert_symbol( equal );
		table.insert_symbol( open_parenthesis );
		table.insert_symbol( close_parenthesis );
		table.insert_symbol( printf );
		table.insert_symbol( scanf );

		cout << "#include <stdio.h>"  << endl
			  << "#include <stdlib.h>" << endl
			  << "#include <string.h>" << endl
			  << "#include <math.h>"   << endl
			  << endl;

		cout << "int main(int argc, char *argv[])" << endl
			  << "{";

	};

/* Rule to terminate the program. */
end_of_program:
	END {
		cout << "return 0;" << endl
		     << "}"			  << endl;

	};

/* Rule that defines how a variable must be declared. */
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

/* Rule that defines how you must assign values ​​to variables. */
attribution:
	VARIABLE ATTRIBUTION value {
		const string variable_token( $<text>1 );
		const string value_token( $<text>3 );
		
		if( table.exist_symbol( variable_token ) )
		{
			const string type = table.find_symbol_by_name( variable_token ).get_symbol_type();

			/* TODO: Verification of correspondence between the type of the variable and 
						the value to be attributed. */
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

/* Rule that defines how to print on screen texts, variable values​​, or both. */
output:
	 PRINTF text {
		const string text_token( $<text>2 );

		const string close_parenthesis = table.find_symbol_by_name( ")" ).get_symbol_name();
		const string open_parenthesis  = table.find_symbol_by_name( "(" ).get_symbol_name();
		const string semi_colon        = table.find_symbol_by_name( ";" ).get_symbol_name();
		const string printf            = table.find_symbol_by_name( "printf" ).get_symbol_name();
		
		string built_string = "";
		
		built_string.append( printf );
		built_string.append( open_parenthesis );
		built_string.append( text_token );
		built_string.append( close_parenthesis );
		built_string.append( semi_colon );
		
		cout << built_string;

		strcpy( $<text>$, built_string.c_str() );

	} | PRINTF VARIABLE {
		const string variable_token( $<text>2 );
		
		if( table.exist_symbol( variable_token ) )
		{
			const string variable_type = table.find_symbol_by_name( variable_token )
													.get_symbol_type();

			const string close_parenthesis = table.find_symbol_by_name( ")" ).get_symbol_name();
			const string open_parenthesis  = table.find_symbol_by_name( "(" ).get_symbol_name();
			const string reference_type    = check_variable_type( variable_type );
			const string semi_colon        = table.find_symbol_by_name( ";" ).get_symbol_name();
			const string printf            = table.find_symbol_by_name( "printf" ).get_symbol_name();
			const string blank             = table.find_symbol_by_name( " " ).get_symbol_name();
			const string comma             = table.find_symbol_by_name( "," ).get_symbol_name();
			const string marks = "\"";

			string built_string = "";

			built_string.append( printf );
			built_string.append( open_parenthesis );
			built_string.append( marks );
			built_string.append( reference_type );
			built_string.append( marks );
			built_string.append( comma );
			built_string.append( blank );
			built_string.append( variable_token );
			built_string.append( close_parenthesis );
			built_string.append( semi_colon );
		
			cout << built_string;

			strcpy( $<text>$, built_string.c_str() );

		} else
		{
			cout << "Variável não declarada!" << endl;
			return UNDECLARED_VARIABLE;
		}
	};

/* Rule to define how a value is to be read and assigned to a variable. */
input:
	SCANF VARIABLE {
		const string variable_token( $<text>2 );

		if( table.exist_symbol( variable_token ) )
		{
			const string variable_type = table.find_symbol_by_name( variable_token )
													.get_symbol_type();

			const string open_parenthesis  = table.find_symbol_by_name( "(" ).get_symbol_name();
			const string close_parenthesis = table.find_symbol_by_name( ")" ).get_symbol_name();
			const string reference_type    = check_variable_type( variable_type );
			const string semi_colon        = table.find_symbol_by_name( ";" ).get_symbol_name();
			const string scanf             = table.find_symbol_by_name( "scanf" ).get_symbol_name();
			const string blank             = table.find_symbol_by_name( " " ).get_symbol_name();
			const string comma             = table.find_symbol_by_name( "," ).get_symbol_name();
			const string marks		= "\"";
		
			string built_string = "";

			built_string.append( scanf );
			built_string.append( open_parenthesis );
			built_string.append( marks );
			built_string.append( reference_type );
			built_string.append( marks );
			built_string.append( comma );
			built_string.append( blank );
			built_string.append( variable_token );
			built_string.append( close_parenthesis );
			built_string.append( semi_colon );

			cout << built_string;

			strcpy( $<text>$, built_string.c_str() );

		} else
		{
			cout << "Variável não declarada!" << endl;
			return UNDECLARED_VARIABLE;
		}
	};

/* Rule that defines possible to build mathematical expressions. */
math_expression:
	number {
		const string number_token( $<text>1 );
		$<text>$ = number_token;

	} | VARIABLE {
		const string variable_token( $<text>1 );
		$<text>$ = variable_token;

	}| math_expression PLUS math_expression {
		const string first_math_expression_token( $<text>1 );
		const string second_math_expression_token( $<text>2 );
	};

%%

int main(void) {
   yyparse();
}

	void yyerror (char const *s) {
   	printf ("%s\n", s);
	}
