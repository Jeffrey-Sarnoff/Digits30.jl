sign(a::Float120) = sign(a.hi)
@inline signbit(a::Float120) = signbit(a.hi)

#=
    negation, abs, flipsign, copysign
=#

@inline (-)(a::Float120) = Float120(-a.hi, -a.lo)
@inline abs(a::Float120) = ifelse(signbit(a.hi), -a, a)

flipsign(a::Float120, b::Float120)   = ifelse(signbit(b.hi), -a, a)
flipsign{T<:Real}(a::Float120, b::T) = ifelse(signbit(b), -a, a)
copysign(a::Float120, b::Float120)   = ifelse(signbit(b.hi), -abs(a), abs(a))
copysign{T<:Real}(a::Float120, b::T) = ifelse(signbit(b), -abs(a), abs(a))


#=
    frexp, ldexp, zero, one
=#

function frexp(a::Float120)
    frhi, xphi = frexp(a.hi)
    frlo, xplo = frexp(a.lo)
    Float120(frhi, ldexp(frlo,xplo-xphi)), xphi
end

function ldexp(a::Float120,xp::Int)
    Float120(ldexp(a.hi,xp),ldexp(a.lo,xp))
end
ldexp{I<:Integer}(fx::Tuple{Float120,I}) = ldexp(fx...)


zero(::Type{Float120}) = Float120(0.0, 0.0)
one(::Type{Float120})  = Float120(1.0, 0.0)
zero(x::Float120) = zero(Float120)
one(x::Float120)  = one(Float120)

# Inf, NaN

Inf30(::Type{Float120}) = Float120(Inf(T), Inf(T))
NaN30(::Type{Float120}) = Float120(NaN(T), NaN(T))
Inf30(x::Float120) = Inf30(Float120)
NaN30(x::Float120) = NaN30(Float120)
