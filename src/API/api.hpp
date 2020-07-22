namespace Contract {
  class Api {
  public:
    virtual bool is_ok() = 0;
    virtual bool has_error() = 0;
    virtual int extract_error() = 0;
    
    class File {
    public:
      virtual ~File();
      
      class Error {
      public:
	virtual int LEVEL_IS_MISSING()    = 0;
	virtual int LEVEL_IS_UNAILABLE()  = 0;
	virtual int BACKUP_NOT_FOUND()    = 0;
	virtual int BACKUP_IS_CORRUPTED() = 0;
	virtual int NAME_IS_EMPTY()       = 0;
	virtual int PERMISSION_DENIED()   = 0;
	virtual int FILE_ALREADY_EXIST()  = 0;
      };
    
      virtual void open_new(int level) = 0;
      virtual void restore(int level, const char* name) = 0;
      virtual void save() = 0;
      virtual void save_as(const char* name) = 0;
      virtual Error* ERROR() = 0;
    };

  private:
    File* _file;
  protected:
    virtual File* file(Api* api) = 0;
  public:
    Api();
    virtual ~Api();
    
    File* file();
  };
}
