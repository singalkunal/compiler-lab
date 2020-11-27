%{
#include "c_subset.tab.h"
%}
%option noyywrap

space   [ \t]+
digit   [0-9]
integer {digit}+
realval {integer}\.{integer}
id      [a-zA-Z][a-zA-Z]*


%%
{space}         {}
"\n"            { yylineno += 1; }
"&&"            {return LAND;}
"||"            {return LOR;}
"!"             {return LNOT;}
"int"           {return INT;}
"float"         {return FLOAT;}
"void"          {return VOID;}
"switch"        {return SWITCH;}
"case"          {return CASE;}
"break"         {return BREAK;}
"default"       {return DEF;}
"if"            {printf("return %s\n", yytext);return IF;}
"else"          {return ELSE;}
{integer}       {yylval.ival=atoi(yytext); return INUM;}
{realval}       {yylval.fval=atof(yytext); return FNUM;}
{id}            {yylval.str=yytext; return ID;}
"<="            {return LE;}
">="            {return GE;}
"=="            {return EQ;}
"!="            {return NE;}
"<"             {return LT;}
">"             {return GT;}
"="             {return ASGN;}
"&"             {return BAND;}
"|"             {return BOR;}
"^"             {return BXOR;}
.               {printf("return %c\n", yytext[0]); return yytext[0];}
\/\/.*          {}
\/\*[.\n]+\*\/  {}


