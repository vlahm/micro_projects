# install.packages("NISTunits", dependencies = TRUE)
library(NISTunits)

cosplot = function(theta){
    tcos = cos(theta)
    segments(0, 0, tcos, 0, col='red')
    return(tcos)
}

sinplot = function(theta, cosine=cos_out){
    tsin = sin(theta)
    segments(cosine, 0, cosine, tsin, col='green')
}

hyplot = function(theta, cosine=cos_out){
    tsin = sin(theta)
    segments(0, 0, cosine, tsin, col='orange')
}

triplot = function(theta){

    plot(0,0, type='n', bty='l', xlab='x', ylab='y')
    abline(h=0, v=0, lty=2, col='gray30')
    xcirc = seq(-1, 1, length.out=1000)
    xcirc = c(xcirc, rev(xcirc))
    ycirc = sqrt(1 - xcirc^2)
    lines(xcirc, ycirc, col='blue')
    lines(xcirc, -ycirc, col='blue')

    cos_out = cosplot(theta)
    sinplot(theta, cosine=cos_out)
    hyplot(theta, cosine=cos_out)
}

triplot(NISTdegTOradian(0))
triplot(NISTdegTOradian(30))
triplot(NISTdegTOradian(60))
triplot(NISTdegTOradian(90))
triplot(NISTdegTOradian(120))
triplot(NISTdegTOradian(360))
