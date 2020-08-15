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
#include "data/domain.hpp"

using namespace std;
using 𝙲𝚞𝚛𝚜𝚘𝚛 = 𝙰𝚙𝚒::𝙴𝚟𝚎𝚗𝚝𝚜𝙾𝚏::𝙲𝚞𝚛𝚜𝚘𝚛;
using StatusOf = 𝙰𝚙𝚒::𝙵𝚒𝚕𝚎::StatusOf;
using Result = Caml::Value::Result;

Api::Api() {
  _state = Caml::Value::unit;
  _file = nullptr;
  _events_of = nullptr;
}

Api::~Api() {
  if (_file != nullptr) delete _file;
  if (_events_of != nullptr) delete _events_of;
}

bool Api::is_empty() const {
  return Caml::Value::is_block(_state);
}

Api::File* Api::file() {
  if (_file == nullptr) _file = new Api::File(this); 
  return _file;
}

Api::EventsOf* Api::events_of() {
  if (_events_of == nullptr) _events_of = new Api::EventsOf();
  return _events_of;
}

void Api::set_state(value state) {
  _state = state;
}

void Api::subscribe_caml_cursor_events() {
  static const value* core_subscribe =
    Caml::function("Core.Api.EventsOf.Cursor.subscribe");

  auto subscription_and_state =
    Caml::Value::to<tuple<value, value>>(
      Caml::call(core_subscribe,
        Caml::Value::of<Api*>(this),
        _state
      )
    );

  _cursor_events_subscription =
            get<0>(subscription_and_state);
  set_state(get<1>(subscription_and_state));
}

void Api::unsubscribe_caml_cursor_events() {
  static const value* core_unsubscribe =
    Caml::function("Core.Api.EventsOf.Cursor.unsubscribe");
					    
  auto observer_and_state =
    Caml::Value::to<tuple<value, value>>(
      Caml::call(core_unsubscribe,
        _cursor_events_subscription,
        _state
      )
    );

  set_state(get<1>(
    observer_and_state
  ));
}

Api::File::File(Api* api) {
  _api = api;
}

StatusOf::OpenNew Api::File::open_new(int level) {
  if (!_api -> is_empty())
    _api -> unsubscribe_caml_cursor_events();

  static const value* core_open_new =
    Caml::function("Core.Api.File.open_new");

  auto result =
    Caml::Value::to<Result>(
      Caml::call(core_open_new,
        Caml::Value::of<int>(level)
      )
    );

  if (result.is_error())
    return Caml::Value::to<StatusOf::OpenNew>(result.value);

  _api -> set_state(result.value);
  _api -> subscribe_caml_cursor_events();
  
  return StatusOf::OpenNew::OK; 
}

StatusOf::Restore Api::File::restore(int level, const char* name) {
  if (!_api -> is_empty())
    _api -> unsubscribe_caml_cursor_events();

  static const value* core_restore =
    Caml::function("Core.Api.File.restore");
  
  auto result =
    Caml::Value::to<Result>(
      Caml::call(core_restore,
        Caml::Value::of<int>(level),
        Caml::Value::of<const char*>(name)
      )
    );

  if (result.is_error())
    return Caml::Value::to<StatusOf::Restore>(result.value);

  _api -> set_state(result.value);
  _api -> subscribe_caml_cursor_events();
  
  return StatusOf::Restore::OK;
}

StatusOf::Save Api::File::save() {
  if (_api -> is_empty())
    return StatusOf::Save::Nothing_to_save;

  _api -> unsubscribe_caml_cursor_events();

  static const value* core_save =
    Caml::function("Core.Api.File.save");
  
  auto result =
    Caml::Value::to<Result>(
      Caml::call(core_save, _api -> _state)
    );

  if (result.is_error())
    return Caml::Value::to<StatusOf::Save>(result.value);

  _api -> set_state(result.value);
  _api -> subscribe_caml_cursor_events();

  return StatusOf::Save::OK;
}

StatusOf::SaveAs Api::File::save_as(const char* name) {
  if (_api -> is_empty())
    return StatusOf::SaveAs::Nothing_to_save;

  _api -> unsubscribe_caml_cursor_events();

  static const value* core_save_as =
    Caml::function("Core.Api.File.save_as");
  
  auto result =
    Caml::Value::to<Result>(
      Caml::call(core_save_as,
        Caml::Value::of<const char*>(name),
        _api -> _state
      )
    );

  if (result.is_error())
    return Caml::Value::to<StatusOf::SaveAs>(result.value);
  
  _api -> set_state(result.value);
  _api -> subscribe_caml_cursor_events();

  return StatusOf::SaveAs::OK;
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
