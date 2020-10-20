library(tercen)
library(plyr)
library(dplyr)

options("tercen.workflowId" = "d330322c43363eb4f9b27738ef0042b9")
options("tercen.stepId"     = "1ae42627-e9ce-4d9f-9797-8700adfd7718")

ctx = tercenCtx()

if(!is.null(ctx$op.value('seed')) && !ctx$op.value('seed') == "NULL") set.seed(as.integer(ctx$op.value('seed')))

min_n <- 0
if(!is.null(ctx$op.value('min_n'))) min_n <- as.numeric(ctx$op.value('min_n')) 

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
dups <- !duplicated(.ci)
group <- group[dups]
.ci <- .ci[dups]

df <- downSample(.ci, group)
df %>%
  ctx$addNamespace() %>%
  ctx$save()

