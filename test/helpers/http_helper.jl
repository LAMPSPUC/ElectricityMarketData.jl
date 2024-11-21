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

    @testset "_async_download" begin
        mktempdir() do tempdir
            temp_filename = joinpath(tempdir, "20211231_rt_lmp_final.csv")
            temp_filename_zip = joinpath(tempdir, "202112_rt_lmp_final_csv.zip")
            urls = ["https://docs.misoenergy.org/marketreports/20211231_rt_lmp_final.csv"]
            url_zip = "https://docs.misoenergy.org/marketreports/202112_rt_lmp_final_csv.zip"
            tasks = ElectricityMarketData._async_download(
                urls,
                [temp_filename],
                url_zip,
                temp_filename_zip,
            )
            @test length(tasks) == 1
            @test temp_filename == fetch(tasks[1])
            @test isfile(temp_filename)
            @test isfile(temp_filename_zip)
        end
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
