extern "C" {
#define CAML_NAME_SPACE
#include "caml/mlvalues.h"
#include "caml/memory.h"
#include "caml/callback.h"
#include "caml/alloc.h"
}

#include <map>
#include "api.hpp"
#include "caml.hpp"
#include "core.hpp"
#include "data/domain.hpp"

using namespace std;
using 𝙲𝚞𝚛𝚜𝚘𝚛 = 𝙰𝚙𝚒::𝙴𝚟𝚎𝚗𝚝𝚜𝙾𝚏::𝙲𝚞𝚛𝚜𝚘𝚛;
using ResultOf = 𝙰𝚙𝚒::𝙵𝚒𝚕𝚎::ResultOf;

Api::Api() {
  _state = Val_unit;
  _file = nullptr;
  _events_of = nullptr;
}

Api::~Api() {
  if (_file != nullptr) delete _file;
  if (_events_of != nullptr) delete _events_of;
}

bool Api::is_empty() const {
  return !Is_block(_state);
}

Api::File* Api::file() {
  if (_file == nullptr) _file = new Api::File(this); 
  return _file;
}

Api::EventsOf* Api::events_of() {
  if (_events_of == nullptr) _events_of = new Api::EventsOf();
  return _events_of;
}

int Api::save_state(value caml_result) {
  // Result.Ok:
  if (Tag_val(caml_result) == 0) {
    _state = Field(caml_result, 0);
    return 0;
  }
  
  // Result.Error:
  return Int_val(Field(caml_result, 0));
}

void Api::subscribe_caml_cursor_events() {
  value subscription_and_state =
    Core::Api::EventsOf::Cursor::subscribe(
      Caml::Value::of<Api*>(this),
      _state
    );
    
  value subscrioption = Caml::Value::field(subscription_and_state, 0);
  value state         = Caml::Value::field(subscription_and_state, 1);

  _cursor_events_subscription = subscrioption;
  _state = state;
}

void Api::unsubscribe_caml_cursor_events() {
  value observer_and_state =
    Core::Api::EventsOf::Cursor::unsubscribe(
      _cursor_events_subscription,
      _state
    );

  value state = Caml::Value::field(observer_and_state, 1);
  _state = state;
}

Api::File::File(Api* api) {
  _api = api;
}

ResultOf::OpenNew Api::File::open_new(int level) {
  if (!_api -> is_empty())
    _api -> unsubscribe_caml_cursor_events();

  static const map<int, ResultOf::OpenNew> statuses = {
    { 0,   ResultOf::OpenNew::OK
    },
    { Core::Api::File::Error::Level_is_missing,
           ResultOf::OpenNew::Level_is_missing
    },
    { Core::Api::File::Error::Level_is_unavailable,
           ResultOf::OpenNew::Level_is_unavailable
    }
  };
    
  auto status =
    statuses.at(
      _api -> save_state(
	Core::Api::File::open_new(
	  Caml::Value::of<int>(
	    level
	  )
	)
      )
    );

  _api -> subscribe_caml_cursor_events();
  return status;
}

ResultOf::Restore Api::File::restore(int level, const char* name) {
  if (!_api -> is_empty())
    _api -> unsubscribe_caml_cursor_events();

  static const map<int, ResultOf::Restore> statuses = {
    { 0,   ResultOf::Restore::OK
    },
    { Core::Api::File::Error::Permission_denied,
           ResultOf::Restore::Permission_denied
    },
    { Core::Api::File::Error::Backup_not_found,
           ResultOf::Restore::Backup_not_found
    },
    { Core::Api::File::Error::Backup_is_corrupted,
           ResultOf::Restore::Backup_is_corrupted
    }
  };
  
  auto status =
    statuses.at(
      _api -> save_state(
	Core::Api::File::restore(
	  Caml::Value::of<int>(level),
	  Caml::Value::of<const char*>(name)
        )
      )
    );
    
  _api -> subscribe_caml_cursor_events();
  return status;
}

ResultOf::Save Api::File::save() {
  if (_api -> is_empty())
    return    ResultOf::Save::Nothing_to_save;

  static const map<int, ResultOf::Save> statuses = {
    { 0,      ResultOf::Save::OK
    },
    { Core::Api::File::Error::Permission_denied,
              ResultOf::Save::Permission_denied
    },
    { Core::Api::File::Error::Name_is_empty,
              ResultOf::Save::Name_is_empty
    }			   
  };
    
  _api -> unsubscribe_caml_cursor_events();

  auto status =
    statuses.at(
      _api -> save_state(
	Core::Api::File::save(
	  _api -> _state
	)
      )
    );

  _api -> subscribe_caml_cursor_events();
  return status;
}

ResultOf::SaveAs Api::File::save_as(const char* name) {
  if (_api -> is_empty())
    return  ResultOf::SaveAs::Nothing_to_save;

  static const map<int, ResultOf::SaveAs> statuses = {
    { 0,    ResultOf::SaveAs::OK
    },
    { Core::Api::File::Error::Permission_denied,
            ResultOf::SaveAs::Permission_denied
    },
    { Core::Api::File::Error::Name_is_empty,
            ResultOf::SaveAs::Name_is_empty
    },
    { Core::Api::File::Error::File_already_exists,
            ResultOf::SaveAs::File_already_exists
    } 
  };
  
  _api -> unsubscribe_caml_cursor_events();
  
  auto status =
    statuses.at(
      _api -> save_state(
	Core::Api::File::save_as(
	  Caml::Value::of<const char*>(name),
          _api -> _state
        )
      )
    );

  _api -> subscribe_caml_cursor_events();
  return status;
}

