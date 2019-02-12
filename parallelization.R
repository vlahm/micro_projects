# workers = nodes = physical locations of processors, possibly containing multiple cores
# parallelization only advisable when you have relatively few iterations with heavy operations
#     within each one. tons of overhead otherwise

library(foreach)
library(doParallel)

#this determines how many cores are available on the machine,
#then saves one for basic operation
ncores <- detectCores() - 1

#if you're on windows, there's only one type of cluster that can be made
#it's called a socket cluster, and it's the default when you use
cl <- makeCluster(ncores)
registerDoParallel(cl)

#or it can be specified with
cl <- makeCluster(ncores, type='PSOCK')
registerDoParallel(cl)

#but on mac and linux, fork clusters are available, and they're more efficient
cl <- makeCluster(ncores, type='FORK')
registerDoParallel(cl)

#so if you want to optimize for multiple machines you can use
if(.Platform$OS.type == "windows"){
    cl <- makeCluster(ncores, type='PSOCK')
} else {
    cl <- makeCluster(ncores, type='FORK')
}
registerDoParallel(cl)

#standard usage:
out <- foreach(i=1:1000) %dopar% {
    do things
}
# %dopar% tells it to parallelize, as opposed to %do%, which tells it not to

#when your foreach loop is finished, you should use
stopCluster(cl)
#otherwise the cores you set aside will not be available to anyone else until you
#close your R session

#you can also specify the number of clusters within registerDoParallel
registerDoParallel(ncores)
#and it *may* take care of the PSOCK vs. FORK thing automatically (unclear).
#if you do it this way, you must instead stop your cluster with
stopImplicitCluster()

#you can nest foreach loops like so:
foreach(i=1:10) %:%
    foreach(j=20:30) %:%
        foreach(k=c('a','b','c')) %dopar% {
            stuff
        }

#and the last variable you generate within the loops will be the one that
#gets returned
out <- foreach(i=1:10) %dopar% {
    a <- i+1
    b <- a+i
    c <- b+a
}
#here, "c" would be the one that gets sent to "out"
#haven't figured out how to speficy which one to export
#but I know for sure this is NOT what the .export and .noexport
#arguments are for

#you can also combine your outputs neatly, with c(), cbind(), rbind(),
#*, +, etc., otherwise they'll emerge as a list
out <-
    foreach(i=1:10, .combine=rbind) %:%
        foreach(j=20:30, .combine=rbind) %:%
            foreach(k=c('a','b','c'), .combine=rbind) %dopar% {
                data.frame(i,j,k)
            }

#to combine output as a list of lists (without having it get nested), use .multicombine
out <- foreach(i=1:length(n), .combine=list, .multicombine=TRUE) %dopar% {
    turbofunction(i)
}

#finally, sometimes things get weird with your cluster, and you're not sure
#whether you've set cores aside, or what kind of cluster you've created
#or some other bollocks.  in that case, this function will remove all the
#hidden stuff created by 'foreach' and 'doParallel'.
#it was made by one of the authors of foreach, who for some reason decided
#it wouldn't be useful within the package

unregister <- function() {
    env <- foreach:::.foreachGlobals
    rm(list=ls(name=env), pos=env)
}
unregister()

#you can verify the current cluster state with:
getDoParRegistered() #see if you have workers registered (if not, NULL)
getDoParName() #see what kind
