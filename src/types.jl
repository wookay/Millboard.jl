# types
abstract type AbstractCell end

struct PreCell <: AbstractCell
  data::AbstractArray
  width::Int
  height::Int
end

struct Vertical <: AbstractCell
  data::String
  width::Int
  height::Int
  Vertical(height) = new("|", 1, height)
end

struct Dash <: AbstractCell
  data::String
  repeat::Int
  Dash(dash::String, n::Int) = new(dash, n)
end

struct Connector <: AbstractCell
  data::String
  Connector() = new("+")
end

mutable struct Cell <: AbstractCell
  data::AbstractArray
  width::Int
  height::Int
end

struct Margin
  leftside::Int
  rightside::Int
end

struct Mill
  board::AbstractArray
  option::Dict
  Mill(board, option::Dict) = new(board, option)
end

const Linear{T<:Union{AbstractCell}} = AbstractVector{T}
const Horizontal{T<:Union{Dash,Connector}} = AbstractVector{T}
const PlateVector{T<:Union{Linear,Horizontal}} = AbstractVector{T}
