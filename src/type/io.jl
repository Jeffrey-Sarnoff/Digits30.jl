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

function frexp10(x::AbstractFloat)
    p10 = isof10toPow(x)
    x/(10.0^p10), p10
end

function ldexp10(fr::AbstractFloat,xp::Integer})
    p10 = 10.0^xp
    fr * p10
end
ldexp10(frxp::Tuple{AbstractFloat,Integer}) = ldexp10(frxp[1],frxp[2])

#=
Goal: 30 digit base 10 significand

30 digits is ~99.658 bits,
we have at least 106 meaningful bits (some may be inexact)

=#

function thirtydigits(x::Float120)
   isneg = signbit(x)
   bigx = convert(BigFloat,abs(x))
   p10 = isof10toPow(bigx)
   #delta = isneg(p10) ? 1 :  (p10>0 ? -1 : 0)
   digs = 30-1-p10
   roundx = round(bigx, digs, 10)
   stringx = string(roundx)
   if contains(stringx, "e")
       sfr,sxp = split(string(round(bigx,digs,10)),"e")
       srounded = string((isneg?"-":""),sfr[1:31],"e",sxp)
   else
       srounded = string((isneg?"-":""),stringx[1:31])
   end
   srounded
end   
