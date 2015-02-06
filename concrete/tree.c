#include "def.h"

char* tabtypes[] =
{
	"INTEGER",
	"STRING",
	"BOOLEAN",
	"INTCONST",
	"BOOLCONST",
	"STRCONST", 
	"ID",
	"NONTERMINAL"
};

char* tabnonterm[] =
{
	"PROGRAM",
	"STAT_LIST",
	"STAT",
	"DEF_STAT",
	"DEF_LIST",
	"DOMAIN_DECL",
	"DOMAIN",
	"ASSIGN_STAT",
	"TUPLE_LIST",
	"TUPLE_CONST",
	"SIMPLE_CONST_LIST",
	"SIMPLE_CONST"
};

void treeprint(Pnode root, int indent)
{
	int i;
	Pnode p;
	for(i=0; i<indent; i++)
		printf("    ");
	printf("%s", (root->type == T_NONTERMINAL ? tabnonterm[root->value.ival] : tabtypes[root->type]));
	if(root->type == T_ID || root->type == T_STRCONST)
		printf(" (%s)", root->value.sval);
	else if(root->type == T_INTCONST)
		printf(" (%d)", root->value.ival);
	else if(root->type == T_BOOLCONST)
		printf(" (%s)", (root->value.ival == TRUE ? "true" : "false"));
	printf("\n");
	for(p=root->child; p != NULL; p = p->brother)
		treeprint(p, indent+1);
}
