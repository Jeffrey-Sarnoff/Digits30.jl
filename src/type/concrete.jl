immutable Digit30 <: AbstractFloat
    hi::Float64
    lo::Float64
    
    Digit30(hi::Float64, lo::Float64) = new(hi,lo)
end

hi(x::Digit30) = x.hi
lo(x::Digit30) = x.lo

Digit30(hi::Float64) = Digit30(hi,0.0)


# fully clean a,b then set hi,lo
function D30{T<:Float64}(a::T, b::T) # hi,lo = eftAdd(a,b)
  hi = a + b
  t = hi - a
  lo = (a - (hi - t)) + (b - t)
  Digit30(hi,lo)
end
