using Millboard
using Compat.Test

set_table_mode(:grid_tables)
Base.eval(:(have_color = false))

board = ["Lorem ipsum dolor sit amet"]
@test """
+---+----------------------------+
|   |                          1 |
+===+============================+
| 1 | Lorem ipsum dolor sit amet |
+---+----------------------------+""" == table(board) |> string


board = ["Lorem ipsum\ndolor sit amet"]
@test """
+---+----------------+
|   |              1 |
+===+================+
|   |    Lorem ipsum |
| 1 | dolor sit amet |
+---+----------------+""" == table(board) |> string

@test """
+-------+----------------+
|       |              1 |
+=======+================+
|       |    Lorem ipsum |
| first | dolor sit amet |
+-------+----------------+""" == table(board, rownames=["first"]) |> string

@test """
+-----------+----------------+
|           |          first |
|           |         column |
+===========+================+
|           |    Lorem ipsum |
| first row | dolor sit amet |
+-----------+----------------+""" == table(board, colnames=["first\ncolumn"], rownames=["first row"]) |> string


board = ["Lorem ipsum\ndolor sit amet" 42]
@test """
+-----------+----------------+----+
|           |          first |  2 |
|           |         column |    |
+===========+================+====+
|           |    Lorem ipsum | 42 |
| first row | dolor sit amet |    |
+-----------+----------------+----+""" == table(board, colnames=["first\ncolumn"], rownames=["first row"]) |> string


Base.eval(:(have_color = true))
