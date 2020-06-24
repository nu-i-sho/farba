#define CAML_NAME_SPACE
#include <caml/mlvalues.h>
#include <caml/memory.h>

extern "C" {
  value load(char get_level_char (void)) {
    CAMLparam0(); // ??? 

    static const value* load = NULL;
    if (load == NULL)
        load = caml_named_value("load");
    
    CAMLreturn(*load, ADAPT_FOR_OCAML(get_level_char));
  }
}
