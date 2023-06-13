using WienerDiffusionModel
using Documenter

DocMeta.setdocmeta!(WienerDiffusionModel, :DocTestSetup, :(using WienerDiffusionModel); recursive=true)

makedocs(;
    modules=[WienerDiffusionModel],
    authors="Tobias Alfers <tobias@alfers.eu> and contributors",
    repo="https://github.com/t-alfers/WienerDiffusionModel.jl/blob/{commit}{path}#{line}",
    sitename="WienerDiffusionModel.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://t-alfers.github.io/WienerDiffusionModel.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/t-alfers/WienerDiffusionModel.jl",
    devbranch="main",
)
