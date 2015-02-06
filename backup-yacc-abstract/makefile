bup: lex.o parser.o tree.o
	cc -g -o bup lex.o parser.o tree.o

lex.o: lex.c parser.h def.h
	cc -g -c lex.c 

parser.o: parser.c def.h
	cc -g -c parser.c

tree.o: tree.c def.h
	cc -g -c tree.c

lex.c: lexer.lex parser.y parser.h parser.c def.h
	flex -o lex.c lexer.lex

parser.h: parser.y def.h
	bison -vd -o parser.c parser.y