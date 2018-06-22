using Millboard
using Compat.Test


set_table_mode(:grid_tables)
Base.eval(:(have_color = false))


Millboard.display_style[:prepend_newline] = true

board = [11 12 13; 21 22 23]
@test """

+---+----+----+----+
|   |  1 |  2 |  3 |
+===+====+====+====+
| 1 | 11 | 12 | 13 |
+---+----+----+----+
| 2 | 21 | 22 | 23 |
+---+----+----+----+""" == table(board) |> string

Millboard.display_style[:prepend_newline] = false


Base.eval(:(have_color = true))
