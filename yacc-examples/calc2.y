/* Estensione da CIFRE a NUMERI . Aggiunta del segno MENO.
	OVERRIDEN BY : calc_4_59	(pag 292) 					*/
%{
#include <ctype.h>
#include <stdio.h>
%}
%token NUM
%left '+' '-'
%left '*' '/'
%right UMINUS
%%
lines  :  lines expr '\n' {printf("%d\n", $2);}
       |  lines '\n'
       |  /* vuoto */
       ;
expr   :  expr '+' expr  {$$ = $1 + $3;} 
       |  expr '-' expr  {$$ = $1 - $3;}
       |  expr '*' expr  {$$ = $1 * $3;}
       |  expr '/' expr  {$$ = $1 / $3;}
       |  '(' expr ')'   {$$ = $2;}
       |  '-'  expr %prec UMINUS {$$ = -$2;}
       |  NUM
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
		scanf("%d", &yylval);
		return(NUM);
	}
	return(c);
}

yyerror()
{ fprintf(stderr, "Syntax error\n"); }

main()
{ yyparse(); }


