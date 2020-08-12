#include "core.hpp"
#include "caml.hpp"

// OCaml polimprphic variant as const
#define CONST_HASH(STRUCT, CONST) \
  const int STRUCT::CONST = Caml::hash_of_polimorphic_variant(#CONST)

#define FUNCTION(F, NAME) \
  static const value* F = nullptr; \
  if (F == nullptr) F = Caml::function(NAME)

namespace Core {
  namespace Api {
    namespace EventsOf {
      namespace Cursor {
	value subscribe(value c_api, value caml_api) {
	  FUNCTION(subscribe, "Core.Api.EventsOf.Cursor.subscribe");
	  return Caml::call(subscribe, c_api, caml_api);
	}
	
	value unsubscribe(value subscription, value caml_api) {
	  FUNCTION(unsubscribe, "Core.Api.EventsOf.Cursor.unsubscribe");
	  return Caml::call(unsubscribe, subscription, caml_api);
	}
	
	CONST_HASH(Status, Success);
	CONST_HASH(Status, Fail);
	CONST_HASH(Status, Clotted);
	CONST_HASH(Status, Rev_gaze);
	CONST_HASH(Status, Self_clotted);
      }
    }

    namespace File {
      CONST_HASH(Error, Level_is_missing);
      CONST_HASH(Error, Level_is_unavailable);
      CONST_HASH(Error, Permission_denied);
      CONST_HASH(Error, Backup_not_found);
      CONST_HASH(Error, Backup_is_corrupted);
      CONST_HASH(Error, Name_is_empty);
      CONST_HASH(Error, File_already_exists);

      value open_new(value level) {
	FUNCTION(open_new, "Core.Api.File.open_new");
	return Caml::call(open_new, level);
      }

      value restore(value level, value name) {
	FUNCTION(restore, "Core.Api.File.restore");
	return Caml::call(restore, level, name);
      }

      value save(value state) {
	FUNCTION(save, "Core.Api.File.save");
	return Caml::call(save, state);
      }

      value save_as(value name, value state) {
	FUNCTION(save_as, "Core.Api.File.save_as");
	return Caml::call(save_as, name, state);
      }
    }
  }
}
