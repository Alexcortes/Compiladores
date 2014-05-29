#ifndef RULES_H
#define RULES_H

#include <string>

#include "Symbol.h"
#include "SymbolTable.h"

using namespace std;

void initialize_symbol_table( SymbolTable& );

void start_program( SymbolTable& );
void end_program( );

void declare_variable( const string, const string, SymbolTable& );
string attribute_variable( string, string, SymbolTable& );

string print_text( const string, SymbolTable& );
string print_variable( const string, SymbolTable& );
string scan_variable( const string, SymbolTable& );

string calculate_plus_expression( string, string );
string calculate_minus_expression( string, string );
string calculate_times_expression( string, string );
void calculate_divide_expression( string, string );

#endif
