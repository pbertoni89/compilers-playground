%{
#include <ctype.h>
#include <stdio.h>
typedef union {float value; char operator;} Value;
#define YYSTYPE Value
%}
%token RNUM
%%
line   :  expr '\n' {printf("%f\n", $1.value);}
       ;

expr   :  expr addop term  
          {switch($2.operator)
            {case '+': $$.value = $1.value + $3.value; break; 
             case '-': $$.value = $1.value - $3.value; break;}}
       |  term
       ;

term   :  term mulop factor 
          {switch($2.operator)
            {case '*': $$.value = $1.value * $3.value; break; 
             case '/': $$.value = $1.value / $3.value; break;}}
       |  factor
       ;

factor  :  '(' expr ')'  {$$.value = $2.value;}
        |  RNUM
        ;

addop  : '+'  {$$.operator = '+';}
       | '-'  {$$.operator = '-';}
       ;

mulop  : '*'  {$$.operator = '*';}
       | '/'  {$$.operator = '/';}

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


