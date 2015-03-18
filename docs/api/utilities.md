



# AbstractDataFrame




## names!

Set column names


```julia
names!(df::AbstractDataFrame, vals)
```

### Arguments

* `df` : the AbstractDataFrame
* `vals` : column names, normally a Vector{Symbol} the same length as
  the number of columns in `df`

### Result

* `::AbstractDataFrame` : the updated result


### Examples

```julia
df = DataFrame(i = 1:10, x = rand(10), y = rand(["a", "b", "c"], 10))
names!(df, [:a, :b, :c])
```


[DataFrames/src/abstractdataframe/abstractdataframe.jl:127](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L127)



## rename!

Rename columns

```julia
rename!(df::AbstractDataFrame, from::Symbol, to::Symbol)
rename!(df::AbstractDataFrame, d::Associative)
rename!(f::Function, df::AbstractDataFrame)
rename(df::AbstractDataFrame, from::Symbol, to::Symbol)
rename(f::Function, df::AbstractDataFrame)
```

### Arguments

* `df` : the AbstractDataFrame
* `d` : an Associative type that maps the original name to a new name
* `f` : a function that has original column names as input and new
  column names as output

### Result

* `::AbstractDataFrame` : the updated result

### Examples

```julia
df = DataFrame(i = 1:10, x = rand(10), y = rand(["a", "b", "c"], 10))
index.jl:40:@test rename(i, @compat(Dict(:a=>:A, :b=>:B))) == Index([:A,:B])
rename!(df, :y, :z)
```


[DataFrames/src/abstractdataframe/abstractdataframe.jl:163](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L163)



## rename

Rename columns

```julia
rename!(df::AbstractDataFrame, from::Symbol, to::Symbol)
rename!(df::AbstractDataFrame, d::Associative)
rename!(f::Function, df::AbstractDataFrame)
rename(df::AbstractDataFrame, from::Symbol, to::Symbol)
rename(f::Function, df::AbstractDataFrame)
```

### Arguments

* `df` : the AbstractDataFrame
* `d` : an Associative type that maps the original name to a new name
* `f` : a function that has original column names as input and new
  column names as output

### Result

* `::AbstractDataFrame` : the updated result

### Examples

```julia
df = DataFrame(i = 1:10, x = rand(10), y = rand(["a", "b", "c"], 10))
index.jl:40:@test rename(i, @compat(Dict(:a=>:A, :b=>:B))) == Index([:A,:B])
rename!(df, :y, :z)
```


[DataFrames/src/abstractdataframe/abstractdataframe.jl:163](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L163)



## eltypes

Column elemental types

```julia
eltypes(df::AbstractDataFrame)
```

### Arguments

* `df` : the AbstractDataFrame

### Result

* `::Vector{Type}` : the elemental type of each column

### Examples

```julia
df = DataFrame(i = 1:10, x = rand(10), y = rand(["a", "b", "c"], 10))
eltypes(df)
```


[DataFrames/src/abstractdataframe/abstractdataframe.jl:197](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L197)



## tail

Show the first or last part of an AbstractDataFrame

```julia
head(df::AbstractDataFrame, r::Int = 6)
tail(df::AbstractDataFrame, r::Int = 6)
```

### Arguments

* `df` : the AbstractDataFrame
* `r` : the number of rows to show

### Result

* `::AbstractDataFrame` : the first or last part of `df`

### Examples

```julia
df = DataFrame(i = 1:10, x = rand(10), y = rand(["a", "b", "c"], 10))
head(df)
tail(df)
```


[DataFrames/src/abstractdataframe/abstractdataframe.jl:310](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L310)



## head

Show the first or last part of an AbstractDataFrame

```julia
head(df::AbstractDataFrame, r::Int = 6)
tail(df::AbstractDataFrame, r::Int = 6)
```

### Arguments

* `df` : the AbstractDataFrame
* `r` : the number of rows to show

### Result

* `::AbstractDataFrame` : the first or last part of `df`

### Examples

```julia
df = DataFrame(i = 1:10, x = rand(10), y = rand(["a", "b", "c"], 10))
head(df)
tail(df)
```


[DataFrames/src/abstractdataframe/abstractdataframe.jl:310](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L310)



## dump

Show the structure of an AbstractDataFrame, in a tree-like format

```julia
dump(df::AbstractDataFrame, n::Int = 5)
dump(io::IO, df::AbstractDataFrame, n::Int = 5)
```

### Arguments

* `df` : the AbstractDataFrame
* `n` : the number of levels to show
* `io` : optional output descriptor

### Result

* nothing

### Examples

```julia
df = DataFrame(i = 1:10, x = rand(10), y = rand(["a", "b", "c"], 10))
str(df)
```


[DataFrames/src/abstractdataframe/abstractdataframe.jl:344](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L344)



## describe

Summarize the columns of an AbstractDataFrame

