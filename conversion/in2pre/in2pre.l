%{
#include <stdio.h>
#include "in2pre.tab.h"
extern int parse_string(const char* in);
extern char* reverse(char* str);

%}

exit    "exit"
spaces  [ \t]+;
digit   [0-9]
alpha   [a-zA-Z]
integer {digit}+
id      {alpha}+{digit}*{alpha}*

%%


{spaces}    {}
{exit}      {return 0;}
{id}        {yylval.id=yytext; return ID;}
{integer}   {yylval.id=yytext; return ID;}
"\n"        {return '\n';}
.           {return yytext[0];}

%%

int yywrap() {return 1;}

void set_input_string(const char* in) {
  yy_scan_string(in);
}

void end_lexical_scan(void) {
  yy_delete_buffer(YY_CURRENT_BUFFER);
}
int main() {
    char* in=(char*)malloc(200);
    printf("Infix: ");
    scanf("%s", in);
    int l=strlen(in);
    in = reverse(in);
    in[l++]='\n';
    in[l]='\0';
    parse_string(in);
}
