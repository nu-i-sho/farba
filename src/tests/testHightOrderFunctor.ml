module type T = sig
  type t
end

module type MAKE = functor 
    (Input : T) -> 
      T

module type HIGHT_ORDER_MAKE = functor
    (Input : T) -> functor
      (Make : MAKE) ->
	T

module Int : T = struct
  type t = int
end

module MakeDouble : MAKE = functor 
  (Input : T) -> struct
    type t = Input.t * Input.t
  end

module MakeDoubleProduct : HIGHT_ORDER_MAKE = functor
  (Input : T) -> functor
    (Factory : MAKE) -> struct
      module Product = Factory (Input) 
      type t = Product.t * Product.t
    end

module PairOfPairOfInt =
  MakeDoubleProduct (Int) (MakeDouble)
