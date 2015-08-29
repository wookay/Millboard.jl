using Millboard
using Base.Test

@test """
+==================+=======+
| Base.WorkerState | value |
+==================+=======+
|        W_CREATED |     0 |
+------------------+-------+
|      W_CONNECTED |     1 |
+------------------+-------+
|    W_TERMINATING |     2 |
+------------------+-------+
|     W_TERMINATED |     3 |
+------------------+-------+""" == table(Base.WorkerState) |> string


@test """
+==================+=======+
| Base.WorkerState | value |
+==================+=======+
|        W_CREATED |     0 |
+------------------+-------+
|      W_CONNECTED |     1 |
+------------------+-------+
|    W_TERMINATING |     2 |
+------------------+-------+
|     W_TERMINATED |     3 |
+------------------+-------+""" == table(Base.W_CREATED) |> string
