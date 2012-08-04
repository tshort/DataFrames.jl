
##
## Standard Float's
##

const NA_Float32 = box(Float32,unbox(Uint32,0x7fc007A2))
const NA_Float64 = box(Float64,unbox(Uint64,0x7ff80000000007A2))
const NA_Float = NA_Float64

na(::Type{Float32}) = NA_Float32
na(::Type{Float64}) = NA_Float64
na(::Float32) = NA_Float32
na(::Float64) = NA_Float64

convert{T <: Float}(::Type{T}, x::NAtype) = na(T)
promote_rule{T <: Float}(::Type{T}, ::Type{NAtype} ) = T

isna(x::Float32)  = eq_int(unbox(Float32, x), unbox(Float32,  NA_Float32))
isna(x::Float64)  = eq_int(unbox(Float64, x), unbox(Float64,  NA_Float64))

natype(::Type{Float32})  = FloatNA32
natype(::Type{Float64})  = FloatNA64

natype(x::Float32)  = convert(FloatNA32, x)
natype(x::Float64)  = convert(FloatNA64, x)

# Redefine these to distinguish between NA and NaN:
isnan(x::Float32)  = eq_int(unbox(Float32, x), unbox(Float32,  NaN32))
isnan(x::Float64)  = eq_int(unbox(Float64, x), unbox(Float64,  NaN))


##
## Standard complex numbers
##

complex NA_Complex64 = complex64(NA_Float32, NA_Float32)
complex NA_Complex128 = complex128(NA_Float64, NA_Float64)

na(::Type{Complex64}) = NA_Complex64
na(::Type{Complex128}) = NA_Complex128
na(::Complex64) = NA_Complex64
na(::Complex128) = NA_Complex128
na{T<:Complex}(x::T) = complex(na(real(x)), na(imag(x)))

basetype{T<:Complex}(x::T) = x
natype{T<:Complex}(x::T) = x

convert{T <: Complex}(::Type{T}, x::NAtype) = na(T)

isna{T<:Complex}(x::T) = isna(real(x)) || isna(imag(x))


##
## FloatNA bittype
##

abstract FloatNA <: Float
bitstype 32 FloatNA32 <: FloatNA
bitstype 64 FloatNA64 <: FloatNA

convert{T <: FloatNA}(::Type{T}, x::NAtype) = na(T)
promote_rule{T <: FloatNA}(::Type{T}, ::Type{NAtype} ) = T

isna(x::FloatNA32)  = eq_int(unbox(FloatNA32, x), unbox(Float32,  NA_Float32))
isna(x::FloatNA64)  = eq_int(unbox(FloatNA64, x), unbox(Float64,  NA_Float64))

natype(::Type{FloatNA32})  = FloatNA32
natype(::Type{FloatNA64})  = FloatNA64

basetype(::Type{FloatNA32})  = Float32
basetype(::Type{FloatNA64})  = Float64

basetype(x::FloatNA32)  = convert(Float32, x)
basetype(x::FloatNA64)  = convert(Float64, x)

function basetype{T<:FloatNA,N}(x::Array{T,N})
    res = Array(basetype(T), size(x))
    for i in 1:length(x)
        res[i] = basetype(x[i])
    end
    res
end

na(::Type{FloatNA32}) = floatNA32(NA_Float32)
na(::Type{FloatNA64}) = floatNA64(NA_Float64)
na(::FloatNA32) = floatNA32(NA_Float32)
na(::FloatNA64) = floatNA64(NA_Float64)


## conversions to floating-point ##

convert(::Type{FloatNA32}, x::Float32) = box(FloatNA32,(unbox(Float32,x)))
convert(::Type{FloatNA64}, x::Float64) = box(FloatNA64,(unbox(Float64,x)))
convert(::Type{Float32}, x::FloatNA32) = box(Float32,(unbox(FloatNA32,x)))
convert(::Type{Float64}, x::FloatNA64) = box(Float64,(unbox(FloatNA64,x)))

