


abstract SignedNA <: Signed

bitstype 8   IntNA8    <: SignedNA
bitstype 16  IntNA16   <: SignedNA
bitstype 32  IntNA32   <: SignedNA
bitstype 64  IntNA64   <: SignedNA
bitstype 128 IntNA128  <: SignedNA

if is(Int,Int64)
    typealias IntNA IntNA64
else
    typealias IntNA IntNA32
end

intNA(x) = convert(IntNA, x)
intNA(x::IntNA) = x

intNA(x::AbstractArray) = copy_to(similar(x,IntNA), x)
intNA(x::AbstractArray{Int}) = reinterpret(IntNA, x, size(x))

## integer conversions ##

convert{T <: SignedNA}(::Type{T}, x::NAtype) = na(T)

convert(::Type{IntNA8}, x::IntNA16  ) = isna(x) ? NA_Int8 : box(IntNA8,trunc8(unbox(Int16,x)))
convert(::Type{IntNA8}, x::IntNA32  ) = isna(x) ? NA_Int8 : box(IntNA8,trunc8(unbox(Int32,x)))
convert(::Type{IntNA8}, x::IntNA64  ) = isna(x) ? NA_Int8 : box(IntNA8,trunc8(unbox(Int64,x)))
convert(::Type{IntNA8}, x::IntNA128 ) = isna(x) ? NA_Int8 : box(IntNA8,trunc8(unbox(Int128,x)))

convert(::Type{IntNA8}, x::Bool   ) = box(IntNA8,unbox(Bool,x))
convert(::Type{IntNA8}, x::Int8  )  = box(IntNA8,unbox(Int8,x))
convert(::Type{IntNA8}, x::Uint8  ) = box(IntNA8,unbox(Uint8,x))
convert(::Type{IntNA8}, x::Int16  ) = box(IntNA8,trunc8(unbox(Int16,x)))
convert(::Type{IntNA8}, x::Uint16 ) = box(IntNA8,trunc8(unbox(Uint16,x)))
convert(::Type{IntNA8}, x::Char   ) = box(IntNA8,trunc8(unbox(Char,x)))
convert(::Type{IntNA8}, x::Int32  ) = box(IntNA8,trunc8(unbox(Int32,x)))
convert(::Type{IntNA8}, x::Uint32 ) = box(IntNA8,trunc8(unbox(Uint32,x)))
convert(::Type{IntNA8}, x::Int64  ) = box(IntNA8,trunc8(unbox(Int64,x)))
convert(::Type{IntNA8}, x::Uint64 ) = box(IntNA8,trunc8(unbox(Uint64,x)))
convert(::Type{IntNA8}, x::Int128 ) = box(IntNA8,trunc8(unbox(Int128,x)))
convert(::Type{IntNA8}, x::Uint128) = box(IntNA8,trunc8(unbox(Uint128,x)))
convert(::Type{IntNA8}, x::Float32) = box(IntNA8,trunc8(checked_fptosi32(unbox(Float32,x))))
convert(::Type{IntNA8}, x::Float64) = box(IntNA8,trunc8(checked_fptosi64(unbox(Float64,x))))

convert(::Type{IntNA16}, x::IntNA8   ) = isna(x) ? NA_Int16 : box(IntNA16,sext16(unbox(Int8,x)))
convert(::Type{IntNA16}, x::IntNA32  ) = isna(x) ? NA_Int16 : box(IntNA16,trunc16(unbox(Int32,x)))
convert(::Type{IntNA16}, x::IntNA64  ) = isna(x) ? NA_Int16 : box(IntNA16,trunc16(unbox(Int64,x)))
convert(::Type{IntNA16}, x::IntNA128 ) = isna(x) ? NA_Int16 : box(IntNA16,trunc16(unbox(Int128,x)))

