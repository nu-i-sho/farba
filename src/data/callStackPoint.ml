module Value = struct
    type t = | Double of DotsOfDice.t * DotsOfDice.t
             | Single of DotsOfDice.t
  end

type t = { value : Value.t;
           index : int
         }
