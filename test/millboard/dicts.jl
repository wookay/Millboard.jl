module test_millboard_dicts

using Millboard
using Test

Millboard.set_table_mode(:markdown)

board = Dict()
@test sprint(show, table(board)) == ""

board = Dict(:a=>:b, "a"=>"b")
@test sprint(show, table(board)) == """
| KEY | VALUE |
|-----|-------|
| :a  | :b    |
| a   | b     |"""

board = Dict("1x3"=>[1 2 3], "2x3"=>[1 2 3; 4 5 6], "3x1"=> [1; 2; 3])
@test sprint(show, table(board)) == """
| KEY | VALUE |
|-----|-------|
| 1x3 | 1 2 3 |
|     | 1 2 3 |
| 2x3 | 4 5 6 |
|     | 1     |
|     | 2     |
| 3x1 | 3     |"""

end # module test_millboard_dicts
