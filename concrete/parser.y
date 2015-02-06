%{
	#include "def.h"
	#define YYSTYPE Pnode
	extern char *yytext;	// lexical analyzer
	extern Value lexval;	// lexical analyzer
	extern int line;		// lexical analyzer
	extern FILE *yyin;		// lexical analyzer
	Pnode root = NULL;
%}

%token DEF INTEGER STRING BOOLEAN ID INTCONST STRCONST BOOLCONST ASSIGN
%token ERROR

%%

program : stat_list {	root = $$ = nontermnode(NPROGRAM);
						$$->child = $1;}
        ;

stat_list : stat stat_list {	$$ = nontermnode(NSTAT_LIST);
								$$->child = $1; 
								$1->brother = $2;}
          | stat {	$$ = nontermnode(NSTAT_LIST); 
					$$->child = $1;}
		  ;

stat : def_stat {	$$ = nontermnode(NSTAT);
					$$->child = $1;}
     | assign_stat {$$ = nontermnode(NSTAT);
					$$->child = $1;}
     ;

def_stat : DEF ID {$$ = idnode();} '(' def_list ')' {	$$ = nontermnode(NDEF_STAT);
														$$->child = $3;
														$3->brother = $5;}
         ;

def_list : domain_decl ',' def_list {	$$ = nontermnode(NDEF_LIST);
										$$->child = $1;
										$1->brother = $3;}
         | domain_decl {	$$ = nontermnode(NDEF_LIST);
							$$->child = $1;}
         ;

domain_decl : ID {$$ = idnode(); } ':' domain {	$$ = nontermnode(NDOMAIN_DECL);
												$$->child = $2;
												$2->brother = $4;}
			;

domain : INTEGER {	$$ = nontermnode(NDOMAIN);
					$$->child = keynode(T_INTEGER);}
       | STRING {	$$ = nontermnode(NDOMAIN);
					$$->child = keynode(T_STRING);}
       | BOOLEAN {	$$ = nontermnode(NDOMAIN);
					$$->child = keynode(T_BOOLEAN);}
       ;

assign_stat : ID {$$ = idnode();} ASSIGN '{' tuple_list '}' {	$$ = nontermnode(NASSIGN_STAT);
																$$->child = $2;
																$2->brother = $5;}
            ;

tuple_list : tuple_const tuple_list {	$$ = nontermnode(NTUPLE_LIST);
										$$->child = $1;
										$1->brother = $2;}
           | {$$ = nontermnode(NTUPLE_LIST);}
		   ;

tuple_const : '(' simple_const_list ')' {	$$ = nontermnode(NTUPLE_CONST);
											$$->child = $2;}
            ;

simple_const_list : simple_const ',' simple_const_list {	$$ = nontermnode(NSIMPLE_CONST_LIST);
															$$->child = $1;
															$1->brother = $3;}
                  | simple_const {	$$ = nontermnode(NSIMPLE_CONST_LIST);
									$$->child = $1;}
                  ;

simple_const: INTCONST {	$$ = nontermnode(NSIMPLE_CONST);
							$$->child = intconstnode();}
			| STRCONST {	$$ = nontermnode(NSIMPLE_CONST);
							$$->child = strconstnode();}
	        | BOOLCONST {	$$ = nontermnode(NSIMPLE_CONST);
							$$->child = boolconstnode();}
	        ;
%%

/** Allocates a Node of Typenode T_NONTERMINAL. */
Pnode nontermnode(Nonterminal nonterm)
{
	Pnode p = newnode(T_NONTERMINAL);
	p->value.ival = nonterm;
	return(p);
}

/** Allocates a Node of Typenode T_ID, and saves the lexical string value as its value. */
Pnode idnode()
{
	Pnode p = newnode(T_ID);
	p->value.sval = lexval.sval;
	return(p);
}

/** Allocates a Node of Typenode @param keyword. Dumb wrapper of newnode(Typenode tnode). */
Pnode keynode(Typenode keyword)
{
	return(newnode(keyword));
}

/** Allocates a Node of Typenode T_INTCONST, and saves the lexical int value as its value. */
Pnode intconstnode()
{
	Pnode p = newnode(T_INTCONST);
	p->value.ival = lexval.ival;
	return(p);
}

/** Allocates a Node of Typenode T_STRCONST, and saves the lexical string value as its value. */
Pnode strconstnode()
{
	Pnode p = newnode(T_STRCONST);
	p->value.sval = lexval.sval;
	return(p);
}

/** Allocates a Node of Typenode T_BOOLCONST, and saves the lexical boolean value as its value. */
Pnode boolconstnode()
{
	Pnode p = newnode(T_BOOLCONST);
	p->value.bval = lexval.bval;
	return(p);
}

/** Allocates a Node of Typenode @param tnode. Child and brother are NOT set yet. */
Pnode newnode(Typenode tnode)
{
	Pnode p = malloc(sizeof(Node));
	p->type = tnode;
	p->child = p->brother = NULL;
	return(p);
}

yyerror()
{
	fprintf(stderr, "Line %d: syntax error on symbol \"%s\"\n", line, yytext);
	exit(-1);
}

main()
{
	int result;
	yyin = stdin;
	if((result = yyparse()) == 0)
		treeprint(root, 0);
	return(result);
}