convert(::Type{IntNA16}, x::Bool   ) = box(IntNA16,zext16(unbox(Bool,x)))
convert(::Type{IntNA16}, x::Int8   ) = box(IntNA16,sext16(unbox(Int8,x)))
convert(::Type{IntNA16}, x::Uint8  ) = box(IntNA16,zext16(unbox(Uint8,x)))
convert(::Type{IntNA16}, x::Int16 )  = box(IntNA16,unbox(Int16,x))
convert(::Type{IntNA16}, x::Uint16 ) = box(IntNA16,unbox(Uint16,x))
convert(::Type{IntNA16}, x::Char   ) = box(IntNA16,trunc16(unbox(Char,x)))
convert(::Type{IntNA16}, x::Int32  ) = box(IntNA16,trunc16(unbox(Int32,x)))
convert(::Type{IntNA16}, x::Uint32 ) = box(IntNA16,trunc16(unbox(Uint32,x)))
convert(::Type{IntNA16}, x::Int64  ) = box(IntNA16,trunc16(unbox(Int64,x)))
convert(::Type{IntNA16}, x::Uint64 ) = box(IntNA16,trunc16(unbox(Uint64,x)))
convert(::Type{IntNA16}, x::Int128 ) = box(IntNA16,trunc16(unbox(Int128,x)))
convert(::Type{IntNA16}, x::Uint128) = box(IntNA16,trunc16(unbox(Uint128,x)))
convert(::Type{IntNA16}, x::Float32) = isna(x) ? NA_Int16 : box(IntNA16,trunc16(checked_fptosi32(unbox(Float32,x))))
convert(::Type{IntNA16}, x::Float64) = isna(x) ? NA_Int16 : box(IntNA16,trunc16(checked_fptosi64(unbox(Float64,x))))

convert(::Type{IntNA32}, x::IntNA8   ) = isna(x) ? NA_Int32 : box(IntNA32,sext32(unbox(Int8,x)))
convert(::Type{IntNA32}, x::IntNA16  ) = isna(x) ? NA_Int32 : box(IntNA32,sext32(unbox(Int16,x)))
convert(::Type{IntNA32}, x::IntNA64  ) = isna(x) ? NA_Int32 : box(IntNA32,trunc32(unbox(Int64,x)))
convert(::Type{IntNA32}, x::IntNA128 ) = isna(x) ? NA_Int32 : box(IntNA32,trunc32(unbox(Int128,x)))

convert(::Type{IntNA32}, x::Bool   ) = box(IntNA32,zext32(unbox(Bool,x)))
convert(::Type{IntNA32}, x::Int8   ) = box(IntNA32,sext32(unbox(Int8,x)))
convert(::Type{IntNA32}, x::Uint8  ) = box(IntNA32,zext32(unbox(Uint8,x)))
convert(::Type{IntNA32}, x::Int16  ) = box(IntNA32,sext32(unbox(Int16,x)))
convert(::Type{IntNA32}, x::Uint16 ) = box(IntNA32,zext32(unbox(Uint16,x)))
convert(::Type{IntNA32}, x::Char   ) = box(IntNA32,unbox(Char,x))
convert(::Type{IntNA32}, x::Int32 )  = box(IntNA32,unbox(Int32,x))
convert(::Type{IntNA32}, x::Uint32 ) = box(IntNA32,unbox(Uint32,x))
convert(::Type{IntNA32}, x::Int64  ) = box(IntNA32,trunc32(unbox(Int64,x)))
convert(::Type{IntNA32}, x::Uint64 ) = box(IntNA32,trunc32(unbox(Uint64,x)))
convert(::Type{IntNA32}, x::Int128 ) = box(IntNA32,trunc32(unbox(Int128,x)))
convert(::Type{IntNA32}, x::Uint128) = box(IntNA32,trunc32(unbox(Uint128,x)))
convert(::Type{IntNA32}, x::Float32) = isna(x) ? NA_Int32 : box(IntNA32,checked_fptosi32(unbox(Float32,x)))
convert(::Type{IntNA32}, x::Float64) = isna(x) ? NA_Int32 : box(IntNA32,trunc32(checked_fptosi64(unbox(Float64,x))))

convert(::Type{IntNA64}, x::IntNA8   ) = isna(x) ? NA_Int64 : box(IntNA64,sext64(unbox(Int8,x)))
convert(::Type{IntNA64}, x::IntNA16  ) = isna(x) ? NA_Int64 : box(IntNA64,sext64(unbox(Int16,x)))
convert(::Type{IntNA64}, x::IntNA32  ) = isna(x) ? NA_Int64 : box(IntNA64,sext64(unbox(Int32,x)))
convert(::Type{IntNA64}, x::IntNA128 ) = isna(x) ? NA_Int64 : box(IntNA64,trunc64(unbox(Int128,x)))

