/* Attenzione: operatora è colorato perchè è una keyword del C++,
	ma ciò non ci interessa assolutamente. poteva chiamarsi pincopallino */

%{
#include <ctype.h>
#include <stdio.h>
%}
%token RNUM
%union {float value; char operatora;}
%type <value> expr term factor RNUM
%type <operatora> addop mulop
%%
line   :  expr '\n' {printf("%f\n", $1);}
       ;

expr   :  expr addop term  
          {switch($2)
            {case '+': $$ = $1 + $3; break; 
             case '-': $$ = $1 - $3; break;}}
       |  term
       ;

term   :  term mulop factor 
          {switch($2)
            {case '*': $$ = $1 * $3; break; 
             case '/': $$ = $1 / $3; break;}}
       |  factor
       ;

factor  :  '(' expr ')'  {$$ = $2;}
        |  RNUM
        ;

addop  : '+'  {$$ = '+';}
       |  '-'  {$$ = '-';}
       ;

mulop  : '*'  {$$ = '*';}
       |  '/'  {$$ = '/';}

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


