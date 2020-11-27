%{
#include <bits/stdc++.h>
#include <stdio.h>
#include "symtable.h"
using namespace std;

int yyerror (char const *s);
extern int yylex (void);
extern int yyparse();
extern FILE* yyin;
extern char* yytext;

FILE* out;
vector<int> labels;
int var=0;

%}

%{
void pushme();
void gencode();
void labelif();
void labelelse();
void endelse();
%}

%token INT FLOAT VOID
%token WHILE
%token IF ELSE SWITCH CASE BREAK DEF
%token INUM FNUM ID
%right ASGN 
%left LOR
%left LAND
%left LNOT
%left BOR
%left BXOR
%left BAND
%left EQ NE 
%left LE GE LT GT
%left '+' '-' 
%left '*' '/'

%type <str> exp ID INUM FNUM

%union{
    int ival;
    double fval;
    char* str=(char*)malloc(400);
}

%%

prgrm:  /*empty*/ | TYPE ID '(' ')' STMT_LIST
;
STMT_LIST:  | '{' STMTS '}'
;
STMTS:  | STMT STMTS
;

STMT:       STMT_IF
;

exp:    exp '+'     { pushme(); }   exp     { gencode(); }
        | exp '-'   { pushme(); }   exp     { gencode(); }
        | exp '*'   { pushme(); }   exp     { gencode(); }
        | exp '/'   { pushme(); }   exp     { gencode(); }
        | exp BOR   { pushme(); }   exp     { gencode(); }
        | exp BXOR  { pushme(); }   exp     { gencode(); }
        | exp BAND  { pushme(); }   exp     { gencode(); }
        | exp EQ    { pushme(); }   exp     { gencode(); }
        | exp NE    { pushme(); }   exp     { gencode(); }
        | exp LE    { pushme(); }   exp     { gencode(); }
        | exp GE    { pushme(); }   exp     { gencode(); }
        | exp LT    { pushme(); }   exp     { gencode(); }
        | exp GT    { pushme(); }   exp     { gencode(); }
        | exp LNOT  { pushme(); }   exp     { gencode(); }
        | exp LAND  { pushme(); }   exp     { gencode(); }
        | exp LOR   { pushme(); }   exp     { gencode(); }
        | exp ASGN  { pushme(); }   exp     { gencode(); }
        | '('exp')' {           }
        | INUM      { pushme(); }
        | FNUM      { pushme(); } 
        | ID        { pushme(); } 
;

STMT_IF:    IF '(' exp ')' { labelif(); } STMT_LIST STMT_ELSE
;
STMT_ELSE:  ELSE { labelelse(); } STMT_LIST { endelse(); }
;


TYPE:   INT | FLOAT | VOID
;

%%
#include <ctype.h>

int lnum=0, top=0;
char st[100][20];

void pushme() {
    strcpy(st[++top], yytext);
}

void labelif() {
    ++lnum;
    fprintf(out, "ifFalse %s then goto $L%d\n", st[top], lnum);
    labels.push_back(lnum);
    /* $L{lnum} will be stmts of else */
}

void labelelse() {
    ++lnum;
    fprintf(out, "else goto $L%d\n", lnum);     /* skip else */
    fprintf(out, "$L%d\n", labels.back());        /* run stmts of else */
    labels.back() = lnum;
}

void endelse() {
    fprintf(out, "$L%d\n", labels.back());
    labels.pop_back();
}

void gencode() {
    if(!strcmp(st[top-1], "=")) {   // ASSIGNMENT
        fprintf(out, "%s = %s\n", st[top-2], st[top]);
        top -= 2;
        strcpy(st[top], st[top-2]);
        return;
    }

    char temp[10];
    var++;
    sprintf(temp, "%d", var);
    char word[]="t";
    strcat(word, temp);
    fprintf(out, "%s = %s %s %s\n", word, st[top-2], st[top-1], st[top]);
    top -= 2;
    strcpy(st[top], word);
}

int yyerror(char const* s) {
    printf("%s\n", s);
    return 0;
}

int main() {
    var=0;
    /*
    char* input = (char*) malloc(20);
    printf("Enter input filename: ");
    scanf("%s", input);

    yyin = fopen(input, "r");*/
    out=fopen("output.txt", "w");

    if(!yyparse())
        printf("<<< Parsed Successfully >>>\n");
    else printf("!! Parsing Failed !!\n");


    //fclose(yyin);
    fclose(out);
}


