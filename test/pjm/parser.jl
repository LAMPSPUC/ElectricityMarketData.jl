@testset "pjm/parser.jl" begin

    start_date = "10/2/2024"
    start_hour_minute = "00:00"
    end_date = "10/2/2024"
    end_hour_minute = "01:00"
    url = ElectricityMarketData.get_url_day_ahead_hourly_lmp(
        start_date,
        start_hour_minute,
        end_date,
        end_hour_minute,
    )
    access_key_dict = ElectricityMarketData.get_acess_key_headers()

    response = HTTP.get(url, headers = access_key_dict)

    df = CSV.read(IOBuffer(response.body), DataFrame)
    @testset "parse_df_format" begin
        parsed_dict = ElectricityMarketData.parse_df_format(
            df,
            ElectricityMarketData.PJMDayAheadHourlyLMP_values_keys,
            ElectricityMarketData.PJMDayAheadHourlyLMP_meta_keys,
        )
        @test haskey(parsed_dict, "total_lmp_da")
        @test haskey(parsed_dict, "meta")
        @test haskey(parsed_dict, "congestion_price_da")
        @test haskey(parsed_dict, "marginal_loss_price_da")
        @test haskey(parsed_dict, "system_energy_price_da")

        @test size(parsed_dict["meta"], 1) == size(parsed_dict["total_lmp_da"], 2) - 2
        @test size(parsed_dict["meta"], 1) ==
              size(parsed_dict["congestion_price_da"], 2) - 2
        @test size(parsed_dict["meta"], 1) ==
              size(parsed_dict["marginal_loss_price_da"], 2) - 2
        @test size(parsed_dict["meta"], 1) ==
              size(parsed_dict["system_energy_price_da"], 2) - 2

        @test size(parsed_dict["total_lmp_da"]) == size(parsed_dict["congestion_price_da"])
        @test size(parsed_dict["total_lmp_da"]) ==
              size(parsed_dict["marginal_loss_price_da"])
        @test size(parsed_dict["total_lmp_da"]) ==
              size(parsed_dict["system_energy_price_da"])
    end

    @testset "get_group_df" begin
        parsed_dict = ElectricityMarketData.get_group_df(
            df,
            ElectricityMarketData.PJMDayAheadHourlyLMP_values_keys,
        )
        @test haskey(parsed_dict, "total_lmp_da")
        @test haskey(parsed_dict, "congestion_price_da")
        @test haskey(parsed_dict, "marginal_loss_price_da")
        @test haskey(parsed_dict, "system_energy_price_da")

        @test size(parsed_dict["total_lmp_da"]) == size(parsed_dict["congestion_price_da"])
        @test size(parsed_dict["total_lmp_da"]) ==
              size(parsed_dict["marginal_loss_price_da"])
        @test size(parsed_dict["total_lmp_da"]) ==
              size(parsed_dict["system_energy_price_da"])
    end

    @testset "get_meta_df" begin
        meta_df = ElectricityMarketData.get_meta_df(
            df,
            ElectricityMarketData.PJMDayAheadHourlyLMP_meta_keys,
        )
        @test size(meta_df, 2) == 8
    end
end
