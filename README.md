# ElectricityMarketData

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://LAMPSPUC.github.io/ElectricityMarketData.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://LAMPSPUC.github.io/ElectricityMarketData.jl/dev/)
[![Build Status](https://github.com/LAMPSPUC/ElectricityMarketData.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/LAMPSPUC/ElectricityMarketData.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/LAMPSPUC/ElectricityMarketData.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/LAMPSPUC/ElectricityMarketData.jl)

Example of getting DayAheadHourlyLMP

```julia 
using ElectricityMarketData
DayAheadHourlyLMP_example = ElectricityMarketData.DayAheadHourlyLMP("10/2/2024", "00:15", "10/3/2024", "00:15")
```