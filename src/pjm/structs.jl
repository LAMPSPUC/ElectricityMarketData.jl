const PJMDayAheadHourlyLMP_values_keys = [
    "system_energy_price_da",
    "total_lmp_da",
    "congestion_price_da",
    "marginal_loss_price_da",
]

const PJMDayAheadHourlyLMP_meta_keys =
    ["pnode_name", "voltage", "equipment", "type", "zone", "row_is_current", "version_nbr"]


struct DayAheadLmpPJM <: ElectricityMarket
    data::DataFrame
    function DayAheadLmpPJM(
        start_date::String,
        start_hour_minute,
        end_date::String,
        end_hour_minute::String,
    )
        df = get_day_ahead_hourly_lmp(
            start_date,
            start_hour_minute,
            end_date,
            end_hour_minute,
        )
        return new(df)
    end
end

struct ParsedDayAheadLmpPJM <: ElectricityMarket
    Meta::DataFrame
    SystemEnergyPricesAhead::DataFrame
    TotalLMPDayAhead::DataFrame
    CongestionPriceDayAhead::DataFrame
    MarginalLossPriceDayAhead::DataFrame

    function ParsedDayAheadLmpPJM(dayaheadlmpPJM::DayAheadLmpPJM)

        df_dict, meta_df = parse_df_format(
            dayaheadlmpPJM.data,
            PJMDayAheadHourlyLMP_values_keys,
            PJMDayAheadHourlyLMP_meta_keys,
        )
        return new(
            meta_df,
            df_dict["system_energy_price_da"],
            df_dict["total_lmp_da"],
            df_dict["congestion_price_da"],
            df_dict["marginal_loss_price_da"],
        )
    end
end
