# put NAtype here temporarily

type NAtype; end
## type NAtype <: Real; end
const NA = NAtype()
show(io, x::NAtype) = print(io, "NA")

type NAException <: Exception
    msg::String
end

length(x::NAtype) = 1
size(x::NAtype) = ()
isna(x::NAtype) = true
isna(x) = false

==(na::NAtype, na2::NAtype) = NA
=={T<:Real}(na::NAtype, ::T) = NA
=={T<:Real}(::T, na::NAtype) = NA



require("src/intNA.jl")
require("src/boolNA.jl")
require("src/floatNA.jl")


## Utilities ##

function isna(A::AbstractArray)
    F = Array(Bool, size(A))
    for i = 1:numel(A)
        F[i] = isna(A[i])
    end
    return F
end

# defaults for basetype
basetype(x) = typeof(x)
basetype{T<:Any}(x) = T


nafilter{T <: Number}(v::AbstractVector{T}) = v[!isna(v)]
nareplace{T <: Number}(v::AbstractVector{T}, r::T) = [isna(v[i]) ? r : v[i] for i = 1:length(v)]


type NAFilter{T}
    x::T
end
function start{T}(v::NAFilter{T})
    x = v.x::T
    for k in 1:length(x)
        if !isna(v.x[k])
            return k
        end
    end
    return length(x) + 1
end
function next{T}(v::NAFilter{T}, i)
    x = v.x::T
    nxt = x[i]
    newi = length(x) + 1
    for k in i + 1 : length(x)
        if !isna(x[k])
            newi = k
            break
        end
    end
    return nxt, newi
end
done{T}(v::NAFilter{T}, i) = i > length(v.x::T)
naFilter{T}(v::T) = NAFilter{T}(v)
    
type NAReplace{T}
    x::AbstractVector{T}
    val::T
end
start(v::NAReplace) = 1
function next(v::NAReplace, i)
    if isna(v.x[i])
        res = v.val
    else
        res = v.x[i]
    end
    (res, i + 1)
end
done(v::NAReplace, i) = i > length(v.x)
naReplace{T <: Float}(v::AbstractVector{T}, val::T) = NAReplace(v, val)


DataVec(x::Vector) = DataVec(x, isna(x))
PooledDataVec(x::Vector) = PooledDataVec(x, isna(x))
