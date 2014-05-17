#include <iostream>
#include <iterator>
#include <string>
#include <cmath>

#include "SymbolTable.h"

using namespace std;

SymbolTable::SymbolTable( )
{
	// Nothing To Do
}

void SymbolTable::insert_symbol( const Symbol inserted_symbol )
{
		this->table.push_back( inserted_symbol );
}

void SymbolTable::delete_symbol( Symbol deleted_symbol )
{	
	const unsigned int length_table = this->table.size();
	
	for( unsigned int i = 0; i < length_table; i++ )
	{
		const string tested_name   = table[ i ].get_name();
		const string searched_name = deleted_symbol.get_name();
		
		if( tested_name == searched_name )
		{	
			this->table.erase( table.begin() + ( i - 1 ) );
			
		} else
		{
			// Nothing To Do
		}
	}
}

void SymbolTable::delete_all_symbols( )
{
	this->table.clear( );
}

Symbol SymbolTable::find_symbolByName( const string searched_name )
{
	Symbol found_symbol("not valid");
	
	const unsigned int length_table = this->table.size();
	
	for( unsigned int i = 0; i < length_table; i++ )
	{
		string tested_name   = table[ i ].get_name();
		
		if( tested_name == searched_name )
		{		
			found_symbol = table[ i ];
			
		} else
		{
			// Nothing To Do
		}
	}
	
	return found_symbol;
}


int SymbolTable::size_table( )
{
	const int size_of_table = this->table.size();
	return size_of_table;
}

vector<Symbol> SymbolTable::get_table( )
{
	return this->table;
}

void SymbolTable::list_table_elements( )
{
	vector<Symbol> listed_table = this->table;
	const unsigned int length_table = this->table.size();
	
	for( unsigned int i = 0; i < length_table; i++ )
	{
		string name_element = table[ i ].get_name();
		
		cout << i << ". " << name_element << endl;
	}
	
	cout << endl;
}
