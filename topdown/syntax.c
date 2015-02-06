#include <stdio.h>
#include <stdlib.h>

#define DEF       258
#define INTEGER   259
#define STRING    260
#define BOOLEAN   261
#define ID        262
#define INTCONST  263
#define STRCONST  264
#define BOOLCONST 265
#define ASSIGN    266
#define ERROR     267

#define NUM_KEYWORDS 6
#define MAXIDENT 100

typedef union
{
  int ival;
  char *sval;
  enum {FALSE, TRUE} bval;
} Value;

void match(int),
     next(),
     parserror();

char *newstring(char*),
     *strcpy(char*, const char*);

void  program(),
      stat(),
      def_stat(),
      def_list(),
      domain(),
      assign_stat(),
      tuple_const(),
      simple_const();

size_t strlen(const char*);

/* Analizzatore lessicale */

Value lexval;
int line = 1;
FILE *yyin;
int lookahead, i, k;
char yytext[MAXIDENT+1];  

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
{
  int cc, keyword;
  
  do
  {
    cc = fgetc(yyin);
    if(cc == '\n')
      line++;
  } while(cc == ' ' || cc == '\t' || cc == '\n');
  if(cc == '(' || cc == ')' || cc == '{' || cc == '}' || cc == ',')
    return(cc);
  else if(cc == ':')
  {
    if((cc = fgetc(yyin)) == '=')
      return(ASSIGN);
    else
    {
      ungetc(cc, yyin);
      return(':');
    }
  }
  else if(isalpha(cc))
  {
    i = 0;
    yytext[i++] = cc;
    while(isalnum(cc = fgetc(yyin)))
      yytext[i++] = cc;
    ungetc(cc, yyin);
    yytext[i] = '\0';
    if(keyword = lookup(yytext))
    { 
      if(keyword == BOOLCONST)
        lexval.bval = (yytext[0] == 'f' ? FALSE : TRUE);
      return (keyword);
    }
    else
    {
      lexval.sval = newstring(yytext); 
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

/* Syntax analyzer */

void next()
{
  lookahead = yylex();
}

void match(int symbol)
{
  if(lookahead == symbol)
    next();
  else
    parserror();
}

void parserror()
{
  fprintf(stderr, "Line %d: syntax error on symbol \"%s\"\n", line, yytext);
  exit(-1);
}

void parse()
{
  next(); 
  program();
}

void program()
{
  stat();
  while (lookahead == DEF || lookahead == ID)
    stat();
}

void stat()
{
  if (lookahead == DEF)
    def_stat();
  else if (lookahead == ID)
    assign_stat();
  else
    parserror();
}

void def_stat()
{
  match(DEF);
  match(ID); 
  match('(');
  def_list();
  match(')');
}

void def_list()
{

  match(ID); 
  match(':');
  domain();
  while(lookahead == ',')
  {
    next();
    match(ID);  
    match(':');
    domain();
  }
}

void domain()
{
  if (lookahead == INTEGER || 
      lookahead == STRING ||
      lookahead == BOOLEAN)
    next();
  else
    parserror();
}

void assign_stat()
{
  match(ID); 
  match(ASSIGN);
  match('{');
  while (lookahead == '(')
    tuple_const();
  match('}');
}

void tuple_const()
{
  match('(');
  simple_const();
  while (lookahead == ',')
  {
    next();
    simple_const();
  }
  match(')');
}

void simple_const()
{
  if (lookahead == INTCONST || lookahead == STRCONST || lookahead == BOOLCONST)
    next();
  else
    parserror();
}

int main()
{
  yyin = stdin;
  parse();
  return(0);
}



