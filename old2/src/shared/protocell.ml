type nucleus_t = 
  { eyes_pigment : Pigment.t;
         pigment : Pigment.t;
            gaze : Side.t
  }

type cyto_t = 
  {   nucleus : nucleus_t;
    cytoplasm : Cytoplasm.t
  }

type cancer_t = 
  { gaze : Side.t 
  }

type cyto_cancer_t = 
  {   nucleus : cancer_t;
    cytoplasm : Cytoplasm.t
  }
                  
type clot_t = 
  { gaze : Side.t
  }

type t = | Nucleus of nucleus_t
         | Cyto of cyto_t
         | Cancer of cancer_t
         | CytoCancer of cyto_cancer_t
	 | Clot of clot_t
