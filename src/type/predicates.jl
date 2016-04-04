# predicates

isnan(a::Digit30)        = isnan(a.hi)
isinf(a::Digit30)        = isinf(a.hi)
isfinite(a::Digit30)     = isfinite(a.hi)
issubnormal(a::Digit30)  = issubnormal(a.hi)

iszero(a::Digit30)       = (a.hi == zero(typeof(a.hi)))
ispos(a::Digit30)        = (a.hi >= zero(typeof(a.hi)))
ispoz(a::Digit30)        = !signbit(a.hi)
isneg(a::Digit30)        = signbit(a.hi)
