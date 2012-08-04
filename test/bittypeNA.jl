## basics

a = [1:3, NA, 5:6]    # IntNA
x = [pi, NA, 1:5]     # Float64

@assert eltype(a) == IntNA
@assert eltype(x) == Float64
@assert isna(sum(a))
@assert isna(sum(x))
@assert isna(mean(a))
@assert isna(mean(x))
## @assert isna(median(a))   # BROKEN because of sort and non-boolean used in boolean context
## @assert isna(median(x))  # BROKEN endless loop? - probable bug in median with NaN's
@assert sum(nafilter(a)) == 17
@assert sum(nafilter(x)) == sum([pi,1:5])
@assert sum(nareplace(a,0)) == 17
@assert sum(nareplace(x,0.0)) == sum([pi,1:5])

# test IntNA indexing
@assert x[a][1] == pi
@assert isna(x[a][2])
@assert isna(x[a][4])
@assert isequal(x[a], [pi, NA, 1, NA, 3:4])

# test BoolNA indexing
idx = boolNA(fill(true, size(x)))
@assert isequal(x, x[idx])
idx[[1,end]] = NA
@assert isna(x[idx][1])
@assert isna(x[idx][2])
