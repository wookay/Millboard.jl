# export table


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
        cel = cv
        rows,cols = arraysize(cel.data)
        if rows >= i
          for n=1:cols
            print(io, cel.data[i,n])
          end
        else
          print(io, repeat(" ", cel.width))
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
Base.isless(::String, ::Symbol) = false


# arraysize
arraysize(a::AbstractArray) = size(a[:,:])


# precell
precell(::Void) = PreCell([], 0, 0)

function precell(el::String)
  if contains(el, "\n")
    a = map(split(el, "\n")) do x
       width = strwidth(x)
       string(x, repeat(" ", width-strwidth(x)))
    end
    m,n = arraysize(a)
    PreCell(a, maximum(map(length, a)), m)
  else
    width = strwidth(el)
    PreCell([el], width, 1)
  end
end

function precell(el::AbstractArray)
  rows,cols = arraysize(el)
  if 0==rows
    PreCell([""], 0, 0)
  else
    prelines = similar(el, String)
    widths = zeros(Int, rows, cols)
    for i=1:rows
      for j=1:cols
        s = replace(string(el[i,j]), "\n", " ")
        widths[i,j] = length(s)
        prelines[i,j] = s
      end
    end
    maxwidths = zeros(Int, cols)
    for j=1:cols
      maxwidths[j] = maximum(widths[:,j])
    end

    lines = AbstractArray{String}([])
    for i=1:rows
      line = AbstractArray{String}([])
      for (j,x) in enumerate(prelines[i,:])
        push!(line, lpad(x, maxwidths[j]))
      end
      push!(lines, join(line, " "))
    end
    PreCell(lines, sum(maxwidths) + (cols-1), rows)
  end
end

function precell(el::Any)
  PreCell([el], length(repr(el)), 1)
end


# postcell
function postcell(precel::PreCell, width::Int, height::Int, margin::Margin)
  data = precel.data
  rows,cols = arraysize(data)
  A = Array{String}(rows, cols)
  @inbounds for i=1:rows
    for j=1:cols
      el = data[i,j]
      x = isa(el, String) ? el : repr(el)
      prep = repeat(" ", margin.leftside + width - strwidth(x))
      A[i,j] = string(prep, x, repeat(" ", margin.rightside))
    end
  end
  Cell(A, width+margin.leftside+margin.rightside, height)
end

function horizontal(maxwidths::Vector{Int}, cols::Int, margin::Margin; dash="-")
  horizon = Horizontal{Union{Dash,Connector}}([]) 
  push!(horizon, Connector())
  for j=1:cols
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
  board = mill.board
  option = mill.option

  # prepare precells
  preplates = PlateVector{Union{Linear}}([])
  rows,cols = arraysize(board)
  widths = zeros(Int, rows+1, cols+1)
  heights = zeros(Int, rows+1, cols+1)

  headlinear = Linear{Union{AbstractCell}}([])
  zerocolname = nothing
  if haskey(option, :zerocolname)
    zerocolname = option[:zerocolname]
  end
  cel = precell(zerocolname)
  widths[1,1] = cel.width
  heights[1,1] = cel.height
  push!(headlinear, cel)
  precols = Vector{PreCell}(cols)
  for j=1:cols
    precols[j] = precell(j)
  end
  if haskey(option, :colnames)
    @inbounds for (j,name) in enumerate(option[:colnames])
      if cols >= j
        precols[j] = precell(name)
      end
    end
  end
  for j=1:cols
    cel = precols[j]
    widths[1,j+1] = cel.width
    heights[1,j+1] = cel.height
    push!(headlinear, cel)
  end
  push!(preplates, headlinear)

  prerows = Vector{PreCell}(rows)
  for i=1:rows
    prerows[i] = precell(i)
  end
  if haskey(option, :rownames)
    @inbounds for (i,name) in enumerate(option[:rownames])
      if rows >= i
        prerows[i] = precell(name)
      end
    end
  end
  for i=1:rows
    linear = Linear{Union{AbstractCell}}([])
    rownamecell = prerows[i]
    widths[1+i,1] = rownamecell.width
    heights[1+i,1] = rownamecell.height
    push!(linear, rownamecell)
    for j=1:cols
      cel = precell(board[i,j])
      widths[1+i,1+j] = cel.width
      heights[1+i,1+j] = cel.height
      push!(linear, cel)
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
    maxheight = maxheights[i]
    for j=1:cols
      precel = preplate[j]
      cel = postcell(precel, maxwidths[j], maxheight, margin)
      if 1==j && cel.height > 1
        prep = [repeat(" ", cel.width) for x in 1:(cel.height-length(cel.data))]
        cel.data = vcat(prep, cel.data)
      end
      push!(linear, cel)
      push!(linear, vertical(maxheight))
    end
    push!(plates, linear)
    push!(plates, horizontal(maxwidths, cols, margin, dash=1==i ? "=" : "-"))
  end
  plates
end


# table
table{T}(board::T) = table(board, Dict())
table{T}(board::T, option::Pair...) = table(board, Dict(option))
table(board::Any, option::Dict) = table([board], option)
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
