include TISSUE.T
val load : string -> t

module MakePrintable 
	 (Printer : Shared.PRINTER.T) : sig
    
    include TISSUE.T
    val load : string -> Printer.t -> t
 end
