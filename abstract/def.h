#include <stdio.h>
#include <stdlib.h>

/** List of all nonterminals. */
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

/** List of all terminals, generalized by a Typenode. PLUS, a Typenode can be a nonterminal one (T_NONTERMINAL). */
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

/** union is similar to a struct, except it defines variables that share storage space. Thus, writing into one will overwrite the other. */
typedef union
{
    int ival;
    char *sval;
    enum {FALSE, TRUE} bval;
} Value;

/** A node of the tree has
 * 		1) one 'type' belonging to set Typenode
 *		2) one 'value' belonging to set Value. */
typedef struct snode
{
    Typenode type;
    Value value;
    struct snode *child, *brother;
} Node;

typedef Node *Pnode;

/** Declaration of a function defined in lexer.lex */
char *newstring(char*);

/** Declarations of various functions defined in parser.y */
Pnode 	nontermnode(Nonterminal),
		idnode(),
		keynode(Typenode),
		intconstnode(),
		strconstnode(),
		boolconstnode(),
		newnode(Typenode);