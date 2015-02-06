#%.y:
#	echo $@
.DEFAULT_GOAL := prog

#y:
#	ls | grep -F '.y' |
#	@echo $(VAR)

prog: $(VAR).o
	cc -g -o $(VAR) $(VAR).o
$(VAR).o: $(VAR).c
	cc -g -c $(VAR).c
$(VAR).c: $(VAR).y
	bison -v -o $(VAR).c $(VAR).y

amb: amb.o
	cc -g -o amb amb.o
amb.o: amb.c
	cc -g -c amb.c
amb.c: amb.y
	bison -v -o amb.c amb.y

#all: $(addsuffix .png, $(basename $(wildcard *.dot)))

clean:
	rm -rf *.o*
	rm -rf *.c
	rm -rf *.output
	rm -rf amb calc calc2 calc3 calc4 calcE
