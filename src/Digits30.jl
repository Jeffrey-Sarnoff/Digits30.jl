module Digits30

import Base: convert, promote_rule, hash, string, show

export Digit30, Dig30, D30

using ErrorfreeArithmetic

include("type/concrete.jl")
include("type/convert.jl")
include("type/io.jl")
include("type/primitive.jl")


end # Digits30
