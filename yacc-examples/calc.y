%{
#include <stdio.h>
#include <ctype.h>
%}

%token DIGIT

%%

line    :   expr '\n'  { printf("line %2d\n", $1); } 
        ;
expr    :   expr '+' term  { $$ = $1 + $3; } 
        |   term
        ;
term    :   term '*' factor  { $$ = $1 * $3; } 
        |   factor
        ;
factor  :   '(' expr ')' { $$ = $2; } 
        |   DIGIT
        ;
%%

yylex()
{
	int c;
	c = getchar();
	if (isdigit(c))
	{
		yylval = c - '0';	// DEALS WITH ASCII AS GUESSED
		return(DIGIT);
	}
	return(c);
}

yyerror()
{ fprintf(stderr, "Syntax error\n"); }

main()
{ yyparse(); }

