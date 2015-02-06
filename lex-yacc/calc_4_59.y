%{
	#include <ctype.h>
	#include <stdio.h>
	#define YYSTYPE double
%}
	%token NUMBER	/* double type for Yacc stack.
						PUO' CHIAMARSI COME MI PARE */
	%left '+' '-'
	%left '*' '/'
	%right UNAMINUS
%%
	lines	: lines expr '\n'	{ printf(" %g\n", $2 ); }
			| lines '\n'
			|
			;

	expr	: expr '+' expr { $$ = $1 + $3; }
			| expr '-' expr { $$ = $1 - $3; }
			| expr '*' expr { $$ = $1 * $3; }
			| expr '/' expr { $$ = $1 / $3; }
			| '(' expr ')'  { $$ = $2; }
			| '-' expr %prec UNAMINUS { $$ = - $2; }
			| NUMBER
			;
%%
yylex()
{
	int c;
	while(( c = getchar ( ) ) == ' ')
		;
	if (( c == '.') || ( isdigit( c )))
	{
		ungetc(c, stdin);
		scanf("%lf", &yylval);
		return NUMBER;
	}
	return c;
}

/* REQUIRED; NOT SUPPLIED BY DEFAULT. at least, with call:
		bison -v -o											*/
yyerror()
{
	fprintf(stderr, "Syntax error\n");
}

/* REQUIRED; NOT SUPPLIED BY DEFAULT. at least, with call:
		bison -v -o											*/
main()
{
	yyparse();
}