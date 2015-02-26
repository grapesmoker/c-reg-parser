#include <python2.7/Python.h>
#include <stdio.h>
#include "reg_parser.tab.h"

// need a linked list of symbols to keep track of 

typedef struct symbol_record
{
  char *name; // symbol name
  char *value; // symbol value; all of our symbols are strings

  int start_loc; // start location of token
  int end_loc; // end location of token

  struct symbol_record *next; // the next symbol in the table

} symbol_record;

extern symbol_record *symbol_table ;

extern symbol_record *add_symbol(char const *name, 
                                 char const *value, 
                                 int start_loc,
                                 int end_loc);

#define YYLEX_PARAM &yylloc
/* not sure we really need a getter at this point since
   we're just going to traverse the symbol table from start
   to end and pull it together into a list. */
// symbol_record *get_symbol(char const *name);

/*
typedef struct YYLTYPE  
{  
  int first_line;  
  int first_column;  
  int last_line;  
  int last_column;  
} YYLTYPE;

#define YYLTYPE_IS_DECLARED;

extern YYLTYPE yylloc;
*/
