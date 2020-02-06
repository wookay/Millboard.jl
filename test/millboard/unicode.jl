module test_millboard_unicode

using Millboard
using Test

Millboard.set_table_mode(:markdown)

board = ["한글"]
@test sprint(show, table(board)) == """
|   | 1    |
|---|------|
| 1 | 한글 |"""

board = ["한\n글"; "abc"]
@test sprint(show, table(board)) == """
|   | 1   |
|---|-----|
|   | 한  |
| 1 | 글  |
| 2 | abc |"""

end # module test_millboard_unicode
