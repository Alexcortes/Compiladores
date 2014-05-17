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

string Symbol::get_symbol_name()
{
	return this->symbol_name;
}

string Symbol::get_symbol_type( )
{
	return this->symbol_type;
}

string Symbol::get_symbol_value( )
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
