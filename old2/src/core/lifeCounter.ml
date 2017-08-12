module Cells = struct

    module Acts = struct
	type t = { replications : int;
	                  turns : int
		 }

	let zero = { replications = 0;
	                    turns = 0
		   }

	let summary o = 
	  o.replications + o.turns

	let inc_replications o = 
	  { o with replications = o.replications + 1}

	let inc_turns o = 
	  { o with turns = o.turns + 1 }
 
      end

    type t = {   acts : Acts.t; 
	         over : int;
                 lack : int;      
	         hels : int;
	       cancer : int;
                 clot : bool;
		  out : bool
	     }

    let zero = {   acts = Acts.zero;
                   over = 0;
                   lack = 0;      
	           hels = 0;
	         cancer = 0;
                   clot = false;
                    out = false
	       }

    let summary         o = o.hels + o.cancer
    let inc_tissue_over o = { o with over = o.over + 1 }
    let inc_tissue_lack o = { o with lack = o.lack + 1 }
    let inc_hels        o = { o with hels = o.hels + 1 }
    let inc_cancer      o = { o with cancer = o.cancer + 1 }
    let do_clot         o = { o with clot = true }
    let do_out          o = { o with out = true }

  end

module BreadcrumbsSteps = struct

    type t = {     runs : int;
                  finds : int;
                returns : int
	     } 

    let zero = {    runs = 0;
                   finds = 0;
                 returns = 0
	       }

    let summary     o = o.runs + o.finds + o.returns    
    let inc_runs    o = { o with runs = o.runs + 1 }
    let inc_finds   o = { o with finds = o.finds + 1 }
    let inc_returns o = { o with returns = o.returns + 1 }

  end

type t = { program_length : int;
             crumbs_steps : BreadcrumbsSteps.t;
		    cells : Cells.t
	 }

let zero =
  { program_length = 0;
      crumbs_steps = BreadcrumbsSteps.zero;
             cells = Cells.zero    
  }	       		       	      
	       		       	      
let inc_crumbs_steps_of_run o =
  let steps = BreadcrumbsSteps.inc_runs o.crumbs_steps in
  { o with crumbs_steps = steps }	       	
	       		       	      
let inc_crumbs_steps_of_find o = 
  let steps = BreadcrumbsSteps.inc_finds o.crumbs_steps in
  { o with crumbs_steps = steps }    
	       		       	      
let inc_crumbs_steps_of_return o =
  let steps = BreadcrumbsSteps.inc_returns o.crumbs_steps in
  { o with crumbs_steps = steps }

let inc_tissue_over_cells o = 
  { o with cells = Cells.inc_tissue_over o.cells }

let inc_tissue_lack_cells o = 
  { o with cells = Cells.inc_tissue_lack o.cells }

let inc_hels_cells o = 
  { o with cells = Cells.inc_hels o.cells }
  
let inc_cancer_cells o = 
 { o with cells = Cells.inc_cancer o.cells }

let do_clot o = 
  { o with cells = Cells.do_clot o.cells }

let do_out o = 
  { o with cells = Cells.do_out o.cells }

let inc_turns o = 
  let acts = Cells.Acts.inc_turns o.cells.acts in
  { o with cells = { o.cells with acts } }

let inc_replications o = 
  let acts = Cells.Acts.inc_replications o.cells.acts in
  { o with cells = { o.cells with acts } }
