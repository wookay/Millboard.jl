__precompile__(true)

module Millboard

include("types.jl")

export set_table_mode
include("table_modes.jl")

export table
include("table.jl")

export colored
include("colored.jl")

end # module
