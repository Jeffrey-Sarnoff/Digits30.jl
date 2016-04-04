module Digits30

import Base: convert, promote_rule, hash, string, show

export Digit30, Dig30, D30

include("type/concrete.jl")
include("type/convert.jl")
include("type/io.jl")


end # Digits30
