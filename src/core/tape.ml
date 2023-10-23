module Make = functor (Num : SEQUENTIAL.T) -> struct
  module Energy = Energy.Make(Num)

  type 'cmd e =
    | Perform of 'cmd
    | Execute of Num.t * (Energy.Wait.t list)
    | Declare of Num.t * (Energy.Open.t list)  

  type cursor =
    | Call   of Energy.Call.t
    | Find   of Energy.Find.t
              * Direction.t
              * Num.t
    | Close  of Energy.Close.t
    | Return of Energy.Return.t
              * Direction.t

  type 'cmd t = 
    { prev :  'cmd e list;
      curr : ('cmd e) * cursor;
      next :  'cmd e list
    }

  type 'cmd tick =
    { command : 'cmd option;
            o : 'cmd t
    }


  let tick o = { command = None; o }

  let step o  =
    let rec step i o =
      let tick, i = (tick o), (succ i) in
      match tick.command with
      | None   -> step i tick.o
      | Some c -> c, i, tick.o in
    step 0 o
                
  end

                                     (*
  
    let tick = function
        
      | { prev = ps;
          curr = c, (Call ec);
          next = ((Perform cmd) as n) :: ns
        } ->
             { command = Some cmd;
                  tape = { prev = c :: ps;
                           curr = n, (Call ec);
                           next = ns
             }}
           
      | { prev = ps;
          curr = c, (Call ec);
          next = (Execute (proc, ens)) :: n2 :: ns
        } ->
             let e_wait, e_find = Energy.find ec in
             { command = None;
                  tape = { prev = (Execute (proc, (e_wait :: ens))) :: c :: ps;
                           curr = n2, (Find (e_find, Direction.Forward, proc));
                           next = ns
             }}
                                      *)
