module test_millboard_tuples

using Millboard
using Test

Millboard.set_table_mode(:markdown)

board = ()
@test sprint(show, table(board)) == """
"""

board = ([],)
@test sprint(show, table(board)) == """
|   | 1 |
|---|---|
| 1 |   |"""

board = ([1,2,3],)
@test sprint(show, table(board)) == """
|   | 1 |
|---|---|
|   | 1 |
|   | 2 |
| 1 | 3 |"""

board = [()]
@test sprint(show, table(board)) == """
|   | 1  |
|---|----|
| 1 | () |"""

board = ((1,2,3),)
@test sprint(show, table(board)) == """
|   | 1         |
|---|-----------|
| 1 | (1, 2, 3) |"""

board = [(1,2,3)]
@test sprint(show, table(board)) == """
|   | 1         |
|---|-----------|
| 1 | (1, 2, 3) |"""

board = [(1,2,3) (4,5,6)]
@test sprint(show, table(board)) == """
|   | 1         | 2         |
|---|-----------|-----------|
| 1 | (1, 2, 3) | (4, 5, 6) |"""

end # module test_tuples
