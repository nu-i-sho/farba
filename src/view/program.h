#ifndef __PROGRAM_H__
#define __PROGRAM_H__

#include "caml/mlvalues.h"

class Program {
 public:
  enum Status {
    OK = 0,
    EMPTY,
    ERROR__OPEN_NEW__LEVEl_IS_MISSING,
    ERROR__OPEN_NEW__LEVEL_IS_UNAVAILABLE,
    ERROR__RESTORE__BACKUP_NOT_FOUND,
    ERROR__RESTORE__BACKUP_IS_CORRUPTED,
    ERROR__SAVE__NAME_IS_EMPTY,
    ERROR__SAVE_AS__NAME_IS_EMPTY,
    ERROR__SAVE_AS__FILE_EXISTS
  };

  struct State {
    enum Status status; 
    value base;
  };

private:
  State _state;
 public:  
  class File {
  private:
    Program* _program;
    File(Program* program);
    friend class Program;
   public:
    void open_new(int level);
    void restore(int level, const char* name);
    void save();
    void save_as(const char* name);
  };

  File file();
};

#endif
