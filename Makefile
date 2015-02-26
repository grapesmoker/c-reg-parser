BISON_FLAGS=--locations
#--debug
FLEX_FLAGS=
#--debug
SHARED=
BUILD_FLAGS=${SHARED} -fPIC
LIBS=-lfl -lpython2.7

all:		regparser

regparser: 	reg_lexer.l reg_parser.y
		bison -d ${BISON_FLAGS} reg_parser.y
		bison --graph reg_parser.y
		flex ${FLEX_FLAGS} -o reg_lexer.yy.c reg_lexer.l 
		gcc ${BUILD_FLAGS} reg_parser.tab.c reg_lexer.yy.c reg_main.c ${LIBS} -o reg_parser

reglexer:	reg_lexer.l
		flex --debug reg_lexer.l
		gcc lex.yy.c -lfl -o reg_lexer

as_python:	reg_lexer.l reg_parser.y
		bison -d ${BISON_FLAGS} reg_parser.y
		bison --graph reg_parser.y
		flex ${FLEX_FLAGS} -o reg_lexer.yy.c reg_lexer.l
		gcc ${BUILD_FLAGS} reg_parser.tab.c reg_lexer.yy.c reg_main.c ${LIBS} -o reg_parser.so
