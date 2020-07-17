extern "C" {
#define CAML_NAME_SPACE
#include "caml/callback.h"
}

#include "program.h"

#include <iostream>

int main(int ac, char** av) {
  caml_main(av);
  Program program;
  std::cout << "1";
  program.file().open_new(1);
  std::cout << "2";
  program.file().save_as("test");
  std::cout << "3";
  return 0;
}
