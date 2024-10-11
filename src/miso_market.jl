
"""
    MisoMarket

struct representing the Midcontinent Independent System Operator (MISO).
"""

Base.@kwdef struct MisoMarket <: ElectricityMarket
    url::String = "https://www.misoenergy.org/"
    timezone::TimeZone = tz"UTC-5"
end

"""
    available_time_series(::MisoMarket) :: Vector{NamedTuple}

Return Vector of `NamedTuple` of available time series for the given `market`.

Ex:
```
[
    (name="RT-load", unit="MW", resolution=Hour(1), first_date=DateTime("2021-01-01T00:00:00"), method=get_real_time_load_data, description="Real-time load data"),
    (name="RT-LMP", unit="MWh", resolution=Hour(1), first_date=DateTime("2021-01-01T00:00:00"), method=get_real_time_lmp, description="Real-time Locational Marginal Price data"),
]
```
"""
function available_time_series(::MisoMarket)::Vector{NamedTuple}
    return [
                (name="RT-LMP", unit="\$/MWh", resolution=Hour(1), first_date=DateTime("2021-01-01T00:00:00"), method=get_real_time_lmp, description="Real-time Locational Marginal Price data"),
           ]
end

"""
    get_timezone(market::MisoMarket) :: TimeZone

Return the timezone of the given `market`.
"""
function get_timezone(market::MisoMarket)::TimeZone
    return market.timezone
end

"""
    get_real_time_lmp_raw_data(market::MisoMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir(), parser::Function=(args...) -> nothing)

Download raw data for Real-Time (RT) Locational Marginal Price (LMP) for the given `market` and `start_date` to `end_date` and save it in `folder`.
Parse the data using `parser` if provided.
"""
function get_real_time_lmp_raw_data(
    market::MisoMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
    parser::Function = (args...) -> nothing,
)::Nothing
    throw(MethodError(get_real_time_lmp_raw_data, (market, start_date, end_date)))
end

"""
    get_real_time_lmp(market::MisoMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir(), parser::Function=(args...) -> nothing) :: Tables.table

Return a table with Real-Time (RT) Locational Marginal Price (LMP) data for the given `market` and `start_date` to `end_date`.
Parse the data using `parser` if provided.
If the data is not available, download it and save it in `folder`. 
"""
function get_real_time_lmp(
    market::MisoMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
    parser::Function = (args...) -> nothing,
)
    throw(MethodError(get_real_time_lmp, (market, start_date, end_date)))
end
