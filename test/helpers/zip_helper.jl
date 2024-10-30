@testset "zip_helper.jl" begin
    @testset "_unzip" begin
        mktempdir() do tempdir
            zip = ZipFile.Writer("temp.zip")
            ZipFile.addfile(zip, "file1.txt")
            ZipFile.addfile(zip, "file2.txt")
            close(zip)
            _ = ElectricityMarketData._unzip("temp.zip", x -> "test_" * x)
            @test isfile("test_file1.txt")
            @test isfile("test_file2.txt")
        end
    end
end
