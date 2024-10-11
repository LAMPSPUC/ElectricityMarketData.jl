using ElectricityMarketData
using Documenter

DocMeta.setdocmeta!(
    ElectricityMarketData,
    :DocTestSetup,
    :(using ElectricityMarketData);
    recursive = true,
)

makedocs(;
    modules = [ElectricityMarketData],
    authors = "Andrew Rosemberg <arosemberg3@gatech.edu>, Andre Ramos <andreramosfdc@gmail.com> and Thiago Novaes <thiagonovaesb@poli.ufrj.br> and contributors",
    sitename = "ElectricityMarketData.jl",
    format = Documenter.HTML(;
        canonical = "https://LAMPSPUC.github.io/ElectricityMarketData.jl",
        edit_link = "main",
        assets = String[],
    ),
    pages = ["Home" => "index.md"],
)

deploydocs(; repo = "github.com/LAMPSPUC/ElectricityMarketData.jl", devbranch = "main")
