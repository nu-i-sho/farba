#include "caml.hpp"
#include <type_traits>
#include <tuple>

extern "C" {
#define CAML_NAME_SPACE
#include "caml/mlvalues.h"
#include "caml/callback.h"
#include <caml/alloc.h>
}

using namespace std;

#define TYPE_NAME(TYPE) #TYPE

namespace Caml {
  const value* function(const char* name) {
    return caml_named_value(name);
  }
  
  value call(const value* f, value arg) {
    return caml_callback(*f, arg);
  }
  
  value call(const value* f, value arg1, value arg2) {
    return caml_callback2(*f, arg1, arg2);
  }

  int hash_of_polimorphic_variant(const char* name) {
    return caml_hash_variant(name);
  }
  
  namespace Value {
    /*
    template<typename T> struct ConverterTo {
      static T convert(value x) {
	if (is_enum<T>::value)
	  return static_cast<T>(to<int>(x));

	throw CannotConvertTo<T>();
      }
    };
    */

    template<typename T> 
    T ConverterTo<T>::convert(value x) {
      if (is_enum<T>::value)
	return static_cast<T>(to<int>(x));
      
      throw CannotConvertTo<T>();
    }
    
    template<> struct ConverterTo<int> {
      static int convert(value x) {
	return Int_val(x);
      }
    };

    template<> struct ConverterTo<bool> {
      static bool convert(value x) {
	return Bool_val(x);
      }
    };

    template<typename T, typename U>
    struct ConverterTo<tuple<T, U>> {
      static bool convert(value x) {
	return make_tuple<T, U>(
	  field<T>(x, 0),
	  field<U>(x, 1)
	);
      }
    };

    template<typename T> T to(value x) {
      return ConverterTo<T>::convert(x);
    }

    value field(value x, int i) {
      return Field(x, i);
    }
    
    template<typename T> T field(value x, int i) {
      return to<T>(field(x, i));
    }

    /*
    template<typename T> struct ParserOf {
      static value parse(T x) = delete;
    };
    */
    
    template<> struct ParserOf<int> {
      static value parse(int x) {
	return Val_int(x);
      }
    };

    template<> struct ParserOf<const char*> {
      static value parse(const char* x) {
	return caml_copy_string(x);
      }
    };

    template<typename T> value of(T x) {
      return ParserOf<T>::parse(x);
    } 
  }
}
