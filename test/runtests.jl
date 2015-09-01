using Millboard
using Base.Test

include(joinpath(dirname(@__FILE__),"numbers.jl"))
include(joinpath(dirname(@__FILE__),"strings.jl"))
include(joinpath(dirname(@__FILE__),"dicts.jl"))
include(joinpath(dirname(@__FILE__),"enums.jl"))
include(joinpath(dirname(@__FILE__),"functions.jl"))
include(joinpath(dirname(@__FILE__),"tuples.jl"))
include(joinpath(dirname(@__FILE__),"types.jl"))
include(joinpath(dirname(@__FILE__),"unicode.jl"))
include(joinpath(dirname(@__FILE__),"regex.jl"))

if Base.have_color
  include(joinpath(dirname(@__FILE__),"colored.jl"))
end
