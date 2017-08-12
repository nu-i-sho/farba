module type T = sig
    type focus_line_t
    type focus_active_line_t

    include SNAKED_PROGRAM.T
          
    val height            : t -> int
    val focus_line        : int -> t -> focus_line_t
    val maybe_focus_line  : int -> t -> focus_line_t option 
    val active_focus_line : t -> active_focus_line_t
  end
