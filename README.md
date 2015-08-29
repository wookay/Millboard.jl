# Millboard

Linux, OSX: [![Build Status](https://api.travis-ci.org/wookay/Millboard.jl.svg?branch=master)](https://travis-ci.org/wookay/Millboard.jl)
Windows: [![Build status](https://ci.appveyor.com/api/projects/status/3hjdk20juucb3kiw?svg=true)](https://ci.appveyor.com/project/wookay/Millboard.jl)
[![Coverage Status](https://coveralls.io/repos/wookay/Millboard.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/wookay/Millboard.jl?branch=master)

# install
```
λ ~$ julia
               _
   _       _ _(_)_     |  A fresh approach to technical computing
  (_)     | (_) (_)    |  Documentation: http://docs.julialang.org
   _ _   _| |_  __ _   |  Type "?help" for help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 0.4.0-pre+7089 (2015-08-28 22:04 UTC)
 _/ |\__'_|_|_|\__'_|  |  Commit c321bf8 (0 days old master)
|__/                   |  x86_64-apple-darwin14.5.0

julia> Pkg.add("Millboard")
INFO: Installing Millboard v0.0.x

julia> using Millboard
INFO: Precompiling module Millboard...
WARNING: replacing module Millboard
```

# example - numbers
```
julia> using Millboard

julia> board = [11 12 13; 21 22 23];

julia> table(board)
+===+====+====+====+
|   |  1 |  2 |  3 |
+===+====+====+====+
| 1 | 11 | 12 | 13 |
+---+----+----+----+
| 2 | 21 | 22 | 23 |
+---+----+----+----+

julia> table(board, :colnames=>["x" "y" "z"])
+===+====+====+====+
|   |  x |  y |  z |
+===+====+====+====+
| 1 | 11 | 12 | 13 |
+---+----+----+----+
| 2 | 21 | 22 | 23 |
+---+----+----+----+

julia> table(board, :rownames=>["A" "B"])
+===+====+====+====+
|   |  1 |  2 |  3 |
+===+====+====+====+
| A | 11 | 12 | 13 |
+---+----+----+----+
| B | 21 | 22 | 23 |
+---+----+----+----+

julia> table(board, :colnames=>["x" "y" "z"], :rownames=>["A" "B"])
+===+====+====+====+
|   |  x |  y |  z |
+===+====+====+====+
| A | 11 | 12 | 13 |
+---+----+----+----+
| B | 21 | 22 | 23 |
+---+----+----+----+

julia> board = ([1 2], [5 6;7 8], [9 10; 11 12]);

julia> table(board, :colnames=>["x" "y" "z"], :rownames=>["result"])
+========+=====+=====+=======+
|        |   x |   y |     z |
+========+=====+=====+=======+
|        | 1 2 | 5 6 |  9 10 |
| result |     | 7 8 | 11 12 |
+--------+-----+-----+-------+
```

# example - strings
```
julia> using Millboard

julia> board = ["Lorem ipsum\ndolor sit amet" 42];

julia> table(board, :colnames=>["first\ncolumn"], :rownames=>["first row"])
+===========+================+====+
|           |          first |  2 |
|           |         column |    |
+===========+================+====+
|           |    Lorem ipsum | 42 |
| first row | dolor sit amet |    |
+-----------+----------------+----+
```
