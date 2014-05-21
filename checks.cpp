#include <iostream>
#include <string>
#include <cctype>
#include <vector>

#include "checks.h"

using namespace std;

/* This function is used to check the type of the variable captured for, thus, correctly 
	reference the variable in the action to print the variable value on the screen or 
	in your reading. */
string check_variable_type( const string variable_type )
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

string check_value_type( const string value_string )
{
	const int length_string = value_string.size();

	if( check_is_string( value_string ) )
	{
		return "char*";

	} else if( check_is_char( value_string ) )
	{
		return "char";

	} else if( check_exist_punctual( value_string ) )
	{
		return "float";

	} else if( check_exist_digit( value_string ) )
	{
		return "int";
	}
}

bool check_is_string( const string value_string )
{
	bool is_string;

		char first_char = value_string[ 0 ];

		if( first_char == '\"' )
		{
			is_string = true;
			
		} else
		{
			is_string = false;
		}
	
	return is_string;
}

bool check_is_char( const string value_string )
{
	bool is_string;

		char first_char = value_string[ 0 ];

		if( first_char == '\'' )
		{
			is_string = true;
			
		} else
		{
			is_string = false;
		}
	
	return is_string;
}

bool check_exist_punctual( const string value_string )
{
	bool not_exist;

	const int length_string = value_string.size();

	for( unsigned int i = 0; i <= length_string; i++ )
	{
		char read_char = value_string [ i ];

		if( read_char == '.' )
		{
			return true;
			
		} else
		{
			not_exist = false;
		}
	}
	
	return not_exist;
}

bool check_exist_digit( const string value_string )
{
	bool not_exist;

	const int length_string = value_string.size();

	for( unsigned int i = 0; i <= length_string; i++ )
	{
		char read_char = value_string [ i ];

		if( isdigit( read_char ) )
		{
			return true;
			
		} else
		{
			not_exist = false;
		}
	}
	
	return not_exist;
}
