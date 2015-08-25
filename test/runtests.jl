push!(LOAD_PATH, "../src")

using Millboard
using Base.Test

board = [11 12 13; 21 22 23]
mill = Mill(board, :title=>["x" "y" "z"])
@test """\
+====+====+====+
| x  | y  | z  |
+====+====+====+
| 11 | 12 | 13 |
| 21 | 22 | 23 |
+----+----+----+""" == table(mill)


board = ([1 2;3 4], [5 6;7 8], [9 10; 11 12])
mill = Mill(board, :title=>["a" "b" "c"])
@test """\
+=====+=====+=======+
|  a  |  b  |   c   |
+=====+=====+=======+
| 1 2 | 5 6 |  9 10 |
| 3 4 | 7 8 | 11 12 |
+-----+-----+-------+""" == table(mill)


mill = Mill(board)
@test """\
+-----+-----+-------+
| 1 2 | 5 6 |  9 10 |
| 3 4 | 7 8 | 11 12 |
+-----+-----+-------+""" == table(mill)
