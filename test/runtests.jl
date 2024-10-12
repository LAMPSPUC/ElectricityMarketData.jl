using ElectricityMarketData
using Dates
using TimeZones
using Test
using HTTP

import ElectricityMarketData: get_timezone

include("http_helper_test.jl")
include("electricity_market_test.jl")