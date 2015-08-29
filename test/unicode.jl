using Millboard
using Base.Test

codes = ['A', Char(0x1f415), '\U1f618']
zerocolname = "code"
board = hcat(codes, map(x -> x |> string |> strwidth, codes))
@test """
+=======+======+==========+
|  code | char | strwidth |
+=======+======+==========+
|    41 |  'A' |        1 |
+-------+------+----------+
| 1f415 |  '🐕' |        2 |
+-------+------+----------+
| 1f618 |  '😘' |        2 |
+-------+------+----------+""" == table(board, :zerocolname=>"code", :colnames=>["char", strwidth], :rownames=>map(hex, codes)) |> string
