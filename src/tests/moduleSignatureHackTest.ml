module type T_PROVIDER = sig
  module type T
end

module type SUMM = functor
    (Left : T_PROVIDER) -> functor
      (Right : T_PROVIDER) -> 
	T_PROVIDER

module Marge : SUMM = functor
  (Left : T_PROVIDER) -> functor
    (Right : T_PROVIDER) -> struct
      module type T = sig
	include Left.T
	include Right.T
      end
    end

module NAMED_Provider = struct
  module type T = sig
    val name : string
  end
end

module IDABLE_Provider = struct
  module type T = sig
     val id : int
  end
end

module NAMED_IDABLE_Provider = 
  Marge (NAMED_Provider) (IDABLE_Provider)

module type NAMED_IDABLE = 
    NAMED_IDABLE_Provider.T
