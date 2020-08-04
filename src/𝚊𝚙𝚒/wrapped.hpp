#ifndef __WRAPPED_HPP__
#define __WRAPPED_HPP__

template <typename T>
class Wrapped {
 public:
  bool operator==(const Wrapped<T>& oth);
  bool operator!=(const Wrapped<T>& oth);
 protected:
  Wrapped(T value);
 private:
  T _value;
};

#endif 
