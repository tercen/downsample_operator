library(tercen)
library(tercenApi)
library(dplyr)
library(data.table)

ctx = tercenCtx()

seed <- ctx$op.value('seed', as.integer, 42)
if(seed > 0) set.seed(seed)

if(length(ctx$colors) == 0) {
  df <- ctx %>%
    select(.ci) %>% 
    mutate(.colorLevels = 0L) %>%
    as.data.table() %>%
    unique()
} else {
  df <- ctx %>%
    select(.ci, .colorLevels) %>%
    as.data.table() %>%
    unique()
}

setkey(df, .colorLevels)
df[, random_sequence := sample.int(.N, replace = FALSE), by = .colorLevels]

min_n <- df[, .N, by = .colorLevels][which.min(N), N]

df[, random_percentage := 100 * (random_sequence / min_n)]

df[, .colorLevels:=NULL]

df %>%
  as_tibble() %>%
  mutate(random_sequence = as.double(random_sequence)) %>%
  ctx$addNamespace() %>%
  ctx$save()
