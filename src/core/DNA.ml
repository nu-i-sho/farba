type t = {    kind : Gene.OfFlesh.Kind.t;
            spirit : RNA.t;
           program : Gene.OfFlesh.Command.t array;
         }

module Builder = struct
  type d = { accumulator : t 
           } 
  
  let make kind = 
    let accumulator = 
      {    kind;
         spirit = RNA.empty;
        program = [||]
      } 
    in
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

let kind_of x = x.kind
let spirit_of x = x.spirit
let program_of x = x.program
