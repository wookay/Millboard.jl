using Millboard
using Compat.Test

set_table_mode(:grid_tables)
Base.eval(:(have_color = false))

str = "The quick brown fox jumps over the lazy dog α,β,γ"
regexz = [r"b[\w]*n", r"[\w]{4,}"]
functions = [match]
board = [func(regex, str) for regex=regexz, func=functions]
@test """
+-------------+---------------------+
|             |               match |
+=============+=====================+
|  r"b[\\w]*n" | RegexMatch("brown") |
+-------------+---------------------+
| r"[\\w]{4,}" | RegexMatch("quick") |
+-------------+---------------------+""" == table(board, colnames=functions, rownames=regexz) |> string


Base.eval(:(have_color = true))
