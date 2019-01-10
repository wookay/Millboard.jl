using Millboard
using Test

Millboard.set_table_mode(:grid)
Base.eval(:(have_color = false))

board = [(+) (*); (-) (/)]
@test """
+---+---+---+
|   | 1 | 2 |
+===+===+===+
| 1 | + | * |
+---+---+---+
| 2 | - | / |
+---+---+---+""" == table(board) |> string


Base.eval(:(have_color = true))
