using FIB
using POMDPs
using POMDPModels
using POMDPToolbox
using Base.Test

pomdp = BabyPOMDP()
solver = FIBSolver()

@requirements_info solver pomdp

policy = solve(solver, pomdp)

