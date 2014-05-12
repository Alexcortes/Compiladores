%{
	#include <stdio.h>
	#include <stdlib.h>

	#include "bison.h"
%}

DIGIT			[0-9]
INTEGER		{DIGIT}+

CHARACTER	[a-zA-Z]
LITERAL		[a-zA-Z0-9][a-zA-Z0-9]*

IDENTIFIER	_?[a-zA-Z0-9][a-zA-Z0-9]*
WHITESPACE	[\n\r\t]+

TRUE			[1]|"verdadeiro"
FALSE			[0]|"falso"
BOOLEAN		{TRUE}|{FALSE}

%%

(?# Tipos de variáveis permitidas )
"literal"	return(TYPE_STRING);
"inteiro"	return(TYPE_INT);
"caractere" return(TYPE_CHAR);
"real"		return(TYPE_FLOAT);
"lógico"		return(TYPE_BOOLEAN);

(?# Funções para entrada e saída de dados )
"escreva"	return(PRINTF);

(?# Pontuação permitida )
":" return(COLON);

{CHARACTER} {
	yylval.text = strdup(yytext);
	return CHAR;
}

{LITERAL} {
	yylval.text = strdup(yytext);
	return STRING;
}

{IDENTIFIER} { 
	yylval.text = strdup(yytext);
	return VARIABLE;
}

%%

yywrap () {
return 0;
}
