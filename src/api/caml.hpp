#ifndef __CAML_HPP__
#define __CAML_HPP__

extern "C" {
#define CAML_NAME_SPACE
#include "caml/mlvalues.h"
}

namespace Caml {
  const value* function(const char* name);
  
  value call(const value* f, value arg);
  value call(const value* f, value arg, value arg2);

  int hash_of_polimorphic_variant(const char* name);

  namespace Value {
    template<typename T> struct ConverterTo {
      static T convert(value);
    };

    template<typename T> struct ParserOf {
      static value parse(T) = delete;
    };
    
    template<typename T> struct CannotConvertTo { };
    template<typename T> T to(value);
    template<typename T>
        T field(value, int i);
    value field(value, int i);
    
    template<typename T> value of(T);
  }
}

#endif
