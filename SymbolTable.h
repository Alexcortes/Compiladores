#ifndef SYMBOLTABLE_H
#define SYMBOLTABLE_H

#include <string>
#include <vector>

#include "Symbol.h"

using namespace std;

/* This class is the symbol table that are part of the lexical and 
 * syntactic part of the compiler. Through it the specific functions in 
 * this class are several possible actions, including the insertion and 
 * search symbols quickly and easily. */
class SymbolTable
{
	private:
		vector<Symbol> table;
	
	public:
		SymbolTable( );
		
		void insert_symbol( Symbol );
		void delete_symbol( string );
		void delete_all_symbols( );
		void list_table_elements( );
		
		int size_table( );

		Symbol find_symbol_by_name( string );
		
		vector<Symbol> get_table( );
};

#endif
