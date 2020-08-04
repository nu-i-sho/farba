#ifndef __NUCLEUS_MOVE_HPP__
#define __NUCLEUS_MOVE_HPP__

#include "data/domain.hpp"
#include "change.hpp"
#include "tissue_cell.hpp"
#include <tuple>
using namespace std;

template <typename T_status>
struct NucleusMove {
  Side direction;
  Change<tuple<TissueCell, TissueCell>> change;
  T_status status;
};

#endif
