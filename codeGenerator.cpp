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

	Symbol equality( "==" );
	Symbol equal( "=" );
 	Symbol plus( "+" );
	Symbol minus( "-" );
	Symbol divide( "/" );
	Symbol times( "*" );
	Symbol smaller( "<" );
	Symbol bigger( ">" );
	Symbol different("!=");
	Symbol s_and("&&");
	Symbol s_or("||");
	Symbol hashtag( "#" );

	Symbol open_parenthesis( "(" );
	Symbol close_parenthesis( ")" );

	Symbol printf( "printf" );
	Symbol scanf( "scanf" );
	Symbol include( "include" );
	Symbol If( "if" );

	table.insert_symbol( comma );
	table.insert_symbol( semi_colon );
	table.insert_symbol( blank );

	table.insert_symbol( equality );
	table.insert_symbol( equal );
  	table.insert_symbol( plus ); 
	table.insert_symbol( minus );
	table.insert_symbol( divide );
	table.insert_symbol( times );
	table.insert_symbol( smaller );
	table.insert_symbol( bigger );
	table.insert_symbol( different );
	table.insert_symbol( hashtag );

	table.insert_symbol( open_parenthesis );
	table.insert_symbol( close_parenthesis );

	table.insert_symbol( printf );
	table.insert_symbol( scanf );
	table.insert_symbol( include );
	table.insert_symbol( If );
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

			int r_position = value_token.find( "R" );
			value_token.resize( r_position );

		} else
		{
			Symbol variable = table.find_symbol_by_name( variable_token );
			variable.set_symbol_value( value_token );

			table.delete_symbol( variable_token );
			table.insert_symbol( variable );		
		}

	} else
	{
		Symbol variable = table.find_symbol_by_name( variable_token );
		variable.set_symbol_value( value_token );

		table.delete_symbol( variable_token );
		table.insert_symbol( variable );

	}

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
			int r_position = second_parcel_token.find_last_of( "R" );
			int after_r_position = second_parcel_token.find_last_of( "R" ) + 1;

			string second_parcel = second_parcel_token.substr( 0, r_position );
			string result_string = second_parcel_token.substr( after_r_position );

			float previous_sum = atof( result_string.c_str() );
			
			sum_parcels = first_parcel + previous_sum;
			
			sprintf( sum, "%f + %sR%f", first_parcel, second_parcel.c_str(), sum_parcels );
		} else
		{
			float second_parcel = atof( second_parcel_token.c_str() );
			sum_parcels = first_parcel + second_parcel;

			sprintf( sum, "%f + %fR%f", first_parcel, second_parcel, sum_parcels );
		}

	} else
	{
		int first_parcel = atoi( first_parcel_token.c_str() );
		int sum_parcels = 0;

		if( check_exist_R( second_parcel_token ) )
		{
			int r_position = second_parcel_token.find_last_of( "R" );
			int after_r_position = second_parcel_token.find_last_of( "R" ) + 1;

			string second_parcel = second_parcel_token.substr( 0, r_position );
			string result_string = second_parcel_token.substr( after_r_position );

			int previous_sum = atoi( result_string.c_str() );
			
			sum_parcels = first_parcel + previous_sum;
			
			sprintf( sum, "%d + %sR%d", first_parcel, second_parcel.c_str(), sum_parcels );
		} else
		{
			int second_parcel = atoi( second_parcel_token.c_str() );
			sum_parcels = first_parcel + second_parcel;

			sprintf( sum, "%d + %dR%d", first_parcel, second_parcel, sum_parcels );
		}
	}

	string result_sum( sum );

	return result_sum;
}

string calculate_minus_expression( string minuend_token, string subtrahend_token )
{
	char difference[ 250 ];

	if( check_exist_punctual( subtrahend_token ) )
	{
		float minuend = atof( minuend_token.c_str() );
		float difference_parcels = 0;

		if( check_exist_R( subtrahend_token ) )
		{
			int r_position = subtrahend_token.find_last_of( "R" );
			int after_r_position = subtrahend_token.find_last_of( "R" ) + 1;

			string subtrahend = subtrahend_token.substr( 0, r_position );
			string result_string = subtrahend_token.substr( after_r_position );

			float previous_difference = atof( result_string.c_str() );
			
			difference_parcels = minuend - previous_difference;
			
			sprintf( difference, "%f - %sR%f", minuend, subtrahend.c_str(), difference_parcels );
		} else
		{
			float subtrahend = atof( subtrahend_token.c_str() );
			difference_parcels = minuend - subtrahend;

			sprintf( difference, "%f - %fR%f", minuend, subtrahend, difference_parcels );
		}

	} else
	{
		int minuend = atoi( minuend_token.c_str() );
		int difference_parcels = 0;

		if( check_exist_R( subtrahend_token ) )
		{
			int r_position = subtrahend_token.find_last_of( "R" );
			int after_r_position = subtrahend_token.find_last_of( "R" ) + 1;

			string subtrahend = subtrahend_token.substr( 0, r_position );
			string result_string = subtrahend_token.substr( after_r_position );

			int previous_difference = atoi( result_string.c_str() );
			
			difference_parcels = minuend - previous_difference;
			
			sprintf( difference, "%d - %sR%d", minuend, subtrahend.c_str(), difference_parcels );
		} else
		{
			int subtrahend = atoi( subtrahend_token.c_str() );
			difference_parcels = minuend - subtrahend;

			sprintf( difference, "%d - %dR%d", minuend, subtrahend, difference_parcels );
		}
	}

	string result_difference( difference );

	return result_difference;
}

