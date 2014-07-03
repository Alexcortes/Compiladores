%{
	#include <cstdio>
	#include <cstdlib>
	#include <cstring>
	#include <cctype>

	#include <iostream>
	#include <string>
	#include <vector>

	#include "messageAndLog.h"
	#include "codeGenerator.h"
	#include "checks.h"
	#include "Symbol.h"
	#include "SymbolTable.h"

	using namespace std;

	int yylex(void);
	void yyerror(const char *);

	SymbolTable table;	// Declaration of the symbol table used throughout the program.
	const bool KEY = ENABLE; // Key to define if the log is enable or disable.
	bool BLOCK_KEY = ENABLE;
	int identation = 0;
%}

%union{
	char *text;
}

%token<text> COLON
%token<text> VARIABLE

%token<text> STRING
%token<text> NUMBER

%token TYPE_STRING
%token TYPE_INT
%token TYPE_CHAR
%token TYPE_FLOAT
%token TYPE_BOOLEAN

%token PRINTF
%token SCANF
%token COMMA

%token ATTRIBUTION

%token NEWLINE
%token START
%token END

%token PLUS
%token MINUS
%token DIVIDE
%token TIMES

%token EQUAL
%token BIGGER
%token SMALLER
%token DIFFERENT

%token AND
%token OR

%token IF
%token THEN
%token ENDIF

%start program

%%

do_identation: {
	for( int i = 0; i < identation; i++ )
	{
		cout << "\t";
	}
};

/* Rule to capture the type of variables. */
type:
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

comparison_value:
	NUMBER {
		$<text>$ = $<text>1;

	} | VARIABLE {
		$<text>$ = $<text>1;

	};

comparison_operator:
	BIGGER {
		char bigger[] = ">";
		$<text>$ = bigger;

	} | SMALLER {
		char smaller[] = "<";
		$<text>$ = smaller;

	} | DIFFERENT {
		char different[] = "!=";
		$<text>$ = different;

	} | EQUAL {
		char equal[] = "==";
		$<text>$ = equal;

	};

comparison_expression:
	comparison_value comparison_operator comparison_value {
		const string first_value_token( $<text>1 );
		const string logical_operator_token( $<text>2 );
		const string second_value_token( $<text>3 );

		const string blank = table.find_symbol_by_name( " " ).get_symbol_name();

		string built_string = "";

		built_string.append( first_value_token );
		built_string.append( blank );
		built_string.append( logical_operator_token );
		built_string.append( blank );
		built_string.append( second_value_token );

		strcpy( $<text>$, built_string.c_str() );
	};

logical_operator:
	AND{
		char And[] = "&&";
		$<text>$ = And;
	} | OR {
		char Or[] = "||";
		$<text>$ = Or;

	};

logical_expression:
	comparison_expression logical_operator comparison_expression {
		const string first_value_token( $<text>1 );
		const string comparison_operator_token( $<text>2 );
		const string second_value_token( $<text>3 );

		const string blank = table.find_symbol_by_name( " " ).get_symbol_name();

		string built_string = "";

		built_string.append( first_value_token );
		built_string.append( blank );
		built_string.append( comparison_operator_token );
		built_string.append( blank );
		built_string.append( second_value_token );

		strcpy( $<text>$, built_string.c_str() );

	} | comparison_expression {
		$<text>$ = $<text>1;
	};

operator:
	PLUS {
		char Plus[] = "+";
		$<text>$ = Plus;

	} | MINUS {
		char Minus[] = "-";
		$<text>$ = Minus;

	} | TIMES {
		char Times[] = "*";
		$<text>$ = Times;

	} | DIVIDE {
		char Divide[] = "/";
		$<text>$ = Divide;

	};

