module test_millboard_namedtuples

using Millboard
using Test

Millboard.set_table_mode(:markdown)

board = Any[(a=3, b=5), (a=6, b=7)]
@test sprint(show, table(board)) == """
|   | a | b |
|---|---|---|
| 1 | 3 | 5 |
| 2 | 6 | 7 |"""

end # module test_millboard_namedtuples
