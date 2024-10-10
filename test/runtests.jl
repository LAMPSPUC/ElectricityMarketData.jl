using ElectricityMarketData
using Dates
using Test

@testset "ElectricityMarketData.jl" begin
    @testset "MockMarket" begin
        struct MockMarket <: ElectricityMarket 
            url::String
        end

        MockMarket() = MockMarket("https://example.com")

        market = MockMarket("https://example.com")
        
        @testset "list_markets" begin
            @test list_markets() isa Vector{Symbol}
        end

        @testset "available_time_series" begin
            @test available_time_series(market) isa Vector{NamedTuple}
        end

        @testset "get_rt_lmp_raw_data" begin
            @test_throws MethodError get_rt_lmp_raw_data(market, DateTime("2021-01-01T00:00:00"), DateTime("2021-01-01T00:00:00"))
        end

        @testset "rt_lmp_data" begin
            @test_throws MethodError rt_lmp_data(market, DateTime("2021-01-01T00:00:00"), DateTime("2021-01-01T00:00:00"))
        end
    end
end
