
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
    return [:MisoMarket, :PjmMarket]
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
    @info "No time series registered for $(market)"
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
    get_real_time_lmp_raw_data(market::ElectricityMarket, 
        start_date::ZonedDateTime, 
        end_date::ZonedDateTime; 
        folder::AbstractString=tempdir(),
        locations::Vector{T} = [],
        data_type::Symbol=:verified, # :verified, :unverified
        frequency::Symbol=:hourly, # :hourly, :fivemin
    )

Download raw data for Real-Time (RT) Locational Marginal Price (LMP) for the given `market` and `start_date` to `end_date` and save it in `folder`.
"""
function get_real_time_lmp_raw_data(
    market::ElectricityMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
    data_type::Symbol = :verified,
    frequency::Symbol = :hourly,
)::Nothing where {T}
    throw(MethodError(get_real_time_lmp_raw_data, (market, start_date, end_date)))
end

function get_real_time_lmp_raw_data(
    market::ElectricityMarket,
    start_date::DateTime,
    end_date::DateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
    data_type::Symbol = :verified,
    frequency::Symbol = :hourly,
)::Nothing where {T}
    @info "Converting DateTime to ZonedDateTime using the timezone of $(market)"
    get_real_time_lmp_raw_data(
        market,
        ZonedDateTime(start_date, get_timezone(market)),
        ZonedDateTime(end_date, get_timezone(market));
        folder = folder,
        locations = locations,
        data_type = data_type,
        frequency = frequency,
    )
end

"""
    get_real_time_lmp(market::ElectricityMarket, 
        start_date::ZonedDateTime, 
            end_date::ZonedDateTime; 
            folder::AbstractString=tempdir(),
            locations::Vector{T} = [],
            data_type::Symbol=:verified, # :verified, :unverified
            frequency::Symbol=:hourly, # :hourly, :fivemin
    ) :: Tables.table

Return a table with Real-Time (RT) Locational Marginal Price (LMP) data for the given `market` and `start_date` to `end_date`.
If the data is not available, download it and save it in `folder`. 
"""
function get_real_time_lmp(
    market::ElectricityMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
    data_type::Symbol = :verified,
    frequency::Symbol = :hourly,
) where {T}
    throw(MethodError(get_real_time_lmp, (market, start_date, end_date)))
end

function get_real_time_lmp(
    market::ElectricityMarket,
    start_date::DateTime,
    end_date::DateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
    data_type::Symbol = :verified,
    frequency::Symbol = :hourly,
) where {T}
    @info "Converting DateTime to ZonedDateTime using the timezone of $(market)"
    get_real_time_lmp(
        market,
        ZonedDateTime(start_date, get_timezone(market)),
        ZonedDateTime(end_date, get_timezone(market));
        folder = folder,
        locations = locations,
        data_type = data_type,
    )
end

"""
    real_time_lmp_data_types(market::ElectricityMarket) :: Vector{Symbol}

Return a vector of available Real-Time (RT) Locational Marginal Price (LMP) data types for the given `market`.

Ex:
```
[
    :verified,
    :unverified,
]
```
"""
function real_time_lmp_data_types(market::ElectricityMarket)::Vector{Symbol}
    throw(MethodError(real_time_lmp_data_types, (market,)))
end

"""
    real_time_lmp_frequency(market::ElectricityMarket) :: Vector{Symbol}

Return a vector of available Real-Time (RT) Locational Marginal Price (LMP) frequencies for the given `market`.

Ex:
```
[
    :hourly,
    :fivemin,
]
```
"""
function real_time_lmp_frequency(market::ElectricityMarket)::Vector{Symbol}
    throw(MethodError(real_time_lmp_frequency, (market,)))
end

"""
    get_day_ahead_lmp_raw_data(market::ElectricityMarket, 
        start_date::ZonedDateTime, 
        end_date::ZonedDateTime; 
        folder::AbstractString=tempdir(),
        locations::Vector{T} = [],
    )

Download raw data for Day-Ahead (DA) Locational Marginal Price (LMP) for the given `market` and `start_date` to `end_date` and save it in `folder`.
"""
function get_day_ahead_lmp_raw_data(
    market::ElectricityMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
)::Nothing where {T}
    throw(MethodError(get_day_ahead_lmp_raw_data, (market, start_date, end_date)))
end

function get_day_ahead_lmp_raw_data(
    market::ElectricityMarket,
    start_date::DateTime,
    end_date::DateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
)::Nothing where {T}
    @info "Converting DateTime to ZonedDateTime using the timezone of $(market)"
    get_day_ahead_lmp_raw_data(
        market,
        ZonedDateTime(start_date, get_timezone(market)),
        ZonedDateTime(end_date, get_timezone(market));
        folder = folder,
        locations = locations,
    )
end

"""
    get_day_ahead_lmp(market::ElectricityMarket, 
        start_date::ZonedDateTime, 
        end_date::ZonedDateTime; 
        folder::AbstractString=tempdir(),
        locations::Vector{T} = [],
    ) :: Tables.table

