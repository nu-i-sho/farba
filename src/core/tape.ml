open Common
open Utils

module Item = struct
    type t = { command : command;
                  args : command Dots.Map.t option;
                  loop : Dots.t option
             }

    let of_command c =
      { command = c;
           args = None;
           loop = None
      }
          
    let command o = o.command
    let args o = o.args
    let loop o = o.loop
  end
   
type t = Item.t list

let empty = []
let length = List.length
let commands = List.map Item.command

let select f o = 
  let unpack = function | i, (Some x) -> i, x 
  and some   = function | _, (Some _) -> true
                        | _,  None    -> false in                
  o |> List.map f
    |> List.mapi Pair.make 
    |> List.filter some
    |> List.map unpack 
    |> IntMap.of_bindings

let args  = select Item.args
let loops = select Item.loop

let partitioni i o =  
  let is_before x = (fst x) < i in 
  o |> List.mapi Pair.make
    |> List.partition is_before
    |> Pair.map (List.map snd)
  
let remove_item i o =
  let before, (_ :: after) = partitioni i o in  
  List.append before after
  
let insert_command c i o =
  let before, after = partitioni i o in
  List.append before ((Item.of_command c) :: after)

let change f i =
  let f j x = if j = i then (f x) else x in 
  List.mapi f
  
let set_command c =
  let f x = Item.{ x with command = c } in 
  change f
  
let set_loop l = 
  let f x = Item.{ x with loop = l } in 
  change f
  
let remove_loop = set_loop  None
let set_loop l  = set_loop (Some l)
         
let remove_arg param =
  let f x =
    let args' = match Item.args x with
                | None      -> None
                | Some args ->
                   let args = Dots.Map.remove param args in
                   if Dots.Map.is_empty args then
                     None else
                     Some args in
    Item.{ x with
           args = args'
         } in
  change f

let mem_arg i param o =
  Item.( match List.nth i o with
         | { args = Some args; _ } -> Dots.Map.mem param args
         | { args = None; _      } -> false
       )

let set_arg param command =
  let f x =
    let args' = Some (( match Item.args x with
                        | None      -> Dots.Map.empty
                        | Some args -> args
                      ) |> Dots.Map.set param command
                     ) in
    Item.{ x with
           args = args'
         } in
  change f      
