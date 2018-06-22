module test_tuples

using Millboard
using Compat.Test

set_table_mode(:grid_tables)
Base.eval(:(have_color = false))


board = ()
@test """
""" == table(board) |> string

board = ([],)
@test """
+---+---+
|   | 1 |
+===+===+
| 1 |   |
+---+---+""" == table(board) |> string

board = ([1,2,3],)
@test """
+---+---+
|   | 1 |
+===+===+
|   | 1 |
|   | 2 |
| 1 | 3 |
+---+---+""" == table(board) |> string

board = [()]
@test """
+---+----+
|   |  1 |
+===+====+
| 1 | () |
+---+----+""" == table(board) |> string

board = ((1,2,3),)
@test """
+---+-----------+
|   |         1 |
+===+===========+
| 1 | (1, 2, 3) |
+---+-----------+""" == table(board) |> string

board = [(1,2,3)]
@test """
+---+-----------+
|   |         1 |
+===+===========+
| 1 | (1, 2, 3) |
+---+-----------+""" == table(board) |> string

board = [(1,2,3) (4,5,6)]
@test """
+---+-----------+-----------+
|   |         1 |         2 |
+===+===========+===========+
| 1 | (1, 2, 3) | (4, 5, 6) |
+---+-----------+-----------+""" == table(board) |> string


Base.eval(:(have_color = true))

end # module test_tuples
