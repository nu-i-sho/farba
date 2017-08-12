open Data
open Tools
   
type inited_t = { values : DotsOfDice.t IntMap.t;
                    mode : RuntimeMode.t;
                     top : Crumb.t
                }
              
type t = (unit, inited_t) Initable.t

let empty = Initable.make ()
let init top mode _ =
  Initable.init ({ values = IntMap.empty;
                     mode;
                      top
                })
let top o =
  let o = Initable.inited o in
  Crumb.( CallStackPoint.(
     { value = o.top.value;
       stage = Stage.Active o.mode
     }
  ))

let top_index o =
  let o = Initable.inited o in
  Crumb.(o.top.index)

let exists_in_range from count o =

  let o = Initable.inited o in
  let last = from + count - 1 in
  let in_range i = i >= from && i < last in

  (in_range Crumb.(o.top.index)) ||
    ( let in_range key _ = in_range key in
      IntMap.exists in_range o.values
    )
  
let update_top previous current o =
  let o = Initable.inited o in
  let values = 
    Crumb.( Doubleable.(
      match previous, current with

      | { value = Double (x, y); index = i },
        { value = Single z;      index = j } when y = z && i <> j
          -> IntMap.add i x o.values
       
      | { value = Single x;      index = i },
        { value = Double (y, z); index = j } when x = z && i <> j
          -> IntMap.remove i o.values
         
      | { value = Double _; _ }, { value = Double _; _ }
          -> failwith Fail.impossible_case 
      | _ -> o.values
    )) in
  Initable.init { o with values; top = current }
  
let update_mode _ current o =
  let o = Initable.inited o in
  Initable.init { o with mode = current }
  
let point i o =
  let o = Initable.inited o in
  Crumb.( Doubleable.( CallStackPoint.( 

    if o.top.index = i then
      Some { value = o.top.value;
             stage = Stage.Active o.mode
           } else
      
      if IntMap.mem i o.values then
        Some { value = Single (IntMap.find i o.values);
               stage = Stage.Wait
             } else
        
        None
  )))
