%{
#include "global.h"
#include "bison.h"
#include <stdlib.h>
%}

TRUE [1]|"verdadeiro"
FALSE [0]|"falso"
DIGIT [0-9]
BOOLEAN {TRUE}|{FALSE}
INTEGER -?{DIGIT}+
FLOAT -?{INTEGER}("."{INTEGER})?
STRING [a - zA - Z0 - 9][a - zA - Z0 - 9]*
WHITESPACE [\n\r\t]+
VARIABLE _?[a - zA - Z][a - zA - Z0 - 9]*
CHAR [a - zA - Z]

%%

{WHITESPACE} { /*We ignore white characters*/ }
{FLOAT} {
yylval=atof(yytext);
return(NUMBER);
}

(?# Expressoes matematicas)
"+" return(PLUS);
"-" return(MINUS);
"*" return(TIMES);
"/" return(DIVIDE);
"=" return(EQUAL);
"(" return(LEFT_PARENTHESIS);
")" return(RIGHT_PARENTHESIS);

"\n" return(NEWLINE);

(?# Expressoes de comparacao)
"=" return(EQUALS);
"<>" return(DIFERENT);
">" return(BIGGER);
"<" return(SMALLER);
"<=" return(SMALLEREQUAL);
">=" return(BIGGEREQUAL);

(?# Entrada saida de dados) 
"escreva" return(PRINTF);
"leia" return(SCANF);

(?# Tipos de variáveis)
"literal" return(T_STRING);
"inteiro" return(T_INT);
"real" return(T_FLOAT);
"caractere" return(T_CHAR)"
"lógico"  return(T_BOOLEAN);
 
(?# Estruturas da linguagem)
"se" return(IF);
"senao" return(ELSE);
"fim-se" return(ENDIF);
"fim-senao" return(ENDELSE);
"entao" return (THEN);

"faca" return(DO);
"fim-faca" return(ENDDO);
"para" return(FOR);
"fim-para" return(ENDFOR);
"enquanto" return(WHILE);
"fim-enquanto" return(ENDWHILE);

"inicio" return(BEGIN);
"fim" return(END);

(?# Pontuação)
"," return(COMMA);
"\"" return(QUOTES);
";" return(SEMICOLON);
":" return(COLON);
":=" return(ATTRIBUTION);

(?# Definições)
INTEGER return(INT);
FLOAT return(FLOAT);
STRING return(STRING);
VARIABLE return(VARIABLE);
CHAR return(CHAR);
BOOLEAN return(BOOLEAN);
%%

yywrap () {
return 0;
}
