module test_millboard_functions

using Millboard
using Test

Millboard.set_table_mode(:markdown)

board = [(+) (*); (-) (/)]
@test sprint(show, table(board)) == """
|   | 1 | 2 |
|---|---|---|
| 1 | + | * |
| 2 | - | / |"""

end # module test_millboard_functions
