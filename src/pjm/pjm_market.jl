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
            method = get_day_ahead_lmp,
            first_date = DateTime("2000-06-01T00:00:00"),
            description = "Day-Ahead Energy Market locational marginal pricing (LMP) data for all bus locations",
            url_function = get_url_day_ahead_lmp,
        ),
        (
            name = "RT-LMP",
            unit = "\$/MWh",
            resolution = Hour(1),
            method = get_real_time_lmp,
            first_date = DateTime("1998-04-01T00:00:00"),
            description = "Real Time Energy Market locational marginal pricing (LMP) data for all bus locations",
            url_function = get_url_real_time_lmp,
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
    get_day_ahead_lmp_raw_data(market::PjmMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir())

Download raw data for Day-Ahead Energy Market locational marginal pricing (LMP) data for all bus locations `market` and `start_date` to `end_date` and save it in `folder`.
"""
function get_pjm_lmp_raw_data(
    market::PjmMarket,
    series_name::String,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
    download::Bool = true,
)

    url_function = get_url_function(market, series_name)

    # assert that the difference between the start and end date is less than 366 days
    @assert Dates.value((end_date - start_date)) / 86400000 < 366 "Currently, we only support downloading data for less than 366 days."

    directory = mkpath(joinpath(folder, market.directory))

    access_key_dict = get_acess_key_headers()

    tasks = _get_raw_data(
        market,
        start_date,
        end_date,
        directory,
        access_key_dict,
        url_function,
        series_name,
        download,
    )

    if download
        return nothing
    else
        df = DataFrame()
        for task in tasks
            df = vcat(df, fetch(task))
        end
        #sort df by datetime column "datetime_beginning_utc"
        sort!(df, :datetime_beginning_utc)
        return df

    end

end

"""
    get_real_time_lmp(market::PjmMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir()) :: Tables.table

Return a table with Real-Time (RT) Locational Marginal Price (LMP) data for the given `market` and `start_date` to `end_date`, download is chosen, save it in `folder` instead.
"""
function get_real_time_lmp(
    market::PjmMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
    download::Bool = false,
)
    return get_pjm_lmp_raw_data(
        market,
        "RT-LMP",
        start_date,
        end_date;
        folder = folder,
        download = download,
    )
end

"""
    get_day_ahead_lmp(market::PjmMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir()) :: Tables.table

Return a table with Day-Ahead (DA) Locational Marginal Price (LMP) data for the given `market` and `start_date` to `end_date`, download is chosen, save it in `folder` instead.

"""
function get_day_ahead_lmp(
    market::PjmMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
    download::Bool = false,
)
    return get_pjm_lmp_raw_data(
        market,
        "DA-LMP",
        start_date,
        end_date;
        folder = folder,
        download = download,
    )
end
