using Millboard
using Compat.Test

set_table_mode(:grid_tables)
Base.eval(:(have_color = false))

board = Dict()
@test table(board) |> string == ""


board = Dict(:a=>:b, "a"=>"b")
@test table(board) |> string == """
+-----+-------+
| KEY | VALUE |
+=====+=======+
|  :a |    :b |
+-----+-------+
|   a |     b |
+-----+-------+"""


board = Dict("1x3"=>[1 2 3], "2x3"=>[1 2 3; 4 5 6], "3x1"=> [1; 2; 3])
@test table(board) |> string == """
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
+-----+-------+"""


Base.eval(:(have_color = true))
