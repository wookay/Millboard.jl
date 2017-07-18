using Millboard
using Base.Test

set_table_mode(:grid_tables)

macro test_colored(expr)
  expected = expr.args[2]
  code = expr.args[3]
  orig = Base.remove_linenums!(Expr(:quote, code))
  quote
       let same = $expected == $code
           println($code)
           if !same
               println("@test_colored ", repr($code), " == ", $orig)
           end
       end
  end
  :( @test $expr )
end

cyan = colored(:cyan)
@test_colored "\e[36m1\e[39m\e[0m" == 1 |> cyan |> string
@test_colored "\e[36mπ = 3.1415926535897...\e[39m\e[0m" == pi |> cyan |> string


green = colored(:green)
@test_colored "Millboard.Coat(:green, sin)" == sin |> green |> string


magenta = colored(:magenta)
@test_colored "\e[35mABC\e[39m\e[0m" == "ABC" |> magenta |> string
@test_colored "\e[35mABC\e[39m\e[0m" == "ABC" |> magenta(s->s) |> string
@test_colored "\e[0m\e[35mABC\e[39m\e[0m\e[0m" == "ABC" |> magenta(s->s[1:end]) |> string

@test_colored "\e[0m\e[35mA\e[39m\e[0m\e[0mBC" ==  "ABC" |> magenta(s->s[]) |> string
@test_colored "\e[0m\e[35mA\e[39m\e[0m\e[0mBC" == "ABC" |> magenta(s->s[1]) |> string

@test_colored "\e[0mA\e[35mB\e[39m\e[0m\e[0mC" == "ABC" |> magenta(s->s[2]) |> string
@test_colored "\e[0mAB\e[35mC\e[39m\e[0m\e[0m" == "ABC" |> magenta(s->s[3]) |> string
@test_colored "\e[0mAB\e[35mC\e[39m\e[0m\e[0m" == "ABC" |> magenta(s->s[end]) |> string


str = "Lorem ipsum dolor sit amet"
@test_colored "\e[33mLorem ipsum dolor sit amet\e[39m\e[0m" == str |> colored(:yellow) |> string
@test_colored "\e[33mLorem ipsum dolor sit amet\e[39m\e[0m" == str |> colored(:yellow, s->s) |> string
@test_colored "\e[33mLorem ipsum dolor sit amet\e[39m\e[0m" == colored(:yellow, s->s, str) |> string
@test_colored "\e[0mLorem \e[33mipsum dol\e[39m\e[0m\e[0mor sit amet" == colored(:yellow, s->s[7:15], str) |> string


# test colored tables

colnames = [:blue :green :red :magenta]
board = map(colnames) do name
  colored(name, s->s[1:end], string(name))
end
@test_colored "+---+-------+--------+------+----------+\n|   | :blue | :green | :red | :magenta |\n+===+=======+========+======+==========+\n| 1 |  \e[0m\e[34mblue\e[39m\e[0m\e[0m |  \e[0m\e[32mgreen\e[39m\e[0m\e[0m |  \e[0m\e[31mred\e[39m\e[0m\e[0m |  \e[0m\e[35mmagenta\e[39m\e[0m\e[0m |\n+---+-------+--------+------+----------+" == table(board, colnames=colnames) |> string

colored_colnames = [colored(:blue, "FIRST")]
@test_colored "+---+-------+-------+-----+---------+\n|   | \e[34mFIRST\e[39m\e[0m |     2 |   3 |       4 |\n+===+=======+=======+=====+=========+\n| 1 |  \e[0m\e[34mblue\e[39m\e[0m\e[0m | \e[0m\e[32mgreen\e[39m\e[0m\e[0m | \e[0m\e[31mred\e[39m\e[0m\e[0m | \e[0m\e[35mmagenta\e[39m\e[0m\e[0m |\n+---+-------+-------+-----+---------+" == table(board, colnames=colored_colnames) |> string

board = [5 6; 7 8]
@test_colored "+---+---+\n|   | 1 |\n+===+===+\n| 1 | \e[36m5\e[39m\e[0m |\n+---+---+\n| 2 | \e[36m7\e[39m\e[0m |\n+---+---+\n| 3 | \e[36m6\e[39m\e[0m |\n+---+---+\n| 4 | \e[36m8\e[39m\e[0m |\n+---+---+" == ((board |> cyan((b->begin
                        b[:]
                    end))) |> table) |> string
@test_colored "+---+---+\n|   | 1 |\n+===+===+\n| 1 | \e[36m5\e[39m\e[0m |\n+---+---+\n| 2 | \e[36m7\e[39m\e[0m |\n+---+---+\n| 3 | \e[36m6\e[39m\e[0m |\n+---+---+\n| 4 | \e[36m8\e[39m\e[0m |\n+---+---+" == ((board |> cyan((b->begin
                        b[:]
                    end))) |> table) |> string
