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
`label`        | character, `pass` or `fail`

Parameters|.
---|---
`seed`        |  random seed

##### Details

A random subset of each group is assigned a `pass` value: the size of the subset is the same as the smallest group. This method is typically used to handle unbalanced sample sizes between group.



