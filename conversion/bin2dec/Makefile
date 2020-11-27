bin2dec: bin2dec.l bin2dec.y
	bison -d bin2dec.y
	flex bin2dec.l
	g++ lex.yy.c bin2dec.tab.c -o bin2dec

clean: 
	@rm *.h *.c
	@find . -type f -executable -delete
