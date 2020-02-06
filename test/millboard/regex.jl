module test_millboard_regex

using Millboard
using Test

Millboard.set_table_mode(:markdown)

str = "The quick brown fox jumps over the lazy dog α,β,γ"
regexz = [r"b[\w]*n", r"[\w]{4,}"]
functions = [match]
board = [func(regex, str) for regex=regexz, func=functions]
@test sprint(show, table(board, colnames=functions, rownames=regexz)) == """
|             | match               |
|-------------|---------------------|
| r"b[\\w]*n"  | RegexMatch("brown") |
| r"[\\w]{4,}" | RegexMatch("quick") |"""

end # module test_millboard_regex
