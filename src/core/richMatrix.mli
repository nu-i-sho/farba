module Extend (Matrix : MATRIX.T) : sig
    include MATRIX.T
    
    let extend   : Matrix.t -> t
    val is_out   : (int * int) -> Matrix.t -> t
    val in_range : (int * int) -> Matrix.t -> t

    val iter   : (e -> unit) -> t -> unit
    val iteri  : ((int * int) -> e -> unit) -> t -> unit
    val fold   : ('a -> e -> 'a) -> 'a -> t -> 'a
    val foldi  : ('a -> (int * int) -> e -> 'a) -> 'a -> t -> 'a
  end
