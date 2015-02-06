/* Generation of lines preceded by their position number */

%{
#include <stdio.h>
int l = 1;
%}
%option	noyywrap
line	.*\n
%%
{line}	{printf("%d %s", l++, yytext);}
%%
main()
{
  yylex();
}
