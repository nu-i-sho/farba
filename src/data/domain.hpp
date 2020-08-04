#ifndef __DOMAIN_HPP__
#define __DOMAIN_HPP__

#include <tuple>
using namespace std;

enum struct Side {
  Up,
  LeftUp,
  RightUp,
  Down,
  LeftDown,
  RightDown,
};

enum struct Gene {
  Dominant,
  Recessive
};

enum struct Hand {
  Left,
  Right
};

enum struct Pigment {
  White,
  Blue,
  Gray
};

typedef tuple<int, int> TissueCoord;

struct Nucleus {
  Pigment pigment;
  Side gaze;
};
  
#endif