convert(::Type{IntNA64}, x::Bool   ) = box(IntNA64,zext64(unbox(Bool,x)))
convert(::Type{IntNA64}, x::Int8   ) = box(IntNA64,sext64(unbox(Int8,x)))
convert(::Type{IntNA64}, x::Uint8  ) = box(IntNA64,zext64(unbox(Uint8,x)))
convert(::Type{IntNA64}, x::Int16  ) = box(IntNA64,sext64(unbox(Int16,x)))
convert(::Type{IntNA64}, x::Uint16 ) = box(IntNA64,zext64(unbox(Uint16,x)))
convert(::Type{IntNA64}, x::Char   ) = box(IntNA64,zext64(unbox(Char,x)))
convert(::Type{IntNA64}, x::Int32  ) = box(IntNA64,sext64(unbox(Int32,x)))
convert(::Type{IntNA64}, x::Uint32 ) = box(IntNA64,zext64(unbox(Uint32,x)))
convert(::Type{IntNA64}, x::Int64 )  = box(IntNA64,unbox(Int64,x))
convert(::Type{IntNA64}, x::Uint64 ) = box(IntNA64,unbox(Uint64,x))
convert(::Type{IntNA64}, x::Int128 ) = box(IntNA64,trunc64(unbox(Int128,x)))
convert(::Type{IntNA64}, x::Uint128) = box(IntNA64,trunc64(unbox(Uint128,x)))
convert(::Type{IntNA64}, x::Float32) = isna(x) ? NA_Int64 : box(IntNA64,checked_fptosi64(fpext64(unbox(Float32,x))))
convert(::Type{IntNA64}, x::Float64) = isna(x) ? NA_Int64 : box(IntNA64,checked_fptosi64(unbox(Float64,x)))

convert(::Type{IntNA128}, x::IntNA8   ) = isna(x) ? NA_Int128 : box(IntNA128,sext_int(Int128,unbox(Int8,x)))
convert(::Type{IntNA128}, x::IntNA16  ) = isna(x) ? NA_Int128 : box(IntNA128,sext_int(Int128,unbox(Int16,x)))
convert(::Type{IntNA128}, x::IntNA32  ) = isna(x) ? NA_Int128 : box(IntNA128,sext_int(Int128,unbox(Int32,x)))
convert(::Type{IntNA128}, x::IntNA64  ) = isna(x) ? NA_Int128 : box(IntNA128,sext_int(Int128,unbox(Int64,x)))

convert(::Type{IntNA128}, x::Bool   ) = box(IntNA128,zext_int(Int128,unbox(Bool,x)))
convert(::Type{IntNA128}, x::Int8   ) = box(IntNA128,sext_int(Int128,unbox(Int8,x)))
convert(::Type{IntNA128}, x::Uint8  ) = box(IntNA128,zext_int(Uint128,unbox(Uint8,x)))
convert(::Type{IntNA128}, x::Int16  ) = box(IntNA128,sext_int(Int128,unbox(Int16,x)))
convert(::Type{IntNA128}, x::Uint16 ) = box(IntNA128,zext_int(Uint128,unbox(Uint16,x)))
convert(::Type{IntNA128}, x::Char   ) = box(IntNA128,zext_int(Uint128,unbox(Char,x)))
convert(::Type{IntNA128}, x::Int32  ) = box(IntNA128,sext_int(Int128,unbox(Int32,x)))
convert(::Type{IntNA128}, x::Uint32 ) = box(IntNA128,zext_int(Uint128,unbox(Uint32,x)))
convert(::Type{IntNA128}, x::Int64  ) = box(IntNA128,sext_int(Int128,unbox(Int64,x)))
convert(::Type{IntNA128}, x::Uint64 ) = box(IntNA128,zext_int(Uint128,unbox(Uint64,x)))
convert(::Type{IntNA128}, x::Int128)  = box(IntNA128,unbox(Int128,x))
convert(::Type{IntNA128}, x::Uint128) = box(IntNA128,unbox(Uint128,x))
# TODO: convert(::Type{IntNA128}, x::Float32)
# TODO: convert(::Type{IntNA128}, x::Float64)

convert(::Type{Int64}, x::IntNA8   ) = box(Int64,sext64(unbox(IntNA8,x)))
convert(::Type{Int64}, x::IntNA16  ) = box(Int64,sext64(unbox(IntNA16,x)))
convert(::Type{Int64}, x::IntNA32  ) = box(Int64,sext64(unbox(IntNA32,x)))
convert(::Type{Int64}, x::IntNA64 )  = box(Int64,unbox(IntNA64,x))
convert(::Type{Int64}, x::IntNA128 ) = box(Int64,trunc64(unbox(IntNA128,x)))

