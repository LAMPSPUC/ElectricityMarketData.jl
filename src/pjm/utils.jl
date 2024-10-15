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
