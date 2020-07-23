#ifndef __API_HPP__
#define __API_HPP__

#include "𝚊𝚙𝚒.hpp"

extern "C" {
#include <caml/mlvalues.h>
}

class Api final : public 𝙰𝚙𝚒 {
 public:
  class File final : public 𝙰𝚙𝚒::𝙵𝚒𝚕𝚎 {
    friend class Api;
    
   public:
    class Errors final : public 𝙰𝚙𝚒::𝙵𝚒𝚕𝚎::𝙴𝚛𝚛𝚘𝚛𝚜 {
     public:
      int Level_is_missing()     const override;
      int Level_is_unavailable() const override;
      int Backup_not_found()     const override;
      int Backup_is_corrupted()  const override;
      int Name_is_empty()        const override;
      int Permission_denied()    const override;
      int File_already_exists()  const override;
      int Nothing_to_save()      const override;
    };

    int open_new(int level) override;
    int restore(int level, const char* name) override;
    int save() override;
    int save_as(const char* name) override;
    
   protected:
    𝙰𝚙𝚒::𝙵𝚒𝚕𝚎::𝙴𝚛𝚛𝚘𝚛𝚜* create_errors_node() override;
    
   private:
    Api* _api;
    File(Api* api);
  };

  Api();
  bool is_empty() const override;

 protected:
  𝙰𝚙𝚒::𝙵𝚒𝚕𝚎* create_file_node() override;    
  
 private:
  value _state;
  int extract_and_save_state(value caml_result);
};

#endif
