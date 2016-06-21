module Cells : sig

    module Acts : sig

	type t = { replications : int;
	                  turns : int
		 }

	val zero             : t
	val summary          : t -> int
	val inc_replications : t -> t
	val inc_turns        : t -> t
 
      end

    type t = {   acts : Acts.t; 
	         over : int;
                 lack : int;      
	         hels : int;
	       cancer : int;
                 clot : bool;
		  out : bool
	     }

    val zero            : t
    val summary         : t -> int
    val inc_tissue_over : t -> t
    val inc_tissue_lack : t -> t
    val inc_hels        : t -> t
    val inc_cancer      : t -> t
    val do_clot		: t -> t
    val do_out		: t -> t

  end

module BreadcrumbsSteps : sig

    type t = {     runs : int;
                  finds : int;
                returns : int
	     } 

    val zero        : t
    val summary     : t -> int 
    val inc_runs    : t -> t 
    val inc_finds   : t -> t 
    val inc_returns : t -> t 

  end

type t = { program_length : int;
             crumbs_steps : BreadcrumbsSteps.t;
		    cells : Cells.t
	 }

val zero                        : t
val inc_crumbs_steps_of_run     : t -> t	    
val inc_crumbs_steps_of_find    : t -> t  
val inc_crumbs_steps_of_return  : t -> t
val inc_tissue_over_cells       : t -> t
val inc_tissue_lack_cells       : t -> t
val inc_hels_cells              : t -> t
val inc_cancer_cells            : t -> t
val do_clot                     : t -> t
val do_out                      : t -> t
val inc_turns                   : t -> t
val inc_replications            : t -> t
