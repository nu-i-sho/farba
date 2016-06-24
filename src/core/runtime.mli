module Make (Breadcrumbs : BREADCRUMBS.T)
                (Program : PROGRAM.T) 
                         : sig
    include RUNTIME.T

    val make : breadcrumbs : Breadcrumbs.t 
            ->     program : Program.t 
            -> t
  end
