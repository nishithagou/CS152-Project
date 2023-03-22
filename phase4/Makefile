parser: super_l.lex
	bison -v -d --file-prefix=y super_l.y
	flex super_l.lex
	g++ -o super_l -x c++ y.tab.c lex.yy.c -ll

clean:
	rm -f lex.yy.c y.tab.* y.output *.o super_l *.mil
