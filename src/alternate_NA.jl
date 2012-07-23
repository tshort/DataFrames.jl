NA_Float64 = NaN 
NA_Float32 = NaN32
na(::Type{Float64}) = NA_Float64
na(::Type{Float32}) = NA_Float32
convert{T <: Float}(::Type{T}, x::NAtype) = na(T)
promote_rule{T <: Float}(::Type{T}, ::Type{NAtype} ) = T
isna{T <: Float}(x::T) = isnan(x)
isna{T <: Float}(x::AbstractVector{T}) = x .!= x
nafilter{T <: Float}(v::AbstractVector{T}) = v[!isna(v)]
nareplace{T <: Float}(v::AbstractVector{T}, r::T) = [isna(v[i]) ? r : v[i] for i = 1:length(v)]

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

## function sum{T<:Float}(A::NAFilter{T})
##     println("here")
##     A = A.x::Vector{Float64}
##     n = length(A)
##     if (n == 0)
##         return zero(T)
##     end
##     s = 0.0
##     c = zero(T)
##     for i in 1:n
##         if isna(A[i])
##             continue
##         end
##         Ai = A[i]
##         t = s + Ai
##         if abs(s) >= abs(Ai)
##             c += ((s-t) + Ai)
##         else
##             c += ((Ai-t) + s)
##         end
##         s = t
##     end
##     s + c
## end

## function sum(A::NAFilter)
##     A = A.x
##     v = 0.0
##     for x in A
##         if !isna(x)
##             v += x
##         end
##     end
##     v
## end
