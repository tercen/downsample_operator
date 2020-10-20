# Downsample operator

##### Description

The `Downsample` allows one to downsample the data.

##### Usage

Input projection|.
---|---
`column`        | numeric, input data, per cell 
`colour`        | factor, groups

Output relations|.
---|---
`label`        | character, `pass` or `fail`, per column

Parameters|.
---|---
`seed`        |  random seed
`min_n`        |  Minimal sample size for downsampling. For each category, the minimal value between the category sample size and `min_n` will be taken for downsampling. If `min_n` is lower than the minimal category sample size, it is set to be equal to the latter.

##### Details

A random subset of each group is assigned a `pass` value: the size of the subset is the same as the smallest group. This method is typically used to handle unbalanced sample sizes between group.

Note that the downsample operator doesn't return a downsampled dataset but a "pass/fail" `label` that can be used as a filter in the next step. To effectively downsample the data, one needs to add the returned `label` variable as a filter and set `label` equals `pass` (or exclude `fail` values). Then, only the downsampled data will be projected and used in the next steps.
