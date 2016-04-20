# addition

# function (+){T<:Float120}(a::T,b::T)
function (+)(a::Float120,b::Float120)
    s1, s2 = eftAdd(a.hi,b.hi)
    t1, t2 = eftAdd(a.lo,b.lo)
    s2 += t1
    s1, s2 = eftAddGTE(s1,s2)
    s2 += t2
    s1, s2 = eftAddGTE(s1,s2)
    Float120(s1,s2)
end


function (+)(a::Float120,b::Float64)
    s1, s2 = eftAdd(a.hi,b)
    s2 += a.lo
    s1, s2 = eftAddGTE(s1,s2)
    Float120(s1,s2)
end

(+)(a::Float64,b::Float120) = (+)(b,a)
(+)(a::Float120,b::Signed) = (+)(a,convert(Float64,b))
(+)(a::Signed,b::Float120) = (+)(b,a)

(+)(a::Float120, b::Real) = (+)(promote(a,b)...)
(+)(a::Real, b::Float120) = (+)(promote(a,b)...)


# subtraction

function (-){T<:Float120}(a::T,b::T)
    s1, s2 = eftSub(a.hi,b.hi)
    t1, t2 = eftSub(a.lo,b.lo)
    s2 += t1
    s1, s2 = eftAddGTE(s1,s2)
    s2 += t2
    s1, s2 = eftAddGTE(s1,s2)
    Float120(s1,s2)
end

function (-)(a::Float120,b::Float64)
    s1, s2 = eftSub(a.hi,b)
    s2 += a.lo
    s1, s2 = eftAddGTE(s1,s2)
    Float120(s1,s2)
end

function (-)(a::Float64,b::Float120)
    s1, s2 = eftSub(a,b.hi)
    s2 -= b.lo
    s1, s2 = eftAddGTE(s1,s2)
    Float120(s1,s2)
end

(-)(a::Float120,b::Signed) = (-)(a,convert(Float64,b))
(-)(a::Signed,b::Float120) = (-)(convert(Float64,a),b)

(-)(a::Float120, b::Real) = (-)(promote(a,b)...)
(-)(a::Real, b::Float120) = (-)(promote(a,b)...)


# multiplication


function (sqr)(a::Float120)
  t1,t2 = eftMul(a.hi,a.hi)
  t3 = a.hi * a.lo
  t5 = t3 + t3
  t6 = t2 + t5
  t1,t6 = eftAddGTE(t1,t6)
  Float120(t1,t6)
end

function (*){T<:Float120}(a::T,b::T)
  t1,t2 = eftMul(a.hi,b.hi)
  t3 = a.hi * b.lo
  t4 = a.lo * b.hi
  t5 = t3 + t4
  t6 = t2 + t5
  t1,t6 = eftAddGTE(t1,t6)
  Float120(t1,t6)
end

function (*)(a::Float120,b::Float64)
  t1,t2 = eftMul(a.hi,b)
  t4 = a.lo * b
  t6 = t2 + t4
  t1,t6 = eftAddGTE(t1,t6)
  Float120(t1,t6)
end

(*)(a::Float64,b::Float120) = (*)(b,a)
(*)(a::Float120,b::Signed) = (*)(a,convert(Float64,b))
(*)(a::Signed,b::Float120) = (*)(convert(Float64,a),b)

(*)(a::Float120, b::Real) = (*)(promote(a,b)...)
(*)(a::Real, b::Float120) = (*)(promote(a,b)...)



function fma{T<:Float120}(a::T,b::T,c::T)
    hi,lo = eftFMAas2(a,b,c)
    Float120(hi,lo)
end

function fms{T<:Float120}(a::T,b::T,c::T)
    hi,lo = eftFMSas2(a,b,c)
    Float120(hi,lo)
end

# reciprocation


function (recip)(b::Float120)
  q1 = one(Float64) / b.hi
  r  = one(Float120) - q1*b

  q2 = r.hi / b.hi
  r = r - (q2 * b)

  q2 += r.hi / b.hi

  q3 = r.hi / b.hi

  q1,q2 = eftAdd(q1, q2)
  q1,q2 = eftAddAs2(q1,q2,q3)
  Float120(q1,q2)
end

# division

function (/){T<:Float120}(a::T,b::T)
  q1 = a.hi / b.hi
  r  = a - (q1 * b)

  q2 = r.hi / b.hi
  r = r - (q2 * b)

  q3 = r.hi / b.hi

  q1,q2 = eftAddGTE(q1, q2)
  q1,q2 = eftAddAs2(q1,q2,q3)
  Float120(q1,q2)
end


(/)(a::Float120, b::Real) = (/)(promote(a,b)...)
(/)(a::Real, b::Float120) = (/)(promote(a,b)...)

# powers


# roots


#=
      for a in [1e-15..1e18]
      relerr ~1.3e-32  (106 bits)
=#

function sqrt(a::Float120)
    if a.hi <= 0.0
       if a.hi == 0.0
           return zero(Float120)
       else
           throw(ArgumentError("sqrt expects a nonnegative base"))
       end
    #elseif (a.hi < 1.0e-18) | (a.hi > 1.0e18)
    #    throw(ArgumentError("sqrt arg ($a) outside domain"))
    end

    if (a.hi < 1.0e-7)  # -log2(1.0e-7) < (1/2) Float64 significand bits
        r = recip(a)
        s = sqrt(r)
        return recip(s)
    end
    # initial approximation to 1/sqrt(a)
    r = Float120(1.0/sqrt(a.hi), 0.0)
    r = r + divby2( r * (one(Float120) - (a*(r*r))) )
    r = r + divby2( r * (one(Float120) - (a*(r*r))) )
    r = r + divby2( r * (one(Float120) - (a*(r*r))) )

    r = a*r
    #divby2(r + a/r)
    r += a/r
    divby2(r)
end


function hypot(a::Float120, b::Float120)
    a = abs(a)
    b = abs(b)
    t, x = minmax(a,b)
    t = t/a
    t = sqr(t)
    t = sqrt(one(Digits30) + t)
    x * t
end

(hypot)(a::Float120, b::Real) = (hypot)(a, convert(Float120,b))
(hypot)(a::Real, b::Float120) = (hypot)(convert(Float120,a), b)
