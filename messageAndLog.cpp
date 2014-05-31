#include <iostream>
#include <string>
#include "messageAndLog.h"

using namespace std;

void print_message_undeclared_variable( )
{
	cout << "Variável não declarada!" << endl;
}

void print_message_variable_already_declared( )
{
	cout << "Variável já declarada!" << endl;
}

void print_message_impossible_to_assign( )
{
	cout << "Não é possível atribuir! O tipo da variável e do valor não correspondem." << endl;
}

void print_message_impossible_comparison( )
{
	cout << "Não é possível comparar dois valores cujos tipos não correspondem." << endl;
}