convert(::Type{FloatNA32}, x::BoolNA)    = isna(x) ? floatNA32(NA_Float32) : box(FloatNA32,sitofp32(unbox(BoolNA,x)))
convert(::Type{FloatNA32}, x::IntNA8)    = isna(x) ? floatNA32(NA_Float32) : box(FloatNA32,sitofp32(unbox(IntNA8,x)))
convert(::Type{FloatNA32}, x::IntNA16)   = isna(x) ? floatNA32(NA_Float32) : box(FloatNA32,sitofp32(unbox(IntNA16,x)))
convert(::Type{FloatNA32}, x::IntNA32)   = isna(x) ? floatNA32(NA_Float32) : box(FloatNA32,sitofp32(unbox(IntNA32,x)))
convert(::Type{FloatNA32}, x::IntNA64)   = isna(x) ? floatNA32(NA_Float32) : box(FloatNA32,sitofp32(unbox(IntNA64,x)))

convert(::Type{FloatNA64}, x::BoolNA)    = isna(x) ? floatNA64(NA_Float64) : box(FloatNA64,sitofp64(unbox(BoolNA,x)))
convert(::Type{FloatNA64}, x::IntNA8)    = isna(x) ? floatNA64(NA_Float64) : box(FloatNA64,sitofp64(unbox(IntNA8,x)))
convert(::Type{FloatNA64}, x::IntNA16)   = isna(x) ? floatNA64(NA_Float64) : box(FloatNA64,sitofp64(unbox(IntNA16,x)))
convert(::Type{FloatNA64}, x::IntNA32)   = isna(x) ? floatNA64(NA_Float64) : box(FloatNA64,sitofp64(unbox(IntNA32,x)))
convert(::Type{FloatNA64}, x::IntNA64)   = isna(x) ? floatNA64(NA_Float64) : box(FloatNA64,sitofp64(unbox(IntNA64,x)))

convert(::Type{FloatNA32}, x::Bool)    = box(FloatNA32,sitofp32(unbox(Bool,x)))
convert(::Type{FloatNA32}, x::Char)    = box(FloatNA32,uitofp32(unbox(FloatNA32,x)))
convert(::Type{FloatNA32}, x::Int8)    = box(FloatNA32,sitofp32(unbox(Int8,x)))
convert(::Type{FloatNA32}, x::Int16)   = box(FloatNA32,sitofp32(unbox(Int16,x)))
convert(::Type{FloatNA32}, x::Int32)   = box(FloatNA32,sitofp32(unbox(Int32,x)))
convert(::Type{FloatNA32}, x::Int64)   = box(FloatNA32,sitofp32(unbox(Int64,x)))
convert(::Type{FloatNA32}, x::Uint8)   = box(FloatNA32,uitofp32(unbox(Uint8,x)))
convert(::Type{FloatNA32}, x::Uint16)  = box(FloatNA32,uitofp32(unbox(Uint16,x)))
convert(::Type{FloatNA32}, x::Uint32)  = box(FloatNA32,uitofp32(unbox(Uint32,x)))
convert(::Type{FloatNA32}, x::Uint64)  = box(FloatNA32,uitofp32(unbox(Uint64,x)))
convert(::Type{FloatNA32}, x::Float64) = isna(x) ? floatNA32(NA_Float32) : box(FloatNA32,fptrunc32(unbox(Float64,x)))
convert(::Type{FloatNA32}, x::FloatNA64) = isna(x) ? floatNA32(NA_Float32) : box(FloatNA32,fptrunc32(unbox(FloatNA64,x)))
convert(::Type{Float32}, x::FloatNA64) = isna(x) ? NA_Float32 : box(FloatNA32,fptrunc32(unbox(Float64,x)))

