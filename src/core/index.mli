type t = int * int
       
module Map : sig     
    include Map.S with type key = t
    val set : key -> 'a -> 'a t -> 'a t 
  end
     
val move : Data.Side.t -> t -> t 
