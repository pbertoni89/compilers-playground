/* Selection of lines which either start or end with character a */

%{
#include <stdio.h>
%}
%option noyywrap
a_line     a.*\n
line_a     .*a\n
%%
{a_line} ECHO;
{line_a} ECHO;
.*\n      ;
%%
main()
{
   yylex();
   return(0);
}


