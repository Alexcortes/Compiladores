#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cctype>

#include <iostream>
#include <string>
#include <vector>

#include "codeGenerator.h"
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

string attribute_variable( string variable_token, string value_token, SymbolTable& table )
{
	const string value_type = check_value_type( value_token );

	if( value_type == "float" || value_type == "int" )
	{
		if( check_exist_R( value_token ) )
		{
			unsigned int result_position = value_token.find( "R" ) + 1;
			string result = value_token.substr( result_position );

			Symbol variable = table.find_symbol_by_name( variable_token );
			variable.set_symbol_value( result );

			table.delete_symbol( variable_token );
			table.insert_symbol( variable );

		} else
		{
			// Nothing To Do
		}

	} else
	{
		// Nothing To Do
	}

	Symbol variable = table.find_symbol_by_name( variable_token );
	variable.set_symbol_value( value_token );

	table.delete_symbol( variable_token );
	table.insert_symbol( variable );

	int r_position = value_token.find( "R" );
	value_token.resize( r_position );

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

	return built_string;
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
	const string marks = "\"";
		
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

string calculate_plus_expression( string first_parcel_token, string second_parcel_token )
{
	char sum[ 250 ];

	if( check_exist_punctual( second_parcel_token ) )
	{
		float first_parcel = atof( first_parcel_token.c_str() );
		float sum_parcels = 0;

		if( check_exist_R( second_parcel_token ) )
		{
			string second_parcel = separate_parcel_to_result( second_parcel_token ).at( 0 );
			string result_string = separate_parcel_to_result( second_parcel_token ).at( 1 );

			float previous_sum = atof( result_string.c_str() );
			
			sum_parcels = first_parcel + previous_sum;
			
			sprintf(sum, "%f + %sR%f", first_parcel, second_parcel.c_str(), sum_parcels );
		} else
		{
			float second_parcel = atof( second_parcel_token.c_str() );
			sum_parcels = first_parcel + second_parcel;

			sprintf(sum, "%f + %fR%f", first_parcel, second_parcel, sum_parcels );
		}

	} else
	{
		int first_parcel = atoi( first_parcel_token.c_str() );
		int sum_parcels = 0;

		if( check_exist_R( second_parcel_token ) )
		{
			string second_parcel = separate_parcel_to_result( second_parcel_token ).at( 0 );
			string result_string = separate_parcel_to_result( second_parcel_token ).at( 1 );

			int previous_sum = atoi( result_string.c_str() );
			
			sum_parcels = first_parcel + previous_sum;
			
			sprintf(sum, "%d + %sR%d", first_parcel, second_parcel.c_str(), sum_parcels );
		} else
		{
			int second_parcel = atoi( second_parcel_token.c_str() );
			sum_parcels = first_parcel + second_parcel;

			sprintf(sum, "%d + %dR%d", first_parcel, second_parcel, sum_parcels );
		}
	}

	string result_sum( sum );

	return result_sum;
}

vector<string> separate_parcel_to_result( string second_parcel_token )
{
	vector<string> separate_strings;
	
	int r_position = second_parcel_token.find_last_of( "R" );
	int after_r_position = second_parcel_token.find_last_of( "R" ) + 1;

	separate_strings[ 0 ] = second_parcel_token.substr( 0, r_position );
	separate_strings[ 1 ] = second_parcel_token.substr( after_r_position );

	return separate_strings;
}

