library(tidyverse)

#this operates on the text of "Life List.doc", copied into a text file
#NOTE: additional manual formatting required running this script

z = readr::read_lines('~/Desktop/ll.txt')

rgx1 = '(.*?)\\((.*?)([0-9]+/[0-9]+/[0-9]+)\\)(.*)'
rgx2 = '(.*?)\\((.*?) . (.*)? ([0-9]+)\\)(.*)'
rgx3 = '(.*?)\\(\\s?\\)'
rgx_common = "\\s*[0-9]*\\.?\\s*([A-Za-z \\-\\'’]+?)\\s?$"
rgx_loc = '([A-Za-z ,’]+?) ?[–\\-]? ?$'
rgx_date = '(.*?)\\s?$'

# fullbool = grepl('(.*?)\\((.*?)([0-9]+)/([0-9]+)/([0-9]+)\\)', z)
form1_bool = grepl(rgx1, z)
form1 = z[form1_bool]
z = z[! form1_bool]

form2_bool = grepl(rgx2, z)
form2 = z[form2_bool]
z = z[! form2_bool]

form3_bool = grepl(rgx3, z)
form3 = z[form3_bool]

formx = z[! form3_bool]

#recast

reformat1 = as_tibble(str_match(form1, rgx1)) %>%
    select(-V1) %>%
    rename(common_name=V2, location=V3, date=V4, notes=V5) %>%
    mutate(
        common_name=str_match(common_name, rgx_common)[, 2],
        common_name=gsub('’', "'", common_name),
        location=str_match(location, rgx_loc)[, 2],
        location=gsub('’', "'", location),
        date=str_match(date, rgx_date)[, 2],
        date=as.Date(strptime(date, '%m/%d/%y')),
        species=NA, family=NA) %>%
    select(common_name, species, family, date, location, notes)

reformat2 = as_tibble(str_match(form2, rgx2)) %>%
    select(-V1) %>%
    rename(common_name=V2, location=V3, notes=V6) %>%
    mutate(
        common_name=str_match(common_name, rgx_common)[, 2],
        common_name=gsub('’', "'", common_name),
        location=str_match(location, rgx_loc)[, 2],
        location=gsub('’', "'", location),
        date=NA, species=NA, family=NA) %>%
    select(common_name, species, family, date, location, notes)

reformat3 = as_tibble(str_match(form3, rgx3)) %>%
    select(-V1) %>%
    rename(common_name=V2) %>%
    mutate(
        common_name=str_match(common_name, rgx_common)[, 2],
        common_name=gsub('’', "'", common_name),
        notes=NA, location=NA, date=NA, species=NA, family=NA) %>%
    select(common_name, species, family, date, location, notes)

reformatx = tibble(common_name=str_match(formx, rgx_common)[, 2]) %>%
    filter(! is.na(common_name)) %>%
    mutate(common_name=gsub('’', "'", common_name),
        notes=NA, location=NA, date=NA, species=NA, family=NA) %>%
    select(common_name, species, family, date, location, notes)

lifelist = bind_rows(reformat1, reformat2, reformat3, reformatx) %>%
    arrange(common_name)

write_csv(lifelist, '~/Desktop/stuff_2/Databases/lifelist_srs.csv')

