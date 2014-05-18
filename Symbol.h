#ifndef SYMBOL_H
#define SYMBOL_H

#include <iostream>
#include <string>

using namespace std;

/* This class represents the elements that are used in the compiler. 
 * Those factors can quote variables. Making variables of type symbol 
 * has become a much better control of these elements as well as the 
 * ability to store values ​​associated with them and their types. */
class Symbol
{
	private:
		string symbol_name;
		string symbol_type;
		string symbol_value;
	
	public:
		Symbol( string );
		Symbol( string, string );
		Symbol( string, string, string );

		string get_symbol_name( ) const;
		string get_symbol_type( ) const;
		string get_symbol_value( ) const;

		void set_symbol_name( string );
		void set_symbol_type( string );
		void set_symbol_value( string );
		
		void list_attributes_symbol( );

		bool equals( Symbol ) const;
		bool equals_name( string ) const;
		bool equals_type( string ) const;
		bool equals_value( string ) const;
};

#endif
