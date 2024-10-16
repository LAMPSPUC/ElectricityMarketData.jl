@testset "pjm_market.jl" begin
    @testset "get_day_ahead_lmp_raw_data" begin
        mktempdir() do tempdir
            market = ElectricityMarketData.PjmMarket()
            ElectricityMarketData.get_day_ahead_lmp_raw_data(
                market,
                ZonedDateTime(DateTime(2024, 1, 1, 0, 0), tz"UTC-4"),
                ZonedDateTime(DateTime(2024, 1, 1, 1, 0), tz"UTC-4");
                folder = tempdir,
            )
            directory = joinpath(tempdir, market.directory)
            @test isdir(directory)
            @test isfile(joinpath(directory, "day_ahead_lmp.csv"))
        end
    end

    @testset "get_day_ahead_lmp" begin
        market = ElectricityMarketData.PjmMarket()
        df_raw = ElectricityMarketData.get_day_ahead_lmp(
            market,
            ZonedDateTime(DateTime(2024, 1, 1, 0, 0), tz"UTC-4"),
            ZonedDateTime(DateTime(2024, 1, 1, 1, 0), tz"UTC-4"),
        )
        @test typeof(df_raw) == DataFrame
    end
end
