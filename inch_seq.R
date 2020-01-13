inch_seq = function(tot_len, piece_len){

    require(stringr)

    comp = str_match(piece_len, '([0-9]+) ([0-9]+)/([0-9]+)')[,2:4]
    comp = as.numeric(comp)

    if(any(is.na(comp))){
        stop('piece_len must be of the form "X X/X" where all X are integers')
    }

    s = seq(0, tot_len, comp[1] + (comp[2]/comp[3]))
    r = s %% 1 * comp[3]
    fract_inches = paste0(floor(s), ' ', r, '/', comp[3])

    return(fract_inches[-1])
}

inch_seq(36, '3 5/8')
inch_seq(36, '3 5/16')
