%{
#include <stdio.h>
#include <cstdlib>
#include <string.h>

int yyerror (char const *s);
extern int yylex (void);

char* pos;
int top=0;

%}

%token ID
%left '-' '+'
%left '*' '/'
%left UMINUS
%right '^'

%type <id> exp ID
%union{
    char *id=(char*) malloc(20);
}

%%

input:  /* empty */ | input line
;
line:   '\n' | exp '\n' { printf("Postfix: %s\nInfix: ", pos); top=0; pos=(char*)malloc(200);} | error '\n' {yyerrok; }
;
exp:    ID                      {pos[top++]=$1[0];}
        | exp '+' exp           {pos[top++]='+';}
        | exp '-' exp           {pos[top++]='-';}
        | exp '*' exp           {pos[top++]='*';}
        | exp '/' exp           {pos[top++]='/';}
        | '-' exp %prec UMINUS  {pos[top++]='-';}
        | exp '^' exp           {pos[top++]='^';}
        | '(' exp ')'           {}
;

%%

int yyerror(char const* s) {
    printf("!!Parsing Failed!!\n%s\n", s);
    return 0;
}

int main() {
    pos=(char*)malloc(200);
    printf("Infix: ");
    yyparse();
}
