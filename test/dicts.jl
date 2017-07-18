using Millboard
using Base.Test

set_table_mode(:grid_tables)

board = Dict()
@test """
""" == table(board) |> string


board = Dict(:a=>:b, "a"=>"b")
@test """
+-----+-------+
| key | value |
+=====+=======+
|  :a |    :b |
+-----+-------+
|   a |     b |
+-----+-------+""" == table(board) |> string


board = Dict("1x3"=>[1 2 3], "2x3"=>[1 2 3; 4 5 6], "3x1"=> [1; 2; 3])
@test """
+-----+-------+
| key | value |
+=====+=======+
| 1x3 | 1 2 3 |
+-----+-------+
|     | 1 2 3 |
| 2x3 | 4 5 6 |
+-----+-------+
|     |     1 |
|     |     2 |
| 3x1 |     3 |
+-----+-------+""" == table(board) |> string
