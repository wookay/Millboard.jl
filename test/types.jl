using Millboard
using Compat.Test

set_table_mode(:grid_tables)
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
