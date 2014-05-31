#include <iostream>
#include <string>

#include "Symbol.h"
#include "SymbolTable.h"
#include "messageAndLog.h"

using namespace std;

void print_message_undeclared_variable( )
{
	cout << "ALERTA!" << endl 
		  << "Variável não declarada!" << endl;
}

void print_message_variable_already_declared( )
{
	cout << "ALERTA!" << endl
		  <<"Variável já declarada!" << endl;
}

void print_message_impossible_to_assign( )
{
	cout << "ALERTA!" << endl
        << "Não é possível atribuir! O tipo da variável e do valor não correspondem." << endl;
}

void print_message_impossible_comparison( )
{
	cout << "ALERTA!" << endl
        << "Não é possível comparar dois valores cujos tipos não correspondem." << endl;
}

void log_message( string message, SymbolTable& table, bool status_key )
{
	if( status_key )
	{
		cout << message << endl;
	} else
	{
		// Nothing To Do
	}
}

void log_variable( string variable_name, SymbolTable& table, bool status_key )
{
	if( status_key )
	{
		if( table.exist_symbol( variable_name ) )
		{
			Symbol variable = table.find_symbol_by_name( variable_name );
			variable.list_attributes_symbol();

		} else
		{
			print_message_undeclared_variable( );
		}

	} else
	{
		// Nothing To Do
	}
}

