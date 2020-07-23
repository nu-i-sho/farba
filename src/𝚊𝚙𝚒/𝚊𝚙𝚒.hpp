#ifndef __𝙰𝙿𝙸_HPP__
#define __𝙰𝙿𝙸_HPP__

class 𝙰𝚙𝚒 {
 public:
  class 𝙵𝚒𝚕𝚎 {
   public:  
    class 𝙴𝚛𝚛𝚘𝚛𝚜 {
     public:
      virtual int Level_is_missing()     const = 0;
      virtual int Level_is_unavailable() const = 0;
      virtual int Backup_not_found()     const = 0;
      virtual int Backup_is_corrupted()  const = 0;
      virtual int Name_is_empty()        const = 0;
      virtual int Permission_denied()    const = 0;
      virtual int File_already_exists()  const = 0;
      virtual int Nothing_to_save()      const = 0;

      virtual ~𝙴𝚛𝚛𝚘𝚛𝚜();
    };

    virtual ~𝙵𝚒𝚕𝚎();
    𝙴𝚛𝚛𝚘𝚛𝚜* errors();
  
    virtual int open_new(int level) = 0;
    virtual int restore(int level, const char* name) = 0;
    virtual int save() = 0;
    virtual int save_as(const char* name) = 0;

   protected:
    𝙵𝚒𝚕𝚎();
    virtual 𝙴𝚛𝚛𝚘𝚛𝚜* create_errors_node() = 0;

   private:
    𝙴𝚛𝚛𝚘𝚛𝚜* _errors;
  };

  virtual ~𝙰𝚙𝚒();
  virtual bool is_empty() const = 0;
  𝙵𝚒𝚕𝚎* file();
  
 protected:
  𝙰𝚙𝚒();
  virtual 𝙵𝚒𝚕𝚎* create_file_node() = 0;
  
 private:
  𝙵𝚒𝚕𝚎* _file;
};

#endif
