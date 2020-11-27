%{
#include <stdio.h>

int yyerror (char const *s);
extern int yylex (void);

%}

%token NUMA NUMB

/*  expb -> expression before decimal point 
 *  expa -> expression after decimal point
*/

%type <val> exp expa expb NUMA NUMB
%union{
    double val;
}

%%

input:  /*empty*/ | input line
;
line:   '\n' | exp '\n' { printf("Decimal: %f\n", $1); }
;

exp:    expb expa   { $$ = $1 + $2; }
        | expb      { $$ = $1; }
;

expb:   NUMB        { $$ = $1; }
        | expb NUMB { $$ = $1*2+$2; }
;

expa:   NUMA        { $$ = $1/2; }
        | NUMA expa { $$ = $1/2+$2/2;  }
;

%%

int yyerror(char const* s) {
    printf("%s\n", s);
    return 0;
}

int main() {
    printf("Binary: ");
    yyparse();
}
