#ifndef __DOMAIN_HPP__
#define __DOMAIN_HPP__

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

typedef std::tuple<int, int> TissueCoord

struct Pigment {
  Pigment pigment;
  Side gaze;
};
  
#endif