convert(::Type{Int8},   x::IntNA8  ) = box(Int8,  (unbox(IntNA8,   x)))
convert(::Type{Int16},  x::IntNA16 ) = box(Int16, (unbox(IntNA16,  x)))
convert(::Type{Int32},  x::IntNA32 ) = box(Int32, (unbox(IntNA32,  x)))
convert(::Type{Int64},  x::IntNA64 ) = box(Int64, (unbox(IntNA64,  x)))
convert(::Type{Int128}, x::IntNA128) = box(Int128,(unbox(IntNA128, x)))

convert(::Type{SignedNA}, x::Int8  ) = convert(IntNA,x)
convert(::Type{SignedNA}, x::Int16 ) = convert(IntNA,x)
convert(::Type{SignedNA}, x::Int32 ) = convert(IntNA,x)
convert(::Type{SignedNA}, x::Int64 ) = convert(IntNA64,x)
convert(::Type{SignedNA}, x::Int128) = convert(IntNA128,x)

convert(::Type{Float32}, x::IntNA8)    = isna(x) ? NA_Float32 : box(Float32,sitofp32(unbox(IntNA8,x)))
convert(::Type{Float32}, x::IntNA16)   = isna(x) ? NA_Float32 : box(Float32,sitofp32(unbox(IntNA16,x)))
convert(::Type{Float32}, x::IntNA32)   = isna(x) ? NA_Float32 : box(Float32,sitofp32(unbox(IntNA32,x)))
convert(::Type{Float32}, x::IntNA64)   = isna(x) ? NA_Float32 : box(Float32,sitofp32(unbox(IntNA64,x)))

convert(::Type{Float64}, x::IntNA8)    = isna(x) ? NA_Float64 : box(Float64,sitofp64(unbox(IntNA8,x)))
convert(::Type{Float64}, x::IntNA16)   = isna(x) ? NA_Float64 : box(Float64,sitofp64(unbox(IntNA16,x)))
convert(::Type{Float64}, x::IntNA32)   = isna(x) ? NA_Float64 : box(Float64,sitofp64(unbox(IntNA32,x)))
convert(::Type{Float64}, x::IntNA64)   = isna(x) ? NA_Float64 : box(Float64,sitofp64(unbox(IntNA64,x)))

convert(::Type{Float}, x::IntNA8)   = isna(x) ? NA_Float64 : convert(Float32, x)
convert(::Type{Float}, x::IntNA16)  = isna(x) ? NA_Float64 : convert(Float32, x)
convert(::Type{Float}, x::IntNA32)  = isna(x) ? NA_Float64 : convert(Float64, x)
convert(::Type{Float}, x::IntNA64)  = isna(x) ? NA_Float64 : convert(Float64, x) # LOSSY



intNA8(x)   = convert(IntNA8,x)
intNA16(x)  = convert(IntNA16,x)
intNA32(x)  = convert(IntNA32,x)
intNA64(x)  = convert(IntNA64,x)
intNA128(x) = convert(IntNA128,x)

intNA8  (x::AbstractArray) = copy_to(similar(x,IntNA8  ), x)
intNA16 (x::AbstractArray) = copy_to(similar(x,IntNA16 ), x)
intNA32 (x::AbstractArray) = copy_to(similar(x,IntNA32 ), x)
intNA64 (x::AbstractArray) = copy_to(similar(x,IntNA64 ), x)
intNA128(x::AbstractArray) = copy_to(similar(x,IntNA128), x)
intNA8  {N}(x::AbstractArray{Int8  ,N}) = reinterpret(IntNA8  , x, size(x))
intNA16 {N}(x::AbstractArray{Int16 ,N}) = reinterpret(IntNA16 , x, size(x))
intNA32 {N}(x::AbstractArray{Int32 ,N}) = reinterpret(IntNA32 , x, size(x))
intNA64 {N}(x::AbstractArray{Int64 ,N}) = reinterpret(IntNA64 , x, size(x))
intNA128{N}(x::AbstractArray{Int128,N}) = reinterpret(IntNA128, x, size(x))



