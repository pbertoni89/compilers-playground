#include "def.h"

#define NUM_KEYWORDS 6
#define MAXIDENT 100

FILE *yyin;
int line = 1;  
char yytext[MAXIDENT+1];                                                     
Value lexval;
int i, k;

struct {char* name; int keyword;} 
keywords[NUM_KEYWORDS] = 
{
  "def", DEF,
  "integer", INTEGER,
  "string", STRING,
  "boolean", BOOLEAN,
  "false", BOOLCONST,
  "true", BOOLCONST
};

int yylex()
{ int cc, keyword;
  
  do
  { cc = fgetc(yyin);
    if(cc == '\n')
      line++;
  } while(cc == ' ' || cc == '\t' || cc == '\n');
  if(cc == '(' || cc == ')' || cc == '{' || cc == '}' || cc == ',')
    return(cc);
  else if(cc == ':')
  { if((cc = fgetc(yyin)) == '=')
      return(ASSIGN);
    else
    { ungetc(cc, yyin);
      return(':');
    }
  }
  else if(isalpha(cc))
  { i = 0;
    yytext[i++] = cc;
    while(isalnum(cc = fgetc(yyin)))
      yytext[i++] = cc;
    ungetc(cc, yyin);
    yytext[i] = '\0';
    if(keyword = lookup(yytext))
    { if(keyword == BOOLCONST)
        lexval.bval = (yytext[0] == 'f' ? FALSE : TRUE);
      return (keyword);
    }
    else
    { lexval.sval = newstring(yytext); 
      return(ID);
    }
  }
  else if(isdigit(cc))
  {
    i = 0;
    yytext[i++] = cc;
    while(isdigit(cc = fgetc(yyin)))
      yytext[i++] = cc;
    ungetc(cc, yyin);
    yytext[i] = '\0';
    lexval.ival = atoi(yytext); 
    return(INTCONST);
  }
  else if(cc == '"')
  {
    i = 0;
    yytext[i++] = cc;
    while((cc = fgetc(yyin)) != '"')
      yytext[i++] = cc;
    yytext[i++] = cc;
    yytext[i] = '\0';
    lexval.sval = newstring(yytext); 
    return(STRCONST);
  }
  else if(cc==EOF)
    return(EOF);
  else
    return(ERROR);
}

int lookup(char *id)
{
  for(k = 0; k < NUM_KEYWORDS; k++)
    if(strcmp(id, keywords[k].name) == 0)
      return(keywords[k].keyword);
  return(0);
}

char *newstring(char *s)
{
  char *p;
  
  p = malloc(strlen(s)+1);
  strcpy(p, s);
  return(p);
}