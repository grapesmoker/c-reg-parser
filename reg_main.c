#include "reg_main.h"

symbol_record *symbol_table;

symbol_record *add_symbol(char const *name,
                          char const *value,
                          int start_loc,
                          int end_loc) 
{
  symbol_record *new_record = (symbol_record *) malloc(sizeof(symbol_record));

  if (new_record == NULL) {
    fprintf(stderr, "Terrible things have happened. Aborting.\n");
    exit(1);
  }

  // allocate space for name and value
  new_record->name = (char *) malloc(strlen(name) + 1);
  new_record->value = (char *) malloc(strlen(name) + 1);

  // fill up name, value, location
  strcpy(new_record->name, name);
  strcpy(new_record->value, value);
  new_record->start_loc = start_loc;
  new_record->end_loc = end_loc;

  // point next to root of table, move root to new node
  new_record->next = (struct symbol_record *) symbol_table;
  symbol_table = new_record;
}

void init_table(symbol_record *root)
{
  root = NULL;
}

void free_table(symbol_record *root)
{
  symbol_record *current_record = root;

  while (current_record != NULL) {
    symbol_record *temp = current_record;
    current_record = current_record->next;
    free(temp);
  }
}

void print_symbol_table(symbol_record *root)
{
  symbol_record *current_record;

  for (current_record = root;
       current_record != NULL;
       current_record = current_record->next) {
    printf("NAME: %s, VALUE: %s, START: %d, END: %d\n", 
           current_record->name, 
           current_record->value,
           current_record->start_loc,
           current_record->end_loc);
  }
}

int main (int argc, char **argv)
{
  // let's initialize the symbol table even though it's just setting
  // the root to null
  printf("Initializing symbol table\n");
  init_table(symbol_table);

  extern FILE *yyin;
  //yydebug = 1;
  if (argc > 1) {
    printf("Opening file %s\n", argv[1]);
    if (!(yyin = fopen(argv[1], "r"))) {
      fprintf(stderr, "Couldn't open %s for reading\n", argv[1]);
      perror(argv[1]);
      return (1);
    }
  }
  
  printf("Running the parser\n");
  yyparse();

  printf("Printing symbol table contents:\n");
  print_symbol_table(symbol_table);

  printf("Freeing up symbol table\n");
  free_table(symbol_table);

  return 0;
}

yyerror(char *s)
{
  fprintf(stderr, "error: %s\n", s);
}

static PyObject* say_hello(PyObject* self, PyObject* args)
{
  const char *name;
  
  if (!PyArg_ParseTuple(args, "s", &name))
    return NULL;
  
  printf("Hello %s!\n", name);
  
  Py_RETURN_NONE;
}

static PyObject* parse(PyObject *self, PyObject *args)
{
  char *scan_string;

  if (!PyArg_ParseTuple(args, "s", &scan_string)) {
    return NULL;
  }

  printf("getting ready to parse\n");
  printf("input string: %s", scan_string);
  
  yy_scan_string(scan_string);
  yyparse();

  Py_RETURN_NONE;

}
 
static PyMethodDef HelloMethods[] =
{
     {"say_hello", say_hello, METH_VARARGS, "Greet somebody."},
     {"parse", parse, METH_VARARGS, "Scan a string."},
     {NULL, NULL, 0, NULL}
};
 
PyMODINIT_FUNC initreg_parser(void)
{
     (void) Py_InitModule("reg_parser", HelloMethods);
}

