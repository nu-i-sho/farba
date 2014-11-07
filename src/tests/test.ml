type 'state t = 
    { name : string;
      run  : 'state -> unit
    }
