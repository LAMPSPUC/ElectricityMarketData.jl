@testset "system_io_helper.jl" begin
    @testset "_mkdir" begin
        mktempdir() do tempdir
            dir = "test"
            path = joinpath(tempdir, dir)
            @test _mkdir(path) == path
            @test isdir(path)
            @test _mkdir(path) == path
        end
    end
end
