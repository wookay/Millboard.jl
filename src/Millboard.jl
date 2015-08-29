module Millboard

export table


__precompile__(true)


# types
abstract AbstractCell

immutable PreCell <: AbstractCell
  data::AbstractArray
  width::Int
  height::Int
end

immutable Vertical <: AbstractCell
  data::AbstractString
  width::Int
  height::Int
  Vertical(height) = new("|", 1, height)
end

immutable Dash <: AbstractCell
  data::AbstractString
  repeat::Int
  Dash(dash::AbstractString, n::Int) = new(dash, n)
end

immutable Connector <: AbstractCell
  data::AbstractString
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


# Base.show
function Base.show(io::IO, vertical::Vertical)
  print(io, vertical.data)
end

function Base.show(io::IO, dash::Dash)
  print(io, repeat(dash.data, dash.repeat))
end

function Base.show(io::IO, connector::Connector)
  print(io, connector.data)
end

function Base.show(io::IO, mill::Mill)
  print(io, decking(mill))
end

function Base.show(io::IO, linear::Linear)
  firstcell = linear[2]
  assert(isa(firstcell, Cell))
  height = firstcell.height
  @inbounds for i=1:height
    for j=1:length(linear)
      cv = linear[j]
      if isa(cv, Vertical)
        print(io, cv)
      else
        cell = cv
        rows,cols = size(cell.data)
        if rows >= i
          for n=1:cols
            print(io, cell.data[i,n])
          end
        else
          print(io, repeat(" ", cell.width))
        end
      end
    end
    println(io)
  end
end

function Base.show(io::IO, horizon::Horizontal)
  for j=1:length(horizon)
    hr = horizon[j]
    print(io, hr)
  end
end

function Base.show(io::IO, plates::PlateVector)
  len = length(plates)
  @inbounds for i=1:len
    plate = plates[i]
    print(io, plate)
    if isa(plate, Horizontal) && len > i
      println(io)
    end
  end
end


# Base.isless
Base.isless(::AbstractString, ::Symbol) = false


# precell

precell(::Void) = PreCell([][:,:], 0, 0)

function precell(n::Number)
  str = string(n)
  PreCell([str][:,:], length(str), 1)
end

function precell(s::AbstractString)
  if contains(s, "\n") 
    a = split(s, "\n")[:,:]
    m,n = size(a)
    PreCell(a, maximum(map(length, a)), m)
  else
    PreCell([s][:,:], length(s), 1)
  end
end

function precell(a::AbstractArray)
  m,n = size(a[:,:])
  if 0==m
    PreCell([""][:,:], 0, 0)
  else
    widths = zeros(Int, m)
    prep = Vector{AbstractString}(m)
    @inbounds for i=1:m
      prep[i] = join(a[i,:], " ")
      widths[i] = length(prep[i])
    end
    PreCell(prep[:,:], maximum(widths), m)
  end
end

function precell(sym::Symbol)
  str = repr(sym)
  PreCell([str][:,:], length(str), 1)
end


# postcell

function postcell(precell::PreCell, width::Int, height::Int, margin::Margin)
  data = precell.data
  rows,cols = size(data)
  A = Array{AbstractString}(rows, cols)
  @inbounds for i=1:rows
    for j=1:cols
      el = data[i,j]
      A[i,j] = string(lpad(el, margin.leftside + width), repeat(" ", margin.rightside))
    end
  end
  Cell(A, width+margin.leftside+margin.rightside, height)
end

function horizontal(maxwidths::Vector{Int}, cols::Int, margin::Margin; dash="-")
  horizon = Horizontal{Union{Dash,Connector}}([]) 
  push!(horizon, Connector())
  @inbounds for j=1:cols
    width = maxwidths[j]
    push!(horizon, Dash(dash, width + margin.leftside + margin.rightside))
    push!(horizon, Connector())
  end 
  horizon
end

function vertical(maxheight::Int)
  Vertical(maxheight)
end

function marginal(option::Dict)
  Margin(1, 1) # fixed
end

