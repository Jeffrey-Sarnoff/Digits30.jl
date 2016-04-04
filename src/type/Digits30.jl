immutable Digit30 <: AbstractFloat
    hi::Float64
    lo::Float64
end

Base.show(io::IO, x::Digit30)
   print(io, string("Digit30(",x.hi,", ",x.lo,")"))
end
