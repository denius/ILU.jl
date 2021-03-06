using ILU
using Base.Test

@testset "Crout ILU" begin
    let
        # Test if it performs full LU if droptol is zero
        A = sprand(10, 10, .5) + 10I
        ilu = ILU.crout_ilu(A, τ = 0.0)
        lu = lufact(full(A), Val{false})

        @test full(ilu.L + I) ≈ lu[:L]
        @test full(ilu.U.') ≈ lu[:U]
    end

    let
        # Test if L = I and U = diag(A) when the droptol is large.
        A = sprand(10, 10, .5) + 10I
        ilu = ILU.crout_ilu(A, τ = 1.0)

        @test nnz(ilu.L) == 0
        @test nnz(ilu.U) == 10
        @test diag(ilu.U) == diag(A)
    end

end