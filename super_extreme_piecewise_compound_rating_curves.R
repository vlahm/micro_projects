control1 = function(h){

    a = 2
    b = 0.12
    c = 1.09

    Q = a * (h - b)^c

    return(Q)
}

control2 = function(h){

    a = 3.4
    b = 0.15
    c = 1.01

    Q = a * (h - b)^c

    return(Q)
}

control3 = function(h){

    a = 1.1
    b = 0.25
    c = 2.3

    Q = a * (h - b)^c

    return(Q)
}

control4 = function(h){

    a = 3.9
    b = 0.45
    c = 5.1

    Q = a * (h - b)^c

    return(Q)
}

controls = list('1' = control1,
                '2' = control2,
                '3' = control3,
                '4' = control4)

get_applicable_ranges = function(h){

    #define 4 ranges (this lets them overlap however you like)
    range_minima = c(0, 0, 15, 50)
    range_maxima = c(1, 10, 30, 100)

    if(h > max(range_maxima)){
        stop('h is too beefy')
    }

    #determine which ones m falls in (inclusive on lower bound here).
    #also see note at bottom about case_when
    applicable_ranges = which(h >= range_minima & h < range_maxima)

    return(applicable_ranges)
}

get_Q = function(h){

    rngs = get_applicable_ranges(h)

    Q_components = sapply(controls[rngs],
                          function(x) do.call(x,
                                              args = list(h = h)))

    # #equivalent to:
    # Q_components = c()
    # for(f in controls[rngs]){
    #     Q_components = c(Q_components,
    #                      do.call(f,
    #                              args = list(h = h)))
    # }

    Q = sum(Q_components)

    return(Q)
}

get_Q(0.5)

#also note: this construct is useful for compact conditionals
r = 5
dplyr::case_when(
    r > 0 && r <= 1 ~ 1,
    r > 1 && r <= 10 ~ c(1, 2),
    r > 10 && r <= 100 ~ 3,
    r > 100 ~ 4)
