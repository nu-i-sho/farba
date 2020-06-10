module type OBSERVER = sig
  type event
  type t

  val send : event -> t -> t
end

module type OBSERVABLE = sig
  type event
  type 'a subscr
  type t

  module type OBSERVER = OBSERVER with type event = event
  val subscribe : (module OBSERVER  with type t = 'a) -> 
    'a -> t -> 'a subscr * t
  val unsubscribe : 'a subscr -> t -> 'a * t
end

module type SUBJECT = sig
  include OBSERVER
  include OBSERVABLE 
    with type event := event
     and type t := t
end

module Subject = struct
  module Make (Event : sig type t end) : sig
    include SUBJECT with type event = Event.t 
    val empty : t
  end = struct
    type event = Event.t
    module type OBSERVER = 
      OBSERVER with type event = event
               
    module Observers = struct
      type _ registry = .. 
      module type E = sig
        include OBSERVER
        type _ registry += Observer : t registry
      end
      
      let registered_E (type a) (module Obs : OBSERVER with type t = a) =
        (module struct
          include Obs
          type _ registry += Observer : t registry
        end : E with type t = a)
      
          (* type zero_e *)
      type 'a e = Observer : {
          i : int; 
          m : (module E with type t = 'a);
          o : 'a 
        } -> 'a e 
  
      type ('a, 'b) equal = Equal : ('a, 'a) equal    
      
      let equel : type a b. 
        (module E with type t = a) -> 
        (module E with type t = b) -> 
        (a, b) equal option =
        
        fun (module X) (module Y) -> 
          match X.Observer with
          | Y.Observer -> Some Equal
          | _          -> None 
  
      type e_pack = Pack : 'a e -> e_pack
      type t = e_pack list
            
      (*
            
      type _ t = 
        | Nil  : zero_e t
        | Cons : 'head e * 'tail t -> ('head e * 'tail) t *)

      let empty = []      

      let add (type a) 
          id (module Obs : OBSERVER with type t = a) init o =
        let head = Observer {
            i = id;
            m = registered_E (module Obs);
            o = init
          } in 
        head, (Pack head) :: o
        
      let rec remove : type a. a e -> t -> a * t = 
        fun ((Observer x) as obs) -> function 
          | (Pack (Observer h)) :: t when h.i = x.i ->
              ( match equel x.m h.m with
                | Some Equal -> h.o, t
                | None       -> assert false
              )
          | h :: t ->
              let state, t = remove obs t in
              state, h :: t 
          | [] -> raise Not_found
  
      let rec send event = function
        | (Pack (Observer h)) :: t ->
            let (module Obs) = h.m in
            (Pack (Observer {
                 h with
                 o = Obs.send event h.o
               })) :: (send event t)
        | [] -> []
    end
    
    type 'a subscr = 'a Observers.e 
    type t = 
      { next_id : int;
        observers : Observers.t
      }

    let empty = 
      { next_id = 0;
        observers = Observers.empty
      }

    let subscribe (type a)
        (module Obs : OBSERVER with type t = a) init o =
      let subscription, observers = 
        Observers.add o.next_id (module Obs) init o.observers in
      subscription,
      { next_id = succ o.next_id;
        observers
      }

    let unsubscribe subscription o =
      let removed, observers = 
        Observers.remove subscription o.observers in
      removed, { o with observers }
    
    let send event o =
      { o with 
        observers = Observers.send event o.observers
      }
  end
end 

module Acc : sig 
  type t
  val zero : t
  val add : int -> t -> t
  val multiply : int -> t -> t
  val value : t -> int
end = struct
  type t = int
  let zero = 0
  let add x o = o + x
  let multiply x o = o * x
  let value o = o
end

module OAcc : sig 
  type event = Add of int | Multiply of int
  
  include module type of Acc 
  include OBSERVABLE with type event := event
                      and type t := t 
end = struct
  type event = Add of int | Multiply of int
        
  module Subject = Subject.Make (struct type t = event end)
  module type OBSERVER = Subject.OBSERVER
                           
  type 'a subscr = 'a Subject.subscr
  type t = 
    { subject : Subject.t;
      acc : Acc.t
    }
  
  let zero = 
    { subject = Subject.empty;
      acc = Acc.zero
    }
    
  let add x o = 
    { subject = Subject.send (Add x) o.subject;
      acc = Acc.add x o.acc
    }
    
  let multiply x o = 
    { subject = Subject.send (Multiply x) o.subject;
      acc = Acc.multiply x o.acc
    }
    
  let value o = Acc.value o.acc
      
  let subscribe (type t) (module Obs : Subject.OBSERVER with type t = t) init o =
    let subscription, subject = 
      Subject.subscribe (module Obs) init o.subject in
    subscription, { o with subject }
                  
  let unsubscribe subscription o =
    let state, subject = 
      Subject.unsubscribe subscription o.subject in
    state, { o with subject } 
end 

module Printer : sig 
  include OAcc.OBSERVER
  val make : string -> t
end = struct
  type event = OAcc.event
  type t = string
  let make prefix = prefix
  let send event o = 
    let () = 
      [ o;
        ( match event with
          | OAcc.Add      x -> "Add("      ^ (string_of_int x) 
          | OAcc.Multiply x -> "Multiply(" ^ (string_of_int x)
        );
        ");\n"
      ] |> String.concat ""
      |> print_string in
    o
end

module History : sig 
  include OAcc.OBSERVER
  val empty : t
  val to_list : t -> event list
end = struct
  type event = OAcc.event
  type t = event list
  let empty = []
  let send event o = event :: o
  let to_list = List.rev
end

let print_operations () =
  let p = (module Printer : OAcc.OBSERVER with type t = Printer.t) in 
  let acc = OAcc.zero in
  let s1, acc = acc |> OAcc.subscribe p (Printer.make "1.") in 
  let s2, acc = acc |> OAcc.subscribe p (Printer.make "2.") in 
  let s3, acc = acc |> OAcc.subscribe p (Printer.make "3.") in
  acc |> OAcc.add 1
  |> OAcc.multiply 2
  |> OAcc.unsubscribe s2 
  |> snd
  |> OAcc.multiply 3
  |> OAcc.add 4 
  |> OAcc.unsubscribe s3
  |> snd
  |> OAcc.add 5
  |> OAcc.unsubscribe s1
  |> snd
  |> OAcc.multiply 6
  |> OAcc.value
  
let history_of_operations () = 
  let h = (module History : OAcc.OBSERVER with type t = History.t) in 
  let acc = OAcc.zero in
  let s, acc = acc |> OAcc.subscribe h History.empty in
  let (history : History.t), _ = 
    acc |> OAcc.add 1
    |> OAcc.multiply 2 
    |> OAcc.add 7 
    |> OAcc.unsubscribe s in
  History.to_list history
