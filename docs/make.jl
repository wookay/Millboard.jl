using Documenter
using Millboard

makedocs(
    build = joinpath(@__DIR__, "local" in ARGS ? "build_local" : "build"),
    modules = [Millboard],
    clean = false,
    format = :html,
    sitename = "Millboard",
    authors = "WooKyoung Noh",
    pages = Any[
        "Home" => "index.md",
    ],
    html_prettyurls = !("local" in ARGS),
)
