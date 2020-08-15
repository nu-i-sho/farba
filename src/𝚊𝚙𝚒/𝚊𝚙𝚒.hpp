#ifndef __𝙰𝙿𝙸_HPP__
#define __𝙰𝙿𝙸_HPP__

#include "data/domain.hpp"
#include "tissue_cell.hpp"
#include "change.hpp"
#include "nucleus_move.hpp"
#include "𝚘𝚋𝚜𝚎𝚛𝚟𝚊𝚝𝚒𝚘𝚗.hpp"

class 𝙰𝚙𝚒 {
 public:
  class 𝙵𝚒𝚕𝚎 {
   public:  
    class StatusOf {
     public:
      enum struct OpenNew {
	OK,
	Level_is_missing,
	Level_is_unavailable
      };

      enum struct Restore {
	OK,
	Permission_denied,
	Backup_not_found,
	Backup_is_corrupted,
      };

      enum struct Save {
	OK,
	Permission_denied,
	Nothing_to_save,
	Name_is_empty
      };

      enum struct SaveAs {
        OK,
	Permission_denied,
	Name_is_empty,
	Nothing_to_save,
	File_already_exists,
      };
      
     private:
      StatusOf() = default;
    };

    virtual StatusOf::OpenNew open_new(int level) = 0;
    virtual StatusOf::Restore restore(int level, const char* name) = 0;
    virtual StatusOf::Save    save() = 0;
    virtual StatusOf::SaveAs  save_as(const char* name) = 0;
    virtual ~𝙵𝚒𝚕𝚎() = default;
  };

  class 𝙴𝚟𝚎𝚗𝚝𝚜𝙾𝚏 {
   public:
    class 𝙲𝚞𝚛𝚜𝚘𝚛 {
     public:
      struct Turned {
        Hand direction;
	Change<TissueCell> change;
      };

      enum struct MovedMindStatus { Success, Fail };
      struct MovedMind : public NucleusMove<MovedMindStatus> { };

      enum struct MovedBodyStatus { Success, Fail, Clotted, Rev_gaze };
      struct MovedBody : public NucleusMove<MovedBodyStatus> { };

      enum struct ReplicatedStatus { Success, Fail, Clotted, Self_clotted };
      struct Replicated : public NucleusMove<ReplicatedStatus> {
	Gene gene;
      };

      virtual 𝙾𝚋𝚜𝚎𝚛𝚟𝚊𝚋𝚕𝚎<Turned>*     turned()     = 0;
      virtual 𝙾𝚋𝚜𝚎𝚛𝚟𝚊𝚋𝚕𝚎<MovedMind>*  moved_mind() = 0;
      virtual 𝙾𝚋𝚜𝚎𝚛𝚟𝚊𝚋𝚕𝚎<MovedBody>*  moved_body() = 0;
      virtual 𝙾𝚋𝚜𝚎𝚛𝚟𝚊𝚋𝚕𝚎<Replicated>* replicated() = 0;
      virtual ~𝙲𝚞𝚛𝚜𝚘𝚛() = default;
    };

    virtual 𝙲𝚞𝚛𝚜𝚘𝚛* cursor() = 0;
    virtual ~𝙴𝚟𝚎𝚗𝚝𝚜𝙾𝚏() = default;
  };
  
  virtual bool is_empty() const = 0;
  virtual 𝙵𝚒𝚕𝚎* file() = 0;
  virtual 𝙴𝚟𝚎𝚗𝚝𝚜𝙾𝚏* events_of() = 0;
  virtual ~𝙰𝚙𝚒() = default;
};

#endif
