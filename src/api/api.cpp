extern "C" {
#define CAML_NAME_SPACE
#include "caml/mlvalues.h"
#include "caml/memory.h"
#include "caml/callback.h"
#include "caml/alloc.h"
}

#include <map>
#include "api.hpp"
#include "data/domain.hpp"

using namespace std;
using 𝙲𝚞𝚛𝚜𝚘𝚛 = 𝙰𝚙𝚒::𝙴𝚟𝚎𝚗𝚝𝚜𝙾𝚏::𝙲𝚞𝚛𝚜𝚘𝚛;
using ResultOf = 𝙰𝚙𝚒::𝙵𝚒𝚕𝚎::ResultOf;

#define CAML_FUNC(F, NAME) \
  static const value* F = nullptr; \
  if (F == nullptr) F = caml_named_value(NAME)

#define CAML_POLIMORPHIC_VARIANT_AS_CONST(NAME) \
  static const int NAME = caml_hash_variant(#NAME);

namespace Caml {
  CAML_POLIMORPHIC_VARIANT_AS_CONST(Level_is_missing)
  CAML_POLIMORPHIC_VARIANT_AS_CONST(Level_is_unavailable)
  CAML_POLIMORPHIC_VARIANT_AS_CONST(Permission_denied)
  CAML_POLIMORPHIC_VARIANT_AS_CONST(Backup_not_found)
  CAML_POLIMORPHIC_VARIANT_AS_CONST(Backup_is_corrupted)
  CAML_POLIMORPHIC_VARIANT_AS_CONST(Name_is_empty)
  CAML_POLIMORPHIC_VARIANT_AS_CONST(File_already_exists)

  CAML_POLIMORPHIC_VARIANT_AS_CONST(Success)
  CAML_POLIMORPHIC_VARIANT_AS_CONST(Fail)
  CAML_POLIMORPHIC_VARIANT_AS_CONST(Clotted)
  CAML_POLIMORPHIC_VARIANT_AS_CONST(Rev_gaze)
  CAML_POLIMORPHIC_VARIANT_AS_CONST(Self_clotted)
}

value Val_api_ptr(Api* api) {
  value caml_api = caml_alloc_small(1, Abstract_tag);
  Field(caml_api, 0) = (value)api;
  return caml_api;
}

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

int Api::extract_and_save_state(value caml_result) {
  // Result.Ok:
  if (Tag_val(caml_result) == 0) {
    _state = Field(caml_result, 0);
    return 0;
  }
  
  // Result.Error:
  return Int_val(Field(caml_result, 0));
}

void Api::subscribe_caml_cursor_events() {
  CAML_FUNC(subscribe, "Events.Cursor.subscribe");
  value subscription_and_state = caml_callback2(
      *subscribe,
      Val_api_ptr(this),
      _state
  );

  value subscrioption = Field(subscription_and_state, 0);
  value state         = Field(subscription_and_state, 1);

  _cursor_events_subscription = subscrioption;
  _state = state;
}

void Api::unsubscribe_caml_cursor_events() {
  CAML_FUNC(unsubscribe, "Events.Cursor.unsubscribe");
  value ignored_value_and_state = caml_callback2(
      *unsubscribe,
      _cursor_events_subscription,
      _state
  );

  value state = Field(ignored_value_and_state, 1);
  _state = state;
}

Api::File::File(Api* api) {
  _api = api;
}

ResultOf::OpenNew Api::File::open_new(int level) {
  if (!_api -> is_empty())
    _api -> unsubscribe_caml_cursor_events();

  static const map<int, ResultOf::OpenNew> results = {
    { 0,                          ResultOf::OpenNew::OK                   },
    { Caml::Level_is_missing,     ResultOf::OpenNew::Level_is_missing     },
    { Caml::Level_is_unavailable, ResultOf::OpenNew::Level_is_unavailable }
  };
  
  CAML_FUNC(caml_open_new, "File.open_new");
  auto result = results.at(Int_val(
    _api -> extract_and_save_state(
      caml_callback(
        *caml_open_new,
        Val_int(level)
      )
    )
  ));

  _api -> subscribe_caml_cursor_events();
  return result;
}

ResultOf::Restore Api::File::restore(int level, const char* name) {
  if (!_api -> is_empty())
    _api -> unsubscribe_caml_cursor_events();

  static const map<int, ResultOf::Restore> results = {
    { 0,                         ResultOf::Restore::OK                  },
    { Caml::Permission_denied,   ResultOf::Restore::Permission_denied   },
    { Caml::Backup_not_found,    ResultOf::Restore::Backup_not_found    },
    { Caml::Backup_is_corrupted, ResultOf::Restore::Backup_is_corrupted }
  };
  
  CAML_FUNC(caml_restore, "File.restore");
  auto result = results.at(Int_val(
    _api -> extract_and_save_state(
      caml_callback2(
        *caml_restore,
        Val_int(level),
        caml_copy_string(name)
      )
    )
  ));

  _api -> subscribe_caml_cursor_events();
  return result;
}

ResultOf::Save Api::File::save() {
  if (_api -> is_empty()) return  ResultOf::Save::Nothing_to_save;

  static const map<int, ResultOf::Save> results = {
    { 0,                          ResultOf::Save::OK                },
    { Caml::Permission_denied,    ResultOf::Save::Permission_denied },
    { Caml::Name_is_empty,        ResultOf::Save::Name_is_empty     }			   
  };
    
  _api -> unsubscribe_caml_cursor_events();

  CAML_FUNC(caml_save, "File.save");
  auto result = results.at(Int_val(
    _api -> extract_and_save_state(
      caml_callback(
        *caml_save,
        _api -> _state
      )
    )
  ));

  _api -> subscribe_caml_cursor_events();
  return result;
}

ResultOf::SaveAs Api::File::save_as(const char* name) {
  if (_api -> is_empty()) return ResultOf::SaveAs::Nothing_to_save;

  static const map<int, ResultOf::SaveAs> results = {
    { 0,                          ResultOf::SaveAs::OK                  },
    { Caml::Permission_denied,    ResultOf::SaveAs::Permission_denied   },
    { Caml::Name_is_empty,        ResultOf::SaveAs::Name_is_empty       },
    { Caml::File_already_exists,  ResultOf::SaveAs::File_already_exists } 
  };
  
  _api -> unsubscribe_caml_cursor_events();
  
  CAML_FUNC(caml_save_as, "File.save_as");
  auto result = results.at(Int_val(
    _api -> extract_and_save_state(
      caml_callback2(
        *caml_save_as,
        caml_copy_string(name),
        _api -> _state
      )
    )
  ));

  _api -> subscribe_caml_cursor_events();
  return result;
}

template <typename T>
T Enum_struct_val(value v) {
  return static_cast<T>(Int_val(v));
}

TissueCell Tissue_cell_val(value v) {
  
  value caml_tissue_coord  = Field(v, 0);
  value caml_nucleus_opt   = Field(v, 1);
  value caml_cytoplasm_opt = Field(v, 2);
  value caml_clotted       = Field(v, 3);
  value caml_cursor_in     = Field(v, 4);
    
  auto coord = make_tuple(
    Int_val(Field(caml_tissue_coord, 0)),
    Int_val(Field(caml_tissue_coord, 1)));

  Nucleus* nucleus = nullptr;
  if (Is_block(caml_nucleus_opt)) // Some nucleus
    nucleus = new Nucleus {
      Enum_struct_val<Pigment>(Field(caml_nucleus_opt, 0)),
      Enum_struct_val<Side>   (Field(caml_nucleus_opt, 1))
    };

  Pigment* cytoplasm = nullptr;
  if (Is_block(caml_cytoplasm_opt)) // Some cytoplasm
    cytoplasm = new Pigment(	    
      Enum_struct_val<Pigment>(Field(caml_cytoplasm_opt, 0))
    );

  bool clotted   = Bool_val(caml_clotted);
  bool cursor_in = Bool_val(caml_cursor_in);

  return TissueCell {
    coord, nucleus, cytoplasm, clotted, cursor_in
  };
}

template <typename T>
tuple<T, T> Pair_val(T (*T_val)(value), value v) {
  return make_tuple<T, T>(T_val(Field(v, 0)), T_val(Field(v, 1)));
}

template <typename T>
Change<T> Change_val(T (*T_val)(value), value v) {
  return Change<T> {
    T_val(Field(v, 0)),
    T_val(Field(v, 1))
  };
}

Change<TissueCell> Change_of_TissueCell_val(value v) {
  return Change_val<TissueCell>(Tissue_cell_val, v);
}

Change<tuple<TissueCell, TissueCell>> Change_of_TissueCell_tuple_val(value v) {
  return Change_val<tuple<TissueCell, TissueCell>>(
    [] (value v) { return Pair_val(Tissue_cell_val, v); },
    Field(v, 1));
}

extern "C" {
  CAMLprim value on_cursor_turned(value caml_event, value caml_api) {
    CAMLparam2(caml_event, caml_api);    

    auto api    = (Api*)                   Field(caml_api,   0);
    auto hand   = Enum_struct_val<Hand>(   Field(caml_event, 0));
    auto change = Change_of_TissueCell_val(Field(caml_event, 1));

    auto event = 𝙲𝚞𝚛𝚜𝚘𝚛::Turned { hand, change };
    api -> events_of() -> cursor() -> _turned -> send(event);

    CAMLreturn(Val_api_ptr(api));
  }
 
  CAMLprim value on_cursor_moved_mind(value caml_event, value caml_api) {
    CAMLparam2(caml_event, caml_api);

    static const map<int, 𝙲𝚞𝚛𝚜𝚘𝚛::MovedMindStatus> statuses = {
      { Caml::Success, 𝙲𝚞𝚛𝚜𝚘𝚛::MovedMindStatus::Success },
      { Caml::Fail,    𝙲𝚞𝚛𝚜𝚘𝚛::MovedMindStatus::Fail    }
    };

    auto api       = (Api*)                         Field(caml_api,   0);
    auto direction = Enum_struct_val<Side>(         Field(caml_event, 0));
    auto change    = Change_of_TissueCell_tuple_val(Field(caml_event, 1));
    auto status    = statuses.at(Int_val(           Field(caml_event, 2)));

    auto event = 𝙲𝚞𝚛𝚜𝚘𝚛::MovedMind { direction, change, status };
    api -> events_of() -> cursor() -> _moved_mind -> send(event);
    
    CAMLreturn(Val_api_ptr(api));
  }

  CAMLprim value on_cursor_moved_body(value caml_event, value caml_api) {
    CAMLparam2(caml_event, caml_api);
    
    static const map<int, 𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus> statuses = {
      { Caml::Success,  𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus::Success  },
      { Caml::Fail,     𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus::Fail     },
      { Caml::Clotted,  𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus::Clotted  },
      { Caml::Rev_gaze, 𝙲𝚞𝚛𝚜𝚘𝚛::MovedBodyStatus::Rev_gaze }
    };

    auto api       = (Api*)                         Field(caml_api,   0);
    auto direction = Enum_struct_val<Side>(         Field(caml_event, 0));
    auto change    = Change_of_TissueCell_tuple_val(Field(caml_event, 1));
    auto status    = statuses.at(Int_val(           Field(caml_event, 2)));

    auto event = 𝙲𝚞𝚛𝚜𝚘𝚛::MovedBody { direction, change, status };
    api -> events_of() -> cursor() -> _moved_body -> send(event);
    
    CAMLreturn(Val_api_ptr(api));
  }

  CAMLprim value on_cursor_replicated(value caml_event, value caml_api) {
    CAMLparam2(caml_event, caml_api);

    static const map<int, 𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus> statuses = {
      { Caml::Success,      𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus::Success      },
      { Caml::Fail,         𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus::Fail         },
      { Caml::Clotted,      𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus::Clotted      },
      { Caml::Self_clotted, 𝙲𝚞𝚛𝚜𝚘𝚛::ReplicatedStatus::Self_clotted }
    };
    
    auto api       = (Api*)                         Field(caml_api,   0);
    auto gene      = Enum_struct_val<Gene>(         Field(caml_event, 0));
    auto direction = Enum_struct_val<Side>(         Field(caml_event, 1));
    auto change    = Change_of_TissueCell_tuple_val(Field(caml_event, 2));
    auto status    = statuses.at(Int_val(           Field(caml_event, 3)));
    
    auto event = 𝙲𝚞𝚛𝚜𝚘𝚛::Replicated { direction, change, status, gene };
    api -> events_of() -> cursor() -> _replicated -> send(event);
    
    CAMLreturn(Val_api_ptr(api));
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
