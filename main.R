library(tercen)
library(dplyr)

ctx = tercenCtx()

do.unifsampling <- FALSE
do.downsampling <- TRUE

if(ctx$op.value('method') == "uniform") do.unifsampling <- TRUE
if(ctx$op.value('method') == "downsampling") do.downsampling <- TRUE

if(!ctx$op.value('seed') == "NULL") set.seed(as.integer(ctx$op.value('seed')))

if(do.unifsampling) {
  
  data.frame(
    .ci = seq(from=0, to=ctx$cschema$nRows - 1),
    sample = runif(ctx$cschema$nRows, 0.0, 100.0)
  ) %>%
    
    ctx$addNamespace() %>%
    ctx$save()
  
} else if(do.downsampling) {
  
  downSample <- function (.ci, group) {
    
    df <- data.frame(.ci, group = as.factor(group))
    
    minClass <- min(table(group))
    df$label <- 0
    
    df <- ddply(df, .(group), function(dat, n) {
      dat[sample(seq(along = dat$group),  n), "label"] <- 1
      return(dat)
    }, n = minClass)
    df$label <- ifelse(df$label == 1, "pass", "fail")
    
    return(df)
  }
  
  library(plyr)
  
  .ci <- c(ctx$select(".ci")[[1]])
  group <- c(as.factor(ctx$select(".colorLevels")[[1]]))
  group <- group[!duplicated(.ci)]
  .ci <- .ci[!duplicated(.ci)]
  df <- downSample(.ci, group)
  df %>%
    ctx$addNamespace() %>%
    ctx$save()
  
} else {
  stop("Wrong sampling method.")
}

