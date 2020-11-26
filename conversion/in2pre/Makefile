in2pre: in2pre.l in2pre.y
	bison -d in2pre.y
	flex in2pre.l
	g++ lex.yy.c in2pre.tab.c -o in2pre

clean: 
	@rm -rf *.c *.h
	@find . -type f -executable -delete
