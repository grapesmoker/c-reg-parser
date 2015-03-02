#include "reg_main.h"

symbol_record *symbol_table;
int symbol_table_size;
int yycolumn;

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

  //increment table size
  symbol_table_size++;
  
  return new_record;
}

void init_table(symbol_record *root)
{
  root = NULL;

  // we'll keep track of the table size in a global variable
  // which is less than ideal but this parser is tiny so it's ok
  symbol_table_size = 0;

  symbol_table = NULL;
}

void free_table(symbol_record *root)
{
  symbol_record *current_record = root;
  symbol_record *temp;
  while (current_record != NULL) {
    temp = current_record;
    current_record = current_record->next;
    free(temp);
  }

  root = NULL;

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

int yyerror(char *s)
{
  fprintf(stderr, "error: %s\n", s);

  return 1;
}

static PyObject* say_hello(PyObject* self, PyObject* args)
{
  const char *name;
  
  if (!PyArg_ParseTuple(args, "s", &name))
    return NULL;
  
  printf("Hello %s!\n", name);
  
  return Py_BuildValue("ss", "hello", name);
}

static PyObject* parse(PyObject *self, PyObject *args)
{
  char *scan_string;

  if (!PyArg_ParseTuple(args, "s", &scan_string)) {
    return NULL;
  }

  init_table(symbol_table);
  
  yy_scan_string(scan_string);
  // remember to reset yycolumn for each new scan
  yycolumn = 0;
  yyparse();

  // now we must construct the list of return values and send it
  // back to the python caller

  // printf("printing the symbol table of %d objects\n", symbol_table_size);
  // print_symbol_table(symbol_table);
  
  symbol_record *current_record;

  // printf("converting symbol table to Python objects\n");
  
  PyObject *retvals = PyList_New(symbol_table_size);

  // printf("allocated Python list of size %d\n", PyList_GET_SIZE(retvals));

  PyObject *new_result;
  
  int i = 0;
  for (current_record = symbol_table;
       current_record != NULL;
       current_record = current_record->next) {
    // printf("processing %s: %s\n", current_record->name, current_record->value);
    new_result = Py_BuildValue("{s:s,s:s,s:i,s:i}",
			       "name",
			       current_record->name,
			       "value",
			       current_record->value,
			       "start",
			       current_record->start_loc,
			       "end",
			       current_record->end_loc + 1);
    if (new_result == NULL) {
      fprintf(stderr, "failed to create object!\n");
      Py_RETURN_NONE;
    }
    else {
      PyList_SetItem(retvals, i, new_result);
      i++;
    }
  }

  // free the symbol table
  free_table(symbol_table);
  
  return retvals;

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

