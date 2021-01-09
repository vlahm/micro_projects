library(tidyverse)
library(plot.matrix)
library(plotrix)
library(utf8)

d = read_csv('~/git/chaz/openings_raw.csv',
             col_names = c('name', 'sequence', 'style'))

rgx_repeat = '(?:\\d\\.)?([a-zA-Z0-9]+)?\\s?([a-zA-Z0-9]+)?\\s?'
d = d %>%
    extract(col = sequence,
            into =  paste0(rep(1:4,
                               each = 2),
                           c('w', 'b')),
            regex = paste(rep(rgx_repeat, 4),
                          collapse = ''),
            remove = TRUE) %>%
    mutate(buffer = '',
           name = utf8_normalize(name,
                                 map_quote = TRUE)) %>%
    select(buffer, everything())

plot_chaz = function(d){

    D = d %>%
        mutate(across(3:10,
                      ~case_when(grepl('R', .) ~ 'green',
                                 grepl('B', .) ~ 'purple',
                                 grepl('N', .) ~ 'orange',
                                 grepl('K', .) ~ 'yellow',
                                 grepl('Q', .) ~ 'gray70',
                                 # grepl('x', .) ~ 'red',
                                TRUE ~ 'white'))) %>%
        mutate(name = 'black', style = 'black', buffer = 'black') %>%
        as.matrix()

    nopenings = nrow(d)
    ncols = ncol(d)

    plotrix::color2D.matplot(matrix(rep(1, nopenings * ncols),
                                    ncol = ncols),
                             cellcolors = D,
                             xlab = '',
                             ylab = '',
                             axes = FALSE,
                             xpd = NA)

    axis(3, at = seq(2, 8, 2) + 0.5, labels = seq(1, 7, 2))

    for(i in 1:nopenings){
        for(j in 2:ncols){

            txt = d[i, j]
            txtlen = nchar(txt)

            textcolor = ifelse(j %in% c(2, ncols), 'gray80', 'black')
            textsize = case_when(txtlen > 30 && txtlen <= 40 ~ 0.6,
                                 txtlen > 40 ~ 0.55,
                                 TRUE ~ 0.7)

            if(j == 2){
                text(txt,
                     y = nopenings - i + 0.5,
                     x = j - 2,
                     col = textcolor,
                     cex = textsize,
                     pos = 4,
                     offset = 0)
            } else {
                text(txt,
                     y = nopenings - i + 0.5,
                     x = j - 0.5,
                     col = textcolor,
                     cex = textsize)
            }
        }
    }
}

pdf('~/Dropbox/stuff_2/game_notes/chaz_openings.pdf',
    onefile = TRUE,
    width = 12,
    height = 12)
plot_chaz(d)
plot_chaz(arrange(d, name))
dev.off()
