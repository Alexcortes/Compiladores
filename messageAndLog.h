#ifndef MESSAGEANDLOG_H
#define MESSAGEANDLOG_H

#include <string>

#define ENABLE true
#define DISABLE false

#define UNDECLARED_VARIABLE -1
#define VARIABLE_ALREADY_DECLARED -2
#define IMPOSSIBLE_TO_ASSIGN -3
#define IMPOSSIBLE_COMPARISON -4

using namespace std;

void print_message_undeclared_variable( );
void print_message_variable_already_declared( );
void print_message_impossible_to_assign( );
void print_message_impossible_comparison( );

void log_message( string, SymbolTable&, bool );
void log_variable( string, SymbolTable&, bool );

#endif
