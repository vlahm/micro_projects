library(macrosheds)
library(sf)
library(mapview)
mv <- mapview::mapview

sites <- macrosheds::ms_load_sites() %>%
    filter(! is.na(latitude)) %>%
    st_as_sf(coords=c('longitude', 'latitude'), crs = 4326)

native_lands <- st_read(dsn = '/home/mike/Downloads/native_american_lands/tl_2020_us_aiannh.shp') %>%
    st_transform(crs = 4326)
mv(native_lands) + mv(sites)
dd = sf::st_intersects(sites, native_lands)
lengths(dd)
