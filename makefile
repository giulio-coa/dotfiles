#-----------------------#
# Configuration Section #
#-----------------------#

flags = -Wall -g
srcDir = source
headDir = header
objDir = obj
lib = -lm -lpthread

.PHONY: clean project

#---------------------#
# Rules for compiling #
#---------------------#

project: $(objDir)/main.o $(objDir)/lib.o clean
	gcc $(flags) -o $@ $(objDir)/main.o $(objDir)/lib.o $(lib)
	chmod 775 $@

$(objDir)/main.o: $(srcDir)/main.c
	gcc $(flags) -o $@ -c $^ $(lib)

$(objDir)/lib.o: $(srcDir)/lib.c $(headDir)/lib.h
	gcc $(flags) -o $@ -c $^ $(lib)

#--------------------#
# Rules for cleaning #
#--------------------#

clean:
	rm -rf $(srcDir)/*bak*
	rm -rf $(objDir)/*bak*
	rm -rf *bak*
	rm -rf $(srcDir)/*~
	rm -rf $(objDir)/*~
	rm -rf *~
	rm -rf $(srcDir)/core
	rm -rf $(objDir)/core
	rm -rf core

distclean: clean
	rm -rf project
	rm -rf $(objDir)/*.o
