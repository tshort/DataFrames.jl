NA_Float64 = NaN 
NA_Float32 = NaN32
na(::Type{Float64}) = NA_Float64
na(::Type{Float32}) = NA_Float32
convert{T <: Float}(::Type{T}, x::NAtype) = na(T)
promote_rule{T <: Float}(::Type{T}, ::Type{NAtype} ) = T
isna{T <: Float}(x::T) = isnan(x)
isna{T <: Float}(x::AbstractVector{T}) = x .!= x
nafilter{T <: Float}(v::AbstractVector{T}) = v[!isna(v)]
nareplace{T <: Float}(v::AbstractVector{T}, r::T) = [isna(v)[i] ? r : v[i] for i = 1:length(v)]

type NAFilter{T}
    x::AbstractVector{T}
end
function start(v::NAFilter)
    for k in 1:length(v.x)
        if !isna(v.x[k])
            return k
        end
    end
    return length(v.x) + 1
end
function next(v::NAFilter, i)
    nxt = v.x[i]
    newi = length(v.x) + 1
    for k in i + 1 : length(v.x)
        if !isna(v.x[k])
            newi = k
            break
        end
    end
    return nxt, newi
end
done(v::NAFilter, i) = i > length(v.x)
naFilter{T <: Float}(v::AbstractVector{T}) = NAFilter(v)
    
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
