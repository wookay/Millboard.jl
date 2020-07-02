# Millboard.jl

|  **Documentation**                        |  **Build Status**                                                |
|:-----------------------------------------:|:----------------------------------------------------------------:|
|  [![][docs-latest-img]][docs-latest-url]  |  [![][travis-img]][travis-url]  [![][codecov-img]][codecov-url]  |


Get julia data in a tablized format to arrange into rows and columns of cells.
See also [PrettyTables.jl](https://github.com/ronisbr/PrettyTables.jl).


# Example

```julia
julia> using Millboard

julia> A = [11 12 13; 21 22 23]
2×3 Matrix{Int64}:
 11  12  13
 21  22  23

julia> table(A)
|   | 1  | 2  | 3  |
|---|----|----|----|
| 1 | 11 | 12 | 13 |
| 2 | 21 | 22 | 23 |

```

![table.svg](https://wookay.github.io/docs/Millboard.jl/assets/millboard/table.svg)


# Example - Calendars

using [Calendars.jl](https://github.com/wookay/Calendars.jl)

```julia
julia> using Millboard

julia> using Calendars

julia> table([VerticalCalendar() VerticalCalendar(Month(3))' VerticalCalendar(Week(1)) VerticalCalendar(Day(-20))'])
|   | 1                  | 2                         | 3         | 4                         |
|---|--------------------|---------------------------|-----------|---------------------------|
|   |     2020           |      Su Mo Tu We Th Fr Sa |     2020  |      Su Mo Tu We Th Fr Sa |
|   |     Jan            | Jan            1  2  3  4 |     Jan   | Jan            1  2  3  4 |
|   |         5 12 19 26 | 2020  5  6  7  8  9 10 11 |        26 | 2020  5  6  7  8  9 10 11 |
|   | Mon     6 13 20 27 |      12 13 14 15 16 17 18 | Mon 20    |      12 13 14 15 16 17 18 |
|   |         7 14 21 28 |      19 20 21 22 23 24 25 |     21    |      19 20 21             |
|   | Wed  1  8 15 22 29 | Feb  26 27 28 29 30 31  1 | Wed 22    |                           |
|   |      2  9 16 23 30 |       2  3  4  5  6  7  8 |     23    |                           |
|   | Fri  3 10 17 24 31 |       9 10 11 12 13 14 15 | Fri 24    |                           |
|   |      4 11 18 25    |      16 17 18 19 20 21 22 |     25    |                           |
|   |                    |      23 24 25 26 27 28 29 |           |                           |
|   |                    | Mar   1  2  3  4  5  6  7 |           |                           |
|   |                    |       8  9 10 11 12 13 14 |           |                           |
|   |                    |      15 16 17 18 19 20 21 |           |                           |
|   |                    |      22 23 24 25 26 27 28 |           |                           |
| 1 |                    |      29 30 31             |           |                           |

```


# Install

`julia>` type `]` key

```julia
(v1.3) pkg> add Millboard
```


[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://wookay.github.io/docs/Millboard.jl

[travis-img]: https://api.travis-ci.org/wookay/Millboard.jl.svg?branch=master
[travis-url]: https://travis-ci.org/wookay/Millboard.jl

[codecov-img]: https://codecov.io/gh/wookay/Millboard.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/wookay/Millboard.jl/branch/master
