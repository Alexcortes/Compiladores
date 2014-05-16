#include <string>
#include <map>
#include <vector>

#include "Symbol.h"

using namespace std;

class SymbolTable
{
	private:
		SymbolTable instanceSymbolTable;

	public:
		SymbolTable get_Instance( );

		void insert_symbol( Symbol );
		void delete_symbol( Symbol );

		Symbol find_symbol( Symbol );

	private:
		SymbolTable( );
};
