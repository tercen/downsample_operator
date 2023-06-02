# Downsample

##### Description

The `Downsample` allows one to downsample a dataset.

##### Usage

Input data|.
---|---
`column`        | numeric, observation IDs (events, ...)
`y axis`        | numeric, any measurement associated with the data of interest 
`colour`        | factor (optional), grouping factor for downsampling

Output data|.
---|---
`random_int`        | Random sequence of integers, per group
`random_perc`       | Cumulative percentage of the sequence of integers, per group

Settings|.
---|---
`seed`        |  Random seed


##### How to use the operator?

Downsampling is typically used to handle unbalanced sample sizes between group,
or to reduce the size of a dataset for performance improvement.

Note that the operator doesn't return a downsampled dataset but two sequences
of numbers that can be used as a filter in the next step:
- a sequence of integers randomly assigned to each observation, per group
- a sequence of percentages assigned to each observation, per group. This percentage is 
relative to the total number of observations in the smallest group.

Those two factors can be used in different ways.

__Filtering down to a given number of observations__

- You can use the "random_int" factor
as a filter in the next step. If you select values less or equal than 1000, this number
of observations will be kept per group provided that colors have been specified. If no color
has been specified, a random subset of 1000 observations will be filtered.

__Filtering down to a given percentage of observations__
- If you wish to __balance__ the dataset size among groups, apply a filter in the 
next data step with the "random_perc" factor, keeping values that are equal or less than 100.
- If you set this value to 50, you will have for each group a size corresponding to
50 __percent of the smallest group size__.
- If no color factor has been specified as part of the input data, using this filter
will simply __subsample__ the data to 50% of the __total observations__.


