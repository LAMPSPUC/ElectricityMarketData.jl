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
            df = get_real_time_lmp(
                ElectricityMarketData.MisoMarket(),
                DateTime("2024-01-01"),
                DateTime("2024-01-02");
                folder = tempdir,
            )
            @test nrow(df) == 115872
            @test ncol(df) == 8
        end
        mktempdir() do tempdir
            df = get_real_time_lmp(
                ElectricityMarketData.MisoMarket(),
                DateTime("2021-12-31"),
                DateTime("2022-01-01");
                folder = tempdir,
            )
            @test nrow(df) == 110736
            @test ncol(df) == 8
        end
    end

    @testset "get_day_ahead_lmp_raw_data" begin
        mktempdir() do tempdir
            market = ElectricityMarketData.MisoMarket()
            get_day_ahead_lmp_raw_data(
                market,
                DateTime("2024-01-01"),
                DateTime("2024-01-02");
                folder = tempdir,
            )
            directory = joinpath(tempdir, market.directory)
            @test isdir(directory)
            @test isfile(joinpath(directory, "20240101_da_expost_lmp.csv"))
            @test isfile(joinpath(directory, "20240102_da_expost_lmp.csv"))
        end
    end

    @testset "get_day_ahead_lmp" begin
        mktempdir() do tempdir
            df = get_day_ahead_lmp(
                ElectricityMarketData.MisoMarket(),
                DateTime("2024-01-01"),
                DateTime("2024-01-02");
                folder = tempdir,
            )
            @test nrow(df) == 115872
            @test ncol(df) == 8
        end
        mktempdir() do tempdir
            df = get_day_ahead_lmp(
                ElectricityMarketData.MisoMarket(),
                DateTime("2021-12-31"),
                DateTime("2022-01-01");
                folder = tempdir,
            )
            @test nrow(df) == 110736
            @test ncol(df) == 8
        end
    end
end
