using Millboard
using Compat.Test

set_table_mode(:grid_tables)

board = Dict()
@test """
""" == table(board) |> string


board = Dict(:a=>:b, "a"=>"b")
@test """
+-----+-------+
| KEY | VALUE |
+=====+=======+
|  :a |    :b |
+-----+-------+
|   a |     b |
+-----+-------+""" == table(board) |> string


board = Dict("1x3"=>[1 2 3], "2x3"=>[1 2 3; 4 5 6], "3x1"=> [1; 2; 3])
@test """
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
+-----+-------+""" == table(board) |> string
