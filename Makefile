portugolC: flex.l bison.y
	bison -d bison.y
	mv bison.tab.h bison.h
	mv bison.tab.c bison.c
	flex flex.l
	mv lex.yy.c flex.c
	gcc -o portugolC bison.c flex.c -lm

clean:
	rm flex.* bison.* portugolC.exe
