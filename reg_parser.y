%{
#include <stdio.h>
#include <string.h>
#include "reg_main.h"

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

%printer { printf("SYMBOL: %s\n", $$) } usc_ref 

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

unit: word { $$ = $1; printf("WORD: %s\n", $word); } 
| reference
| punctuation
;

word: WORD { 
  printf("%d %d %d %d", yylloc.first_column, yylloc.last_column,
         yylloc.first_line, yylloc.last_line);
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
  printf("REFERENCE: %s\n", $$);
  add_symbol("REFERENCE", $$, @1.first_column, @3.last_column);
  free($$); free($2); free($3);
 }
| OPEN_PAREN LOWERCASE_LETTER LOWERCASE_LETTER CLOSE_PAREN {
  strcat($$, $2); strcat($$, $3); strcat($$, $4);
  printf("REFERENCE: %s\n", $$);
 }
| OPEN_PAREN UPPERCASE_LETTER CLOSE_PAREN {
  strcat($$, $2);
  strcat($$, $3);
  printf("REFERENCE: %s\n", $$);
 }
| OPEN_PAREN UPPERCASE_LETTER UPPERCASE_LETTER CLOSE_PAREN {
  strcat($$, $2); strcat($$, $3); strcat($$, $4);
  printf("REFERENCE: %s\n", $$);
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
  strcat($$, $2);
  strcat($$, $3);
  // printf("USC_REFERENCE: %s\n", $$);
}
;

cfr_exp_v1: INTEGERS CFR_PART INTEGERS {
  strcat($$, $2);
  strcat($$, $3);
  printf("CFR REFERENCE: %s\n", $$);
 };

cfr_exp_v2: INTEGERS CFR FLOATS {
  strcat($$, $2);
  strcat($$, $3);
  printf("CFR REFERENCE: %s\n", $$);
 };

the_act: THE_ACT;

public_law: PUBLIC_LAW INTEGERS DASH INTEGERS {
  strcat($$, $2);
  strcat($$, $3);
  strcat($$, $4);
  printf("PUBLIC_LAW: %s\n", $$);
 }

statute: INTEGERS STATUTE INTEGERS {
  strcat($$, $2);
  strcat($$, $3);
 };

%%

