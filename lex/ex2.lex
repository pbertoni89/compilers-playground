/* Generation of lines in odd position */

%{
#include <stdio.h>
int l = 1;
%}
%option	noyywrap
line	.*\n
%%
{line}	{ if(l++%2)
            printf("%s", yytext);
        }
%%
main()
{
  yylex();
}
