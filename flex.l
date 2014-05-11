%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	#include "bison.h"
%}

DIGIT			[0-9]
CHARACTER	[a-zA-Z]
LITERAL		[a-zA-Z0-9][a-zA-Z0-9]*

IDENTIFIER	_?[a-zA-Z0-9][a-zA-Z0-9]*

INTEGER		{DIGIT}+

%%

"literal" return(TYPE_STRING);
"inteiro" return(TYPE_INT);
"caractere" return(TYPE_CHAR);
"real" return(TYPE_FLOAT);

":" return(COLON);

{CHARACTER} {
	yylval.text = strdup(yytext);
	return CHAR;
}

{INTEGER} {
	yylval.integer = atoi(yytext);
	return INT;
}

{IDENTIFIER} { 
	yylval.text = strdup(yytext);
	return VARIABLE;
}

%%

yywrap () {
return 0;
}
