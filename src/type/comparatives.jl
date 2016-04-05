function isless(a::Float120, b::Float120)
    (a.hi < b.hi) || (a.hi==b.hi && a.lo<b.lo)
end
function isless(a::Float120, b::Float64)
    (a.hi < b) || (a.hi==b && a.lo<zero(Float64))
end
function isless(a::Float64, b::Float120)
    (a < b.hi) || (a==b.hi && b.lo<zero(Float64))
end
function isequal(a::Float120, b::Float120)
    (a.hi == b.hi) && (a.lo == b.lo)
end
function isequal(a::Float120, b::Float64)
    (a.hi == b) && (a.lo == zero(Float64))
end
function isequal(a::Float64, b::Float120)
    (a == b.hi) && (b.lo == zero(Float64))
end

@inline (==)(a::Float120,b::Float120) = (a.hi == b.hi) && (a.lo == b.lo)
@inline (< )(a::Float120,b::Float120) = (a.hi < b.hi) || (a.hi==b.hi && a.lo<b.lo)
@inline (<=)(a::Float120,b::Float120) = (a.hi < b.hi) || (a.hi==b.hi && a.lo<=b.lo)
@inline (> )(a::Float120,b::Float120) = (a.hi > b.hi) || (a.hi==b.hi && a.lo>b.lo)
@inline (>=)(a::Float120,b::Float120) = (a.hi > b.hi) || (a.hi==b.hi && a.lo>=b.lo)

min{T<:Float120}(a::T, b::T) = (a<b) ? a : b
max{T<:Float120}(a::T, b::T) = (b<a) ? a : b
minmax{T<:Float120}(a::T, b::T) = (a<b) ? (a,b) : (b,a)
maxmin{T<:Float120}(a::T, b::T) = (b<a) ? (a,b) : (b,a)




