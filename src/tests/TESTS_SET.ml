module type T = sig
  include NAMED_NODE.T with type child_t = (module TEST.T)
end
