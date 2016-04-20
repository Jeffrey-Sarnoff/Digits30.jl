function show(io::IO, x::Float120)
   s = string("Float120(",x.hi,", ",x.lo,")")
   print(io, s)
end

#=
isof10toPow( 0.1) == -1
isof10toPow( 9.0) ==  0
isof10toPow(10.0) ==  1
=#
isof10toPow{T<:AbstractFloat}(x::T) = floor(Int, log10(abs(x)))
isof10toPow{T<:Integer}(x::T) = isof10toPow(float(x))

isof2toPow{T<:AbstractFloat}(x::T) = floor(Int, log2(abs(x)))
isof2toPow{T<:Integer}(x::T) = isof2toPow(float(x))

#=
Goal: 30 digit base 10 significand

30 digits is ~99.658 bits,
we have at least 106 meaningful bits (some may be inexact)

=#

function thirtydigits(x::Float120)
   isneg = signbit(x)
   bigx = convert(BigFloat,abs(x))
   roundx = round(bigx, 30-(1+isof10toPow(bigx), 10))
   stringx = string(x)
   if contains(stringx, "e")
       sfr,sxp = split(string(round(bigx,30-(1+isof10toPow(bigx)),10)),"e")
       srounded = string((isneg?"-":""),sfr[1:31],"e",sxp)
   else
   end
   #fr,xp = frexp(bigx)
   #roundfr = ldexp(round(fr,30,10),xp)
   #stringfr = @sprintf("%30.30f",roundfr)
   srounded
end   
