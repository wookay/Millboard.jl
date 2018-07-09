# Millboard


Get julia data in a tablized format to arrange into rows and columns of cells.


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

![table.svg](./assets/millboard/table.svg)


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