convert(::Type{FloatNA64}, x::Bool)    = box(FloatNA64,sitofp64(unbox(Bool,x)))
convert(::Type{FloatNA64}, x::Char)    = box(FloatNA64,uitofp64(unbox(Char,x)))
convert(::Type{FloatNA64}, x::Int8)    = box(FloatNA64,sitofp64(unbox(Int8,x)))
convert(::Type{FloatNA64}, x::Int16)   = box(FloatNA64,sitofp64(unbox(Int16,x)))
convert(::Type{FloatNA64}, x::Int32)   = box(FloatNA64,sitofp64(unbox(Int32,x)))
convert(::Type{FloatNA64}, x::Int64)   = box(FloatNA64,sitofp64(unbox(Int64,x)))
convert(::Type{FloatNA64}, x::Uint8)   = box(FloatNA64,uitofp64(unbox(Uint8,x)))
convert(::Type{FloatNA64}, x::Uint16)  = box(FloatNA64,uitofp64(unbox(Uint16,x)))
convert(::Type{FloatNA64}, x::Uint32)  = box(FloatNA64,uitofp64(unbox(Uint32,x)))
convert(::Type{FloatNA64}, x::Uint64)  = box(FloatNA64,uitofp64(unbox(Uint64,x)))
convert(::Type{FloatNA64}, x::Float32) = box(FloatNA64,fpext64(unbox(Float32,x)))
convert(::Type{FloatNA64}, x::FloatNA32) = isna(x) ? floatNA64(NA_Float64) : box(FloatNA64,fpext64(unbox(FloatNA32,x)))
convert(::Type{Float64}, x::FloatNA32) = isna(x) ? NA_Float64 : box(Float64,fpext64(unbox(FloatNA32,x)))

convert(::Type{FloatNA}, x::Bool)   = convert(FloatNA32, x)
convert(::Type{FloatNA}, x::Char)   = convert(FloatNA32, x)
convert(::Type{FloatNA}, x::Int8)   = convert(FloatNA32, x)
convert(::Type{FloatNA}, x::Int16)  = convert(FloatNA32, x)
convert(::Type{FloatNA}, x::Int32)  = convert(FloatNA64, x)
convert(::Type{FloatNA}, x::Int64)  = convert(FloatNA64, x) # LOSSY
convert(::Type{FloatNA}, x::Uint8)  = convert(FloatNA32, x)
convert(::Type{FloatNA}, x::Uint16) = convert(FloatNA32, x)
convert(::Type{FloatNA}, x::Uint32) = convert(FloatNA64, x)
convert(::Type{FloatNA}, x::Uint64) = convert(FloatNA64, x) # LOSSY

floatNA32(x) = convert(FloatNA32, x)
floatNA64(x) = convert(FloatNA64, x)
floatNA(x)   = convert(FloatNA64, x)
floatNA32(x::FloatNA32)   = x
floatNA64(x::FloatNA64)   = x

floatNA32(x::AbstractArray) = copy_to(similar(x,FloatNA32), x)
floatNA64(x::AbstractArray) = copy_to(similar(x,FloatNA64), x)
floatNA  (x::AbstractArray) = copy_to(similar(x,typeof(floatNA(one(eltype(x))))), x)
floatNA32(x::AbstractArray{Float32}) = reinterpret(FloatNA32, x, size(x))
floatNA64(x::AbstractArray{Float64}) = reinterpret(FloatNA64, x, size(x))
floatNA(x::AbstractArray{Float64}) = reinterpret(FloatNA64, x, size(x))


## conversions from floating-point ##

if WORD_SIZE == 64
    iround(x::FloatNA32) = iround(float64(x))
    itrunc(x::FloatNA32) = itrunc(float64(x))
else
    iround(x::FloatNA32) = box(Int32,fpsiround32(unbox(FloatNA32,x)))
    itrunc(x::FloatNA32) = box(Int32,fptosi32(unbox(FloatNA32,x)))
end
iround(x::FloatNA64) = box(Int64,fpsiround64(unbox(FloatNA64,x)))
itrunc(x::FloatNA64) = box(Int64,fptosi64(unbox(FloatNA64,x)))

