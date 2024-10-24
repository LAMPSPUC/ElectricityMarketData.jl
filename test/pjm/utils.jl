@testset "pjm/utils.jl" begin
    @testset "get_acess_key_headers" begin
        headers = ElectricityMarketData.get_acess_key_headers()
        @test haskey(headers, "Ocp-Apim-Subscription-Key")
    end

    @testset "get_str_dates" begin
        start_date = ZonedDateTime(DateTime("2024-01-01"), tz"UTC-4")
        end_date = ZonedDateTime(DateTime("2024-01-02"), tz"UTC-4")
        market = ElectricityMarketData.PjmMarket()
        start_date_str, start_hour_minute, end_date_str, end_hour_minute =
            ElectricityMarketData.get_str_dates(start_date, end_date, market)
        @test start_date_str == "1/1/2024"
        @test start_hour_minute == "00:00"
        @test end_date_str == "1/2/2024"
        @test end_hour_minute == "00:00"
    end

    @testset "get_str_dates_file_name" begin
        start_date = ZonedDateTime(DateTime("2024-01-01"), tz"UTC-4")
        end_date = ZonedDateTime(DateTime("2024-01-02"), tz"UTC-4")
        market = ElectricityMarketData.PjmMarket()
        str_dates =
            ElectricityMarketData.get_str_dates_file_name(start_date, end_date, market)
        @test str_dates == " from 1-1-2024 00:00 to 1-2-2024 00:00"
    end

    @testset "get_url_function" begin
        market = ElectricityMarketData.PjmMarket()
        @test ElectricityMarketData.get_url_function(market, "DA-LMP") ==
              ElectricityMarketData.get_url_day_ahead_lmp
        @test ElectricityMarketData.get_url_function(market, "RT-LMP") ==
              ElectricityMarketData.get_url_real_time_lmp

        #test assert error 
        @test_throws AssertionError ElectricityMarketData.get_url_function(
            market,
            "RT-load",
        )

    end

    @testset "get_dates" begin
        dates = ElectricityMarketData.get_dates(
            ZonedDateTime(DateTime("2024-01-01"), tz"UTC-4"),
            ZonedDateTime(DateTime("2024-01-02"), tz"UTC-4"),
        )
        @test length(dates) == 1
        @test dates[1] == (
            ZonedDateTime(DateTime("2024-01-01"), tz"UTC-4"),
            ZonedDateTime(DateTime("2024-01-02"), tz"UTC-4"),
        )

        dates2 = ElectricityMarketData.get_dates(
            ZonedDateTime(DateTime("2024-01-01"), tz"UTC-4"),
            ZonedDateTime(DateTime("2024-01-03"), tz"UTC-4"),
        )
        @test length(dates2) == 2
        @test dates2[1] == (
            ZonedDateTime(DateTime("2024-01-01"), tz"UTC-4"),
            ZonedDateTime(DateTime("2024-01-02"), tz"UTC-4"),
        )
    end

    @testset "read_url" begin
        url = ElectricityMarketData.get_url_day_ahead_lmp(
            "1/1/2024",
            "00:00",
            "1/1/2024",
            "01:00",
        )
        df = ElectricityMarketData.read_url(
            url,
            ElectricityMarketData.get_acess_key_headers(),
        )
        @test typeof(df) == DataFrame
    end
end
