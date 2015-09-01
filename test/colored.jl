using Millboard
using Base.Test


macro test_colored(expr)
  #println()
  #println(expr.args[3])
  #println(expr.args[1])
  :( @test $expr )
end


cyan = colored(:cyan)
@test_colored "\e[1m\e[36m1\e[0m\e[1m" == 1 |> cyan |> string
@test_colored "\e[1m\e[36mπ = 3.1415926535897...\e[0m\e[1m" == pi |> cyan |> string


green = colored(:green)
@test_colored "\e[1m\e[32msin\e[0m\e[1m" == sin |> green |> string


magenta = colored(:magenta)
@test_colored "\e[1m\e[35mABC\e[0m\e[1m" == "ABC" |> magenta |> string
@test_colored "\e[1m\e[35mABC\e[0m\e[1m" == "ABC" |> magenta(s->s) |> string
@test_colored "\e[1m\e[1m\e[35mABC\e[0m\e[1m\e[1m" == "ABC" |> magenta(s->s[1:end]) |> string

@test_colored "\e[1m\e[1m\e[35mA\e[0m\e[1m\e[1mBC" == "ABC" |> magenta(s->s[]) |> string
@test_colored "\e[1m\e[1m\e[35mA\e[0m\e[1m\e[1mBC" == "ABC" |> magenta(s->s[1]) |> string

@test_colored "\e[1mA\e[1m\e[35mB\e[0m\e[1m\e[1mC" == "ABC" |> magenta(s->s[2]) |> string
@test_colored "\e[1mAB\e[1m\e[35mC\e[0m\e[1m\e[1m" == "ABC" |> magenta(s->s[3]) |> string
@test_colored "\e[1mAB\e[1m\e[35mC\e[0m\e[1m\e[1m" == "ABC" |> magenta(s->s[end]) |> string


str = "Lorem ipsum dolor sit amet"
@test_colored "\e[1m\e[33mLorem ipsum dolor sit amet\e[0m\e[1m" == str |> colored(:yellow) |> string
@test_colored "\e[1m\e[33mLorem ipsum dolor sit amet\e[0m\e[1m" == str |> colored(:yellow, s->s) |> string
@test_colored "\e[1m\e[33mLorem ipsum dolor sit amet\e[0m\e[1m" == colored(:yellow, s->s, str) |> string
@test_colored "\e[1mLorem \e[1m\e[33mipsum dol\e[0m\e[1m\e[1mor sit amet" == colored(:yellow, s->s[7:15], str) |> string


# test colored tables

colnames = [:blue :green :red :magenta]
board = map(colnames) do name
  colored(name, s->s[1:end], string(name))
end
@test_colored "+===+=======+========+======+==========+\n|   | :blue | :green | :red | :magenta |\n+===+=======+========+======+==========+\n| 1 |  \e[1m\e[1m\e[34mblue\e[0m\e[1m\e[1m |  \e[1m\e[1m\e[32mgreen\e[0m\e[1m\e[1m |  \e[1m\e[1m\e[31mred\e[0m\e[1m\e[1m |  \e[1m\e[1m\e[35mmagenta\e[0m\e[1m\e[1m |\n+---+-------+--------+------+----------+" == table(board, :colnames=>colnames) |> string

colored_colnames = [colored(:blue, "FIRST")]
@test_colored "+===+=======+=======+=====+=========+\n|   | \e[1m\e[34mFIRST\e[0m\e[1m |     2 |   3 |       4 |\n+===+=======+=======+=====+=========+\n| 1 |  \e[1m\e[1m\e[34mblue\e[0m\e[1m\e[1m | \e[1m\e[1m\e[32mgreen\e[0m\e[1m\e[1m | \e[1m\e[1m\e[31mred\e[0m\e[1m\e[1m | \e[1m\e[1m\e[35mmagenta\e[0m\e[1m\e[1m |\n+---+-------+-------+-----+---------+" == table(board, :colnames=>colored_colnames) |>string


board = [5 6; 7 8]
@test_colored "+===+===+\n|   | 1 |\n+===+===+\n| 1 | \e[1m\e[36m5\e[0m\e[1m |\n+---+---+\n| 2 | \e[1m\e[36m7\e[0m\e[1m |\n+---+---+\n| 3 | \e[1m\e[36m6\e[0m\e[1m |\n+---+---+\n| 4 | \e[1m\e[36m8\e[0m\e[1m |\n+---+---+" == board |> cyan(b->b[:]) |> table |> string
@test_colored "+===+===+\n|   | 1 |\n+===+===+\n| 1 | \e[1m\e[36m5\e[0m\e[1m |\n+---+---+\n| 2 | \e[1m\e[36m7\e[0m\e[1m |\n+---+---+\n| 3 | \e[1m\e[36m6\e[0m\e[1m |\n+---+---+\n| 4 | \e[1m\e[36m8\e[0m\e[1m |\n+---+---+" == board |> cyan(b->b[:,]) |> table |> string

