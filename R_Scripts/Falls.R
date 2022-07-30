
# Falls ####
# definition of numerator: Emergency admissions for falls injuries classified by primary diagnosis code (ICD10 code S00 - T98), and external cause (W00 - W19) and an emergency admission code - Age at admission 65+.

# Create an emergency variable to highlight if an emergency admission.
# PHE method describes - emergency first finished  consultant episodes (episode number = 1 and admission method starts with 2.

# Primary Diagnosis Injury with a cause of Fall.

falls_codes <- data.frame(ICD_code = c("W00","W01","W02","W03","W04","W05","W06","W07","W08","W09","W10","W11","W12","W13","W14","W15","W16","W17","W18","W19"), 
                          definition = c("Fall on same level involving ice and snow", "Fall on same level from slipping, tripping and stumbling", "Fall involving ice-skates, skis, roller-skates or skateboards", "Other fall on same level due to collision with, or pushing by, another person", "Fall while being carried or supported by other persons", "Fall involving wheelchair", "Fall involving bed", "Fall involving chair", "Fall involving other furniture", "Fall involving playground equipment", "Fall on and from stairs and steps", "Fall on and from ladder", "Fall on and from scaffolding", "Fall from, out of or through building or structure", "Fall from tree", "Fall from cliff", "Diving or jumping into water causing injury other than drowning or submersion", "Other fall from one level to another", "Other fall on same level", "Unspecified fall"))
