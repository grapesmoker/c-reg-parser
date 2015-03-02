/* lexer for the regulation parser */


%option bison-bridge bison-locations

%{

#include "reg_main.h"
#include "reg_parser.tab.h"

YYSTYPE yylval;
// YYLTYPE yylloc;

extern int yycolumn = 0;

#define YY_USER_ACTION \
        yylloc->first_line = yylloc->last_line = yylineno; \
        yylloc->first_column = yycolumn; \
        yylloc->last_column = yycolumn + yyleng - 1; \
        yycolumn += yyleng; \
        // printf("start: %d, length: %d, end: %d\n", yylloc.first_column, yyleng, yylloc.last_column);

%}

%option yylineno

%%

"("     { yylval->str = strdup(yytext); return OPEN_PAREN; }
")"     { yylval->str = strdup(yytext); return CLOSE_PAREN; }

","              { yylval->str = strdup(yytext); return COMMA; }
"\."             { yylval->str = strdup(yytext); return PERIOD; }
"-"              { yylval->str = strdup(yytext); return DASH; }
"§"              { yylval->str = strdup(yytext); return SECTION_MARK; }

[a-z]{1}         { yylval->str = strdup(yytext); return LOWERCASE_LETTER; }
[A-Z]{1}         { yylval->str = strdup(yytext); return UPPERCASE_LETTER; }

        /* external citations */

"U.S.C."          { yylval->str = strdup(yytext); return USC; }
"CFR"             { yylval->str = strdup(yytext); return CFR; }
"CFR part"        { yylval->str = strdup(yytext); return CFR_PART; }
"the Act"         { yylval->str = strdup(yytext); return THE_ACT; }
"Public Law"      { yylval->str = strdup(yytext); return PUBLIC_LAW; }
"Stat."           { yylval->str = strdup(yytext); return STATUTE; }



[0-9]+           { yylval->str = strdup(yytext); return INTEGERS; }
[0-9]+\.[0-9]+   { yylval->str = strdup(yytext); return FLOATS; }

\$[0-9]+\.?[0-9]{0,2}          { yylval->str = strdup(yytext); return MONEY; }

^([a-zA-Z]+|[0-9]+)\.          { yylval->str = strdup(yytext); return PAR_MARKER; }
^"("([a-zA-Z]+|[0-9]+)")"      { yylval->str = strdup(yytext); return PAR_MARKER; }

\<E[^>]*>        { yylval->str = strdup(yytext); return OPEN_EMPH; }
\<\/E>           { yylval->str = strdup(yytext); return CLOSE_EMPH; }

[a-zA-Z]*        { yylval->str = strdup(yytext); return WORD; }

[ \t]*           {  }
       
\r\n             { yycolumn = 0;
		   return EOL; }

%%