/* Counting of chars, words and lines (wc), where word = list of non-blank chars */

%{
#include <stdio.h>
int nc=0, nw=0, nl=0;
%}
%option noyywrap
word	[^ \t\n]+
eol	\n
%%
{word}	{nw++; nc+=yyleng;}
{eol}	{nl++; nc++;}
.	{nc++;}
%%
main()
{
  yylex();
  printf("%d %d %d\n", nl, nw, nc);
}

