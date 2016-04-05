
for (fn) in (:floor, :ceil, :round)
  @eval begin
    function ($fn)(a::Float120)
        hi = ($fn)(a.hi)
        lo = 0.0
        if (hi == a.hi)
            lo = ($fn)(a.lo)
            hi,lo = eftAddGTE(hi,lo)
        end
        DD(hi,lo)
    end    
  end        
end

function (trunc)(a::Float120)
    ifelse(a.hi < zero(Float64), ceil(a), floor(a))
end

"""
stretch is the opposite of trunc()
it extends to the nearest integer away from zero
"""
function (stretch)(a::Float120)
    ifelse(a.hi < zero(Float64), floor(a), ceil(a))
end
