type t = | White
         | Blue
         | Gray

include Sig.REVERSIBLE with type t := t
