using Millboard
using Compat.Test

set_table_mode(:markdown)
Base.eval(:(have_color = false))

board = []
@test """
""" == table(board) |> string

board = [11 12 13; 21 22 23; 31 32 33]
@test """
|   |  1 |  2 |  3 |
|---|----|----|----|
| 1 | 11 | 12 | 13 |
| 2 | 21 | 22 | 23 |
| 3 | 31 | 32 | 33 |""" == table(board) |> string


Base.eval(:(have_color = true))
