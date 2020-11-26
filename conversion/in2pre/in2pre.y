%{
#include <stdio.h>
#include <cstdlib>
#include <string.h>

int yyerror (char const *s);
extern int yylex (void);
void set_input_string(const char* in);
void end_lexical_scan(void);
char* reverse(char* str);

char* pos=(char*)malloc(200);
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
line:   '\n' | exp '\n' { printf("Prefix: %s\n", reverse(pos)); top=0; pos=(char*)malloc(200);} | error '\n' {yyerrok; }
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

int parse_string(const char* in) {
  set_input_string(in);
  int rv = yyparse();
  end_lexical_scan();
  return rv;
}

char* reverse(char* str) {
    int i=0, j=strlen(str)-1;
    while(i<j) {
        char c=str[i];
        str[i]=str[j];
        str[j]=c;
        i++; j--;
    }
    return str;
}
