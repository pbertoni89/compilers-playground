/* Substitution of uppercase with lowercase letters, except those in C comments */

%{
#include <stdio.h>
#define FALSE 0
#define TRUE 1
%}
%option noyywrap
%%
[A-Z]	{putchar(tolower(yytext[0]));}
"/*"	{
		char c; 
		int end = FALSE;
        ECHO;
        do { 
			while ((c=input()) != '*')
				putchar(c);
			putchar(c);
			while ((c=input()) == '*')
				putchar(c);
			putchar(c);
			if(c == '/')
				end = TRUE;
			}
		while(!end);
		}
%%
main()
{
  yylex();
}

