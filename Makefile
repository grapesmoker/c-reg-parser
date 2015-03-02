BISON_FLAGS=--locations
#--debug
FLEX_FLAGS=
#--debug
SHARED=
BUILD_FLAGS=${SHARED} -fPIC
DEV_MACHINE=mac
# flags for development on my mac
# ifeq($(DEV_MACHINE), mac)
LDFLAGS=-L/Users/vinokurovy/homebrew/opt/flex/lib -L/Users/vinokurovy/homebrew/Cellar/python/2.7.9/Frameworks/Python.framework/Versions/2.7/lib/python2.7/config
CPPFLAGS=-I/Users/vinokurovy/homebrew/opt/flex/include -I/Users/vinokurovy/homebrew/Cellar/python/2.7.9/Frameworks/Python.framework/Versions/2.7/include/python2.7
#else
#	LDFLAGS=
#	CPPFLAGS=
#endif

LIBS=-lfl -lpython2.7 -ldl -framework CoreFoundation

all:		regparser

regparser: 	reg_lexer.l reg_parser.y
		bison -d ${BISON_FLAGS} reg_parser.y
		bison --graph reg_parser.y
		flex ${FLEX_FLAGS} -o reg_lexer.yy.c reg_lexer.l 
		gcc ${BUILD_FLAGS} ${CPPFLAGS} ${LDFLAGS} reg_parser.tab.c reg_lexer.yy.c reg_main.c ${LIBS} -o reg_parser

reglexer:	reg_lexer.l
		flex --debug reg_lexer.l
		gcc lex.yy.c -lfl -o reg_lexer

as_python:	reg_lexer.l reg_parser.y
		bison -d ${BISON_FLAGS} reg_parser.y
		bison --graph reg_parser.y
		flex ${FLEX_FLAGS} -o reg_lexer.yy.c reg_lexer.l
		gcc -shared ${BUILD_FLAGS} ${CPPFLAGS} ${LDFLAGS} reg_parser.tab.c reg_lexer.yy.c reg_main.c ${LIBS} -o reg_parser.so