```julia
describe(df::AbstractDataFrame)
describe(io, df::AbstractDataFrame)
```

### Arguments

* `df` : the AbstractDataFrame
* `io` : optional output descriptor

### Result

* nothing

### Details

If the column's base type derives from Number, compute the minimum, first
quantile, median, mean, third quantile, and maximum. NA's are filtered and
reported separately.

For boolean columns, report trues, falses, and NAs.

For other types, show column characteristics and number of NAs.

### Examples

```julia
df = DataFrame(i = 1:10, x = rand(10), y = rand(["a", "b", "c"], 10))
describe(df)
```


[DataFrames/src/abstractdataframe/abstractdataframe.jl:395](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L395)



## complete_cases

Indexes of complete cases (rows without NA's)

```julia
complete_cases(df::AbstractDataFrame)
```

### Arguments

* `df` : the AbstractDataFrame

### Result

* `::Vector{Bool}` : indexes of complete cases

See also `complete_cases!`.

### Examples

```julia
df = DataFrame(i = 1:10, x = rand(10), y = rand(["a", "b", "c"], 10))
df[[1,4,5], :x] = NA
df[[9,10], :y] = NA
complete_cases(df)
```


[DataFrames/src/abstractdataframe/abstractdataframe.jl:465](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L465)



## complete_cases!

Delete rows with NA's.

```julia
complete_cases!(df::AbstractDataFrame)
```

### Arguments

* `df` : the AbstractDataFrame

### Result

* `::AbstractDataFrame` : the updated version

See also `complete_cases`.

### Examples

```julia
df = DataFrame(i = 1:10, x = rand(10), y = rand(["a", "b", "c"], 10))
df[[1,4,5], :x] = NA
df[[9,10], :y] = NA
complete_cases!(df)
```


[DataFrames/src/abstractdataframe/abstractdataframe.jl:501](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L501)



## nonunique

Indexes of complete cases (rows without NA's)

```julia
nonunique(df::AbstractDataFrame)
```

### Arguments

* `df` : the AbstractDataFrame

### Result

* `::Vector{Bool}` : indicates whether the row is a duplicate of a
  prior row

See also `unique` and `unique!`.

### Examples

```julia
df = DataFrame(i = 1:10, x = rand(10), y = rand(["a", "b", "c"], 10))
df = vcat(df, df)
nonunique(df)
```


[DataFrames/src/abstractdataframe/abstractdataframe.jl:555](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L555)



## unique!

Delete duplicate rows

```julia
unique(df::AbstractDataFrame)
unique!(df::AbstractDataFrame)
```

### Arguments

* `df` : the AbstractDataFrame

### Result

* `::AbstractDataFrame` : the updated version

See also `nonunique` and `unique`.

### Examples

```julia
df = DataFrame(i = 1:10, x = rand(10), y = rand(["a", "b", "c"], 10))
df = vcat(df, df)
unique(df)   # doesn't modify df
unique!(df)  # modifies df
```


[DataFrames/src/abstractdataframe/abstractdataframe.jl:598](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L598)



## unique

Delete duplicate rows

```julia
unique(df::AbstractDataFrame)
unique!(df::AbstractDataFrame)
```

### Arguments

* `df` : the AbstractDataFrame

### Result

* `::AbstractDataFrame` : the updated version

See also `nonunique` and `unique`.

### Examples

```julia
df = DataFrame(i = 1:10, x = rand(10), y = rand(["a", "b", "c"], 10))
df = vcat(df, df)
unique(df)   # doesn't modify df
unique!(df)  # modifies df
```


[DataFrames/src/abstractdataframe/abstractdataframe.jl:598](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L598)



## ncol

Number of rows or columns in an AbstractDataFrame

```julia
nrow(df::AbstractDataFrame)
ncol(df::AbstractDataFrame)
```

### Arguments

* `df` : the AbstractDataFrame

### Result

* `::AbstractDataFrame` : the updated version

See also `size`.

NOTE: these functions may be depreciated for `size`.

### Examples

```julia
df = DataFrame(i = 1:10, x = rand(10), y = rand(["a", "b", "c"], 10))
size(df)
nrow(df)
ncol(df)
```


[DataFrames/src/abstractdataframe/abstractdataframe.jl:771](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L771)



## nrow

Number of rows or columns in an AbstractDataFrame

```julia
nrow(df::AbstractDataFrame)
ncol(df::AbstractDataFrame)
```

### Arguments

* `df` : the AbstractDataFrame

### Result

* `::AbstractDataFrame` : the updated version

See also `size`.

NOTE: these functions may be depreciated for `size`.

### Examples

```julia
df = DataFrame(i = 1:10, x = rand(10), y = rand(["a", "b", "c"], 10))
size(df)
nrow(df)
ncol(df)
```


[DataFrames/src/abstractdataframe/abstractdataframe.jl:771](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L771)




# DataFrame





# SubDataFrame


