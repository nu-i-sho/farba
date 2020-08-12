#ifndef __CORE_HPP__
#define __CORE_HPP__

extern "C" {
#define CAML_NAME_SPACE
#include "caml/mlvalues.h"
}

namespace Core {
  namespace Api {
    namespace EventsOf {
      namespace Cursor {
	value subscribe(value c_api, value caml_api);
	value unsubscribe(value subscription, value caml_api);
	
	struct Status {
	  static const int Success;
	  static const int Fail;
	  static const int Clotted;
	  static const int Rev_gaze;
	  static const int Self_clotted;
	  Status() = delete;
	};
      }
    }
    
    namespace File {
      struct Error {	
        static const int Level_is_missing;
        static const int Level_is_unavailable;
        static const int Permission_denied;
        static const int Backup_not_found;
        static const int Backup_is_corrupted;
        static const int Name_is_empty;
	static const int File_already_exists;
	Error() = delete;
      };

      value open_new(value level);
      value restore(value level, value name);
      value save(value state);
      value save_as(value name, value state);
    }
  }
}

#endif
