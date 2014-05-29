#ifndef RULES_H
#define RULES_H

#include <string>

#include "Symbol.h"
#include "SymbolTable.h"

using namespace std;

void initialize_symbol_table( SymbolTable& ); // OK

void start_program( SymbolTable& ); // OK
void end_program( ); // OK

void declare_variable( const string, const string, SymbolTable& ); // OK
string attribute_variable( string, string, SymbolTable& ); // OK

string print_text( const string, SymbolTable& ); // OK
string print_variable( const string, SymbolTable& ); // OK
string scan_variable( const string, SymbolTable& ); // OK

string calculate_plus_expression( string, string ); // OK
string calculate_minus_expression( string, string );
string calculate_times_expression( string, string );
void calculate_divide_expression( string, string );

vector<string> separate_parcel_to_result( string ); // OK

#endif
