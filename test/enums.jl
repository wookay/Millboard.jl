using Millboard
using Compat.Test

set_table_mode(:grid_tables)
Base.eval(:(have_color = false))

@enum RPS ✊  ✋  ✌️ 

@test """
+-----+-------+
| RPS | VALUE |
+=====+=======+
|  ✊ |     0 |
+-----+-------+
|  ✋ |     1 |
+-----+-------+
|  ✌️ |     2 |
+-----+-------+""" == table(RPS) |> string

@test """
+-----+-------+
| RPS | VALUE |
+=====+=======+
|  ✊ |     0 |
+-----+-------+
|  ✋ |     1 |
+-----+-------+
|  ✌️ |     2 |
+-----+-------+""" == table(✊ ) |> string


Base.eval(:(have_color = true))
