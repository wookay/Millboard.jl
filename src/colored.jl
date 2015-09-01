# export colored


# types
type Coat
  func::Function
  color::Symbol
  data
end

immutable ANSIEscaped
  color::Symbol
  data
  ANSIEscaped(c, d) = isa(d, ANSIEscaped) ? new(c, d.data) : new(c, d)
end

immutable ANSIEscapedString
  data::AbstractString
  strwidth::Int
  length::Int
end


# color
colored(func::Function, color::Symbol) = check_have_color() && Coat(func, color, nothing)
colored(func::Function, color::Symbol, data) = check_have_color() && func(Coat(func, color, data))

function normal_color()
  @windows ? Base.text_colors[:bold] : Base.answer_color()
end

function check_have_color()
  if Base.have_color
    print(normal_color())
    true
  else
    throw(ArgumentError("run julia with --color=yes"))
    false
  end
end


# Coat
Base.endof(c::Coat) = endof(c.data)
Base.ndims(c::Coat) = ndims(c.data)
Base.size(c::Coat, row::Int) = size(c.data, row)

function Base.SubString{T<:Coat}(s::T, i::Int, j::Int)
  pre = i>1 ? s.data[1:i-1] : ""
  post = j<Base.length(s.data) ? s.data[j+1:end] : ""
  normal = normal_color()
  str = s.data[i:j]
  ANSIEscapedString(string(normal, pre, ANSIEscaped(s.color, str), normal, post), strwidth(s.data), length(s.data))
end

Base.getindex{T<:Coat}(a::T) = getindex(a, 1)
function Base.getindex{T<:Coat}(a::T, ind::Int)
  m,n = arraysize(a.data)
  A = Array{Any}(m,n)
  A[:] = a.data
  el = a.data[ind]
  if isa(el, AbstractArray)
    precel = precell(el)
    el = join(map(precel.data) do x
      lpad(x, precel.width)
    end, "\n")
  end
  A[ind] = ANSIEscaped(a.color, el)
  a.data = A
end

function Base.getindex{T<:Coat}(a::T, ::Colon)
  a.data = map(a.data[:]) do el
    ANSIEscaped(a.color, el)
  end
end

function Base.getindex{T<:Coat}(a::T, rang::UnitRange)
  if isa(a.data, AbstractString)
    a.data = SubString(a, rang.start, rang.stop)
  else
    m,n = arraysize(a.data)
    A = Array{Any}(m,n)
    A[:] = map(string, a.data)
    sub = map(a.data[rang]) do el
      ANSIEscaped(a.color, el)
    end
    A[rang] = sub
    a.data = A
  end
end

function Base.getindex{T<:Coat}(a::T, row, col)
  m,n = arraysize(a.data)
  A = Array{Any}(m,n)
  A[:] = a.data
  sub = map(a.data[row,col]) do el
    ANSIEscaped(a.color, el)
  end
  A[row,col] = sub
  a.data = A
end

function call(coat::Coat, data::Union{AbstractArray,AbstractString,Tuple})
  input = isa(data, Tuple) ? rotl90(collect(data)[:,:]) : data
  c = Coat(coat.func, coat.color, input)
  coated = coat.func(c)
  c == coated ? getindex(c, :) : coated
end


# ANSIEscaped
Base.endof(ansi::ANSIEscaped) = endof(ansi.data)
Base.next(ansi::ANSIEscaped, i::Int) = next(ansi.data, i)
Base.strwidth(ansi::ANSIEscaped) = strwidth(string(ansi.data))
Base.length(ansi::ANSIEscaped) = length(string(ansi.data))
Base.repr(ansi::ANSIEscaped) = ansi

function Base.show(io::IO, a::AbstractArray{ANSIEscaped,1})
  for ansi in a
    print_with_color(ansi.color, io, ansi.data)
  end
end

function Base.show(io::IO, ansi::ANSIEscaped)
  print_with_color(ansi.color, io, string(ansi.data))
  print(io, normal_color())
end

function precell(el::ANSIEscaped)
  s = string(el.data)
  if contains(s, "\n")
    a = AbstractArray{ANSIEscaped}([])
    widths = AbstractArray{Int}([])
    for x in split(s, "\n")
       width = strwidth(x)
       str = string(" ", x, repeat(" ", width-length(x)))
       push!(widths, width)
       push!(a, ANSIEscaped(el.color, str))
    end
    m,n = arraysize(a)
    PreCell(a, maximum(widths), m)
  else
    width = strwidth(s)
    PreCell([el], width, 1)
  end
end


# ANSIEscapedString
Base.endof(ansi::ANSIEscapedString) = endof(ansi.data)
Base.next(ansi::ANSIEscapedString, i::Int) = next(ansi.data, i)
Base.strwidth(ansi::ANSIEscapedString) = ansi.strwidth
Base.length(ansi::ANSIEscapedString) = ansi.length
Base.repr(ansi::ANSIEscapedString) = ansi
function Base.show(io::IO, ansi::ANSIEscapedString)
  print(io, ansi.data)
end
