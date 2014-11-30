module type T = sig
  include T.T
  val all_from_default_ordered_to_right : t list
end