iround(::Type{IntNA8},  x::FloatNA32) = box(IntNA8,trunc8(fpsiround32(unbox(FloatNA32,x))))
iround(::Type{IntNA8},  x::FloatNA64) = box(IntNA8,trunc8(fpsiround64(unbox(FloatNA64,x))))
iround(::Type{IntNA16}, x::FloatNA32) = box(IntNA16,trunc16(fpsiround32(unbox(FloatNA32,x))))
iround(::Type{IntNA16}, x::FloatNA64) = box(IntNA16,trunc16(fpsiround64(unbox(FloatNA64,x))))
iround(::Type{IntNA32}, x::FloatNA32) = box(IntNA32,fpsiround32(unbox(FloatNA32,x)))
iround(::Type{IntNA32}, x::FloatNA64) = box(IntNA32,trunc32(fpsiround64(unbox(FloatNA64,x))))
iround(::Type{IntNA64}, x::FloatNA32) = box(IntNA64,fpsiround64(fpext64(unbox(FloatNA32,x))))
iround(::Type{IntNA64}, x::FloatNA64) = box(IntNA64,fpsiround64(unbox(FloatNA64,x)))
# TODO: Int128

# this is needed very early because it is used by Range and colon
floor(x::FloatNA64) = ccall(dlsym(_jl_libfdm,:floor), FloatNA64, (FloatNA64,), x)

iceil(x::FloatNA)  = itrunc(ceil(x))  # TODO: fast primitive for iceil
ifloor(x::FloatNA) = itrunc(floor(x)) # TOOD: fast primitive for ifloor

## floating point promotions ##

promote_rule(::Type{FloatNA32}, ::Type{Float32}) = FloatNA32
promote_rule(::Type{FloatNA32}, ::Type{Float64}) = FloatNA64
promote_rule(::Type{FloatNA64}, ::Type{Float32}) = FloatNA64
promote_rule(::Type{FloatNA64}, ::Type{Float64}) = FloatNA64

promote_rule(::Type{FloatNA64}, ::Type{FloatNA32}) = FloatNA64

promote_rule(::Type{FloatNA32}, ::Type{IntNA8} ) = FloatNA32
promote_rule(::Type{FloatNA32}, ::Type{IntNA16}) = FloatNA32
promote_rule(::Type{FloatNA32}, ::Type{IntNA32}) = FloatNA64
promote_rule(::Type{FloatNA32}, ::Type{IntNA64}) = FloatNA64 # TODO: should be FloatNA80

promote_rule(::Type{FloatNA64}, ::Type{IntNA8} ) = FloatNA64
promote_rule(::Type{FloatNA64}, ::Type{IntNA16}) = FloatNA64
promote_rule(::Type{FloatNA64}, ::Type{IntNA32}) = FloatNA64
promote_rule(::Type{FloatNA64}, ::Type{IntNA64}) = FloatNA64 # TODO: should be FloatNA80

promote_rule(::Type{FloatNA32}, ::Type{Int8} ) = FloatNA32
promote_rule(::Type{FloatNA32}, ::Type{Int16}) = FloatNA32
promote_rule(::Type{FloatNA32}, ::Type{Int32}) = FloatNA64
promote_rule(::Type{FloatNA32}, ::Type{Int64}) = FloatNA64 # TODO: should be FloatNA80

promote_rule(::Type{FloatNA64}, ::Type{Int8} ) = FloatNA64
promote_rule(::Type{FloatNA64}, ::Type{Int16}) = FloatNA64
promote_rule(::Type{FloatNA64}, ::Type{Int32}) = FloatNA64
promote_rule(::Type{FloatNA64}, ::Type{Int64}) = FloatNA64 # TODO: should be FloatNA80

promote_rule(::Type{FloatNA32}, ::Type{Uint8} ) = FloatNA32
promote_rule(::Type{FloatNA32}, ::Type{Uint16}) = FloatNA32
promote_rule(::Type{FloatNA32}, ::Type{Uint32}) = FloatNA64
promote_rule(::Type{FloatNA32}, ::Type{Uint64}) = FloatNA64 # TODO: should be FloatNA80

