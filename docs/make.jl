using Documenter
using Millboard

makedocs(
    build = joinpath(@__DIR__, "local" in ARGS ? "build_local" : "build"),
    modules = [Millboard],
    clean = false,
    format = Documenter.HTML(
        prettyurls = !("local" in ARGS),
        assets = ["assets/custom.css"],
    ),
    sitename = "Millboard.jl",
    authors = "WooKyoung Noh",
    pages = Any[
        "Home" => "index.md",
    ],
)
