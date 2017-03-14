using Millboard
using Base.Test

board = ()
@test """
+==+""" == table(board) |> string


board = ([],)
@test """
+===+===+
|   | 1 |
+===+===+
| 1 |   |
+---+---+""" == table(board) |> string


board = ([1,2,3],)
@test """
+===+===+
|   | 1 |
+===+===+
|   | 1 |
|   | 2 |
| 1 | 3 |
+---+---+""" == table(board) |> string


board = [()]
@test """
+===+====+
|   |  1 |
+===+====+
| 1 | () |
+---+----+""" == table(board) |> string


# Julia PR #20288
if VERSION >= v"0.6.0-dev.2505"
    @testset "display tuples" begin
        board = ((1,2,3),)
        @test """
        +===+===========+
        |   |         1 |
        +===+===========+
        | 1 | (1, 2, 3) |
        +---+-----------+""" == table(board) |> string

        board = [(1,2,3)]
        @test """
        +===+===========+
        |   |         1 |
        +===+===========+
        | 1 | (1, 2, 3) |
        +---+-----------+""" == table(board) |> string

        board = [(1,2,3) (4,5,6)]
        @test """
        +===+===========+===========+
        |   |         1 |         2 |
        +===+===========+===========+
        | 1 | (1, 2, 3) | (4, 5, 6) |
        +---+-----------+-----------+""" == table(board) |> string
    end
end
