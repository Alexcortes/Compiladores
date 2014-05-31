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
	const bool KEY = DISABLE; // Key to define if the log is enable or disable.
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

%start program

%%
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



/* Rule to define how to capture a line of math expression */
math_expression:
	NUMBER {
		$<text>$ = $<text>1;

	} | math_expression PLUS math_expression {

		const string first_parcel_token( $<text>1 );
		const string second_parcel_token( $<text>3 );

		string sum = calculate_plus_expression( first_parcel_token, second_parcel_token );
		strcpy( $<text>$, sum.c_str() );

	} | math_expression MINUS math_expression {

		const string minuend_token( $<text>1 );
		const string subtrahend_token( $<text>3 );

		string difference = calculate_minus_expression( minuend_token, subtrahend_token );
		strcpy( $<text>$, difference.c_str() );

	} | math_expression TIMES math_expression {

		const string first_factor_token( $<text>1 );
		const string second_factor_token( $<text>3 );

		string product = calculate_times_expression( first_factor_token, second_factor_token );
		strcpy( $<text>$, product.c_str() );

	} | math_expression DIVIDE math_expression {

		const string first_factor_token( $<text>1 );
		const string second_factor_token( $<text>3 );

		string division = calculate_divide_expression( first_factor_token, second_factor_token );
		strcpy( $<text>$, division.c_str() );
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

/* Rule that starts the program. */
program:
	/* Empty rule. */
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
	| condition_expression
	;

/* Rule that starts the program. There are two essential things are set to the proper 
	functioning of the compiler and program to be generated: the symbols begins compiler) 
	and the inclusion of libraries and definition of the main function. */
begin_of_program:
	START {
		start_program( table );
	};

/* Rule to terminate the program. */
end_of_program:
	END {
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
				cout << built_string;

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
	 PRINTF text {
		const string text_token( $<text>2 );
		
		string built_string = print_text( text_token, table );
		cout << built_string;

		strcpy( $<text>$, built_string.c_str() );

	} | PRINTF VARIABLE {
		const string variable_token( $<text>2 );
		
		if( table.exist_symbol( variable_token ) )
		{
			string built_string = print_variable( variable_token, table );
			cout << built_string;

			strcpy( $<text>$, built_string.c_str() );

		} else
		{
			print_message_undeclared_variable();
			return UNDECLARED_VARIABLE;
		}
	};

/* Rule to define how a value is to be read and assigned to a variable. */
input:
	SCANF VARIABLE {
		const string variable_token( $<text>2 );

		if( table.exist_symbol( variable_token ) )
		{
			string built_string = scan_variable( variable_token, table );
			cout << built_string;

			strcpy( $<text>$, built_string.c_str() );

		} else
		{
			print_message_undeclared_variable();
			return UNDECLARED_VARIABLE;
		}
	};

logical_expression:
		NUMBER BIGGER NUMBER {
		const string first_number_token( $<text>1 );
		const string second_number_token( $<text>3 );

		const string first_number_type  = check_value_type( first_number_token );
		const string second_number_type = check_value_type( second_number_token );

		/* The function string::compare() return zero if the strings are equal. So, to 
			pass in test it is necessary transform zero (false) in one (true). */
		if( !first_number_type.compare( second_number_type ) )
		{
			const string bigger_symbol = table.find_symbol_by_name( ">" ).get_symbol_name();
			const string blank         = table.find_symbol_by_name( " " ).get_symbol_name();

			string built_string = "";

			built_string.append( first_number_token );
			built_string.append( blank );
			built_string.append( bigger_symbol );
			built_string.append( blank );
			built_string.append( second_number_token );

			strcpy( $<text>$, built_string.c_str() );

		} else
		{
			print_message_impossible_comparison();
			return IMPOSSIBLE_COMPARISON;
		}

	} | NUMBER SMALLER NUMBER {
		const string first_number_token( $<text>1 );
		const string second_number_token( $<text>3 );

		const string first_number_type  = check_value_type( first_number_token );
		const string second_number_type = check_value_type( second_number_token );

		/* The function string::compare() return zero if the strings are equal. So, to 
			pass in test it is necessary transform zero (false) in one (true). */
		if( !first_number_type.compare( second_number_type ) )
		{
			const string smaller_symbol = table.find_symbol_by_name( "<" ).get_symbol_name();
			const string blank          = table.find_symbol_by_name( " " ).get_symbol_name();

			string built_string = "";

			built_string.append( first_number_token );
			built_string.append( blank );
			built_string.append( smaller_symbol );
			built_string.append( blank );
			built_string.append( second_number_token );

			strcpy( $<text>$, built_string.c_str() );

		} else
		{
			print_message_impossible_comparison();
			return IMPOSSIBLE_COMPARISON;
		}

	} | NUMBER EQUAL NUMBER {
		const string first_number_token( $<text>1 );
		const string second_number_token( $<text>3 );

		const string first_number_type  = check_value_type( first_number_token );
		const string second_number_type = check_value_type( second_number_token );

		/* The function string::compare() return zero if the strings are equal. So, to 
			pass in test it is necessary transform zero (false) in one (true). */
		if( !first_number_type.compare( second_number_type ) )
		{
			const string equality_symbol = table.find_symbol_by_name( "==" ).get_symbol_name();
			const string blank           = table.find_symbol_by_name( " " ).get_symbol_name();

			string built_string = "";

			built_string.append( first_number_token );
			built_string.append( blank );
			built_string.append( equality_symbol );
			built_string.append( blank );
			built_string.append( second_number_token );

			strcpy( $<text>$, built_string.c_str() );

		} else
		{
			print_message_impossible_comparison();
			return IMPOSSIBLE_COMPARISON;
		}

	} | NUMBER DIFFERENT NUMBER {
		const string first_number_token( $<text>1 );
		const string second_number_token( $<text>3 );

		const string first_number_type  = check_value_type( first_number_token );
		const string second_number_type = check_value_type( second_number_token );

		/* The function string::compare() return zero if the strings are equal. So, to 
			pass in test it is necessary transform zero (false) in one (true). */
		if( !first_number_type.compare( second_number_type ) )
		{
			const string diferent_symbol = table.find_symbol_by_name( "!=" ).get_symbol_name();
			const string blank           = table.find_symbol_by_name( " " ).get_symbol_name();

			string built_string = "";

			built_string.append( first_number_token );
			built_string.append( blank );
			built_string.append( diferent_symbol );
			built_string.append( blank );
			built_string.append( second_number_token );
			
			strcpy( $<text>$, built_string.c_str() );

		} else
		{
			print_message_impossible_comparison();
			return IMPOSSIBLE_COMPARISON;
		}
	
	} | VARIABLE BIGGER VARIABLE {
		const string first_variable_token( $<text>1 );
		const string second_variable_token( $<text>3 );

		if( table.exist_symbol( first_variable_token ) && table.exist_symbol( second_variable_token ) )
		{
			const string first_variable_type  = check_value_type( first_variable_token );
			const string second_variable_type = check_value_type( second_variable_token );

			/* The function string::compare() return zero if the strings are equal. So, to 
				pass in test it is necessary transform zero (false) in one (true). */
			if( !first_variable_type.compare( second_variable_type ) )
			{
				const string bigger_symbol = table.find_symbol_by_name( ">" ).get_symbol_name();
				const string blank         = table.find_symbol_by_name( " " ).get_symbol_name();

				string built_string = "";

				built_string.append( first_variable_token );
				built_string.append( blank );
				built_string.append( bigger_symbol );
				built_string.append( blank );
				built_string.append( second_variable_token );

				strcpy( $<text>$, built_string.c_str() );

			} else
			{
				print_message_impossible_comparison();
				return IMPOSSIBLE_COMPARISON;
			}

		} else
		{
			print_message_undeclared_variable();
			return UNDECLARED_VARIABLE;
		}

	} | VARIABLE SMALLER VARIABLE {
		const string first_variable_token( $<text>1 );
		const string second_variable_token( $<text>3 );

		if( table.exist_symbol( first_variable_token ) && table.exist_symbol( second_variable_token ) )
		{
			const string first_variable_type  = check_value_type( first_variable_token );
			const string second_variable_type = check_value_type( second_variable_token );

			/* The function string::compare() return zero if the strings are equal. So, to 
				pass in test it is necessary transform zero (false) in one (true). */
			if( !first_variable_type.compare( second_variable_type ) )
			{
				const string smaller_symbol = table.find_symbol_by_name( "<" ).get_symbol_name();
				const string blank         = table.find_symbol_by_name( " " ).get_symbol_name();

				string built_string = "";

				built_string.append( first_variable_token );
				built_string.append( blank );
				built_string.append( smaller_symbol );
				built_string.append( blank );
				built_string.append( second_variable_token );

				strcpy( $<text>$, built_string.c_str() );

			} else
			{
				print_message_impossible_comparison();
				return IMPOSSIBLE_COMPARISON;
			}

		} else
		{
			print_message_undeclared_variable();
			return UNDECLARED_VARIABLE;
		}

	} | VARIABLE EQUAL VARIABLE {
		const string first_variable_token( $<text>1 );
		const string second_variable_token( $<text>3 );

		if( table.exist_symbol( first_variable_token ) && table.exist_symbol( second_variable_token ) )
		{
			const string first_variable_type  = check_value_type( first_variable_token );
			const string second_variable_type = check_value_type( second_variable_token );

			/* The function string::compare() return zero if the strings are equal. So, to 
				pass in test it is necessary transform zero (false) in one (true). */
			if( !first_variable_type.compare( second_variable_type ) )
			{
				const string equality_symbol = table.find_symbol_by_name( "==" ).get_symbol_name();
				const string blank         = table.find_symbol_by_name( " " ).get_symbol_name();

				string built_string = "";

				built_string.append( first_variable_token );
				built_string.append( blank );
				built_string.append( equality_symbol );
				built_string.append( blank );
				built_string.append( second_variable_token );

				strcpy( $<text>$, built_string.c_str() );

			} else
			{
				print_message_impossible_comparison();
				return IMPOSSIBLE_COMPARISON;
			}

		} else
		{
			print_message_undeclared_variable();
			return UNDECLARED_VARIABLE;
		}

	} | VARIABLE DIFFERENT VARIABLE {
		const string first_variable_token( $<text>1 );
		const string second_variable_token( $<text>3 );

		if( table.exist_symbol( first_variable_token ) && table.exist_symbol( second_variable_token ) )
		{
			const string first_variable_type  = check_value_type( first_variable_token );
			const string second_variable_type = check_value_type( second_variable_token );

			/* The function string::compare() return zero if the strings are equal. So, to 
				pass in test it is necessary transform zero (false) in one (true). */
			if( !first_variable_type.compare( second_variable_type ) )
			{
				const string different_symbol = table.find_symbol_by_name( "!=" ).get_symbol_name();
				const string blank         = table.find_symbol_by_name( " " ).get_symbol_name();

				string built_string = "";

				built_string.append( first_variable_token );
				built_string.append( blank );
				built_string.append( different_symbol );
				built_string.append( blank );
				built_string.append( second_variable_token );

				strcpy( $<text>$, built_string.c_str() );

			} else
			{
				print_message_impossible_comparison();
				return IMPOSSIBLE_COMPARISON;
			}

		} else
		{
			print_message_undeclared_variable();
			return UNDECLARED_VARIABLE;
		}
	};

condition_expression:
	IF VARIABLE {
		const string variable_token( $<text>2 );

		if( table.exist_symbol( variable_token ) )
		{
			const string open_parenthesis  = table.find_symbol_by_name( "(" ).get_symbol_name();
			const string close_parenthesis = table.find_symbol_by_name( ")" ).get_symbol_name();
			const string blank             = table.find_symbol_by_name( " " ).get_symbol_name();
			const string If		       	 = table.find_symbol_by_name( "if" ).get_symbol_name();
		
			string built_string = "";

			built_string.append( If );
			built_string.append( open_parenthesis );
			built_string.append( blank );
			built_string.append( variable_token );
			built_string.append( blank );
			built_string.append( close_parenthesis );

			cout << built_string;

			strcpy( $<text>$, built_string.c_str() );
		} else
		{
			print_message_undeclared_variable();
			return UNDECLARED_VARIABLE;
		}

	} | IF logical_expression{
		const string logical_expression_token( $<text>2 );

		const string open_parenthesis  = table.find_symbol_by_name( "(" ).get_symbol_name();
		const string close_parenthesis = table.find_symbol_by_name( ")" ).get_symbol_name();
		const string blank             = table.find_symbol_by_name( " " ).get_symbol_name();
		const string If		       	 = table.find_symbol_by_name( "if" ).get_symbol_name();	
		
		string built_string = "";

		built_string.append( If );
		built_string.append( open_parenthesis );
		built_string.append( blank );
		built_string.append( logical_expression_token );
		built_string.append( blank );
		built_string.append( close_parenthesis );	

		cout << built_string;

		strcpy( $<text>$, built_string.c_str() );
	};
%%

int main(void) {
   yyparse();
}

void yyerror (char const *s) {
  	printf ("%s\n", s);
}
