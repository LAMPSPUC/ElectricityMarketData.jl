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
end
