setwd('~/git/mine_locations/')
dir()
z = sf::st_read('mrds-trim.shp')
#currently explodes
mapview::mapview(z)
