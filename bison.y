%{
/* Includes */

#include <stdlib.h>
#include <stdio.h>
%}

/* Tokens */

%token LEFT_PARENTHESIS RIGHT_PARENTHESIS
%token END
%token PRINTF 
%token COMMA QUOTES SEMICOLON COLON
%token STRING FLOAT INT VARIABLE CHAR
%token T_STRING T_INT T_FLOAT T_CHAR

%%
/* Rules */
// This rules is about the definitions of the variables
definitions:
	VARIABLE COLON T_STRING
	|VARIABLE COLON T_INT
	|VARIABLE COLON T_FLOAT
	|VARIABLE COLON T_CHAR
	;

// This rules define what is a content. It's used specially in the strings
content:
	QUOTES STRING QUOTES
	|VARIABLE
	|VARIABLE COMMA content
	|QUOTES STRING QUOTES COMMA content
	;

// This rule define the function printf(  )
output:
	PRINTF LEFT_PARANTHESIS content RIGHT_PARENTHESIS SEMICOLON
	;

%%
