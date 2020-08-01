#include <list>
#include <memory>
#include  "../𝚊𝚙𝚒/𝚘𝚋𝚜𝚎𝚛𝚟𝚊𝚝𝚒𝚘𝚗.hpp"
#include "subject.hpp"
using namespace std;

template <typename T_event>
Subject<T_event>::Subscription::Subscription(Subject* parent) {
  _is_canceled = false;
  _parent = parent;
  _pos = (*_parent)->_observers->begin();
}

template <typename T_event>
𝙾𝚋𝚜𝚎𝚛𝚟𝚎𝚛<T_event>* Subject<T_event>::Subscription::cancel() {
  if (!_is_canceled && *_parent != nullptr) { 
    auto observer = *_pos;
    (*_parent)->_observers->erase(_pos);
    _is_canceled = true;
    return observer;
  };

  return nullptr;
}

template <typename T_event>
Subject<T_event>::Subject() {
  _observers = new std::list<𝙾𝚋𝚜𝚎𝚛𝚟𝚎𝚛<T_event>*>();
  _self = this; 
}

template <typename T_event>
Subject<T_event>::~Subject() {
  delete _observers;
  _self = nullptr;
}

template <typename T_event>
𝚂𝚞𝚋𝚜𝚌𝚛𝚒𝚙𝚝𝚒𝚘𝚗<T_event>* Subject<T_event>::subscribe(
  𝙾𝚋𝚜𝚎𝚛𝚟𝚎𝚛<T_event>* observer) {

  _observers.push_front(observer);
  return new Subject<T_event>::Subscription(&_self);
}

template <typename T_event>
void Subject<T_event>::send(T_event event) {
  
}
