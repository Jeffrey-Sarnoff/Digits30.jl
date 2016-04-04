sign(a::Digit30) = sign(a.hi)
@inline signbit(a::Digit30) = signbit(a.hi)

#=
    negation, abs, flipsign, copysign
=#

@inline (-)(a::Digit30) = Digit30(-a.hi, -a.lo)
@inline abs(a::Digit30) = ifelse(signbit(a.hi), -a, a)

flipsign(a::Digit30, b::Digit30) = ifelse(signbit(b.hi), -a, a)
flipsign{T<:Real}(a::Digit30, b::T) = ifelse(signbit(b), -a, a)
copysign(a::Digit30, b::Digit30) = ifelse(signbit(b.hi), -abs(a), abs(a))
copysign{T<:Real}(a::Digit30, b::T) = ifelse(signbit(b), -abs(a), abs(a))


#=
    frexp, ldexp, zero, one
=#

function frexp(a::Digit30)
    frhi, xphi = frexp(a.hi)
    frlo, xplo = frexp(a.lo)
    Digit30(frhi, ldexp(frlo,xplo-xphi)), xphi
end

function ldexp(a::Digit30,xp::Int)
    Digit30(ldexp(a.hi,xp),ldexp(a.lo,xp))
end
ldexp{I<:Integer}(fx::Tuple{Digit30,I}) = ldexp(fx...)


zero(::Type{Digit30{T}}) = FloatFloat(zero(T), zero(T))
one(::Type{Digit30{T}}) = FloatFloat(one(T), zero(T))
zero(x::Digit30) = zero(Digit30)
one(x::Digit30) = one(Digit30)

# Inf, NaN

Inf30(::Type{Digit30}) = Digit30(Inf(T), Inf(T))
NaN30(::Type{Digit30}) = Digit30(NaN(T), NaN(T))
Inf30(x::Digit30) = Inf30(Digit30)
NaN30(x::Digit30) = NaN30(Digit30)
