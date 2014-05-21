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

void check_value_type( const string value_string )
{
	const int length_string = value_string.size();

	vector<string> classification_of_chars;
	
	for( unsigned int i = 0; i <= length_string; i++ )
	{
		char read_char = value_string[ i ];

		if( isdigit( read_char ) )
		{
			classification_of_chars[ i ] = "digit";

		} else if( isalpha( read_char ) )
		{
			classification_of_chars[ i ] = "letter";

		} else if( ispunct( read_char ) )
		{
			classification_of_chars[ i ] = "punctual";
		} else
		{
			// Nothing To Do
		}
	}
}
