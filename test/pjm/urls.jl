@testset "pjm/urls.jl" begin
    @testset "get_url_day_ahead_lmp" begin
        start_date = "1/1/2021"
        start_hour_minute = "00:00"
        end_date = "1/2/2021"
        end_hour_minute = "01:00"
        url = ElectricityMarketData.get_url_day_ahead_lmp(
            start_date,
            start_hour_minute,
            end_date,
            end_hour_minute,
        )
        @test url[1:27] == "https://api.pjm.com/api/v1/"
    end
end
