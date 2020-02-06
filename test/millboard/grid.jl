module test_millboard_grid

using Millboard
using Test

Millboard.set_table_mode(:grid)

Millboard.display_style[:prepend_newline] = true

board = [11 12 13; 21 22 23]
@test sprint(show, table(board)) == """

+---+----+----+----+
|   | 1  | 2  | 3  |
+===+====+====+====+
| 1 | 11 | 12 | 13 |
+---+----+----+----+
| 2 | 21 | 22 | 23 |
+---+----+----+----+"""

Millboard.display_style[:prepend_newline] = false

end # module test_millboard_grid
