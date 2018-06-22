using Millboard
using Compat.Test

set_table_mode(:grid_tables)

board = [(+) (*); (-) (/)]
@test """
+---+---+---+
|   | 1 | 2 |
+===+===+===+
| 1 | + | * |
+---+---+---+
| 2 | - | / |
+---+---+---+""" == table(board) |> string
