
@inline function mulby2(a::Float120)
    Float120(a.hi*2.0, a.lo*2.0)
end

@inline function divby2(a::Float120)
    Float120(a.hi*0.5, a.lo*0.5)
end

@inline function mulbypow2(a::Float120,p::Float64)
    Float120(a.hi*p, a.lo*p)
end

@inline function divbypow2(a::Float120,p::Float64)
    fr,xp = frexp(p)
    mulbypow2(a, ldexp(fr,-xp))
end


function div{T<:Float120}(a::T,b::T)
    if (b.hi == zero(Float64))
        throw(DomainError("denominator must be nonzero"))
    end
    temp = a/b
    trunc(temp)
end
div(a::Float120,b::Float64) = div(a,Float120(b))
div(a::Float64,b::Float120) = div(Float120(a),b)

function fld{T<:Float120}(a::T,b::T)
    if (b.hi == zero(Float64))
        throw(DomainError("denominator must be nonzero"))
    end
    floor( a/b )
end
fld(a::Float120,b::Float64) = fld(a,Float120(b))
fld(a::Float64,b::Float120) = fld(Float120(a),b)

function cld{T<:Float120}(a::T,b::T)
    if (b.hi == zero(Float64))
        throw(DomainError("denominator must be nonzero"))
    end
    ceil( a/b )
end
cld(a::Float120,b::Float64) = cld(a,Float120(b))
cld(a::Float64,b::Float120) = cld(Float120(a),b)

function rem{T<:Float120}(a::T,b::T)
    if (b.hi == zero(Float64))
        throw(DomainError("denominator must be nonzero"))
    end
    a - div(a,b)*b
end

function mod{T<:Float120}(a::T,b::T)
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
mod(a::Float120,b::Float64) = mod(a,convert(Float120,b))
mod(a::Float64,b::Float120) = mod(convert(Float120,a),b)


function divrem{T<:Float120}(a::T,b::T)
    if (b.hi == zero(Float64))
        throw(DomainError("denominator must be nonzero"))
    end
    temp = a/b
    d = trunc(temp)
    r = a - d*b
    d,r
end
divrem(a::Float120, b::Float64) = divrem(a,convert(Float120,b))
divrem(a::Float64, b::Float120) = divrem(convert(Float120,a),b)

function fldmod{T<:Float120}(a::T,b::T)
    d = floor(a/b)
    a - d*b
    d,a
end
fldmod(a::Float120, b::Float64) = fldmod(a,convert(Float120,b))
fldmod(a::Float64, b::Float120) = fldmod(convert(Float120,a),b)

#=
   This well-behaved bounded modulo implementation is from
   The pitfalls of verifying floating-point computations
   by David Monniaux, 2008 
   http://arxiv.org/abs/cs/0701192v5
=#
function modulo{T<:Float120}(a::T, lowerbound::T, upperbound::T)
    delta = upperbound - lowerbound
    a - (floor((a - lowerbound)/delta) * delta)
end
modulo(a::Float120, lowerbound::Float64, upperbound::Float64) = modulo(a,convert(Float120,lowerbound),convert(Float120,upperbound))
modulo(a::Float64, lowerbound::Float120, upperbound::Float120) = modulo(convert(Float120,a),lowerbound,upperbound)
