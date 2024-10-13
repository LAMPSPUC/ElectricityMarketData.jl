"""
    get_day_ahead_hourly_lmp(start_date::String, end_date::String)::DataFrame

Get the dataframe for the day ahead hourly lmp data from the PJM API between `start_date` and `end_date`.

# Arguments
- start_date::String: The start date of the data to be retrieved (format: "m/d/y").
- end_date::String: The end date of the data to be retrieved (format: "m/d/y").
- start_hour_minute::String: The start hour and minute of the data to be retrieved (format: "HH:MM").
- end_hour_minute::String: The end hour and minute of the data to be retrieved (format: "HH:MM").

# Returns
- DataFrame: The dataframe for the day ahead hourly lmp data from the PJM API between `start_date` and `end_date`.
"""
function get_day_ahead_hourly_lmp(
    start_date::String,
    start_hour_minute,
    end_date::String,
    end_hour_minute,
)::DataFrame
    access_key_dict = get_acess_key_headers()
    url = get_url_day_ahead_hourly_lmp(
        start_date,
        start_hour_minute,
        end_date,
        end_hour_minute,
    )
    response = HTTP.get(url, headers = access_key_dict)

    return CSV.read(IOBuffer(response.body), DataFrame)

end
