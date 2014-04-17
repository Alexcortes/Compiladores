%{
/* Includes */

#include <stdlib.h>
#include <stdio.h>
%}

/* Tokens */

// These tokens refer to the language punctuation
%token LEFT_PARENTHESIS RIGHT_PARENTHESIS
%token END BEGIN
%token COMMA QUOTES SEMICOLON COLON NEWLINE

// These tokens refer to the function of the language
%token PRINTF

// These tokens refer to the language types
%token STRING FLOAT INT VARIABLE CHAR BOOLEAN
%token T_STRING T_INT T_FLOAT T_CHAR T_BOOLEAN

// These tokens refer to the language operators
%token EQUALS DIFERENT BIGGER SMALLER BIGGEREQUAL SMALLEREQUAL
%token PLUS MINUS DIVIDE TIMES

// These tokens refer to control struct
%token IF ENDIF ELSE

//These tokens refer to loop struct
%token DO WHILE FOR ENDWHILE ENDDO ENDFOR

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

// These rules define Boolean tests for simple conditions such as equal, greater than or less than
logical_expression:
	 VARIABLE
	 | logical_expression EQUALS logical_expression
	 | logical_expression DIFERENT logical_expression
	 | logical_expression BIGGER logical_expression
	 | logical_expression SMALLER logical_expression
	 | logical_expression BIGGEREQUAL logical_expression
	 | logical_expression SMALLEREQUAL logical_expression
	 | LEFT_PARANTHESIS logical_expression RIGHT_PARANTHESIS
	 ;
%%
