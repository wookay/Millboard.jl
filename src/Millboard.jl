__precompile__(true)

module Millboard

using Compat
import Compat: Nothing, undef, textwidth, occursin, pairs, printstyled

include("types.jl")
include("table_modes.jl")

export table
include("table.jl")

end # module
