# types

abstract type AbstractCell end

struct DataCell <: AbstractCell
    data::AbstractArray
    width::Int
    height::Int
    style::Union{Nothing,Dict}
end

struct ColoredString
    data::String
    style::Union{Nothing,Dict}
end

struct Vertical <: AbstractCell
    data::String
    width::Int
    height::Int
    Vertical(height::Int) = new("|", 1, height)
end

struct Dash <: AbstractCell
    data::String
    repeat::Int
    Dash(dash::String, n::Int) = new(dash, n)
end

struct Connector <: AbstractCell
    data::String
    Connector(data::String) = new(data)
end

mutable struct Cell <: AbstractCell
    data::AbstractArray
    width::Int
    height::Int
end

mutable struct Margin
    leftside::Int
    rightside::Int
end

struct Mill
    board::AbstractArray
    option::Dict{Symbol,Any}
    Mill(board, option::Dict{Symbol,Any}) = new(board, option)
end

const Linear{T} = AbstractVector{T} where T <: Union{Cell, Vertical}
const Horizontal{T} = AbstractVector{T} where T <: Union{Dash, Connector}
const PlateVector{T} = AbstractVector{T} where T <: Union{Linear, Horizontal}

struct TableMode
    style::Symbol
    corner_corner::Char
    header_fillchar::Char
    TableMode(style::Symbol; corner_corner::Char = '|', header_fillchar::Char = '-') = new(style, corner_corner, header_fillchar)
end