promote_rule(::Type{FloatNA64}, ::Type{Uint8} ) = FloatNA64
promote_rule(::Type{FloatNA64}, ::Type{Uint16}) = FloatNA64
promote_rule(::Type{FloatNA64}, ::Type{Uint32}) = FloatNA64
promote_rule(::Type{FloatNA64}, ::Type{Uint64}) = FloatNA64 # TODO: should be FloatNA80

promote_rule(::Type{FloatNA32}, ::Type{Char}) = FloatNA32
promote_rule(::Type{FloatNA64}, ::Type{Char}) = FloatNA64

morebits(::Type{FloatNA32}) = FloatNA64

## floating point arithmetic ##

-(x::FloatNA32) = box(FloatNA32,neg_float(unbox(FloatNA32,x)))
-(x::FloatNA64) = box(FloatNA64,neg_float(unbox(FloatNA64,x)))
+(x::FloatNA32, y::FloatNA32) = box(FloatNA32,add_float(unbox(FloatNA32,x),unbox(FloatNA32,y)))
+(x::FloatNA64, y::FloatNA64) = box(FloatNA64,add_float(unbox(FloatNA64,x),unbox(FloatNA64,y)))
-(x::FloatNA32, y::FloatNA32) = box(FloatNA32,sub_float(unbox(FloatNA32,x),unbox(FloatNA32,y)))
-(x::FloatNA64, y::FloatNA64) = box(FloatNA64,sub_float(unbox(FloatNA64,x),unbox(FloatNA64,y)))
*(x::FloatNA32, y::FloatNA32) = box(FloatNA32,mul_float(unbox(FloatNA32,x),unbox(FloatNA32,y)))
*(x::FloatNA64, y::FloatNA64) = box(FloatNA64,mul_float(unbox(FloatNA64,x),unbox(FloatNA64,y)))
/(x::FloatNA32, y::FloatNA32) = box(FloatNA32,div_float(unbox(FloatNA32,x),unbox(FloatNA32,y)))
/(x::FloatNA64, y::FloatNA64) = box(FloatNA64,div_float(unbox(FloatNA64,x),unbox(FloatNA64,y)))

# TODO: faster floating point div?
# TODO: faster floating point fld?
# TODO: faster floating point mod?

rem(x::FloatNA32, y::FloatNA32) = box(FloatNA32,rem_float(unbox(FloatNA32,x),unbox(FloatNA32,y)))
rem(x::FloatNA64, y::FloatNA64) = box(FloatNA64,rem_float(unbox(FloatNA64,x),unbox(FloatNA64,y)))

## floating point comparisons ##

==(x::FloatNA32, y::FloatNA32) = eq_float(unbox(FloatNA32,x),unbox(FloatNA32,y))
==(x::FloatNA64, y::FloatNA64) = eq_float(unbox(FloatNA64,x),unbox(FloatNA64,y))
!=(x::FloatNA32, y::FloatNA32) = isna(x) || isna(y) ? NA_Bool : ne_float(unbox(FloatNA32,x),unbox(FloatNA32,y))
!=(x::FloatNA64, y::FloatNA64) = isna(x) || isna(y) ? NA_Bool : ne_float(unbox(FloatNA64,x),unbox(FloatNA64,y))
< (x::FloatNA32, y::FloatNA32) = isna(x) || isna(y) ? NA_Bool : lt_float(unbox(FloatNA32,x),unbox(FloatNA32,y))
< (x::FloatNA64, y::FloatNA64) = isna(x) || isna(y) ? NA_Bool : lt_float(unbox(FloatNA64,x),unbox(FloatNA64,y))
<=(x::FloatNA32, y::FloatNA32) = isna(x) || isna(y) ? NA_Bool : le_float(unbox(FloatNA32,x),unbox(FloatNA32,y))
<=(x::FloatNA64, y::FloatNA64) = isna(x) || isna(y) ? NA_Bool : le_float(unbox(FloatNA64,x),unbox(FloatNA64,y))

