function show(io::IO, x::Digit30)
   s = string("Digit30(",x.hi,", ",x.lo,")")
   print(io, s)
end
