using Millboard
using Base.Test

set_table_mode(:grid_tables)

@enum RPS ✊  ✋  ✌️ 

@test """
+-----+-------+
| RPS | value |
+=====+=======+
|  ✊ |     0 |
+-----+-------+
|  ✋ |     1 |
+-----+-------+
|  ✌️ |     2 |
+-----+-------+""" == table(RPS) |> string

@test """
+-----+-------+
| RPS | value |
+=====+=======+
|  ✊ |     0 |
+-----+-------+
|  ✋ |     1 |
+-----+-------+
|  ✌️ |     2 |
+-----+-------+""" == table(✊ ) |> string