Return a table with Day-Ahead (DA) Locational Marginal Price (LMP) data for the given `market` and `start_date` to `end_date`.
If the data is not available, download it and save it in `folder`. 
"""
function get_day_ahead_lmp(
    market::ElectricityMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
) where {T}
    throw(MethodError(get_day_ahead_lmp, (market, start_date, end_date)))
end

function get_day_ahead_lmp(
    market::ElectricityMarket,
    start_date::DateTime,
    end_date::DateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
) where {T}
    @info "Converting DateTime to ZonedDateTime using the timezone of $(market)"
    get_day_ahead_lmp(
        market,
        ZonedDateTime(start_date, get_timezone(market)),
        ZonedDateTime(end_date, get_timezone(market));
        folder = folder,
        locations = locations,
    )
end

"""
    get_load_raw_data(market::ElectricityMarket, 
        start_date::ZonedDateTime, 
        end_date::ZonedDateTime; 
        folder::AbstractString=tempdir(),
        locations::Vector{T} = [],
        data_type::Symbol=:metered, # :metered, :preliminary, :estimated
    )

Download raw Load data for the given `market` and `start_date` to `end_date` and save it in `folder`.
"""
function get_load_raw_data(
    market::ElectricityMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
    data_type::Symbol = :metered,
)::Nothing where {T}
    throw(MethodError(get_load_raw_data, (market, start_date, end_date)))
end

function get_load_raw_data(
    market::ElectricityMarket,
    start_date::DateTime,
    end_date::DateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
    data_type::Symbol = :metered,
)::Nothing where {T}
    @info "Converting DateTime to ZonedDateTime using the timezone of $(market)"
    get_load_raw_data(
        market,
        ZonedDateTime(start_date, get_timezone(market)),
        ZonedDateTime(end_date, get_timezone(market));
        folder = folder,
        locations = locations,
        data_type = data_type,
    )
end

"""
    get_load(market::ElectricityMarket, 
        start_date::ZonedDateTime, 
        end_date::ZonedDateTime; 
        folder::AbstractString=tempdir(),
        locations::Vector{T} = [],
        data_type::Symbol=:metered, # :metered, :preliminary, :estimated
    ) :: Tables.table

Return a table with Load data for the given `market` and `start_date` to `end_date`.
If the data is not available, download it and save it in `folder`. 
"""
function get_load(
    market::ElectricityMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
    data_type::Symbol = :metered,
) where {T}
    throw(MethodError(get_load, (market, start_date, end_date)))
end

function get_load(
    market::ElectricityMarket,
    start_date::DateTime,
    end_date::DateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
    data_type::Symbol = :metered,
) where {T}
    @info "Converting DateTime to ZonedDateTime using the timezone of $(market)"
    get_load(
        market,
        ZonedDateTime(start_date, get_timezone(market)),
        ZonedDateTime(end_date, get_timezone(market));
        folder = folder,
        locations = locations,
        data_type = data_type,
    )
end

"""
    load_data_types(market::ElectricityMarket) :: Vector{Symbol}

Return a vector of available Load data types for the given `market`.

Ex:
```
[
    :metered,
    :preliminary,
    :estimated,
]
```
"""
function load_data_types(market::ElectricityMarket)::Vector{Symbol}
    throw(MethodError(load_data_types, (market,)))
end

"""
    get_load_forecast_raw_data(market::ElectricityMarket, 
        start_date::ZonedDateTime, 
        end_date::ZonedDateTime; 
        folder::AbstractString=tempdir(),
        locations::Vector{T} = [],
        data_type::Symbol=:fivemin # :fivemin, :7days
    )

Download raw Load Forecast data for the given `market` and `start_date` to `end_date` and save it in `folder`.
"""
function get_load_forecast_raw_data(
    market::ElectricityMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
    data_type::Symbol = :fivemin,
)::Nothing where {T}
    throw(MethodError(get_load_forecast_raw_data, (market, start_date, end_date)))
end

function get_load_forecast_raw_data(
    market::ElectricityMarket,
    start_date::DateTime,
    end_date::DateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
    data_type::Symbol = :fivemin,
)::Nothing where {T}
    @info "Converting DateTime to ZonedDateTime using the timezone of $(market)"
    get_load_forecast_raw_data(
        market,
        ZonedDateTime(start_date, get_timezone(market)),
        ZonedDateTime(end_date, get_timezone(market));
        folder = folder,
        locations = locations,
        data_type = data_type,
    )
end

"""
    get_load_forecast(market::ElectricityMarket, 
        start_date::ZonedDateTime, 
        end_date::ZonedDateTime; 
        folder::AbstractString=tempdir(),
        locations::Vector{T} = [],
        data_type::Symbol=:fivemin # :fivemin, :7days
    ) :: Tables.table

Return a table with Load Forecast data for the given `market` and `start_date` to `end_date`.
If the data is not available, download it and save it in `folder`. 
"""
function get_load_forecast(
    market::ElectricityMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
    data_type::Symbol = :fivemin,
) where {T}
    throw(MethodError(get_load_forecast, (market, start_date, end_date)))
end

function get_load_forecast(
    market::ElectricityMarket,
    start_date::DateTime,
    end_date::DateTime;
    folder::AbstractString = tempdir(),
    locations::Vector{T} = [],
    data_type::Symbol = :fivemin,
) where {T}
    @info "Converting DateTime to ZonedDateTime using the timezone of $(market)"
    get_load_forecast(
        market,
        ZonedDateTime(start_date, get_timezone(market)),
        ZonedDateTime(end_date, get_timezone(market));
        folder = folder,
        locations = locations,
        data_type = data_type,
    )
end

"""
    load_forecast_data_types(market::ElectricityMarket) :: Vector{Symbol}

Return a vector of available Load Forecast data types for the given `market`.

Ex:
```
[
    :fivemin,
    :7days,
]
```
"""
function load_forecast_data_types(market::ElectricityMarket)::Vector{Symbol}
    throw(MethodError(load_forecast_data_types, (market,)))
end