@test_colored "+---+---+---+\n|   | 1 | 2 |\n+===+===+===+\n| 1 | \e[36m5\e[39m\e[0m | \e[36m6\e[39m\e[0m |\n+---+---+---+\n| 2 | \e[36m7\e[39m\e[0m | \e[36m8\e[39m\e[0m |\n+---+---+---+" == ((board |> cyan((b->begin
                        b[:, :]
                    end))) |> table) |> string
@test_colored "+---+---+---+\n|   | 1 | 2 |\n+===+===+===+\n| 1 | \e[36m5\e[39m\e[0m | 6 |\n+---+---+---+\n| 2 | \e[36m7\e[39m\e[0m | 8 |\n+---+---+---+" == ((board |> cyan((b->begin
                        b[1:2]
                    end))) |> table) |> string
@test_colored "+---+---+---+\n|   | 1 | 2 |\n+===+===+===+\n| 1 | \e[36m5\e[39m\e[0m | \e[36m6\e[39m\e[0m |\n+---+---+---+\n| 2 | \e[36m7\e[39m\e[0m | \e[36m8\e[39m\e[0m |\n+---+---+---+" == ((board |> cyan((b->begin
                        b[1:end]
                    end))) |> table) |> string
@test_colored "+---+---+---+\n|   | 1 | 2 |\n+===+===+===+\n| 1 | \e[36m5\e[39m\e[0m | 6 |\n+---+---+---+\n| 2 | 7 | 8 |\n+---+---+---+" == ((board |> cyan((b->begin
                        b[1:1]
                    end))) |> table) |> string

board = ([1 2], [5 6;7 8], [9 10; 11 12])
@test_colored "+---+-------+\n|   |     1 |\n+===+=======+\n| 1 |   1 2 |\n+---+-------+\n|   |  \e[36m 5 6\e[39m\e[0m |\n| 2 |  \e[36m 7 8\e[39m\e[0m |\n+---+-------+\n|   |  9 10 |\n| 3 | 11 12 |\n+---+-------+" == ((board |> cyan((b->begin
                        b[2]
                    end))) |> table) |> string

@test_colored "+---+-------+\n|   |     1 |\n+===+=======+\n| 1 |   1 2 |\n+---+-------+\n|   |  \e[36m 5 6\e[39m\e[0m |\n| 2 |  \e[36m 7 8\e[39m\e[0m |\n+---+-------+\n|   |\e[36m  9 10\e[39m\e[0m |\n| 3 |\e[36m 11 12\e[39m\e[0m |\n+---+-------+" == ((board |> cyan((b->begin
                        begin
                            b[2:end]
                        end
                    end))) |> table) |> string
@test_colored "+---+-------+\n|   |     1 |\n+===+=======+\n| 1 |   \e[36m1 2\e[39m\e[0m |\n+---+-------+\n|   |  \e[36m 5 6\e[39m\e[0m |\n| 2 |  \e[36m 7 8\e[39m\e[0m |\n+---+-------+\n|   |\e[36m  9 10\e[39m\e[0m |\n| 3 |\e[36m 11 12\e[39m\e[0m |\n+---+-------+" == ((board |> cyan) |> table) |> string
@test_colored "+---+-------+\n|   |     1 |\n+===+=======+\n| 1 |   \e[36m1 2\e[39m\e[0m |\n+---+-------+\n|   |  \e[36m 5 6\e[39m\e[0m |\n| 2 |  \e[36m 7 8\e[39m\e[0m |\n+---+-------+\n|   |\e[36m  9 10\e[39m\e[0m |\n| 3 |\e[36m 11 12\e[39m\e[0m |\n+---+-------+" == ((board |> cyan((b->begin
                        begin
                            b
                        end
                    end))) |> table) |> string
@test_colored "+---+-------+\n|   |     1 |\n+===+=======+\n| 1 |   \e[36m1 2\e[39m\e[0m |\n+---+-------+\n|   |  \e[36m 5 6\e[39m\e[0m |\n| 2 |  \e[36m 7 8\e[39m\e[0m |\n+---+-------+\n|   |\e[36m  9 10\e[39m\e[0m |\n| 3 |\e[36m 11 12\e[39m\e[0m |\n+---+-------+" == ((board |> cyan((b->begin
                        begin
                            b[:, :]
                        end
                    end))) |> table) |> string
@test_colored "+---+-------+\n|   |     1 |\n+===+=======+\n| 1 |   \e[36m1 2\e[39m\e[0m |\n+---+-------+\n|   |   5 6 |\n| 2 |   7 8 |\n+---+-------+\n|   |  9 10 |\n| 3 | 11 12 |\n+---+-------+" == ((board |> cyan((b->begin
                        begin
                            b[]
                        end
                    end))) |> table) |> string

# coverage
import Millboard: Coating, coating
A = Coating(:green, [1,2,3])
buf = IOBuffer()
show(buf, A)
coating(A, AbstractArray)
coating(A, String)

import Millboard: ANSIEscaped, ANSIEscapedString
E = ANSIEscaped(:green, [1,2,3])	
endof(E)
next(E, true)

s = ANSIEscapedString("hello", 5, 5)
endof(s)
next(s, 1)
