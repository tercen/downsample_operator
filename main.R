library(tercen)
library(dplyr)

ctx = tercenCtx()

n <- ctx$op.value('n', as.double, 1000)
seed <- ctx$op.value('seed', as.integer, -1)
if(seed > 0) set.seed(seed)

if(length(ctx$colors) == 0) {
  df <- ctx %>%
    select(.ci) %>% 
    mutate(.colorLevels = 0L)
} else {
  df <- ctx %>%
    select(.ci, .colorLevels)
}

df2 <- df %>%
  unique() %>%
  group_by(.colorLevels) %>%
  mutate(random_int = as.double(sample(n())))

min_n <- df %>% summarise(ct = n()) %>% select(ct) %>% min()

df_out <- df2 %>%
  mutate(random_perc = 100 * (random_int / min_n))

df_out %>%
  select(-contains(".colorLevels")) %>%
  ctx$addNamespace() %>%
  ctx$save()
