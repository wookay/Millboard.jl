using Millboard
using Compat.Test

set_table_mode(:grid_tables)
Base.eval(:(have_color = false))

board = ["한글"]
@test """
+---+------+
|   |    1 |
+===+======+
| 1 | 한글 |
+---+------+""" == board |> table |> string


board = ["한\n글"; "abc"]
@test """
+---+-----+
|   |   1 |
+===+=====+
|   |  한 |
| 1 |  글 |
+---+-----+
| 2 | abc |
+---+-----+""" == board |> table |> string


Base.eval(:(have_color = true))
