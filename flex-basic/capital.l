/*** Definition Section has one variable 
which can be accessed inside yylex() 
and main() ***/
%{ 
int count = 0; 
%} 

%% 
[A-Z] {printf("%s capital letter\n", yytext); 
	count++;} 
.	 {printf("%s not a capital letter\n", yytext);} 
\n {return 0;} 
%% 

int yywrap(){} 
int main(){ 

// Explanation: 
// yywrap() - wraps the above rule section 
/* yyin - takes the file pointer 
		which contains the input*/
/* yylex() - this is the main flex function 
		which runs the Rule Section*/
// yytext is the text in the buffer 

yylex(); 
printf("\nNumber of Captial letters "
	"in the given input - %d\n", count); 

return 0; 
} 