morebits(::Type{IntNA8})  = IntNA16
morebits(::Type{IntNA16}) = IntNA32
morebits(::Type{IntNA32}) = IntNA64
morebits(::Type{IntNA64}) = IntNA128

## integer arithmetic ##

-(x::SignedNA) = -intNA(x)

+{T<:SignedNA}(x::T, y::T) = isna(x) || isna(y) ? NA_Int : intNA(x) + intNA(y)
-{T<:SignedNA}(x::T, y::T) = isna(x) || isna(y) ? NA_Int : intNA(x) - intNA(y)
*{T<:SignedNA}(x::T, y::T) = isna(x) || isna(y) ? NA_Int : intNA(x) * intNA(y)

-(x::IntNA)     = box(IntNA,neg_int(unbox(IntNA,x)))
-(x::IntNA64)   = box(IntNA64,neg_int(unbox(IntNA64,x)))
-(x::IntNA128)  = box(IntNA128,neg_int(unbox(IntNA128,x)))

+(x::IntNA,     y::IntNA)     = isna(x) || isna(y) ? NA_Int : box(IntNA,add_int(unbox(IntNA,x),unbox(IntNA,y)))
+(x::IntNA64,   y::IntNA64)   = isna(x) || isna(y) ? NA_Int64 : box(IntNA64,add_int(unbox(IntNA64,x),unbox(IntNA64,y)))
+(x::IntNA128,  y::IntNA128)  = isna(x) || isna(y) ? NA_Int128 : box(IntNA128,add_int(unbox(IntNA128,x),unbox(IntNA128,y)))

-(x::IntNA,     y::IntNA)     = isna(x) || isna(y) ? NA_Int : box(IntNA,sub_int(unbox(IntNA,x),unbox(IntNA,y)))
-(x::IntNA64,   y::IntNA64)   = isna(x) || isna(y) ? NA_Int64 : box(IntNA64,sub_int(unbox(IntNA64,x),unbox(IntNA64,y)))
-(x::IntNA128,  y::IntNA128)  = isna(x) || isna(y) ? NA_Int128 : box(IntNA128,sub_int(unbox(IntNA128,x),unbox(IntNA128,y)))

*(x::IntNA,     y::IntNA)     = isna(x) || isna(y) ? NA_Int : box(IntNA,mul_int(unbox(IntNA,x),unbox(IntNA,y)))
*(x::IntNA64,   y::IntNA64)   = isna(x) || isna(y) ? NA_Int64 : box(IntNA64,mul_int(unbox(IntNA64,x),unbox(IntNA64,y)))
*(x::IntNA128,  y::IntNA128)  = isna(x) || isna(y) ? NA_Int128 : box(IntNA128,mul_int(unbox(IntNA128,x),unbox(IntNA128,y)))

/(x::SignedNA, y::SignedNA) = isna(x) || isna(y) ? NA_Int : float64(x)/float64(y)
inv(x::SignedNA) = 1.0/float64(x)

div{T<:SignedNA}(x::T, y::T) = isna(x) || isna(y) ? NA_Int : intNA(div(int(x),int(y)))
rem{T<:SignedNA}(x::T, y::T) = isna(x) || isna(y) ? NA_Int : intNA(rem(int(x),int(y)))
mod{T<:SignedNA}(x::T, y::T) = isna(x) || isna(y) ? NA_Int : intNA(mod(int(x),int(y)))

div(x::IntNA,     y::IntNA)     = isna(x) || isna(y) ? NA_Int : box(IntNA,sdiv_int(unbox(IntNA,x),unbox(IntNA,y)))
div(x::IntNA64,   y::IntNA64)   = isna(x) || isna(y) ? NA_Int64 : box(IntNA64,sdiv_int(unbox(IntNA64,x),unbox(IntNA64,y)))
div(x::IntNA128,  y::IntNA128)  = isna(x) || isna(y) ? NA_Int128 : box(IntNA128,sdiv_int(unbox(IntNA128,x),unbox(IntNA128,y)))

rem(x::IntNA,     y::IntNA)     = isna(x) || isna(y) ? NA_Int : box(IntNA,srem_int(unbox(IntNA,x),unbox(IntNA,y)))
rem(x::IntNA64,   y::IntNA64)   = isna(x) || isna(y) ? NA_Int64 : box(IntNA64,srem_int(unbox(IntNA64,x),unbox(IntNA64,y)))
rem(x::IntNA128,  y::IntNA128)  = isna(x) || isna(y) ? NA_Int128 : box(IntNA128,srem_int(unbox(IntNA128,x),unbox(IntNA128,y)))

