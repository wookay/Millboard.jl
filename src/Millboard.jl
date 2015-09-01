module Millboard


__precompile__(true)


include("types.jl")

export table
include("table.jl")

export colored
include("colored.jl")

end # module
