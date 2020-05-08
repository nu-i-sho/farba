module type COMMANDER = sig
  type t
  val perform : Action.t -> t -> t  
  end
                     
module Make (Commander : COMMANDER) = struct
  module ParameterAttachment = struct
    module ValuesStack = struct
      type t = Source.Args.e list
      end
                       
    type 'current_value t =
      Source.Loop.t *
      Source.Args.t *
      ValuesStack.t *
     'current_value
    end

  module Args = struct
    type t = Source.Args.t Switch.t option
    end
                             
  module Prev = struct
    open struct
      type 'parameter_attachment t =
        ((* | Perform   of ( Action.t * *)  Source.Loop.t           (* ) *),
         (* | Call      of ( Dots.t   * *) (wait * Loop.t * Args.t) (* ) *),
         (* | Parameter of ( Dots.t   * *) 'parameter_attachment    (* ) *),
         (* | Procedure of ( Dots.t   * *)  mark                    (* ) *)
        ) Statement.t
      and wait = Energy.Wait.t option
      and mark = Energy.Mark.t option
      end
      
    type nonrec t = unit t ParameterAttachment.t t
    end

  module Current = struct
    module Energy = struct
      type t =
        | Call of Energy.Call.t
        | Back of Energy.Back.t
        | Find of Energy.Find.t
      end

    open struct
      type 'parameter_attachment t = 
        ((* | Perform   of ( Action.t * *) (Energy.t * Loop.t)          (* ) *),
         (* | Call      of ( Dots.t   * *) (Energy.t * Loop.t * Args.t) (* ) *),
         (* | Parameter of ( Dots.t   * *) 'parameter_attachment        (* ) *),
         (* | Procedure of ( Dots.t   * *)  Energy.t                    (* ) *)
        ) Statement.t
      end
                  
    type nonrec t = Energy.t t ParameterAttachment.t t
    end
           
  module Next = struct
    open struct
      module S = Source
      type 'parameter_attachment t = 
        ((* | Perform   of ( Action.t * *)  S.Loop.t             (* ) *),
         (* | Call      of ( Dots.t   * *) (S.Loop.t * S.Args.t) (* ) *), 
         (* | Parameter of ( Dots.t   * *) 'parameter_attachment (* ) *),
         (* | Procedure of ( Dots.t   * *)  unit                 (* ) *)
        ) Statement.t
      end

    type nonrec t = unit t ParameterAttachment.t t
       
    let of_src =
      Statement.( function
        | (Perform _ | Call _ | Procedure _) as x -> x
        |  Parameter (name, (loop, args))         ->
           Parameter (name, (loop, args, [], (Parameter (name, ()))))
      )
    end

  type t =
    { commander : Commander.t;
           prev : Prev.t list;
        current : Current.t option;
           next : Next.t list
    }

  let make commander src =
    { commander;
           prev = [];
        current = None;
           next = List.map Next.of_src src
    }

  let performing_state_opt = function
    | Statement.Perform   x -> Some x
    | Statement.Procedure _
    | Statement.Call      _ -> None
    | Statement.Parameter x ->
       match x with
       | _,(_,_,_, (Statement.Perform   x)) -> Some x
       | _,(_,_,_, (Statement.Procedure _))
       | _,(_,_,_, (Statement.Call      _))
       | _,(_,_,_, (Statement.Parameter _)) -> None

  let performable_action_opt o =
    let opt_bind o f = Option.bind f o in
    let extract = function
        | x, ((Current.Energy.Call _), (Loop.Active _))
             -> Some x
        | _  -> None in
    o.current |> opt_bind performing_state_opt
              |> opt_bind extract
              |> ( function
                   | (Some _) as x -> x
                   |  None         ->
                       let extract (x, _) = Some x in
                       o.next |> List.hd_opt
                              |> opt_bind performing_state_opt
                              |> opt_bind extract
                 )
    
  let commander' o =
    ( match performable_action_opt o with
      | Some x -> Commander.perform x
      | None   -> Fun.id
    ) o.commander
    
  let next'    o = o.next
  let current' o = o.current
  let prev'    o = o.prev
    
  let step o =
    { commander = o |> commander';
           prev = o |> prev';
        current = o |> current';
           next = o |> next'
    }
    
(*
  type t =
    { commander : Commander.t;
           prev : Prev.t list;
        current : Current.t;
           next : Next.t list
    }

  let make commander src =
    { commander;
           prev = [];
        current = Current.origin;
           next = List.map Next.of_src src
    }

  let action = function
    | Command.Perform      x -> Some action
    | Command.Procedure    _
    | Command.Call         _ -> None
    | Command.Parameter    x ->
       match x.values with
       | Command.Perform   x -> Some action
       | Command.Procedure _
       | Command.Call      _
       | Command.Parameter _ -> None
    
  let commander' o =
    match o.current.energy with
    | Current.Energy.Call _ ->
       ( match o.current.statement with
         | Some {    loop = Some (Availability.Enabled (Loop.Active _));
                  command = cmd;
                  _
                }
         
      
    | {   current = Current.Energy.Call _;
        statement =
            Some {    loop = Some (Availability.Enabled (Loop.Active _));
                   command = ( Command.Perform action
                            | Command.Parameter
                                    { values = (Command.Perform action) :: _; _
                                    });
        _
      }
    | { current = {  energy = Current.Energy.Call _; _ });
           next = { command = ( Command.Perform action
                              | Command.Parameter
                                  { values = (Command.Perform action) :: _; _
                                  });
                    _
                  };
           _
      }
    
  let step o =
    { commander = o |> commander';
           prev = o |> prev';
        current = o |> current';
           next = o |> next'
    }
    
    let module Av = Availability in
    let open Statement in
    let open Param in
    match o with
    (* 1 *)
    | { current =
          {    energy = Current.Energy.Call _;
            statement =
              Some ({    loop = Some (Av.Enabled ((Loop.Active _) as loop));
                      command = ( Command.Perform action
                                | Command.Parameter
                                    { values = (Command.Perform action) :: _; _
                                    });
                      _
                    } as statement)
          };
        _
      } -> let commander = Commander.perform action o.commander 
           and loop      = Some (Av.Enabled (Loop.iter loop)) in
           let statement = Some { statement with loop } in
           let current   = { o.current with statement } in
           { o with
             commander;
             current
           }      
    (* 2 *)
    | { current = ({  energy = Current.Energy.Call _; _ });
           next = ({ command = ( Command.Perform action
                               | Command.Parameter
                                   { values = (Command.Perform action) :: _; _
                               });
                     _
                   } as next_statement) :: next;
           _ 
      } -> let commander = Commander.perform action o.commander
           and loop =
             match next_statement.loop with
             | None                 -> None
             | Some (Av.Disabled _) -> raise Impossible
             | Some (Av.Enabled  x) ->
                let x = Loop.make x in
                let x = Loop.iter x in
                Some (Av.Enabled x) in
      
           let statement = Some { next_statement with loop } in
           let current = { o.current with statement }
           and prev = 
             match o.current.statement with
             | None   -> o.prev 
             | Some x -> { statement = x;
                              energy = Prev.Energy.None
                         } :: o.prev in
           { commander;
             prev;
             current;
             next
           }
           
    (* 4 *) 
    | { current = ({  energy = Current.Energy.Call e; _ });
           next = ({ command = ( Command.Procedure _
                               | Command.Parameter { values = []; _ });
                     _
                   } as next_statement) :: next;
           _
      } -> let prev    =
             {    energy = Prev.Energy.None;
               statement = o.current.statement
             } :: o.prev;
           and current =
             {    energy = Current.Energy.Back (Energy.back e);
               statement = Some next_statement;
             } in
           { o with
             prev;
             current;
             next
           }
           
    (* 5 *) 
    | { current = ({    energy = Current.Energy.Call e;
                     statement = None });
           next = ({   command = ( Command.Procedure _
                                 | Command.Parameter { values = []; _ });
                     _
                   } as next_statement) :: next_tail;
           _
      } -> { o with prev = o.prev;
                 current = {    energy = Current.Energy.Back (Energy.back e);
                             statement = Some next_statement;
                           };
                    next = next_tail
           }

    | { current = ({  energy = Current.Energy.Call e; _ });
           next = ({ command = ( Command.Procedure _
                               | Command.Parameter { values = []; _ });
                        loop = next_loop;
                     _
                   } as next_statement) :: next_tail;
           _
      } -> let current_loop = 
           { o with prev = o.prev;
                 current = {    energy = Current.Energy.Back (Energy.back e);
                             statement = Some next_statement;
                           };
                    next = next_tail
           }
 *)                    
  end
