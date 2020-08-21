library(tercen)
library(dplyr)
library(plyr)

ctx = tercenCtx()

if(!ctx$op.value('seed') == "NULL") set.seed(as.integer(ctx$op.value('seed')))

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

.ci <- c(ctx$select(".ci")[[1]])
group <- c(as.factor(ctx$select(".colorLevels")[[1]]))
dups <- !duplicated(.ci)
group <- group[dups]
.ci <- .ci[dups]

df <- downSample(.ci, group)
df %>%
  ctx$addNamespace() %>%
  ctx$save()

