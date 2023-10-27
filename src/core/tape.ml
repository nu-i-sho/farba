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

  type 'cmd e =
    | Perform of 'cmd
    | Execute of Num.t * (Energy.Wait.t list)
    | Declare of Num.t * (Energy.Open.t list)  

  type 'cmd t = 
    | Middle of
        { prev :  'cmd e list;
          curr : ('cmd e) * cursor;
          next :  'cmd e list
        }
    | LeftEnd of
        { curr : cursor;
          next : ('cmd e) * ('cmd e list);
        }
    | RightEnd of
        { prev : ('cmd e) * ('cmd e list);
          curr : cursor;
        }
    | Empty
    
  type 'cmd tick =
    { command : 'cmd option;
            o : 'cmd t
    }

  type 'cmd step =
    {     command : 'cmd;
      ticks_count : int;
                o : 'cmd t
    }

  type error =
    | Nothing_to_do_with_empty_program
    | Procedure_not_found of Num.t     
    
  let tick o =
    let open Direction in
    let with_command  x o = Ok { command = Some x; o }
    and without_command o = Ok { command = None;   o } in
    match o with
    | Empty -> Error Nothing_to_do_with_empty_program
      
    | Middle
      { prev = ps :: pss;
        curr = cs, (Move (( Find (_, Back, _)
                          | Return (_, Back)
                          | Close _) as e));
        next = nss
      } -> without_command
             (Middle { prev = pss;
                       curr = ps, (Apply e);
                       next = cs :: nss
                     })
    | Middle
      { prev = [];
        curr = cs, (Move (( Find (_, Back, _)
                          | Return (_, Back)
                          | Close _) as e));
        next = nss
      } -> without_command
             (LeftEnd { curr = Apply e;
                        next = cs, nss
                      })
           
    | Middle 
      { prev = pss;
        curr = cs, (Move e);
        next = ns :: nss
      } -> without_command
             (Middle { prev = cs :: pss;
                       curr = ns, (Apply e);
                       next = nss
                     })
    | Middle 
      { prev = pss;
        curr = cs, (Move e);
        next = []
      } -> without_command
             (RightEnd { prev = cs, pss;
                         curr = Apply e;
                       })

    | LeftEnd
      { curr = Move e;
        next = ns, nss
      } -> without_command
             (Middle { prev = [];
                       curr = ns, (Apply e);
                       next = nss
                     })
    | RightEnd
      { prev = ps, pss;
        curr = Move e
      } -> without_command
             (Middle { prev = pss;
                       curr = ps, (Apply e);
                       next = []
             })

   | Middle
      ({ curr = (Perform cmd), (Apply ((Call _) as e))
       } as o) -> with_command cmd
                    (Middle { o with
                         curr = (Perform cmd), (Move e)
                    })
   | Middle
      ({ curr = (Execute (proc, ews)), (Apply (Call e)) 
       } as o) -> let ew, ef = Energy.find e in
                  without_command
                    (Middle { o with
                         curr = (Execute (proc, (ew :: ews))), 
                                (Move (Find (ef, Forward, proc)))
                    })
   | Middle
      ({ curr = ((Declare _) as cs), (Apply (Call e)) 
       } as o) -> let ec = Energy.close e in
                  without_command
                    (Middle { o with
                         curr = cs, (Move (Close ec))
                    })
   | RightEnd
      ({ curr = Apply (Call e) 
       } as o) -> let ec = Energy.close e in
                  without_command
                    (RightEnd { o with
                         curr = Move (Close ec)
                    })

   | Middle
      ({ curr = (Declare (proc, eos)), 
                (Apply (Find (e, _, proc'))) 
       } as o) when proc = proc'
               -> let eo, ec = Energy.open' e in
                  without_command
                    (Middle { o with
                         curr = (Declare (proc, (eo :: eos))), 
                                (Move (Call ec))
                    })
   | LeftEnd
      ({ curr = Apply (Find (_, _, proc))
       }) -> Error (Procedure_not_found proc)

   | RightEnd
      ({ curr = Apply (Find (e, _, proc))
       } as o) -> without_command
                    (RightEnd { o with
                         curr = Move (Find (e, Back, proc))
                    })

   | Middle
      ({ curr = ((Declare (proc, (oe :: oes))) as cs), 
                (Apply (Close e)) 
       } as o) -> without_command
                    (match Energy.return oe e with
                     | None    ->
                        Middle { o with
                            curr = cs, (Move (Close e))
                          }
                     | Some er ->
                        Middle { o with
                            curr = (Declare (proc, oes)), 
                                   (Move (Return (er, Back)))
                          }
                    )

   | Middle
      ({ curr = ((Execute (proc, (ew :: ews))) as cs), 
                (Apply ((Return (e, _)) as er)) 
       } as o) -> without_command
                    (match Energy.done' ew e with
                     | None    ->
                        Middle { o with
                            curr = cs, (Move er)
                          }
                     | Some ec ->
                        Middle { o with
                            curr = (Execute (proc, ews)), 
                                   (Move (Call ec))
                          }
                    )

   | LeftEnd
      ({ curr = Apply (Return (e, _)) 
       } as o) -> without_command
                    (LeftEnd { o with
                          curr = Move (Return (e, Forward)) 
                    })

   | Middle
      ({ curr = cs, (Apply e) 
       } as o) -> without_command 
                    (Middle { o with
                         curr = cs, (Move e)
                    })
   | LeftEnd
      ({ curr = Apply e 
       } as o) -> without_command 
                    (LeftEnd { o with
                         curr = Move e
                    })
   | RightEnd
      ({ curr = Apply e 
       } as o) -> without_command 
                    (RightEnd { o with
                         curr = Move e
                    })

let step o =
  let rec step i o =
    match tick o with
    | Error _ as e                   -> e
    | Ok { command = None;   o = o } -> step (succ i) o
    | Ok { command = Some c; o = o } ->
      Ok { command = c; 
       ticks_count = i;
                 o 
    } in
  step 1 o
                
  end
