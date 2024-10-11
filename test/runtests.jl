using ElectricityMarketData
using Dates
using TimeZones
using Test

import ElectricityMarketData: get_timezone

@testset "ElectricityMarketData.jl" begin
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
                DateTime("2021-01-01T00:00:00", tz"UTC"),
                DateTime("2021-01-01T00:00:00", tz"UTC"),
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
                DateTime("2021-01-01T00:00:00", tz"UTC"),
                DateTime("2021-01-01T00:00:00", tz"UTC"),
            )
        end
    end
end
