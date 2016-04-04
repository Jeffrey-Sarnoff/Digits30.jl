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

function convert(::Type{BigFloat}, x::Digit30)
    convert(BigFloat,x.hi) + convert(BigFloat,x.lo)
end


