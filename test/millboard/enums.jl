using Millboard
using Test

Millboard.set_table_mode(:markdown)
Base.eval(:(have_color = false))

@enum RPS R P S

@test """
| RPS | VALUE |
|-----|-------|
|   R |     0 |
|   P |     1 |
|   S |     2 |""" == table(RPS) |> string

@test """
| RPS | VALUE |
|-----|-------|
|   R |     0 |
|   P |     1 |
|   S |     2 |""" == table(R) |> string

Base.eval(:(have_color = true))