/* Rule to define how to capture a line of math expression */
math_expression:
	NUMBER {

		$<text>$ = $<text>1;

	} | math_expression operator math_expression {

		const string first_parcel_token( $<text>1 );
		const string operator_token( $<text>2 );
		const string second_parcel_token( $<text>3 );

		string result = calculate_expression( first_parcel_token, second_parcel_token,
									operator_token );

		strcpy( $<text>$, result.c_str() );

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
	math_expression
	| text
	| VARIABLE {
		$<text>$ = $<text>1;

	};

/* Rule to reference variables ​​and text in a single rule called. The motivation 
	comes from an effort to simplify the creation of rules involving the values ​​
	of a variable. */
printable_value:
	text {
	} | VARIABLE {
		$<text>$ = $<text>1;

	};

/* Rule that starts the program. */
program:
	/* Empty rule. */
	| program content_identation
	;

/* Rule that defines what can be the content of a program. */
content_program:
	NEWLINE { printf("\n"); }
	| begin_of_program
	| end_of_program
	| content_block
	| block
	;

content_block:
	declaration
	| attribution
	| output
	| input
	| condition_expression
	;

content_identation:
	do_identation content_program
	| do_identation content_program content_identation
	;

/* Rule that starts the program. There are two essential things are set to the proper 
	functioning of the compiler and program to be generated: the symbols begins compiler) 
	and the inclusion of libraries and definition of the main function. */
begin_of_program:
	START do_identation {
		identation++;
		start_program( table );
	};

/* Rule to terminate the program. */
end_of_program:
	END { identation--; } do_identation {

		end_program();
	};

/* Rule that defines how a variable must be declared. */
declaration:
	VARIABLE COLON type {
		const string variable_token( $<text>1 );
		const string type_token( $<text>3 );

		if( !table.exist_symbol( variable_token ) )
		{
			declare_variable( variable_token, type_token, table);
		} else
		{
			print_message_variable_already_declared();
			return VARIABLE_ALREADY_DECLARED;
		}
	};

/* Rule that defines how you must assign values ​​to variables. */
attribution:
	VARIABLE ATTRIBUTION value {
		const string variable_token( $<text>1 );
				string value_token( $<text>3 );

		if( table.exist_symbol( variable_token ) )
		{
			const string type = table.find_symbol_by_name( variable_token ).get_symbol_type();
			const string value_type = check_value_type( value_token );

			/* The function string::compare() return zero if the strings are equal. So, to 
				pass in test it is necessary transform zero (false) in one (true). */
			if( !type.compare( value_type ) )
			{
				string built_string = attribute_variable( variable_token, value_token, table );

				if( BLOCK_KEY )
				{
					cout << built_string;
				} else {
					// Nothing To Do
				}				

				strcpy( $<text>$, built_string.c_str() );

			} else
			{
				print_message_impossible_to_assign();
				return IMPOSSIBLE_TO_ASSIGN;
			}

		} else
		{
			print_message_undeclared_variable();
			return UNDECLARED_VARIABLE;
		}
	};

/* Rule that defines how to print on screen texts, variable values​​, or both. */
output:
	 PRINTF printable_value {
		const string printable_value_token( $<text>2 );
			
		if( printable_value_token[ 0 ] == '\"' )
		{	
			string built_string = print_printable_value( printable_value_token, table );
			
			if( BLOCK_KEY )
			{
				cout << built_string;
			} else {
				// Nothing To Do
			}

			strcpy( $<text>$, built_string.c_str() );

		} else
		{
			if( table.exist_symbol( printable_value_token ) )
			{
				string built_string = print_printable_value( printable_value_token, table );
				
			if( BLOCK_KEY )
			{
				cout << built_string;
			} else {
				// Nothing To Do
			}

				strcpy( $<text>$, built_string.c_str() );

			} else
			{
				print_message_undeclared_variable();
				return UNDECLARED_VARIABLE;
			}
		}
	};

/* Rule to define how a value is to be read and assigned to a variable. */
input:
	SCANF VARIABLE {
		const string variable_token( $<text>2 );

		if( table.exist_symbol( variable_token ) )
		{
			string built_string = scan_variable( variable_token, table );

			if( BLOCK_KEY )
			{
				cout << built_string;
			} else {
				// Nothing To Do
			}

			strcpy( $<text>$, built_string.c_str() );

		} else
		{
			print_message_undeclared_variable();
			return UNDECLARED_VARIABLE;
		}
	};

begin_block:
	THEN {
		char Open_brace[] = "{";

		identation++;

		$<text>$ = Open_brace;
	};

end_block:
	ENDIF {
		char Close_brace[] = "}";
		identation--;
		$<text>$ = Close_brace;
	};

block:
	begin_block content_block end_block {
		BLOCK_KEY = ENABLE;

		const string begin_block_token( $<text>1 );
		const string content_block_token( $<text>2 );
		const string end_block_token( $<text>3 );

		string built_string = "";

		built_string.append( begin_block_token );
		built_string.append( "\n" );
		built_string.append( content_block_token );
		built_string.append( "\n" );
		built_string.append( end_block_token );

		strcpy( $<text>$, built_string.c_str() );
	};

condition_expression:
	IF logical_expression { BLOCK_KEY = DISABLE; } block {
		const string logical_expression_token( $<text>2 );
		const string block_token( $<text>4 );

		string built_string = build_condition_expression( logical_expression_token, block_token, 
																		  table );
		cout << built_string;
	};
%%

int main(void) {
   yyparse();
}

void yyerror (char const *s) {
  	printf ("%s\n", s);
}
