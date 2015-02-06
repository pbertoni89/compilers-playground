%{
#include "def.h"
#define YYSTYPE Pnode
extern char *yytext;
extern Value lexval;
extern int line;
extern FILE *yyin;
Pnode root = NULL;
%}

%token DEF INTEGER STRING BOOLEAN ID INTCONST STRCONST BOOLCONST ASSIGN
%token ERROR

%%

program : stat_list {root = $$ = nontermnode(NPROGRAM); $$->child = $1;}
        ;

stat_list : stat stat_list {$$ = $1; $1->brother = $2}
          | stat {$$ = $1;}
	  ;

stat : def_stat {$$ = nontermnode(NSTAT); $$->child = $1;}
     | assign_stat {$$ = nontermnode(NSTAT); $$->child = $1;}
     ;

def_stat : DEF ID {$$ = idnode();} '(' def_list ')' {$$ = nontermnode(NDEF_STAT); 
                                                     $$->child = $3; 
                                                     $3->brother = nontermnode(NDEF_LIST);
                                                     $3->brother->child = $5;}
         ;

def_list : domain_decl ',' def_list {$$ = $1; $1->brother->brother = $3;}
         | domain_decl {$$ = $1;}
         ;

domain_decl : ID {$$ = idnode(); } ':' domain {$$ = $2; $2->brother = $4;}
	    ;

domain : INTEGER {$$ = nontermnode(NDOMAIN); $$->child = keynode(T_INTEGER);}
       | STRING {$$ = nontermnode(NDOMAIN); $$->child = keynode(T_STRING);}
       | BOOLEAN {$$ = nontermnode(NDOMAIN); $$->child = keynode(T_BOOLEAN);}
       ;

assign_stat : ID {$$ = idnode();} ASSIGN '{' tuple_list '}' {$$ = nontermnode(NASSIGN_STAT); 
                                                             $$->child = $2; $2->brother = $5;}
            ;

tuple_list : tuple_const tuple_list {$$ = $1; $1->brother = $2;}
           | {$$ = NULL;}
	      ;

tuple_const : '(' simple_const_list ')' {$$ = nontermnode(NTUPLE_CONST); $$->child = $2;}
            ;

simple_const_list : simple_const ',' simple_const_list {$$ = $1; $1->brother = $3;}
                  | simple_const {$$ = $1;}
                  ;

simple_const :INTCONST {$$ = nontermnode(NSIMPLE_CONST); $$->child = intconstnode();}
	        |  STRCONST {$$ = nontermnode(NSIMPLE_CONST); $$->child = strconstnode();}
	        |  BOOLCONST {$$ = nontermnode(NSIMPLE_CONST); $$->child = boolconstnode();}
	        ;
%%

Pnode nontermnode(Nonterminal nonterm)
{
    Pnode p = newnode(T_NONTERMINAL);
    p->value.ival = nonterm;
    return(p);
}

Pnode idnode()
{
    Pnode p = newnode(T_ID);
    p->value.sval = lexval.sval;
    return(p);
}

Pnode keynode(Typenode keyword)
{
    return(newnode(keyword));
}

Pnode intconstnode()
{
    Pnode p = newnode(T_INTCONST);
    p->value.ival = lexval.ival;
    return(p);
}

Pnode strconstnode()
{
    Pnode p = newnode(T_STRCONST);
    p->value.sval = lexval.sval;
    return(p);
}

Pnode boolconstnode()
{
  Pnode p = newnode(T_BOOLCONST);
  p->value.bval = lexval.bval;
  return(p);
}

Pnode newnode(Typenode tnode)
{
  Pnode p = malloc(sizeof(Node));
  p->type = tnode;
  p->child = p->brother = NULL;
  return(p);
}

main()
{
  int result;
    
  yyin = stdin;
  if((result = yyparse()) == 0)
    treeprint(root, 0);
  return(result);
}

yyerror()
{
  fprintf(stderr, "Line %d: syntax error on symbol \"%s\"\n",
          line, yytext);
  exit(-1);
}
