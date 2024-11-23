@testset "electricity_market.jl" begin
    @testset "MockMarket" begin
        struct MockMarket <: ElectricityMarket
            url::String
            timezone::TimeZone
        end

        MockMarket() = MockMarket("https://example.com", tz"UTC")

        market = MockMarket()

        @testset "list_markets" begin
            @test list_markets() isa Vector{Symbol}
        end

        @testset "available_time_series" begin
            @test available_time_series(market) isa Vector{NamedTuple}
        end

        @testset "get_timezone error" begin
            @test_throws MethodError get_timezone(market)
        end

        function ElectricityMarketData.get_timezone(market::MockMarket)::TimeZone
            return market.timezone
        end

        @testset "get_timezone" begin
            @test get_timezone(market) isa TimeZone

            @test ZonedDateTime(DateTime("2021-01-01T00:00:00"), market) isa ZonedDateTime
        end

        @testset "get_real_time_lmp_raw_data" begin
            @test_throws MethodError get_real_time_lmp_raw_data(
                market,
                DateTime("2021-01-01T00:00:00"),
                DateTime("2021-01-01T00:00:00"),
            )

            @test_throws MethodError get_real_time_lmp_raw_data(
                market,
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
            )
        end

        @testset "get_real_time_lmp" begin
            @test_throws MethodError get_real_time_lmp(
                market,
                DateTime("2021-01-01T00:00:00"),
                DateTime("2021-01-01T00:00:00"),
            )

            @test_throws MethodError get_real_time_lmp(
                market,
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
            )
        end

        @testset "get_day_ahead_lmp_raw_data" begin
            @test_throws MethodError get_day_ahead_lmp_raw_data(
                market,
                DateTime("2021-01-01T00:00:00"),
                DateTime("2021-01-01T00:00:00"),
            )

            @test_throws MethodError get_day_ahead_lmp_raw_data(
                market,
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
            )
        end

        @testset "get_day_ahead_lmp" begin
            @test_throws MethodError get_day_ahead_lmp(
                market,
                DateTime("2021-01-01T00:00:00"),
                DateTime("2021-01-01T00:00:00"),
            )

            @test_throws MethodError get_day_ahead_lmp(
                market,
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
            )
        end

        @testset "get_load_raw_data" begin
            @test_throws MethodError get_load_raw_data(
                market,
                DateTime("2021-01-01T00:00:00"),
                DateTime("2021-01-01T00:00:00"),
            )

            @test_throws MethodError get_load_raw_data(
                market,
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
            )
        end

        @testset "get_load" begin
            @test_throws MethodError get_load(
                market,
                DateTime("2021-01-01T00:00:00"),
                DateTime("2021-01-01T00:00:00"),
            )

            @test_throws MethodError get_load(
                market,
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
            )
        end

        @testset "get_load_forecast_raw_data" begin
            @test_throws MethodError get_load_forecast_raw_data(
                market,
                DateTime("2021-01-01T00:00:00"),
                DateTime("2021-01-01T00:00:00"),
            )

            @test_throws MethodError get_load_forecast_raw_data(
                market,
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
            )
        end

        @testset "get_load_forecast" begin
            @test_throws MethodError get_load_forecast(
                market,
                DateTime("2021-01-01T00:00:00"),
                DateTime("2021-01-01T00:00:00"),
            )

            @test_throws MethodError get_load_forecast(
                market,
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
                ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"),
            )
        end

        @testset "real_time_lmp_data_types" begin
            @test_throws MethodError real_time_lmp_data_types(market)
        end

        @testset "real_time_lmp_frequency" begin
            @test_throws MethodError real_time_lmp_frequency(market)
        end

        @testset "load_data_types" begin
            @test_throws MethodError load_data_types(market)
        end

        @testset "load_forecast_data_types" begin
            @test_throws MethodError load_forecast_data_types(market)
        end
    end
end
