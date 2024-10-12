@testset "date_time_helper.jl" begin
    @testset "_zoned_date_time_to_yyyymmdd" begin
        @test ElectricityMarketData._zoned_date_time_to_yyyymmdd(ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"), tz"UTC") == 20210101
        @test ElectricityMarketData._zoned_date_time_to_yyyymmdd(ZonedDateTime(DateTime("2021-01-01T00:00:00"), tz"UTC"), tz"UTC-1") == 20201231
    end
end
