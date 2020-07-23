#include "𝚊𝚙𝚒.hpp"

𝙰𝚙𝚒::𝙰𝚙𝚒() {
  _file = nullptr;
}

𝙰𝚙𝚒::𝙵𝚒𝚕𝚎* 𝙰𝚙𝚒::file() {
  if (_file == nullptr)
    _file = create_file_node();
  
  return _file;
}

𝙰𝚙𝚒::~𝙰𝚙𝚒() {
  if (_file != nullptr) {
    delete _file;
    _file = nullptr;
  }
}

𝙰𝚙𝚒::𝙵𝚒𝚕𝚎::𝙵𝚒𝚕𝚎() {
  _errors = nullptr;
}

𝙰𝚙𝚒::𝙵𝚒𝚕𝚎::𝙴𝚛𝚛𝚘𝚛𝚜* 𝙰𝚙𝚒::𝙵𝚒𝚕𝚎::errors() {
  if (_errors == nullptr)
    _errors = create_errors_node();

  return _errors;
}

𝙰𝚙𝚒::𝙵𝚒𝚕𝚎::~𝙵𝚒𝚕𝚎() {
  if (_errors != nullptr) {
    delete _errors;
    _errors = nullptr;
  }
}

𝙰𝚙𝚒::𝙵𝚒𝚕𝚎::𝙴𝚛𝚛𝚘𝚛𝚜::~𝙴𝚛𝚛𝚘𝚛𝚜() {
}
