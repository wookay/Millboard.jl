using Millboard
using Base.Test

board = [(+) (*); (-) (/)]
@test """
+===+===+===+
|   | 1 | 2 |
+===+===+===+
| 1 | + | * |
+---+---+---+
| 2 | - | / |
+---+---+---+""" == table(board) |> string
