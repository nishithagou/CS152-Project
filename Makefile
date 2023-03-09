CFLAGS = -g -Wall -ansi -pedantic

superl: super_l.l super_l.y
	bison -d -v super_l.y
	flex super_l.l
	g++ $(CFLAGS) -std=c++11 lex.yy.c super_l.tab.c -ll -o superl
	rm -f lex.yy.c



	