@test_colored "+===+===+===+\n|   | 1 | 2 |\n+===+===+===+\n| 1 | \e[1m\e[36m5\e[0m\e[1m | \e[1m\e[36m6\e[0m\e[1m |\n+---+---+---+\n| 2 | \e[1m\e[36m7\e[0m\e[1m | \e[1m\e[36m8\e[0m\e[1m |\n+---+---+---+" == board |> cyan(b->b[:,:]) |> table |> string
@test_colored "+===+===+===+\n|   | 1 | 2 |\n+===+===+===+\n| 1 | \e[1m\e[36m5\e[0m\e[1m | 6 |\n+---+---+---+\n| 2 | \e[1m\e[36m7\e[0m\e[1m | 8 |\n+---+---+---+" == board |> cyan(b->b[1:2]) |> table |> string
@test_colored "+===+===+===+\n|   | 1 | 2 |\n+===+===+===+\n| 1 | \e[1m\e[36m5\e[0m\e[1m | \e[1m\e[36m6\e[0m\e[1m |\n+---+---+---+\n| 2 | \e[1m\e[36m7\e[0m\e[1m | \e[1m\e[36m8\e[0m\e[1m |\n+---+---+---+" == board |> cyan(b->b[1:end]) |> table |> string
@test_colored "+===+===+===+\n|   | 1 | 2 |\n+===+===+===+\n| 1 | \e[1m\e[36m5\e[0m\e[1m | 6 |\n+---+---+---+\n| 2 | 7 | 8 |\n+---+---+---+" == board |> cyan(b->b[1:1]) |> table |> string
@test_colored "+===+===+===+\n|   | 1 | 2 |\n+===+===+===+\n| 1 | 5 | 6 |\n+---+---+---+\n| 2 | 7 | 8 |\n+---+---+---+" == board |> cyan(b->b[2:1]) |> table |> string
@test_colored "+===+===+===+\n|   | 1 | 2 |\n+===+===+===+\n| 1 | 5 | 6 |\n+---+---+---+\n| 2 | \e[1m\e[36m7\e[0m\e[1m | 8 |\n+---+---+---+" == board |> cyan(b->b[2,1]) |> table |> string
@test_colored "+===+===+===+\n|   | 1 | 2 |\n+===+===+===+\n| 1 | 5 | \e[1m\e[36m6\e[0m\e[1m |\n+---+---+---+\n| 2 | \e[1m\e[36m7\e[0m\e[1m | \e[1m\e[36m8\e[0m\e[1m |\n+---+---+---+" == board |> cyan(b->b[2:end]) |> table |> string
@test_colored "+===+===+===+\n|   | 1 | 2 |\n+===+===+===+\n| 1 | 5 | 6 |\n+---+---+---+\n| 2 | \e[1m\e[36m7\e[0m\e[1m | \e[1m\e[36m8\e[0m\e[1m |\n+---+---+---+" == board |> cyan(b->b[2,:]) |> table |> string


board = ([1 2], [5 6;7 8], [9 10; 11 12])
@test_colored "+===+=====+=====+=======+\n|   |   1 |   2 |     3 |\n+===+=====+=====+=======+\n|   | \e[1m\e[36m1 2\e[0m\e[1m |\e[1m\e[36m 5 6\e[0m\e[1m |\e[1m\e[36m  9 10\e[0m\e[1m |\n| 1 |     |\e[1m\e[36m 7 8\e[0m\e[1m |\e[1m\e[36m 11 12\e[0m\e[1m |\n+---+-----+-----+-------+" == board |> cyan |> table |> string
@test_colored "+===+=====+=====+=======+\n|   |   1 |   2 |     3 |\n+===+=====+=====+=======+\n|   | \e[1m\e[36m1 2\e[0m\e[1m |\e[1m\e[36m 5 6\e[0m\e[1m |\e[1m\e[36m  9 10\e[0m\e[1m |\n| 1 |     |\e[1m\e[36m 7 8\e[0m\e[1m |\e[1m\e[36m 11 12\e[0m\e[1m |\n+---+-----+-----+-------+" == board |> cyan(b->b) |> table |> string
@test_colored "+===+=====+=====+=======+\n|   |   1 |   2 |     3 |\n+===+=====+=====+=======+\n|   | \e[1m\e[36m1 2\e[0m\e[1m |\e[1m\e[36m 5 6\e[0m\e[1m |\e[1m\e[36m  9 10\e[0m\e[1m |\n| 1 |     |\e[1m\e[36m 7 8\e[0m\e[1m |\e[1m\e[36m 11 12\e[0m\e[1m |\n+---+-----+-----+-------+" == board |> cyan(b->b[:,:]) |> table |> string
@test_colored "+===+=====+=====+=======+\n|   |   1 |   2 |     3 |\n+===+=====+=====+=======+\n|   | \e[1m\e[36m1 2\e[0m\e[1m | 5 6 |  9 10 |\n| 1 |     | 7 8 | 11 12 |\n+---+-----+-----+-------+" == board |> cyan(b->b[]) |> table |> string
