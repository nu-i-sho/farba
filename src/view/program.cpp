extern "C" {
#define CAML_NAME_SPACE
#include <caml/mlvalues.h>
#include <caml/callback.h>
#include <caml/alloc.h>
}

#include "program.h" 

#define INIT_ERROR(NAME) \
  const int Program::File::Error::NAME = \
  caml_hash_variant(#NAME)

INIT_ERROR(LEVEL_IS_MISSING);
INIT_ERROR(LEVEL_IS_UNAILABLE);
INIT_ERROR(BACKUP_NOT_FOUND);
INIT_ERROR(BACKUP_IS_CORRUPTED);
INIT_ERROR(NAME_IS_EMPTY);
INIT_ERROR(PERMISSION_DENIED);
INIT_ERROR(FILE_ALREADY_EXIST);

#define CAML_FUNC(NAME) \
  static const value* caml_func = NULL; \
  if (caml_func == NULL) \
    caml_func = caml_named_value(NAME)

Program::State read_caml_state(value caml_state) {
  Program::State state;  
  switch (Tag_val(caml_state)) {
  case /* Result.Ok */ 0:
    state.status = Program::OK;
    state.base = Field(caml_state, 0);
    break;
      
  case /* Result.Error */ 1:
    state.status = Program::ERROR;
    state.error = Int_val(Field(caml_state, 0));
    break;
  }
  
  return state;
}

Program::File::File(Program* program) {
  _program = program;
}

void Program::File::open_new(int level) {
  CAML_FUNC("Program.open_new");
  _program->_state = read_caml_state(
    caml_callback(
      *caml_func,
      Val_int(level)
    )
  );
}

void Program::File::restore(int level, const char* name) {
  CAML_FUNC("Program.restore");
  _program->_state = read_caml_state(
    caml_callback2(
      *caml_func,
      Val_int(level),
      caml_copy_string(name)
    )
  );
}

void Program::File::save() {
  CAML_FUNC("Program.save");
  _program->_state = read_caml_state(
    caml_callback(
      *caml_func,
      _program->_state.base
    )
  );
}

void Program::File::save_as(const char* name) {
  CAML_FUNC("Program.save_as");
  _program->_state = read_caml_state(
    caml_callback2(
      *caml_func,
      caml_copy_string(name),
      _program->_state.base
    )
  ); 
}

Program::File Program::file() {
  return File(this);
}
