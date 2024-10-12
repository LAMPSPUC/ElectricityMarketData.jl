"""
    MisoMarket

struct representing the Midcontinent Independent System Operator (MISO).
"""

Base.@kwdef struct MisoMarket <: ElectricityMarket
    url::String = "https://docs.misoenergy.org/"
    directory::String = "MisoMarket"
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
    _async_get_real_time_lmp_raw_data(market::MisoMarket, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString=tempdir())

Download raw data for Real-Time (RT) Locational Marginal Price (LMP) for the given `market` and `start_date` to `end_date` and save it in `folder`.
"""
function _async_get_real_time_lmp_raw_data(
    market::MisoMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime;
    folder::AbstractString = tempdir(),
)::Vector{Task}
    directory = _mkdir(joinpath(folder, market.directory))
    start = _zoned_date_time_to_yyyymmdd(start_date, market.timezone)
    stop = _zoned_date_time_to_yyyymmdd(end_date, market.timezone)
    urls = Vector{String}()
    paths = Vector{String}()
    base_url = joinpath(market.url, "marketreports")
    base_file = "_rt_lmp_final.csv"
    for date in start:stop
       file = string(date) * base_file
       url = base_url * "/" * file
       path = joinpath(directory, file)
       push!(urls, url)
       push!(paths, path)
    end
    return _download_async(urls, paths)
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
    tasks = _async_get_real_time_lmp_raw_data(market, start_date, end_date; folder = folder)
    for task in tasks
        wait(task)
    end
    return nothing
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
    # TODO
    dict = Dict{String, Vector{Float64}}()
    tasks = _async_get_real_time_lmp_raw_data(market, start_date, end_date; folder = folder)
    for task in tasks
        file_name = fetch(task)
        df = CSV.read(file_name, DataFrame)[4:end,:]
        for row in eachrow(df)
            if (row[3] != "LMP") continue end
            vec = [parse(Float64, x) for x in values(row[4:27])]
            if !haskey(dict, row[1])
                dict[row[1]] = vec
            else
                append!(dict[row[1]], vec)
            end
        end
    end
    return dict
end
