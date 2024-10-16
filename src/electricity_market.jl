
"""
    ElectricityMarket

Abstract type representing an electricity market.
"""
abstract type ElectricityMarket end

"""
    list_markets() :: Vector{ElectricityMarket}

Return a vector of all available electricity markets.
"""
function list_markets()::Vector{Symbol}
    return [:MisoMarket]
end

"""
    available_time_series(market::ElectricityMarket) :: Vector{NamedTuple}

Return Vector of `NamedTuple` of available time series for the given `market`.

Ex:
```
[
    (name="RT-load", unit="MW", resolution=Hour(1), first_date=DateTime("2021-01-01T00:00:00"), method=get_real_time_load_data, description="Real-time load data"),
    (name="RT-LMP", unit="MWh", resolution=Hour(1), first_date=DateTime("2021-01-01T00:00:00"), method=get_real_time_lmp, description="Real-time Locational Marginal Price data"),
]
```
"""
function available_time_series(market::ElectricityMarket)::Vector{NamedTuple}
    @warn "No time series registered for $(market)"
    return Vector{NamedTuple}()
end

"""
    get_timezone(market::ElectricityMarket) :: TimeZone

Return the timezone of the given `market`.
"""
function get_timezone(market::ElectricityMarket)::TimeZone
    throw(MethodError(get_timezone, (market,)))
end

"""
    ZonedDateTime(date::DateTime, timezone::TimeZone) :: ZonedDateTime

Return a `ZonedDateTime` object with the given `date` and `timezone` from the market.
"""
function ZonedDateTime(date::DateTime, market::ElectricityMarket)::ZonedDateTime
    ZonedDateTime(date, get_timezone(market))
end

"""
    get_real_time_lmp_raw_data(market::ElectricityMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir())

Download raw data for Real-Time (RT) Locational Marginal Price (LMP) for the given `market` and `start_date` to `end_date` and save it in `folder`.
"""
function get_real_time_lmp_raw_data(
    market::ElectricityMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
)::Nothing
    throw(MethodError(get_real_time_lmp_raw_data, (market, start_date, end_date)))
end

function get_real_time_lmp_raw_data(
    market::ElectricityMarket,
    start_date::DateTime,
    end_date::DateTime;
    folder::AbstractString = tempdir(),
)::Nothing
    @warn "Converting DateTime to ZonedDateTime using the timezone of $(market)"
    get_real_time_lmp_raw_data(
        market,
        ZonedDateTime(start_date, get_timezone(market)),
        ZonedDateTime(end_date, get_timezone(market));
        folder = folder,
    )
end

"""
    get_real_time_lmp(market::ElectricityMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir()) :: Tables.table

Return a table with Real-Time (RT) Locational Marginal Price (LMP) data for the given `market` and `start_date` to `end_date`.
If the data is not available, download it and save it in `folder`. 
"""
function get_real_time_lmp(
    market::ElectricityMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
)
    throw(MethodError(get_real_time_lmp, (market, start_date, end_date)))
end

function get_real_time_lmp(
    market::ElectricityMarket,
    start_date::DateTime,
    end_date::DateTime;
    folder::AbstractString = tempdir(),
)
    @warn "Converting DateTime to ZonedDateTime using the timezone of $(market)"
    get_real_time_lmp(
        market,
        ZonedDateTime(start_date, get_timezone(market)),
        ZonedDateTime(end_date, get_timezone(market));
        folder = folder,
    )
end

"""
    get_day_ahead_lmp_raw_data(market::ElectricityMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir())

Download raw data for Day-Ahead (DA) Locational Marginal Price (LMP) for the given `market` and `start_date` to `end_date` and save it in `folder`.
"""
function get_day_ahead_lmp_raw_data(
    market::ElectricityMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
)::Nothing
    throw(MethodError(get_day_ahead_lmp_raw_data, (market, start_date, end_date)))
end

function get_day_ahead_lmp_raw_data(
    market::ElectricityMarket,
    start_date::DateTime,
    end_date::DateTime;
    folder::AbstractString = tempdir(),
)::Nothing
    @warn "Converting DateTime to ZonedDateTime using the timezone of $(market)"
    get_day_ahead_lmp_raw_data(
        market,
        ZonedDateTime(start_date, get_timezone(market)),
        ZonedDateTime(end_date, get_timezone(market));
        folder = folder,
    )
end

"""
    get_day_ahead_lmp(market::ElectricityMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir()) :: Tables.table

Return a table with Day-Ahead (DA) Locational Marginal Price (LMP) data for the given `market` and `start_date` to `end_date`.
If the data is not available, download it and save it in `folder`. 
"""
function get_day_ahead_lmp(
    market::ElectricityMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
)
    throw(MethodError(get_day_ahead_lmp, (market, start_date, end_date)))
end

function get_day_ahead_lmp(
    market::ElectricityMarket,
    start_date::DateTime,
    end_date::DateTime;
    folder::AbstractString = tempdir(),
)
    @warn "Converting DateTime to ZonedDateTime using the timezone of $(market)"
    get_day_ahead_lmp(
        market,
        ZonedDateTime(start_date, get_timezone(market)),
        ZonedDateTime(end_date, get_timezone(market));
        folder = folder,
    )
end
