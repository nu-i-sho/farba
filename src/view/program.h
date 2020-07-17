#ifndef __PROGRAM_H__
#define __PROGRAM_H__

extern "C" {
#include <caml/mlvalues.h>
}

class Program {
 public:
  enum Status { OK, ERROR };
  struct State {
    enum Status status;
    int error;
    value base;
  };

private:
  State _state;
 public:
  class File {
  public:
    class Error {
    public:
      static const int LEVEL_IS_MISSING;
      static const int LEVEL_IS_UNAILABLE;
      static const int BACKUP_NOT_FOUND;
      static const int BACKUP_IS_CORRUPTED;
      static const int NAME_IS_EMPTY;
      static const int PERMISSION_DENIED;
      static const int FILE_ALREADY_EXIST;
    };
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
