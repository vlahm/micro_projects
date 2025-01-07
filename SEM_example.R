library(lavaan)
library(semPlot)
library(dplyr)
library(moments)
# install.packages('lme4') #might need to reinstall this

setwd("~/git/streampulse/other_projects/big_stats_paper")

data <- read.csv("output/final/turbofinal/streampulse_synthesis_statset.csv") %>%
    as_tibble()

data$NPP_ann_sum <- data$GPP_ann_sum + data$ER_ann_sum

#transform GPP, log
data$log_ann_gpp<-log(data$GPP_ann_sum)
hist(data$GPP_ann_sum)

hist(data$log_ann_gpp)

##transform Disch_ar1, logist
hist(data$Disch_ar1)

data$logit_Disch_ar1<- log(data$Disch_ar1 / (1-data$Disch_ar1))
hist(data$logit_Disch_ar1)

##Based on charles recommedation we have stopped using this transform

plot(data$logit_Disch_ar1,data$log_ann_gpp)

##Modis NPP
hist(data$NPP_ann_sum)

hist(log(data$NPP_ann_sum)) ##logging skews it

plot(data$NPP_ann_sum,data$log_ann_gpp)

data$MOD_ann_NPP_scale<- data$NPP_ann_sum/1000 #rescale

##PAR
hist(data$Stream_PAR_sum) #no log transform here, skews worse

plot (data$Stream_PAR_sum, data$log_ann_gpp)

plot (data$Stream_PAR_sum, data$NPP_ann_sum)

plot (data$Stream_PAR_sum, data$NPP_ann_sum)

##watershed area
hist(data$area_km)

hist(log(data$area_km))  ##log transorm these data

data$log_area<-log(data$area_km)



##########################
#width NOTICE: WIDTH AND Q MISSING IN THIS DATASET; FABRICATING IT HERE
##########################

data$width <- rnorm(nrow(data), 3, 1)
hist(data$width)
data$logwidth<- log(data$width)
hist(data$logwidth)
data[data$width<0.5,]

data$log_area <- log(data$area_km)

n <- nrow(data)
t <- seq(0,4*pi,,n)
c.norm <- rnorm(n)
amp <- 2

# y1 <- a*sin(b*t)+c.unif*amp # uniform error
data$discharge <- 10*sin(3*t)+c.norm*amp
plot(data$discharge)

window_size <- 7
# Compute rolling mean, standard deviation, and CV
data <- data %>%
    mutate(
        rolling_mean = zoo::rollmean(discharge, window_size, fill = NA, align = "center"),
        rolling_sd = zoo::rollapply(discharge, window_size, sd, fill = NA, align = "center"),
        Disch_cv = rolling_sd / rolling_mean
    )

data$Disch_amp <- mean(range(data$discharge))
# data$Disch_ar1 <- acf(data$discharge, lag.max = 1)$acf[2]
data$Disch_skew <- moments::skewness(data$discharge)



##now for more Q data

#hist(data$Disch_cv)#looks good



##make a small dataframe for the SEM fit

data.sem<-data.frame(
    gpp=log(data$GPP_ann_sum),
    PAR=data$Stream_PAR_sum,
    mod_npp=scale(data$NPP_ann_sum), #was modeled npp (and somewhere else modeled gpp was in use)
    logwidth=data$logwidth,
    qcv=data$Disch_cv,
    qamp=data$Disch_amp,
    ar1=data$Disch_ar1, #note untransformed
    skew=data$Disch_skew,
    area=data$log_area)

#SEM modeling
'Where are we?

    After a lot of consideration and feedback in the form of a 2 h coding zoom meeting with Charles and Lauren,
we have decided to scrap the latent variable model, which we describe at the end of the document and go with
an observed variables model. Thus light is Phils integrated estimates of PAR hitting the stream and Q
variability is some measure of how variable Q is. Cut to the chase: we do not believe that AR(1) is that
measure. Skewness is.
Observed variables SEM model

Here is an observed variable model. To keep with the theme of the paper the observed variables are light (modeled light, a nice integrated measure), some aspect of Q variability, we will show a few of these. NPP is in the model since that is in our hypothesis. In fact NPP lowers the model fit just a bit, but that is ok.
The observed variable SEM model'

##############################
#####switch to html for commentary and sketches.
#####only code from here on
##############################

# Model with CV of Q

gpp_model_qcv <- ' # regressions
gpp ~ PAR + qcv
PAR ~ area + mod_npp
qcv ~ area+ mod_npp

'
##end of model

sem.fit <- sem(gpp_model_qcv, data=data.sem)
summary(sem.fit, standardize=T, rsq=T)

semPaths(sem.fit, what='std', nCharNodes=6, sizeMan=10,
         edge.label.cex=1.25, curvePivot = TRUE, fade=FALSE)

# Model with skewness of Q

gpp_model_skew <- ' # regressions
  gpp ~ PAR + skew
PAR ~ area + mod_npp
skew ~ area+ mod_npp

'
##end of model

sem.fit <- sem(gpp_model_skew, data=data.sem)
summary(sem.fit, standardize=T, rsq=T)
semPaths(sem.fit, what='std', nCharNodes=6, sizeMan=10,
         edge.label.cex=1.25, curvePivot = TRUE, fade=FALSE)

## see also: "former attempt using latent variables" in the html
