#ifndef __CAML_HPP__
#define __CAML_HPP__

#include <type_traits>
#include <tuple>
#include <map>

extern "C" {
#define CAML_NAME_SPACE
#include "caml/mlvalues.h"
#include "caml/callback.h"
#include "caml/alloc.h"
}

#include "data/domain.hpp"
#include "𝚊𝚙𝚒/𝚊𝚙𝚒.hpp"
#include "api.hpp"

using namespace std;
using 𝙲𝚞𝚛𝚜𝚘𝚛 = 𝙰𝚙𝚒::𝙴𝚟𝚎𝚗𝚝𝚜𝙾𝚏::𝙲𝚞𝚛𝚜𝚘𝚛;
using ResultOf = 𝙰𝚙𝚒::𝙵𝚒𝚕𝚎::ResultOf;

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
    struct Result {
      bool is_ok;
      value value;
    };

    value field(value x, int i) {
      return Field(x, i);
    }
    
    template<typename T> struct CannotConvertTo { };
    template<typename T> T to(value);
    template<typename T> T field(value, int i);
    template<typename T> struct ConverterTo {
      static T convert(value x) {
	if (is_enum<T>::value)
         return static_cast<T>(to<int>(x));
      
	throw CannotConvertTo<T>();
      }
    };

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

    template<> struct ConverterTo<Result> {
      static Result convert(value x) {
	return Result {
	  Tag_val(x) == 0,
	  Field(x, 0)
	};
      }
    };
    
    template<typename T, typename U>
    struct ConverterTo<tuple<T, U>> {
      static tuple<T, U> convert(value x) {
	return make_tuple<T, U>(
	  field<T>(x, 0),
	  field<U>(x, 1)
	);
      }
    };

    template<> struct ConverterTo<Api*> {
      static Api* convert(value x) {
	return (Api*)Field(x, 0);
      }
    };

    template<> struct ConverterTo<ResultOf::OpenNew> {
      static ResultOf::OpenNew convert(value x) {
	static const map<int, ResultOf::OpenNew> errors = {
							   
	  { hash_of_polimorphic_variant("Level_is_missing"),
            ResultOf::OpenNew::Level_is_missing
	  },
	  { hash_of_polimorphic_variant("Level_is_unavailable"),
            ResultOf::OpenNew::Level_is_unavailable
	  }
	};

	return errors.at(to<int>(x));
      }
    };

    template<> struct ConverterTo<ResultOf::Restore> {
      static ResultOf::Restore convert(value x) {
	static const map<int, ResultOf::Restore> errors = {

	  { hash_of_polimorphic_variant("Permission_denied"),
	    ResultOf::Restore::Permission_denied
	  },
	  { hash_of_polimorphic_variant("Backup_not_found"),
	    ResultOf::Restore::Backup_not_found
	  },
	  { hash_of_polimorphic_variant("Backup_is_corrupted"),
	    ResultOf::Restore::Backup_is_corrupted
	  }		 
	};

	return errors.at(to<int>(x));
      }
    };

    template<> struct ConverterTo<ResultOf::Save> {
      static ResultOf::Save convert(value x) {
	static const map<int, ResultOf::Save> errors = {

	  { hash_of_polimorphic_variant("Permission_denied"),
            ResultOf::Save::Permission_denied
	  },
	  {  hash_of_polimorphic_variant("Name_is_empty"),
	     ResultOf::Save::Name_is_empty
	  }	
	};

	return errors.at(to<int>(x));
      }
    };

    template<> struct ConverterTo<ResultOf::SaveAs> {
      static ResultOf::SaveAs convert(value x) {
	static const map<int, ResultOf::SaveAs> errors = {
    
          { hash_of_polimorphic_variant("Permission_denied"),
            ResultOf::SaveAs::Permission_denied
	  },
	  { hash_of_polimorphic_variant("Name_is_empty"),
            ResultOf::SaveAs::Name_is_empty
	  },
	  { hash_of_polimorphic_variant("File_already_exists"),
            ResultOf::SaveAs::File_already_exists
	  } 
	};

	return errors.at(to<int>(x));
      }
    };
    
    template<typename T>
    struct ConverterTo<Change<T>> {
      static Change<T> convert(value x) {
	return Change<T> {
	  field<T>(x, 0),
	    field<T>(x, 1)
	};
      }
    };

    template<> struct ConverterTo<Nucleus*> {
      static Nucleus* convert(value x) {
	if (!Is_block(x)) return nullptr;
	return new Nucleus {
	  field<Pigment>(x, 0),
	  field<Side>(x, 1)
	};
      }
    };

    template<> struct ConverterTo<Pigment*> {
      static Pigment* convert(value x) {
	if (!Is_block(x)) return nullptr;
	return new Pigment(
	  field<Pigment>(x, 0)
	);
      }
    };
  
    template<> struct ConverterTo<TissueCell> {
      static TissueCell convert(value x) {
	auto coord     = field<tuple<int, int>>(x, 0);
	auto nucleus   = field<Nucleus*>(x, 1);
	auto cytoplasm = field<Pigment*>(x, 2);
	auto clotted   = field<bool>(x, 3);
	auto cursor_in = field<bool>(x, 4);

	return TissueCell {
	  coord, nucleus, cytoplasm, clotted, cursor_in
	};
      }
    };

    template<> struct ConverterTo<𝙲𝚞𝚛𝚜𝚘𝚛::Turned> {
      static 𝙲𝚞𝚛𝚜𝚘𝚛::Turned convert(value x) {
	auto hand   = field<Hand>(x, 0);
	auto change = field<Change<TissueCell>>(x, 1);
	return 𝙲𝚞𝚛𝚜𝚘𝚛::Turned {
	  hand, change
	};
      }
    };

    template<> struct ConverterTo<𝙲𝚞𝚛𝚜𝚘𝚛::MovedMindStatus> {
      static 𝙲𝚞𝚛𝚜𝚘𝚛::MovedMindStatus convert(value x) {
	static const map<int, 𝙲𝚞𝚛𝚜𝚘𝚛::MovedMindStatus> statuses = {
								 
	  { hash_of_polimorphic_variant("Success"),
            𝙲𝚞𝚛𝚜𝚘𝚛::MovedMindStatus::Success
	  },
	  { hash_of_polimorphic_variant("Fail"),
	    𝙲𝚞𝚛𝚜𝚘𝚛::MovedMindStatus::Fail
	  }
        };

        return statuses.at(to<int>(x));
      }
    };

    template<> struct ConverterTo<𝙲𝚞𝚛𝚜𝚘𝚛::MovedMind> {
      static 𝙲𝚞𝚛𝚜𝚘𝚛::MovedMind convert(value x) {
	auto direction = field<Side>(x, 0);
	auto change    = field<Change<tuple<TissueCell, TissueCell>>>(x, 1);
	auto status    = field<𝙲𝚞𝚛𝚜𝚘𝚛::MovedMindStatus>(x, 2);
	return 𝙲𝚞𝚛𝚜𝚘𝚛::MovedMind {
	  direction, change, status
	};
      }
    };

    template<> struct ConverterTo<𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus> {
      static 𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus convert(value x) {
	static const map<int, 𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus> statuses = {
								 
	  { hash_of_polimorphic_variant("Success"),
	    𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus::Success
	  },
	  { hash_of_polimorphic_variant("Fail"),
	    𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus::Fail
	  },
	  { hash_of_polimorphic_variant("Clotted"),
	    𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus::Clotted
	  },
	  { hash_of_polimorphic_variant("Rev_gaze"),
	    𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus::Rev_gaze
	  }
        };

        return statuses.at(to<int>(x));
      }
    };

    template<> struct ConverterTo<𝙲𝚞𝚛𝚜𝚘𝚛::MovedBody> {
      static 𝙲𝚞𝚛𝚜𝚘𝚛::MovedBody convert(value x) {
	auto direction = field<Side>(x, 0);
	auto change    = field<Change<tuple<TissueCell, TissueCell>>>(x, 1);
	auto status    = field<𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus>(x, 2);
	return 𝙲𝚞𝚛𝚜𝚘𝚛::MovedBody {
	  direction, change, status
	};
      }
    };

    template<> struct ConverterTo<𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus> {
      static 𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus convert(value x) {
	static const map<int, 𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus> statuses = {
								  
	  { hash_of_polimorphic_variant("Success"),
            𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus::Success
          },
	  { hash_of_polimorphic_variant("Fail"),
	    𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus::Fail
	  },
	  { hash_of_polimorphic_variant("Clotted"),
            𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus::Clotted
	  },
	  { hash_of_polimorphic_variant("Self_clotted"),
	   𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus::Self_clotted
	  }
	};

	return statuses.at(to<int>(x));
      }
    };

    template<> struct ConverterTo<𝙲𝚞𝚛𝚜𝚘𝚛::Replicated> {
      static 𝙲𝚞𝚛𝚜𝚘𝚛::Replicated convert(value x) {
	auto gene      = field<Gene>(x, 0);
	auto direction = field<Side>(x, 1);
	auto change    = field<Change<tuple<TissueCell, TissueCell>>>(x, 2);
	auto status    = field<𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus>(x, 3);
	return 𝙲𝚞𝚛𝚜𝚘𝚛::Replicated {
	  direction, change, status, gene
	};
      }
    };

    template<typename T> T to(value x) {
      return ConverterTo<T>::convert(x);
    }

    template<typename T> T field(value x, int i) {
      return to<T>(Field(x, i));
    }
    
    template<typename T> struct CannotConvertFrom { };
    template<typename T> struct ConverterFrom {
      static value convert(T) {
	throw CannotConvertFrom<T>();
      }
    };

    template<> struct ConverterFrom<int> {
      static value convert(int x) {
	return Val_int(x);
      }
    };

    template<> struct ConverterFrom<const char*> {
      static value convert(const char* x) {
        return caml_copy_string(x);
      }
    };

    template<> struct ConverterFrom<Api*> {
      static value convert(Api* x) {
	value pack = caml_alloc_small(1, Abstract_tag);
	Field(pack, 0) = (value)x;
	return pack;
      }
    };
    
    template<typename T> value of(T x) {
      return ConverterFrom<T>::convert(x);
    }
  }
}

#endif
