using Millboard
using Test

Millboard.set_table_mode(:grid)
Base.eval(:(have_color = false))

board = Any[(a=3, b=5), (a=6, b=7)]
@test """
+---+---+---+
|   | a | b |
+===+===+===+
| 1 | 3 | 5 |
+---+---+---+
| 2 | 6 | 7 |
+---+---+---+""" == table(board) |> string

Base.eval(:(have_color = true))
