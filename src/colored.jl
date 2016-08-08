# export colored


# types
type Colored
  color::Symbol
end

type Coat
  color::Symbol
  indexfunc::Function
end

type Coating
  color::Symbol
  data
end

immutable ANSIEscaped
  color::Symbol
  data
  ANSIEscaped(c, d) = isa(d, ANSIEscaped) ? new(c, d.data) : new(c, d)
end

immutable ANSIEscapedString
  data::String
  strwidth::Int
  length::Int
end


# colored
colored(color::Symbol) = check_have_color() && Colored(color)
colored(color::Symbol, indexfunc::Function) = check_have_color() && Coat(color, indexfunc)
colored(color::Symbol, indexfunc::Function, data) = check_have_color() && (Coat(color, indexfunc))(data)
colored(color::Symbol, data) = check_have_color() && (Coat(color, identity))(data)

function normal_color()
  is_windows() ? Base.text_colors[:bold] : Base.answer_color()
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


# Coating : getindex
Base.endof(c::Coating) = endof(c.data)
Base.ndims(c::Coating) = ndims(c.data)
Base.size(c::Coating, row::Int) = size(c.data, row)

function Base.SubString{T<:Coating}(s::T, i::Int, j::Int)
  pre = i>1 ? s.data[1:i-1] : ""
  post = j<Base.length(s.data) ? s.data[j+1:end] : ""
  normal = normal_color()
  str = s.data[i:j]
  ANSIEscapedString(string(normal, pre, ANSIEscaped(s.color, str), normal, post), strwidth(s.data), length(s.data))
end

function escape_precell(el::Any)
  el
end
function escape_precell(el::AbstractArray)
  precel = precell(el)
  join(map(precel.data) do x
    lpad(x, precel.width)
  end, "\n")
end

Base.getindex{T<:Coating}(a::T) = getindex(a, 1)
function Base.getindex{T<:Coating}(a::T, ind::Int)
  if isa(a.data, String)
    a.data = SubString(a, ind, ind)
  else
    m,n = arraysize(a.data)
    A = Array{Any}(m,n)
    A[:] = a.data
    A[ind] = ANSIEscaped(a.color, escape_precell(a.data[ind]))
    a.data = A
  end
end

function Base.getindex{T<:Coating}(a::T, ::Colon)
  if isa(a.data, String)
    a.data = ANSIEscaped(a.color, a.data)
  else
    a.data = map(a.data[:]) do el
      ANSIEscaped(a.color, escape_precell(el))
    end
  end
end

function Base.getindex{T<:Coating}(a::T, rang::UnitRange)
  if isa(a.data, String)
    a.data = SubString(a, rang.start, rang.stop)
  else
    m,n = arraysize(a.data)
    A = Array{Any}(m,n)
    A[:] = a.data
    A[rang] = map(a.data[rang]) do el
      ANSIEscaped(a.color, escape_precell(el))
    end
    a.data = A
  end
end

function Base.getindex{T<:Coating}(a::T, row, col)
  m,n = arraysize(a.data)
  A = Array{Any}(m,n)
  A[:] = a.data
  sub = map(a.data[row,col]) do el
    ANSIEscaped(a.color, escape_precell(el))
  end
  if !isa(sub, AbstractArray)
    sub = [sub][:,:]
  end
  q,r = arraysize(sub)
  if 1==q && 1==r
    A[row,col] = sub[q,r]
  else
    A[row,col] = sub
  end
  a.data = A
end

function Base.show(io::IO, c::Coating)
  print(io, c.data)
end

coating(c::Coating, ::Type{AbstractArray}) = (a->a[:,:])(c)
coating(c::Coating, ::Any) = ANSIEscaped(c.color, c.data)


# Coat
identityfunc(::AbstractArray) = a->a[:,:]
identityfunc(::Any) = a->a

(coat::Coat)(data::Function) = coating(Coating(coat.color, data), typeof(data))
(coat::Coat)(input::Tuple) = (coat)(rotl90(collect(input)[:,:]))
function (coat::Coat)(input)
  c = Coating(coat.color, input)
  coated = coat.indexfunc(c)
  if c==coated
    isa(input, AbstractArray) ? identityfunc(input)(c) : coating(c, typeof(input))
  else
    coated
  end
end


# Colored
(c::Colored)(data::Tuple) = (c)(rotl90(collect(data)[:,:]))
(c::Colored)(data::AbstractArray) = (Coat(c.color, identityfunc(data)))(data)
(c::Colored)(data::Any) = coating(Coating(c.color, data), typeof(data))

function (c::Colored)(func::Function)
  Coat(c.color, func)
end

function (c::Colored)(func::Function, data)
  (c)(func)(data)
end


# ANSIEscaped
Base.endof(ansi::ANSIEscaped) = endof(ansi.data)
Base.start(ansi::ANSIEscaped) = start(ansi.data)
Base.next(ansi::ANSIEscaped, b::Bool) = next(ansi.data, b)
Base.done(ansi::ANSIEscaped, b::Bool) = done(ansi.data, b)
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
    PreCell(isa(el.data, AbstractArray) ? el : [el], width, 1)
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