mod(x::IntNA,    y::IntNA)    = isna(x) || isna(y) ? NA_Int : box(IntNA,smod_int(unbox(IntNA,x),unbox(IntNA,y)))
mod(x::IntNA64,  y::IntNA64)  = isna(x) || isna(y) ? NA_Int64 : box(IntNA64,smod_int(unbox(IntNA64,x),unbox(IntNA64,y)))
mod(x::IntNA128, y::IntNA128) = isna(x) || isna(y) ? NA_Int128 : box(IntNA128,smod_int(unbox(IntNA128,x),unbox(IntNA128,y)))

## integer bitwise operations ##

# deleted...

## integer comparisons ##

==(x::IntNA8,   y::IntNA8 )  = isna(x) || isna(y) ? NA_Int8   : eq_int(unbox(IntNA8,x),unbox(IntNA8,y))
==(x::IntNA16,  y::IntNA16)  = isna(x) || isna(y) ? NA_Int16  : eq_int(unbox(IntNA16,x),unbox(IntNA16,y))
==(x::IntNA32,  y::IntNA32)  = isna(x) || isna(y) ? NA_Int32  : eq_int(unbox(IntNA32,x),unbox(IntNA32,y))
==(x::IntNA64,  y::IntNA64)  = isna(x) || isna(y) ? NA_Int64  : eq_int(unbox(IntNA64,x),unbox(IntNA64,y))
==(x::IntNA128, y::IntNA128) = isna(x) || isna(y) ? NA_Int128 : eq_int(unbox(IntNA128,x),unbox(IntNA128,y))

!=(x::IntNA8,   y::IntNA8)   = isna(x) || isna(y) ? NA_Int8   : ne_int(unbox(IntNA8,x),  unbox(IntNA8,y))
!=(x::IntNA16,  y::IntNA16)  = isna(x) || isna(y) ? NA_Int16  : ne_int(unbox(IntNA16,x), unbox(IntNA16,y))
!=(x::IntNA32,  y::IntNA32)  = isna(x) || isna(y) ? NA_Int32  : ne_int(unbox(IntNA32,x), unbox(IntNA32,y))
!=(x::IntNA64,  y::IntNA64)  = isna(x) || isna(y) ? NA_Int64  : ne_int(unbox(IntNA64,x), unbox(IntNA64,y))
!=(x::IntNA128, y::IntNA128) = isna(x) || isna(y) ? NA_Int128 : ne_int(unbox(IntNA128,x),unbox(IntNA128,y))

<(x::IntNA8,   y::IntNA8)   = isna(x) || isna(y) ? NA_Int8   : slt_int(unbox(IntNA8,x),  unbox(IntNA8,y))
<(x::IntNA16,  y::IntNA16)  = isna(x) || isna(y) ? NA_Int16  : slt_int(unbox(IntNA16,x), unbox(IntNA16,y))
<(x::IntNA32,  y::IntNA32)  = isna(x) || isna(y) ? NA_Int32  : slt_int(unbox(IntNA32,x), unbox(IntNA32,y))
<(x::IntNA64,  y::IntNA64)  = isna(x) || isna(y) ? NA_Int64  : slt_int(unbox(IntNA64,x), unbox(IntNA64,y))
<(x::IntNA128, y::IntNA128) = isna(x) || isna(y) ? NA_Int128 : slt_int(unbox(IntNA128,x),unbox(IntNA128,y))

<=(x::IntNA8,   y::IntNA8)   = isna(x) || isna(y) ? NA_Int8   : sle_int(unbox(IntNA8,x),  unbox(IntNA8,y))
<=(x::IntNA16,  y::IntNA16)  = isna(x) || isna(y) ? NA_Int16  : sle_int(unbox(IntNA16,x), unbox(IntNA16,y))
<=(x::IntNA32,  y::IntNA32)  = isna(x) || isna(y) ? NA_Int32  : sle_int(unbox(IntNA32,x), unbox(IntNA32,y))
<=(x::IntNA64,  y::IntNA64)  = isna(x) || isna(y) ? NA_Int64  : sle_int(unbox(IntNA64,x), unbox(IntNA64,y))
<=(x::IntNA128, y::IntNA128) = isna(x) || isna(y) ? NA_Int128 : sle_int(unbox(IntNA128,x),unbox(IntNA128,y))

