library(tercen)
library(plyr)
library(dplyr)

ctx = tercenCtx()

seed <- ctx$op.value('seed', as.integer, -1)
if( seed > 0){
  set.seed(seed)
}


min_n <- ctx$op.value('min_n', as.double, 0)

downSample <- function (.ci, group, gt) {
  df <- data.frame(.ci, group = as.factor(group))  
  
  if(min_n > 0){
    minClass <- min(min_n, gt) 
  }else{
    minClass <- gt
  }
  
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
gt <- table(group)

# dups <- !duplicated(group)
# group <- group[dups]
# .ci <- .ci[dups]

df <- downSample(.ci, group, gt)

df %>%
  ctx$addNamespace() %>%
  ctx$save()

