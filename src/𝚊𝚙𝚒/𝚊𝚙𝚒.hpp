class 𝙰𝚙𝚒 {
 public:
  𝙰𝚙𝚒();
  virtual ~𝙰𝚙𝚒();
  
  virtual bool is_ok() = 0;
  virtual bool has_error() = 0;
  virtual int extract_error() = 0;
    
  class 𝙵𝚒𝚕𝚎 {
   public:  
    class 𝙴𝚛𝚛𝚘𝚛 {
     public:
      virtual int Level_is_missing()     = 0;
      virtual int Level_is_unavailable() = 0;
      virtual int Backup_not_found()     = 0;
      virtual int Backup_is_corrupted()  = 0;
      virtual int Name_is_empty()        = 0;
      virtual int Permission_denied()    = 0;
      virtual int File_alreadt_exists()  = 0;
    };

    virtual ~𝙵𝚒𝚕𝚎();
  
    virtual void open_new(int level) = 0;
    virtual void restore(int level, const char* name) = 0;
    virtual void save() = 0;
    virtual void save_as(const char* name) = 0;
    virtual 𝙴𝚛𝚛𝚘𝚛* error() = 0;
  };
  
  𝙵𝚒𝚕𝚎* file();
 protected:
  virtual 𝙵𝚒𝚕𝚎* file(𝙰𝚙𝚒* api) = 0;
 private:
  𝙵𝚒𝚕𝚎* _file;
};
