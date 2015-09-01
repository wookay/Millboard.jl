using Millboard
using Base.Test


colnames = [:blue :green :red :magenta]
board = map(colnames) do name
  colored(s->s[1:end], name, string(name))
end
@test "+===+=======+========+======+==========+\n|   | :blue | :green | :red | :magenta |\n+===+=======+========+======+==========+\n| 1 |  \e[1m\e[1m\e[34mblue\e[0m\e[1m\e[1m |  \e[1m\e[1m\e[32mgreen\e[0m\e[1m\e[1m |  \e[1m\e[1m\e[31mred\e[0m\e[1m\e[1m |  \e[1m\e[1m\e[35mmagenta\e[0m\e[1m\e[1m |\n+---+-------+--------+------+----------+" == table(board, :colnames=>colnames) |> string
# table(board, :colnames=>colnames) |> println
#
# +===+=======+========+======+==========+
# |   | :blue | :green | :red | :magenta |
# +===+=======+========+======+==========+
# | 1 |  blue |  green |  red |  magenta |
# +---+-------+--------+------+----------+


str = "Lorem ipsum dolor sit amet"
@test "\e[1mLorem \e[1m\e[33mipsum dol\e[0m\e[1m\e[1mor sit amet" == colored(s->s[7:15], :yellow, str) |> string
# "Lorem ipsum dolor sit amet" |> colored(s->s[7:15], :yellow) |> println
#
# Lorem ipsum dolor sit amet
#       ---------
