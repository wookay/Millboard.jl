module test_millboard_enums

using Millboard
using Test

Millboard.set_table_mode(:markdown)

@enum RPS R P S

@test sprint(show, table(RPS)) == """
| RPS | VALUE |
|-----|-------|
| R   | 0     |
| P   | 1     |
| S   | 2     |"""

@test sprint(show, table(R)) == """
| RPS | VALUE |
|-----|-------|
| R   | 0     |
| P   | 1     |
| S   | 2     |"""

end # module test_millboard_enums
