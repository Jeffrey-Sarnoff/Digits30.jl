
@inline function mulby2(a::Digit30)
    Digit30(a.hi*2.0, a.lo*2.0)
end

@inline function divby2(a::Digit30)
    Digit30(a.hi*0.5, a.lo*0.5)
end

@inline function mulbypow2(a::Digit30,p::Float64)
    Digit30(a.hi*p, a.lo*p)
end

@inline function divbypow2(a::Digit30,p::Float64)
    fr,xp = frexp(p)
    mulbypow2(a, ldexp(fr,-xp))
end


function div{T<:Digit30}(a::T,b::T)
    if (b.hi == zero(Float64))
        throw(DomainError("denominator must be nonzero"))
    end
    temp = a/b
    trunc(temp)
end
div(a::Digit30,b::Float64) = div(a,Digit30(b))
div(a::Float64,b::Digit30) = div(Digit30(a),b)

function fld{T<:Digit30}(a::T,b::T)
    if (b.hi == zero(Float64))
        throw(DomainError("denominator must be nonzero"))
    end
    floor( a/b )
end
fld(a::Digit30,b::Float64) = fld(a,Digit30(b))
fld(a::Float64,b::Digit30) = fld(Digit30(a),b)

function cld{T<:Digit30}(a::T,b::T)
    if (b.hi == zero(Float64))
        throw(DomainError("denominator must be nonzero"))
    end
    ceil( a/b )
end
cld(a::Digit30,b::Float64) = cld(a,Digit30(b))
cld(a::Float64,b::Digit30) = cld(Digit30(a),b)

function rem{T<:Digit30}(a::T,b::T)
    if (b.hi == zero(Float64))
        throw(DomainError("denominator must be nonzero"))
    end
    a - div(a,b)*b
end

function mod{T<:Digit30}(a::T,b::T)
    if (b.hi == zero(Float64))
        throw(DomainError("modulus must be nonzero"))
    end
    if signbit(a.hi)==signbit(b.hi)
        rem(a,b)
    else
        d = floor(a/b)
        a - d*b
    end
end
mod(a::Digit30,b::Float64) = mod(a,convert(Digit30,b))
mod(a::Float64,b::Digit30) = mod(convert(Digit30,a),b)


function divrem{T<:Digit30}(a::T,b::T)
    if (b.hi == zero(Float64))
        throw(DomainError("denominator must be nonzero"))
    end
    temp = a/b
    d = trunc(temp)
    r = a - d*b
    d,r
end
divrem(a::Digit30, b::Float64) = divrem(a,convert(Digit30,b))
divrem(a::Float64, b::Digit30) = divrem(convert(Digit30,a),b)

function fldmod{T<:Digit30}(a::T,b::T)
    d = floor(a/b)
    a - d*b
    d,a
end
fldmod(a::Digit30, b::Float64) = fldmod(a,convert(Digit30,b))
fldmod(a::Float64, b::Digit30) = fldmod(convert(Digit30,a),b)

#=
   This well-behaved bounded modulo implementation is from
   The pitfalls of verifying floating-point computations
   by David Monniaux, 2008 
   http://arxiv.org/abs/cs/0701192v5
=#
function modulo{T<:Digit30}(a::T, lowerbound::T, upperbound::T)
    delta = upperbound - lowerbound
    a - (floor((a - lowerbound)/delta) * delta)
end
modulo(a::Digit30, lowerbound::Float64, upperbound::Float64) = modulo(a,convert(Digit30,lowerbound),convert(Digit30,upperbound))
modulo(a::Float64, lowerbound::Digit30, upperbound::Digit30) = modulo(convert(Digit30,a),lowerbound,upperbound)
