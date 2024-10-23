"""
    _async_get_raw_data(
        market::PjmMarket,
        start_date::ZonedDateTime,
        end_date::ZonedDateTime,
        directory::AbstractString,
        access_key_dict::Dict{String, String},
        url_function::Function,
        series_name::String,
        download::Bool = true,
    )::Vector{Task}

Download raw data for Locational Marginal Price (LMP) for the given `market` and `start_date` to `end_date` and save it in `folder`.

# Arguments
- market::PjmMarket: The market object.
- start_date::ZonedDateTime: The start date of the data to be retrieved.
- end_date::ZonedDateTime: The end date of the data to be retrieved.
- directory::AbstractString: The directory where the data will be saved.
- access_key_dict::Dict{String, String}: The access key dictionary.
- url_function::Function: The function to get the url for the data.
- series_name::String: The name of the series.
- download::Bool: If true, download the data. If false, read the data.

# Returns
- Vector{Task}: The tasks to download the data.
"""
function _async_get_raw_data(
    market::PjmMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime,
    directory::AbstractString,
    access_key_dict::Dict{String, String},
    url_function::Function,
    series_name::String,
    download::Bool = true,
)::Vector{Task}

    dates = get_dates(start_date, end_date)
    # Loop over each day
    tasks = Vector{Task}()
 
    for date in dates

        st_date = date[1]; ed_date = date[2]

        start_date_str, start_hour_minute, end_date_str, end_hour_minute =
        get_str_dates(st_date, ed_date, market)
    
        url = url_function(
            start_date_str,
            start_hour_minute,
            end_date_str,
            end_hour_minute,
        )
    
        file_path = joinpath(directory, series_name * get_str_dates_file_name(st_date, ed_date, market) * ".csv")
       
        if download
            append!(
                tasks,
                [_async_download(
                    url,
                    file_path,
                    access_key_dict,
                )],
            )
        else
            append!(
                tasks,
                [@async read_url(
                    url, access_key_dict
                )],
            )
            
        end
     
    end

    return tasks
end

"""
    _get_raw_data(market::PjmMarket, start_date::ZonedDateTime, end_date::ZonedDateTime, directory::AbstractString, access_key_dict::Dict{String, String}, url_function::Function, series_name::String)::Nothing

Download raw data for Locational Marginal Price (LMP) for the given `market` and `start_date` to `end_date` and save it in `folder`.

# Arguments
- market::PjmMarket: The market object.
- start_date::ZonedDateTime: The start date of the data to be retrieved.
- end_date::ZonedDateTime: The end date of the data to be retrieved.
- directory::AbstractString: The directory where the data will be saved.
- access_key_dict::Dict{String, String}: The access key dictionary.
- url_function::Function: The function to get the url for the data.
- series_name::String: The name of the series.
- download::Bool: If true, download the data. If false, read the data.

# Returns
- Vector{Task}: The tasks to download the data.
"""
function _get_raw_data(
    market::PjmMarket,
    start_date::ZonedDateTime,
    end_date::ZonedDateTime,
    directory::AbstractString,
    access_key_dict::Dict{String, String},
    url_function::Function,
    series_name::String,
    download::Bool = true,
)::Vector{Task}
    tasks = _async_get_raw_data(
        market,
        start_date,
        end_date,
        directory,
        access_key_dict,
        url_function,
        series_name,
        download,
    )
    for task in tasks
        wait(task)
    end
    return tasks
end