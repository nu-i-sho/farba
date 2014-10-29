module type T = sig
  include NAMED_NODE with type child_t = (module TESTS_SET.T)
end