string calculate_times_expression( string first_factor_token, string second_factor_token )
{
	char product[ 250 ];

	if( check_exist_punctual( second_factor_token ) )
	{
		float first_factor = atof( first_factor_token.c_str() );
		float product_factors = 0;

		if( check_exist_R( second_factor_token ) )
		{
			int r_position = second_factor_token.find_last_of( "R" );
			int after_r_position = second_factor_token.find_last_of( "R" ) + 1;

			string second_factor = second_factor_token.substr( 0, r_position );
			string result_string = second_factor_token.substr( after_r_position );

			float previous_product = atof( result_string.c_str() );
			
			product_factors = first_factor * previous_product;
			
			sprintf( product, "%f * %sR%f", first_factor, second_factor.c_str(), product_factors );
		} else
		{
			float second_factor = atof( second_factor_token.c_str() );
			product_factors = first_factor * second_factor;

			sprintf( product, "%f * %fR%f", first_factor, second_factor, product_factors );
		}

	} else
	{
		int first_factor = atoi( first_factor_token.c_str() );
		int product_factors = 0;

		if( check_exist_R( second_factor_token ) )
		{
			int r_position = second_factor_token.find_last_of( "R" );
			int after_r_position = second_factor_token.find_last_of( "R" ) + 1;

			string second_factor = second_factor_token.substr( 0, r_position );
			string result_string = second_factor_token.substr( after_r_position );

			int previous_product = atoi( result_string.c_str() );
			
			product_factors = first_factor * previous_product;
			
			sprintf( product, "%d * %sR%d", first_factor, second_factor.c_str(), product_factors );
		} else
		{
			int second_factor = atoi( second_factor_token.c_str() );
			product_factors = first_factor * second_factor;

			sprintf( product, "%d * %dR%d", first_factor, second_factor, product_factors );
		}
	}

	string result_product( product );

	return result_product;
}

string calculate_divide_expression( string dividend_token , string divisor_token)
{
	char division[ 250 ];
	
	if( check_exist_punctual( divisor_token ) )
	{
		float dividend = atof( dividend_token.c_str() );
		float divide_elements = 0;

		if( check_exist_R( divisor_token ) )
		{
			int r_position = divisor_token.find_last_of( "R" );
			int after_r_position = divisor_token.find_last_of( "R" ) + 1;

			string divisor = divisor_token.substr( 0, r_position );
			string result_string = divisor_token.substr( after_r_position );

			float previous_result = atof( result_string.c_str() );
			
			divide_elements = dividend / previous_result;
			
			sprintf( division, "%f / %sR%f", dividend, divisor.c_str(), divide_elements );
		} else
		{
			float divisor = atof( divisor_token.c_str() );
			divide_elements = dividend / divisor;

			sprintf( division, "%f / %fR%f", dividend, divisor, divide_elements );
		}

	} else
	{
		int dividend = atoi( dividend_token.c_str() );
		int divide_elements = 0;

		if( check_exist_R( divisor_token ) )
		{
			int r_position = divisor_token.find_last_of( "R" );
			int after_r_position = divisor_token.find_last_of( "R" ) + 1;

			string divisor = divisor_token.substr( 0, r_position );
			string result_string = divisor_token.substr( after_r_position );

			int previous_division = atoi( result_string.c_str() );
			
			divide_elements = dividend / previous_division;
			
			sprintf( division, "%d / %sR%d", dividend, divisor.c_str(), divide_elements );
		} else
		{
			int divisor = atoi( divisor_token.c_str() );
			divide_elements = dividend / divisor;

			sprintf( division, "%d / %dR%d", dividend, divisor, divide_elements );
		}
	}

	string result_division( division );

	return result_division;
}

