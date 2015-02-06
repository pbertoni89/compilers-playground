/* Selection of lines which both start and end with character a
   and contain other characters, all different from a  */

%{
#include <stdio.h>
%}
%option noyywrap
a_line_a     a[^a\n]+a\n
%%
{a_line_a} ECHO;
.*\n      ;
%%
main()
{
   yylex();
   return(0);
}


