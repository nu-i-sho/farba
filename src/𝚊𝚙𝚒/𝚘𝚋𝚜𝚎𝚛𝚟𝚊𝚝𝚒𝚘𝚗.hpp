#ifndef __𝙾𝙱𝚂𝙴𝚁𝚅𝙰𝚃𝙸𝙾𝙽_HPP__
#define __𝙾𝙱𝚂𝙴𝚁𝚅𝙰𝚃𝙸𝙾𝙽_HPP__

template <typename T_event>
class 𝙾𝚋𝚜𝚎𝚛𝚟𝚎𝚛 {
 public:
  virtual void send(T_event event) = 0;
  virtual ~𝙾𝚋𝚜𝚎𝚛𝚟𝚎𝚛();
};

template <typename T_event>
class 𝚂𝚞𝚋𝚜𝚌𝚛𝚒𝚙𝚝𝚒𝚘𝚗 {
 public:
  virtual 𝙾𝚋𝚜𝚎𝚛𝚟𝚎𝚛<T_event*> cancel() = 0;
  virtual ~𝚂𝚞𝚋𝚜𝚌𝚛𝚒𝚙𝚝𝚒𝚘𝚗();
};

template <typename T_event>
class 𝙾𝚋𝚜𝚎𝚛𝚟𝚊𝚋𝚕𝚎 {
 public:
  virtual 𝚂𝚞𝚋𝚜𝚌𝚛𝚒𝚙𝚝𝚒𝚘𝚗<T_event>* subscribe(𝙾𝚋𝚜𝚎𝚛𝚟𝚎𝚛<T_event>* observer) = 0;
  virtual ~𝙾𝚋𝚜𝚎𝚛𝚟𝚊𝚋𝚕𝚎();
};
  
#endif
