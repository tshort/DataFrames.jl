
## definition ##

bitstype 8  BoolNA <: Integer

convert(::Type{BoolNA}, x::NAtype) = NA_Bool
promote_rule(::Type{BoolNA}, ::Type{NAtype} ) = BoolNA
promote_rule(::Type{Bool}, ::Type{NAtype} ) = BoolNA

## boolean conversions ##

convert(::Type{BoolNA}, x::NAtype) = NA_Bool

convert(::Type{BoolNA}, x::Number) = (x!=0)

convert(::Type{Bool}, x::BoolNA) = box(Bool,unbox(BoolNA,x))
convert(::Type{BoolNA}, x::Bool) = box(BoolNA,unbox(Bool,x))

convert(::Type{IntNA8},   x::BoolNA) = box(IntNA8,unbox(BoolNA,x))
convert(::Type{IntNA16},  x::BoolNA) = box(IntNA16,zext16(unbox(BoolNA,x)))
convert(::Type{IntNA32},  x::BoolNA) = box(IntNA32,zext32(unbox(BoolNA,x)))
convert(::Type{IntNA64},  x::BoolNA) = box(IntNA64,zext64(unbox(BoolNA,x)))
convert(::Type{IntNA128}, x::BoolNA) = box(IntNA128,zext_int(IntNA128,unbox(BoolNA,x)))

convert(::Type{Float32}, x::BoolNA) = box(Float32,sitofp32(unbox(BoolNA,x)))
convert(::Type{Float64}, x::BoolNA) = box(Float64,sitofp64(unbox(BoolNA,x)))
convert(::Type{Float}, x::BoolNA)   = convert(Float32, x)


# promote Bool to any other numeric type

promote_rule{T<:Number}(::Type{BoolNA}, ::Type{T}) = T

promote_rule(::Type{Bool}, ::Type{BoolNA} ) = BoolNA

## boolNA definition ##

boolNA(x) = convert(BoolNA, x)
boolNA(x::BoolNA) = x

boolNA(x::AbstractArray) = copy_to(similar(x,BoolNA), x)
boolNA(x::AbstractArray{Bool}) = reinterpret(BoolNA, x, size(x))

## NA definition / handling ##

NA_Bool  = boolNA(-128)
NA_Bool  = box(BoolNA, unbox(Int8,int8(-128)))

na(::Type{Bool}) = NA_Bool
na(::Type{BoolNA}) = NA_Bool
na(::Bool)   = NA_Bool
na(::BoolNA) = NA_Bool

isna(x::BoolNA) = eq_int(unbox(BoolNA, x), unbox(BoolNA, NA_Bool))

basetype(::Type{BoolNA}) = Bool
natype(::Type{Bool}) = BoolNA
natype(::Type{BoolNA}) = BoolNA

function basetype{T<:BoolNA,N}(x::Array{T,N})
    res = Array(basetype(T), size(x))
    for i in 1:length(x)
        res[i] = basetype(x[i])
    end
    res
end

natype{T<:BoolNA,N}(x::Array{T,N}) = x

function natype{T<:Bool,N}(x::Array{T,N})
    res = Array(natype(T), size(x))
    for i in 1:length(x)
        res[i] = natype(x[i])
    end
    res
end


sizeof(::Type{BoolNA}) = 1

typemin(::Type{BoolNA}) = false
typemax(::Type{BoolNA}) = true

## boolean operations ##

!(x::BoolNA) = eq_int(unbox(BoolNA,x),trunc8(0))
isequal(x::Bool, y::Bool) = eq_int(unbox(BoolNA,x),unbox(BoolNA,y))

(~)(x::BoolNA) = isna(x) ? NA_Bool : !x
(&)(x::BoolNA, y::BoolNA) = isna(x) || isna(y) ? NA_Bool : eq_int(and_int(unbox(BoolNA,x),unbox(BoolNA,y)),trunc8(1))
(|)(x::BoolNA, y::BoolNA) = isna(x) || isna(y) ? NA_Bool : eq_int( or_int(unbox(BoolNA,x),unbox(BoolNA,y)),trunc8(1))
($)(x::BoolNA, y::BoolNA) = isna(x) || isna(y) ? NA_Bool : (x!=y)

any(x::BoolNA)  = isna(x) ? NA_Bool : x
all(x::BoolNA)  = isna(x) ? NA_Bool : x

any(x::BoolNA, y::BoolNA) = x | y
all(x::BoolNA, y::BoolNA) = x & y

## do arithmetic as Int ##

signbit(x::BoolNA) = 0
sign(x::BoolNA) = intNA(x)
abs(x::BoolNA) = intNA(x)

<(x::BoolNA, y::BoolNA) = y&!x
==(x::BoolNA, y::BoolNA) = eq_int(unbox(BoolNA,x),unbox(BoolNA,y))

-(x::BoolNA) = -int(x)

+(x::BoolNA, y::BoolNA) = intNA(x)+intNA(y)
-(x::BoolNA, y::BoolNA) = intNA(x)-intNA(y)
*(x::BoolNA, y::BoolNA) = intNA(x)*intNA(y)
/(x::BoolNA, y::BoolNA) = intNA(x)/intNA(y)
^(x::BoolNA, y::BoolNA) = intNA(x)^intNA(y)

div(x::BoolNA, y::BoolNA) = div(intNA(x),intNA(y))
fld(x::BoolNA, y::BoolNA) = fld(intNA(x),intNA(y))
rem(x::BoolNA, y::BoolNA) = rem(intNA(x),intNA(y))
mod(x::BoolNA, y::BoolNA) = mod(intNA(x),intNA(y))

show(io, b::BoolNA) = print(io, isna(b) ? "NA" : b ? "true" : "false")
