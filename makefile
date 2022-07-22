#-----------------------#
# Configuration Section #
#-----------------------#
flags = -Wall -Wextra -g
srcDir = source
headDir = header
lib = -lm -lpthread
project_name = project_name

.PHONY: clean $(project_name)

#---------------------#
# Rules for compiling #
#---------------------#
$(project_name): main.o lib.o clean
	gcc $(flags) -o $@ main.o lib.o $(lib)
	chmod 775 $@

main.o: $(srcDir)/main.c
	gcc $(flags) -c $^ $(lib)

lib.o: $(srcDir)/lib.c $(headDir)/lib.h
	gcc $(flags) -c $^ $(lib)

#--------------------#
# Rules for cleaning #
#--------------------#
clean:
	rm -rf $(srcDir)/*bak*
	rm -rf *bak*
	rm -rf $(srcDir)/*~
	rm -rf *~
	rm -rf $(srcDir)/core
	rm -rf core

distclean: clean
	rm -rf $(project_name)
	rm -rf *.o
	rm -rf $(headDir)/*.gch
