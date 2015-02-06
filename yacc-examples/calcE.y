%{
#include <ctype.h>
#include <stdio.h>
typedef union {float value; char operator;} Value;
#define YYSTYPE Value
%}
%token RNUM
%token INTEGER
%%
program:
	program expr '\n'	{ printf("%d\n", $2); }
	|
	;
expr:
	INTEGER			{ $$ = $1; }
	| expr '+' expr		{ $$ = $1 + $3; }
	| expr '-' expr		{ $$ = $1 - $3; }
	;

%%

yylex()
{
  int c;

  while((c = getchar()) == ' ' || c == '\t')
     ;
  if (isdigit(c))
  {
    ungetc(c, stdin);
    scanf("%f", &yylval.value);
    return(RNUM);
  }
  return(c);
}

yyerror()
{ fprintf(stderr, "Syntax error\n"); }

main()
{ yyparse(); }


