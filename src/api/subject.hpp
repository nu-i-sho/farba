#ifndef __SUBJECT_HPP__
#define __SUBJECT_HPP__

#include <list>
#include <memory>
#include "𝚊𝚙𝚒/𝚘𝚋𝚜𝚎𝚛𝚟𝚊𝚝𝚒𝚘𝚗.hpp"
using namespace std;

template <typename T_event>
class Subject final
  : public 𝙾𝚋𝚜𝚎𝚛𝚟𝚎𝚛<T_event>
  , public 𝙾𝚋𝚜𝚎𝚛𝚟𝚊𝚋𝚕𝚎<T_event> {
 public:
  𝚂𝚞𝚋𝚜𝚌𝚛𝚒𝚙𝚝𝚒𝚘𝚗<T_event>* subscribe(𝙾𝚋𝚜𝚎𝚛𝚟𝚎𝚛<T_event>* observer) override;
  void send(T_event event) override;
  
  Subject();
  ~Subject();
  
 private:
  class Subscription final : public 𝚂𝚞𝚋𝚜𝚌𝚛𝚒𝚙𝚝𝚒𝚘𝚗<T_event> {
   public:
    𝙾𝚋𝚜𝚎𝚛𝚟𝚎𝚛<T_event>* cancel() override;
    
   private:
    Subject<T_event>* _parent;
    bool _is_canceled;
    typename list<𝙾𝚋𝚜𝚎𝚛𝚟𝚎𝚛<T_event>*>::iterator _pos;
    Subscription(Subject<T_event>* parent);
    friend class Subject<T_event>;
  };

  Subject<T_event>* _self;
  list<𝙾𝚋𝚜𝚎𝚛𝚟𝚎𝚛<T_event>*>* _observers;
};

#endif
