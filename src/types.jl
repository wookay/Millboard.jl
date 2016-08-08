# types
abstract AbstractCell

immutable PreCell <: AbstractCell
  data::AbstractArray
  width::Int
  height::Int
end

immutable Vertical <: AbstractCell
  data::String
  width::Int
  height::Int
  Vertical(height) = new("|", 1, height)
end

immutable Dash <: AbstractCell
  data::String
  repeat::Int
  Dash(dash::String, n::Int) = new(dash, n)
end

immutable Connector <: AbstractCell
  data::String
  Connector() = new("+")
end

type Cell <: AbstractCell
  data::AbstractArray
  width::Int
  height::Int
end

type Margin
  leftside::Int
  rightside::Int
end

type Mill
  board::AbstractArray
  option::Dict
  Mill(board, option::Dict) = new(board, option)
end

typealias Linear{T<:Union{AbstractCell}} AbstractVector{T}
typealias Horizontal{T<:Union{Dash,Connector}} AbstractVector{T}
typealias PlateVector{T<:Union{Linear,Horizontal}} AbstractVector{T}
