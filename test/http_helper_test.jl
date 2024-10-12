using HTTP
@testset "http_helper.jl" begin
    @testset "_download" begin
        mktempdir() do tempdir
            temp_filename = joinpath(tempdir, "test.csv")
            url = "https://docs.misoenergy.org/marketreports/20241007_rt_lmp_final.csv"
            ElectricityMarketData._download(url, temp_filename)
            @test isfile(temp_filename)
            @assert filesize(temp_filename) > 0
        end
    end
end
