type t = {   flesh : Gene.OfFlesh.t;
            spirit : RNA.t;
           program : Gene.OfProgram.t list;
         }

module Builder = struct
  type d = { accumulator : t 
           } 
  
  let make flesh_gene = 
    let accumulator = 
      {   flesh = flesh_gene;
         spirit = [];
        program = []
      } in
    { accumulator 
    }
  
  let with_spirit builder spirit = 
    { builder.accumulator with spirit
    }

  let with_program builder program =  
    { builder.accumulator with program
    }

  let result builder = 
    builder.accumulator
end

let flesh_of x = x.flesh
let spirit_of x = x.spirit
let program_of x = x.program


