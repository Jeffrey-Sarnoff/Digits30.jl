typealias SmallerFloatInt Union{Float32,Float16,Int32,Int16,Int8}
typealias FloatInt Union{Float64,Float32,Float16,Int64,Int32,Int16,Int8}

Float120{T<:SmallerFloatInt}(hi::T) = Float120(hi,zero(T))

function Float120{T<:SmallerFloatInt}(hi::T, lo::T)
    high = Float64(hi)
    low  = Float64(lo)
    high, low = eftAdd(high, low)
    Float120(high,low)
end

Float120{T1<:FloatInt,T2<:FloatInt}(hi::T1, lo::T2) = Float120(Float64(hi), Float64(lo))

function convert(::Type{Float120}, x::BigFloat)
    hi = Float64(x)
    lo = Float64(x-hi)
    Float120(hi,lo)
end

convert(::Type{BigFloat}, x::Float120) = convert(BigFloat,x.hi) + convert(BigFloat,x.lo)


convert(::Type{Float64}, x::Float120) = x.hi
convert(::Type{Float32}, x::Float120) = convert(Float32, x.hi)
convert(::Type{Float16}, x::Float120) = convert(Float16, x.hi)

convert(::Type{Float120}, x::Float64) = Float120(x)
convert(::Type{Float120}, x::Float32) = Float120(convert(Float64,x))
convert(::Type{Float120}, x::Float16) = Float120(convert(Float64,x))


convert(::Type{Int128}, x::Float120) = trunc(Int128,x.hi)+trunc(Int128,x.lo)
convert(::Type{Int64}, x::Float120) = convert(Int64, convert(Int128,x))

function convert(::Type{Int32}, x::Float120)
    if (x.lo == trunc(x.lo)) && (x.hi == trunc(x.hi))
        convert(Int32, trunc(Int64,x.hi)+trunc(Int64,x.lo))
    else
        throw(InexactError())
    end
end

convert(::Type{Int16}, x::Float120) = convert(Int16, convert(Int32,x))
convert(::Type{Int8}, x::Float120) = convert(Int8, convert(Int32,x))

convert(::Type{Float120}, x::Int8) = Float120(convert(Float64,x))
convert(::Type{Float120}, x::Int16) = Float120(convert(Float64,x))
convert(::Type{Float120}, x::Int32) = Float120(convert(Float64,x))

function convert(::Type{Float120}, x::Int64)
    if signbit(x)
        if x < safemin(Float64)
            convert(Float120, convert(Int128,x))
        else
            Float120(convert(Float64,x))
        end
    else
        if x > safemax(Float64)
            convert(Float120, convert(Int128,x))
        else
            Float120(convert(Float64,x))
        end
    end
end

const Float120safemax128 = Int128(  207_691_874_341_393_105_096_183_856_895_509_888 )
const Float120safemin128 = Int128( -207_691_874_341_393_105_096_183_856_895_509_888 )

function convert(::Type{Float120}, x::Int128)
    if signbit(x)
        if x > typemin(Int128)
            Float120(convert(BigFloat,convert(BigInt,x)))
        else
            throw(DomainError())
        end
    else
        if x <= typemax(Int128)
            Float120(convert(BigFloat,convert(BigInt,x)))
        else
            throw(DomainError())
        end
    end
end




# resolve ambiguity
convert(::Type{Bool}, x::Float120) = !(x.hi == 0.0)
convert(::Type{Base.GMP.BigInt}, x::Float120) =
   convert(Base.GMP.BigInt, x.hi) + convert(Base.GMP.BigInt, x.lo)
convert(::Type{Rational{Int128}}, x::Float120) =
   convert(Rational{Int128}, x.hi) + convert(Rational{Int128}, x.lo)
convert(::Type{Rational{Base.GMP.BigInt}}, x::Float120) =
   convert(Rational{Base.GMP.BigInt}, x.hi) + convert(Rational{Base.GMP.BigInt}, x.lo)
   
function convert{T<:Union{Int128,Base.GMP.BigInt}}(::Type{Float120}, x::Rational{T})
    hi = Float64(x - convert(Rational{T},Float64(x)))
    lo = Float64(x - convert(Rational{T},hi))
    Float120(hi,lo)
end


convert{T<:Integer}(::Type{Rational{T}}, x::Float120) =
   convert(Rational{T}, x.hi) + convert(Rational{T}, x.lo)

convert{T<:Integer}(::Type{Float120}, x::Rational{T}) =
   convert(Float120, convert(BigFloat,x))

# promotions


promote_rule(::Type{Bool}, ::Type{Float120}) = Float120
promote_rule(::Type{Base.GMP.BigInt}, ::Type{Float120}) = Float120
promote_rule(::Type{Rational{Int128}}, ::Type{Float120}) = Rational{Int128}
promote_rule(::Type{Rational{Base.GMP.BigInt}}, ::Type{Float120}) = Rational{Base.GMP.BigInt}
promote_rule(::Type{BigFloat}, ::Type{Float120}) = BigFloat

promote_rule{T<:AbstractFloat}(::Type{T}, ::Type{Float120}) = Float120
promote_rule{T<:Integer}(::Type{T}, ::Type{Float120}) = Float120
promote_rule{T<:Integer}(::Type{Rational{T}}, ::Type{Float120}) = Float120


