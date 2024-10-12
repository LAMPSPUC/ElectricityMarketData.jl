const DayAheadHourlyLMP_values_keys = [
    "system_energy_price_da",
    "total_lmp_da",
    "congestion_price_da",
    "marginal_loss_price_da",
]

const DayAheadHourlyLMP_meta_keys = [
    "pnode_name",
    "voltage",
    "equipment",
    "type",
    "zone",
    "row_is_current",
    "version_nbr",
]

struct DayAheadHourlyLMP <: ElectricityMarket
    Meta::DataFrame
    SystemEnergyPricesAhead::DataFrame
    TotalLMPDayAhead::DataFrame
    CongestionPriceDayAhead::DataFrame
    MarginalLossPriceDayAhead::DataFrame

    function DayAheadHourlyLMP(start_date::String, start_hour_minute, end_date::String, end_hour_minute::String)
        df = get_day_ahead_hourly_lmp(start_date, start_hour_minute, end_date, end_hour_minute)
        df_dict, meta_df = parse_df_format(df, DayAheadHourlyLMP_values_keys, DayAheadHourlyLMP_meta_keys)
        return new(
            meta_df,
            df_dict["system_energy_price_da"],
            df_dict["total_lmp_da"],
            df_dict["congestion_price_da"],
            df_dict["marginal_loss_price_da"],
        )
    end
end

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
function get_day_ahead_hourly_lmp(start_date::String, start_hour_minute, end_date::String, end_hour_minute)::DataFrame
    access_key_dict = get_acess_key_headers()
    url = get_url_day_ahead_hourly_lmp(start_date, start_hour_minute, end_date, end_hour_minute)
    response = HTTP.get(url, headers=access_key_dict)

    return CSV.read(IOBuffer(response.body), DataFrame)

end

"""
 parse_df_format(df::DataFrame, value_keys::Vector{String}, meta_keys::Vector{String})::Tuple{Dict, DataFrame}

parse the DataFrame into a Dict of DataFrames for each value key and a DataFrame for the meta keys.

# Arguments
- df::DataFrame: The DataFrame to be parsed.
- value_keys::Vector{String}: The keys to be parsed into a Dict of DataFrames.
- meta_keys::Vector{String}: The keys to be parsed into a DataFrame.

# Returns
- Tuple{Dict, DataFrame}: A Tuple containing the Dict of DataFrames for each value key and a DataFrame for the meta keys.
"""
function parse_df_format(df::DataFrame, value_keys::Vector{String}, meta_keys::Vector{String})::Tuple{Dict, DataFrame}

    df.datetime_beginning_utc = DateTime.(df.datetime_beginning_utc, "m/d/y H:M:S p")
    df.datetime_beginning_ept = DateTime.(df.datetime_beginning_ept, "m/d/y H:M:S p")

    df_dict   = get_group_df(df, value_keys)
    meta_df   = get_meta_dict(df, meta_keys)

    return df_dict, meta_df
end

"""
    get_group_df(df::DataFrame, value_keys::Vector{String})::Dict{String, DataFrame}

Group the DataFrame by pnode_id and return a Dict of DataFrames for each value key.

# Arguments
- df::DataFrame: The DataFrame to be grouped.
- value_keys::Vector{String}: The keys to be grouped into a Dict of DataFrames.

# Returns
- Dict{String, DataFrame}: A Dict of DataFrames for each value key.
"""
function get_group_df(df::DataFrame, value_keys::Vector{String})::Dict{String, DataFrame}
    unique_dates_utc = unique(df.datetime_beginning_utc)
    unique_dates_ept = unique(df.datetime_beginning_ept)

    df_dict = Dict{String, DataFrame}()
    for key in value_keys 
        key_df = DataFrame("datetime_beginning_utc" => unique_dates_utc, "datetime_beginning_ept" => unique_dates_ept)

        grouped_df = groupby(df, :pnode_id)

        # Iterate over the grouped data to populate key_df
        for group in grouped_df
            pnode_id = unique(group.pnode_id)[1]
            key_df[!, Symbol(pnode_id)] = group[:, key]
        end

        df_dict[key] = key_df
    end
    return df_dict
end

"""
    get_meta_dict(df::DataFrame, meta_keys::Vector{String})::DataFrame

Get the meta DataFrame from the DataFrame.

# Arguments
- df::DataFrame: The DataFrame to get the meta DataFrame from.
- meta_keys::Vector{String}: The keys to be included in the meta DataFrame.

# Returns
- DataFrame: The meta DataFrame.
"""
function get_meta_dict(df::DataFrame, meta_keys::Vector{String})::DataFrame
    
    unique_pnode_id = unique(df.pnode_id)

    meta_df = DataFrame(pnode_id = unique_pnode_id)

    # Group the original DataFrame by pnode_id for efficient lookup
    grouped_df = groupby(df, :pnode_id)

    # Iterate over the unique keys to populate meta_df
    for key in meta_keys
        # Create a column for each key
        meta_df[!, key] =  Vector{Any}(undef, nrow(meta_df))

        # Populate the column values using the grouped data
        for (index, group) in enumerate(grouped_df)
            #assert that the pnode_id is the same for all rows in the group
            @assert all(group.pnode_id .== group.pnode_id[1])
            meta_df[index, key] = group[1, key]  # Assume the first value represents the key value
        end
    end
    return meta_df
end
