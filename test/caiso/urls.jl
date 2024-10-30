@testset "caiso/urls.jl" begin
    @testset "_get_caiso_url" begin
        queryname = "PRC_INTVL_LMP"
        startdate = "20210105T07:00-0000"
        stopdate = "20210106T07:00-0000"
        market_run_id = "RTM"
        url = ElectricityMarketData._get_caiso_url(
            queryname,
            startdate,
            stopdate,
            market_run_id,
        )
        @test url ==
              "http://oasis.caiso.com/oasisapi/SingleZip?resultformat=6&queryname=PRC_INTVL_LMP&version=1&startdatetime=20210105T07:00-0000&enddatetime=20210106T07:00-0000&market_run_id=RTM"
    end
    @testset "_get_caiso_price_url" begin
        startdate = "20230104T07:00-0000"
        stopdate = "20230105T07:00-0000"
        market_run_id = "RTM"
        url = ElectricityMarketData._get_caiso_price_url(startdate, stopdate, market_run_id)
        @test url ==
              "http://oasis.caiso.com/oasisapi/SingleZip?resultformat=6&queryname=PRC_INTVL_LMP&version=1&startdatetime=20230104T07:00-0000&enddatetime=20230105T07:00-0000&market_run_id=RTM"
    end
    @testset "_get_caiso_price_url" begin
        startdate = "20230104T07:00-0000"
        stopdate = "20230105T07:00-0000"
        market_run_id = "DAM"
        url = ElectricityMarketData._get_caiso_price_url(startdate, stopdate, market_run_id)
        @test url ==
              "http://oasis.caiso.com/oasisapi/SingleZip?resultformat=6&queryname=PRC_LMP&version=1&startdatetime=20230104T07:00-0000&enddatetime=20230105T07:00-0000&market_run_id=DAM"
    end
end
