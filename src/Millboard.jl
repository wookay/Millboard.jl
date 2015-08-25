module Millboard

export Mill, table

type Mill
  board::Union{Array,Tuple}
  option::Dict
  Mill(board) = new(board, Dict())
  Mill(board, option::Pair) = new(board, Dict(option))
  Mill(board, option...) = new(board, Dict(option))
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

function cell(box::Array, option::Dict)
  m,n = size(box[:,:])
  0 == m && return [" "]
  A = similar(box, AbstractString)
  W = similar(box, Int)
  box_repr = string
  if haskey(option, :repr)
    box_repr = option[:repr]
  end
  for i=1:m
    for j=1:n
      el = box[i,j] |> box_repr
      A[i,j] = el
      W[i,j] = length(el)
    end
  end
  slate(Tile(A, W))
end

function cell(box::Number, option::Dict)
  el = box |> string
  A = [el][:,:]
  W = [length(el)][:,:]
  slate(Tile(A, W))
end


# table

function table(mill::Mill)
  B,S = table_board(mill.board, mill.option)
  rows,cols = size(S)
  buf = IOBuffer()
  if haskey(mill.option, :title)
    writeln(buf, border(S,"=","+"))
    A = Array(AbstractString, 1, cols)
    for j=1:cols
      titles = mill.option[:title]
      title = string(titles[j])
      title_width = S[1,j] + 2
      if haskey(mill.option, :has_long_title) && mill.option[:has_long_title]
        A[1,j] = Base.cpad(title, title_width)
      else
        if length(title) > title_width
          A[1,j] = Base.cpad(title[1:title_width], title_width)
        else
          A[1,j] = Base.cpad(title, title_width)
        end
      end
    end
    l = surround(join(A, "|"), space="")
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


function table_board(board::Tuple, option::Dict)
  table_array(collect(board), option)
end

function table_board(board::Array, option::Dict)
  if eltype(board) <: Number
    table_number(board, option)
  elseif eltype(board) <: Any
    table_array(board, option)
  end
end

function table_number(board::Array, option::Dict)
  rows,cols = size(board)
  B = Array(Any, rows, cols)
  S = similar(B, Int)
  for i=1:rows
    for j=1:cols
      c = board[i,j] |> string
      B[i,j] = c
      if haskey(option, :has_long_title) && option[:has_long_title]
        S[i,j] = max(option[:title][i], length(c))
      else
        S[i,j] = length(c)
      end
    end
  end
  B,S
end

function table_array(board::AbstractArray, option::Dict)
  cols = length(board)
  rows = 0
  for b in board
    rows = max(rows, size(b, 1))
  end
  B = Array(Any, rows, cols)
  S = similar(B, Int)
  for j=1:cols
    c = cell(board[j], option)
    len_c = length(c)
    for i=1:rows
      if len_c >= i
        if haskey(option, :has_long_title) && option[:has_long_title]
          S[i,j] = max(length(string(option[:title][j])), length(c[i]))
          B[i,j] = Base.cpad(c[i], S[i,j])
        else
          S[i,j] = length(c[i])
          B[i,j] = c[i]
        end
      else
        if len_c > 0
          S[i,j] = S[1,j]
          B[i,j] = Base.cpad("", S[1,j])
        end
      end
    end
  end
  B,S
end


# border
surround(s;space=" ", outer="|") = "$outer$space$s$space$outer"

function border(S, line, edge)
  surround(join([repeat(line,n) for n in S[1,:]], "$line$edge$line"), space=line, outer=edge)
end


# io
writeln(buf::IO, s) = write(buf, "$s\n")

end # module