function decking(mill::Mill)
  board = mill.board[:,:]
  option = mill.option

  # prepare precells
  preplates = PlateVector{Union{Linear}}([])
  rows,cols = size(board)
  widths = zeros(Int, rows+1, cols+1)
  heights = zeros(Int, rows+1, cols+1)

  headlinear = Linear{Union{AbstractCell}}([])
  zerocolname = nothing
  if haskey(option, :zerocolname)
    zerocolname = option[:zerocolname]
  end
  cell = precell(zerocolname)
  widths[1,1] = cell.width
  heights[1,1] = cell.height
  push!(headlinear, cell)
  precols = Vector{PreCell}(cols)
  for j=1:cols
    precols[j] = precell(j)
  end
  if haskey(option, :colnames)
    for (j,name) in enumerate(option[:colnames])
      precols[j] = precell(name)
    end
  end
  @inbounds for j=1:cols
    cell = precols[j]
    widths[1,j+1] = cell.width
    heights[1,j+1] = cell.height
    push!(headlinear, cell)
  end
  push!(preplates, headlinear)

  prerows = Vector{PreCell}(rows)
  for i=1:rows
    prerows[i] = precell(i)
  end
  if haskey(option, :rownames)
    for (i,name) in enumerate(option[:rownames])
      prerows[i] = precell(name)
    end
  end
  @inbounds for i=1:rows
    linear = Linear{Union{AbstractCell}}([])
    rownamecell = prerows[i]
    widths[1+i,1] = rownamecell.width
    heights[1+i,1] = rownamecell.height
    push!(linear, rownamecell)
    for j=1:cols
      cell = precell(board[i,j])
      widths[1+i,1+j] = cell.width
      heights[1+i,1+j] = cell.height
      push!(linear, cell)
    end
    push!(preplates, linear)
  end

  maxwidths = zeros(Int, cols+1)
  for j=1:cols+1
    maxwidths[j] = maximum(widths[:,j])
  end
  maxheights = zeros(Int, rows+1)
  for i=1:rows+1
    maxheights[i] = maximum(heights[i,:])
  end
  margin = marginal(option)
  if 0==rows
    cols = 1
  else
    rows += 1
    cols += 1
  end

  # decking
  plates = PlateVector{Union{Linear,Horizontal}}([])
  push!(plates, horizontal(maxwidths, cols, margin, dash="="))
  @inbounds for i=1:rows
    preplate = preplates[i]
    linear = Linear{Union{AbstractCell}}([])
    push!(linear, vertical(maxheights[i]))
    for j=1:cols
      precell = preplate[j]
      cell = postcell(precell, maxwidths[j], maxheights[i], margin)
      if 1==j && cell.height > 1
        prep = [repeat(" ", cell.width) for x in 1:(cell.height-length(cell.data))]
        cell.data = vcat(prep, cell.data)
      end
      push!(linear, cell)
      push!(linear, vertical(maxheights[i]))
    end
    push!(plates, linear)
    push!(plates, horizontal(maxwidths, cols, margin, dash=1==i ? "=" : "-"))
  end
  plates
end


# table
table{T}(board::T) = table(board, Dict())
table{T}(board::T, option::Pair...) = table(board, Dict(option))
table(board::AbstractArray, option::Dict) = Mill(board, option)
function table(board::Tuple, option::Dict)
  if 0==length(board)
    Mill([], option)
  else
    Mill(rotl90(collect(board)[:,:]), option)
  end
end
function table(board::Dict, option::Dict)
  if 0==length(board)
    Mill([], option)
  else
    opt = option
    if !haskey(option, :colnames)
      opt[:zerocolname] = "key"
      opt[:colnames] = ["value"]
    end
    opt[:rownames] = sort(collect(keys(board)))
    valuez = map(opt[:rownames]) do key
      board[key]
    end
    table(valuez, opt)
  end
end 
table{T<:Base.Enums.Enum}(board::T, option::Dict) = table(typeof(board), option)
function table{T<:Base.Enums.Enum}(board::Type{T}, option::Dict)
  opt = option
  enums = instances(board)
  opt[:rownames] = map(string, enums)
  if !haskey(option, :colnames)
    opt[:zerocolname] = string(board)
    opt[:colnames] = ["value"]
  end
  valuez = collect(map(enums) do typename
    string(Int(typename))
  end)
  table(valuez, opt)
end

end # module
