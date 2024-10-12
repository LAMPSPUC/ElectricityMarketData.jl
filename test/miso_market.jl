@testset "miso_market.jl" begin
    @testset "get_real_time_lmp_raw_data" begin
        mktempdir() do tempdir
            market = ElectricityMarketData.MisoMarket()
            get_real_time_lmp_raw_data(
                market,
                DateTime("2024-01-01"),
                DateTime("2024-01-02");
                folder = tempdir,
            )
            directory = joinpath(tempdir, market.directory)
            @test isdir(directory)
            @test isfile(joinpath(directory, "20240101_rt_lmp_final.csv"))
            @test isfile(joinpath(directory, "20240102_rt_lmp_final.csv"))
        end
    end

    @testset "get_real_time_lmp" begin
        mktempdir() do tempdir
            market = ElectricityMarketData.MisoMarket()
            # TODO
            _ = get_real_time_lmp(
                market,
                DateTime("2024-01-01"),
                DateTime("2024-01-02");
                folder = tempdir,
            )
        end
    end
end
