immutable Float120 <: AbstractFloat
    hi::Float64
    lo::Float64
    
    Float120(hi::Float64, lo::Float64) = new(hi,lo)
end

hi(x::Float120) = x.hi
lo(x::Float120) = x.lo

Float120(hi::Float64) = Float120(hi,0.0)


# fully clean a,b then set hi,lo
function F120{T<:Float64}(a::T, b::T) # hi,lo = eftAdd(a,b)
  hi = a + b
  t = hi - a
  lo = (a - (hi - t)) + (b - t)
  Float120(hi,lo)
end
