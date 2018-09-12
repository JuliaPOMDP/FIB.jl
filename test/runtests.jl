using FIB
using POMDPs
using POMDPModels
using BeliefUpdaters
using POMDPTesting
using Test

pomdp = BabyPOMDP()
solver = FIBSolver()
policy = solve(solver, pomdp)

#@requirements_info solver pomdp

@testset "all" begin
# test that alpha vectors turn out mostly correct
@testset "alpha vectors" begin
    alphas = Vector{Float64}[]
    push!(alphas, [-29.4557, -19.4557])
    push!(alphas, [-36.5093, -16.0629])
    @test isapprox(policy.alphas, alphas, atol=1e-4)
end

@testset "action value functions" begin
    # create uniform belief (0.5,0.5)
    bu = updater(policy)
    b = uniform_belief(pomdp)

    # check that the action and value functions work
    a = action(policy, b)
    v = value(policy, b)

    @test a
    @test isapprox(v, -24.4557, atol=1e-4)
end

@testset "solver" begin
    test_solver(solver, BabyPOMDP())
    test_solver(solver, TigerPOMDP())
end
end
