module type S = sig
  include Map.S
        
  val set         : key -> 'a -> 'a t -> 'a t
  val of_bindings : (key * 'a) list -> ('a t)
  end

module type OrderedType =
  Map.OrderedType
              
module Make :
  functor (Key : OrderedType) ->
  S with type key = Key.t

module MakeDefault :
  functor (Key : sig type t end) ->
  S with type key = Key.t

module MakeOpt :
  functor (Key : OrderedType) ->
  S with type key = Key.t option
                
module MakePair :
  functor (Fst : OrderedType) ->
  functor (Snd : OrderedType) ->
  S with type key = Fst.t * Snd.t
