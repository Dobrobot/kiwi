EXAMPLES = syntax
OS=$(shell uname)

CFLAGS = -fPIC -O3 -g3 -Wall -std=gnu99 -Wno-unused-function -Wno-unused-but-set-variable -Wl,--allow-multiple-definition

all : $(EXAMPLES)

syntax : .FORCE
	mkdir -p bin
	leg -o src/syntax.leg.c src/syntax.leg
	$(CC) $(CFLAGS) -c src/bstrlib.c
	$(CC) $(CFLAGS) -c src/syntax.leg.c
	$(CC) $(CFLAGS) -c src/list.c
	$(CC) $(CFLAGS) -c src/content.c
	$(CC) $(CFLAGS) -c src/io.c
	$(CC) $(CFLAGS) -c src/parse.c
	$(CC) $(CFLAGS) -c src/stack.c
ifeq ($(OS), Darwin)
	$(CC) $(CFLAGS) -dynamiclib -shared -o libkiwi.so syntax.leg.o bstrlib.o list.o stack.o content.o io.o parse.o
else
	$(CC) $(CFLAGS) -shared -o libkiwi.so syntax.leg.o bstrlib.o list.o stack.o content.o io.o parse.o
endif
	$(CC) $(CFLAGS) -c src/main.c
	$(CC) $(CFLAGS) -o bin/parser main.o syntax.leg.o bstrlib.o list.o stack.o content.o io.o parse.o

testlist: .FORCE
	$(CC) $(CFLAGS) -c src/bstrlib.c
	$(CC) $(CFLAGS) -c src/list.c
	$(CC) $(CFLAGS) -c src/testlist.c
	$(CC) $(CFLAGS) -o bin/testlist testlist.o bstrlib.o list.o

memtest: .FORCE
	$(CC) $(CFLAGS) -c src/bstrlib.c
	$(CC) $(CFLAGS) -c src/syntax.leg.c
	$(CC) $(CFLAGS) -c src/list.c
	$(CC) $(CFLAGS) -c src/content.c
	$(CC) $(CFLAGS) -c src/io.c
	$(CC) $(CFLAGS) -c src/parse.c
	$(CC) $(CFLAGS) -c src/memtest.c
	$(CC) $(CFLAGS) -c src/stack.c
	$(CC) $(CFLAGS) -o bin/memtest memtest.o syntax.leg.o bstrlib.o list.o stack.o content.o io.o parse.o


clean : .FORCE
	rm -rf bin/* *~ *.o *.[pl]eg.[cd] *.so *.a $(EXAMPLES)

.FORCE :
