#ifndef CHECKS_H
#define CHECKS_H

#include <string>

using namespace std;

string check_variable_type( const string );
string check_value_type( const string );

bool check_is_string( const string );
bool check_is_char( const string );
bool check_exist_punctual( const string );
bool check_exist_digit( const string );
bool check_exist_R( const string );

#endif
