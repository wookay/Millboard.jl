module Millboard

export Mill, table

type Mill
  board::Union{Array,Tuple}
  option::Dict
  Mill(board) = new(board, Dict())
  Mill(board, option::Pair) = new(board, Dict(option))
end

type Tile
  clay::Array{AbstractString, 2}
  breadth::Array{Int, 2}
end

function slate(tile::Tile)
  width = ceil(Int, mean(tile.breadth))
  m,n = size(tile.clay)
  A = similar(tile.clay, AbstractString)
  for i=1:m
    for j=1:n
      A[i,j] = lpad(tile.clay[i,j], width) 
    end
  end
  [join(A[i,:], " ") for i=1:m]
end

function cell(box::Array)
  m,n = size(box)
  A = similar(box, AbstractString)
  W = similar(box, Int)
  for i=1:m
    for j=1:n
      el = box[i,j] |> string
      A[i,j] = el
      W[i,j] = length(el)
    end
  end
  slate(Tile(A, W))
end

function cell(box::Number)
  el = box |> string
  A = [el][:,:]
  W = [length(el)][:,:]
  slate(Tile(A, W))
end


# table

function table(board::Array, ::Type{Val{:Number}})
  rows,cols = size(board)
  B = Array(Any, rows, cols)
  S = similar(B, Int)
  for i=1:rows
    for j=1:cols
      c = board[i,j] |> string
      B[i,j] = c
      S[i,j] = length(c)
    end
  end
  B,S
end

function table(board::Array)
  if eltype(board) <: Number
    table(board, Val{:Number})
  end
end

function table(board::Tuple)
  cols = length(board)
  rows = size(first(board), 1)
  B = Array(Any, rows, cols)
  S = similar(B, Int)
  for j=1:cols
    c = cell(board[j])
    for i=1:rows
      B[i,j] = c[i]
      S[i,j] = length(c[i])
    end
  end
  B,S
end

function table(mill::Mill)
  B,S = table(mill.board)
  rows,cols = size(S)
  buf = IOBuffer()
  if haskey(mill.option, :title)
    writeln(buf, border(S,"=","+"))
    A = Array(AbstractString, 1, cols)
    for j=1:cols
      titles = mill.option[:title]
      title = titles[j]
      A[1,j] = Base.cpad(title, S[1,j])
    end
    l = join(A, " | ") |> surround
    writeln(buf, l)
    writeln(buf, border(S,"=","+"))
  else
    writeln(buf, border(S,"-","+"))
  end
  for i=1:rows
    l = join(B[i,:], " | ") |> surround
    writeln(buf, l)
  end
  write(buf, border(S,"-","+"))
  takebuf_string(buf)
end


# border
surround(s;space=" ", outer="|") = "$outer$space$s$space$outer"

function border(S, line, edge)
  surround(join([repeat(line,n) for n in S[1,:]], "$line$edge$line"), space=line, outer=edge)
end


# io
writeln(buf::IO, s) = write(buf, "$s\n")

end # module
