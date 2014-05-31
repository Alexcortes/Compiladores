portugolC: flex.ll bison.yy
	bison -d bison.yy
	mv bison.tab.hh bison.h
	mv bison.tab.cc bison.c
	flex flex.ll
	mv lex.yy.c flex.c
	g++ -o portugolC bison.c flex.c Symbol.h Symbol.cpp SymbolTable.h SymbolTable.cpp checks.h checks.cpp codeGenerator.h codeGenerator.cpp messageAndLog.h messageAndLog.cpp

clean:
	rm flex.c bison.c bison.h portugolC.exe
