# Millboard

|  **Documentation**                        |  **Build Status**                                                |
|:-----------------------------------------:|:----------------------------------------------------------------:|
|  [![][docs-latest-img]][docs-latest-url]  |  [![][travis-img]][travis-url]  [![][codecov-img]][codecov-url]  |


Get julia data in a tablized format to arrange into rows and columns of cells.
See also [PrettyTables.jl](https://github.com/ronisbr/PrettyTables.jl).


# Example

```julia
julia> using Millboard

julia> board = [11 12 13; 21 22 23]
2×3 Array{Int64,2}:
 11  12  13
 21  22  23
```

* `table(x)` displays the data into the Markdown format.

```julia
julia> table(board)
|   |  1 |  2 |  3 |
|---|----|----|----|
| 1 | 11 | 12 | 13 |
| 2 | 21 | 22 | 23 |

julia> table(board, colnames=["x" "y" "z"], rownames=["A" "B"])
|   |  x |  y |  z |
|---|----|----|----|
| A | 11 | 12 | 13 |
| B | 21 | 22 | 23 |
```

![table.svg](https://wookay.github.io/docs/Millboard.jl/assets/millboard/table.svg)


* `Millboard.set_table_mode` : to change the display mode
  - `:markdown` (default)
  - `:grid`

```julia
julia> Millboard.set_table_mode(:grid)
Millboard.TableMode(:grid, '+', '=')

julia> board = ([1 2], [5 6; 7 8], [9 10; 11 12])
([1 2], [5 6; 7 8], [9 10; 11 12])

julia> table(board, colnames=["result"], rownames=["x" "y" "z"])
+---+--------+
|   | result |
+===+========+
| x |    1 2 |
+---+--------+
|   |    5 6 |
| y |    7 8 |
+---+--------+
|   |   9 10 |
| z |  11 12 |
+---+--------+
```


# Example - strings
```julia
julia> board = ["Lorem ipsum\ndolor sit amet" 42]
1×2 Array{Any,2}:
 "Lorem ipsum\ndolor sit amet"  42

julia> Millboard.set_table_mode(:markdown)
Millboard.TableMode(:markdown, '|', '-')

julia> table(board, colnames=["first column"], rownames=["first row"])
|           |   first column |  2 |
|-----------|----------------|----|
|           |    Lorem ipsum | 42 |
| first row | dolor sit amet |    |
```


# Example - Dict
```julia
julia> Millboard.set_table_mode(:grid)
Millboard.TableMode(:grid, '+', '=')

julia> board = Dict("1x3"=>[1 2 3], "2x3"=>[1 2 3; 4 5 6], "3x1"=> [1; 2; 3])
Dict{String,Array{Int64,N} where N} with 3 entries:
  "3x1" => [1, 2, 3]
  "2x3" => [1 2 3; 4 5 6]
  "1x3" => [1 2 3]

julia> table(board)
+-----+-------+
| KEY | VALUE |
+=====+=======+
| 1x3 | 1 2 3 |
+-----+-------+
|     | 1 2 3 |
| 2x3 | 4 5 6 |
+-----+-------+
|     |     1 |
|     |     2 |
| 3x1 |     3 |
+-----+-------+
```


# Install

`julia>` type `]` key

```julia
(v1.0) pkg> add Millboard
```


[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://wookay.github.io/docs/Millboard.jl

[travis-img]: https://api.travis-ci.org/wookay/Millboard.jl.svg?branch=master
[travis-url]: https://travis-ci.org/wookay/Millboard.jl

[codecov-img]: https://codecov.io/gh/wookay/Millboard.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/wookay/Millboard.jl/branch/master
