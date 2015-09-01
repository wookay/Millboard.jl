using Millboard
using Base.Test


board = ["한글"]
@test """
+===+======+
|   |    1 |
+===+======+
| 1 | 한글 |
+---+------+""" == board |> table |> string


board = ["한\n글"; "abc"]
@test """
+===+=====+
|   |   1 |
+===+=====+
|   |  한 |
| 1 |  글 |
+---+-----+
| 2 | abc |
+---+-----+""" == board |> table |> string
