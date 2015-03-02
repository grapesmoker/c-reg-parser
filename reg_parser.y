%{
#include <stdio.h>
#include <string.h>
#include "reg_main.h"

  
  // yylloc->first_line = yylloc->last_line = yylloc->first_column = yylloc->last_column = 0;
  %}

%defines

%token OPEN_PAREN 
%token CLOSE_PAREN
%token COMMA 
%token PERIOD
%token DASH
%token SECTION_MARK
%token LOWERCASE_LETTER
%token UPPERCASE_LETTER
%token INTEGERS 
%token FLOATS
%token MONEY
%token PAR_MARKER
%token OPEN_EMPH
%token CLOSE_EMPH
%token WORD
%token EOL

 // some tokens representing external cites
%token USC CFR CFR_PART THE_ACT PUBLIC_LAW STATUTE

 // type declarations; everything is a string

%type<str> WORD LOWERCASE_LETTER UPPERCASE_LETTER PAR_MARKER
%type<str> OPEN_PAREN CLOSE_PAREN OPEN_EMPH CLOSE_EMPH
%type<str> INTEGERS FLOATS COMMA PERIOD DASH SECTION_MARK
%type<str> USC CFR CFR_PART THE_ACT PUBLIC_LAW STATUTE

%type<str> reference unit word external_citation
%type<str> usc_ref cfr_exp_v1 cfr_exp_v2
%type<str> the_act public_law statute
%type<str> punctuation

// %printer { printf("SYMBOL: %s\n", $$) } usc_ref
//%destructor { printf("freeing %s", $$); free($$); } <str>

%define parse.error verbose

%pure-parser
%locations

%start paragraph

%union {
  int integer;
  float real;
  char* str;
}

%%

paragraph: 
| PAR_MARKER paragraph
| paragraph unit
;

unit: word
| reference
| punctuation
;

word: WORD { 
  //printf("%d %d %d %d", yylloc.first_column, yylloc.last_column,
  //       yylloc.first_line, yylloc.last_line);
  add_symbol("WORD", $$, @$.first_column, @$.last_column);
  free($$);
 }
| LOWERCASE_LETTER
| UPPERCASE_LETTER
;

punctuation: COMMA
| PERIOD
| DASH
| SECTION_MARK
;

reference:  OPEN_PAREN LOWERCASE_LETTER CLOSE_PAREN { 
  strcat($$, $2);
  strcat($$, $3);
  add_symbol("REFERENCE", $$, @1.first_column, @3.last_column);
  free($$); free($2); free($3);
 }
| OPEN_PAREN LOWERCASE_LETTER LOWERCASE_LETTER CLOSE_PAREN {
  strcat($$, $2);
  strcat($$, $3);
  strcat($$, $4);
  add_symbol("REFERENCE", $$, @1.first_column, @4.last_column);
  free($$); free($2); free($3); free($4);
 }
| OPEN_PAREN UPPERCASE_LETTER CLOSE_PAREN {
  strcat($$, $2);
  strcat($$, $3);
  add_symbol("REFERENCE", $$, @1.first_column, @3.last_column);
  free($$); free($2); free($3);
 }
| OPEN_PAREN UPPERCASE_LETTER UPPERCASE_LETTER CLOSE_PAREN {
  strcat($$, $2);
  strcat($$, $3);
  strcat($$, $4);
  add_symbol("REFERENCE", $$, @1.first_column, @3.last_column);
  free($$); free($2); free($3); free($4);
 }
| external_citation
;

external_citation: usc_ref
| cfr_exp_v1
| cfr_exp_v2
| the_act
| public_law
| statute
;

/* external citation rules */

usc_ref: INTEGERS USC INTEGERS {
  strcat($$, " ");
  strcat($$, $2);
  strcat($$, " ");
  strcat($$, $3);
  add_symbol("USC_REF", $$, @1.first_column, @3.last_column);
  free($$); free($2); free($3);
}
;

cfr_exp_v1: INTEGERS CFR_PART INTEGERS {
  strcat($$, $2);
  strcat($$, $3);
  add_symbol("CFR_REF_V1", $$, @1.first_column, @3.last_column);
  free($$); free($2); free($3);
 };

cfr_exp_v2: INTEGERS CFR FLOATS {
  strcat($$, $2);
  strcat($$, $3);
  add_symbol("CFR_REF_V2", $$, @1.first_column, @3.last_column);
  free($$); free($2); free($3);
 };

the_act: THE_ACT {
  add_symbol("THE_ACT", $$, @$.first_column, @$.last_column);
  free($$);
 };

public_law: PUBLIC_LAW INTEGERS DASH INTEGERS {
  strcat($$, " ");
  strcat($$, $2);
  strcat($$, $3);
  strcat($$, $4);
  add_symbol("PUBLIC_LAW", $$, @1.first_column, @4.last_column);
  free($$); free($2); free($3); free($4);

 };

statute: INTEGERS STATUTE INTEGERS {
  strcat($$, " ");
  strcat($$, $2);
  strcat($$, " ");
  strcat($$, $3);
  add_symbol("STATUTE", $$, @1.first_column, @3.last_column);
  free($$); free($2); free($3);
 };

%%

