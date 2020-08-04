#ifndef __TISSUE_CELL_HPP__
#define __TISSUE_CELL_HPP__

#include "data/domain.hpp"

struct TissueCell {
  TissueCoord coord;
  Nucleus* nucleus;
  Pigment* cytoplasm;
  bool clotted;
  bool cursor_in;
};

#endif
