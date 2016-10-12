module type T = sig
    include Map.S

    val put        : key -> 'a -> 'a t -> 'a t
    val item       : key -> 'a t -> 'a
    val maybe_item : key -> 'a t -> 'a option
  end
