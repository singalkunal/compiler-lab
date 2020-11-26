%{
    unsigned charCnt=0, wordCnt=0, lineCnt=0;
%}

word [^ \t\n]+
eol \n

%%

{word}  {wordCnt++, charCnt += yyleng; }
{eol}   {charCnt++; lineCnt++;}
.       {charCnt++;}


%%

int yywrap(){}

int main()
{
    FILE *fp; 
    char filename[50]; 
    printf("Enter the filename: \n"); 
    scanf("%s",filename); 
    fp = fopen(filename,"r"); 
    yyin = fp; 


    yylex();
    printf("char count: %d\n Word count: %d\n Line count: %d\n", charCnt, wordCnt, lineCnt);
    return 0;
}
