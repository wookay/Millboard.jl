module test_millboard_strings

using Millboard
using Test

Millboard.set_table_mode(:markdown)

board = ["Lorem ipsum dolor sit amet"]
@test sprint(show, table(board)) == """
|   | 1                          |
|---|----------------------------|
| 1 | Lorem ipsum dolor sit amet |"""

board = ["Lorem ipsum\ndolor sit amet"]
@test sprint(show, table(board)) == """
|   | 1              |
|---|----------------|
|   | Lorem ipsum    |
| 1 | dolor sit amet |"""

@test sprint(show, table(board, rownames=["first"])) == """
|       | 1              |
|-------|----------------|
|       | Lorem ipsum    |
| first | dolor sit amet |"""

@test sprint(show, table(board, colnames=["first\ncolumn"], rownames=["first row"])) == """
|           | first          |
|           | column         |
|-----------|----------------|
|           | Lorem ipsum    |
| first row | dolor sit amet |"""

board = ["Lorem ipsum\ndolor sit amet" 42]
@test sprint(show, table(board, colnames=["first\ncolumn"], rownames=["first row"])) == """
|           | first          | 2  |
|           | column         |    |
|-----------|----------------|----|
|           | Lorem ipsum    | 42 |
| first row | dolor sit amet |    |"""

end # module test_millboard_strings
