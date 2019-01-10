using Millboard
using Test

Millboard.set_table_mode(:grid)
Base.eval(:(have_color = false))

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
