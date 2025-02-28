#00_background review of BC literature summary
library(readxl)
library(fs)
library(dplyr)
library(tidyr)
library(stringr)

li <- read_excel(path("01_inputs", "CCN PDFs Each Term - UP TO DATE.xlsx"))

li <- li |> 
  select(c(`CCN SEARCH`, YEAR, AUTHOR, `TERRESTRIAL OR AQUATIC`,`TOOL 1` , `TOOL 2` , `TOOL 3` ,
              `TOOL 4` , `TOOL 5` , `TOOL 6` , `TOOL 7` ,
              `TOOL 8` , `TOOL 9` , `TOOL 10`))


unique(li$`CCN SEARCH`)

co <- li |> 
  #filter(`CCN SEARCH` == "Corridors") |> 
  select(c(`CCN SEARCH`, `TERRESTRIAL OR AQUATIC`,`TOOL 1` , `TOOL 2` , `TOOL 3` ,
              `TOOL 4` , `TOOL 5` , `TOOL 6` , `TOOL 7` ,
              `TOOL 8` , `TOOL 9` , `TOOL 10`)) |> 
  filter(!(`TOOL 1` %in% c("N/A",' ','NA'))) 

length(co$`CCN SEARCH`) #478

col <- co |>
  pivot_longer(cols = starts_with("TOOL"), names_to = "tool", values_to = "method") |>  
  filter(!(method %in% c("N/A",' ','NA', NA, ""," "))) 
  
length(col$`CCN SEARCH`) #831

# colm <- col |>
#   mutate(method1 = case_when(
#     str_detect(method, "ArcM*") ~ "GIS",
#     str_detect(method, "R *") ~ "R",
#     str_detect(method, "circuit *") ~ "circuit")
# )



summary_cor <- col |>
  group_by(method, `CCN SEARCH`) |>
  summarise(n = n()) |>
  arrange(desc(n))

write.csv(summary_cor, path("01_inputs", "lit_methods_summary_raw.csv"))