## integer promotions ##

promote_rule{T <: SignedNA}(::Type{T}, ::Type{NAtype} ) = T

basetypes = [:Int8 :Int16 :Int32 :Int64 :Int128
             :Uint8 :Uint16 :Uint32 :Uint64 :Uint128
             :IntNA8 :IntNA16 :IntNA32 :IntNA64 :IntNA128]'
natypes = [:IntNA8, :IntNA16, :IntNA32, :IntNA64, :IntNA128]

for i in 1:length(basetypes)
    for j in 1:length(natypes)
        k = rem(i,5) + (rem(i,5) == 0 ? 5 : 0) # row number of basetypes
        @eval promote_rule(::Type{$(natypes[j])}, ::Type{$(basetypes[i])} ) = $(natypes[max(j,k)])
    end
end

promote_rule(::Type{Float32}, ::Type{IntNA8} ) = Float32
promote_rule(::Type{Float32}, ::Type{IntNA16}) = Float32
promote_rule(::Type{Float32}, ::Type{IntNA32}) = Float64
promote_rule(::Type{Float32}, ::Type{IntNA64}) = Float64 # TODO: should be Float80

promote_rule(::Type{Float64}, ::Type{IntNA8} ) = Float64
promote_rule(::Type{Float64}, ::Type{IntNA16}) = Float64
promote_rule(::Type{Float64}, ::Type{IntNA32}) = Float64
promote_rule(::Type{Float64}, ::Type{IntNA64}) = Float64 # TODO: should be Float80

## traits ##

typemin(::Type{IntNA8  }) = intNA8(-127)
typemax(::Type{IntNA8  }) = intNA8(127)
typemin(::Type{IntNA16 }) = intNA16(-32767)
typemax(::Type{IntNA16 }) = intNA16(32767)
typemin(::Type{IntNA32 }) = intNA32(-2147483647)
typemax(::Type{IntNA32 }) = intNA32(2147483647)
typemin(::Type{IntNA64 }) = intNA64(typemin(Int64) + 1)
typemax(::Type{IntNA64 }) = intNA64(typemax(Int64))
typemin(::Type{IntNA128}) = intNA128(typemin(Int128) + 1)
typemax(::Type{IntNA128}) = intNA64(typemax(Int128))

## NA pattern ##
const NA_Int8  = intNA8(-128)
const NA_Int16 = intNA16(-32768)
const NA_Int32 = intNA32(-2147483648)
const NA_Int64 = intNA64(typemin(Int64))
const NA_Int128 = intNA128(typemin(Int128))

na(::Type{Int8})   = NA_Int8
na(::Type{Int16})  = NA_Int16
na(::Type{Int32})  = NA_Int32
na(::Type{Int64})  = NA_Int64
na(::Type{Int128}) = NA_Int128

na(::Type{IntNA8})   = NA_Int8
na(::Type{IntNA16})  = NA_Int16
na(::Type{IntNA32})  = NA_Int32
na(::Type{IntNA64})  = NA_Int64
na(::Type{IntNA128}) = NA_Int128

na(::Int8)   = NA_Int8
na(::Int16)  = NA_Int16
na(::Int32)  = NA_Int32
na(::Int64)  = NA_Int64
na(::Int128) = NA_Int128

na(::IntNA8)   = NA_Int8
na(::IntNA16)  = NA_Int16
na(::IntNA32)  = NA_Int32
na(::IntNA64)  = NA_Int64
na(::IntNA128) = NA_Int128

const NA_Int  = na(1)

isna(x::IntNA8)   = eq_int(unbox(IntNA8,  x), unbox(IntNA8,   NA_Int8))
isna(x::IntNA16)  = eq_int(unbox(IntNA16, x), unbox(IntNA16,  NA_Int16))
isna(x::IntNA32)  = eq_int(unbox(IntNA32, x), unbox(IntNA32,  NA_Int32))
isna(x::IntNA64)  = eq_int(unbox(IntNA64, x), unbox(IntNA64,  NA_Int64))
isna(x::IntNA128) = eq_int(unbox(IntNA128,x), unbox(IntNA128, NA_Int128))

