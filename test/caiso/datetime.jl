@testset "caiso/date.jl" begin
    @testset "_get_zdt_formated" begin
        zdt = ZonedDateTime(2023, 5, 4, 7, 2, 13, tz"UTC-3")
        formated = ElectricityMarketData._get_zdt_formated(zdt)
        @test formated == "20230504T07:02-0300"
    end
end
