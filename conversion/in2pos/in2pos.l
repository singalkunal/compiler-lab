%{
#include <stdio.h>
#include "in2pos.tab.h"
%}

spaces  [ \t]+;
digit   [0-9]
alpha   [a-zA-Z]
integer {digit}+
id      {alpha}+{digit}*{alpha}*

%%

{spaces}    {}
{id}        {yylval.id=yytext; return ID;}
{integer}   {yylval.id=yytext; return ID;}
"\n"        {return '\n';}
.           {return yytext[0];}

%%

int yywrap() {return 1;}
