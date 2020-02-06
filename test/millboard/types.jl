module test_millboard_types

using Millboard
using Test

Millboard.set_table_mode(:markdown)

struct A
    val1
    val2
end

board = A(5, [1, 2])
@test sprint(show, table(board)) == """
| A | val1 | val2 |
|---|------|------|
|   | 5    | 1    |
|   |      | 2    |"""

board = Any[A(5, 6), A(7, 8)]
@test sprint(show, table(board)) == """
| Vector{A} | val1 | val2 |
|-----------|------|------|
| 1         | 5    | 6    |
| 2         | 7    | 8    |"""

@test sprint(show, table(A(5,6))) == """
| A | val1 | val2 |
|---|------|------|
|   | 5    | 6    |"""

types = [AbstractString, String]
board = [T.abstract for T=types]
@test sprint(show, table(board, colnames=["abstract"], rownames=types)) == """
|                | abstract |
|----------------|----------|
| AbstractString | true     |
| String         | false    |"""

end # module test_millboard_types
