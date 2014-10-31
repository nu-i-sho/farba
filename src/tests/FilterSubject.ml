module Out = DirectSubject

type 'a t = 
    { out : 'a Out.t;
      filter : 'a -> bool
    }

let make filter =
  { out = Out.empty;
    filter
  }

let subscribe observer o = 
  let (unsubscribe, out) = 
    o.out |> Out.subscribe observer in
  (unsubscribe, { o with out })
    
let send msg o =
  let out = if filter msg then 
    o.out |> Out.send msg else
    o.out in
  { o with out }
  
