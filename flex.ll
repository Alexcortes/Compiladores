%option noyywrap

%{
	#include <cstdio>
	#include <cstdlib>

	#include "bison.h"
%}

DIGIT			[0-9]
INTEGER		{DIGIT}+
REAL			-?{INTEGER}("."{INTEGER})?

CHARACTER	[a-zA-Z]
LITERAL		\"[a-zA-Z0-9][a-zA-Z0-9].*\"

IDENTIFIER	_?[a-zA-Z0-9][a-zA-Z0-9]*
WHITESPACE	[ ]+

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
"leia"		return(SCANF);

(?# Identificadores matemáticos )
"+" return(PLUS);
"=" return(EQUAL);
"-" return(MINUS);
"/" return(DIVIDE);
"*" return(TIMES);

(?# Pontuação permitida )
":" return(COLON);
":=" return(ATTRIBUTION);

(?# Marcadores )
"\n" return(NEWLINE);
"inicio" return(START);
"final" return(END);

{REAL} {
	yylval.text = strdup(yytext);
	return NUMBER;
}

{IDENTIFIER} { 
	yylval.text = strdup(yytext);
	return VARIABLE;
}

{LITERAL} {
	yylval.text = strdup(yytext);
	return STRING;
}

%%