isequal(x::FloatNA32, y::FloatNA32) = fpiseq32(unbox(FloatNA32,x),unbox(FloatNA32,y))
isequal(x::FloatNA64, y::FloatNA64) = fpiseq64(unbox(FloatNA64,x),unbox(FloatNA64,y))
isless (x::FloatNA32, y::FloatNA32) = isna(x) || isna(y) ? NA_Bool : fpislt32(unbox(FloatNA32,x),unbox(FloatNA32,y))
isless (x::FloatNA64, y::FloatNA64) = isna(x) || isna(y) ? NA_Bool : fpislt64(unbox(FloatNA64,x),unbox(FloatNA64,y))

isequal(a::Integer, b::FloatNA) = (a==b) & isequal(float(a),b)
isequal(a::FloatNA, b::Integer) = isequal(b, a)
isless (a::Integer, b::FloatNA) = (a<b) | isless(float(a),b)
isless (a::FloatNA, b::Integer) = (a<b) | isless(a,float(b))

==(x::FloatNA64, y::IntNA64  ) = eqfsi64(unbox(FloatNA64,x),unbox(IntNA64,y))
==(x::IntNA64  , y::FloatNA64) = eqfsi64(unbox(FloatNA64,y),unbox(IntNA64,x))

==(x::FloatNA32, y::IntNA64  ) = eqfsi64(unbox(FloatNA64,floatNA64(x)),unbox(IntNA64,y))
==(x::IntNA64  , y::FloatNA32) = eqfsi64(unbox(FloatNA64,floatNA64(y)),unbox(IntNA64,x))

< (x::FloatNA64, y::IntNA64  ) = isna(x) || isna(y) ? NA_Bool : ltfsi64(unbox(FloatNA64,x),unbox(IntNA64,y))
< (x::IntNA64  , y::FloatNA64) = isna(x) || isna(y) ? NA_Bool : ltsif64(unbox(IntNA64,x),unbox(FloatNA64,y))

< (x::FloatNA32, y::IntNA64  ) = isna(x) || isna(y) ? NA_Bool : ltfsi64(unbox(FloatNA64,float64(x)),unbox(IntNA64,y))
< (x::IntNA64  , y::FloatNA32) = isna(x) || isna(y) ? NA_Bool : ltsif64(unbox(IntNA64,x),unbox(FloatNA64,floatNA64(y)))

<=(x::FloatNA64, y::IntNA64  ) = isna(x) || isna(y) ? NA_Bool : lefsi64(unbox(FloatNA64,x),unbox(IntNA64,y))
<=(x::IntNA64  , y::FloatNA64) = isna(x) || isna(y) ? NA_Bool : lesif64(unbox(IntNA64,x),unbox(FloatNA64,y))

<=(x::FloatNA32, y::IntNA64  ) = isna(x) || isna(y) ? NA_Bool : lefsi64(unbox(FloatNA64,floatNA64(x)),unbox(IntNA64,y))
<=(x::IntNA64  , y::FloatNA32) = isna(x) || isna(y) ? NA_Bool : lesif64(unbox(IntNA64,x),unbox(FloatNA64,floatNA64(y)))

==(x::FloatNA64, y::Int64  ) = eqfsi64(unbox(FloatNA64,x),unbox(Int64,y))
==(x::FloatNA64, y::Uint64 ) = eqfui64(unbox(FloatNA64,x),unbox(Uint64,y))
==(x::Int64  , y::FloatNA64) = eqfsi64(unbox(FloatNA64,y),unbox(Int64,x))
==(x::Uint64 , y::FloatNA64) = eqfui64(unbox(FloatNA64,y),unbox(Uint64,x))

