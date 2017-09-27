using olcamat
using Base.Test


function test_matrixio()
    A = [1.0 2.0 3.0 ;
         4.0 5.0 6.0 ]
    path = joinpath(tempdir(), "_olcamat_jl_test.bin")
    olcamat.write_matrix(A, path)
    B = olcamat.read_matrix(path)
    @test A == B
    c1 = olcamat.read_column(path, 1)
    @test c1 == [1.0, 4.0]
    c2 = olcamat.read_column(path, 2)
    @test c2 == [2.0, 5.0]
    c3 = olcamat.read_column(path, 3)
    @test c3 == [3.0, 6.0]
    rm(path)
    @test isfile(path) == false
end

test_matrixio()
