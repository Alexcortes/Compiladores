#include <iostream>
#include <string>

#include "Symbol.h"

using namespace std;

Symbol::Symbol( string name )
{
	this->set_symbol_name( name );
}

Symbol::Symbol( string name, string type )
{
	this->set_symbol_name( name );
	this->set_symbol_type( type );
}

Symbol::Symbol( string name, string type, string value )
{
	this->set_symbol_name( name );
	this->set_symbol_type( type );
	this->set_symbol_value( value );
}

string Symbol::get_symbol_name() const
{
	return this->symbol_name;
}

string Symbol::get_symbol_type( ) const
{
	return this->symbol_type;
}

string Symbol::get_symbol_value( ) const
{
	return this->symbol_value;
}

void Symbol::set_symbol_name( string name )
{
	this->symbol_name = name;
}

void Symbol::set_symbol_type( string type )
{
	this->symbol_type = type;
}

void Symbol::set_symbol_value( string value )
{
	this->symbol_value = value;
}

void Symbol::list_attributes_symbol( )
{
	const string name = this->get_symbol_name();
	const string type = this->get_symbol_type();
	const string value = this->get_symbol_value();
	
	cout << "Nome: "  << name  << endl
 		  << "Tipo: "  << type  << endl
		  << "Valor: " << value << endl;
}

bool Symbol::equals( Symbol symbol_compared ) const
{
	bool equals_name  = this->equals_name( symbol_compared.get_symbol_name() );
	bool equals_type  = this->equals_name( symbol_compared.get_symbol_type() );
	bool equals_value = this->equals_name( symbol_compared.get_symbol_value() );

	bool equals_symbol = false;

	if( equals_name == true && equals_type == true && equals_value == true )
	{
		equals_symbol = true;
	} else
	{
		equals_symbol = false;
	}

	return equals_symbol;
}

bool Symbol::equals_name( string name_compared ) const
{
	bool is_equals = false;
	
	string name = this->get_symbol_name( );

	if( name == name_compared )
	{
		is_equals = true;
	} else
	{
		is_equals = false;
	}

	return is_equals;
}

bool Symbol::equals_type( string type_compared ) const
{
	bool is_equals = false;
	
	string type = this->get_symbol_type( );

	if( type == type_compared )
	{
		is_equals = true;
	} else
	{
		is_equals = false;
	}

	return is_equals;
}

bool Symbol::equals_value( string value_compared ) const
{
	bool is_equals = false;
	
	string value = this->get_symbol_value( );

	if( value == value_compared )
	{
		is_equals = true;
	} else
	{
		is_equals = false;
	}

	return is_equals;
}

