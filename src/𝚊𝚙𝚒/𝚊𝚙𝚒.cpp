#include "𝚊𝚙𝚒.hpp"

𝙰𝚙𝚒::𝙰𝚙𝚒() {
  _file = nullptr;
}

𝙰𝚙𝚒::~𝙰𝚙𝚒() {
  if (_file != nullptr) delete _file;
}

𝙰𝚙𝚒::𝙵𝚒𝚕𝚎* 𝙰𝚙𝚒::file() {
  if (_file == nullptr) _file = file(this);
  return _file;
}

𝙰𝚙𝚒::𝙵𝚒𝚕𝚎::~𝙵𝚒𝚕𝚎() {
}

