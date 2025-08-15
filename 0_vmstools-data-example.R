library(tidyverse)
library(vmstools)
data(tacsat)
data(eflalo)

tacsat2 <- 
  tacsat |> 
  dplyr::mutate(SI_DATE = stringr::str_replace(SI_DATE, "1800", "1803"),
                SI_DATE = stringr::str_replace(SI_DATE, "1801", "1804"))
eflalo2 <-
  eflalo |>  
  dplyr::mutate(FT_DDAT = stringr::str_replace(FT_DDAT, "1800", "1803"),
                FT_DDAT = stringr::str_replace(FT_DDAT, "1801", "1804"),
                FT_LDAT = stringr::str_replace(FT_LDAT, "1800", "1803"),
                FT_LDAT = stringr::str_replace(FT_LDAT, "1801", "1804"),
                LE_CDAT = stringr::str_replace(LE_CDAT, "1800", "1803"),
                LE_CDAT = stringr::str_replace(LE_CDAT, "1801", "1804")) |> 
  dplyr::rename(LE_MET = LE_MET_level6)

yrs <- 1803:1804

for(y in seq_along(yrs)) {
  tacsat <- 
    tacsat2 |> 
    filter(stringr::str_detect(SI_DATE, as.character(yrs[y])))
  save(tacsat, file = paste0("Data/tacsat_", yrs[y], ".RData"))
  eflalo <- 
    eflalo2 |> 
    filter(stringr::str_detect(FT_DDAT, as.character(yrs[y])))
  save(eflalo, file = paste0("Data/eflalo_", yrs[y], ".RData"))
}
