library(XML)
library(mapview)
library(sf)

total_gain <- function(path){

    gpx_parsed <- htmlTreeParse(file = path, useInternalNodes = TRUE)

    coords <- xpathSApply(doc = gpx_parsed, path = "//trkpt", fun = xmlAttrs)
    elevation <- xpathSApply(doc = gpx_parsed, path = "//trkpt/ele", fun = xmlValue)

    elevation <- as.numeric(elevation) * 3.28084 # m to ft

    gpx_data <- data.frame(
        lat = as.numeric(coords["lat", ]),
        lon = as.numeric(coords["lon", ]),
        elevation = elevation
    )

    gpx_sf <- st_as_sf(gpx_data, coords = c("lon", "lat"), crs = 4326)

    mapviewOptions(basemaps = 'OpenTopoMap')
    print(mapview(gpx_sf, lwd = 0, cex = 1))

    elev_change <- diff(gpx_data$elevation)
    total_gain <- sum(elev_change[elev_change > 0])

    return(total_gain)
}

total_gain('~/Dropbox/stuff_2/data_and_ideas/gps_tracks/scenic_point_ridgewalk.gpx') #6802
total_gain('~/Dropbox/stuff_2/data_and_ideas/gps_tracks/holland_peak_loop.gpx') #12411



