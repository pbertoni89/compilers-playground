concrete: lex.o parser.o tree.o
	gcc -g -c -o concrete lex.o tree.o parser.o

lex.o: lex.c parser.h def.h
	gcc -g -c lex.c 

parser.o: parser.c def.h
	gcc -g -c parser.c

tree.o: tree.c def.h
	gcc -g -c tree.c

lex.c: lexer.lex parser.y parser.h parser.c def.h
	flex -o lex.c lexer.lex

parser.h: parser.y def.h
	bison -vd -o parser.c parser.y
clean:
	rm -rf *.o*
	rm -rf parser.c lex.c parser.h
	rm -rf *.output
	rm -rf concrete
