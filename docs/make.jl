using Wiener
using Documenter

DocMeta.setdocmeta!(Wiener, :DocTestSetup, :(using Wiener); recursive=true)

makedocs(;
    modules=[Wiener],
    authors="Tobias Alfers <tobias@alfers.eu> and contributors",
    repo="https://github.com/t-alfers/Wiener.jl/blob/{commit}{path}#{line}",
    sitename="Wiener.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://t-alfers.github.io/Wiener.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/t-alfers/Wiener.jl",
    devbranch="main",
)
