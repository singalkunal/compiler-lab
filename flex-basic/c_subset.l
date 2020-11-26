%{
    unsigned int ids=0, key_words=0, ops=0, seps=0, nums=0, lineno=0, whitesp=0;
%}    

header [^>]+
%%



#include<[a-z.]+>           		    {++key_words, printf("%s :Header\n", yytext);}
"["   					    {++seps, printf("%s :SQOPEN\n", yytext);}
"]"   					    {++seps, printf("%s :SQCLOSE\n", yytext);}
"("   					    {++seps, printf("%s :Round Open RO\n", yytext);}
")"   					    {++seps, printf("%s :Round Close RC\n", yytext);}
"&&"   					    {++ops, printf("%s :logical AND\n", yytext);}
"||"   					    {++ops, printf("%s :logical OR\n", yytext);}
"!"   					    {++ops, printf("%s :logical NOT\n", yytext);}
int[' '\t]+ 				    {++key_words, printf("%s :Keyword INT\n", yytext);}
float[' '\t]+   		    	    {++key_words, printf("%s :Keyword Float\n", yytext);}
"<="   					    {++ops, printf("%s :Relational op LE\n", yytext);}
">="   					    {++ops, printf("%s Relational op GE\n", yytext);} 
"=="   					    {++ops, printf("%s :Relational op EQ\n", yytext);}
"<"    					    {++ops, printf("%s :Relational op LT\n", yytext);}
">"    					    {++ops, printf("%s :Relational op GT\n", yytext);}
"="    					    {++ops, printf("%s :Assignment op\n", yytext);}
"*"   					    {++ops, printf("%s :MUL\n", yytext);}
"+"   					    {++ops, printf("%s :Add\n", yytext);}
"/"   					    {++ops, printf("%s :Divide\n", yytext);}
"-"   					    {++ops, printf("%s :MINUS\n", yytext);}
";"   					    {++seps, printf("%s :Semi Colon\n", yytext);}
","   					    {++seps, printf("%s :Comma\n", yytext);}
"while"                     		    {++key_words, printf("%s :While keyword\n", yytext);}
"for"                       		    {++key_words, printf("%s : For keyword\n", yytext);}
"{"                         		    {++seps, printf("%s :Left Curly\n", yytext);}
"}"                         		    {++seps, printf("%s :Right Curly\n", yytext);}
"if"                        		    {++key_words, printf("%s :IF\n", yytext);}
"else"                      		    {++key_words, printf("%s :Else\n", yytext);}
"cout"                    		    {++key_words, printf("%s :cout\n", yytext);}
"cin"                    		    {++key_words, printf("%s :cin\n", yytext);}
"return"                    		    {++key_words, printf("%s :Return\n", yytext);}
"main"                                      {printf("%s :Main Keyword\n", yytext);}
[a-zA-Z][a-zA-Z0-9_]*       		    {++ids, printf("%s :Identifier\n", yytext);}
[0-9]+                      		    {++nums, printf("%s :Number\n", yytext);}
[ \t]					    {++whitesp;}
\n                          		    {++lineno;}

%%

int yywrap(){}

int main() {
    FILE *fp; 
    char filename[50]; 
    printf("Enter the filename: \n"); 
    scanf("%s",filename); 
    fp = fopen(filename,"r"); 
    yyin = fp; 

    yylex();
    printf("\n-------------------------------------\n");
    printf("#key_words:\t%d\n#identifiers:\t%d\n#operators:\t%d\n#numbers:\t%d\n#separators:\t%d\n#lines:\t%d\n#whtiespaces:\t%d\n",
    key_words, ids, ops, nums, seps, lineno, whitesp);
    return 0;
}
