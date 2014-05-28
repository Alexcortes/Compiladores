#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cctype>

#include <iostream>
#include <string>
#include <vector>

#include "rules.h"
#include "checks.h"
#include "Symbol.h"
#include "SymbolTable.h"

using namespace std;

void initialize_symbol_table( SymbolTable &table )
{
	Symbol comma( "," );
	Symbol semi_colon( ";" );
	Symbol blank( " " );

	Symbol equal( "=" );
   Symbol plus( "+" );
	Symbol minus( "-" );
	Symbol divide( "/" );
	Symbol times( "*" );
	Symbol smaller( "<" );
	Symbol bigger( ">" );
	Symbol hashtag( "#" );

	Symbol open_parenthesis( "(" );
	Symbol close_parenthesis( ")" );

	Symbol printf( "printf" );
	Symbol scanf( "scanf" );
	Symbol include( "include" );

	table.insert_symbol( comma );
	table.insert_symbol( semi_colon );
	table.insert_symbol( blank );

	table.insert_symbol( equal );
   table.insert_symbol( plus ); 
	table.insert_symbol( minus );
	table.insert_symbol( divide );
	table.insert_symbol( times );
	table.insert_symbol( smaller );
	table.insert_symbol( bigger );
	table.insert_symbol( hashtag );

	table.insert_symbol( open_parenthesis );
	table.insert_symbol( close_parenthesis );

	table.insert_symbol( printf );
	table.insert_symbol( scanf );
	table.insert_symbol( include );
}

void start_program( SymbolTable &table )
{
	initialize_symbol_table( table );

	cout << "#include <stdio.h>"  << endl
        << "#include <stdlib.h>" << endl
        << "#include <string.h>" << endl
        << "#include <math.h>"   << endl
        << endl;

	cout << "int main(int argc, char *argv[])" << endl
        << "{";
}

void end_program( )
{
	cout << "return 0;" << endl
        << "}"         << endl;
}

void declare_variable( const string variable_token, const string type_token, SymbolTable &table )
{
	Symbol variable( variable_token, type_token );

	table.insert_symbol( variable );

	const string semi_colon = table.find_symbol_by_name( ";" ).get_symbol_name();
	const string blank      = table.find_symbol_by_name( " " ).get_symbol_name();
		
	cout << variable.get_symbol_type() << blank
        << variable.get_symbol_name() << semi_colon;
}

string print_text( const string text_token, SymbolTable &table )
{
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
		
	return built_string;
}

string print_variable( const string variable_token, SymbolTable &table )
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

	return built_string;
}

string scan_variable( const string variable_token, SymbolTable &table )
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

	return built_string;
}

