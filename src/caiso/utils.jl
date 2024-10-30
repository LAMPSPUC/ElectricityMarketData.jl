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
    for task in tasks
        _unzip(fetch(task), x -> serie * "_" * x)
    end
    return nothing
end
