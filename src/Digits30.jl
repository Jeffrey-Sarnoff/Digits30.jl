module Digits30

import Base: convert, promote_rule, hash, string, show,
             zero, one, isinf, isnan, isfinite,
             (-), abs, sign, signbit, copysign, flipsign,
             isequal, isless, (<),(<=),(==),(>=),(>),
             (+),(*),(/),(\) 

export Digit30, D30,
       iszero, ispos, ispoz, isneg

using ErrorfreeArithmetic

include("type/concrete.jl")
include("type/convert.jl")
include("type/primitive.jl")
include("type/predicates.jl")
include("type/comparatives.jl")
include("type/io.jl")

include("arith/ops.jl")

end # Digits30
