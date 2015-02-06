/* Substitution of uppercase with lowercase letters, except those in (Pascal) comments */

%{
#include <stdio.h>
%}
%option noyywrap
%%
[A-Z]	    {putchar(tolower(yytext[0]));}
\{[^\}]*\}  ECHO;
%%
main()
{
  yylex();
}