namespace Caml::Value {
  template<> struct ParserOf<Api*> {
    static value parse(Api* x) {
      value pack = caml_alloc_small(1, Abstract_tag);
      Field(pack, 0) = (value)x;
      return pack;
    }
  };
  
  template<> struct ConverterTo<Api*> {
    static Api* convert(value x) {
      return (Api*)Field(x, 0);
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
								 
	{ Core::Api::EventsOf::Cursor::Status::Success,
                       𝙲𝚞𝚛𝚜𝚘𝚛::MovedMindStatus::Success
	},
	{ Core::Api::EventsOf::Cursor::Status::Fail,
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
								 
	{ Core::Api::EventsOf::Cursor::Status::Success,
	               𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus::Success
	},
	{ Core::Api::EventsOf::Cursor::Status::Fail,
	               𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus::Fail
	},
	{ Core::Api::EventsOf::Cursor::Status::Clotted,
	               𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus::Clotted
	},
	{ Core::Api::EventsOf::Cursor::Status::Rev_gaze,
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
								  
        { Core::Api::EventsOf::Cursor::Status::Success,
                      𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus::Success
        },
	{ Core::Api::EventsOf::Cursor::Status::Fail,
	              𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus::Fail
	},
	{ Core::Api::EventsOf::Cursor::Status::Clotted,
                      𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus::Clotted
	},
	{ Core::Api::EventsOf::Cursor::Status::Self_clotted,
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
}

extern "C" {
  CAMLprim value on_cursor_turned(value caml_event, value caml_api) {
    CAMLparam2(caml_event, caml_api);    

    auto event = Caml::Value::to<𝙲𝚞𝚛𝚜𝚘𝚛::Turned>(caml_event);
    auto api   = Caml::Value::to<Api*>(caml_api);
    api -> events_of() -> cursor() -> _turned -> send(event);

    CAMLreturn(Caml::Value::of<Api*>(api));
  }
 
  CAMLprim value on_cursor_moved_mind(value caml_event, value caml_api) {
    CAMLparam2(caml_event, caml_api);

    auto event = Caml::Value::to<𝙲𝚞𝚛𝚜𝚘𝚛::MovedMind>(caml_event);
    auto api   = Caml::Value::to<Api*>(caml_api);
    api -> events_of() -> cursor() -> _moved_mind -> send(event);
    
    CAMLreturn(Caml::Value::of<Api*>(api));
  }

  CAMLprim value on_cursor_moved_body(value caml_event, value caml_api) {
    CAMLparam2(caml_event, caml_api);

    auto event = Caml::Value::to<𝙲𝚞𝚛𝚜𝚘𝚛::MovedBody>(caml_event);
    auto api   = Caml::Value::to<Api*>(caml_api);
    api -> events_of() -> cursor() -> _moved_body -> send(event);
    
    CAMLreturn(Caml::Value::of<Api*>(api));
  }

  CAMLprim value on_cursor_replicated(value caml_event, value caml_api) {
    CAMLparam2(caml_event, caml_api);

    auto event = Caml::Value::to<𝙲𝚞𝚛𝚜𝚘𝚛::Replicated>(caml_event);
    auto api   = Caml::Value::to<Api*>(caml_api);
    api -> events_of() -> cursor() -> _replicated -> send(event);
    
    CAMLreturn(Caml::Value::of<Api*>(api));
  }
}

Api::EventsOf::EventsOf() {
  _cursor = nullptr;
}

Api::EventsOf::~EventsOf() {
  if (_cursor != nullptr) delete _cursor;
}

Api::EventsOf::Cursor* Api::EventsOf::cursor() {
  if (_cursor == nullptr) _cursor = new Cursor();
  return _cursor;
}

Api::EventsOf::Cursor::Cursor() {
  _turned     = nullptr;
  _moved_mind = nullptr;
  _moved_body = nullptr;
  _replicated = nullptr;
}

Api::EventsOf::Cursor::~Cursor() {
  if (_turned     != nullptr) delete _turned;
  if (_moved_mind != nullptr) delete _moved_mind;
  if (_moved_body != nullptr) delete _moved_body;
  if (_replicated != nullptr) delete _replicated;
}

𝙾𝚋𝚜𝚎𝚛𝚟𝚊𝚋𝚕𝚎<𝙲𝚞𝚛𝚜𝚘𝚛::Turned>* Api::EventsOf::Cursor::turned() {
  if (_turned == nullptr)
      _turned = new Subject<𝙲𝚞𝚛𝚜𝚘𝚛::Turned>();
  
  return _turned;
}

𝙾𝚋𝚜𝚎𝚛𝚟𝚊𝚋𝚕𝚎<𝙲𝚞𝚛𝚜𝚘𝚛::MovedMind>* Api::EventsOf::Cursor::moved_mind() {
  if (_moved_mind == nullptr)
      _moved_mind = new Subject<𝙲𝚞𝚛𝚜𝚘𝚛::MovedMind>();
  
  return _moved_mind;
}

𝙾𝚋𝚜𝚎𝚛𝚟𝚊𝚋𝚕𝚎<𝙲𝚞𝚛𝚜𝚘𝚛::MovedBody>* Api::EventsOf::Cursor::moved_body() {
  if (_moved_body == nullptr)
      _moved_body = new Subject<𝙲𝚞𝚛𝚜𝚘𝚛::MovedBody>();
  
  return _moved_body;
}

𝙾𝚋𝚜𝚎𝚛𝚟𝚊𝚋𝚕𝚎<𝙲𝚞𝚛𝚜𝚘𝚛::Replicated>* Api::EventsOf::Cursor::replicated() {
  if (_replicated == nullptr)
      _replicated = new Subject<𝙲𝚞𝚛𝚜𝚘𝚛::Replicated>();

  return _replicated;
}
