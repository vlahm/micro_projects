require(sf)
shape <- read_sf(dsn = "~/Desktop/wildfire/", layer = "wf_all_1980_2016")
s2 = shape[shape$STATE == 'California',]
s2$STARTDATED
str(s2)
mindate = tapply(s2$STARTDATED, substr(s2$STARTDATED, 1, 4), min)
as.Date(mindate, origin='1970-01-01')
maxdate = tapply(s2$STARTDATED, substr(s2$STARTDATED, 1, 4), max)
as.Date(maxdate, origin='1970-01-01')
s2[substr(s2$STARTDATED, 6, 7) == '12','TOTALACRES']

par(mfrow=c(2,1))
size = tapply(s2$TOTALACRES, substr(s2$STARTDATED, 1, 4), max)
lm(
barplot(size, ylab='acres', xlab='year', font.lab=2, main='CA Fires')

quantity = tapply(s2$TOTALACRES, substr(s2$STARTDATED, 1, 4), sum)
barplot(quantity, ylab='# of fires', xlab='year', font.lab=2)

