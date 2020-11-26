%{
#include <stdio.h>
#include "simple_calc.tab.h"    /* bridge file b/w bison and flex */
char ch;
float temp;
%}

digit   [0-9]
integer {digit}+
expon   [eE][-+]?{integer}
realval {integer}("."{integer})?{expon}?

%%

[ \t] {}
{realval}  {yylval.realval=atof(yytext); return NUM;} /*yylval contains semantic values for tokens*/
"\n"      {return '\n';}
"exit"  {return 0;}
.       {return yytext[0];}

%%

int yywrap(){return 1; /* called when i/p is exhausted => 1->no more i/p*/}
