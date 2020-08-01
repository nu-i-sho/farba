#include "wrapped.cpp"

template <typename T>
Wrapped::Wrapped(T value) {
  _value = value;
}

template <typename T>
bool Wrapped<T>::operator==(const Wrapped<T>& oth) {
  return _value == oth.value;
}

template <typename T>
bool Wrapped<T>::operator!=(const Wrapped<T>& oth) {
  return _value != oth.value;
}
