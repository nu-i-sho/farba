extern "C" {
#define CAML_NAME_SPACE
#include <caml/mlvalues.h>
#include <caml/callback.h>
#include <caml/alloc.h>
}

#include "program.h" 

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

extern "C" {
  Program::State base_open_new(int level_id) {
    CAML_FUNC("Program.open_new");
    return read_caml_state(
      caml_callback(
        *caml_func,
        Val_int(level_id)
      )
    );
  }

  Program::State base_restore(int level_id, const char* name) {
    CAML_FUNC("Program.restore");
    return read_caml_state(
      caml_callback2(
        *caml_func,
	Val_int(level_id),
	caml_copy_string(name)
      )
    );
  }

  Program::State base_save(value base_state) {
    CAML_FUNC("Program.save");
    return read_caml_state(
      caml_callback(
	*caml_func,
	base_state
      )
    );
  }

  Program::State base_save_as(const char* name, value base_state) {
    CAML_FUNC("Program.save_as");
    return read_caml_state(
      caml_callback2(
	*caml_func,
	caml_copy_string(name),
	base_state
      )
    ); 
  }

  Program::State base_save_force(const char* name, value base_state) {
    CAML_FUNC("Program.force");
    return read_caml_state(
      caml_callback2(
	*caml_func,
	caml_copy_string(name),
	base_state
      )
    );
  }
}

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

Program::File::File(Program* program) {
  _program = program;
}

void Program::File::open_new(int level) {
  _program->_state = base_open_new(level);
}

void Program::File::restore(int level, const char* name) {
  _program->_state = base_restore(level, name);
}

void Program::File::save() {
  _program->_state = base_save(_program->_state.base);
}

void Program::File::save_as(const char* name) {
  _program->_state = base_save_as(name, _program->_state.base);
}

Program::File Program::file() {
  return File(this);
}
