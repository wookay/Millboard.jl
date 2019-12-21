using Millboard
using Test

Millboard.set_table_mode(:grid)
Base.eval(:(have_color = false))

struct A
    val1
    val2
end

board = A(5, [1, 2])
@test """
+---+------+------+
| A | val1 | val2 |
+===+======+======+
|   |    5 |    1 |
|   |      |    2 |
+---+------+------+""" == table(board) |> string

board = Any[A(5, 6), A(7, 8)]
@test """
+-----------+------+------+
| Vector{A} | val1 | val2 |
+===========+======+======+
|         1 |    5 |    6 |
+-----------+------+------+
|         2 |    7 |    8 |
+-----------+------+------+""" == table(board) |> string

@test """
+---+------+------+
| A | val1 | val2 |
+===+======+======+
|   |    5 |    6 |
+---+------+------+""" == table(A(5,6)) |> string

types = [AbstractString, String]
board = [T.abstract for T=types]
@test """
+----------------+----------+
|                | abstract |
+================+==========+
| AbstractString |     true |
+----------------+----------+
|         String |    false |
+----------------+----------+""" == table(board, colnames=["abstract"], rownames=types) |> string

Base.eval(:(have_color = true))
