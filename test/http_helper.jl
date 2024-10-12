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

    @testset "_download_async" begin
        mktempdir() do tempdir
            temp_filename1 = joinpath(tempdir, "test1.csv")
            temp_filename2 = joinpath(tempdir, "test2.csv")
            url1 = "https://docs.misoenergy.org/marketreports/20241007_rt_lmp_final.csv"
            url2 = "https://docs.misoenergy.org/marketreports/20241006_rt_lmp_final.csv"
            tasks = ElectricityMarketData._download_async([url1, url2], [temp_filename1, temp_filename2])
            @test length(tasks) == 2
            wait(tasks[1])
            @test isfile(temp_filename1)
            @test filesize(temp_filename1) > 0
            wait(tasks[2])
            @test isfile(temp_filename2)
            @test filesize(temp_filename2) > 0
        end
    end
end
