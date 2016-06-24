type t = {     runs : int;
              finds : int;
            returns : int
	 } 

let zero = {    runs = 0;
               finds = 0;
             returns = 0
	   }

let summary o = o.runs + o.finds + o.returns
let runs    o = o.runs
let finds   o = o.finds
let returns o = o.returns
    
let increment_runs    o = { o with runs = o.runs + 1 }
let increment_finds   o = { o with finds = o.finds + 1 }
let increment_returns o = { o with returns = o.returns + 1 }
