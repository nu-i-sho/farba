#define CAML_NAME_SPACE

#include "caml/mlvalues.h"
#include "caml/callback.h"
#include "caml/alloc.h"
#include "program.h" 

#define CAML_FUNC(NAME) \
  static const value* caml_func = NULL; \
  if (caml_func == NULL) \
    caml_func = caml_named_value(NAME)

extern "C" {
  Program::State base_open_new(int level_id) {
    CAML_FUNC("Program.open_new");
    
    // (t, Error.OpenNew.t) result
    value result =
      caml_callback(*caml_func,
        Val_int(level_id)
      );

    struct Program::State state = { Program::OK, Val_false };  
    switch (Tag_val(result)) {
    case /* Result.Ok */ 0:
      state.base = Field(result, 0);
      break;
      
    case /* Result.Error */ 1:
      switch (Int_val(Field(result, 0))) {
      case /* Error.OpenNew.Level_is_missing */ 0:
	state.status = Program::ERROR__OPEN_NEW__LEVEl_IS_MISSING;
	break;
      case /* Error.OpenNew.Level_is_unavailable */ 1:
	state.status = Program::ERROR__OPEN_NEW__LEVEL_IS_UNAVAILABLE;
	break;
      }
    }
    
    return state;
  }

  Program::State base_restore(int level_id, const char* name) {
    CAML_FUNC("Program.restore");
    
    // (t, Error.Restore.t) result
    value result =
      caml_callback2(*caml_func,
	Val_int(level_id),
	caml_copy_string(name)
      );

    struct Program::State state = { Program::OK, Val_false };
    switch (Tag_val(result)) {
    case /* Result.Ok */ 0: 
      state.base = Field(result, 0);
      break;
      
    case /* Result.Error */ 1:
      switch (Int_val(Field(result, 0))) {
      case /* Error.Restore.Backup_not_found */ 0:
	state.status = Program::ERROR__RESTORE__BACKUP_NOT_FOUND;
	break;
      case /* Error.Restore.Backup_is_corrupted */ 1:
	state.status = Program::ERROR__RESTORE__BACKUP_IS_CORRUPTED;
	break;
      }
    }

    return state;
  }

  Program::State base_save(value base_state) {
    CAML_FUNC("Program.save");
      
    // (t, Error.Save.t) result
    value result = caml_callback(*caml_func, base_state);
    
    struct Program::State state = { Program::OK, Val_false }; 
    switch (Tag_val(result)) {
    case /* Result.Ok */ 0: 
      state.base = Field(result, 0);
      break;
      
    case /* Result.Error */ 1:
      switch (Int_val(Field(result, 0))) {
      case /* Error.Save.Name_is_empty */ 0:
	state.status = Program::ERROR__SAVE__NAME_IS_EMPTY;
	break;
      }
    }
    
    return state;
  }

  Program::State base_save_as(const char* name, value base_state) {
    CAML_FUNC("Program.save_as");

    // (t, Error.SaveAs.t) result
    value result =
      caml_callback2(*caml_func,
	caml_copy_string(name),
	base_state
      );

    struct Program::State state = { Program::OK, Val_false };
    switch (Tag_val(result)) {
    case /* Result.Ok */ 0: 
      state.base = Field(result, 0);
      break;
      
    case /* Result.Error */ 1:
      switch (Int_val(Field(result, 0))) {
      case /* Error.SaveAs.Name_is_empty */ 0:
	state.status = Program::ERROR__SAVE_AS__NAME_IS_EMPTY;
	break;
      case /* Error.SaveAs.File_exists */ 1:
	state.status = Program::ERROR__SAVE_AS__FILE_EXISTS;
	break;
      }
    }
    
    return state; 
  }

  Program::State base_save_force(const char* name, value base_state) {
    CAML_FUNC("Program.force");
      
    // (t, Error.Save.t) result
    value result =
      caml_callback2(*caml_func,
	caml_copy_string(name),
	base_state
      );
    
    struct Program::State state = { Program::OK, Val_false }; 
    switch (Tag_val(result)) {
    case /* Result.Ok */ 0: 
      state.base = Field(result, 0);
      break;
      
    case /* Result.Error */ 1:
      switch (Int_val(Field(result, 0))) {
      case /* Error.Save.Name_is_empty */ 0:
	state.status = Program::ERROR__SAVE__NAME_IS_EMPTY;
	break;
      }
    }
    
    return state;
  }
}

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
