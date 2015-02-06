%{
	#include "parser.h"
	#include "def.h"
	int line = 1;
	Value lexval;
%}
%option noyywrap

spacing     ([ \t])+
letter      [A-Za-z]
digit       [0-9]
intconst    {digit}+
strconst    \"([^\"])*\"
boolconst   false|true
id          {letter}({letter}|{digit})*
sugar       [(){}:,]

%%

{spacing}   ;
\n          {line++;}
def         {return(DEF);}
integer     {return(INTEGER);}
string      {return(STRING);}
boolean     {return(BOOLEAN);}
{intconst}  {lexval.ival = atoi(yytext); return(INTCONST);}
{strconst}  {lexval.sval = newstring(yytext); return(STRCONST);}
{boolconst} {
				lexval.bval = (yytext[0] == 'f' ? FALSE : TRUE);
				return(BOOLCONST);
			}
{id}        {lexval.sval = newstring(yytext); return(ID);}
{sugar}     {return(yytext[0]);}
":="        {return(ASSIGN);}
.           {return(ERROR);}
%%

char *newstring(char *s)
{
	char *p;
	p = malloc(strlen(s)+1);
	strcpy(p, s);
	return(p);
}
