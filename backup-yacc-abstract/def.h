#include <stdio.h>
#include <stdlib.h>

typedef enum 
{
    NPROGRAM,
    NSTAT_LIST,
    NSTAT,
    NDEF_STAT,
    NDEF_LIST,
    NDOMAIN_DECL,
    NDOMAIN,
    NASSIGN_STAT,
    NTUPLE_LIST,
    NTUPLE_CONST,
    NSIMPLE_CONST_LIST,
    NSIMPLE_CONST
} Nonterminal;

typedef enum
{
    T_INTEGER,
    T_STRING,
    T_BOOLEAN,
    T_INTCONST,
    T_BOOLCONST,
    T_STRCONST,
    T_ID,
    T_NONTERMINAL
} Typenode;

typedef union
{
    int ival;
    char *sval;
    enum {FALSE, TRUE} bval;
} Value;

typedef struct snode
{
    Typenode type;
    Value value;
    struct snode *child, *brother;
} Node;

typedef Node *Pnode;

char *newstring(char*);

Pnode nontermnode(Nonterminal), 
      idnode(), 
      keynode(Typenode), 
      intconstnode(),
      strconstnode(),
      boolconstnode(),
      newnode(Typenode);



