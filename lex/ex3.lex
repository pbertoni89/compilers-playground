/* Substitution of numbers from decimal to hexadecimal notation + 
   printing of number of actual substitutions */
%{
	#include <stdio.h>
	#include <stdlib.h>
	int cont = 0;
%}
	%option noyywrap
	digit     [0-9]
	num       {digit}+
%%
	{num} 	{	int n = atoi(yytext);
				printf("%x", n);
				if (n > 9)
					cont++;
			}
%%
	main()
	{
	yylex();
	fprintf(stderr, "Tot substitutions = %d\n", cont);
	return(0);
	}

