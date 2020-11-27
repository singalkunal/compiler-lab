c_subset: c_subset.l c_subset.y
	bison -d c_subset.y
	flex c_subset.l
	g++ lex.yy.c c_subset.tab.c -o c_subset
clean: 
	rm *.tab.* *.c
	find . -type f -executable -delete
