#ifndef __API_HPP__
#define __API_HPP__

extern "C" {
#define CAML_NAME_SPACE
#include "caml/mlvalues.h"
}

#include "𝚊𝚙𝚒/𝚊𝚙𝚒.hpp"
#include "subject.cpp"

extern "C" {  
  value on_cursor_turned    (value caml_event, value caml_api);
  value on_cursor_moved_body(value caml_event, value caml_api);
  value on_cursor_moved_mind(value caml_event, value caml_api);
  value on_cursor_replicated(value caml_event, value caml_api);
}

class Api final : public 𝙰𝚙𝚒 {
 public:
  class File final : public 𝙰𝚙𝚒::𝙵𝚒𝚕𝚎 {
    friend class Api;
    
   public:
    ResultOf::OpenNew open_new(int level) override;
    ResultOf::Restore restore(int level, const char* name) override;
    ResultOf::Save    save() override;
    ResultOf::SaveAs  save_as(const char* name) override;

    ~File() = default;
   private:
    Api* _api;
    File(Api* api);
  };

  class EventsOf final : public 𝙰𝚙𝚒::𝙴𝚟𝚎𝚗𝚝𝚜𝙾𝚏 {
   public:
    class Cursor final : public 𝙰𝚙𝚒::𝙴𝚟𝚎𝚗𝚝𝚜𝙾𝚏::𝙲𝚞𝚛𝚜𝚘𝚛 {
     public:
      𝙾𝚋𝚜𝚎𝚛𝚟𝚊𝚋𝚕𝚎<Turned>*     turned()     override;
      𝙾𝚋𝚜𝚎𝚛𝚟𝚊𝚋𝚕𝚎<MovedMind>*  moved_mind() override;
      𝙾𝚋𝚜𝚎𝚛𝚟𝚊𝚋𝚕𝚎<MovedBody>*  moved_body() override;
      𝙾𝚋𝚜𝚎𝚛𝚟𝚊𝚋𝚕𝚎<Replicated>* replicated() override;
    
    private:
      Subject<Turned>*     _turned;
      Subject<MovedMind>*  _moved_mind;
      Subject<MovedBody>*  _moved_body;
      Subject<Replicated>* _replicated;

      Cursor();
      ~Cursor();
      
      friend class EventsOf;
      friend value on_cursor_turned    (value caml_event, value caml_api);
      friend value on_cursor_moved_body(value caml_event, value caml_api);
      friend value on_cursor_moved_mind(value caml_event, value caml_api);
      friend value on_cursor_replicated(value caml_event, value caml_api);
    };

    Cursor* cursor() override;
   private:
    Cursor* _cursor;
    
    EventsOf();
    ~EventsOf();
    friend class Api;
  };
  
  Api();
  ~Api();
    
  bool is_empty() const override;
  File* file() override;
  EventsOf* events_of() override;
  
 private:
  value _state;
  value _cursor_events_subscription;
  File* _file;
  EventsOf* _events_of;

  int extract_and_save_state(value caml_result);
  void subscribe_caml_cursor_events();
  void unsubscribe_caml_cursor_events();
};

#endif
