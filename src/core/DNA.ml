type t = {   flesh : Gene.OfFlesh.t;
            spirit : RNA.t;
           program : Gene.OfProgram.t list;
         }

let flesh_of x = x.flesh
let spirit_of x = x.spirit
let program_of x = x.program


