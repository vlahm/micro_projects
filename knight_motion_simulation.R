
get_newpos = function(pos, ord, sgns){

    rank = pos[1]
    file = pos[2]

    newrank = pos[1] + ord[1] * sgns[1]
    newfile = pos[2] + ord[2] * sgns[2]

    if(newrank < 1 || newrank > 8){
        newrank = pos[1] + ord[1] * sgns[1] * -1
    }
    if(newfile < 1 || newfile > 8){
        newfile = pos[2] + ord[2] * sgns[2] * -1
    }

    newpos = c(newrank, newfile)
    return(newpos)
}

simulate_knight_moves = function(nmoves, starting_rank=1, starting_file=1){

    visited = matrix(c(starting_rank, starting_file), nrow=1)

    for(i in 1:nmoves){

        position = visited[i,]
        ordr = sample(1:2, replace=FALSE)
        signs = sample(c(1, -1), replace=FALSE)

        newpos = get_newpos(position, ordr, signs)
        visited = rbind(visited, newpos)
    }

    m = matrix(0, nrow=8, ncol=8)

    for(r in 1:nrow(visited)){
        vr = visited[r, ]
        nvisits = m[vr[1], vr[2]]
        m[vr[1], vr[2]] = nvisits + 1
    }

    return(m)
}

simulate_knight_moves(4)
m = simulate_knight_moves(10000)
#why is 8-8 never reached?

plotrix::color2D.matplot(m, main='visit density', xlab='file', ylab='rank',
    show.legend=TRUE)

m_binary = m / m
m_binary[is.na(m_binary)] = 0

plotrix::color2D.matplot(m_binary, xlab='file', ylab='rank',)
legend('top', fill=c('white', 'black'), legend=c('visited', 'not'),
    inset=c(0,-0.2), xpd=TRUE, horiz=TRUE, bty='n')
