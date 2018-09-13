module FIB

using POMDPs
using POMDPModelTools
using POMDPPolicies
using Printf

import POMDPs: Solver, Policy, solve

export
    FIBSolver,
    solve

include("vanilla.jl")

end # module
