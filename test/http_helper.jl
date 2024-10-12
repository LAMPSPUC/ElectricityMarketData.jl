@testset "http_helper.jl" begin
    @testset "_download" begin
        mktempdir() do tempdir
            temp_filename = joinpath(tempdir, "test.csv")
            url = "https://docs.misoenergy.org/marketreports/20241007_rt_lmp_final.csv"
            _ = ElectricityMarketData._download(url, temp_filename)
            @test isfile(temp_filename)
            @test filesize(temp_filename) > 0
        end
    end

    @testset "_async_download" begin
        mktempdir() do tempdir
            temp_filename = joinpath(tempdir, "test.csv")
            url = "https://docs.misoenergy.org/marketreports/20241007_rt_lmp_final.csv"
            task = ElectricityMarketData._async_download(url, temp_filename)
            @test temp_filename == fetch(task)
            @test isfile(temp_filename)
            @test filesize(temp_filename) > 0
        end
    end
end
