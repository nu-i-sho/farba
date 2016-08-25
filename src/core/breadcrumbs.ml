open Data
   
type t = { crumbs : Crumb.t list;
             mode : RuntimeMode.t
         }

open Doubleable
open Crumb
       
let start =
  {   mode = RuntimeMode.RunNext;
    crumbs = [{ value = Single DotsOfDice.O;
                index = 0
             }]
  }

let top o =
  List.hd o.crumbs

let mode o =
  o.mode

let with_mode x o =
  { o with mode = x }

let move o =
  let crumbs = 
    match List.hd o.crumbs with

    | { value = Single a; index = i }
      -> { value = Single a;
           index = i + 1
         } :: (List.tl o.crumbs)
    
    | { value = Double (a, b); index = i }
      -> { value = Single b;
           index = i + 1
         } :: { value = Single a;
                index = i
              } :: (List.tl o.crumbs)
  in { o with crumbs }

let back o =
  let crumbs =
    match List.hd o.crumbs with
    
    | { value = Single a; index = i }
      -> { value = Single a;
           index = i - 1
         } :: (List.tl o.crumbs)
     
    | { value = Double (a, _); index = i }
      -> { value = Single a;
           index = i
         } :: (List.tl o.crumbs)
  in { o with crumbs }

let split o =
  let crumbs = 
    match List.hd o.crumbs with

    | { value = Single a; index = i }
      -> { value = Single (DotsOfDiceExt.increment a);
           index = i
         } :: o.crumbs

    | { value = Double _; _ }
      -> failwith Fail.cannot_split
  in { o with crumbs }
