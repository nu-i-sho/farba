let matrix = lazy
(*     012345678901234567890123456789012345678901234567890123*)
(*     0    |    1    |    2    |    3    |    4    |    5   *)
  ([| "         HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH         ";
(*01*)"        HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH        ";
(*02*)"      HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH      ";
(*03*)"     HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH     ";
(*04*)"    HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH    ";
(*05*)"   HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH   ";
(*06*)"  HHHHHHHHHHHH----HHHHHHHHHHHHHHHHHH----HHHHHHHHHHHH  ";
(*07*)"  HHHHHHHHHH--------HHHHHHHHHHHHHH--------HHHHHHHHHH  ";
(*08*)" HHHHHHHHHH----------HHHHHHHHHHHH----------HHHHHHHHHH ";
(*09*)"HHHHHHHHHHH----------HHHHHHHHHHHH----------HHHHHHHHHHH";
(*10*)"HHHHHHHHHH------------HHHHHHHHHH------------HHHHHHHHHH";
(*11*)"HHHHHHHHHH------------HHHHHHHHHH------------HHHHHHHHHH";
(*12*)"HHHHHHHHHH------------HHHHHHHHHH------------HHHHHHHHHH";
(*13*)"HHHHHHHHHH------------HHHHHHHHHH------------HHHHHHHHHH";
(*14*)"HHHHHHHHHHH----------HHHHHHHHHHHH----------HHHHHHHHHHH";
(*15*)"HHHHHHHHHHH----------HHHHHHHHHHHH----------HHHHHHHHHHH";
(*16*)"HHHHHHHHHHHH--------HHHHHHHHHHHHHH--------HHHHHHHHHHHH";
(*17*)"HHHHHHHHHHHHHH----HHHHHHHHHHHHHHHHHH----HHHHHHHHHHHHHH";
(*18*)"HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH";
(*19*)"HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH";
(*20*)"HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH";
(*21*)"HHHHHHHHHHHHHH----HHHHHHHHHHHHHHHHHH----HHHHHHHHHHHHHH";
(*22*)"HHHHHHHHHHHH--------HHHHHHHHHHHHHH--------HHHHHHHHHHHH";
(*23*)"HHHHHHHHHHH----------HHHHHHHHHHHH----------HHHHHHHHHHH";
(*24*)"HHHHHHHHHHH----------HHHHHHHHHHHH----------HHHHHHHHHHH";
(*25*)"HHHHHHHHHH------------HHHHHHHHHH------------HHHHHHHHHH";
(*26*)"HHHHHHHHHH------------HHHHHHHHHH------------HHHHHHHHHH";
(*27*)"HHHHHHHHHH------------HHHHHHHHHH------------HHHHHHHHHH";
(*28*)"HHHHHHHHHH------------HHHHHHHHHH------------HHHHHHHHHH";
(*29*)"HHHHHHHHHHH----------HHHHHHHHHHHH----------HHHHHHHHHHH";
(*30*)"HHHHHHHHHHH----------HHHHHHHHHHHH----------HHHHHHHHHHH";
(*31*)"HHHHHHHHHHHH--------HHHHHHHHHHHHHH--------HHHHHHHHHHHH";
(*32*)"HHHHHHHHHHHHHH----HHHHHHHHHHHHHHHHHH----HHHHHHHHHHHHHH";
(*33*)"HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH";
(*34*)"HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH";
(*35*)"HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH";
(*36*)"HHHHHHHHHHHHHH----HHHHHHHHHHHHHHHHHH----HHHHHHHHHHHHHH";
(*37*)"HHHHHHHHHHHH--------HHHHHHHHHHHHHH--------HHHHHHHHHHHH";
(*38*)"HHHHHHHHHHH----------HHHHHHHHHHHH----------HHHHHHHHHHH";
(*39*)"HHHHHHHHHHH----------HHHHHHHHHHHH----------HHHHHHHHHHH";
(*40*)"HHHHHHHHHH------------HHHHHHHHHH------------HHHHHHHHHH";
(*41*)"HHHHHHHHHH------------HHHHHHHHHH------------HHHHHHHHHH";
(*42*)"HHHHHHHHHH------------HHHHHHHHHH------------HHHHHHHHHH";
(*43*)"HHHHHHHHHH------------HHHHHHHHHH------------HHHHHHHHHH";
(*44*)"HHHHHHHHHHH----------HHHHHHHHHHHH----------HHHHHHHHHHH";
(*45*)" HHHHHHHHHH----------HHHHHHHHHHHH----------HHHHHHHHHH ";
(*46*)"  HHHHHHHHHH--------HHHHHHHHHHHHHH--------HHHHHHHHHH  ";
(*47*)"  HHHHHHHHHHHH----HHHHHHHHHHHHHHHHHH----HHHHHHHHHHHH  ";
(*48*)"   HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH   ";
(*49*)"    HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH    ";
(*50*)"     HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH     ";
(*51*)"      HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH      ";
(*52*)"        HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH        ";
(*53*)"         HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH         ";
  |])
