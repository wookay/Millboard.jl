# Millboard

Linux, OSX: [![Build Status](https://api.travis-ci.org/wookay/Millboard.jl.svg?branch=master)](https://travis-ci.org/wookay/Millboard.jl)
Windows: [![Build status](https://ci.appveyor.com/api/projects/status/3hjdk20juucb3kiw?svg=true)](https://ci.appveyor.com/project/wookay/Millboard.jl)
[![Coverage Status](https://coveralls.io/repos/wookay/Millboard.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/wookay/Millboard.jl?branch=master)

```
~/work/Millboard.jl/src$ julia
               _
   _       _ _(_)_     |  A fresh approach to technical computing
  (_)     | (_) (_)    |  Documentation: http://docs.julialang.org
   _ _   _| |_  __ _   |  Type "?help" for help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 0.4.0-dev+6941 (2015-08-24 15:52 UTC)
 _/ |\__'_|_|_|\__'_|  |  Commit f0c8239 (0 days old master)
|__/                   |  x86_64-apple-darwin14.5.0

julia> push!(LOAD_PATH, ".")
3-element Array{ByteString,1}:
 "/Users/wookyoung/work/julia/usr/local/share/julia/site/v0.4"
 "/Users/wookyoung/work/julia/usr/share/julia/site/v0.4"
 "."

julia> using Millboard

julia> board = [11 12 13; 21 22 23]
2x3 Array{Int64,2}:
 11  12  13
 21  22  23

julia> mill = Mill(board, :title=>["x" "y" "z"]);

julia> println(table(mill))
+====+====+====+
| x  | y  | z  |
+====+====+====+
| 11 | 12 | 13 |
| 21 | 22 | 23 |
+----+----+----+

julia> board = ([1 2;3 4], [5 6;7 8], [9 10; 11 12])
(
2x2 Array{Int64,2}:
 1  2
 3  4,

2x2 Array{Int64,2}:
 5  6
 7  8,

2x2 Array{Int64,2}:
  9  10
 11  12)

julia> mill = Mill(board, :title=>["a" "b" "c"]);

julia> println(table(mill))
+=====+=====+=======+
|  a  |  b  |   c   |
+=====+=====+=======+
| 1 2 | 5 6 |  9 10 |
| 3 4 | 7 8 | 11 12 |
+-----+-----+-------+
```
