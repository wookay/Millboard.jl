# Millboard

Linux, OSX: [![Build Status](https://api.travis-ci.org/wookay/Millboard.jl.svg?branch=master)](https://travis-ci.org/wookay/Millboard.jl)
Windows: [![Build status](https://ci.appveyor.com/api/projects/status/3hjdk20juucb3kiw?svg=true)](https://ci.appveyor.com/project/wookay/Millboard.jl)
[![Coverage Status](https://coveralls.io/repos/wookay/Millboard.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/wookay/Millboard.jl?branch=master)


# Install
```julia
λ ~$ julia
               _
   _       _ _(_)_     |  A fresh approach to technical computing
  (_)     | (_) (_)    |  Documentation: https://docs.julialang.org
   _ _   _| |_  __ _   |  Type "?help" for help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 0.6.0 (2017-06-19 13:05 UTC)
 _/ |\__'_|_|_|\__'_|  |  Official http://julialang.org/ release
|__/                   |  x86_64-apple-darwin13.4.0

julia> Pkg.add("Millboard")
INFO: Installing Millboard v0.1.0

julia> Pkg.checkout("Millboard", "master")
```


# Example - numbers
```julia
julia> using Millboard

julia> board = [11 12 13; 21 22 23]
2×3 Array{Int64,2}:
 11  12  13
 21  22  23

julia> table(board)
|   |  1 |  2 |  3 |
|---|----|----|----|
| 1 | 11 | 12 | 13 |
| 2 | 21 | 22 | 23 |

julia> table(board, colnames=["x" "y" "z"])
|   |  x |  y |  z |
|---|----|----|----|
| 1 | 11 | 12 | 13 |
| 2 | 21 | 22 | 23 |

julia> table(board, rownames=["A" "B"])
|   |  1 |  2 |  3 |
|---|----|----|----|
| A | 11 | 12 | 13 |
| B | 21 | 22 | 23 |

julia> table(board, colnames=["x" "y" "z"], rownames=["A" "B"])
|   |  x |  y |  z |
|---|----|----|----|
| A | 11 | 12 | 13 |
| B | 21 | 22 | 23 |
```


* `set_table_mode` : to change display mode
  - `:markdown` (default)
  - `:grid_tables`

```julia
julia> set_table_mode(:grid_tables)
Millboard.TableMode(:grid_tables, '+', '=')

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

julia> set_table_mode(:markdown)
Millboard.TableMode(:markdown, '|', '-')

julia> table(board, colnames=["first column"], rownames=["first row"])
|           |   first column |  2 |
|-----------|----------------|----|
|           |    Lorem ipsum | 42 |
| first row | dolor sit amet |    |
```


# Example - Dict
```julia
julia> set_table_mode(:grid_tables)
Millboard.TableMode(:grid_tables, '+', '=')

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
