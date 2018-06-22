using Millboard
using Compat.Test

set_table_mode(:grid_tables)
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
