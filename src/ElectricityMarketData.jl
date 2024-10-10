module ElectricityMarketData

using Dates
using Logging
using Tables

export ElectricityMarket, list_markets, available_time_series, get_rt_lmp_raw_data, rt_lmp_data

"""
    ElectricityMarket

Abstract type representing an electricity market.
"""
abstract type ElectricityMarket end

"""
    list_markets() :: Vector{ElectricityMarket}

Return a vector of all available electricity markets.
"""
function list_markets() :: Vector{Symbol}
    return Vector{Symbol}()
end

"""
    available_time_series(market::ElectricityMarket) :: Vector{NamedTuple}

Return Vector of `NamedTuple` of available time series for the given `market`.

Ex:
```
[
    (name="RT-load", unit="MW", resolution=Hour(1), first_date=DateTime("2021-01-01T00:00:00"), method=rt_load_data, description="Real-time load data"),
    (name="RT-LMP", unit="MWh", resolution=Hour(1), first_date=DateTime("2021-01-01T00:00:00"), method=rt_lmp_data, description="Real-time Locational Marginal Price data"),
]
```
"""
function available_time_series(market::ElectricityMarket)
    @warn "No time series registered for $(market)"
    return Vector{NamedTuple}()
end

"""
    get_rt_lmp_raw_data(market::ElectricityMarket, start_date::DateTime, end_date::DateTime; folder::AbstractString=mktempdir(), parser::Function=(args...) -> nothing)

Download raw data for Real-Time (RT) Locational Marginal Price (LMP) for the given `market` and `start_date` to `end_date` and save it in `folder`.
Parse the data using `parser` if provided.
"""
function get_rt_lmp_raw_data(market::ElectricityMarket, start_date::DateTime, end_date::DateTime; folder::AbstractString="", parser::Function=(args...) -> nothing)
    throw(MethodError(get_rt_lmp_raw_data, (market, DateTime, DateTime)))
end

"""
    rt_lmp_data(market::ElectricityMarket, start_date::DateTime, end_date::DateTime; folder::AbstractString=mktempdir(), parser::Function=(args...) -> nothing) :: Tables.AbstractTable

Return a table with Real-Time (RT) Locational Marginal Price (LMP) data for the given `market` and `start_date` to `end_date`.
Parse the data using `parser` if provided.
If the data is not available, download it and save it in `folder`. 
"""
function rt_lmp_data(market::ElectricityMarket, start_date::DateTime, end_date::DateTime; folder::AbstractString="", parser::Function=(args...) -> nothing)
    throw(MethodError(rt_lmp_data, (market, DateTime, DateTime)))
end

end # module