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

#define CAML_FUNC(F, NAME) \
  static const value* F = NULL; \
  if (F == NULL) F = caml_named_value(NAME)

void Program::File::open_new(int level) {
  CAML_FUNC(caml_open_new, "File.open_new");
  _program->_state = read_caml_state(
    caml_callback(
      *caml_open_new,
      Val_int(level)
    )
  );
}

void Program::File::restore(int level, const char* name) {
  CAML_FUNC(caml_restore, "File.restore");
  _program->_state = read_caml_state(
    caml_callback2(
      *caml_restore,
      Val_int(level),
      caml_copy_string(name)
    )
  );
}

void Program::File::save() {
  CAML_FUNC(caml_save, "File.save");
  _program->_state = read_caml_state(
    caml_callback(
      *caml_save,
      _program->_state.base
    )
  );
}

void Program::File::save_as(const char* name) {
  CAML_FUNC(caml_save_as, "File.save_as");
  _program->_state = read_caml_state(
    caml_callback2(
      *caml_save_as,
      caml_copy_string(name),
      _program->_state.base
    )
  ); 
}

Program::File Program::file() {
  return File(this);
}
