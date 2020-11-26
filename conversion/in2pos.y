%{
#include <stdio.h>
#include <math.h>

int yyerror (char const *s);
extern int yylex (void);
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

input:  /* empty */ | line
;
line:   '\n' | exp '\n' { printf("\n"); return 0;} | error '\n' {yyerrok; }
;
exp:    ID                      {printf("%s ", $1);}
        | exp '+' exp           {printf("+ ");}
        | exp '-' exp           {printf("- ");}
        | exp '*' exp           {printf("* ");}
        | exp '/' exp           {printf("/ ");}
        | '-' exp %prec UMINUS  {printf("- ");}
        | exp '^' exp           {printf("^ ");}
        | '(' exp ')'           {}
;

%%

int yyerror(char const* s) {
    printf("!!Parsing Failed!!\n%s\n", s);
    return 0;
}

int main() { 
    yyparse();
}
