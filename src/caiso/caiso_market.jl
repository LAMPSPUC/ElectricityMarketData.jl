"""
    CaisoMarket

struct representing the Midcontinent Independent System Operator (MISO).
"""

Base.@kwdef struct CaisoMarket <: ElectricityMarket
    url::String = "https://www.caiso.com/"
    directory::String = "CaisoMarket"
    timezone::TimeZone = tz"UTC-8"
end

"""
    available_time_series(::CaisoMarket) :: Vector{NamedTuple}

Return Vector of `NamedTuple` of available time series for the given `market`.

Ex:
```
[
    (name="RT-load", unit="MW", resolution=Hour(1), first_date=DateTime("2021-01-01T00:00:00"), method=get_real_time_load_data, description="Real-time load data"),
    (name="RT-LMP", unit="MWh", resolution=Hour(1), first_date=DateTime("2021-01-01T00:00:00"), method=get_real_time_lmp, description="Real-time Locational Marginal Price data"),
]
```
"""
function available_time_series(::CaisoMarket)::Vector{NamedTuple}
    return [
        (
            name = "RT-LMP",
            unit = "\$/MWh",
            resolution = Hour(1),
            first_date = DateTime("2005-05-01T00:00:00"),
            method = get_real_time_lmp,
            description = "Real-time Locational Marginal Price data",
        ),
        (
            name = "DA-LMP",
            unit = "\$/MWh",
            resolution = Hour(1),
            first_date = DateTime("2005-05-01T00:00:00"),
            method = get_day_ahead_lmp,
            description = "Day-ahead Locational Marginal Price data",
        ),
    ]
end

"""
    get_timezone(market::CaisoMarket) :: TimeZone

Return the timezone of the given `market`.
"""
function get_timezone(market::CaisoMarket)::TimeZone
    return market.timezone
end

"""
    get_real_time_lmp_raw_data(market::CaisoMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir())

Download raw data for Real-Time (RT) Locational Marginal Price (LMP) for the given `market` and `start_date` to `end_date` and save it in `folder`.
"""
function get_real_time_lmp_raw_data(
    market::CaisoMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
)::Nothing
    return _get_raw_data(market, "RTM", start_date, end_date, folder)
end

"""
    get_day_ahead_lmp_raw_data(market::CaisoMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir())

Download raw data for Day-Ahead (DA) Locational Marginal Price (LMP) for the given `market` and `start_date` to `end_date` and save it in `folder`.
"""
function get_day_ahead_lmp_raw_data(
    market::CaisoMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
)::Nothing
    return _get_raw_data(market, "DAM", start_date, end_date, folder)
end

"""
    get_real_time_lmp(market::CaisoMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir()) :: Tables.table

Return a table with Real-Time (RT) Locational Marginal Price (LMP) data for the given `market` and `start_date` to `end_date`.
If the data is not available, download it and save it in `folder`. 
"""
function get_real_time_lmp(
    market::CaisoMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
)
    return _get_data(market, "RTM", start_date, end_date, folder)
end

"""
    get_day_ahead_lmp(market::CaisoMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir()) :: Tables.table

Return a table with Day-Ahead (DA) Locational Marginal Price (LMP) data for the given `market` and `start_date` to `end_date`.
If the data is not available, download it and save it in `folder`. 
"""
function get_day_ahead_lmp(
    market::CaisoMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
)
    return _get_data(market, "DAM", start_date, end_date, folder)
end
