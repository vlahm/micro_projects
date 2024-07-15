library(macrosheds)
library(sf)
library(mapview)
mv <- mapview::mapview

setwd('~/git/macrosheds/r_package/')

sites <- ms_load_sites() %>%
    filter(! is.na(latitude)) %>%
    st_as_sf(coords=c('longitude', 'latitude'), crs = 4326)

ms_root <- 'data/macrosheds/'

ms_download_core_data(ms_root, 'all')
watersheds = ms_load_spatial_product(ms_root, 'ws_boundary')

native_lands <- st_read(dsn = '/home/mike/Downloads/native_american_lands/tl_2020_us_aiannh.shp') %>%
    st_transform(crs = 4326)
mv(native_lands) + mv(sites) + mv(watersheds)
dd = sf::st_intersects(sites, native_lands)
dd = sf::st_intersects(watersheds, native_lands)
lengths(dd)
