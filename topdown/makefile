syntax: syntax.o
	cc -g -o syntax syntax.o

tds: scanner.o parser.o tree.o
	cc -g -o tds scanner.o parser.o tree.o

tdl: lexer.o parser.o tree.o
	cc -g -o tdl lexer.o parser.o tree.o

lexer.o: lexer.c def.h
	cc -g -c lexer.c 

scanner.o: scanner.c def.h
	cc -g -c scanner.c

syntax.o: syntax.c def.h
	cc -g -c syntax.c

parser.o: parser.c def.h
	cc -g -c parser.c

tree.o: tree.c def.h
	cc -g -c tree.c

lexer.c: lexer.lex def.h
	flex -o lexer.c lexer.lex
