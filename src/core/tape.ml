module Make = functor (Num : SEQUENTIAL.T) -> struct
  module Energy = Energy.Make(Num)

  type stage =
    | Call   of Energy.Call.t
    | Find   of Energy.Find.t
              * Direction.t
              * Num.t
    | Close  of Energy.Close.t
    | Return of Energy.Return.t
              * Direction.t

  type cursor =
    | Apply of stage
    | Move  of stage

  type 'cmd e = ( 'cmd,
                  Num.t * (Energy.Wait.t list),
                  Num.t * (Energy.Open.t list)
                ) Statement.t
    
  type 'cmd t = 
    | Middle of 'cmd middle
    | Left   of 'cmd left
    | Right  of 'cmd right
    | Empty
    
   and 'cmd middle = 
     { prev :  'cmd e list;
       curr : ('cmd e) * cursor;
       next :  'cmd e list
     }
   and 'cmd left =
     { curr : cursor;
       next : ('cmd e) * ('cmd e list);
     }
   and 'cmd right = 
     { prev : ('cmd e) * ('cmd e list);
       curr : cursor;
     } 

  type error =
    | Nothing_to_do_with_empty_program
    | Procedure_not_found of Num.t     
                           
  let load = function
    | []     -> Empty
    | h :: t ->
       Left { curr = Move (Call Energy.origin);
              next = let internalize =
                       Statement.( function
                         | Perform x -> Perform  x
                         | Execute x -> Execute (x, [])
                         | Declare x -> Declare (x, [])                           
                       ) in
                     (h |> internalize),
                     (t |> List.map internalize)
            }
              
  module Tick = struct
    type nonrec 'cmd t =
      { command : 'cmd option;
           tape : 'cmd t
      }

    let command o = o.command
    let tape    o = o.tape

    let succ o =
      let open Direction in
      let open Statement in

      let middle x = Ok { command = None; tape = Middle x }
      and left   x = Ok { command = None; tape = Left   x }
      and right  x = Ok { command = None; tape = Right  x } in

      match o.tape with
      | Empty -> Error Nothing_to_do_with_empty_program
      
      | Middle ({ prev = p :: prev;
                  curr = c, (Move (( Find (_, Back, _)
                                   | Return (_, Back)
                                   | Close _) as e))
                } as o)
                  -> middle { prev;
                              curr = p, (Apply e);
                              next = c :: o.next
                            }
      | Middle ({ prev = [];
                  curr = c, (Move (( Find (_, Back, _)
                                   | Return (_, Back)
                                   | Close _) as e))
                } as o)
                  ->   left { curr = Apply e;
                              next = c, o.next
                            }
           
      | Middle ({ curr = c, (Move e);
                  next = n :: next
                } as o)
                  -> middle { prev = c :: o.prev;
                              curr = n, (Apply e);
                              next;
                            }
      | Middle ({ curr = c, (Move e);
                  next = []
                } as o)
                  ->  right { prev = c, o.prev;
                              curr = Apply e;
                            }

      | Left    { curr = Move e;
                  next = n, next
                } -> middle { prev = [];
                              curr = n, (Apply e);
                              next
                            }
      | Right   { prev = p, prev;
                  curr = Move e
                } -> middle { prev;
                              curr = p, (Apply e);
                              next = []
                            }

      | Middle ({ curr = (Perform cmd), (Apply ((Call _) as e)) } as o)
                  -> Ok { command = Some cmd;
                             tape = Middle { o with
                                             curr = (Perform cmd), (Move e)
                        }}
      | Middle ({ curr = (Execute (proc, ews)), (Apply (Call e)) } as o)
                  -> let ew, ef = Energy.find e in
                     middle { o with
                              curr = (Execute (proc, (ew :: ews))), 
                                     (Move (Find (ef, Forward, proc)))
                            }
      | Middle ({ curr = ((Declare _) as c), (Apply (Call e)) } as o)
                  -> let ec = Energy.close e in
                     middle { o with
                              curr = c, (Move (Close ec))
                            }
      | Right  ({ curr = Apply (Call e) } as o)
                  -> let ec = Energy.close e in
                     right  { o with
                              curr = Move (Close ec)
                            }

      | Middle ({ curr = (Declare (proc, eos)), 
                         (Apply (Find (e, _, proc'))) 
                } as o) when proc = proc'
                  -> let eo, ec = Energy.open' e in
                     middle { o with
                              curr = (Declare (proc, (eo :: eos))), 
                                     (Move (Call ec))
                            }
      | Left    { curr = Apply (Find (_, _, proc))
                } -> Error (Procedure_not_found proc)

      | Right  ({ curr = Apply (Find (e, _, proc)) } as o)
                  ->  right { o with
                              curr = Move (Find (e, Back, proc))
                            }

      | Middle ({ curr = ((Declare (proc, (oe :: oes))) as c), 
                         (Apply (Close e)) 
                } as o)
                  -> middle { o with
                              curr = match Energy.return oe e with
                                     | None    -> c, (Move (Close e))
                                     | Some er -> (Declare (proc, oes)), 
                                                  (Move (Return (er, Back)))
                            }
      | Middle ({ curr = ((Execute (proc, (ew :: ews))) as c), 
                  (Apply ((Return (e, _)) as er)) 
                } as o)
                  -> middle { o with
                              curr = match Energy.done' ew e with
                                     | None    -> c, (Move er)
                                     | Some ec -> (Execute (proc, ews)),
                                                  (Move (Call ec))
                            }
      | Left   ({ curr = Apply (Return (e, _)) } as o)
                  ->   left { o with
                              curr = Move (Return (e, Forward)) 
                            }

      | Middle ({ curr = c, (Apply e) } as o)
                  -> middle { o with
                              curr = c, (Move e)
                            }
      | Left   ({ curr = Apply e } as o)
                  ->   left { o with
                              curr = Move e
                            }
      | Right  ({ curr = Apply e } as o)
                  ->  right { o with
                              curr = Move e
                            }

    let start tape =
      succ { tape; command = None }
      
    end

  module Step = struct
    type nonrec 'cmd t =
      {     command : 'cmd;
        ticks_count : int;
               tape : 'cmd t
      }

    let command    o = o.command
    let tiks_count o = o.ticks_count
    let tape       o = o.tape

    let rec up_to_command i tick_result =   
      match tick_result with
      | Error _ as e -> e
      | Ok         x ->
         match Tick.command x with
         | None      -> up_to_command (Int.succ i) (Tick.succ x)
         | Some cmd  -> Ok {     command = cmd; 
                             ticks_count = i;
                                    tape = Tick.tape x
                           }            

    let start  tape = up_to_command 1 (Tick.start   tape)
    let adjust tick = up_to_command 1 (Ok tick)
    let succ      o = up_to_command 1 (Tick.start o.tape)
    let tick      o = Tick.start o.tape
    end         
  end
