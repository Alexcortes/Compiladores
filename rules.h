#ifndef RULES_H
#define RULES_H

#include <string>

#include "Symbol.h"
#include "SymbolTable.h"

using namespace std;

void start_program( );
void end_program( );

void declare_variable( const string, const string, SymbolTable& );
void attribute_variable( string, string );

string print_text( const string, SymbolTable& );
string print_variable( const string, SymbolTable& );
string scan_variable( const string, SymbolTable& );

void calculate_expression( string, string );

#endif
