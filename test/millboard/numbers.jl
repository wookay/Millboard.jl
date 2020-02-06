module test_millboard_numbers

using Millboard
using Test

Millboard.set_table_mode(:markdown)

board = []
@test sprint(show, table(board)) == """
"""

board = [11 12 13; 21 22 23]
@test sprint(show, table(board)) == """
|   | 1  | 2  | 3  |
|---|----|----|----|
| 1 | 11 | 12 | 13 |
| 2 | 21 | 22 | 23 |"""

board = ([1 2], [5 6;7 8], [9 10; 11 12])
@test sprint(show, table(board)) == """
|   | 1     |
|---|-------|
| 1 | 1 2   |
|   | 5 6   |
| 2 | 7 8   |
|   |  9 10 |
| 3 | 11 12 |"""

@test sprint(show, table(board, colnames=["result"], rownames=["x", "y", "z"])) == """
|   | result |
|---|--------|
| x | 1 2    |
|   | 5 6    |
| y | 7 8    |
|   |  9 10  |
| z | 11 12  |"""

board = ([1 2], [5 6;7 8], [9 10; 11 12])
@test sprint(show, table(board)) == """
|   | 1     |
|---|-------|
| 1 | 1 2   |
|   | 5 6   |
| 2 | 7 8   |
|   |  9 10 |
| 3 | 11 12 |"""

board = ([], [5 6;7 8], [9 10; 11 12])
@test sprint(show, table(board)) == """
|   | 1     |
|---|-------|
| 1 |       |
|   | 5 6   |
| 2 | 7 8   |
|   |  9 10 |
| 3 | 11 12 |"""

board = ([1 2;3 4], [5 6;7 8], [9 10; 11 12])
@test sprint(show, table(board)) == """
|   | 1     |
|---|-------|
|   | 1 2   |
| 1 | 3 4   |
|   | 5 6   |
| 2 | 7 8   |
|   |  9 10 |
| 3 | 11 12 |"""

end # module test_millboard_numbers
