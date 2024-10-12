"""
    get_url_day_ahead_hourly_lmp(start_date::String, end_date::String)::AbstractString

Get the url for the day ahead hourly lmp data from the PJM API.

# Arguments
- start_date::String: The start date of the data to be retrieved.
- end_date::String: The end date of the data to be retrieved.
- start_hour_minute::String: The start hour and minute of the data to be retrieved.
- end_hour_minute::String: The end hour and minute of the data to be retrieved.

# Returns
- AbstractString: The url for the day ahead hourly lmp data from the PJM API.
"""
function get_url_day_ahead_hourly_lmp(start_date::String, start_hour_minute, end_date::String, end_hour_minute)::AbstractString

    return "https://api.pjm.com/api/v1/da_hrl_lmps?sort=datetime_beginning_ept&order=Asc&startRow=1&isActiveMetadata=true&fields=congestion_price_da,datetime_beginning_ept,datetime_beginning_utc,equipment,marginal_loss_price_da,pnode_id,pnode_name,row_is_current,system_energy_price_da,total_lmp_da,type,version_nbr,voltage,zone&datetime_beginning_ept=$start_date%20$(start_hour_minute)to$end_date%20$(end_hour_minute)&format=csv&download=true"

end 