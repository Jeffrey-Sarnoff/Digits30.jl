typealias SmallerFloatInt Union{Float32,Float16,Int32,Int16,Int8}
typealias FloatInt Union{Float64,Float32,Float16,Int64,Int32,Int16,Int8}

Digit30{T<:SmallerFloatInt}(hi::T) = Digit30(hi,zero(T))

function Digit30{T<:SmallerFloatInt}(hi::T, lo::T)
    high = Float64(hi)
    low  = Float64(lo)
    high, low = eftAdd(high, low)
    Digit30(high,low)
end

Digit30{T1<:FloatInt,T2<:FloatInt}(hi::T1, lo::T2) = Digit30(Float64(hi), Float64(lo))

function convert(::Type{Digit30}, x::BigFloat)
    hi = Float64(x)
    lo = Float64(x-hi)
    Digit30(hi,lo)
end

convert(::Type{BigFloat}, x::Digit30) = convert(BigFloat,x.hi) + convert(BigFloat,x.lo)


convert(::Type{Float64}, x::Digit30) = x.hi
convert(::Type{Float32}, x::Digit30) = convert(Float32, x.hi)
convert(::Type{Float16}, x::Digit30) = convert(Float16, x.hi)

convert(::Type{Int128}, x::Digit30) = trunc(Int128,x.hi)+trunc(Int128,x.lo)
convert(::Type{Int64}, x::Digit30) = convert(Int64, convert(Int128,x))

function convert(::Type{Int32}, x::Digit30)
    if (x.lo == trunc(x.lo)) && (x.hi == trunc(x.hi))
        convert(Int32, trunc(Int64,x.hi)+trunc(Int64,x.lo))
    else
        throw(InexactError())
    end
end

convert(::Type{Int16}, x::Digit30) = convert(Int16, convert(Int32,x))
convert(::Type{Int8}, x::Digit30) = convert(Int8, convert(Int32,x))


function convert(::Type{Rational{Base.GMP.BigInt}}, x::Digit30)
   convert(Rational{Base.GMP.BigInt}, x.hi) + convert(Rational{Base.GMP.BigInt}, x.lo)
end
function convert{T<:Integer}(::Type{Rational{T}}, x::Digit30)
   convert(Rational{T}, x.hi) + convert(Rational{T}, x.lo)
end

function convert{T<:Integer}(::Type{Digit30}, x::Rational{T})
   convert(Digit30, convert(BigFloat,x))
end

