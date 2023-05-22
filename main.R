library(tercen)
library(plyr)
library(dplyr)


# http://127.0.0.1:5400/test/w/149395de86cec5641a6345ce78023e3b/ds/b01ca698-422d-482b-94ff-5cd33f922349
options("tercen.workflowId" = "149395de86cec5641a6345ce78023e3b")
options("tercen.stepId"     = "b01ca698-422d-482b-94ff-5cd33f922349")
ctx = tercenCtx()


seed <- ctx$op.value('seed', as.integer, -1)
if( seed > 0){
  set.seed(seed)
}
# if(!is.null(ctx$op.value('seed')) && !ctx$op.value('seed') == "NULL") set.seed(as.integer(ctx$op.value('seed')))

# min_n <- 0
min_n <- ctx$op.value('min_n', as.double, 0)
# if(!is.null(ctx$op.value('min_n'))) min_n <- as.numeric(ctx$op.value('min_n')) 

downSample <- function (.ci, group) {
  df <- data.frame(.ci, group = as.factor(group))  
  
  
  minClass <- max(min_n, min(table(group))) # if 0 (default) or lower than min samp size, get min samp size

  
  df$label <- 0
  
  df <- ddply(df, .(group), function(dat, n) {
    n_corrected <- min(length(dat$group), n) #if specified n > samp size, get samp size
    dat[sample(seq(along = dat$group),  n_corrected), "label"] <- 1
    return(dat)
  }, n = minClass)
  df$label <- ifelse(df$label == 1, "pass", "fail")
  
  return(df)
}

.ci <- c(ctx$select(".ci")[[1]])
group <- c(as.factor(ctx$select(".colorLevels")[[1]]))
# dups <- !duplicated(group)
# group <- group[dups]
# .ci <- .ci[dups]

df <- downSample(.ci, group)
print(df)
df %>%
  ctx$addNamespace() %>%
  ctx$save()

