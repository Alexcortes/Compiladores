%{
#include <stdio.h>
#include <stdlib.h>
%}

/* Tokens */

// These tokens refer to the language punctuation
%token LEFT_PARENTHESIS RIGHT_PARENTHESIS
%token END BEGIN
%token COMMA QUOTES SEMICOLON COLON NEWLINE

// These tokens refer to the function of the language
%token PRINTF SCANF

// These tokens refer to the language types
%token STRING FLOAT INT VARIABLE CHAR BOOLEAN
%token T_STRING T_INT T_FLOAT T_CHAR T_BOOLEAN

// These tokens refer to the language operators
%token EQUALS DIFERENT BIGGER SMALLER BIGGEREQUAL SMALLEREQUAL
%token PLUS MINUS DIVIDE TIMES EQUAL

// These tokens refer to control struct
%token IF ENDIF ELSE ENDELSE THEN

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

// The rules define attribution
attribution:
	VARIABLE EQUAL VARIABLE
	|VARIABLE EQUAL INT
	|VARIABLE EQUAL FLOAT
	|VARIABLE EQUAL STRING
	|VARIABLE EQUAL CHAR
	|VARIABLE EQUAL BOOLEAN
	;

// These rules define what is a content. It's used specially in the strings
content:
	QUOTES STRING QUOTES
	| VARIABLE
	| VARIABLE COMMA content
	| QUOTES STRING QUOTES COMMA content
	;

// These rules define the function printf(  ) and scanf( )
output:
	PRINTF LEFT_PARENTHESIS content RIGHT_PARENTHESIS SEMICOLON
	;

input:
	VARIABLE SCANF LEFT_PARENTHESIS RIGHT_PARENTHESIS SEMICOLON
	;

// These rules define expressions:
	 VARIABLE
	 | logical_expression EQUALS logical_expression
	 | logical_expression DIFERENT logical_expression
	 | logical_expression BIGGER logical_expression
	 | logical_expression SMALLER logical_expression
	 | logical_expression BIGGEREQUAL logical_expression
	 | logical_expression SMALLEREQUAL logical_expression
	 | LEFT_PARENTHESIS logical_expression RIGHT_PARENTHESIS
	 ;

math_expressions:
	FLOAT
	|INTEGER
	|VARIABLE
	|math_expressions PLUS math_expressions 
	|math_expressions MINUS math_expressions
	|math_expressions DIVIDE math_expressions
	|math_expressions TIMES math_expressions 
	|math_expressions PLUS math_expressions EQUAL math_expressions
	|math_expressions MINUS math_expressions EQUAL math_expressions
	|math_expressions DIVIDE math_expressions EQUAL math_expressions
	|math_expressions TIMES math_expressions  EQUAL math_expressions
	;

block_expressions:
	math_expressions block_expressions
	|condition_expressions block_expressions
	|logical_expression block_expressions
	|output block_expressions
	|ENDIF
	;

condition_expressions:
	IF LEFT_PARENTHESIS logical_expression RIGHT_PARENTHESIS THEN block_expressions ENDIF
	|IF LEFT_PARENTHESIS math_expressions RIGHT_PARENTHESIS	THEN block_expressions ENDIF
	|IF LEFT_PARENTHESIS logical_expression RIGHT_PARENTHESIS THEN block_expressions ENDIF condition_expressions
	|IF LEFT_PARENTHESIS math_expressions RIGHT_PARENTHESIS	THEN block_expressions ENDIF condition_expressions
	|ELSE block_expressions ENDELSE
	|ELSE LEFT_PARENTHESIS logical_expression RIGHT_PARENTHESIS block_expressions ENDELSE
	|ELSE LEFT_PARENTHESIS math_expressions RIGHT_PARENTHESIS block_expressions ENDELSE
	;

loop_expressions:
	;

//These rules define content's program
content_program:
	definitions
	|definitions content_program
	|attribution
	|attribution content_program
	|output
	|output content_program
	|logical_expression
	|logical_expression content_program
	|condition_expressions
	|condition_expressions content_program	
	|math_expressions 
	|math_expressions content_program	
	;

program:
	BEGIN content_program END
	;
%%
