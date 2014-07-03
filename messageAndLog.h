#ifndef MESSAGEANDLOG_H
#define MESSAGEANDLOG_H

#include <string>

#include "SymbolTable.h"

#define ENABLE true
#define DISABLE false

#define UNDECLARED_VARIABLE -1
#define VARIABLE_ALREADY_DECLARED -2
#define IMPOSSIBLE_TO_ASSIGN -3
#define IMPOSSIBLE_COMPARISON -4
#define NOT_DECLARATION_THEN -5
#define BLOCK_NOT_CLOSED -6
#define BLOCK_UNDECLARED -7

using namespace std;

void print_message_undeclared_variable( );
void print_message_variable_already_declared( );
void print_message_impossible_to_assign( );
void print_message_impossible_comparison( );
void print_message_not_declaration_then( );
void print_message_block_not_closed( );
void print_message_block_undeclared();

void log_message( string, SymbolTable&, bool );
void log_variable( string, SymbolTable&, bool );

#endif