==(x::FloatNA32, y::Int64  ) = eqfsi64(unbox(FloatNA64,float64(x)),unbox(Int64,y))
==(x::FloatNA32, y::Uint64 ) = eqfui64(unbox(FloatNA64,float64(x)),unbox(Uint64,y))
==(x::Int64  , y::FloatNA32) = eqfsi64(unbox(FloatNA64,float64(y)),unbox(Int64,x))
==(x::Uint64 , y::FloatNA32) = eqfui64(unbox(FloatNA64,float64(y)),unbox(Uint64,x))

< (x::FloatNA64, y::Int64  ) = ltfsi64(unbox(FloatNA64,x),unbox(Int64,y))
< (x::FloatNA64, y::Uint64 ) = ltfui64(unbox(FloatNA64,x),unbox(Uint64,y))
< (x::Int64  , y::FloatNA64) = ltsif64(unbox(Int64,x),unbox(FloatNA64,y))
< (x::Uint64 , y::FloatNA64) = ltuif64(unbox(Uint64,x),unbox(FloatNA64,y))

< (x::FloatNA32, y::Int64  ) = ltfsi64(unbox(FloatNA64,floatNA64(x)),unbox(Int64,y))
< (x::FloatNA32, y::Uint64 ) = ltfui64(unbox(FloatNA64,floatNA64(x)),unbox(Uint64,y))
< (x::Int64  , y::FloatNA32) = ltsif64(unbox(Int64,x),unbox(FloatNA64,floatNA64(y)))
< (x::Uint64 , y::FloatNA32) = ltuif64(unbox(Uint64,x),unbox(FloatNA64,floatNA64(y)))

<=(x::FloatNA64, y::Int64  ) = lefsi64(unbox(FloatNA64,x),unbox(Int64,y))
<=(x::FloatNA64, y::Uint64 ) = lefui64(unbox(FloatNA64,x),unbox(Uint64,y))
<=(x::Int64  , y::FloatNA64) = lesif64(unbox(Int64,x),unbox(FloatNA64,y))
<=(x::Uint64 , y::FloatNA64) = leuif64(unbox(Uint64,x),unbox(FloatNA64,y))

<=(x::FloatNA32, y::Int64  ) = lefsi64(unbox(FloatNA64,floatNA64(x)),unbox(Int64,y))
<=(x::FloatNA32, y::Uint64 ) = lefui64(unbox(FloatNA64,floatNA64(x)),unbox(Uint64,y))
<=(x::Int64  , y::FloatNA32) = lesif64(unbox(Int64,x),unbox(FloatNA64,floatNA64(y)))
<=(x::Uint64 , y::FloatNA32) = leuif64(unbox(Uint64,x),unbox(FloatNA64,floatNA64(y)))

## floating point traits ##

## const Inf32 = box(FloatNA32,unbox(Uint32,0x7f800000))
## const NaN32 = box(FloatNA32,unbox(Uint32,0x7fc00000))
## const Inf = box(FloatNA64,unbox(Uint64,0x7ff0000000000000))
## const NaN = box(FloatNA64,unbox(Uint64,0x7ff8000000000000))

