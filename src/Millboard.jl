module Millboard

export table


# types

type Mill
  board::Array
  option::Dict
  Mill(board, option::Dict) = new(board, option)
end

type Cell{T}
  data::T
  width::Int
  rows::Int
  cols::Int
end

type Dash
  data::AbstractString
  repeat::Int
  Dash(dash::AbstractString, n::Int) = new(dash, n)
  Dash(n::Int) = new("-", n)
end

type Connector
  data::AbstractString
  Connector() = new("+")
end

type Vertical
  width::Int
  height::Int
  data::AbstractString
  Vertical(height) = new(1, height, "|")
end

typealias Linear{T<:Union{Cell,Vertical}} AbstractVector{T}
typealias Horizontal{T<:Union{Dash,Connector}} AbstractVector{T}
typealias Plate{T<:Union{Linear,Horizontal}} AbstractVector{T}


# functions - show

function Base.show(io::IO, dash::Dash)
  print(io, repeat(dash.data, dash.repeat))
end


function Base.show(io::IO, mill::Mill)
  print(io, decking(mill))
end

function Base.show(io::IO, horizontal::Horizontal)
  for j=1:length(horizontal)
    h = horizontal[j]
    print(io, h)
  end
end

function Base.show(io::IO, connector::Connector)
  print(io, connector.data)
end

function Base.show(io::IO, cell::Cell)
  print(io, cell.data)
end

function Base.show(io::IO, vertical::Vertical)
  print(io, vertical.data)
end

function Base.show(io::IO, linear::Linear)
  firstunit = linear[2] # Cell
  assert(isa(firstunit, Cell))
  if isa(firstunit, Vertical)
    print(io, firstunit)
  else
    height = firstunit.rows
    if height > 1
      for row=1:height
        for i=1:length(linear)
          unit = linear[i]
          width = unit.width
          if isa(unit, Cell)
            if 0==unit.rows
              print(io, lpad("", width))
            else
              if isa(unit.data, AbstractArray)
                print(io, lpad(string(join(unit.data[row,:], " "), " "), width+2))
              else
                if 1==unit.rows
                  if height==row
                    print(io, lpad(string(unit.data, " "), width+2))
                  else
                    print(io, lpad(" ", width+2))
                  end
                else
                  print(io, lpad(unit.data, width+1))
                end
              end
            end
          else
            print(io, lpad(unit, width))
          end
        end
        row!=height && println(io)
      end
    else
      len = length(linear)
      for i=1:len
        unit = linear[i]
        width = unit.width
        if isa(unit, Vertical) && len==i
          print(io, lpad(string(unit), width))
        else
          print(io, lpad(string(unit, " "), width))
        end
      end
    end
  end
end

function Base.show(io::IO, plates::Plate)
  for i=1:length(plates)
    i>1 && println(io)
    plate = plates[i]
    print(io, plate)
  end
end


# functions - cell

function cell_for_row(row::Int, width::Int, height::Int)
  if height > 1
    a = Array{Union{AbstractString,Int}}(height)
    for i=1:height-1
      a[i] = ""
    end
    a[height] = row
    Cell(a[:,:], width, height, 1)
  else
    Cell(row, width+1, height, 1)
  end
end

function cell_repr(b)
  if isa(b, AbstractArray)
    crow,ccol = size(b[:,:])
    0==crow && return " "
    1==crow && return join(b, " ")
  end
  b
end


# functions - decking

function decking(mill::Mill)
  board = mill.board[:,:]
  rows,cols = size(board)
  plates = Plate{Union{Linear,Horizontal}}([])
  cellwidths = zeros(Int, rows, cols)
  cellrows = zeros(Int, rows, cols)
  cellcols = zeros(Int, rows, cols)
  cellwidthmax = zeros(Int, 1, cols)
  for i=1:rows
    for j=1:cols
      b = cell_repr(board[i,j])
      if isa(b, AbstractArray)
        crow,ccol = size(b[:,:])
        width = 0
        for ci=1:crow
          width = max(width, length(join(b[ci,:], " ")))
        end
        cellwidths[i,j],cellrows[i,j],cellcols[i,j] = width,crow,ccol
      else
        cellwidths[i,j],cellrows[i,j],cellcols[i,j] = length(string(b)),1,1
      end
    end
  end

  firstcellwidth = 2
  if rows > 0
    for j=1:cols
      cellwidthmax[j] = maximum(cellwidths[:,j])
    end
    for i=1:rows
      linear = Linear{Union{Cell,Vertical}}([])
      for j=1:cols
        b = cell_repr(board[i,j])
        cell = Cell(b, cellwidthmax[j], cellrows[i,j], cellcols[i,j])
        push!(linear, cell)
      end
      push!(plates, linear)
    end

    firstcellwidths = zeros(Int, rows)
    for i=1:rows
      firstcellwidths[i] = length(string(i))
    end
    firstcellwidth = maximum(firstcellwidths)
  end

  deck = Plate{Union{Linear,Horizontal}}([])

  function horizontal(deck; dash="-")
    h = Horizontal{Union{Dash,Connector}}([])
    push!(h, Connector())
    push!(h, Dash(dash, firstcellwidth+2))
    push!(h, Connector())
    for j=1:cols
      push!(h, Dash(dash, cellwidthmax[j]+2))
      push!(h, Connector())
    end
    if rows > 0
    else
      push!(h, Dash(dash, 2))
    end
    push!(deck, h)
  end

  if rows > 0
    horizontal(deck, dash="=")

    linear = Linear{Union{Cell,Vertical}}([])
    push!(linear, Vertical(1))
    push!(linear, Cell(" ", firstcellwidth+1, 1, 1))
    push!(linear, Vertical(1))
    for j=1:cols
      push!(linear, Cell(lpad(string(j), cellwidthmax[j]), cellwidthmax[j], 1, 1))
      push!(linear, Vertical(1))
    end
    push!(deck, linear)
  end

  horizontal(deck, dash="=")

  for i=1:rows
    linear = Linear{Union{Cell,Vertical}}([])
    push!(linear, Vertical(1))
    height = maximum(cellrows[i,:])
    push!(linear, cell_for_row(i, firstcellwidth, height))
    plate = plates[i]
    push!(linear, Vertical(height))
    for j=1:length(plate)
      push!(linear, plate[j])
      push!(linear, Vertical(height))
    end
    push!(deck, linear)
    horizontal(deck)
  end
  deck
end


# functions - table

table(board::Array) = Mill(board, Dict())
table(board::Array, option::Pair...) = Mill(board, Dict(option))
table(board::Tuple, option::Pair...) = Mill(rotl90(collect(board)[:,:]), Dict(option))

end # module
