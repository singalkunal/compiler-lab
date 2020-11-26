in2pos: in2pos.l in2pos.y
	bison -d in2pos.y
	flex in2pos.l
	g++ lex.yy.c in2pos.tab.c -o in2pos

clean: 
	@rm -rf *.c *.h
	@find . -type f -executable -delete
