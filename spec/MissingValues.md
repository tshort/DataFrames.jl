# Background on Handling Missing Values (NA's)

Handling missing data is important for many statistical and scientific
data analysis tasks. Missing data can be handled in analysis in a
number of ways. Two common ways are with a mask vector to store
missing value status and a bit pattern approach where certain bit
patterns are reserved to indicate a missing value. 

Here is some background on how other open-source packages treat
missing values:

* R -- Missing values are completely integrated into basic language
  types. Bit patterns are used to specify missing values. For
  floating-point operations, the bit pattern is a NaN (not a number)
  that is propagated through many numeric calculations. NA and NaN
  have separate bit patterns, although operations between NA and NaN
  can result in either an NA or NaN answer.

* Pandas (Python) -- Missing values are supported in floating-point
  arrays by using NaN's as missing data. If NA's are inserted into
  integer arrays, they are converted to floating point. See here for
  background:
  
  http://pandas.pydata.org/pandas-docs/stable/missing_data.html

* Future Numpy (Python) -- Numpy plans to implement both bit patterns
  and one or more masking approaches for missing values. Discussions
  have been intense. See here:
  
  https://github.com/numpy/numpy/blob/master/doc/neps/missing-data.rst

In Julia, we adopt multiple approaches for integrating missing values.
An array mask approach is adopted in DataVecs, and several bitstypes
have been defined that can be used in Julia arrays. The API is common
for both approaches, and they are interoperable. Other types that
support NA's are expected. For other types that support NA's,
following the same API will aid interoperability.

# API for Handling Missing Values

* `NA` : A constant indicating NA. It should work for all
  types that support missing values.
  
* `isna(x)` : Return a `Bool` or `Array{Bool}` that is `true` for
  elements with missing values.

* `nafilter(x)` : Return a copy of `x` after removing missing values. 

* `nareplace(x, val)` : Return a copy of `x` after replacing missing
  values with `val`.

* `naFilter(x)` : Return an object based on `x` such that future
  operations like `mean` will not include missing values. This can be
  an iterator or other object.

* `naReplace(x, val)` : Return an object based on `x` such that future
  operations like `mean` will replace NAs with `val`.

* `basetype(x)` : Convert `x` from a value that can contain missing
  values to it's fundamental type that may or may not handle missing
  values.

* `natype(x)` : Convert `x` to a value of similar type that can
  contain missing values.

* `na(x)` : Return an `NA` value appropriate for the type of `x`.

In addition, here are other specifications for types handling missing
values:

* Missing values should propagate by default. `[1,NA] + 2` should
  return `[3,NA]`.
  
* Comparisons involving an `NA` should return `NA`. `NA == NA` returns
  `NA`.

* In an indexing element is `NA`, the result should be `NA`.

* Missing values should print as `"NA"`.


# DataVecs

`DataVec` implements a masking approach to missing values. This
structure holds a data vector and an `na` mask as shown in the first
part of the type definition:

```julia
type DataVec{T} <: AbstractDataVec{T}
    data::Vector{T}
    na::AbstractVector{Bool}
```

DataVecs can hold any type of vector, so NA support is automatic for
data included in a DataVec. 

The methods `nafilter` and `nareplace` are available to either filter
out NA's or to replace them with another value and return a `Vector`.
Here is an example of a DataVec definition and the use of `nafilter`
and `nareplace`.

```julia
julia> dv = DataVec[1,NA,3,4]
[1,NA,3,4]

julia> nafilter(dv)
3-element Int64 Array:
 1
 3
 4

julia> nareplace(dv, -1)
4-element Int64 Array:
  1
 -1
  3
  4
```

`nafilter` is relatively efficient because the masking index is
readily available. 

In addition to `nafilter` and `nareplace`, the methods `naFilter` and
`naReplace` are available to filter or replace on demand. These do not
make copies. Instead, they are an indicator to filter or replace in a
future operation. DataVecs include indicators for filter or replace in
the data structure. Here is an example of `naFilter`:

```julia
julia> sum(naFilter(dv))
8
```

Because `DataVec` support is young, many operations require
`nafilter(dv)` or other operation to convert to a `Vector` for
processing. Likewise, few methods currrently support fast operation
using `naFilter` or `naReduce`.

# PooledDataVecs

`PooledDataVec` is an AbstractDataVec that implements something like a
vector of R's factors. A PooledDataVec holds references to a pool of
data values. This is especially useful for character and integer
vectors, especially if these are used for grouping or indexing.
Missing values are automatically stored as the zeroeth element, so as
with DataVecs, PooledDataVecs can hold NA representations for any type.

```jul
julia> pd = PooledDataVec["a", NA, "b", "a", "b"]
["a",NA,"b","a","b"]

julia> pd[2]
NA

julia> pd .== "a"
[true,NA,false,true,false]
```

# Bitstype Missing Values

Several bitstype values have been defined that can represent missing
values. These are:

* BoolNA
* IntNA8
* IntNA16
* IntNA32
* IntNA64
* IntNA128
* FloatNA32
* FloatNA64

These each have a bit pattern that represents NA. These types can be
used in any Julia structure, including Arrays, Dicts, and DArrays.
Arrays of these types can support `nafilter`, `nareduce`, `naFilter`,
and `naReplace`.

