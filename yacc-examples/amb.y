%{
#include <stdio.h>
%}

%token IF ELSE OTHER

%%

S  :  I
   |  OTHER 
   ;

I  :  IF S 
   |  IF S ELSE S
   ;
        
%%

yylex()
{ 
  return(0);
}

yyerror()
{ fprintf(stderr, "Syntax error\n"); }

main()
{ yyparse(); }

