module Stage = struct
    type t = | Active of RuntimeMode.t
             | Wait        
  end
             
type t = { value : DotsOfDice.t Doubleable.t;
           stage : Stage.t
         }
