"""
    get_url_day_ahead_lmp(start_date::String, end_date::String)::AbstractString

Get the url for the day ahead hourly lmp data from the PJM API.

# Arguments
- start_date::String: The start date of the data to be retrieved.
- end_date::String: The end date of the data to be retrieved.
- start_hour_minute::String: The start hour and minute of the data to be retrieved.
- end_hour_minute::String: The end hour and minute of the data to be retrieved.

# Returns
- AbstractString: The url for the day ahead hourly lmp data from the PJM API.
"""
function get_url_day_ahead_lmp(
    start_date::String,
    start_hour_minute::String,
    end_date::String,
    end_hour_minute::String,
)::AbstractString

    return "https://api.pjm.com/api/v1/da_hrl_lmps?startRow=1&isActiveMetadata=true&datetime_beginning_ept=$start_date%20$(start_hour_minute)to$end_date%20$(end_hour_minute)&format=csv&download=true"
end

"""
    get_url_real_time_lmp(start_date::String, end_date::String)::AbstractString

Get the url for the real time hourly lmp data from the PJM API.

# Arguments
- start_date::String: The start date of the data to be retrieved.
- end_date::String: The end date of the data to be retrieved.
- start_hour_minute::String: The start hour and minute of the data to be retrieved.
- end_hour_minute::String: The end hour and minute of the data to be retrieved.

# Returns
- AbstractString: The url for the real time hourly lmp data from the PJM API.
"""
function get_url_real_time_lmp(
    start_date::String,
    start_hour_minute::String,
    end_date::String,
    end_hour_minute::String,
)::AbstractString

    return "https://api.pjm.com/api/v1/rt_hrl_lmps?rowCount=25&startRow=1&isActiveMetadata=true&datetime_beginning_ept=$start_date%20$(start_hour_minute)to$end_date%20$(end_hour_minute)&format=csv&download=true"
end
