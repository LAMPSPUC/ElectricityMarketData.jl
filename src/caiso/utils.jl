"""
    _async_get_raw_data(market::CaisoMarket, serie::AbstractString, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString)::Vector{Task}

Download the 'func' raw data for the given `market` and `start_date` to `end_date` and save it in `folder`.
"""
function _async_get_raw_data(
    market::CaisoMarket,
    serie::AbstractString,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime,
    folder::AbstractString,
)::Vector{Task}
    directory = mkpath(joinpath(folder, market.directory))
    tasks = Vector{Task}()
    date = start_date
    while date < end_date
        start_formated = _get_zdt_formated(date)
        next = date + Day(1)
        end_formated = _get_zdt_formated(next)
        url = _get_caiso_price_url(start_formated, end_formated, serie)
        push!(
            tasks,
            _async_download(
                url,
                joinpath(
                    directory,
                    replace(start_formated, ":" => "") * "_" * serie * ".zip",
                ),
            ),
        )
        date = next
    end
    return tasks
end

"""
    _get_raw_data(market::CaisoMarket, serie::AbstractString, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString)::Nothing

Download the 'func' raw data for the given `market` and `start_date` to `end_date` and save it in `folder`.
"""
function _get_raw_data(
    market::CaisoMarket,
    serie::AbstractString,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime,
    folder::AbstractString,
)::Nothing
    tasks = _async_get_raw_data(market, serie, start_date, end_date, folder)
    for task in tasks
        _ = _unzip(fetch(task), x -> serie * "_" * x)
    end
    return nothing
end

"""
    _get_data(market::CaisoMarket, serie::AbstractString, start_date::ZonedDateTime, end_date::ZonedDateTime; folder::AbstractString)

Download the 'func' raw data for the given `market` and `start_date` to `end_date` and save it in `folder`.
"""
function _get_data(
    market::CaisoMarket,
    serie::AbstractString,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime,
    folder::AbstractString,
)
    tasks = _async_get_raw_data(market, serie, start_date, end_date, folder)
    dfs = Vector{DataFrame}()
    for task in tasks
        temp = nothing
        for file_name in _unzip(fetch(task), x -> serie * "_" * x)
            df = CSV.read(file_name, DataFrame)
            pivot =
                unstack(df, [:INTERVALSTARTTIME_GMT, :MARKET_RUN_ID, :NODE], :LMP_TYPE, :MW)
            temp =
                isnothing(temp) ? pivot :
                outerjoin(temp, pivot, on = [:INTERVALSTARTTIME_GMT, :MARKET_RUN_ID, :NODE])
        end
        push!(dfs, temp)
    end
    df = vcat(dfs...)
    rename!(
        df,
        Dict(
            :INTERVALSTARTTIME_GMT => :Time,
            :MARKET_RUN_ID => :Market,
            :NODE => :Node,
            :MCC => :Congestion,
            :MCE => :Energy,
            :MCL => :Loss,
        ),
    )
    return df
end
