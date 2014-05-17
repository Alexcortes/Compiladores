#include <iostream>
#include <iterator>
#include <string>
#include <cmath>

#include "SymbolTable.h"

using namespace std;

/* Empty constructor of SymbolTable. */
SymbolTable::SymbolTable( )
{
	// Nothing To Do
}

/* This function provides the action to insert, in symbol table, 
 * new symbols that can be used later in the compiler. */
void SymbolTable::insert_symbol( const Symbol inserted_symbol )
{
		this->table.push_back( inserted_symbol );
}

/* This function provides the action of deleting symbols of the 
 * symbol table. */
void SymbolTable::delete_symbol( Symbol deleted_symbol )
{	
	const unsigned int length_table = this->table.size();
	
	for( unsigned int i = 0; i < length_table; i++ )
	{
		const string tested_name   = table[ i ].get_symbol_name();
		const string searched_name = deleted_symbol.get_symbol_name();
		
		if( tested_name == searched_name )
		{	
			this->table.erase( table.begin() + ( i - 1 ) );
			
		} else
		{
			// Nothing To Do
		}
	}
}

/* This function provides the action to delet all symbols in symbol
 * table. */
void SymbolTable::delete_all_symbols( )
{
	this->table.clear( );
}

/* This function provides the action to seek a symbol inserted in symbol
 * table. */
Symbol SymbolTable::find_symbol_by_name( const string searched_name )
{
	Symbol found_symbol("not valid");
	
	const unsigned int length_table = this->table.size();
	
	for( unsigned int i = 0; i < length_table; i++ )
	{
		string tested_name = table[ i ].get_symbol_name();
		
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

/* Provides the actual size of the symbol table. */
int SymbolTable::size_table( )
{
	const int size_of_table = this->table.size();
	return size_of_table;
}

vector<Symbol> SymbolTable::get_table( )
{
	return this->table;
}

/* This function provides the ability to list all elements contained 
 * in the table. */
void SymbolTable::list_table_elements( )
{
	vector<Symbol> listed_table = this->table;
	const unsigned int length_table = this->table.size();
	
	for( unsigned int i = 0; i < length_table; i++ )
	{
		string name_element = table[ i ].get_symbol_name();
		
		cout << i << ". " << name_element << endl;
	}
	
	cout << endl;
}
