"""
    get_acess_key_headers()::Dict

Get the access key headers from the PJM API.
"""
function get_acess_key_headers()::Dict
    # get public subscription key
    r = HTTP.request("GET", "http://dataminer2.pjm.com/config/settings.json")
    #convert response to dict
    response = JSON.Parser.parse(String(r.body))
    return Dict("Ocp-Apim-Subscription-Key" => response["subscriptionKey"])
end

"""
    get_str_dates(start_date::ZonedDateTime, end_date::ZonedDateTime, market::PjmMarket)::Tuple{String, String, String, String}

Get the start and end date strings in the format "m/d/yyyy" and the start and end hour and minute strings in the format "HH:MM".
"""
function get_str_dates(
    start_date::ZonedDateTime,
    end_date::ZonedDateTime,
    market::PjmMarket,
)::Tuple{String,String,String,String}
    zd_start_date = astimezone(start_date, market.timezone)
    zd_end_date = astimezone(end_date, market.timezone)

    start_date_str = Dates.format(zd_start_date, "m/d/yyyy")
    start_hour_minute = Dates.format(zd_start_date, "HH:MM")
    end_date_str = Dates.format(zd_end_date, "m/d/yyyy")
    end_hour_minute = Dates.format(zd_end_date, "HH:MM")
    return start_date_str, start_hour_minute, end_date_str, end_hour_minute
end

"""
    get_str_dates_file_name(start_date::ZonedDateTime, end_date::ZonedDateTime)::String

Get the start and end date strings in the format "m-d-yyyy HH:MM" for the file name.

# Arguments
- start_date::ZonedDateTime: The start date of the data to be retrieved.
- end_date::ZonedDateTime: The end date of the data to be retrieved.
- market::PjmMarket: The market object.

# Returns
- String: The start and end date strings in the format "m-d-yyyy HH:MM" for the file name.
"""
function get_str_dates_file_name(
    start_date::ZonedDateTime,
    end_date::ZonedDateTime,
    market::PjmMarket,
)
    zd_start_date = astimezone(start_date, market.timezone)
    zd_end_date = astimezone(end_date, market.timezone)

    start_date_str = Dates.format(zd_start_date, "m/d/yyyy HH:MM")
    end_date_str = Dates.format(zd_end_date, "m/d/yyyy HH:MM")

    # convert `/` to `-` in the date string
    start_date_str = replace(start_date_str, "/" => "-")
    end_date_str = replace(end_date_str, "/" => "-")
    return " from " * start_date_str * " to " * end_date_str
end

"""
    get_url_function(market::PjmMarket, series_name::String)::Function

Get the url function for the series name.

# Arguments
- market::PjmMarket: The market object.
- series_name::String: The name of the series.

# Returns
- Function: The url function for the series name.
"""
function get_url_function(
    market::PjmMarket,
    series_name::String,
)::Function
    av_time_series = available_time_series(market)
    available_names = map(x -> x.name, av_time_series)
    @assert series_name in available_names "Series name not available for the given market."
    # get the url function for the series
    return first(filter(x -> x.name == series_name, av_time_series)).url_function
end

"""
    get_dates(start_date::ZonedDateTime, end_date::ZonedDateTime)::Tuple{Vector{ZonedDateTime}, Vector{ZonedDateTime}}

Get the start and end date for each day in the range.

# Arguments
- start_date::ZonedDateTime: The start date of the data to be retrieved.
- end_date::ZonedDateTime: The end date of the data to be retrieved.

# Returns
- dates::Vector{Tuple{ZonedDateTime, ZonedDateTime}}: The start and end date for each month in the range.
"""
function get_dates(
    start_date::ZonedDateTime,
    end_date::ZonedDateTime,)::Vector{Tuple{ZonedDateTime, ZonedDateTime}}
    # get the start and end date for each month in the range
    dates = []

    current_start = start_date
    while current_start < end_date
        current_end = min(end_date, current_start + Day(1))
        push!(dates, (current_start, current_end))
        current_start = current_end + Hour(1)
    end
    return dates
end

"""
    read_url(url::AbstractString, access_key_dict::Dict)::DataFrame

Read the data from the url.

# Arguments
- url::AbstractString: The url to read the data from.
- access_key_dict::Dict: The access key dictionary.

# Returns
- DataFrame: The data read from the url.
"""
function read_url(
    url::AbstractString,
    access_key_dict::Dict,
)::DataFrame
    # get the data from the url
    response = HTTP.get(url, headers = access_key_dict)
    # read the data into a DataFrame
    CSV.read(IOBuffer(response.body), DataFrame)
end