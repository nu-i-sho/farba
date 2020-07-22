#include "api.hpp"

namespace Contract {
  Api::Api() {
    _file = nullptr;
  }

  Api::~Api() {
    if (_file != nullptr) delete _file;
  }
  
  Api::File* Api::file() {
    if (_file == nullptr) _file = file(this);
    return _file;
  }

  Api::File::~File() {
  }
}
