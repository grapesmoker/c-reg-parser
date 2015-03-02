/* A Bison parser, made by GNU Bison 3.0.3.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_REG_PARSER_TAB_H_INCLUDED
# define YY_YY_REG_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    OPEN_PAREN = 258,
    CLOSE_PAREN = 259,
    COMMA = 260,
    PERIOD = 261,
    DASH = 262,
    SECTION_MARK = 263,
    LOWERCASE_LETTER = 264,
    UPPERCASE_LETTER = 265,
    INTEGERS = 266,
    FLOATS = 267,
    MONEY = 268,
    PAR_MARKER = 269,
    OPEN_EMPH = 270,
    CLOSE_EMPH = 271,
    WORD = 272,
    EOL = 273,
    USC = 274,
    CFR = 275,
    CFR_PART = 276,
    THE_ACT = 277,
    PUBLIC_LAW = 278,
    STATUTE = 279
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 54 "reg_parser.y" /* yacc.c:1915  */

  int integer;
  float real;
  char* str;

#line 85 "reg_parser.tab.h" /* yacc.c:1915  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif



int yyparse (void);

#endif /* !YY_YY_REG_PARSER_TAB_H_INCLUDED  */