```julia
julia> a = [1:3, NA, 5:6]    # IntNA
6-element IntNA64 Array:
  1
  2
  3
 NA
  5
  6

julia> x = [pi, NA, 1:5]     # Float64
7-element Float64 Array:
  3.14159
 NA      
  1.0    
  2.0    
  3.0    
  4.0    
  5.0    

julia> isna(x)
7-element Bool Array:
 false
  true
 false
 false
 false
 false
 false

julia> sum(x)
NA

julia> sum(a)
NA

julia> x[2]
NA

julia> sum(nafilter(a))
17

julia> sum(nafilter(x))
18.141592653589793

julia> x[a]
6-element Float64 Array:
  3.14159
 NA      
  1.0    
 NA      
  3.0    
  4.0    

julia> b = x .> 3  # wrong for the NA element in x
7-element Bool Array:
  true
 false
 false
 false
 false
  true
  true

julia> b = floatNA(x) .< 3
7-element BoolNA Array:
 false
    NA
  true
  true
 false
 false
 false

julia> x[b]
3-element Float64 Array:
 NA  
  1.0
  2.0

julia> randn(7)[b]
3-element Float64 Array:
 NA       
  0.158701
 -0.535744
```

More details on each type follow.

## BoolNA

`boolNA` is analagous to `bool`; it converts values to type
`BoolNA`. The constant `NA_Bool` is the bit pattern representing a
missing value. Normally, the user will not need this as the standard
`NA` will be properly promoted to type `BoolNA` when needed. 

`Array{Bool}` can be used for array indexing. If an index includes an
NA, the result should be NA. (What should we do if the type doesn't
support NA's?)

Boolean values and NA's are tricky. Non-boolean values cannot be used
in places where Bool's are expected, like the following cases:

```julia
julia> a = boolNA([true, NA])
2-element BoolNA Array:
 true
   NA

julia> a[1] ? 1 : 0
type error: non-boolean (BoolNA) used in boolean context
```

The following is needed:

```jul
julia> bool(a[1]) ? 1 : 0
1
```

But, wathc out for this:
```julia
julia> bool(a[2]) ? 1 : 0
0
``` 
Something like this might be best:

```julia
julia> isna(a[2]) ? error("can't use NA's here") : bool(a[2]) ? 1 : 0
can't use NA's here

julia> isna(a[1]) ? error("can't use NA's here") : bool(a[2]) ? 1 : 0
0
``` 

These issues will occur with any boolean representation of NAs in
Julia.

## IntNA

`intNA` and bit-length specific versions (intNA8, intNA16, intNA32,
intNA64, and intNA128) convert values to the appropriate IntNA type.
Each IntNA type has a base type (Int16 and IntNA16 for example).
`IntNA` has the same bit length as `Int`.

Only signed integers have been developed with NA support currently.
The extreme negative value is used to represent NA. Constants are
provided for each: `NA_Int8`, `NA_Int16`, `NA_Int32`, `NA_Int64`, and
`NA_Int128`.

`Vector{IntNA}` can be used to index arrays. If an index includes an
NA, the result should be NA in that position. 

## FloatNA

`FloatNA` uses a particular NaN value to represent NA's. Standard
Float32 and Float64 can also hold NA values in a similar manner.
`floatNA`, `floatNA32`, and `floatNA64` convert to an NA
representation. The bit-level format of float and floatNA versions is
identical. The only real difference is in comparisons. With standard
floating-point types, any operation involving a missing value returns
false. With the `FloatNA` version of the type, comparisons involving
NA return NA.

The following constants for NA's are provided: `NA_Float32`,
`NA_Float64`, and `NA_Float` (equivalent to `NA_Float64`).

Two options are possible for NA representation:

* Try to keep NA's in FloatNA arrays. This has the advantage that NA
  support is most consistent. The disadvantage is that some other
  functions are written specifically for Float32 and/or Float64. In
  these cases, the user would have to call the function as
  `sumfun(float(x))`.
  
* Try to keep NA's in standard Float arrays. The main issue with using
  NA's in standard Floats is that comparisons don't respect NA's. For
  example, `3.0 < NA` is false, and `3.0 >= NA` is also false. It's
  more consistant for both of these to return NA.

In either case, since conversion between Float types and FloatNA types
is fast. Arrays are just reinterpretted; there is no copying.

It is possible to differentiate between NA and NaN. Operations between
NA and NaN's can be either, depending on which flavor of NaN
propagates first. Currently `isna` and `isnan` do not overlap. This
should probably change, so that one includes both. In R for example,
`is.na` is `true` for NA or NaN.

# Examples of Interoperability

Different NA types should interoperate. Here are some examples when
used in a DataFrame.

```jul
julia> x = [1:3, NA, 1:3, NA]
8-element IntNA64 Array:
  1
  2
  3
 NA
  1
  2
  3
 NA

julia> d = DataFrame({x, 1.0*x, DataVec(x), PooledDataVec(x)})
DataFrame  (8,4)
        x1  x2 x3 x4
[1,]     1 1.0  1  1
[2,]     2 2.0  2  2
[3,]     3 3.0  3  3
[4,]    NA  NA NA NA
[5,]     1 1.0  1  1
[6,]     2 2.0  2  2
[7,]     3 3.0  3  3
[8,]    NA  NA NA NA


julia> isna(d[4,4])
true

julia> isna(d[4,3])
true

julia> isna(d[4,2])
true

julia> isna(d[4,1])
true

julia> res = by(d, "x4", :(x1_sum = sum(x1); x2_mean = mean(x2)))
DataFrame  (4,3)
        x4 x1_sum x2_mean
[1,]    NA     NA      NA
[2,]     1      2     1.0
[3,]     2      4     2.0
[4,]     3      6     3.0
```



