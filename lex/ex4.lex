/* Substitution of numbers with value >= 10 from decimal to hexadecimal notation + 
   printing of number of substitutions */
%{
	#include  <stdio.h>
	#include  <stdlib.h>
	int cont  = 0;
%}
	%option noyywrap
	digit     [0-9]
	num       {digit}{digit}+
%%
	{num} 	{	int n = atoi(yytext);
				printf("%x", n);
				cont++;
			}
%%
	main()
	{
		yylex();
		fprintf(stderr, "Tot substitutions = %d\n", cont);
		return(0);
	}