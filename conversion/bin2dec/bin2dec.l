%{
#include <stdio.h>
#include "bin2dec.tab.h"
bool flag=0;
/*  expb -> expression before decimal point 
 *  expa -> expression after decimal point
*/

%}
%option noyywrap

space   [ \t]+
bin     [012]


%%

{space}     {}
{bin}       {yylval.val=atoi(yytext); if(flag) {return NUMA;} return NUMB; }
"."         {flag=1;}
"\n"        {flag=0; return '\n';}

