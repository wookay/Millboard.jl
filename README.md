# Millboard

Linux, OSX: [![Build Status](https://api.travis-ci.org/wookay/Millboard.jl.svg?branch=master)](https://travis-ci.org/wookay/Millboard.jl)
Windows: [![Build status](https://ci.appveyor.com/api/projects/status/3hjdk20juucb3kiw?svg=true)](https://ci.appveyor.com/project/wookay/Millboard.jl)
[![Coverage Status](https://coveralls.io/repos/wookay/Millboard.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/wookay/Millboard.jl?branch=master)

```
λ ~$ julia
               _
   _       _ _(_)_     |  A fresh approach to technical computing
  (_)     | (_) (_)    |  Documentation: http://docs.julialang.org
   _ _   _| |_  __ _   |  Type "?help" for help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 0.4.0-dev+7012 (2015-08-26 22:34 UTC)
 _/ |\__'_|_|_|\__'_|  |  Commit 2244a5b (0 days old master)
|__/                   |  x86_64-apple-darwin14.5.0

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

julia> board = ([1 2], [5 6;7 8], [9 10; 11 12]);

julia> table(board)
+===+=====+=====+=======+
|   |   1 |   2 |     3 |
+===+=====+=====+=======+
|   |     | 5 6 |  9 10 |
| 1 | 1 2 | 7 8 | 11 12 |
+---+-----+-----+-------+

julia> board = ([], [5 6;7 8], [9 10; 11 12]);

julia> table(board)
+===+===+=====+=======+
|   | 1 |   2 |     3 |
+===+===+=====+=======+
|   |   | 5 6 |  9 10 |
| 1 |   | 7 8 | 11 12 |
+---+---+-----+-------+

julia> board = ([1 2;3 4], [5 6;7 8], [9 10; 11 12]);

julia> table(board)
+===+=====+=====+=======+
|   |   1 |   2 |     3 |
+===+=====+=====+=======+
|   | 1 2 | 5 6 |  9 10 |
| 1 | 3 4 | 7 8 | 11 12 |
+---+-----+-----+-------+
```
