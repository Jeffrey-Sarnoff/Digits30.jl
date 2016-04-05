# predicates

isnan(a::Float120)        = isnan(a.hi)
isinf(a::Float120)        = isinf(a.hi)
isfinite(a::Float120)     = isfinite(a.hi)
issubnormal(a::Float120)  = issubnormal(a.hi)

iszero(a::Float120)       = (a.hi == zero(typeof(a.hi)))
ispos(a::Float120)        = (a.hi >= zero(typeof(a.hi)))
ispoz(a::Float120)        = !signbit(a.hi)
isneg(a::Float120)        = signbit(a.hi)
