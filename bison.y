%{
/* Includes */

#include <stdlib.h>
#include <stdio.h>
%}

/* Tokens */

// These tokens refer to the language punctuation
%token LEFT_PARENTHESIS RIGHT_PARENTHESIS
%token END
%token COMMA QUOTES SEMICOLON COLON

// These tokens refer to the function of the language
%token PRINTF

// These tokens refer to the language types
%token STRING FLOAT INT VARIABLE CHAR
%token T_STRING T_INT T_FLOAT T_CHAR

// These tokens refer to the language operators
%token EQUALS DIFERENT BIGGER SMALLER BIGGEREQUAL SMALLEREQUAL
%token PLUS MINUS DIVIDE TIMES

%%
/* Rules */
// These rules is about the definitions of the variables
definitions:
	VARIABLE COLON T_STRING
	| VARIABLE COLON T_INT
	| VARIABLE COLON T_FLOAT
	| VARIABLE COLON T_CHAR
	;

// These rules define what is a content. It's used specially in the strings
content:
	QUOTES STRING QUOTES
	| VARIABLE
	| VARIABLE COMMA content
	| QUOTES STRING QUOTES COMMA content
	;

// This rule define the function printf(  )
output:
	PRINTF LEFT_PARANTHESIS content RIGHT_PARENTHESIS SEMICOLON
	;

// These rules definen Boolean tests for simple conditions such as equal, greater than or less than
	 
%%
