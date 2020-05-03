library(tidyverse)

#this processing sequence uses lifelist_srs.csv, which was originally
#generated from "Life List.doc", Manual modifications have been made since then.

args = commandArgs(trailingOnly=TRUE)
# args = list(ll_path='~/Desktop/stuff_2/Databases/lifelist_srs.csv')

#get lifelist
ll = read.csv(args[1], stringsAsFactors=FALSE)

#get ebird data
message('Getting eBird data')
req = httr::GET(paste0('http://ebird.org/ws1.1/ref/taxa/ebird?cat=species,',
    'hybrid&fmt=json&locale=en_US'))
txt = httr::content(req, as="text")
ebrd = jsonlite::fromJSON(txt, simplifyDataFrame=TRUE, flatten=TRUE)

update_lifelist = function(){

    # lookup = readline('Enter common name as e.g. Adj-noun Adj-Noun (no quotes) > ')
    cat('Enter common name as e.g. Adj-noun Adj-Noun (no quotes) > ')
    lookup = readLines(con="stdin", 1)

    if(lookup %in% ll$comName){
        message('Yo, that shit is already in ur list:\n')
        print(ll[ll$comName == lookup, ])
        update_lifelist()
    }

    if(! lookup %in% ebrd$comName){
        message('Name not in eBird database as received.')
        update_lifelist()
    }

    cat('Enter location > ')
    location = readLines(con="stdin", 1)
    cat('Enter date as "YYYY-MM-DD" > ')
    date = readLines(con="stdin", 1)
    cat('Enter notes > ')
    notes = readLines(con="stdin", 1)

    newrow = data.frame(lookup=lookup, date=date, location=location,
        notes=notes, stringsAsFactors=FALSE)

    newrow = ebrd %>%
        select(sciName, comName, speciesCode, familyComName, familySciName) %>%
        # mutate_all(as.character) %>%
        filter(comName == lookup) %>%
        bind_cols(newrow) %>%
        select(-lookup)

    ll = bind_rows(newrow, ll) %>%
        arrange(familySciName, sciName) %>%
        select(comName, sciName, date, location, familySciName, familyComName,
            speciesCode, notes)

    write.csv(ll, args[1], row.names=FALSE)

    message('Success')
}

update_lifelist()

#correct hyphenated modifiers in common names in lifelist to X-x format
# ll$common_name = sub('\\-([A-Z])', '-\\L\\1', ll$common_name, perl=TRUE)

# ll = ebrd %>%
#     select(sciName, comName, speciesCode, familyComName, familySciName) %>%
#     right_join(ll, by=c('comName'='common_name')) %>%
#     arrange(familySciName, sciName) %>%
#     select(comName, sciName, date, location, familySciName, familyComName,
#         speciesCode, notes)

# write.csv('~/Desktop/stuff_2/Databases/lifelist_srs.csv', row.names=FALSE)
#
# any(is.na(ll$sciName))
# ll[which(is.na(qq$sciName)),]
