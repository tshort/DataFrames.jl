



# AbstractDataFrame




## DataFrames.AbstractDataFrame


An abstract type for which all concrete types expose a database-like
interface.

### Common methods

An AbstractDataFrame is a two-dimensional table with Symbols for
column names. An AbstractDataFrame is also similar to an Associative
type in that it allows indexing by a key (the columns).

The following are normally implemented for AbstractDataFrames:

* `describe(d)` : summarize columns
* `dump(d)` : show structure
* `hcat(d1, d2)` : horizontal concatenation
* `vcat(d1, d2)` : vertical concatenation
* `names(d)` : columns names
* `names!(d, vals)` : set columns names
* `rename!(d, args)` : rename columns names based on keyword arguments
* `eltypes(d)` : `eltype` of each column
* `length(d)` : number of columns
* `size(d)` : (nrows, ncols)
* `head(d, n = 5)` : first `n` rows
* `tail(d, n = 5)` : last `n` rows
* `array(d)` : convert to an array
* `DataArray(d)` : convert to a DataArray
* `complete_cases(d)` : indexes of complete cases (rows with no NA's)
* `complete_cases!(d)` : remove rows with NA's
* `nonunique(d)` : indexes of duplicate rows
* `unique!(d)` : remove duplicate rows
* `similar(d)` : a DataFrame with similar columns as `d`

### Indexing

Table columns are accessed (`getindex`) by a single index that can be
a symbol identifier, an integer, or a vector of each. If a single
column is selected, just the column object is returned. If multiple
columns are selected, some AbstractDataFrame is returned.

```julia
d[:colA] 
d[3]
d[[:colA, :colB]]
d[[1:3; 5]]
```

Rows and columns can be indexed like a `Matrix` with the added feature
of indexing columns by name.

```julia
d[1:3, :colA]
d[3,3]
d[3,:]
d[3,[:colA, :colB]]
d[:, [:colA, :colB]]
d[[1:3; 5], :]
```

`setindex` works similarly.

[DataFrames/src/abstractdataframe/abstractdataframe.jl:67](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/abstractdataframe/abstractdataframe.jl#L67)




# DataFrame




## DataFrames.DataFrame

An AbstractDataFrame that stores a set of named columns

The columns are normally AbstractVectors stored in memory,
particularly a Vector, DataVector, or PooledDataVector.

### Constructors

```julia
DataFrame(columns::Vector{Any}, names::Vector{Symbol})
DataFrame(kwargs...)
DataFrame() # an empty DataFrame
DataFrame(t::Type, nrows::Integer, ncols::Integer) # an empty DataFrame of arbitrary size
DataFrame(column_eltypes::Vector, names::Vector, nrows::Integer)
DataFrame(ds::Vector{Associative})
```

### Arguments

* `columns` : a Vector{Any} with each column as contents
* `names` : the column names
* `kwargs` : the key gives the column names, and the value is the
  column contents
* `t` : elemental type of all columns
* `nrows`, `ncols` : number of rows and columns
* `column_eltypes` : elemental type of each column
* `ds` : a vector of Associatives

Each column in `columns` should be the same length. 

### Notes

Most of the default constructors convert columns to `DataArrays`.  The
base constructor, `DataFrame(columns::Vector{Any},
names::Vector{Symbol})` does not convert to `DataArrays`.

A `DataFrame` is a lightweight object. As long as columns are not
manipulated, creation of a DataFrame from existing AbstractVectors is
inexpensive. For example, indexing on columns is inexpensive, but
indexing by rows is expensive because copies are made of each column.

Because column types can vary, a DataFrame is not type stable. For
performance-critical code, do not index into a DataFrame inside of
loops.

### Examples

```julia
df = DataFrame()
v = ["x","y","z"][rand(1:3, 10)]
df1 = DataFrame(Any[[1:10], v, rand(10)], [:A, :B, :C])  # columns are Arrays
df2 = DataFrame(A = 1:10, B = v, C = rand(10))           # columns are DataArrays
dump(df1)
dump(df2)
describe(df2)
head(df1)
df1[:A] + df2[:C]
df1[1:4, 1:2]
df1[[:A,:C]]
df1[1:2, [:A,:C]]
df1[:, [:A,:C]]
df1[:, [1,3]]
df1[1:4, :]
df1[1:4, :C]
df1[1:4, :C] = 40. * df1[1:4, :C]
[df1; df2]  # vcat
[df1  df2]  # hcat
size(df1)
```


[DataFrames/src/dataframe/dataframe.jl:76](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/dataframe/dataframe.jl#L76)




# SubDataFrame




## DataFrames.SubDataFrame{T<:AbstractArray{Int64,1}}

A view of row subsets of an AbstractDataFrame

A `SubDataFrame` is meant to be constructed with `sub`.  A
SubDataFrame is used frequently in split/apply sorts of operations.

```julia
sub(d::AbstractDataFrame, rows)
```

### Arguments

* `d` : an AbstractDataFrame
* `rows` : any indexing type for rows, typically an Int,
  AbstractVector{Int}, AbstractVector{Bool}, or a Range

### Notes

A `SubDataFrame` is an AbstractDataFrame, so expect that most
DataFrame functions should work. Such methods include `describe`,
`dump`, `nrow`, `size`, `by`, `stack`, and `join`. Indexing is just
like a DataFrame; copies are returned.

To subset along columns, use standard column indexing as that creates
a view to the columns by default. To subset along rows and columns,
use column-based indexing with `sub`.

### Examples

```julia
df = DataFrame(a = rep(1:4, 2), b = rep(2:-1:1, 4), c = randn(8))
sdf1 = sub(df, 1:6)
sdf2 = sub(df, df[:a] .> 1)
sdf3 = sub(df[[1,3]], df[:a] .> 1)  # row and column subsetting
sdf4 = groupby(df, :a)[1]  # indexing a GroupedDataFrame returns a SubDataFrame
sdf5 = sub(sdf1, 1:3)
sdf1[:,[:a,:b]]
```


[DataFrames/src/subdataframe/subdataframe.jl:53](https://github.com/JuliaStats/DataFrames.jl/tree/cac96119c9f5e24c5f2976ff119703a6ec52476c/src/subdataframe/subdataframe.jl#L53)

