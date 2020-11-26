# target: prerequisites
# <tab> recipe

simple_calc: simple_calc.y simple_calc.l
	@bison -d simple_calc.y
	@flex simple_calc.l
	@g++ lex.yy.c simple_calc.tab.c -o simple_calc
clean:
	@rm -rf *.c *.h
	@find . -type f -executable -delete