@eval begin
    inf(::Type{FloatNA32}) = $Inf32
    nan(::Type{FloatNA32}) = $NaN32
    inf(::Type{FloatNA64}) = $Inf
    nan(::Type{FloatNA64}) = $NaN
    inf{T<:FloatNA}(x::T) = inf(T)
    nan{T<:FloatNA}(x::T) = nan(T)

    isdenormal(x::FloatNA32) = (abs(x) < $box(FloatNA32,unbox(Uint32,0x00800000)))
    isdenormal(x::FloatNA64) = (abs(x) < $box(FloatNA64,unbox(Uint64,0x0010000000000000)))

    typemin(::Type{FloatNA32}) = $(-Inf32)
    typemax(::Type{FloatNA32}) = $(Inf32)
    typemin(::Type{FloatNA64}) = $(-Inf)
    typemax(::Type{FloatNA64}) = $(Inf)
    typemin{T<:Real}(x::T) = typemin(T)
    typemax{T<:Real}(x::T) = typemax(T)

    realmin(::Type{FloatNA32}) = $box(FloatNA32,unbox(Uint32,0x00800000))
    realmin(::Type{FloatNA64}) = $box(FloatNA64,unbox(Uint64,0x0010000000000000))
    realmax(::Type{FloatNA32}) = $box(FloatNA32,unbox(Uint32,0x7f7fffff))
    realmax(::Type{FloatNA64}) = $box(FloatNA64,unbox(Uint64,0x7fefffffffffffff))
    realmin{T<:FloatNA}(x::T) = realmin(T)
    realmax{T<:FloatNA}(x::T) = realmax(T)
    realmin() = realmin(FloatNA64)
    realmax() = realmax(FloatNA64)

    nextfloat(x::FloatNA32, i::Integer) = box(FloatNA32,add_int(unbox(FloatNA32,x),unbox(Int32,int32(i))))
    nextfloat(x::FloatNA64, i::Integer) = box(FloatNA64,add_int(unbox(FloatNA64,x),unbox(Int64,int64(i))))
    nextfloat(x::FloatNA) = nextfloat(x,1)
    prevfloat(x::FloatNA) = nextfloat(x,-1)

    eps(x::FloatNA) = isfinite(x) ? abs(nextfloat(x)-x) : nan(x)
    eps(::Type{FloatNA32}) = $box(FloatNA32,unbox(Uint32,0x34000000))
    eps(::Type{FloatNA64}) = $box(FloatNA64,unbox(Uint64,0x3cb0000000000000))
end

sizeof(::Type{FloatNA32}) = 4
sizeof(::Type{FloatNA64}) = 8

## byte order swaps for arbitrary-endianness serialization/deserialization ##
bswap(x::FloatNA32) = box(FloatNA32,bswap_int(unbox(FloatNA32,x)))
bswap(x::FloatNA64) = box(FloatNA64,bswap_int(unbox(FloatNA64,x)))

##
## functions from floatfuncs.jl
##

abs(x::FloatNA64) = box(FloatNA64,abs_float(unbox(FloatNA64,x)))
abs(x::FloatNA32) = box(FloatNA32,abs_float(unbox(FloatNA32,x)))

##
## functions from sort.jl
##

_jl_fp_pos_lt(x::FloatNA32, y::FloatNA32) = isna(x) || isna(y) ? NA_Float32 : slt_int(unbox(FloatNA32,x),unbox(FloatNA32,y))
_jl_fp_pos_lt(x::FloatNA64, y::FloatNA64) = isna(x) || isna(y) ? NA_Float64 : slt_int(unbox(FloatNA64,x),unbox(FloatNA64,y))
_jl_fp_pos_le(x::FloatNA32, y::FloatNA32) = isna(x) || isna(y) ? NA_Float32 : sle_int(unbox(FloatNA32,x),unbox(FloatNA32,y))
_jl_fp_pos_le(x::FloatNA64, y::FloatNA64) = isna(x) || isna(y) ? NA_Float64 : sle_int(unbox(FloatNA64,x),unbox(FloatNA64,y))

_jl_fp_neg_lt(x::FloatNA32, y::FloatNA32) = isna(x) || isna(y) ? NA_Float32 : slt_int(unbox(Float32,y),unbox(Float32,x))
_jl_fp_neg_lt(x::FloatNA64, y::FloatNA64) = isna(x) || isna(y) ? NA_Float64 : slt_int(unbox(Float64,y),unbox(Float64,x))
_jl_fp_neg_le(x::FloatNA32, y::FloatNA32) = isna(x) || isna(y) ? NA_Float32 : sle_int(unbox(Float32,y),unbox(Float32,x))
_jl_fp_neg_le(x::FloatNA64, y::FloatNA64) = isna(x) || isna(y) ? NA_Float64 : sle_int(unbox(Float64,y),unbox(Float64,x))

##
## printing
##

show{T<:FloatNA}(io, n::T) = isna(n) ? show(io, NA) : show(io, basetype(n))
