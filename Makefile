#
# Makefile for SPL compiler
#

JAVA = java
JAVAC = javac
JFLEX = ./lib/JFlex.jar
CUP = ./lib/java-cup-11a.jar
CUP_RT = ./lib/java-cup-11a-runtime.jar

SRCS = main/Main.java \
       parse/Scanner.java parse/Parser.java parse/sym.java

all:			main/Main.class

tests:			main/Main.class
			@for i in Tests/test??.spl ; do \
			  echo ; \
			  echo -- Compiling $$i -- ; \
			  spl $$i ; \
			done
			@echo

main/Main.class:	$(SRCS)
			$(JAVAC) -cp $(CUP_RT) -sourcepath . main/Main.java

parse/Scanner.java:	parse/scanner.jflex
			$(JAVA) -cp $(JFLEX) JFlex.Main parse/scanner.jflex

parse/Parser.java:	parse/parser.cup
			$(JAVA) -cp $(CUP) java_cup.Main \
			  -parser Parser -expect 1 parse/parser.cup
			mv Parser.java parse
			mv sym.java parse

parse/sym.java:		parse/parser.cup
			$(JAVA) -cp $(CUP) java_cup.Main \
			  -parser Parser -expect 1 parse/parser.cup

clean:
			rm -f *~
			rm -f Tests/*~
			rm -f main/*~
			rm -f parse/*~

dist-clean:		clean
			rm -f main/*.class
			rm -f parse/Scanner.java parse/Parser.java
			rm -f parse/sym.java parse/*.class
