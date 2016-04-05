VERSION > v"0.4.9" && __precompile__()

module Floats120

import Base: convert, promote_rule, hash, string, show,
             zero, one, isinf, isnan, isfinite,
             (-), abs, sign, signbit, copysign, flipsign,
             isequal, isless, (<),(<=),(==),(>=),(>),
             min, max, minmax,
             trunc, round, floor, ceil,
             (+),(*),(/),(\),sqrt,hypot,
             (%),mod,rem,div,fld,cld,divrem,fldmod,
             fma

export Float120, F120,
       iszero, ispos, ispoz, isneg,
       maxmin,
       mulby2, divby2, mulbypow2, divbypow2,
       sqr, recip,
       fms

using ErrorfreeArithmetic

include("type/concrete.jl")
include("type/convert.jl")
include("type/primitive.jl")
include("type/predicates.jl")
include("type/comparatives.jl")
include("type/io.jl")

include("arith/ops.jl")
include("arith/moddiv.jl")
include("arith/round.jl")

end # Floats120
