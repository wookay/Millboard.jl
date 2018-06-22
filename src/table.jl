const colnames_style = Dict(:color=>:yellow,)
const rownames_style = Dict(:color=>:cyan,)

# Base.show
function Base.show(io::IO, colored::ColoredString)
    if Base.have_color && colored.style isa Dict
         printstyled(io, colored.data, color=colored.style[:color])
    else
         print(io, colored.data)
    end
end

function Base.show(io::IO, v::Vertical)
    print(io, v.data)
end

function Base.show(io::IO, dash::Dash)
    print(io, repeat(dash.data, dash.repeat))
end

function Base.show(io::IO, connector::Connector)
    print(io, connector.data)
end

function print_plate(io::IO, horizon::Horizontal, isgridtables::Bool, islast::Bool)
    for j=1:length(horizon)
        hr = horizon[j]
        print(io, hr)
    end
    !islast && println(io)
end

function print_plate(io::IO, linear::Linear, isgridtables::Bool, islast::Bool)
    isempty(linear) && return
    firstcell = first(linear)
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
        if !isgridtables && i==height
            !islast && println(io)
        else
            println(io)
        end
    end
end

function print_plates(io::IO, plates::PlateVector, tablemode::TableMode)
    isgridtables = :grid_tables == tablemode.style
    len = length(plates)
    @inbounds for i=1:len
        plate = plates[i]
        print_plate(io, plate, isgridtables, i==len)
    end
end

function Base.show(io::IO, mill::Mill)
    tablemode = display_style[:table_mode]
    plates = decking(mill, tablemode)
    print_plates(io, plates, tablemode)
end


# Base.isless
Base.isless(::String, ::Symbol) = false


# arraysize
arraysize(a::AbstractArray) = size(a[:,:])


# precell
precell(::Nothing, style=nothing) = DataCell([], 0, 0, style)

function precell(el::String, style=nothing)
    if occursin("\n", el)
        a = map(split(el, "\n")) do x
            width = textwidth(x)
            string(x, repeat(" ", width-textwidth(x)))
        end
        m,n = arraysize(a)
        DataCell(a, maximum(map(length, a)), m, style)
    else
        width = textwidth(el)
        DataCell([el], width, 1, style)
    end
end

function precell(el::AbstractArray, style=nothing)
    rows,cols = arraysize(el)
    if 0==rows
        DataCell([""], 0, 0, style)
    else
        prelines = similar(el, String)
        widths = zeros(Int, rows, cols)
        for i=1:rows
            for j=1:cols
                s = replace(string(el[i,j]), "\n" => " ")
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
        DataCell(lines, sum(maxwidths) + (cols-1), rows, style)
    end
end

function precell(el::Any, style=nothing)
    DataCell([el], length(repr(el)), 1, style)
end


# postcell
function postcell(cell::DataCell, width::Int, height::Int, margin::Margin)
    data = cell.data
    rows,cols = arraysize(data)
    A = Array{ColoredString}(undef, rows, cols)
    @inbounds for i=1:rows
        for j=1:cols
            el = data[i,j]
            x = isa(el, String) ? el : repr(el)
            prep = repeat(" ", margin.leftside + width - textwidth(x))
            A[i,j] = ColoredString(string(prep, x, repeat(" ", margin.rightside)), cell.style)
        end
    end
    Cell(A, width+margin.leftside+margin.rightside, height)
end

function horizontal(maxwidths::Vector{Int}, cols::Int, margin::Margin, tablemode::TableMode; dash="-")
    corner_corner = string(tablemode.corner_corner)
    horizon = Horizontal{Union{Dash,Connector}}([])
    push!(horizon, Connector(corner_corner))
    for j=1:cols
        width = maxwidths[j]
        push!(horizon, Dash(dash, width + margin.leftside + margin.rightside))
        push!(horizon, Connector(corner_corner))
    end
    horizon
end

function marginal(option::Dict{Symbol,Any})
    Margin(1, 1) # fixed
end

