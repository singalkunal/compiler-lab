%{
#include <stdio.h>
#include <math.h>

int yyerror (char const *s);
extern int yylex (void);
%}

%token NUM
/* defining associativity */
%left '-' '+'
%left '*' '/'
%left UMINUS    /* Unary minus */
%right '^'

%type <realval> exp NUM;
%start input
%union{
    double realval;
}

%%

input:  /* empty */ | input line;
line:   '\n' | exp '\n' { printf ("result = %f\n", $1); } | error '\n' {yyerrok; };
exp:    NUM                     { $$ = $1; } 
        | exp '+' exp           { $$ = $1 + $3; }
        | exp '-' exp           { $$ = $1 - $3; }
        | exp '*' exp           { $$ = $1 * $3; }
        | exp '/' exp           { $$ = $1 / $3; }
        | '-' exp %prec UMINUS  { $$ = -$2; }
        | exp '^' exp           { $$ = pow($1, $3);}
        | '(' exp ')'           { $$ = $2; }
;

%%

int yyerror(char const* s) {
    printf("%s\n", s);
    return 0;
}

int main() {
    printf("***Type 'exit' to exit***\n");
    yyparse();
}
