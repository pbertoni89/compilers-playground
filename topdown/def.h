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


typedef enum 
{
  NPROGRAM,
  NSTAT,
  NDEF_STAT,
  NDEF_LIST,
  NDOMAIN,
  NASSIGN_STAT,
  NTUPLE_CONST,
  NSIMPLE_CONST
} Nonterminal;

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

void strcopy(char*, const char*),
     match(int),
     next(),
     parserror(),
     treeprint(Pnode, int);

char *newstring(char*),
     *strcpy(char*, const char*);

size_t strlen(const char*);

Pnode nontermnode(Nonterminal),
      idnode(),
      keynode(Typenode),
      intconstnode(),
      strconstnode(),
      boolconstnode(),
      newnode(Typenode),
      program(),
      stat(),
      def_stat(),
      def_list(),
      domain(),
      assign_stat(),
      tuple_const(),
      simple_const();