function decking(mill::Mill, tablemode::TableMode)
    board = mill.board
    option = mill.option
    isgridtables = :grid_tables == tablemode.style
    header_fillchar = string(tablemode.header_fillchar)

    rows,cols = arraysize(board)
    plates = PlateVector{Union{Linear,Horizontal}}([])
    if 0==rows
        return plates
    end

    widths = zeros(Int, rows+1, cols+1)
    heights = zeros(Int, rows+1, cols+1)
    # prepare ells
    preplates = Vector{Vector{DataCell}}([])
    headlinear = Vector{Union{DataCell,Vertical}}([])
    zerocolname = nothing
    if haskey(option, :zerocolname)
        zerocolname = option[:zerocolname]
    end
    cel = precell(zerocolname, colnames_style)
    widths[1,1] = cel.width
    heights[1,1] = cel.height
    push!(headlinear, cel)
    ols = Vector{DataCell}(undef, cols)
    for j=1:cols
        ols[j] = precell(j, colnames_style)
    end
    if haskey(option, :colnames)
        @inbounds for (j,name) in enumerate(option[:colnames])
            if cols >= j
                ols[j] = precell(name, colnames_style)
            end
        end
    end
    for j=1:cols
        cel = ols[j]
        widths[1,j+1] = cel.width
        heights[1,j+1] = cel.height
        push!(headlinear, cel)
    end
    push!(preplates, headlinear)

    prerows = Vector{DataCell}(undef, rows)
    for i=1:rows
        prerows[i] = precell(i, rownames_style)
    end
    if haskey(option, :rownames)
        @inbounds for (i,name) in enumerate(option[:rownames])
            if rows >= i
                prerows[i] = precell(name, rownames_style)
            end
        end
    end
    for i=1:rows
        linear = Vector{Union{DataCell,Vertical}}([])
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

    isgridtables && push!(plates, horizontal(maxwidths, cols, margin, tablemode, dash="-"))
    @inbounds for i=1:rows
        linear = Linear{Union{Cell,Vertical}}([])
        preplate = preplates[i]
        push!(linear, Vertical(maxheights[i]))
        maxheight = maxheights[i]
        for j=1:cols
            el = preplate[j]
            cel = postcell(el, maxwidths[j], maxheight, margin)
            if 1==j && cel.height > 1
                prep = [repeat(" ", cel.width) for x in 1:(cel.height-length(cel.data))]
                cel.data = vcat(prep, cel.data)
            end
            push!(linear, cel)
            push!(linear, Vertical(maxheight))
        end
        push!(plates, linear)
        (1==i || isgridtables) && push!(plates, horizontal(maxwidths, cols, margin, tablemode, dash = 1==i ? header_fillchar : "-"))
    end
    plates
end

function optiondict(options)::Dict{Symbol,Any}
    if VERSION >= v"0.7.0-"
        Dict{Symbol,Any}(pairs(options))
    else
        Dict{Symbol,Any}(collect(options))
    end
end

# table
table(board::Any; options...) = Mill([board], optiondict(options))
table(board::AbstractArray; options...) = Mill(board, optiondict(options))
table(board::Tuple; options...) = Mill(collect(board), optiondict(options))

function table(board::Dict; options...)
    option = optiondict(options)
    if !haskey(option, :colnames)
        option[:zerocolname] = "KEY"
        option[:colnames] = ["VALUE"]
    end
    rownames = sort(collect(keys(board)))
    option[:rownames] = rownames
    Mill(getindex.(Ref(board), rownames), option)
end 

table(board::T; options...) where {T<:Base.Enums.Enum} = table(typeof(board), options...)
function table(board::Type{T}; options...) where {T<:Base.Enums.Enum}
    option = optiondict(options)
    enums = instances(board)
    option[:rownames] = map(string, enums)
    if !haskey(option, :colnames)
        option[:zerocolname] = string(board)
        option[:colnames] = ["VALUE"]
    end
    Mill(string.(Int.(collect(enums))), option)
end
