# addition

function (+){T<:Digit30}(a::T,b::T)
    s1, s2 = eftAdd(a.hi,b.hi)
    t1, t2 = eftAdd(a.lo,b.lo)
    s2 += t1
    s1, s2 = eftAddGTE(s1,s2)
    s2 += t2
    s1, s2 = eftAddGTE(s1,s2)
    Digit30(s1,s2)
end

function (+)(a::Digit30,b::Float64)
    s1, s2 = eftAdd(a.hi,b)
    s2 += a.lo
    s1, s2 = eftAddGTE(s1,s2)
    Digit30(s1,s2)
end

(+)(a::Float64,b::Digit30) = (+)(b,a)
(+)(a::Digit30,b::Signed) = (+)(a,convert(Float64,b))
(+)(a::Signed,b::Digit30) = (+)(b,a)

(+){T<:Real}(a::Digit30, b::T) = (+)(promote(a,b)...)
(+){T<:Real}(a::T, b::Digit30) = (+)(promote(a,b)...)


# subtraction

function (-){T<:Digit30}(a::T,b::T)
    s1, s2 = eftSub(a.hi,b.hi)
    t1, t2 = eftSub(a.lo,b.lo)
    s2 += t1
    s1, s2 = eftAddGTE(s1,s2)
    s2 += t2
    s1, s2 = eftAddGTE(s1,s2)
    Digit30(s1,s2)
end

function (-)(a::Digit30,b::Float64)
    s1, s2 = eftSub(a.hi,b)
    s2 += a.lo
    s1, s2 = eftAddGTE(s1,s2)
    Digit30(s1,s2)
end

function (-)(a::Float64,b::Digit30)
    s1, s2 = eftSub(a,b.hi)
    s2 -= b.lo
    s1, s2 = eftAddGTE(s1,s2)
    Digit30(s1,s2)
end

(-)(a::Digit30,b::Signed) = (-)(a,convert(Float64,b))
(-)(a::Signed,b::Digit30) = (-)(convert(Float64,a),b)

(-){T<:Real}(a::Digit30, b::T) = (-)(promote(a,b)...)
(-){T<:Real}(a::T, b::Digit30) = (-)(promote(a,b)...)


# multiplication


function (sqr)(a::Digit30)
  t1,t2 = eftMul(a.hi,a.hi)
  t3 = a.hi * a.lo
  t5 = t3 + t3
  t6 = t2 + t5
  t1,t6 = eftAddGTE(t1,t6)
  Digit30(t1,t6)
end

function (*){T<:Digit30}(a::T,b::T)
  t1,t2 = eftMul(a.hi,b.hi)
  t3 = a.hi * b.lo
  t4 = a.lo * b.hi
  t5 = t3 + t4
  t6 = t2 + t5
  t1,t6 = eftAddGTE(t1,t6)
  Digit30(t1,t6)
end

function (*)(a::Digit30,b::Float64)
  t1,t2 = eftMul(a.hi,b)
  t4 = a.lo * b
  t6 = t2 + t4
  t1,t6 = eftAddGTE(t1,t6)
  Digit30(t1,t6)
end

(*)(a::Float64,b::Digit30) = (*)(b,a)
(*)(a::Digit30,b::Signed) = (*)(a,convert(Float64,b))
(*)(a::Signed,b::Digit30) = (*)(convert(Float64,a),b)

(*){T<:Real}(a::Digit30, b::T) = (*)(promote(a,b)...)
(*){T<:Real}(a::T, b::Digit30) = (*)(promote(a,b)...)



function fma{T<:Digit30}(a::T,b::T,c::T)
    hi,lo = eftFMAto2(a,b,c)
    Digit30(hi,lo)
end

function fms{T<:Digit30}(a::T,b::T,c::T)
    hi,lo = eftFMSto2(a,b,c)
    Digit30(hi,lo)
end

# reciprocation


function (recip)(b::Digit30)
  q1 = one(Float64) / b.hi
  r  = one(Digit30) - q1*b

  q2 = r.hi / b.hi
  r = r - (q2 * b)

  q2 += r.hi / b.hi

  q3 = r.hi / b.hi

  q1,q2 = eftAdd(q1, q2)
  q1,q2 = eftAdd3to2(q1,q2,q3)
  Digit30(q1,q2)
end

# division

function (/){T<:Digit30}(a::T,b::T)
  q1 = a.hi / b.hi
  r  = a - (q1 * b)

  q2 = r.hi / b.hi
  r = r - (q2 * b)

  q3 = r.hi / b.hi

  q1,q2 = eftAddGTE(q1, q2)
  q1,q2 = eftAdd3to2(q1,q2,q3)
  Digit30(q1,q2)
end


(/){T<:Real}(a::Digit30, b::T) = (/)(promote(a,b)...)
(/){T<:Real}(a::T, b::Digit30) = (/)(promote(a,b)...)

# powers


# roots

function sqrt(a::Digit30)
    if a.hi >= 0.0
       if a.hi == 0.0
           return zero(Digit30)
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
    r = Digit30(1.0/sqrt(a.hi), 0.0)

    r = r + divby2( r * (one(Digit30) - (a*(r*r))) )
    r = r + divby2( r * (one(Digit30) - (a*(r*r))) )
    r = r + divby2( r * (one(Digit30) - (a*(r*r))) )

    r = a*r
    #divby2(r + a/r)
    r += a/r
    divby2(r)
end




#=
#     for a in [1e-15..1e18]
      relerr ~1.3e-32  (106 bits)

function sqrt(a::Digit30)
    if a.hi <= zero(Float64)
       if a.hi == zero(Float64)
           return zero(Digit30)
       else
           throw(ArgumentError("sqrt expects a nonnegative base"))
       end
    elseif (a.hi < 1.0e-18) | (a.hi > 1.0e18)
        throw(ArgumentError("sqrt arg ($a) outside domain"))
    end

    if (a.hi < 1.0e-7)  # -log2(1.0e-7) < (1/2) Float64 significand bits
        return one(Digit30) / sqrt(one(Digit30)/a)
    end

    # initial approximation to 1/sqrt(a)
    r = Digit30(1.0/sqrt(a.hi), 0.0)

    r = r + divby2( r * (one(Digit30) - (a*(r*r))) )
    r = r + divby2( r * (one(Digit30) - (a*(r*r))) )
    r = r + divby2( r * (one(Digit30) - (a*(r*r))) )

    r = a*r
    divby2(r + a/r)
end
=#

function hypot(a::Digit30, b::Digit30)
    a = abs(a)
    b = abs(b)
    t, x = min(a,b), max(a,b)
    t = t/a
    x * sqrt(1.0 + t*t)
end
