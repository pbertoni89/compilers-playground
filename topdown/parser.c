#include "def.h"

extern char yytext[];
extern Value lexval;
extern int line;
extern FILE *yyin;

int lookahead;

Pnode root = NULL;

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

Pnode newnode(Typenode tnode)
{
  Pnode p;

  p = (Pnode) malloc(sizeof(Node));
  p->type = tnode;
  p->child = p->brother = NULL;
  return(p);
}

Pnode nontermnode(Nonterminal nonterm)
{
  Pnode p;

  p = newnode(T_NONTERMINAL);
  p->value.ival = nonterm;
  return(p);
}

Pnode keynode(Typenode keyword)
{
  return(newnode(keyword));
}

Pnode idnode()
{
  Pnode p;

  p = newnode(T_ID);
  p->value.sval = lexval.sval;
  return(p);
}

Pnode intconstnode()
{
  Pnode p;

  p = newnode(T_INTCONST);
  p->value.ival = lexval.ival;
  return(p);
}

Pnode strconstnode()
{
  Pnode p;

  p = newnode(T_STRCONST);
  p->value.sval = lexval.sval;
  return(p);
}

Pnode boolconstnode()
{
  Pnode p;

  p = newnode(T_BOOLCONST);
  p->value.bval = lexval.bval;
  return(p);
}

void parse()
{
  next(); 
  root = nontermnode(NPROGRAM);
  root->child = program();
}

Pnode program()
{
  Pnode head, p;
 
  head = p = nontermnode(NSTAT); 
  p->child = stat();
  while (lookahead == DEF || lookahead == ID)
  {
    p->brother = nontermnode(NSTAT);
    p = p->brother;
    p->child = stat();
  }
  return(head);
}

Pnode stat()
{
  Pnode p;

  if (lookahead == DEF)
  {
    p = nontermnode(NDEF_STAT);
    p->child = def_stat();
    return(p);
  }
  else if (lookahead == ID)
  {
    p = nontermnode(NASSIGN_STAT);
    p->child = assign_stat();
    return(p);
  }
  else
    parserror();
}

Pnode def_stat()
{
  Pnode p;

  match(DEF);
  if (lookahead == ID)
  {
    p = idnode();
    next(); 
    match('(');
    p->brother = nontermnode(NDEF_LIST);
    p->brother->child = def_list();
    match(')');
    return(p);
  }
  else
    parserror();
}

Pnode def_list()
{
  Pnode head, p;

  if (lookahead == ID)
  {
    head = p = idnode();
    next(); 
    match(':');
    p->brother = nontermnode(NDOMAIN);
    p = p->brother;
    p->child = domain();
    while(lookahead == ',')
    {
      next();
      if ( lookahead == ID)
      {
        p->brother = idnode();
        p = p->brother;
        next(); 
        match(':');
        p-> brother = nontermnode(NDOMAIN);
        p = p->brother;
        p->child = domain();
      }
      else
        parserror();
    }
    return(head);
  }
  else
    parserror();
}

Pnode domain()
{
  Pnode p;

  if (lookahead == INTEGER || 
      lookahead == STRING ||
      lookahead == BOOLEAN)
  {
    p = keynode( lookahead == INTEGER ? T_INTEGER : 
                   ( lookahead == STRING ? T_STRING :
                        T_BOOLEAN));
    next();
    return(p);
  }
  else
    parserror();
}

Pnode assign_stat()
{
  Pnode head, p;

  if (lookahead == ID)
  {
    head = p = idnode();
    next(); 
    match(ASSIGN);
    match('{');
    while ( lookahead == '(')
    {
      p->brother = nontermnode(NTUPLE_CONST);
      p = p->brother;
      p->child = tuple_const();
    }
    match('}');
  }
  else
    parserror();
  return(head);
}

Pnode tuple_const()
{
  Pnode head, p;

  match('(');
  head = p = nontermnode(NSIMPLE_CONST);
  p->child = simple_const();
  while (lookahead == ',')
  {
    next();
    p->brother = nontermnode(NSIMPLE_CONST);
    p = p->brother;
    p->child = simple_const();
  }
  match(')');
  return(head);
}

Pnode simple_const()
{
  Pnode p;

  if (lookahead == INTCONST)
  {
    p = intconstnode();
    next();
    return(p);
  }
  else if (lookahead == STRCONST)
  {
    p = strconstnode();
    next();
    return(p);
  }
  else if (lookahead == BOOLCONST)
  {
    p = boolconstnode();
    next();
    return(p);
  }
  else
    parserror();
}

int main()
{
  yyin = stdin;
  parse();
  treeprint(root, 0);
  return(0);
}



