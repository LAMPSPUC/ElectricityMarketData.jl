@testset "pjm_market.jl" begin
    @testset "get_pjm_lmp_raw_data with download" begin
        mktempdir() do tempdir
            market = ElectricityMarketData.PjmMarket()
            ElectricityMarketData.get_pjm_lmp_raw_data(
                market,
                "DA-LMP",
                ZonedDateTime(DateTime(2024, 1, 1, 0, 0), tz"UTC-4"),
                ZonedDateTime(DateTime(2024, 1, 1, 1, 0), tz"UTC-4");
                folder = tempdir,
            )
            directory = joinpath(tempdir, market.directory)
            @test isdir(directory)
            @test isfile(joinpath(directory, "DA-LMP from 1-1-2024 00:00 to 1-1-2024 01:00.csv"))
        end
    end

    @testset "get_pjm_lmp_raw_data without download" begin
        market = ElectricityMarketData.PjmMarket()
        df_raw = ElectricityMarketData.get_pjm_lmp_raw_data(
            market,
            "RT-LMP",
            ZonedDateTime(DateTime(2024, 1, 1, 0, 0), tz"UTC-4"),
            ZonedDateTime(DateTime(2024, 1, 1, 1, 0), tz"UTC-4");
            folder = "",
            download = false
        )
        @test typeof(df_raw) == DataFrame
    end
end
