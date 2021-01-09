#identify the first 100 emirps

is_prime = function(n){
    lim = n %/% 2
    prime = TRUE
    for(i in 2:lim){
        if(n %% i == 0) prime = FALSE
    }
    return(prime)
}

rev_char = function(s){
    s_rev = paste(rev(strsplit(s, '')[[1]]), collapse='')
    return(s_rev)
}

x = 13
emirps = c()
while(TRUE){
    if(is_prime(x) && is_prime(as.numeric(rev_char(as.character(x))))){
        emirps = append(emirps, x)
        n_emerps = length(emirps)
        print(n_emerps)
        if(n_emerps > 100) break
    }
    x = x + 2
}
