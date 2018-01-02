using FIB
using POMDPs
using POMDPModels
using POMDPToolbox
using Base.Test     # for @test

pomdp = BabyPOMDP()
solver = FIBSolver()

#@requirements_info solver pomdp

# test that alpha vectors turn out mostly correct
policy = solve(solver, pomdp)
alphas = [-29.4557 -36.5093; -19.4557 -16.0629]
@test isapprox(policy.alphas, alphas, atol=1e-4)

# create uniform belief (0.5,0.5)
bu = updater(policy)
b = create_belief(bu)

# check that the action and value functions work
a = action(policy, b)
v = value(policy, b)

@test a
@test isapprox(v, -24.4557, atol=1e-4)

# tests from POMDPToolbox to make sure typical usage works
test_solver(solver, BabyPOMDP())
test_solver(solver, TigerPOMDP())
