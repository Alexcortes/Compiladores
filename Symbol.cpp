#include <iostream>
#include <string>

#include "Symbol.h"

using namespace std;

Symbol::Symbol( string name )
{
	this->set_name( name );
}

string Symbol::get_name()
{
	return this->symbol_name;
}

void Symbol::set_name( string name )
{
	this->symbol_name = name;
}
