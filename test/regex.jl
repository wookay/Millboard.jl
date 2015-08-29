using Millboard
using Base.Test

str = "The quick brown fox jumps over the lazy dog α,β,γ"
regexz = [r"b[\w]*n", r"[\w]{4,}"]
functions = [match, matchall]
board = [func(regex, str) for regex=regexz, func=functions]
@test """
+=============+=====================+==========+
|             |               match | matchall |
+=============+=====================+==========+
|  r"b[\\w]*n" | RegexMatch("brown") |    brown |
+-------------+---------------------+----------+
|             | RegexMatch("quick") |    quick |
|             |                     |    brown |
|             |                     |    jumps |
|             |                     |     over |
| r"[\\w]{4,}" |                     |     lazy |
+-------------+---------------------+----------+""" == table(board, :colnames=>functions, :rownames=>regexz) |> string
