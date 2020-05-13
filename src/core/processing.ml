module type COMMANDER = sig
  type t
  val perform : Command.t -> t -> t  
  end

module Make (Commander : COMMANDER) = struct
  type t =
    { commander : Commander.t;
      arguments : Statement.t lo Dots.Map.t
           prev : prev_element List.t;
        current : current;
           next : Statement.t List.t
    }

   and current =
    {  statement : statement Option.t;
      influencer : current_influencer
    }
    
   and prev_element =
    {  statement : statement;
      influencer : prev_influence
    }

   and current_influencer =
     | Call of Energy.Call.t
     | Back of Energy.Back.t
     | Find of Energy.Find.t
     
   and prev_influencer =
     | Mark of Energy.Mark.t 
     | Wait of Energy.Wait.t
     | None
      
  let step o =
    match o.current.influencer with
    | Call call ->
       match o.current.statement with
       | Some ((Command cmd) as statement)
       | Some ((Parameter { value = (Command cmd)) 
         -> let current_statement, next =
              match o.next with
              | h :: t -> (Some h), t
              | []     -> (None  ), [] in
            let current = { o.current with
                            statement = current_statement
                          } in
          
            { commander = Commander.perform cmd o.commander;
                   prev = (statement, None) :: o.prev;
                current;
                   next
            }
          
       | Some (Parameter param)
         -> match param.value with
            | []       -> { o with c 
            | arg :: t -> 
            
         
    | Find find -> 
    | Back back -> 

    
    match o.current with
    | (Some ((Command cmd) as e)),
      ((Influencer.Call _) as infl)

      -> let commander = Commander.perform cmd o.commander in
         let prev = o.before :: (e, None) in
         let current, next =
           match o.after with
           | h :: t -> ((Some h), infl), t
           | []     -> (None, infl), [] in
         { commander,
           prev,
           current,
           next
         }
           
    | None, (Influencer.Call call)

      -> { o with
              prev = List.tl o.before; 
           current = let back = Influencer.back call in
                      (Some (List.hd o.next)),
                      (Influenser.Back back);
              next = []
         }

    | (Some ((Declare _) as e)),
      (
    
  end
