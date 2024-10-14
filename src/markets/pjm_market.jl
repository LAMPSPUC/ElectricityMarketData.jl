"""
    PjmMarket

struct representing the PJM Energy Market.
"""

Base.@kwdef struct PjmMarket <: ElectricityMarket
    directory::String = "PjmMarket"
    timezone::TimeZone = tz"UTC-4" # EPT timezone
end

"""
    available_time_series(::PjmMarket) :: Vector{NamedTuple}

Return Vector of `NamedTuple` of available time series for the given `market`.

Ex:
```
[
    (name="RT-load", unit="MW", resolution=Hour(1), first_date=DateTime("2021-01-01T00:00:00"), method=get_real_time_load_data, description="Real-time load data"),
    (name="RT-LMP", unit="MWh", resolution=Hour(1), first_date=DateTime("2021-01-01T00:00:00"), method=get_real_time_lmp, description="Real-time Locational Marginal Price data"),
]
```
"""
function available_time_series(::PjmMarket)::Vector{NamedTuple}
    return [
        (
            name = "DA-LMP",
            unit = "\$/MWh",
            resolution = Hour(1),
            first_date = DateTime("2000-06-01T00:00:00"),
            method = get_day_ahead_lmp_pjm,
            description = "Day-Ahead Energy Market locational marginal pricing (LMP) data for all bus locations",
        ),
    ]
end

"""
    get_timezone(market::PjmMarket) :: TimeZone

Return the timezone of the given `market`.
"""
function get_timezone(market::PjmMarket)::TimeZone
    return market.timezone
end

"""
    get_day_ahead_hourly_lmp_raw_data(market::PjmMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir())

Download raw data for Day-Ahead Energy Market locational marginal pricing (LMP) data for all bus locations `market` and `start_date` to `end_date` and save it in `folder`.
"""
function get_day_ahead_hourly_lmp_raw_data(
    market::PjmMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
)::Nothing

    # assert that the difference between the start and end date is less than 366 days
    @assert Dates.value((end_date - start_date)) / 86400000 < 366 "Currently, we only support downloading data for less than 366 days."

    directory = mkpath(joinpath(folder, market.directory))

    start_date_str, start_hour_minute, end_date_str, end_hour_minute =
        get_str_dates(start_date, end_date, market)
    url = get_url_day_ahead_hourly_lmp(
        start_date_str,
        start_hour_minute,
        end_date_str,
        end_hour_minute,
    )
    access_key_dict = get_acess_key_headers()

    file_path = joinpath(directory, "day_ahead_hourly_lmp.csv")
    _download(url, file_path, access_key_dict)
    return nothing
end


"""
    get_day_ahead_hourly_lmp(market::PjmMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir())

Return a table with data for Day-Ahead Energy Market locational marginal pricing (LMP) data for all bus locations `market` and `start_date` to `end_date` and save it in `folder`.
"""
function get_day_ahead_hourly_lmp(
    market::PjmMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime,
)
    # assert that the difference between the start and end date is less than 366 days
    @assert Dates.value((end_date - start_date)) / 86400000 < 366 "Currently, we only support downloading data for less than 366 days."

    start_date_str, start_hour_minute, end_date_str, end_hour_minute =
        get_str_dates(start_date, end_date, market)
    url = get_url_day_ahead_hourly_lmp(
        start_date_str,
        start_hour_minute,
        end_date_str,
        end_hour_minute,
    )
    access_key_dict = get_acess_key_headers()

    response = HTTP.get(url, headers = access_key_dict)

    return CSV.read(IOBuffer(response.body), DataFrame)
end
