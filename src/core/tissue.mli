include TISSUE.T
val load : string -> t

module MakePrintable 
	 (Printer : TISSUE_PRINTER.T) : sig
    
    include TISSUE.T
    val load : string -> Printer.t -> t
 end