sizeof(::Type{IntNA8})    = 1
sizeof(::Type{IntNA16})   = 2
sizeof(::Type{IntNA32})   = 4
sizeof(::Type{IntNA64})   = 8
sizeof(::Type{IntNA128})  = 16

## float to integer coercion ##

# requires int arithmetic defined, for the loops to work

for f in (:intNA, :intNA8, :intNA16, :intNA32)
    @eval ($f)(x::Float) = ($f)(iround(x))
end

for (f,t) in ((:intNA64,:IntNA64), (:intNA128,:IntNA128))
    @eval ($f)(x::Float) = iround($t,x)
end

## byte order swaps for arbitrary-endianness serialization/deserialization ##
bswap(x::IntNA16)  = box(IntNA16, bswap_int(unbox(IntNA16, x)))
bswap(x::IntNA32)  = box(IntNA32, bswap_int(unbox(IntNA32, x)))
bswap(x::IntNA64)  = box(IntNA64, bswap_int(unbox(IntNA64, x)))
bswap(x::IntNA128) = box(IntNA128,bswap_int(unbox(IntNA128,x)))

show{T<:SignedNA}(io, n::T) = print(io, isna(n) ? "NA" : dec(n))

show(io, n::SignedNA) = print(io, isna(n) ? "NA" : dec(n))
print(io::IO, n::SignedNA) = print(io, isna(n) ? "NA" : dec(n))


## Array referencing ##

ref(a::Array, i::SignedNA) = isna(i) ? na(eltype(a)) : arrayref(a,int(i))
ref{T}(a::Array{T,1}, i::SignedNA) = isna(i) ? na(eltype(a)) : arrayref(a,int(i))
ref(a::Array{Any,1}, i::SignedNA) = isna(i) ? na(eltype(a)) : arrayref(a,int(i))

function check_bounds(sz::Int, I::SignedNA)
    if isna(I) return; end
    if I < 1 || I > sz
        throw(BoundsError())
    end
end

function check_bounds{T <: SignedNA}(sz::Int, I::AbstractVector{T})
    for i in I
        check_bounds(sz, i)
    end
end

nafilter{T <: SignedNA}(v::AbstractVector{T}) = basetype(v[!isna(v)])  # should these return a base vector? Probably
nareplace{T <: SignedNA}(v::AbstractVector{T}, r) = [isna(v[i]) ? r : basetype(v[i]) for i = 1:length(v)]

basetype(::Type{IntNA8})   = Int8
basetype(::Type{IntNA16})  = Int16
basetype(::Type{IntNA32})  = Int32
basetype(::Type{IntNA64})  = Int64
basetype(::Type{IntNA128}) = Int128

basetype(x::IntNA8)   = convert(Int8, x)
basetype(x::IntNA16)  = convert(Int16, x)
basetype(x::IntNA32)  = convert(Int32, x)
basetype(x::IntNA64)  = convert(Int64, x)
basetype(x::IntNA128) = convert(Int128, x)

basetype{T,N}(x::Array{T,N}) = x

function basetype{T<:SignedNA,N}(x::Array{T,N})
    res = Array(basetype(T), size(x))
    for i in 1:length(x)
        res[i] = basetype(x[i])
    end
    res
end

natype(::Type{Int8})   = IntNA8
natype(::Type{Int16})  = IntNA16
natype(::Type{Int32})  = IntNA32
natype(::Type{Int64})  = IntNA64
natype(::Type{Int128}) = IntNA128

natype(x::Int8)   = convert(IntNA8, x)
natype(x::Int16)  = convert(IntNA16, x)
natype(x::Int32)  = convert(IntNA32, x)
natype(x::Int64)  = convert(IntNA64, x)
natype(x::Int128) = convert(IntNA128, x)

natype(::Type{IntNA8})   = IntNA8
natype(::Type{IntNA16})  = IntNA16
natype(::Type{IntNA32})  = IntNA32
natype(::Type{IntNA64})  = IntNA64
natype(::Type{IntNA128}) = IntNA128

natype(x::IntNA8)   = x
natype(x::IntNA16)  = x
natype(x::IntNA32)  = x
natype(x::IntNA64)  = x
natype(x::IntNA128) = x

natype{T<:SignedNA,N}(x::Array{T,N}) = x

function natype{T<:Number,N}(x::Array{T,N})
    res = Array(natype(T), size(x))
    for i in 1:length(x)
        res[i] = natype(x[i])
    end
    res
end
